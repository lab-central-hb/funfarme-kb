# Visão Geral — Infraestrutura

O laboratório faz parte do complexo hospitalar da FUNFARME, integrado ao Hospital de Base de São José do Rio Preto.

## Domínio e Rede

- **Domínio:** HBASE
- A rede hospitalar é gerenciada por uma equipe de redes separada, que controla políticas via Active Directory.
- A equipe de TI do laboratório tem visibilidade limitada sobre a infraestrutura de rede — o foco é nos sistemas e equipamentos do laboratório.
- Acesso remoto para municípios: VPN (Sophos) + Remote Desktop.

## Servidores

O laboratório utiliza os seguintes servidores:

| Servidor | Função | SO |
|----------|--------|----|
| **Servidor Cloud (Shift)** | Hospeda o Shift LIS — mantido pela empresa Shift | Gerenciado externamente |
| **SRV-AUTOMA** | Interfaceamento dos equipamentos com o Shift (CachéITF) | Windows Server 2016 |
| **SRV-TS** | Acesso remoto ao SoulMV para municípios | Windows Server |
| **SRV-TS02** | Segundo servidor de acesso remoto ao SoulMV | Windows Server |

Para detalhes de cada servidor, consulte a página [Servidores](servidores.md).

## Equipamentos Laboratoriais

O laboratório possui equipamentos interfaceados com o Shift Automação nas seguintes áreas:

| Área | Equipamentos |
|------|-------------|
| Urinálise | Cobas 6500 I, Cobas 6500 II |
| Bioquímica / Imunologia | Cobas PRO I |
| Sorologias | Cobas PRO II |
| Hematologia | STA COMPACT MAX, STA R MAX, XN 3100, XN 1000, XN 550 |
| Microbiologia / Biomolecular | Documentação pendente |

Para detalhes, consulte a página [Equipamentos](equipamentos.md).

## Fluxo de Dados

O fluxo principal de resultados segue o caminho:

```
Equipamento → Shift Automação (SRV-AUTOMA) → Shift LIS (Cloud) → SoulMV
```

Para uma visão detalhada com diagrama, consulte [Fluxo de Resultados](../sistemas/fluxo-resultados.md).

## Estações de Trabalho

A rede do laboratório possui aproximadamente **255 estações de trabalho** (PCs), inventariadas por hostname. O inventário completo é mantido internamente pela equipe de TI.
