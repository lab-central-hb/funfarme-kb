# I2 — Divergência de user-id entre Shift e MV — Caroline

- **Data:** 2026-06-25
- **Resolução:** 2026-06-25
- **Status:** Resolvido
- **Usuária:** Caroline (código 6816) — Analista de Microbiologia

## Descrição

O user-id da colaboradora diferia entre os sistemas:

| Sistema | User-ID |
|---|---|
| Shift | CAROLINERDS |
| MV | CAROLINE.6913 |

Essa divergência causava falha na integração durante a assinatura de laudos, pois os sistemas tentam se conectar utilizando o user-id e os valores não coincidiam.

## Ação

Chamado criado para a equipe de desenvolvimento alterar o user-id da colaboradora diretamente via banco de dados, unificando os identificadores.

## Resolução

User-id alterado pela equipe de desenvolvimento. Assinatura de laudos testada e funcionando corretamente.
