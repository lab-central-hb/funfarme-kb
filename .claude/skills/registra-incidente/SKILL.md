---
name: registra-incidente
description: Registra um novo incidente de TI em docs/incidentes/ com ID automático (I#)
disable-model-invocation: true
effort: low
---

Registre um novo incidente de TI a partir da descrição em $ARGUMENTS.

1. Leia `docs/incidentes/index.md` e pegue o próximo ID no comentário `<!-- próximo ID: I# -->`.
2. Crie `docs/incidentes/YYYY-MM-DD_titulo-curto.md` (data de hoje) no formato:

   ```
   # I# — Título

   **Data:** YYYY-MM-DD
   **Status:** Registrado
   **Sistema:** [sistema envolvido]

   ## Descrição

   [descrição do incidente]

   ## Ações tomadas

   - [ações, se houver]

   ## Resolução

   [deixar em branco se ainda não resolvido]
   ```

3. Adicione uma linha na tabela de `docs/incidentes/index.md` (ID, data, título linkado ao arquivo, status).
4. Incremente o comentário `<!-- próximo ID: I# -->`.
5. Mostre um resumo do que foi criado.

Não crie commit. Nunca grave IPs, senhas ou credenciais — isso vai exclusivamente em `docs/credenciais.md`.
