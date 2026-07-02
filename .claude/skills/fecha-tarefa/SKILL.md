---
name: fecha-tarefa
description: Marca uma tarefa como concluída em docs/tarefas.md
disable-model-invocation: true
effort: low
---

Feche a tarefa identificada em $ARGUMENTS (ID como "T147" ou descrição).

1. Localize a tarefa em `docs/tarefas.md`.
2. Mova para a seção "Concluídas (mês atual)", na semana correspondente à data de hoje, no formato:
   `- [x] T# [SISTEMA] Descrição — *concluída em YYYY-MM-DD*`
3. Rode: `python scripts/sync-tarefas.py` e `python scripts/sync-landing.py`.
4. Mostre um resumo do que foi alterado.

Não crie commit.
