# I1 — Bloqueio de ferramentas de acesso remoto externo

**Data:** semana 3 de junho de 2026 (16–20/06)
**Responsável:** Equipe de redes
**Impacto:** Alto — afeta suporte a municípios e manutenção do SRV-AUTOMA pela Shift

---

## O que aconteceu

A equipe de redes bloqueou todas as ferramentas de acesso remoto externo na rede hospitalar como medida de segurança:

- **Bloqueados:** AnyDesk, TeamViewer e similares
- **Permitido:** Apenas MSRA (Microsoft Remote Assistance) para máquinas dentro da rede interna

## Impacto no laboratório

### Suporte a municípios
- Pedro e Kauã não conseguem mais acessar remotamente os computadores dos municípios para resolver problemas
- O atendimento que antes era feito via AnyDesk (acesso direto à máquina do colaborador) está interrompido
- Municípios ficam sem suporte técnico remoto direto

### Manutenção do SRV-AUTOMA
- A empresa Shift utilizava o AnyDesk para fazer manutenções no servidor de automação (SRV-AUTOMA)
- Este acesso não é mais possível — a Shift precisa de uma alternativa para manutenções remotas

## Plano de ação

- Conversar com os técnicos de TI de cada município para capacitá-los e torná-los mais autônomos na resolução de problemas
- Avaliar alternativas para acesso da Shift ao SRV-AUTOMA (VPN dedicada, exceção de rede, etc.)
