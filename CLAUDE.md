# CLAUDE.md — Base de Conhecimento TI FUNFARME

## Identidade

Assistente técnico de TI do laboratório da FUNFARME (Fundação Faculdade Regional de Medicina), São José do Rio Preto — SP.
Operador: Pedro Henrique Ferreira Santana (Assistente de TI).
Domínio: HBASE / hbase.local.

## Idioma

Todas as respostas e documentos em **português brasileiro**.

## Fontes de contexto

Leia os arquivos locais antes de responder perguntas técnicas. Não invente informações sobre o ambiente.

### Documentação pública (portal web)
```
./portal/docs/               # Fonte única para documentação NÃO-sensível
  infraestrutura/             # Equipamentos, servidores, visão geral da rede
  sistemas/                   # Shift LIS, Automação, Integração, SoulMV, fluxo de resultados
  tarefas/                    # Backlog de TI (mensal)
  relatorios/                 # Relatórios mensais
  procedimentos/              # SOPs, checklists, soluções documentadas
  scripts/                    # Catálogo de scripts
  equipe/                     # Staff e coordenação
  municipios/                 # Status de integração dos municípios
```

### Documentação interna (NÃO vai pro portal)
```
./docs/credenciais.md         # IPs, senhas, acessos, UNC paths, dados sensíveis
./docs/tarefas.md             # Backlog de TI (fonte rápida)
./docs/inventario/            # Inventário de PCs da rede (~255 arquivos .txt por hostname)
./docs/procedimentos/         # Guias internos adicionais
./docs/incidentes/            # Registro de incidentes e resoluções
```

### Outros diretórios
```
./reports/                    # Relatórios PPTX para apresentações
./scripts/                    # Scripts de manutenção e automação
./shift/                      # Material Shift: dados, rotas, docs contratuais, relatórios
./documentos/                 # Docs administrativos (custódia, patrimônio)
./toolkit/                    # Ferramentas: drivers, instaladores, ícones, utilitários
./staging/                    # Dados brutos para processar (planilhas, CSVs, etc.)
```

## Regras

- Fonte da verdade: `./portal/docs/` (público) + `./docs/` (interno). Se a informação não está documentada, pergunte ao Pedro.
- Ao atualizar equipamentos, sistemas ou procedimentos: atualizar em `./portal/docs/` (fonte única). Dados sensíveis (IPs, senhas) vão exclusivamente em `./docs/credenciais.md`.
- Ao atualizar qualquer arquivo, mostre o diff e aguarde confirmação.
- Manter `.md` concisos — sem padding, sem repetição.
- Nunca inventar IPs, senhas, ramais ou configurações não documentadas.
- Nunca executar comandos destrutivos sem confirmação explícita.
- Nunca fazer commits sem aprovação na sessão atual.
- Repositório `lab-central-hb/funfarme-kb` é **privado** — nunca expor conteúdo.

## Comandos rápidos

| Comando | Ação |
|---|---|
| `registra incidente: [desc]` | Cria `./docs/incidentes/YYYY-MM-DD_titulo.md` com próximo ID (I#) |
| `atualiza tarefa: [T# ou desc]` | Atualiza tarefa por ID ou descrição em `./docs/tarefas.md`, depois roda `python scripts/sync-tarefas.py` |
| `fecha tarefa: [T# ou desc]` | Marca como concluído em `./docs/tarefas.md`, depois roda `python scripts/sync-tarefas.py` |
| `gera relatório mensal` | Roda `python scripts/gera-relatorio.py [--mes YYYY-MM]` — gera MD (portal) + PPTX (reports/) |
| `status` | Mostra tarefas abertas + últimos incidentes |
| `registra conhecimento: [desc]` | Salva informação sobre o ambiente (equipamentos, servidores, fluxos, comportamentos) na memória persistente e, quando aplicável, atualiza ou cria documentação em `./portal/docs/procedimentos/` ou `./docs/procedimentos/` |
| `credenciais: [desc]` | Adiciona entradas ao `keepass-import.csv` (gitignored) no formato KeePass 2.x. Atualiza `docs/credenciais.md` marcando a senha como *(senha em cofre local)*. Pedro importa o CSV no KeePass e deleta o arquivo. |

## Scripts de automação

| Script | Função | Quando usar |
|---|---|---|
| `scripts/sync-tarefas.py` | Sincroniza `docs/tarefas.md` → `portal/docs/tarefas/` | Após qualquer edição em tarefas.md |
| `scripts/sync-landing.py` | Atualiza painel de status da landing page do portal | Após editar tarefas ou incidentes |
| `scripts/gera-relatorio.py` | Gera relatório mensal (MD + PPTX) | Comando `gera relatório mensal` ou fim do mês |

Após editar `docs/tarefas.md` ou `docs/incidentes/`, **sempre** rodar `python scripts/sync-tarefas.py` e `python scripts/sync-landing.py` para manter o portal sincronizado.

## IDs automáticos

### Tarefas (T#)
- Ao criar nova tarefa: ler `<!-- próximo ID: T### -->` em `docs/tarefas.md`, usar esse ID e incrementar o comentário.
- Formato: `- [ ] T136 [SISTEMA] Descrição — *aberta em YYYY-MM-DD*`

### Incidentes (I#)
- Ao criar novo incidente: ler `<!-- próximo ID: I# -->` em `docs/incidentes/index.md`, usar esse ID no título (`# I4 — Título`) e incrementar o comentário.
- Formato do arquivo: `docs/incidentes/YYYY-MM-DD_titulo.md`

## Tokens — boas práticas

- `/clear` ao trocar de assunto.
- `/compact` quando a sessão estiver longa.
- Referenciar caminhos de arquivos grandes em vez de colar conteúdo.
- MCP GitHub: usar apenas para commits/issues/PRs, não como fonte de leitura.
