# funfarme-kb

Base de conhecimento de TI do laboratório da **FUNFARME** (Fundação Faculdade Regional de Medicina) — São José do Rio Preto, SP.

Repositório privado mantido por Pedro Santana (Analista de TI).

## Portal web

Documentação pública acessível em **[lab-central-hb.github.io/funfarme-kb](https://lab-central-hb.github.io/funfarme-kb/)**, gerado com MkDocs Material e deploy automático via GitHub Actions.

## Estrutura

| Pasta | Conteúdo |
|---|---|
| `portal/docs/` | Fonte única da documentação pública — infraestrutura, sistemas, tarefas, relatórios, procedimentos, scripts, equipe, municípios |
| `docs/` | Documentação interna (sensível) — credenciais, inventário de PCs, incidentes, procedimentos internos |
| `scripts/` | Automação em Python — sync de tarefas, geração de relatórios (MD + PPTX), utilitários |
| `shift/` | Material do sistema Shift LIS — dados de integração, rotas, documentação contratual |
| `reports/` | Relatórios mensais em PPTX para apresentações |
| `documentos/` | Documentos administrativos (custódia, transferência de patrimônio) |
| `toolkit/` | Ferramentas operacionais — drivers, instaladores, ícones, utilitários |
| `staging/` | Dados brutos para processar (planilhas, CSVs) |
| `profissional/` | Material profissional pessoal |

## Scripts de automação

| Script | Função |
|---|---|
| `scripts/sync-tarefas.py` | Sincroniza `docs/tarefas.md` → `portal/docs/tarefas/` |
| `scripts/gera-relatorio.py` | Gera relatório mensal (MD no portal + PPTX em `reports/`) |
| `scripts/cria-template-pptx.py` | Cria template PPTX com branding FUNFARME |
| `scripts/concatena_sheets.py` | Concatena planilhas de dados |

## Uso com Claude Code

O arquivo `CLAUDE.md` na raiz configura o Claude Code como assistente técnico do laboratório. Ele usa `portal/docs/` (público) e `docs/` (interno) como fontes da verdade.

### Comandos rápidos

| Comando | Ação |
|---|---|
| `registra incidente: [desc]` | Cria registro em `docs/incidentes/` |
| `atualiza tarefa: [desc]` | Adiciona item no backlog e sincroniza portal |
| `fecha tarefa: [desc]` | Marca como concluído e sincroniza portal |
| `gera relatório mensal` | Gera MD + PPTX do mês |
| `status` | Mostra tarefas abertas e últimos incidentes |
