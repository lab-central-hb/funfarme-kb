"""
sync-tarefas.py — Sincroniza docs/tarefas.md → portal/docs/tarefas/

Lê o backlog de tarefas e gera as páginas do portal MkDocs:
  - portal/docs/tarefas/index.md  (abertas + em andamento + histórico)
  - portal/docs/tarefas/YYYY-MM.md (concluídas por mês/semana)
  - Atualiza portal/mkdocs.yml nav se necessário
"""

import re
import os
from datetime import datetime, timedelta
from collections import defaultdict
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
TAREFAS_SRC = ROOT / "docs" / "tarefas.md"
PORTAL_TAREFAS = ROOT / "portal" / "docs" / "tarefas"
MKDOCS_YML = ROOT / "portal" / "mkdocs.yml"

MESES_PT = {
    1: "Janeiro", 2: "Fevereiro", 3: "Março", 4: "Abril",
    5: "Maio", 6: "Junho", 7: "Julho", 8: "Agosto",
    9: "Setembro", 10: "Outubro", 11: "Novembro", 12: "Dezembro",
}

CATEGORY_MAP = {
    "Shift LIS": None,
    "Shift Automação": "Automação",
    "Shift Integração": "Integração",
    "Municípios": "Municípios",
    "Rede/Servidores": "Servidor",
    "Equip. Laboratoriais": "Equipamento",
    "Equip./Dispositivos": "Equipamento",
    "Equipamentos": "Equipamento",
}


def parse_tarefas(text):
    abertas = []
    em_andamento = []
    concluidas = []

    section = None
    current_month = None

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
        elif stripped.startswith("### ") and section == "concluidas":
            continue
        elif stripped.startswith("#### ") and section == "concluidas":
            continue

        if not stripped.startswith("- ["):
            continue

        task = parse_task_line(stripped)
        if not task:
            continue

        if section == "abertas":
            if task["status"] == "done":
                continue
            abertas.append(task)
        elif section == "em_andamento":
            em_andamento.append(task)
        elif section == "concluidas":
            concluidas.append(task)

    return abertas, em_andamento, concluidas


def parse_task_line(line):
    checkbox_match = re.match(r"- \[(.)\] ", line)
    if not checkbox_match:
        return None

    mark = checkbox_match.group(1)
    status = {"x": "done", "~": "in_progress", " ": "open"}.get(mark, "open")
    rest = line[len(checkbox_match.group(0)):]

    cat_match = re.match(r"\[([^\]]+)\]\s*", rest)
    category = "Shift LIS"
    if cat_match:
        category = cat_match.group(1)
        rest = rest[len(cat_match.group(0)):]

    date = None
    date_match = re.search(r"\*(?:concluída|iniciada|aberta) em (\d{4}-\d{2}-\d{2})\*", rest)
    if date_match:
        date = date_match.group(1)

    schedule = None
    sched_match = re.search(r"\(agendado para ([^)]+)\)", rest)
    if sched_match:
        schedule = sched_match.group(1)

    desc = rest
    desc = re.sub(r"\s*—\s*\*(?:concluída|iniciada|aberta) em \d{4}-\d{2}-\d{2}\*", "", desc)
    desc = re.sub(r"\s*\(agendado para [^)]+\)", "", desc)
    desc = re.sub(r"\s*\(resp\. [^)]+\)", "", desc)
    desc = desc.strip().rstrip(" —").strip()

    return {
        "status": status,
        "category": category,
        "description": desc,
        "date": date,
        "schedule": schedule,
        "raw": line,
    }


def get_week_number(date_str, year, month):
    dt = datetime.strptime(date_str, "%Y-%m-%d")
    first_day = datetime(year, month, 1)
    first_monday = first_day + timedelta(days=(7 - first_day.weekday()) % 7)
    if first_monday.day > 7:
        first_monday -= timedelta(days=7)

    if dt < first_monday:
        return 1

    week = ((dt - first_monday).days // 7) + 1
    return max(1, week)


def get_week_range(year, month, week_num):
    first_day = datetime(year, month, 1)
    first_monday = first_day + timedelta(days=(7 - first_day.weekday()) % 7)
    if first_monday.day > 7:
        first_monday -= timedelta(days=7)

    week_start = first_monday + timedelta(weeks=week_num - 1)
    week_end = week_start + timedelta(days=4)

    if week_start.month != month:
        week_start = datetime(year, month, 1)
    if month == 12:
        last_day = datetime(year + 1, 1, 1) - timedelta(days=1)
    else:
        last_day = datetime(year, month + 1, 1) - timedelta(days=1)
    if week_end > last_day:
        week_end = last_day

    return f"{week_start.day:02d}/{week_start.month:02d}", f"{week_end.day:02d}/{week_end.month:02d}"


def format_portal_task(task):
    cat = task["category"]
    portal_cat = CATEGORY_MAP.get(cat, cat)
    desc = task["description"]

    if task["date"]:
        dt = datetime.strptime(task["date"], "%Y-%m-%d")
        date_str = f"{dt.day:02d}/{dt.month:02d}"
    else:
        date_str = ""

    if portal_cat and portal_cat != "Shift LIS":
        return f"- [x] **[{portal_cat}]** {desc} — *concluída em {date_str}*"
    else:
        return f"- [x] {desc} — *concluída em {date_str}*"


def generate_month_page(year, month, tasks):
    month_name = MESES_PT[month]
    lines = [f"# {month_name} {year}", ""]

    weeks = defaultdict(list)
    for t in sorted(tasks, key=lambda x: x["date"] or ""):
        if t["date"]:
            wn = get_week_number(t["date"], year, month)
            weeks[wn].append(t)
        else:
            weeks[1].append(t)

    for wn in sorted(weeks.keys()):
        start, end = get_week_range(year, month, wn)
        lines.append(f"## Semana {wn} ({start}–{end})")
        lines.append("")
        for t in weeks[wn]:
            lines.append(format_portal_task(t))
        lines.append("")

    return "\n".join(lines).rstrip() + "\n"


def generate_index(abertas, em_andamento, months_summary):
    lines = [
        "# Tarefas",
        "",
        "Backlog de atividades da equipe de TI do laboratório.",
        "",
        "## Abertas",
        "",
    ]

    for t in abertas:
        desc = t["description"]
        cat = t["category"]
        sched = f" — <span class=\"status-agendada\">agendado para {t['schedule']}</span>" if t["schedule"] else ""
        date_info = f" — *aberta em {t['date'][8:10]}/{t['date'][5:7]}*" if t.get("date") else ""
        lines.append(f"- [ ] **[{cat}]** {desc}{sched}{date_info}")

    lines.extend(["", "## Em Andamento", ""])

    for t in em_andamento:
        desc = t["description"]
        cat = t["category"]
        date_info = f" — *iniciada em {t['date'][8:10]}/{t['date'][5:7]}*" if t.get("date") else ""
        lines.append(f"- [x] **[{cat}]** {desc}{date_info}")

    lines.extend(["", "## Histórico por Mês", ""])

    lines.append("| Mês | Concluídas |")
    lines.append("|-----|-----------|")
    for ym, count in months_summary:
        year, month = ym
        month_name = MESES_PT[month]
        lines.append(f"| [{month_name} {year}]({year}-{month:02d}.md) | {count} |")

    lines.append("")
    return "\n".join(lines).rstrip() + "\n"


def update_mkdocs_nav(months):
    content = MKDOCS_YML.read_text(encoding="utf-8")

    tarefas_start = content.find("  - Tarefas:")
    if tarefas_start == -1:
        return

    next_section = content.find("\n  - ", tarefas_start + 1)
    if next_section == -1:
        next_section = len(content)

    nav_lines = ["  - Tarefas:"]
    nav_lines.append("    - tarefas/index.md")
    for (year, month) in months:
        month_name = MESES_PT[month]
        nav_lines.append(f'    - "{month_name} {year}": tarefas/{year}-{month:02d}.md')

    new_section = "\n".join(nav_lines)
    new_content = content[:tarefas_start] + new_section + content[next_section:]

    if new_content != content:
        MKDOCS_YML.write_text(new_content, encoding="utf-8")
        print(f"  Atualizado: {MKDOCS_YML.name}")


def main():
    if not TAREFAS_SRC.exists():
        print(f"Erro: {TAREFAS_SRC} não encontrado")
        return

    text = TAREFAS_SRC.read_text(encoding="utf-8")
    abertas, em_andamento, concluidas = parse_tarefas(text)

    by_month = defaultdict(list)
    for t in concluidas:
        if t["date"]:
            dt = datetime.strptime(t["date"], "%Y-%m-%d")
            by_month[(dt.year, dt.month)].append(t)

    PORTAL_TAREFAS.mkdir(parents=True, exist_ok=True)

    sorted_months = sorted(by_month.keys(), reverse=True)

    for (year, month), tasks in by_month.items():
        page = generate_month_page(year, month, tasks)
        out = PORTAL_TAREFAS / f"{year}-{month:02d}.md"
        out.write_text(page, encoding="utf-8")
        print(f"  Gerado: {out.name} ({len(tasks)} tarefas)")

    months_summary = [(ym, len(by_month[ym])) for ym in sorted_months]
    index = generate_index(abertas, em_andamento, months_summary)
    index_path = PORTAL_TAREFAS / "index.md"
    index_path.write_text(index, encoding="utf-8")
    print(f"  Gerado: index.md")

    update_mkdocs_nav(sorted_months)

    total = sum(len(v) for v in by_month.values())
    print(f"\nSync concluído: {len(abertas)} abertas, {len(em_andamento)} em andamento, {total} concluídas em {len(by_month)} meses")


if __name__ == "__main__":
    main()
