# I3 — Imagens Cobas 6500 II não consumidas — 15/05/2026

- **Data do incidente:** 2026-05-15
- **Data do registro:** 2026-06-25
- **Status:** Registrado
- **Servidor:** SRV-AUTOMA
- **Equipamento:** Cobas 6500 II (urinálise)

## Descrição

Durante análise de disco do SRV-AUTOMA, foram encontradas imagens do dia 15/05/2026 intactas na pasta `D:\Shift\Dados\HOSPBASE\ImagensCobasII`, sem terem sido consumidas pelo Shift Automação.

O comportamento esperado é que as imagens sejam exportadas pelo equipamento, consumidas pelo serviço de automação em segundos e removidas automaticamente após transferência bem-sucedida. A permanência das imagens indica possível falha no fluxo de exportação/consumo nessa data.

## Próximos passos

- [ ] Verificar logs do Shift Automação referentes a 15/05/2026
- [ ] Verificar se os resultados de urinálise dessa data foram integrados corretamente
- [ ] Avaliar se as imagens podem ser removidas manualmente após confirmação
