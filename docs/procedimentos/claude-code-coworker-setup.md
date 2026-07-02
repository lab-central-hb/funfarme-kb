# Setup do Claude Code para coworker (acesso restrito)

Guia para configurar o Claude Code no computador de um coworker que vai apenas
registrar tarefas e incidentes na base — sem acesso ao restante do ambiente.

## O que foi criado

- `.claude/skills/registra-incidente/`, `atualiza-tarefa/`, `fecha-tarefa/`,
  `gera-relatorio-mensal/`, `registra-conhecimento/`, `status/` — versões dos
  comandos rápidos do `CLAUDE.md` como skills reais (`/nome-do-skill`), com
  `disable-model-invocation: true` para só rodarem quando digitadas
  explicitamente, permitindo travar por nome no `permissions.allow`.
- `docs/procedimentos/claude-code-coworker-settings.local.json.template` —
  modelo de configuração restrita (não é usado neste computador).

Essas mudanças ficam no repositório e não afetam o seu computador: seu
`.claude/settings.local.json` é local (ignorado pelo git) e continua sem
restrições.

## Passo 0 — no GitHub (você faz uma vez, antes de tudo)

1. **Adicionar o coworker como colaborador** do repositório privado
   `lab-central-hb/funfarme-kb` (Settings → Collaborators → Add people),
   com permissão de escrita (Write).
2. **Proteger a branch `main`** (Settings → Branches → Add branch protection
   rule, pattern `main`):
   - ✅ Require a pull request before merging
   - ✅ Require approvals (mínimo 1 — você)
   - ✅ Do not allow bypassing the above settings (inclui admins, se quiser
     que a regra valha até pra você)
   - Isso é o que realmente impede push direto em `main` — mesmo que alguém
     tenha permissão de escrita no repo, só entra em `main` via PR aprovado.
     A config do Claude Code (abaixo) é só uma camada extra pro que a IA
     roda; ela não impede um `git push` manual fora do Claude Code.

## Passos no computador do coworker

1. Clonar o repositório normalmente.
2. Criar e usar a branch `colaborador` (o template já libera push só nela):
   ```
   git checkout -b colaborador
   ```
3. Copiar o template para o lugar certo:
   ```
   cp docs/procedimentos/claude-code-coworker-settings.local.json.template .claude/settings.local.json
   ```
4. Abrir o Claude Code nesse computador. Os comandos disponíveis para o
   coworker são: `/registra-incidente`, `/atualiza-tarefa`, `/fecha-tarefa`,
   `/gera-relatorio-mensal`, `/registra-conhecimento`, `/status`.

## Fluxo do dia a dia

1. Coworker roda os comandos acima; Claude Code faz `git add` + `git commit`
   local (liberado sem confirmação).
2. Quando quiser mandar pra revisão: `git push origin colaborador` (só essa
   branch é liberada — push em `main` é negado no template e bloqueado no
   GitHub de qualquer forma).
3. Abrir o PR `colaborador` → `main` — o Claude Code dele pode fazer isso
   (`gh pr create` ou a ferramenta MCP do GitHub estão liberadas), ou você
   mesmo abre pelo GitHub.
4. **Você revisa o PR** (diff no GitHub, ou `/code-review` localmente) e
   faz o merge. `gh pr merge` e as ferramentas MCP de merge estão
   bloqueadas para o coworker — só você mescla.
5. Depois do merge, o coworker roda `git checkout colaborador && git pull
   origin main && git merge main` (ou `rebase`) pra manter a branch dele
   atualizada antes do próximo lote de tarefas.

## O que a configuração restringe

- **Modelo travado em Sonnet/Haiku** (`enforceAvailableModels`) — não dá pra
  trocar pra outro modelo via `/model`.
- **Effort baixo** definido por skill (`effort: low`) e globalmente
  (`effortLevel: "low"`) — isso é só uma preferência de custo/velocidade, o
  Claude Code permite o usuário sobrescrever via flag `--effort` ou variável
  de ambiente, **não é uma restrição de segurança**.
- **Bloqueado (deny, sem exceção):** leitura/escrita de `docs/credenciais.md`
  e `keepass-import.csv`, push em `main` (`origin main`, `HEAD:main`, force
  push), troca pra branch `main`, `git reset`, merge de PR (`gh pr merge` e
  o equivalente MCP), subagentes (`Agent`), busca na web, e as ações do MCP
  GitHub que escrevem no repositório remoto fora de PR (push direto de
  arquivo, deletar arquivo, criar repositório).
- **Liberado sem confirmação (allow):** os 6 skills acima, leitura de
  arquivos, edição/criação dentro de `docs/tarefas.md`, `docs/incidentes/`,
  `docs/procedimentos/`, `portal/docs/`, os scripts de sync/relatório, git
  local (`status`, `diff`, `log`, `add`, `commit`), push restrito à branch
  `colaborador`, e abertura de PR (`gh pr create` / MCP GitHub).
- **Qualquer outra ação** (editar fora dessas pastas, rodar outros comandos)
  cai em `defaultMode: "ask"` — o Claude Code pede confirmação manual antes
  de executar. Isso é uma segunda camada, não um bloqueio duro.

## Ressalva importante

A precedência exata entre um `deny` amplo (ex: negar `Edit` inteiro) e um
`allow` específico (ex: liberar só `Edit(/docs/tarefas.md)`) não está 100%
documentada — por isso este template evita denies amplos e usa principalmente
allow específico + deny pontual nos itens realmente sensíveis, com "ask" como
rede de segurança pro resto. **Teste no computador do coworker antes de
confiar totalmente**: tente rodar `/registra-incidente` (deve funcionar sem
pedir confirmação), tente pedir pro Claude ler `docs/credenciais.md` (deve
ser recusado), e tente `git push origin main` pelo Claude Code (deve ser
recusado — e mesmo que não fosse, a proteção de branch no GitHub barra).
