# funfarme-kb

Base de conhecimento de TI do laboratório da **FUNFARME** (Fundação Faculdade Regional de Medicina) — São José do Rio Preto, SP.

Repositório privado mantido por Pedro Santana (Analista de TI).

## Estrutura

| Pasta | Conteúdo |
|---|---|
| `docs/` | Documentação técnica — ambiente, tarefas, inventário de PCs, sistemas, equipamentos, procedimentos, incidentes |
| `scripts/` | Scripts de manutenção e automação (PowerShell, Batch, Python) |
| `shift/` | Material do sistema Shift LIS — dados de integração, rotas, documentação contratual, relatórios mensais |
| `documentos/` | Documentos administrativos (custódia, transferência de patrimônio) |
| `toolkit/` | Ferramentas operacionais — drivers, instaladores, ícones/atalhos, utilitários |
| `reports/` | Relatórios semanais e mensais gerados |
| `profissional/` | Material profissional pessoal |

## Uso com Claude Code

O arquivo `CLAUDE.md` na raiz configura o Claude Code como assistente técnico do laboratório. Ele usa `docs/` como fonte da verdade para responder perguntas sobre o ambiente.

Comandos rápidos disponíveis: `registra incidente`, `atualiza tarefa`, `fecha tarefa`, `gera relatório semanal/mensal`, `status`.
