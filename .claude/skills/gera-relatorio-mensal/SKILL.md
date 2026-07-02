---
name: gera-relatorio-mensal
description: Gera o relatório mensal (MD + PPTX) a partir de tarefas e incidentes do mês
disable-model-invocation: true
effort: low
---

Gere o relatório mensal. Se $ARGUMENTS contiver um mês no formato YYYY-MM, use-o; senão use o mês atual.

Rode `python scripts/gera-relatorio.py` (ou `python scripts/gera-relatorio.py --mes YYYY-MM` se um mês foi especificado em $ARGUMENTS).

Confirme que o MD foi gerado em `portal/docs/relatorios/` e o PPTX em `reports/`. Mostre os caminhos gerados.

Não crie commit.
