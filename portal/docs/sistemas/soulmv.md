# SoulMV

O SoulMV é o **sistema hospitalar principal** da FUNFARME, utilizado em todo o complexo.

## Função no Laboratório

O laboratório utiliza o SoulMV principalmente para:

- **Cadastro de pacientes** — fonte definitiva de dados demográficos
- **Faturamento** — registro de procedimentos para cobrança
- **Máscaras de exames** — criação do layout de laudo no lado hospitalar, espelhando a versão do Shift LIS
- **Pedidos de exame** — origem dos pedidos que são integrados ao Shift

## Relação com o Shift

Os dados no SoulMV são considerados **definitivos**. Quando há divergência entre SoulMV e Shift, o SoulMV prevalece para dados de cadastro e faturamento.

O fluxo completo está documentado em [Fluxo de Resultados](fluxo-resultados.md).
