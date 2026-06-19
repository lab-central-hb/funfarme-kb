# Shift LIS

O Shift LIS (Laboratory Information System) é o sistema principal do laboratório, desenvolvido pela empresa **Shift (Pulsa pela Vida)**.

## Função

Gerencia todo o ciclo do exame laboratorial:

- Configuração de exames, procedimentos, recipientes e amostras
- Máscaras de laudo (layout e campos de variáveis)
- Regras de resultado (faixas de referência, alertas, cálculos)
- Validação técnica e liberação de resultados
- Gestão de usuários e permissões

## Módulos do Shift

| Módulo | Função |
|--------|--------|
| **Shift LIS** | Configuração e gestão de exames, máscaras e resultados |
| **Shift Automação** | Interfaceamento com equipamentos — [ver detalhes](shift-automacao.md) |
| **Shift Integração** | Ponte de dados entre SoulMV e Shift LIS — [ver detalhes](shift-integracao.md) |
| **Shift BI** | Relatórios e visualizações de dados para gestão |

## Máscaras de Exame

Uma **máscara** é o layout do laudo de um exame. Define:

- Campos de resultado (numéricos, texto livre, opções)
- Valores de referência
- Observações e notas de rodapé
- Formatação visual do laudo

A criação de máscaras é uma das atividades mais frequentes da equipe de TI — cada novo exame ou alteração de layout exige configuração no Shift LIS e espelhamento no SoulMV.

## Hospedagem

O Shift LIS é hospedado em **servidor cloud**, mantido exclusivamente pela empresa Shift. A equipe de TI do laboratório não possui acesso direto ao servidor — toda manutenção de infraestrutura é feita pelo suporte Shift.
