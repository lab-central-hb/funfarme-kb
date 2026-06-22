# Guia de Soluções — Shift LIS

> Procedimentos operacionais e soluções para o dia a dia do laboratório.
> Fonte: Notion TI Laboratório (importado em 2026-06-22).

---

## Criação de Máscara

1. Menu Shift LIS > Configuração > Procedimento > Máscara.
2. Selecionar o procedimento utilizando código, nome ou mnemônico.
3. Clicar em **Criar máscara em elaboração**.
4. Preencher "Descrição proc." e "Descrição proc. online" com o nome da máscara que será exibido, conforme convenção do laboratório ou laudo de exemplo.
5. No campo "Observações", preencher com: `PDF | Laboratório | mês/ano de criação`. Exemplos: **PDF Fleury 2026** ou **Pardini 06/2026**.
6. Na área **Campos de máscara**, criar e inserir os parâmetros e processos analíticos.
7. Em "Tipo do campo", escolher entre entrada de dados comum, campo calculado ou imagem (para gráficos). O mais comum é "entrada de dados comum".
8. Na caixa de seleção ao lado direito, definir se o campo terá impressão ou ficará apenas visível pelo sistema ("sem impressão").
9. Os campos de descrição definem como o parâmetro aparece no laudo final. Para máscaras com campo único, usar apenas "RESULTADO:" como descrição.
10. Para criar um novo parâmetro, clicar no ícone de documento ao lado de "Parâmetro".
11. Preencher "Descrição" com descrição clara. Preencher os dois campos de "Apelido" com abreviação do parâmetro (identificador na integração). Ex.: para "DEHIDROEPIANDROSTERONA SULFATO (SDHEA)", usar apelido "SDHEA" para o laboratório central e "SDHEApard" para o Hermes Pardini.
12. Nos botões de rádio ao lado direito, escolher se o campo é obrigatório ou não. Campos não obrigatórios são usados para resultados visíveis apenas pelos analistas ou exames com número variável de análises.
13. Na área **Processo analítico**, criar um novo clicando no ícone de documento ao lado de "Padrão". Cada parâmetro tem obrigatoriamente pelo menos um processo analítico (formatações, valores de referência, unidades de medida).
14. Na nova página, clicar em **Novo** para criar o processo analítico.
15. Escolher "Apelido" e "Descrição" para o processo analítico.
16. Na aba **Geral**, preencher "Método" do exame (criar novo caso necessário).
17. Para unidades de medida, buscar no campo "Unidade (pré-cadastrado)" para reutilizar unidades existentes.
18. Tipo de resultado:
    - **Alfanumérico** — texto, geralmente tamanho 30+.
    - **Numérico** — apenas números, geralmente para resultados de equipamentos.
    - **Numérico/alfanumérico** — aceita números ou letras. Muito utilizado. Para o número 10.1: tamanho mínimo "3", decimais "1".
    - **Laudo** — para gráficos/imagens.
    - **Arquivo PDF** — para exames cadastrados como campo livre no MV. Tamanho geralmente 30.
19. Na aba **Valores de referência**, criar "Novo valor". Para uso apenas de visualização (sem classificação dinâmica):
    - Categoria: Humano
    - Sexo: Todos
    - Idade inicial: 0
    - Idade final: 200
    - Tipo idade: Anos
    - Preencher texto no campo "Texto referência".
20. Para classificação dinâmica (cores, avisos de resultados fora do normal): preencher idades e sexo conforme descrito no laudo de referência. Consultar central de ajuda da Shift para configuração detalhada.
21. Após gravar valores de referência, adicionar "Notas de laudo" se necessário — fonte **Courier New**, tamanho **8**.
22. Clicar em **Salvar** e fechar a janela do processo analítico.
23. Escolher o processo analítico criado no campo "Padrão" (pelo apelido) e salvar.
24. Na tela "Campos de máscara", escolher o parâmetro e preencher as descrições. Clicar no **+** acima de "Descrição" para adicionar à máscara.
25. Após adicionar todos os parâmetros, **salvar**. A máscara ficará disponível com nome "Elaboração".
26. Levar via impressa para validação pelo profissional de Qualidade.
27. Para ativar: clicar em **Gerar nova versão** e escolher se será padrão ou não (consultar solicitante).

---

## Etiquetas Shift não funciona

1. Checar se o acesso à rede local está ativo no navegador. Reiniciar o navegador ou atualizar a página.
2. Usar o script **E(MV2000):/TI/Shift/Conserta Shift.bat**.
3. Desinstalar e instalar o Shift novamente: **E:/TI/Shift/ShiftAppInstall.exe** (como administrador).
4. Caso persista, limpar os cookies do navegador.

---

## Criação de Usuários Shift

### Usuário do laboratório
Espelhar com o usuário que a pessoa indicar.

### Usuário externo
1. Digitar o código **4** e clicar em **Duplicar**.
2. Adicionar o nome completo do usuário.
3. Nome de usuário: primeiro e último nome, tudo maiúsculo (`NOMESOBRENOME`).
4. Apelido: departamento do requerente.
5. Senha: *(ver cofre local — padrão de senha inicial)*.
6. Perfil de acesso: código **3**.
7. Em Acessos > Unid. Coleta de trabalho, procurar equivalente ao departamento do requerente.

---

## Funcionamento do Shift Automação

1. Verificar os 3 primeiros itens (documentos de funcionamento das máquinas) — checar se os horários batem com a hora atual.
2. Se não estiverem batendo: clicar no botão **vermelho** para parar. Se não parar, clicar no botão com **X** (parada forçada). Para retomar, clicar no **play**.
3. Verificar se todas as máquinas estão online. Se estiverem offline, repetir o processo acima.

---

## Grupos/Áreas (notificações e resultados críticos)

Sempre que um profissional formado (biomédico, farmacêutico etc.) entrar no setor, incluí-lo no grupo correspondente:

- Menu: **Qualidade > Configuração > Área**
- Incluir o usuário na lista e preencher os check-boxes de cada um.

---

## Instalação Shift em Municípios

### O que instalar
- **Apenas sala de coleta** (etiquetas e registro de coletas): instalar apenas Shift.
- **Cadastros de pacientes no MV**: instalar Sophos + Shift.

### Procedimento
1. Copiar todos os arquivos da pasta **Fluxo Hospital de Base** para o computador.
2. Instalar o **Sophos Connect** (requer permissão de administrador):
   - Acessar `https://vpn.hospitaldebase.com.br:4442/`
   - Login com usuário e senha de rede da pessoa
   - Baixar o SSL VPN client e executar
3. Instalar Shift: baixar `ShiftAppInstall.exe` e executar como administrador.
4. Acessar `hb.shiftcloud.com.br` e logar com o usuário.
5. Clicar em **Permitir** na janela superior esquerda.
6. Nome do usuário > Saída de impressão e arquivos > Perfil de impressão: **perfil HB** > Salvar.
7. Acessar o link de **Etiquetas Laboratório**.
8. Em Atendimento > Monitor de O.S.:
   - Selecionar a unidade de coleta correspondente
   - Adicionar todos os procedimentos
   - Selecionar Origem > Integração
   - Filtrar e selecionar 500 registros por página
9. Configurar acesso de **Resultados de Exames** com credenciais do município *(ver cofre local)*.
10. Criar atalhos para os links de Etiquetas e Resultados (**não** criar para `hb.shiftcloud.com.br`).

### Troubleshooting
Comando para reiniciar o serviço Shift local:
```bat
taskkill /F /IM javaw.exe
```
Compilado como `.bat` — ao clicar duas vezes, reabre o Shift.

---

## Informações Pré-Analíticas

Adicionar informações pré-analíticas e vincular o recipiente correspondente aos procedimentos que necessitam dessa informação. Configurar via menu do Shift LIS.

---

## Serviço de Importação — Laboratórios de Apoio

Para importação de resultados de laboratórios de apoio:

1. Acessar **Painel de Tarefas** no menu do LIS.
2. Se um serviço parou: verificar a tarefa de importação e **anotar as configurações**.
3. Excluir a tarefa (clicar no **X** na coluna de opções).
4. Criar nova tarefa com as configurações anotadas.
5. Clicar no **play** para iniciar.
6. Verificar funcionamento em **Importação de Resultados**.

Novas integrações com laboratórios de apoio seguem o mesmo processo de criação de tarefa.

---

## Resultados Críticos — Microbiologia

1. Identificar o microrganismo caracterizado como resultado crítico.
2. Localizar em **Cadastro de Grupo de Laudo**.
3. Incluir o microrganismo em **Cadastro de Item de Laudo** como resultado crítico (copiar nome exato).

---

## Processos Analíticos (alteração sem mudar máscara)

Quando houver mudança que **não** envolve adição/remoção/alteração de tipo de parâmetros, é preferível apenas criar novos processos analíticos em vez de alterar a máscara inteira.
