"""
gera-relatorio.py — Gera relatório mensal de atividades

Lê docs/tarefas.md + docs/incidentes/ e gera:
  - portal/docs/relatorios/YYYY-MM.md  (versão web)
  - reports/YYYY-MM_resumo-mensal.pptx (apresentação)
  - Atualiza portal/docs/relatorios/index.md
  - Atualiza contadores no portal/docs/index.md

Uso: python scripts/gera-relatorio.py [--mes YYYY-MM]
"""

import argparse
import re
import os
from datetime import datetime
from collections import defaultdict, Counter
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
TAREFAS_SRC = ROOT / "docs" / "tarefas.md"
INCIDENTES_DIR = ROOT / "docs" / "incidentes"
PORTAL_RELATORIOS = ROOT / "portal" / "docs" / "relatorios"
PORTAL_INDEX = ROOT / "portal" / "docs" / "index.md"
REPORTS_DIR = ROOT / "reports"
MKDOCS_YML = ROOT / "portal" / "mkdocs.yml"

MESES_PT = {
    1: "Janeiro", 2: "Fevereiro", 3: "Março", 4: "Abril",
    5: "Maio", 6: "Junho", 7: "Julho", 8: "Agosto",
    9: "Setembro", 10: "Outubro", 11: "Novembro", 12: "Dezembro",
}


def parse_tasks_for_month(text, year, month):
    concluidas = []
    abertas_andamento = []
    in_concluidas = False

    for line in text.splitlines():
        stripped = line.strip()

        if stripped.startswith("## Abertas") or stripped.startswith("## Em andamento"):
            in_concluidas = False
        elif stripped.startswith("## Concluídas"):
            in_concluidas = True

        if not stripped.startswith("- ["):
            continue

        task = parse_task(stripped)
        if not task:
            continue

        if in_concluidas and task["date"]:
            dt = datetime.strptime(task["date"], "%Y-%m-%d")
            if dt.year == year and dt.month == month:
                concluidas.append(task)
        elif not in_concluidas:
            if task["status"] in ("open", "in_progress"):
                abertas_andamento.append(task)

    return concluidas, abertas_andamento


def parse_task(line):
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
    }


def get_week_number(date_str, month):
    dt = datetime.strptime(date_str, "%Y-%m-%d")
    first = datetime(dt.year, month, 1)
    return ((dt.day - 1) // 7) + 1


def get_week_range(year, month, week_num):
    start_day = (week_num - 1) * 7 + 1
    end_day = min(start_day + 6, 28 if month == 2 else 30 if month in (4, 6, 9, 11) else 31)
    try:
        datetime(year, month, end_day)
    except ValueError:
        end_day = 28 if month == 2 else 30
    return f"{start_day:02d}/{month:02d}", f"{end_day:02d}/{month:02d}"


def find_incidents(year, month):
    incidents = []
    if not INCIDENTES_DIR.exists():
        return incidents
    prefix = f"{year}-{month:02d}"
    for f in sorted(INCIDENTES_DIR.iterdir()):
        if f.name.startswith(prefix) and f.suffix == ".md":
            content = f.read_text(encoding="utf-8")
            title_match = re.search(r"^#\s+(.+)$", content, re.MULTILINE)
            title = title_match.group(1) if title_match else f.stem
            incidents.append({"file": f.name, "title": title, "date": f.name[:10]})
    return incidents


def generate_md_report(year, month, concluidas, pendentes, incidents):
    month_name = MESES_PT[month]
    today = datetime.now()
    is_current = (year == today.year and month == today.month)
    period_end = f"{today.day:02d}/{month:02d}" if is_current else f"{28 if month == 2 else 30 if month in (4,6,9,11) else 31}/{month:02d}"
    status_note = " (parcial — mês em andamento)" if is_current else ""

    lines = [
        f"# Resumo Mensal — {month_name} {year}",
        "",
        f"**Período:** 01/{month:02d} a {period_end}{status_note}",
        "",
        "---",
        "",
        f"## Tarefas concluídas: {len(concluidas)}",
        "",
        "| # | Categoria | Descrição | Data |",
        "|---|-----------|-----------|------|",
    ]

    for i, t in enumerate(sorted(concluidas, key=lambda x: x["date"]), 1):
        dt = datetime.strptime(t["date"], "%Y-%m-%d")
        lines.append(f"| {i} | {t['category']} | {t['description']} | {dt.day:02d}/{dt.month:02d} |")

    cat_counts = Counter(t["category"] for t in concluidas)
    lines.extend([
        "",
        "## Por categoria",
        "",
        "| Categoria | Qtd |",
        "|-----------|-----|",
    ])
    for cat, count in cat_counts.most_common():
        lines.append(f"| {cat} | {count} |")
    lines.append(f"| **Total** | **{len(concluidas)}** |")

    weeks = defaultdict(int)
    for t in concluidas:
        wn = get_week_number(t["date"], month)
        weeks[wn] += 1

    lines.extend([
        "",
        "## Distribuição semanal",
        "",
        "| Semana | Concluídas |",
        "|--------|-----------|",
    ])
    for wn in sorted(weeks.keys()):
        start, end = get_week_range(year, month, wn)
        lines.append(f"| Semana {wn} ({start}–{end}) | {weeks[wn]} |")

    if pendentes:
        lines.extend(["", "## Tarefas em andamento / pendentes", ""])
        for t in pendentes:
            lines.append(f"- {t['description']} — {t['category']}")

    lines.extend(["", "## Incidentes registrados", ""])
    if incidents:
        for inc in incidents:
            lines.append(f"- **{inc['date']}** — {inc['title']}")
    else:
        lines.append(f"Nenhum incidente registrado em {month_name.lower()}.")

    lines.append("")
    return "\n".join(lines)


def generate_pptx(year, month, concluidas, pendentes, incidents):
    from pptx import Presentation
    from pptx.util import Inches, Pt
    from pptx.enum.text import PP_ALIGN

    prs = Presentation()
    prs.slide_width = Inches(13.333)
    prs.slide_height = Inches(7.5)

    month_name = MESES_PT[month]

    # --- Slide 1: Capa ---
    slide = prs.slides.add_slide(prs.slide_layouts[6])  # blank
    txBox = slide.shapes.add_textbox(Inches(1), Inches(2.5), Inches(11), Inches(2))
    tf = txBox.text_frame
    p = tf.paragraphs[0]
    p.text = f"Resumo Mensal — {month_name} {year}"
    p.font.size = Pt(36)
    p.font.bold = True
    p.alignment = PP_ALIGN.CENTER
    p2 = tf.add_paragraph()
    p2.text = "TI Laboratório — FUNFARME"
    p2.font.size = Pt(20)
    p2.alignment = PP_ALIGN.CENTER
    p3 = tf.add_paragraph()
    p3.text = f"\n{len(concluidas)} tarefas concluídas"
    p3.font.size = Pt(18)
    p3.alignment = PP_ALIGN.CENTER

    # --- Slide 2: Resumo por categoria ---
    slide = prs.slides.add_slide(prs.slide_layouts[6])
    title_box = slide.shapes.add_textbox(Inches(0.5), Inches(0.3), Inches(12), Inches(0.8))
    tf = title_box.text_frame
    p = tf.paragraphs[0]
    p.text = "Resumo por Categoria"
    p.font.size = Pt(28)
    p.font.bold = True

    cat_counts = Counter(t["category"] for t in concluidas)
    y = Inches(1.3)
    for cat, count in cat_counts.most_common():
        box = slide.shapes.add_textbox(Inches(1), y, Inches(10), Inches(0.45))
        tf = box.text_frame
        p = tf.paragraphs[0]
        p.text = f"{cat}: {count} tarefa{'s' if count > 1 else ''}"
        p.font.size = Pt(18)
        y += Inches(0.5)

    total_box = slide.shapes.add_textbox(Inches(1), y + Inches(0.2), Inches(10), Inches(0.5))
    tf = total_box.text_frame
    p = tf.paragraphs[0]
    p.text = f"Total: {len(concluidas)}"
    p.font.size = Pt(20)
    p.font.bold = True

    # --- Slides por categoria ---
    for cat, count in cat_counts.most_common():
        cat_tasks = [t for t in concluidas if t["category"] == cat]
        slide = prs.slides.add_slide(prs.slide_layouts[6])

        title_box = slide.shapes.add_textbox(Inches(0.5), Inches(0.3), Inches(12), Inches(0.8))
        tf = title_box.text_frame
        p = tf.paragraphs[0]
        p.text = f"{cat} ({count})"
        p.font.size = Pt(24)
        p.font.bold = True

        content_box = slide.shapes.add_textbox(Inches(0.8), Inches(1.3), Inches(11), Inches(5.5))
        tf = content_box.text_frame
        tf.word_wrap = True

        for i, t in enumerate(sorted(cat_tasks, key=lambda x: x["date"])):
            dt = datetime.strptime(t["date"], "%Y-%m-%d")
            p = tf.paragraphs[0] if i == 0 else tf.add_paragraph()
            p.text = f"• {t['description']} ({dt.day:02d}/{dt.month:02d})"
            p.font.size = Pt(14)
            p.space_after = Pt(4)

    # --- Slide: Pendências ---
    if pendentes:
        slide = prs.slides.add_slide(prs.slide_layouts[6])
        title_box = slide.shapes.add_textbox(Inches(0.5), Inches(0.3), Inches(12), Inches(0.8))
        tf = title_box.text_frame
        p = tf.paragraphs[0]
        p.text = "Pendências"
        p.font.size = Pt(24)
        p.font.bold = True

        content_box = slide.shapes.add_textbox(Inches(0.8), Inches(1.3), Inches(11), Inches(5.5))
        tf = content_box.text_frame
        tf.word_wrap = True

        for i, t in enumerate(pendentes):
            p = tf.paragraphs[0] if i == 0 else tf.add_paragraph()
            p.text = f"• [{t['category']}] {t['description']}"
            p.font.size = Pt(14)
            p.space_after = Pt(4)

    # --- Slide: Incidentes ---
    if incidents:
        slide = prs.slides.add_slide(prs.slide_layouts[6])
        title_box = slide.shapes.add_textbox(Inches(0.5), Inches(0.3), Inches(12), Inches(0.8))
        tf = title_box.text_frame
        p = tf.paragraphs[0]
        p.text = "Incidentes"
        p.font.size = Pt(24)
        p.font.bold = True

        content_box = slide.shapes.add_textbox(Inches(0.8), Inches(1.3), Inches(11), Inches(5.5))
        tf = content_box.text_frame
        tf.word_wrap = True

        for i, inc in enumerate(incidents):
            p = tf.paragraphs[0] if i == 0 else tf.add_paragraph()
            p.text = f"• {inc['date']} — {inc['title']}"
            p.font.size = Pt(14)
            p.space_after = Pt(4)

    return prs


def update_relatorios_index(year, month):
    index_path = PORTAL_RELATORIOS / "index.md"
    if not index_path.exists():
        return

    content = index_path.read_text(encoding="utf-8")
    month_name = MESES_PT[month]
    entry = f"{year}-{month:02d}"

    if entry in content:
        return

    today = datetime.now()
    is_current = (year == today.year and month == today.month)
    status = ":material-clock-outline: Parcial (mês em andamento)" if is_current else ":material-check-circle: Completo"

    new_row = f"| [{month_name} {year}]({entry}.md) | {status} |"

    table_end = content.rfind("|")
    if table_end != -1:
        line_end = content.find("\n", table_end)
        if line_end == -1:
            line_end = len(content)
        content = content[:line_end] + "\n" + new_row + content[line_end:]

    index_path.write_text(content, encoding="utf-8")
    print(f"  Atualizado: relatorios/index.md")


def update_portal_index(concluidas_count, month_name):
    if not PORTAL_INDEX.exists():
        return

    content = PORTAL_INDEX.read_text(encoding="utf-8")

    content = re.sub(
        r'(Concluídas em \w+\s*\|\s*)\d+',
        f"Concluídas em {month_name.lower()} | {concluidas_count}",
        content
    )

    today = datetime.now()
    content = re.sub(
        r'Atualizado em \d{2}/\d{2}/\d{4}',
        f"Atualizado em {today.day:02d}/{today.month:02d}/{today.year}",
        content
    )

    PORTAL_INDEX.write_text(content, encoding="utf-8")
    print(f"  Atualizado: portal index.md")


def update_mkdocs_nav(year, month):
    content = MKDOCS_YML.read_text(encoding="utf-8")
    month_name = MESES_PT[month]
    entry = f'"{month_name} {year}": relatorios/{year}-{month:02d}.md'

    if entry in content:
        return

    relatorios_start = content.find("  - Relatórios:")
    if relatorios_start == -1:
        return

    next_section = content.find("\n  - ", relatorios_start + 1)
    if next_section == -1:
        next_section = len(content)

    insert_pos = content.find("\n", content.find("relatorios/index.md", relatorios_start))
    if insert_pos == -1 or insert_pos > next_section:
        return

    new_line = f'\n    - "{month_name} {year}": relatorios/{year}-{month:02d}.md'
    content = content[:insert_pos] + new_line + content[insert_pos:]

    MKDOCS_YML.write_text(content, encoding="utf-8")
    print(f"  Atualizado: mkdocs.yml nav (relatórios)")


def main():
    parser = argparse.ArgumentParser(description="Gera relatório mensal")
    parser.add_argument("--mes", type=str, default=None, help="Mês no formato YYYY-MM (padrão: mês atual)")
    args = parser.parse_args()

    if args.mes:
        year, month = map(int, args.mes.split("-"))
    else:
        today = datetime.now()
        year, month = today.year, today.month

    month_name = MESES_PT[month]
    print(f"Gerando relatório: {month_name} {year}")

    if not TAREFAS_SRC.exists():
        print(f"Erro: {TAREFAS_SRC} não encontrado")
        return

    text = TAREFAS_SRC.read_text(encoding="utf-8")
    concluidas, pendentes = parse_tasks_for_month(text, year, month)
    incidents = find_incidents(year, month)

    print(f"  {len(concluidas)} tarefas concluídas, {len(pendentes)} pendentes, {len(incidents)} incidentes")

    # Gera MD para portal
    PORTAL_RELATORIOS.mkdir(parents=True, exist_ok=True)
    md_content = generate_md_report(year, month, concluidas, pendentes, incidents)
    md_path = PORTAL_RELATORIOS / f"{year}-{month:02d}.md"
    md_path.write_text(md_content, encoding="utf-8")
    print(f"  Gerado: {md_path.relative_to(ROOT)}")

    # Gera PPTX para reports/
    REPORTS_DIR.mkdir(parents=True, exist_ok=True)
    pptx = generate_pptx(year, month, concluidas, pendentes, incidents)
    pptx_path = REPORTS_DIR / f"{year}-{month:02d}_resumo-mensal.pptx"
    pptx.save(str(pptx_path))
    print(f"  Gerado: {pptx_path.relative_to(ROOT)}")

    # Atualiza índices
    update_relatorios_index(year, month)
    update_portal_index(len(concluidas), month_name)
    update_mkdocs_nav(year, month)

    print(f"\nRelatório de {month_name} {year} concluído.")


if __name__ == "__main__":
    main()
