# Ambiente de TI — Laboratório HBASE
> Documento de referência técnica para uso no projeto Claude.
> Última atualização: 2026-05-12
> Mantenedor: Pedro Santana

---

## 1. Contexto Geral

O laboratório é um ambiente clínico sério, integrado ao hospital da FUNFARME.
Toda comunicação e documentação deve ser mantida em **português**.
O foco deste projeto é a manutenção, configuração e suporte dos sistemas e equipamentos laboratoriais.

---

## 2. Domínio e Rede

- **Domínio:** `hbase` / `hbase.local`
- A rede hospitalar é gerenciada por uma equipe de redes separada, que controla políticas via Active Directory.
- A equipe de TI do laboratório não faz parte da equipe de redes e tem visibilidade limitada sobre a infraestrutura de rede.
- Usuários do TS são cadastrados pela equipe de redes no formato `nome.sobrenome@hbase.local`.

---

## 3. Servidores

### 3.1 Servidor Cloud — Shift LIS
- Hospeda o Shift LIS.
- Mantido e acessível exclusivamente pela empresa Shift.
- Sem acesso direto pela equipe de TI do laboratório.

### 3.2 SRV-AUTOMA — Servidor de Automação
- **Função:** Interfaceamento dos equipamentos laboratoriais com o sistema Shift.
- **IP:** `192.168.20.44`
- **SO:** Windows Server 2016
- **Acesso remoto:** `.\administrator` / *(senha em cofre local)*
- **Serviço hospedado:** CachéITF
- **Diretório principal:** `D:\Shift\`
  - `D:\Shift\Dados\HOSPBASE\ImagensCobasI` — imagens de microscopia do Cobas 6500 I
  - `D:\Shift\Dados\HOSPBASE\ImagensCobasII` — imagens de microscopia do Cobas 6500 II
  - `D:\Shift\Backups ImagensCobas\` — backups mensais das imagens, organizados por ano e equipamento
- **Compartilhamentos de rede mapeados nos Cobas:**
  - `\\192.168.20.44\ImagensCobasI` (usuário: `administrator`, senha em cofre local)
  - `\\192.168.20.44\ImagensCobasII` (usuário: `administrator`, senha em cofre local)

### 3.3 SRV-TS — Terminal Server
- **Função:** Acesso remoto ao sistema SoulMV para colaboradores de municípios vizinhos.
- **IP:** `10.10.10.124`
- **Acesso:** Via SophosVPN + Remote Desktop com credenciais individuais (`nome.sobrenome@hbase.local`)
- **Acesso administrativo:** Restrito a Pedro Santana e equipe de redes.
- **Scripts em produção:**
  - `C:\scripts\Get-TSUserSnapshot.ps1` — snapshot horário de usuários ativos e uso de RAM
  - `C:\scripts\DailyReboot.ps1` — reinicia o servidor diariamente às 23h30 com avisos de 5 e 1 minuto
  - `C:\scripts\TSUserSnapshots_YYYY-MM.csv` — CSV mensal gerado pelo snapshot

### 3.4 SRV-TS02 — Terminal Server
- **Função:** Acesso remoto ao sistema SoulMV para colaboradores de municípios vizinhos.
- **IP:** `10.10.10.125`
- **Acesso:** Via SophosVPN + Remote Desktop com credenciais individuais (`nome.sobrenome@hbase.local`)
- **Acesso administrativo:** Restrito a Pedro Santana e equipe de redes.
- **Scripts em produção:**
---

## 4. Equipamentos Laboratoriais

### 4.1 Urinálise
| Equipamento | IP | Diretório de imagens |
|---|---|---|
| Cobas 6500 I | `172.30.27.150` | `D:\Shift\Dados\HOSPBASE\ImagensCobasI` |
| Cobas 6500 II | `172.30.27.151` | `D:\Shift\Dados\HOSPBASE\ImagensCobasII` |

- Enviam resultados numéricos e imagens de microscopia para o Shift Automação.
- Backup semanal automatizado via `Backup-CobasImages.ps1` (toda segunda-feira às 02h00).

### 4.2 Bioquímica / Imunologia
- **Cobas PRO I** — responsável por todos os exames de bioquímica e imuno. Resultados enviados para Automação.

### 4.3 Sorologias
- **Cobas PRO II** — dedicado exclusivamente a sorologias. Resultados enviados para Automação.

### 4.4 Hematologia
- STA COMPACT MAX
- STA R MAX
- XN 3100
- XN 1000
- XN 550

### 4.5 Microbiologia e Biomolecular
> ⚠️ *Pendente — lista completa a ser fornecida futuramente.*
> Nota: nem todos os equipamentos do laboratório possuem interface com o sistema para resultados de automação.

---

## 5. Sistemas

### 5.1 Shift (Pulsa pela Vida)
Sistema LIS principal do laboratório. Composto por 5 módulos, dos quais utilizamos:

| Módulo | Nome curto | Função |
|---|---|---|
| Shift LIS | LIS | Configuração de exames, procedimentos, recipientes, amostras, usuários e regras de resultados |
| Shift Automação | Automação | Configuração dos exames interfaceados com os equipamentos; recebe resultados e os envia ao LIS |
| Shift Integração | Integração | Integração de dados entre SoulMV e Shift LIS |
| Shift BI | BI | Relatórios e visualizações de dados; usado pelo gerente de qualidade e administrativo |

**Fluxo de resultados:**
`Equipamento → Shift Automação (via CachéITF no SRV-AUTOMA) → Shift LIS → SoulMV`

### 5.2 SoulMV
- Sistema hospitalar principal da FUNFARME.
- Cadastro de pacientes e faturamento — dados aqui são considerados definitivos.
- O laboratório utiliza o SoulMV principalmente para criar **máscaras de exames** (layout do laudo e campos de variáveis), espelhando as versões criadas no Shift.
- **Erros comuns que causam falhas de integração com a Shift:**
  > ⚠️ *Pendente — Pedro irá detalhar cada cenário e suas soluções:*
  - Erros de cadastro por cargos administrativos
  - Exames adicionados indevidamente
  - Pacientes duplicados
  - Alteração de pedidos após cadastro

---

## 6. Scripts em Produção

| Script | Servidor | Função | Agendamento |
|---|---|---|---|
| `Backup-CobasImages.ps1` | SRV-AUTOMA | Move pastas de imagens dos Cobas para backup mensal | Semanal (segunda, 02h00) |
| `Get-TSUserSnapshot.ps1` | SRV-TS | Snapshot horário de sessões ativas + RAM | A cada 1 hora |
| `DailyReboot.ps1` | SRV-TS | Reinício diário com avisos aos usuários | Diário, 23h30 |

---

## 7. Staff do Laboratório

### 7.1 TI
| Nome | Cargo | Observações |
|---|---|---|
| Pedro Santana | Assistente de TI | Administrador dos servidores; contato principal de TI |
| Kauã | Menor aprendiz | Suporte ao Pedro Santana |

- **Ramal TI:** 1421

### 7.2 Coordenação
| Nome | Cargo / Função |
|---|---|
| Mauricio Lacerda Nogueira | Médico virologista — Coordenador geral do laboratório |
| Camila de Souza Daher | Médica patologista clínica — Coordenadora do laboratório |
| Leonardo Ruiz | Biomédico — Supervisor analítico |
| Jean Michel Dias | Biomédico — Líder de qualidade, controle de estatísticas, vigilância sanitária local |
| Ana Paula Galdiano | Coordenadora administrativa — Líder dos cargos administrativos, secretarias e recepção |
| Adele Cristina Betum | Enfermeira — Supervisora de operações |

- **Ramal Coordenação:** 1085
- **Ramal Sala Administrativa:** 5024 / 1423

> ⚠️ *Pendente — ramais de Apoio, Bioquímica e Almoxarifado a confirmar.*

---

## 8. Computador de Pedro Santana (NTI-102856)

- **IP:** `172.30.57.127`
- **Hostname:** NTI-102856
- **Importância:** Contém arquivos essenciais de trabalho, documentação, scripts e ferramentas de TI no disco `D:\`.

### Estrutura do disco D:\

#### `D:\backups\`
- `hbsstrauma\` — backup de perfil de usuário (Desktop, Documents). Pode ser placeholder ou cópia incompleta.

#### `D:\documentos\`
Documentos de trabalho e administrativos.

| Pasta / Arquivo | Conteúdo |
|---|---|
| `Assinaturas de Email\` | Templates PowerPoint de assinaturas de e-mail por unidade (AMBULATÓRIO, CIEPS, FUNFARME, HB ONCO, HB, HCM, Hemocentro, HLAB, LUCY MONTORO, HM) com assets JPG |
| `Equipamentos\` | PDFs/DOCs de custódia e transferência de equipamentos (termos de responsabilidade, entrada/saída de materiais) |
| `Relatórios Fiscais\` | Pastas mensais (`2026.01`, `2026.03`, `2026.04`, `2026.05`…) com relatórios Word de serviço, NFSe PDFs, notas de débito. Resumos root de NF Intersystems / NF Shift |
| `e-mail criar máscaras.xlsx` | Planilha de padrão/máscara de e-mails |
| `Epimed UTI 7o andar.txt` | Nota sobre o sistema Epimed (UTI 7º andar) |
| `reboot.bat` | Script simples de reboot |

#### `D:\santana\`
Kit de trabalho pessoal de TI.

| Pasta | Conteúdo |
|---|---|
| `computadores\` | ~255 arquivos `.txt` com inventário de ativos por hostname (`NTI-xxxxx.txt`) — base de inventário de PCs da rede |
| `documentos\` | PDFs de controle de trânsito de equipamentos e transferência de ativos |
| `drivers\` | Drivers organizados: etiquetas (Bematech, Zebra gc420t/gk420t/zd220/zt230), leitor biométrico (Hamster DX III), impressoras/copiadoras (408dn, 432, UPD), scanners (Canon DR-C230, CaptureOnTouch) |
| `icones\` | Atalhos `.lnk` e `.url` para sistemas internos: intranet, webmail, Senior, Shift LIS/Automação, etiquetas lab, chamados NTI, Effort, Xero Viewer, HBIS totem |
| `install\` | Instaladores: Acrobat Reader, AnyDesk, AIDA64, HWMonitor, Brother iPrint&Scan, Teams, OCS agent, PDF24, Samsung, ZebraDesigner, Digital Anatomy (`D:\santana\install\Microdata\DigitalAnatomia\`), WebCas (`webcas amb.exe`, `webcas hb.exe`) |
| `scripts\` | Scripts de manutenção (ver seção 6 e detalhamento abaixo) |
| `shift\` | Material Shift LIS: instalador (`ShiftAppInstall.exe`), `conserta shift.bat`, XMLs de integração, CSVs de rotas, documentação contratual (até 31.07.2026) |
| `solucoes doc\` | `configuracao DS22.pdf` — configuração de display/quiosque |
| `soulmv\` | Atalhos (Painel, Totem Senha), `.bat` helpers, `hosts` editado — suporte ao SoulMV/quiosque |
| `tools\` | Utilitários de partição: AOMEI, EASEUS (com instaladores) |
| `windows\windows 11 64-bit\` | Binários de boot/logon para reparo: `winload.efi`, `winload.exe`, `winlogon.exe` |

#### Detalhamento de `D:\santana\scripts\`

| Subpasta / Arquivo | Função |
|---|---|
| `servidores - lab\` | XMLs de Task Scheduler + PowerShell: reboot diário SRV-TS, snapshot de usuários TS, backup imagens Cobas |
| `x - coleta info pc\` | Inventário de PCs: `pc_info.ps1`, `concatena_sheets.py`, `requirements.txt`, JSON de amostra, runners silenciosos |
| `x - licensas\` | Wrapper em torno de `massgrave.ps1` — usar apenas em conformidade com política e legislação |
| Root (scripts avulsos) | Helpers AnyDesk, backup remoto, limpeza de temp, sincronização de relógio, instalação LAS, reparo Edge/HBIS/WMI, deploy Shift, mapeamento de disco, reset de rede, reboot, `gdistro.ps1` |

---

## 9. Pendências de Documentação

- [ ] Lista completa de equipamentos de microbiologia e biomolecular
- [ ] Descrição do módulo Shift View
- [ ] Detalhamento dos cenários de erro no SoulMV e suas soluções
- [ ] Ramais de Apoio, Bioquímica e Almoxarifado
- [ ] Scripts avulsos do `D:\santana\scripts\` root (descrição individual de cada um)
- [ ] Outros servidores ou sistemas não mencionados ainda
