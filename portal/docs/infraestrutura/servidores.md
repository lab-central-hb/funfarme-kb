# Servidores

Detalhamento dos servidores utilizados pelo laboratório.

## Servidor Cloud — Shift LIS

- **Função:** Hospeda o sistema Shift LIS.
- **Manutenção:** Exclusiva da empresa Shift — sem acesso direto pela equipe de TI do laboratório.

## SRV-AUTOMA — Servidor de Automação

- **Função:** Interfaceamento dos equipamentos laboratoriais com o Shift.
- **SO:** Windows Server 2016
- **Serviço principal:** CachéITF
- **Responsabilidade:** Recebe resultados dos equipamentos (Cobas, XN, STA, etc.) e os envia ao Shift LIS.
- **Backup:** Script automatizado de backup semanal das imagens de microscopia dos Cobas 6500.

## SRV-TS — Terminal Server

- **Função:** Acesso remoto ao sistema SoulMV para colaboradores de municípios vizinhos.
- **Acesso:** Via SophosVPN + Remote Desktop com credenciais individuais.
- **Acesso administrativo:** Restrito ao analista de TI e equipe de redes.
- **Scripts em produção:**
    - Snapshot horário de usuários ativos e uso de RAM
    - Reinício diário programado às 23h30 com avisos aos usuários

## SRV-TS02 — Terminal Server (secundário)

- **Função:** Segundo servidor de acesso remoto ao SoulMV, complementando o SRV-TS.
- **Acesso:** Mesma estrutura do SRV-TS (VPN + RDP).
- **Acesso administrativo:** Restrito ao analista de TI e equipe de redes.
