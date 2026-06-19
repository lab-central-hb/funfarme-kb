# Shift Automação

O módulo de Automação é responsável pelo **interfaceamento** entre os equipamentos laboratoriais e o Shift LIS.

## Função

- Recebe resultados dos equipamentos via protocolo de comunicação (serial, TCP/IP)
- Mapeia os parâmetros do equipamento para os exames configurados no LIS
- Realiza pré-validação de resultados (delta check, limites)
- Encaminha resultados validados ao Shift LIS

## Serviço

O interfaceamento é operado pelo serviço **CachéITF**, hospedado no servidor de automação (SRV-AUTOMA).

Cada equipamento possui uma configuração específica:

- Porta de comunicação
- Protocolo (varia por fabricante/modelo)
- Mapeamento de exames (códigos do equipamento → códigos do LIS)
- Regras de importação (quais parâmetros aceitar, quais ignorar)

## Equipamentos Interfaceados

Consulte a lista completa na página [Equipamentos](../infraestrutura/equipamentos.md).

## Atividades Comuns

- Configuração de interfaceamento para novos equipamentos
- Ajuste de mapeamento de exames após mudanças no LIS
- Diagnóstico de falhas de comunicação entre equipamento e servidor
- Adição de novos parâmetros de resultado (ex.: campo "Outros" no Cobas 6500)
