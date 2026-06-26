# Shift LIS

O Shift LIS (Laboratory Information System) é o sistema principal do laboratório, desenvolvido pela empresa **Shift (Pulsa pela Vida)**.

## Links de Acesso

| Sistema | URL |
|---------|-----|
| **LIS** | [hb.shiftcloud.com.br/main/app](https://hb.shiftcloud.com.br/main/app) |
| **Etiquetas Lab** | [hb.shiftcloud.com.br/…/s00.iu.Login2.cls](https://hb.shiftcloud.com.br/shift/lis/hb/elis/s00.iu.Login2.cls) |
| **Resultados de Exames** | [hb.shiftcloud.com.br/…/s01.iu.web.Login.cls](https://hb.shiftcloud.com.br/shift/lis/hb/elis/s01.iu.web.Login.cls?config=UNICO&sigla) |
| **Integração** | [integracao.shiftcloud.com.br/…/s00.iu.Menu.cls](https://integracao.shiftcloud.com.br/shift/integracao/hospitaldebase/mv/s00.iu.Menu.cls) |
| **Automação** | [automacao.hospitaldebase.com.br/…/s00.iu.Menu.cls](https://automacao.hospitaldebase.com.br/shift/automacao/hospbase/s00.iu.Menu.cls) |

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

Para o procedimento completo, consulte [Criação de Máscara](../procedimentos/index.md).

### Máscaras em PDF — Erro de Exportação

Os seguintes procedimentos utilizam campo PDF e causam erro no relatório de exportação:

| Código Shift | Código SoulMV |
|-------------|---------------|
| 2247 | — |
| 1245 | 232 |
| 2299 | 741 |
| 2037 | — |
| 2321 | — |
| 2189 | — |
| 1629 | — |

## Hospedagem

O Shift LIS é hospedado em **servidor cloud**, mantido exclusivamente pela empresa Shift. A equipe de TI do laboratório não possui acesso direto ao servidor — toda manutenção de infraestrutura é feita pelo suporte Shift.
