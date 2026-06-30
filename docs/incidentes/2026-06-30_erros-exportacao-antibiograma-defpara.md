# I5 — Erros de exportação por falta de de/para de antibiogramas

**Data:** 2026-06-30
**Status:** Resolvido
**Sistema:** Shift Integração

## Descrição

17 erros de exportação identificados no Shift LIS causados por falta de configurações de de/para de antimicrobianos no módulo de antibiograma. Os exames com antibióticos sem mapeamento não conseguiam ser enviados ao MV.

## Ações tomadas

- Corrigido de/para da Isoniazida (T137): Shift 635 → MV 231 — erros reduzidos
- Corrigido de/para do Imipenem (T140): Shift IPM4 → MV 215 — erros reduzidos
- Corrigido de/para do IMR (T141): Shift IMR → MV 551 — erros reduzidos
- Corrigido de/para da Rifabutina (T145): Shift RFB → MV 268 — erros reduzidos
- Corrigido de/para da Isoniazida variante (T146): Shift IZ → MV 231 — erros zerados

## Resolução

Após todas as correções de de/para, o número de erros de exportação voltou a **0** em 2026-06-30.
