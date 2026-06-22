# Instalação Shift em Municípios

Procedimento para configurar computadores de unidades de coleta em municípios integrados.

---

## O que instalar

| Cenário | Instalar |
|---------|----------|
| Apenas sala de coleta (etiquetas e registro de coletas) | Shift |
| Cadastros de pacientes no MV | Sophos VPN + Shift |

---

## Passo a passo

### 1. Preparar arquivos

Copiar todos os arquivos da pasta **Fluxo Hospital de Base** para o computador.

### 2. Instalar Sophos Connect (se necessário)

!!! note "Requer permissão de administrador"

1. Acessar `https://vpn.hospitaldebase.com.br:4442/`
2. Login com usuário e senha de rede da pessoa que utilizará o computador.
3. Baixar o **SSL VPN client** e executar.

### 3. Instalar Shift

1. Baixar `ShiftAppInstall.exe` e executar como administrador.
2. Aceitar todas as permissões durante a instalação.

### 4. Configurar Shift LIS

1. Acessar `hb.shiftcloud.com.br` e logar com o usuário.
2. Clicar em **Permitir** na janela superior esquerda.
3. Nome do usuário > **Saída de impressão e arquivos** > Perfil de impressão: **perfil HB** > Salvar.

### 5. Configurar Etiquetas

1. Acessar o link de **Etiquetas Laboratório**.
2. Em **Atendimento > Monitor de O.S.**:
    - Selecionar a unidade de coleta correspondente ao município (lupinha)
    - Adicionar todos os procedimentos (lupinha)
    - Selecionar **Origem > Integração**
    - Filtrar
    - No canto inferior, selecionar **500 registros por página**

### 6. Configurar Resultados de Exames

1. Acessar o link de Resultados de Exames.
2. Usar as credenciais do município correspondente.

### 7. Criar atalhos

Criar atalhos na área de trabalho para:

- :material-check: Link de **Etiquetas Laboratório**
- :material-check: Link de **Resultados de Exames**
- :material-close: **Não** criar atalho para `hb.shiftcloud.com.br`

---

## Troubleshooting

Se o Shift travar ou ficar em loop de carregamento:

```bat
taskkill /F /IM javaw.exe
```

Disponível como `.bat` no kit de instalação. Ao executar, reabre o serviço Shift automaticamente.
