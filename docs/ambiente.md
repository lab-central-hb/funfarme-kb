# ambiente.md — Infraestrutura de TI · FUNFARME

> Documento de referência do ambiente técnico do laboratório.
> **Fonte primária para o Claude Code.** Mantenha sempre atualizado.
> Última atualização: <!-- data -->

---

## Domínio e rede

| Campo | Valor |
|---|---|
| Domínio Active Directory | HBASE / hbase.local |
| Faixa de IP | <!-- ex: 192.168.1.0/24 --> |
| Gateway | <!-- --> |
| DNS primário | <!-- --> |
| DNS secundário | <!-- --> |

---

## Servidores

### SRV-RS
| Campo | Valor |
|---|---|
| Função | <!-- Terminal Server / Remote Desktop --> |
| IP | <!-- --> |
| OS | <!-- Windows Server 20xx --> |
| Serviços | <!-- RDS, etc. --> |
| Task Scheduler | Reboot diário, snapshot de usuários TS |
| Notas | <!-- --> |

### SRV-AUTOMA
| Campo | Valor |
|---|---|
| Função | <!-- Automação laboratorial --> |
| IP | <!-- --> |
| OS | <!-- --> |
| Serviços | <!-- Shift Automação, etc. --> |
| Task Scheduler | Backup de imagens Cobas, reboot diário |
| Notas | <!-- --> |

<!-- Adicione outros servidores conforme necessário -->

---

## Sistemas principais

### Shift LIS ("Pulsa pela Vida")
- **Fornecedor:** Shift
- **Função:** Sistema de informação laboratorial principal
- **Módulos ativos:** Shift LIS, Shift Integração, Shift Automação
- **Contato suporte:** <!-- -->
- **Notas relevantes:** <!-- ex: rotas Cobas P-512, configurações específicas -->

### SoulMV
- **Fornecedor:** MV
- **Função:** <!-- HIS / sistema hospitalar -->
- **Contato suporte:** <!-- -->
- **Notas:** <!-- -->

### Municípios
- **Função:** <!-- acesso de municípios parceiros -->
- **Municípios ativos:** <!-- lista -->
- **Notas:** <!-- -->

---

## Equipamentos laboratoriais

| Equipamento | Modelo | Interface | Notas |
|---|---|---|---|
| Sorter | Cobas P-512 | <!-- --> | Rotas 8, 9, 23 — ver `./sistemas/shift-automacao.md` |
| <!-- --> | <!-- --> | <!-- --> | <!-- --> |

---

## Impressoras

| Nome de rede | Localização | Função | Notas |
|---|---|---|---|
| `\\nti-9999\etiquetas` | <!-- --> | Impressão de etiquetas ZPL | 50×30mm, 203 DPI |
| <!-- --> | <!-- --> | <!-- --> | <!-- --> |

---

## Equipe

| Nome | Função | Contato |
|---|---|---|
| Pedro Henrique Ferreira Santana | Analista de TI | <!-- ramal / email --> |
| Kauã | Aprendiz de TI | <!-- --> |
| Pedro Pogi | Equipe Shift | <!-- contato --> |
| André | Analista | <!-- --> |
| Leonardo | Equipe Lab | <!-- --> |
| Camila | Equipe Lab | <!-- --> |

---

## Municípios parceiros

<!-- Liste os municípios atendidos e informações de acesso/integração -->

---

## Scripts em produção

| Script | Servidor | Agendamento | Função |
|---|---|---|---|
| Cobas image backup | SRV-AUTOMA | <!-- horário --> | Backup das imagens do sorter Cobas |
| TS user snapshot | SRV-RS | <!-- horário --> | Snapshot de usuários do Terminal Server |
| Reboot diário | SRV-RS / SRV-AUTOMA | <!-- horário --> | Reinicialização programada |
| sync.ps1 | Local KB | 18h diário | Commit automático da base de conhecimento |

---

## Repositório GitHub

| Campo | Valor |
|---|---|
| Repositório | `lab-central-hb/funfarme-kb` (privado) |
| Branch principal | `main` |
| Autenticação | PAT armazenado em `~/.claude.json` via MCP |

---

## Notas operacionais

<!-- Campo livre para registrar observações recorrentes, workarounds conhecidos,
     comportamentos esperados de sistemas, etc. -->

- Scripts PowerShell devem usar **ASCII puro** — caracteres Unicode causam erros de parse no ambiente Windows
- <!-- adicione outras notas conforme necessário -->
