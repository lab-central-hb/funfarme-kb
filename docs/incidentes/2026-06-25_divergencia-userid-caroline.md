# I2 — Divergência de user-id entre Shift e MV — Caroline

- **Data:** 2026-06-25
- **Status:** Aberto (aguardando desenvolvimento)
- **Usuária:** Caroline (código 6816) — Analista de Microbiologia

## Descrição

O user-id da colaboradora difere entre os sistemas:

| Sistema | User-ID |
|---|---|
| Shift | CAROLINERDS |
| MV | CAROLINE.6913 |

Essa divergência causa falha na integração durante a assinatura de laudos, pois os sistemas tentam se conectar utilizando o user-id e os valores não coincidem.

## Ação

Chamado criado para a equipe de desenvolvimento alterar o user-id da colaboradora diretamente via banco de dados, unificando os identificadores.
