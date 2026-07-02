---
name: registra-conhecimento
description: Salva conhecimento sobre o ambiente (equipamentos, servidores, fluxos, comportamentos de sistema) na memória e, se aplicável, em docs/procedimentos
disable-model-invocation: true
effort: low
---

Registre o conhecimento descrito em $ARGUMENTS sobre o ambiente FUNFARME.

1. Salve a informação relevante na memória persistente.
2. Se for um procedimento, comportamento de sistema ou solução reutilizável, crie/atualize um arquivo em:
   - `portal/docs/procedimentos/` — informação não-sensível, útil para o portal público
   - `docs/procedimentos/` — informação interna
3. Mostre o conteúdo criado/alterado.

Nunca grave IPs, senhas, ramais ou credenciais aqui — isso vai exclusivamente em `docs/credenciais.md`, ao qual este usuário não tem acesso. Não crie commit.
