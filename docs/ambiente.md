# Ambiente de TI — Laboratório HBASE
> Documento de referência técnica para uso no projeto Claude.
> Última atualização: 2026-06-24
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

### 3.3 AQURE
- **IP:** `172.30.57.101`
- **Acesso:** `.\administrator` / *(senha em cofre local)*

### 3.4 Impressora Diretoria
- **IP:** `172.30.57.9`
- **Acesso:** `admin` / *(senha em cofre local)*

### 3.5 Painel HLab
- **ID:** `1575619917`

### 3.6 Painel Lab
- **Hostname:** NTI-60200
- **IP:** `172.30.57.30`

### 3.7 Conta Lab (Gmail / GitHub)
- **E-mail:** `tilabcentral@gmail.com`
- **Senha:** *(cofre local)*

### 3.8 SRV-TS — Terminal Server
- **Função:** Acesso remoto ao sistema SoulMV para colaboradores de municípios vizinhos.
- **IP:** `10.10.10.124`
- **Acesso:** Via SophosVPN + Remote Desktop com credenciais individuais (`nome.sobrenome@hbase.local`)
- **Acesso administrativo:** Restrito a Pedro Santana e equipe de redes.
- **Scripts em produção:**
  - `C:\scripts\Get-TSUserSnapshot.ps1` — snapshot horário de usuários ativos e uso de RAM
  - `C:\scripts\DailyReboot.ps1` — reinicia o servidor diariamente às 23h30 com avisos de 5 e 1 minuto
  - `C:\scripts\TSUserSnapshots_YYYY-MM.csv` — CSV mensal gerado pelo snapshot

### 3.9 SRV-TS02 — Terminal Server
- **Função:** Acesso remoto ao sistema SoulMV para colaboradores de municípios vizinhos.
- **IP:** `10.10.10.125`
- **Acesso:** Via SophosVPN + Remote Desktop com credenciais individuais (`nome.sobrenome@hbase.local`)
- **Acesso administrativo:** Restrito a Pedro Santana e equipe de redes.
- **Scripts em produção:**
---

## 4. Equipamentos Laboratoriais

> Detalhamento completo (incluindo rotas de exames) em [`docs/equipamentos/equipamentos-laboratoriais.md`](equipamentos/equipamentos-laboratoriais.md).

### 4.1 Urinálise
| Equipamento | IP | Diretório de imagens |
|---|---|---|
| Cobas 6500 I | `172.30.27.150` | `D:\Shift\Dados\HOSPBASE\ImagensCobasI` |
| Cobas 6500 II | `172.30.27.151` | `D:\Shift\Dados\HOSPBASE\ImagensCobasII` |

- Enviam resultados numéricos e imagens de microscopia para o Shift Automação.
- Backup semanal automatizado via `Backup-CobasImages.ps1` (toda segunda-feira às 02h00).

### 4.2 Bioquímica
- **Cobas PRO I** (Rota R9) — bioquímica geral, marcadores tumorais (CA125, CEA, CA19.9), complementos, troponina. Resultados enviados para Automação.

### 4.3 Imunologia / Hormônios / Sorologias
- **Cobas PRO II** (Rota R8) — hormônios (TSH, T4, cortisol, insulina, testosterona, FSH, LH, prolactina), sorologias (HIV, hepatites, toxo, rubéola, CMV, sífilis, Chagas), ferritina, vitaminas B12 e D. Resultados enviados para Automação.

### 4.4 Hematologia
- XN 3100 (+ módulos R e L) — Sysmex
- XN 1000 — Sysmex
- XN 550 — Sysmex
- Micros 60 — ABX Pentra

### 4.5 Hemostasia
- STA Compact MAX — Stago
- STA R MAX — Stago

### 4.6 Gasometria
- ABL 800 — Radiometer (8 unidades)
- ABL 90 Flex — Radiometer

### 4.7 Imunologia (Abbott)
- i1000 — Abbott Architect
- i2000 — Abbott Architect

### 4.8 Alergologia
- ImmunoCap Export — Phadia
- ImmunoCap Query — Phadia

### 4.9 Imuno-hematologia
- IH 500 — Bio-Rad

### 4.10 Hemoglobina Glicada / VHS
- Premier Hb 9210 — Trinity Biotech
- Roller 20 — Alifax

### 4.11 Microbiologia
- Myla — bioMérieux

### 4.12 Biologia Molecular
- Cobas 6800 — Roche
- GeneXpert I e II — Cepheid

> Nota: nem todos os equipamentos possuem interface com o Shift Automação.

---

## 5. Sistemas

### 5.1 Shift (Pulsa pela Vida)
Sistema LIS principal do laboratório. Composto por 5 módulos, dos quais utilizamos:

**Links de acesso:**

| Sistema | URL |
|---|---|
| LIS | `http://hb.shiftcloud.com.br/main/app` |
| Etiquetas Lab | `https://hb.shiftcloud.com.br/shift/lis/hb/elis/s00.iu.Login2.cls` |
| Integração | `https://integracao.shiftcloud.com.br/shift/integracao/hospitaldebase/mv/s00.iu.Menu.cls` |
| Automação | `https://automacao.hospitaldebase.com.br/shift/automacao/hospbase/s00.iu.Menu.cls?OrigemLogin=Login` |
| P-512 (local) | `http://192.168.20.91:57774/shift/integracao/hb/cobas/s00.iu.Login.cls` |
| Resultados de Exames | `https://hb.shiftcloud.com.br/shift/lis/hb/elis/s01.iu.web.Login.cls?config=UNICO\\&sigla` |

**Credenciais de municípios para Resultados de Exames:** *(cofre local)*

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
- **Ramal Sala Administrativa:** 5024
- **Ramal Apoio:** 1422
- **Ramal Bioquímica:** 1423
- **Ramal Ambulatório:** 5456

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

## 9. Contatos Externos

| Entidade | Telefone |
|---|---|
| Hermes Pardini (apoio) | 31 3228-6646 |

---

## 10. Máscaras em PDF (erro no relatório de exportação)

Procedimentos que utilizam campo PDF e causam erro no relatório de exportação:

| Código Shift | Código SoulMV |
|---|---|
| 2247 | — |
| 1245 | 232 |
| 2299 | 741 |
| 2037 | — |
| 2321 | — |
| 2189 | — |
| 1629 | — |

---

## 11. Pendências de Documentação

- [x] Lista completa de equipamentos laboratoriais (atualizada 2026-06-24)
- [ ] Descrição do módulo Shift View
- [ ] Detalhamento dos cenários de erro no SoulMV e suas soluções
- [ ] Ramal do Almoxarifado
- [ ] Scripts avulsos do `D:\santana\scripts\` root (descrição individual de cada um)
- [ ] Outros servidores ou sistemas não mencionados ainda
