# Shift Integração

O módulo de Integração é a ponte de dados entre o **SoulMV** (sistema hospitalar) e o **Shift LIS** (sistema laboratorial).

## Função

- Recebe pedidos de exame do SoulMV e os encaminha ao Shift LIS
- Exporta resultados validados do Shift LIS de volta ao SoulMV
- Sincroniza cadastros de pacientes e dados demográficos

## Erros Comuns de Integração

!!! warning "Causas frequentes de falha"

    - **Erros de cadastro** — cargos administrativos alterando campos indevidamente no SoulMV
    - **Exames adicionados indevidamente** — exames inseridos fora do fluxo padrão
    - **Pacientes duplicados** — cadastros duplicados no SoulMV gerando conflitos
    - **Alteração de pedidos após cadastro** — modificações em pedidos já integrados

!!! tip "Diagnóstico"

    Quando resultados param de exportar, verificar:

    1. Status do usuário de exportação no Shift
    2. Logs de integração no Shift LIS
    3. Consistência dos dados entre SoulMV e Shift
