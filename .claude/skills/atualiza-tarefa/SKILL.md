---
name: atualiza-tarefa
description: Atualiza uma tarefa existente em docs/tarefas.md por ID ou descrição
disable-model-invocation: true
effort: low
---

Atualize a tarefa identificada em $ARGUMENTS (ID como "T147" ou descrição).

1. Localize a tarefa em `docs/tarefas.md` (seções Abertas / Em andamento).
2. Atualize a linha com a nova informação, mantendo o formato:
   - `- [ ] T# [SISTEMA] Descrição — *aberta em YYYY-MM-DD*` (aberta)
   - `- [~] T# [SISTEMA] Descrição — *iniciada em YYYY-MM-DD*` (em andamento)
   Se a tarefa está passando de "Aberta" para "Em andamento", mova a linha de seção, troque `[ ]` → `[~]` e "aberta em" → "iniciada em".
3. Após salvar, rode: `python scripts/sync-tarefas.py` e `python scripts/sync-landing.py`.
4. Mostre um resumo do que foi alterado.

Não crie commit. Não crie tarefas novas com este comando — apenas atualize existentes.
