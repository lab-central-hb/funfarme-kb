# Procedimentos

Guias operacionais e soluções para o dia a dia do laboratório.

---

## Shift LIS — Criação de Máscara

??? abstract "Passo a passo completo"

    1. Menu **Shift LIS > Configuração > Procedimento > Máscara**.
    2. Selecionar o procedimento utilizando código, nome ou mnemônico.
    3. Clicar em **Criar máscara em elaboração**.
    4. Preencher "Descrição proc." e "Descrição proc. online" com o nome da máscara conforme convenção do laboratório ou laudo de exemplo.
    5. No campo "Observações", preencher com: `PDF | Laboratório | mês/ano`. Exemplos: **PDF Fleury 2026** ou **Pardini 06/2026**.
    6. Na área **Campos de máscara**, criar e inserir os parâmetros e processos analíticos.
    7. Em "Tipo do campo": entrada de dados comum (mais usado), campo calculado ou imagem.
    8. Na caixa de seleção ao lado direito, definir se o campo terá impressão ou ficará apenas visível ("sem impressão").
    9. Os campos de descrição definem como o parâmetro aparece no laudo final. Para campo único, usar "RESULTADO:".
    10. Para criar parâmetro: clicar no ícone de documento ao lado de "Parâmetro".
    11. Preencher "Descrição" e os dois campos de "Apelido" (identificador na integração). Ex.: `SDHEA` para lab central, `SDHEApard` para Hermes Pardini.
    12. Definir se o campo é obrigatório nos botões de rádio ao lado direito.
    13. Na área **Processo analítico**, criar novo clicando no ícone de documento ao lado de "Padrão". Cada parâmetro precisa de pelo menos um.
    14. Na nova página, clicar em **Novo**.
    15. Escolher "Apelido" e "Descrição" para o processo analítico.
    16. Aba **Geral**: preencher "Método" do exame (criar novo caso necessário).
    17. Unidades de medida: buscar em "Unidade (pré-cadastrado)" para reutilizar existentes.
    18. Tipo de resultado:

        | Tipo | Uso |
        |------|-----|
        | **Alfanumérico** | Texto, geralmente tamanho 30+ |
        | **Numérico** | Apenas números — resultados de equipamentos |
        | **Numérico/alfanumérico** | Aceita números ou letras (mais usado). Para 10.1: tamanho "3", decimais "1" |
        | **Laudo** | Gráficos/imagens |
        | **Arquivo PDF** | Exames cadastrados como campo livre no MV. Tamanho 30 |

    19. Aba **Valores de referência** > "Novo valor". Para visualização simples:

        | Campo | Valor |
        |-------|-------|
        | Categoria | Humano |
        | Sexo | Todos |
        | Idade inicial | 0 |
        | Idade final | 200 |
        | Tipo idade | Anos |

        Preencher texto no campo "Texto referência".

    20. Para classificação dinâmica (cores, avisos): preencher idades e sexo conforme laudo de referência. Consultar central de ajuda da Shift.
    21. Adicionar "Notas de laudo" se necessário — fonte **Courier New**, tamanho **8**.
    22. **Salvar** e fechar a janela do processo analítico.
    23. Escolher o processo analítico no campo "Padrão" (pelo apelido) e salvar.
    24. Na tela "Campos de máscara", escolher o parâmetro, preencher descrições e clicar no **+** acima de "Descrição".
    25. Após todos os parâmetros, **salvar**. A máscara ficará como "Elaboração".
    26. Levar via impressa para validação pelo profissional de **Qualidade**.
    27. Para ativar: **Gerar nova versão** e escolher se será padrão (consultar solicitante).

---

## Processos Analíticos (sem alterar máscara)

Quando a mudança **não** envolve adição, remoção ou alteração de tipo de parâmetros, é preferível criar novos **processos analíticos** em vez de alterar a máscara inteira.

---

## Etiquetas Shift — Troubleshooting

Quando as etiquetas param de funcionar:

1. Checar se o **acesso à rede local** está ativo no navegador. Reiniciar o navegador ou atualizar a página.
2. Executar o script `E(MV2000):/TI/Shift/Conserta Shift.bat`.
3. Desinstalar e reinstalar: `E:/TI/Shift/ShiftAppInstall.exe` (como administrador).
4. Se persistir, **limpar cookies** do navegador.

---

## Criação de Usuários Shift

=== "Usuário do laboratório"

    Espelhar com o usuário que a pessoa indicar.

=== "Usuário externo"

    1. Digitar o código **4** e clicar em **Duplicar**.
    2. Adicionar o nome completo do usuário.
    3. Nome de usuário: primeiro e último nome, maiúsculo — `NOMESOBRENOME`.
    4. Apelido: departamento do requerente.
    5. Senha inicial: conforme padrão interno.
    6. Perfil de acesso: código **3**.
    7. Em **Acessos > Unid. Coleta de trabalho**, selecionar a unidade equivalente ao departamento.

---

## Grupos/Áreas — Notificações e Resultados Críticos

Sempre que um profissional formado (biomédico, farmacêutico etc.) entrar no setor:

1. Menu **Qualidade > Configuração > Área**.
2. Incluir o usuário na lista.
3. Preencher os check-boxes de cada um dentro da lista.

---

## Resultados Críticos — Microbiologia

1. Identificar o microrganismo caracterizado como resultado crítico.
2. Localizar em **Cadastro de Grupo de Laudo**.
3. Incluir o microrganismo em **Cadastro de Item de Laudo** como resultado crítico (copiar nome exato).

---

## Shift Automação — Monitoramento

1. Verificar os 3 primeiros itens (documentos de funcionamento das máquinas) — os horários devem bater com a hora atual.
2. Se não estiverem batendo: clicar no botão **vermelho** para parar. Se não parar, clicar no botão **X** (parada forçada). Para retomar, clicar no **play**.
3. Verificar se todas as máquinas estão **online**. Se offline, repetir o processo acima.

---

## Serviço de Importação — Laboratórios de Apoio

Para importação de resultados de laboratórios de apoio:

1. Acessar **Painel de Tarefas** no menu do LIS.
2. Se um serviço parou: verificar a tarefa de importação e **anotar as configurações**.
3. Excluir a tarefa (clicar no **X** na coluna de opções).
4. Criar nova tarefa com as configurações anotadas.
5. Clicar no **play** para iniciar.
6. Verificar funcionamento em **Importação de Resultados**.

---

## Informações Pré-Analíticas

Configurar informações pré-analíticas e vincular o recipiente correspondente aos procedimentos que necessitam dessa informação. Configurar via menu do Shift LIS.

---

## Instalação Shift em Municípios

Procedimento completo de instalação para unidades de coleta em municípios.

[Ver procedimento detalhado :octicons-arrow-right-24:](instalacao-municipios.md)

---

## Reiniciar Serviço Shift (local)

Quando o Shift trava no computador local:

```bat
taskkill /F /IM javaw.exe
```

Disponível como `.bat` — ao clicar duas vezes, reabre o serviço Shift automaticamente.
