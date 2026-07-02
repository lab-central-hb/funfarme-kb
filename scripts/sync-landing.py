"""
sync-landing.py — Atualiza o painel de status da landing page do portal

Lê docs/tarefas.md + docs/incidentes/index.md e regenera as seções
marcadas com BEGIN/END no portal/docs/index.md.

Uso: python scripts/sync-landing.py
"""

import re
from datetime import datetime
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
TAREFAS_SRC = ROOT / "docs" / "tarefas.md"
INCIDENTES_SRC = ROOT / "docs" / "incidentes" / "index.md"
LANDING = ROOT / "portal" / "docs" / "index.md"

STATUS_COLORS = {
    "Aberto": "aberta",
    "Em análise": "andamento",
    "Registrado": "concluida",
    "Resolvido": "concluida",
}


def parse_tarefas(text):
    abertas = []
    em_andamento = []
    concluidas_mes = 0

    section = None
    today = datetime.now()

    for line in text.splitlines():
        stripped = line.strip()

        if stripped.startswith("## Abertas"):
            section = "abertas"
            continue
        elif stripped.startswith("## Em andamento"):
            section = "em_andamento"
            continue
        elif stripped.startswith("## Concluídas"):
            section = "concluidas"
            continue

        if not stripped.startswith("- ["):
            continue

        checkbox = re.match(r"- \[(.)\] ", stripped)
        if not checkbox:
            continue

        mark = checkbox.group(1)
        rest = stripped[len(checkbox.group(0)):]

        task_id = ""
        id_m = re.match(r"(T\d+)\s+", rest)
        if id_m:
            task_id = id_m.group(1)
            rest = rest[len(id_m.group(0)):]

        cat = "Shift LIS"
        cat_m = re.match(r"\[([^\]]+)\]\s*", rest)
        if cat_m:
            cat = cat_m.group(1)
            rest = rest[len(cat_m.group(0)):]

        date = None
        date_m = re.search(r"\*(?:concluída|iniciada|aberta) em (\d{4}-\d{2}-\d{2})\*", rest)
        if date_m:
            date = date_m.group(1)

        desc = rest
        desc = re.sub(r"\s*—\s*\*(?:concluída|iniciada|aberta) em \d{4}-\d{2}-\d{2}\*", "", desc)
        desc = re.sub(r"\s*\(agendado para [^)]+\)", "", desc)
        desc = re.sub(r"\s*\(resp\. [^)]+\)", "", desc)
        desc = desc.strip().rstrip(" —").strip()

        task = {"id": task_id, "cat": cat, "desc": desc, "date": date}

        if section == "abertas" and mark == " ":
            abertas.append(task)
        elif section == "em_andamento" and mark == "~":
            em_andamento.append(task)
        elif section == "concluidas" and mark == "x" and date:
            dt = datetime.strptime(date, "%Y-%m-%d")
            if dt.year == today.year and dt.month == today.month:
                concluidas_mes += 1

    return abertas, em_andamento, concluidas_mes


def parse_incidentes(text):
    incidents = []
    for line in text.splitlines():
        m = re.match(r"\|\s*(I\d+)\s*\|\s*(\S+)\s*\|\s*\[([^\]]+)\]", line)
        if m:
            status_m = re.search(r"\|\s*([^|]+?)\s*\|?\s*$", line)
            status = status_m.group(1).strip() if status_m else ""
            incidents.append({
                "id": m.group(1),
                "date": m.group(2),
                "title": m.group(3),
                "status": status,
            })
    return incidents


def fmt_date(iso_date):
    if not iso_date:
        return ""
    dt = datetime.strptime(iso_date, "%Y-%m-%d")
    return f"{dt.day:02d}/{dt.month:02d}"


def generate_status(abertas, em_andamento, concluidas_mes, incidents):
    today = datetime.now()
    from collections import defaultdict
    meses_pt = {1:"janeiro",2:"fevereiro",3:"março",4:"abril",5:"maio",6:"junho",
                7:"julho",8:"agosto",9:"setembro",10:"outubro",11:"novembro",12:"dezembro"}
    mes = meses_pt[today.month]

    open_incidents = sum(1 for i in incidents if i["status"] not in ("Resolvido", "Registrado"))

    lines = [
        f'!!! info "Atualizado em {today.day:02d}/{today.month:02d}/{today.year}"',
        "",
        "    | Indicador | Valor |",
        "    |-----------|-------|",
        f"    | Tarefas abertas | {len(abertas)} |",
        f"    | Em andamento | {len(em_andamento)} |",
        f"    | Concluídas em {mes} | {concluidas_mes} |",
        f"    | Incidentes abertos | {open_incidents} |",
    ]
    return "\n".join(lines)


def generate_tarefas(abertas, em_andamento):
    lines = [
        "| ID | Sistema | Descrição | Desde |",
        "|----|---------|-----------|-------|",
    ]
    for t in abertas:
        lines.append(f"| {t['id']} | {t['cat']} | {t['desc']} | {fmt_date(t['date'])} |")

    if em_andamento:
        lines.append("")
        lines.append("**Em andamento:**")
        lines.append("")
        lines.append("| ID | Sistema | Descrição | Desde |")
        lines.append("|----|---------|-----------|-------|")
        for t in em_andamento:
            lines.append(f"| {t['id']} | {t['cat']} | {t['desc']} | {fmt_date(t['date'])} |")

    return "\n".join(lines)


def generate_incidentes(incidents):
    lines = [
        "| ID | Data | Título | Status |",
        "|----|------|--------|--------|",
    ]
    for i in incidents:
        dt = i["date"]
        if len(dt) == 10:
            d = datetime.strptime(dt, "%Y-%m-%d")
            dt = f"{d.day:02d}/{d.month:02d}"
        status = i["status"]
        css = STATUS_COLORS.get(status, "")
        if css:
            status = f'<span class="status-{css}">{status}</span>'
        lines.append(f"| {i['id']} | {dt} | {i['title']} | {status} |")
    return "\n".join(lines)


def replace_section(content, tag, new_content):
    pattern = re.compile(
        rf"(<!-- BEGIN_{tag} -->\n).*?(<!-- END_{tag} -->)",
        re.DOTALL,
    )
    return pattern.sub(rf"\g<1>{new_content}\n\2", content)


def check_duplicate_ids(items):
    from collections import Counter
    counts = Counter(i["id"] for i in items if i.get("id"))
    return sorted(iid for iid, c in counts.items() if c > 1)


def main():
    tarefas_text = TAREFAS_SRC.read_text(encoding="utf-8")
    abertas, em_andamento, concluidas_mes = parse_tarefas(tarefas_text)

    incidents = []
    if INCIDENTES_SRC.exists():
        incidents = parse_incidentes(INCIDENTES_SRC.read_text(encoding="utf-8"))

    dup_tarefas = check_duplicate_ids(abertas + em_andamento)
    dup_incidentes = check_duplicate_ids(incidents)

    landing = LANDING.read_text(encoding="utf-8")

    landing = replace_section(landing, "STATUS", generate_status(abertas, em_andamento, concluidas_mes, incidents))
    landing = replace_section(landing, "TAREFAS", generate_tarefas(abertas, em_andamento))
    landing = replace_section(landing, "INCIDENTES", generate_incidentes(incidents))

    LANDING.write_text(landing, encoding="utf-8")
    print(f"Landing page atualizada: {len(abertas)} abertas, {len(em_andamento)} em andamento, {concluidas_mes} concluídas no mês, {len(incidents)} incidentes")

    if dup_tarefas or dup_incidentes:
        if dup_tarefas:
            print(f"\n⚠️  AVISO: ID(s) de tarefa duplicado(s): {', '.join(dup_tarefas)}")
        if dup_incidentes:
            print(f"⚠️  AVISO: ID(s) de incidente duplicado(s): {', '.join(dup_incidentes)}")
        print("Renumere o(s) item(ns) duplicado(s) antes de commitar.\n")
        raise SystemExit(1)


if __name__ == "__main__":
    main()
