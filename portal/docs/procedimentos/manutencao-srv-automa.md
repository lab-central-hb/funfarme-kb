# Manutenção de Disco — SRV-AUTOMA

O servidor **SRV-AUTOMA** acumula logs, traces e arquivos de debug ao longo do tempo, exigindo manutenção periódica de espaço em disco.

---

## Verificação

1. Acessar o servidor **SRV-AUTOMA** via área de trabalho remota.
2. Abrir o **TreeSize** para identificar pastas que consomem mais espaço.
3. Avaliar e remover logs, traces e arquivos de debug antigos conforme necessário.

---

## Imagens dos Cobas (Urinálise)

Os equipamentos de urinálise **Cobas 6500 I** e **Cobas 6500 II** exportam imagens para o servidor. Em funcionamento normal, as imagens são consumidas pelo **Shift Automação** em segundos e removidas automaticamente após transferência bem-sucedida.

### Pastas de imagens

- `D:\Shift\Dados\HOSPBASE\ImagensCobasI`
- `D:\Shift\Dados\HOSPBASE\ImagensCobasII`

!!! warning "Imagens acumuladas = problema"
    Se forem encontradas imagens persistentes nessas pastas (ou nas pastas de backup correspondentes), isso indica falha no fluxo de exportação/consumo do Shift Automação. Investigar o serviço de automação antes de remover manualmente.
