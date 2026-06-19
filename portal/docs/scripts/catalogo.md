# Catálogo de Scripts

Scripts de manutenção e automação utilizados pela equipe de TI.

## Scripts de Servidor

| Script | Servidor | Função | Agendamento |
|--------|----------|--------|-------------|
| Backup-CobasImages | SRV-AUTOMA | Move pastas de imagens de microscopia dos Cobas 6500 para backup mensal | Semanal (segunda, 02h00) |
| Get-TSUserSnapshot | SRV-TS | Captura snapshot horário de sessões ativas e uso de RAM | A cada 1 hora |
| DailyReboot | SRV-TS | Reinício diário com avisos de 5 e 1 minuto aos usuários | Diário, 23h30 |

## Scripts de Manutenção de Estações

| Script | Função |
|--------|--------|
| Conectar rede | Configuração de rede da estação |
| Sincroniza relógio | Sincronização de horário com servidor NTP |
| Exclui temp | Limpeza de arquivos temporários |
| AnyDesk | Configuração do AnyDesk para suporte remoto |
| Backup remoto | Backup de dados da estação |
| Reseta rede | Reset de configurações de rede |
| Mapear discos | Mapeamento de unidades de rede |

## Scripts de Deploy

| Script | Função |
|--------|--------|
| Deploy Shift | Instalação/atualização do client Shift nas estações |
| Conserta Shift | Correção de problemas comuns do client Shift |
| Instala LAS | Instalação do sistema LAS |
| Repara/Atualiza HBIS | Reparo do sistema HBIS |
| Painel Edge | Configuração do Microsoft Edge para modo quiosque |

## Scripts de Inventário

| Script | Função |
|--------|--------|
| pc_info (PowerShell) | Coleta informações de hardware e software de estações |
| concatena_sheets (Python) | Consolida dados de inventário coletados em planilha única |

## Etiquetas

| Script | Função |
|--------|--------|
| Etiquetas Microbiologia | Geração de etiquetas específicas para o setor de microbiologia |
