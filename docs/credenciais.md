# Credenciais e Acessos Internos

> Documento interno — NÃO publicar no portal.
> Última atualização: 2026-06-24

---

## Servidores

### SRV-AUTOMA — Servidor de Automação
- **IP:** `192.168.20.44`
- **Acesso:** `.\administrator` / *(senha em cofre local)*
- **Diretório principal:** `D:\Shift\`
  - `D:\Shift\Dados\HOSPBASE\ImagensCobasI` — imagens de microscopia do Cobas 6500 I
  - `D:\Shift\Dados\HOSPBASE\ImagensCobasII` — imagens de microscopia do Cobas 6500 II
  - `D:\Shift\Backups ImagensCobas\` — backups mensais das imagens
- **Compartilhamentos de rede:**
  - `\\192.168.20.44\ImagensCobasI` (usuário: `administrator`, senha em cofre local)
  - `\\192.168.20.44\ImagensCobasII` (usuário: `administrator`, senha em cofre local)

### SRV-TS — Terminal Server
- **IP:** `10.10.10.124`
- **Acesso administrativo:** Restrito a Pedro Santana e equipe de redes
- **Scripts em produção:**
  - `C:\scripts\Get-TSUserSnapshot.ps1` — snapshot horário de usuários ativos e uso de RAM
  - `C:\scripts\DailyReboot.ps1` — reinicia o servidor diariamente às 23h30
  - `C:\scripts\TSUserSnapshots_YYYY-MM.csv` — CSV mensal gerado pelo snapshot

### SRV-TS02 — Terminal Server (secundário)
- **IP:** `10.10.10.125`
- **Acesso administrativo:** Restrito a Pedro Santana e equipe de redes

### AQURE
- **IP:** `172.30.57.101`
- **Acesso:** `.\administrator` / *(senha em cofre local)*

---

## Equipamentos — IPs

| Equipamento | IP |
|---|---|
| Cobas 6500 I | `172.30.27.150` |
| Cobas 6500 II | `172.30.27.151` |

---

## Dispositivos de Rede

| Dispositivo | IP / ID | Acesso |
|---|---|---|
| Impressora Diretoria | `172.30.57.9` | `admin` / *(senha em cofre local)* |
| Painel HLab | ID `1575619917` | — |
| Painel Lab (NTI-60200) | `172.30.57.30` | — |

---

## URLs de Sistemas (com IPs internos)

| Sistema | URL |
|---|---|
| P-512 (local) | `http://192.168.20.91:57774/shift/integracao/hb/cobas/s00.iu.Login.cls` |

---

## Conta Institucional

- **E-mail:** `tilabcentral@gmail.com`
- **Senha:** *(cofre local)*

---

## Credenciais de Municípios (Resultados de Exames)

*(cofre local)*

---

## Computador da Microbiologia — SARAMIS

- **Sistema:** SARAMIS (identificação de microrganismos)
- **Usuário principal:** `Labadmin` / *(senha em cofre local)* — uso dos microbiologistas
- **Usuário de respaldo:** `Microbiologia` / *(senha em cofre local)* — para quando o Labadmin é bloqueado por erro de senha

---

## Computador do Assistente de TI (NTI-102856)

- **IP:** `172.30.57.127`
- **Hostname:** NTI-102856

### Estrutura do disco D:\

#### `D:\backups\`
- `hbsstrauma\` — backup de perfil de usuário

#### `D:\documentos\`

| Pasta / Arquivo | Conteúdo |
|---|---|
| `Assinaturas de Email\` | Templates PowerPoint de assinaturas por unidade com assets JPG |
| `Equipamentos\` | PDFs/DOCs de custódia e transferência de equipamentos |
| `Relatórios Fiscais\` | Pastas mensais com relatórios Word de serviço, NFSe PDFs, notas de débito |
| `e-mail criar máscaras.xlsx` | Planilha de padrão/máscara de e-mails |
| `Epimed UTI 7o andar.txt` | Nota sobre o sistema Epimed (UTI 7º andar) |
| `reboot.bat` | Script simples de reboot |

#### `D:\santana\`

| Pasta | Conteúdo |
|---|---|
| `computadores\` | ~255 arquivos `.txt` com inventário de ativos por hostname |
| `documentos\` | PDFs de controle de trânsito de equipamentos |
| `drivers\` | Drivers: etiquetas (Bematech, Zebra), leitor biométrico (Hamster DX III), impressoras (408dn, 432, UPD), scanners (Canon DR-C230) |
| `icones\` | Atalhos para sistemas internos |
| `install\` | Instaladores: Acrobat, AnyDesk, AIDA64, HWMonitor, Brother, Teams, OCS, PDF24, Samsung, ZebraDesigner, Digital Anatomy, WebCas |
| `scripts\` | Scripts de manutenção (detalhamento abaixo) |
| `shift\` | Material Shift LIS: instalador, XMLs de integração, CSVs de rotas, documentação contratual (até 31.07.2026) |
| `solucoes doc\` | `configuracao DS22.pdf` — configuração de display/quiosque |
| `soulmv\` | Atalhos, `.bat` helpers, `hosts` editado |
| `tools\` | AOMEI, EASEUS (partição) |
| `windows\windows 11 64-bit\` | Binários de boot/logon para reparo |

#### Detalhamento de `D:\santana\scripts\`

| Subpasta / Arquivo | Função |
|---|---|
| `servidores - lab\` | XMLs de Task Scheduler + PowerShell: reboot diário SRV-TS, snapshot de usuários TS, backup imagens Cobas |
| `x - coleta info pc\` | Inventário de PCs: `pc_info.ps1`, `concatena_sheets.py`, `requirements.txt`, JSON de amostra |
| `x - licensas\` | Wrapper em torno de `massgrave.ps1` — usar apenas em conformidade com política |
| Root (scripts avulsos) | Helpers AnyDesk, backup remoto, limpeza de temp, sincronização de relógio, instalação LAS, reparo Edge/HBIS/WMI, deploy Shift, mapeamento de disco, reset de rede, reboot, `gdistro.ps1` |

---

## Pendências

- [ ] Descrição do módulo Shift View
- [ ] Detalhamento dos cenários de erro no SoulMV e suas soluções
- [ ] Ramal do Almoxarifado
- [ ] Scripts avulsos do `D:\santana\scripts\` root (descrição individual)
- [ ] Outros servidores ou sistemas não mencionados
