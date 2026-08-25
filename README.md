<div align="center">

# `Sysinfo Shell`

### 🔍 Informações do sistema. Um único comando.

**Uma ferramenta leve, portátil e independente de dependências para obter informações essenciais do sistema diretamente pelo terminal.**

<br>

[![POSIX Shell](https://img.shields.io/badge/POSIX-Shell-111827?style=for-the-badge\&logo=gnu-bash\&logoColor=white)](https://pubs.opengroup.org/onlinepubs/9699919799/)
[![Linux](https://img.shields.io/badge/Linux-Support-111827?style=for-the-badge\&logo=linux\&logoColor=FCC624)](https://www.kernel.org/)
[![Windows](https://img.shields.io/badge/Windows-Support-111827?style=for-the-badge\&logo=windows\&logoColor=00A4EF)](https://www.microsoft.com/windows)
[![WSL](https://img.shields.io/badge/WSL-Support-111827?style=for-the-badge\&logo=linux\&logoColor=white)](https://learn.microsoft.com/windows/wsl/)
[![License](https://img.shields.io/badge/License-Open%20Source-111827?style=for-the-badge)](#-licença)

<br>

**Linux · Windows · WSL · Git Bash · MSYS2**

</div>

---

## ⚡ Visão geral

**Sysinfo Shell** é uma ferramenta de linha de comando desenvolvida em **POSIX Shell** para apresentar, de forma rápida e organizada, informações essenciais sobre o ambiente onde está sendo executada.

A ideia é simples:

> **Em vez de executar vários comandos diferentes para descobrir informações do sistema, execute apenas um.**

```sh
./sysinfo.sh
```

O programa detecta automaticamente o ambiente e utiliza diferentes estratégias de coleta conforme a plataforma.

Entre as informações coletadas estão:

* 🖥️ Sistema operacional
* 📦 Versão do sistema
* 🏷️ Hostname
* 👤 Usuário atual
* ⚙️ Kernel
* 🧬 Arquitetura
* 🔥 CPU
* 🧠 Núcleos
* 💾 Memória RAM
* 💿 Armazenamento
* 🌐 IP local
* 🌍 IP público
* ⏱️ Uptime
* 🕐 Data e hora

---

# ✦ Por que Sysinfo Shell?

No dia a dia, descobrir informações básicas de uma máquina normalmente exige vários comandos:

```sh
uname -a
hostname
whoami
df -h
free -h
ip addr
uptime
date
```

O Sysinfo Shell transforma isso em uma única experiência:

```sh
./sysinfo.sh
```

O objetivo não é substituir ferramentas avançadas de monitoramento.

O objetivo é oferecer uma **fotografia rápida do sistema**.

---

# 🎯 Filosofia

O projeto segue quatro princípios:

| Princípio         | Objetivo                                     |
| ----------------- | -------------------------------------------- |
| **Simplicidade**  | Fazer uma coisa e fazer bem                  |
| **Portabilidade** | Funcionar em diferentes ambientes            |
| **Resiliência**   | Ter alternativas quando comandos não existem |
| **Legibilidade**  | Mostrar informações de forma clara           |

A ferramenta foi construída para ser pequena do ponto de vista operacional, mesmo contendo diversas estratégias internas de fallback.

---

# 🖥️ Plataformas

| Plataforma         |                   Status                  |
| ------------------ | :---------------------------------------: |
| Linux              |                     ✅                     |
| Ubuntu             |                     ✅                     |
| Debian             |                     ✅                     |
| Fedora             |                     ✅                     |
| Arch Linux         |                     ✅                     |
| Kali Linux         |                     ✅                     |
| WSL                |                     ✅                     |
| Windows + Git Bash |                     ✅                     |
| Windows + MSYS2    |                     ✅                     |
| Windows + Cygwin   | ⚠️ Compatibilidade dependente do ambiente |

> **Observação:** Windows não fornece `/bin/sh` nativamente. Para executar o projeto no Windows é necessário um ambiente Unix-like como Git Bash, MSYS2, Cygwin ou WSL.

---

# ✨ Recursos

## 🖥️ Sistema

Exibe informações como:

```text
OS
Version
Hostname
User
Kernel
Architecture
```

---

## ⚡ Hardware

Informações relacionadas ao processador:

```text
CPU
CPU Cores
Architecture
```

No Linux, o script utiliza fontes como `/proc/cpuinfo`, `nproc` e `lscpu` quando disponíveis.

No Windows, utiliza mecanismos como `wmic` e variáveis de ambiente.

---

## 🧠 Memória

O sistema apresenta:

```text
RAM : usada / total
```

No Linux, a coleta utiliza `/proc/meminfo` e possui fallback para `free`.

No Windows, são utilizadas alternativas como `wmic` e `systeminfo`.

---

## 💿 Armazenamento

A ferramenta consulta o armazenamento principal e apresenta:

```text
Used / Total
```

Exemplo:

```text
Disk : 120GiB / 500GiB
```

No Linux, o mecanismo principal utiliza:

```sh
df -h
```

No Windows, o script tenta utilizar `df` e possui fallback através do `wmic`.

---

## 🌐 Rede

O Sysinfo Shell diferencia:

### IP local

Obtido diretamente do ambiente da máquina.

No Linux, existem múltiplos métodos de fallback:

```text
ip
hostname -I
ifconfig
```

No Windows:

```text
ipconfig
wmic
```

---

### 🌍 IP público

O IP público é obtido através de serviços externos.

O script possui múltiplos endpoints de fallback para aumentar a disponibilidade.

Exemplos utilizados:

```text
ifconfig.me
icanhazip.com
api.ipify.org
```

> ⚠️ A consulta do IP público requer conexão com a Internet e envia uma requisição para um serviço externo.

---

# 🎨 Interface

O projeto possui uma interface de terminal simples e visualmente organizada.

Exemplo:

```text
╔══════════════════════════════════════════════╗
║                 SYSTEM INFO                   ║
╠══════════════════════════════════════════════╣
║ OS           : Linux                         ║
║ Version      : Ubuntu 24.04 LTS              ║
║ Hostname     : workstation                   ║
║ User         : user                           ║
║ Kernel       : 6.8.0                         ║
║ Architecture : x86_64                        ║
║ CPU          : AMD Ryzen 5                   ║
║ Cores        : 12                             ║
║ RAM          : 5GiB / 16GiB                  ║
║ Disk         : 120GiB / 500GiB               ║
║ Local IP     : 192.168.1.100                 ║
║ Public IP    : xxx.xxx.xxx.xxx               ║
║ Uptime       : 2 days, 4h 32m                ║
║ Date         : 2026-08-25 20:30:00           ║
╚══════════════════════════════════════════════╝
```

A interface utiliza ANSI Colors apenas quando a saída está sendo realizada diretamente em um terminal.

Quando a saída é redirecionada para um arquivo, as cores são desabilitadas.

---

# 🧩 Arquitetura

Apesar de ser distribuído como um único arquivo, o script foi organizado internamente em funções especializadas.

```text
sysinfo.sh
│
├── 🎨 ANSI / Terminal
│
├── 🔍 Detecção do ambiente
│
├── 🧰 Helpers
│
├── 🖥️ Sistema operacional
│
├── 🏷️ Hostname
│
├── 👤 Usuário
│
├── ⚙️ Kernel
│
├── 🧬 Arquitetura
│
├── 🔥 CPU
│
├── 🧠 Núcleos
│
├── 💾 RAM
│
├── 💿 Disco
│
├── 🌐 IP local
│
├── 🌍 IP público
│
├── ⏱️ Uptime
│
├── 🕐 Data/Hora
│
└── 🎛️ Renderização
```

Essa organização facilita futuras extensões sem transformar o projeto em um script monolítico difícil de manter.

---

# 🐚 POSIX Shell

Um dos principais objetivos técnicos do projeto é utilizar **POSIX Shell**, em vez de depender exclusivamente do Bash.

O script inicia com:

```sh
#!/bin/sh
```

E evita recursos específicos do Bash, como:

```bash
[[ ... ]]
```

arrays Bash:

```bash
array=(one two three)
```

e:

```bash
source file.sh
```

O projeto prioriza construções portáveis como:

```sh
if
case
for
while
command -v
```

Isso permite que o mesmo código seja utilizado em uma variedade maior de ambientes.

---

# 🔍 Detecção de ambiente

O sistema começa identificando o ambiente através de:

```sh
uname -s
```

A lógica diferencia ambientes como:

```text
Linux
Linux (WSL)
Windows
Unknown
```

### Linux

Quando `uname` retorna algo iniciado por:

```text
Linux
```

o ambiente é tratado como Linux.

---

### WSL

O script também verifica:

```text
/proc/version
```

procurando indicadores de Microsoft/WSL.

Quando identificado:

```text
OS : Linux (WSL)
```

---

### Windows

Ambientes:

```text
MSYS
MINGW
CYGWIN
```

são identificados como:

```text
Windows
```

Isso permite adaptar a coleta para os comandos disponíveis no ambiente.

---

# 🛡️ Sistema de fallback

Um dos pontos mais importantes da implementação é que o script **não presume que todos os comandos estarão instalados**.

Existe uma função auxiliar:

```sh
has_cmd()
```

que verifica a existência de comandos utilizando:

```sh
command -v
```

Conceitualmente:

```sh
if has_cmd curl; then
    ...
fi
```

Isso permite que o programa tente diferentes fontes.

A estratégia geral é:

```text
┌──────────────────────┐
│ Fonte principal      │
└──────────┬───────────┘
           ↓
     disponível?
      ↙       ↘
    SIM       NÃO
     ↓         ↓
  retorna   fallback
              ↓
        outra fonte
              ↓
        outra fonte
              ↓
             N/A
```

---

# 🧱 Graceful Degradation

Se uma determinada informação não puder ser obtida, o programa não deve comprometer o restante do relatório.

Exemplo:

```text
CPU          : AMD Ryzen 5
RAM          : 8GiB / 16GiB
Disk         : 120GiB / 500GiB
Local IP     : 192.168.1.20
Public IP    : N/A
```

Em vez de interromper a execução inteira, a informação indisponível recebe:

```text
N/A
```

---

# 📊 Fontes de informação

O projeto utiliza diferentes fontes dependendo do sistema.

| Informação  | Linux                          | Windows                       |
| ----------- | ------------------------------ | ----------------------------- |
| OS          | `uname`                        | `uname`                       |
| Versão      | `/etc/os-release`              | `wmic` / `systeminfo` / `cmd` |
| Hostname    | `hostname`                     | `hostname`                    |
| Usuário     | `whoami`                       | `whoami`                      |
| Kernel      | `uname -r`                     | `uname -r`                    |
| Arquitetura | `uname -m`                     | `PROCESSOR_ARCHITECTURE`      |
| CPU         | `/proc/cpuinfo` / `lscpu`      | `wmic` / env                  |
| Núcleos     | `nproc` / `/proc/cpuinfo`      | env / `wmic`                  |
| RAM         | `/proc/meminfo` / `free`       | `wmic` / `systeminfo`         |
| Disco       | `df`                           | `df` / `wmic`                 |
| IP local    | `ip` / `hostname` / `ifconfig` | `ipconfig` / `wmic`           |
| IP público  | `curl` / `wget`                | `curl` / `wget`               |
| Uptime      | `uptime` / `/proc/uptime`      | ferramentas disponíveis       |
| Data        | `date`                         | `date`                        |

---

# 📦 Dependências

O projeto não possui framework ou runtime adicional.

Ele utiliza comandos disponíveis no ambiente.

Entre os comandos que podem ser utilizados estão:

```text
sh
uname
hostname
whoami
grep
sed
awk
cut
head
tail
tr
wc
date
df
uptime
curl
wget
ip
ifconfig
free
nproc
lscpu
systeminfo
wmic
ipconfig
cmd
```

Nem todos são necessários em todas as plataformas.

O sistema verifica comandos opcionais antes de utilizá-los.

---

# 🚀 Instalação

## 1. Clone o repositório

```sh
git clone https://github.com/excanear/Sysinfo-Shell.git
```

## 2. Entre no projeto

```sh
cd Sysinfo-Shell
```

## 3. Dê permissão de execução

Linux / WSL / MSYS2:

```sh
chmod +x sysinfo.sh
```

## 4. Execute

```sh
./sysinfo.sh
```

---

# ⚡ Execução rápida

Se o repositório já estiver clonado:

```sh
cd Sysinfo-Shell && chmod +x sysinfo.sh && ./sysinfo.sh
```

---

# 🪟 Windows

## Git Bash

Abra o Git Bash:

```sh
cd /c/caminho/do/projeto
```

Execute:

```sh
./sysinfo.sh
```

Ou:

```sh
sh sysinfo.sh
```

---

## MSYS2

Abra o terminal MSYS2:

```sh
cd /c/caminho/do/projeto
```

Execute:

```sh
./sysinfo.sh
```

---

## WSL

No WSL:

```sh
git clone https://github.com/excanear/Sysinfo-Shell.git
cd Sysinfo-Shell
chmod +x sysinfo.sh
./sysinfo.sh
```

O programa deverá identificar o ambiente como:

```text
Linux (WSL)
```

---

# 📄 Redirecionamento

Como o relatório é enviado para `stdout`, ele pode ser redirecionado normalmente.

### Salvar em arquivo

```sh
./sysinfo.sh > system-info.txt
```

### Visualizar e salvar simultaneamente

```sh
./sysinfo.sh | tee system-info.txt
```

### Filtrar uma informação

```sh
./sysinfo.sh | grep RAM
```

---

# 🔧 Desenvolvimento

Clone:

```sh
git clone https://github.com/excanear/Sysinfo-Shell.git
cd Sysinfo-Shell
```

Execute:

```sh
sh sysinfo.sh
```

Durante o desenvolvimento, recomenda-se testar diretamente com:

```sh
sh -n sysinfo.sh
```

para verificar erros básicos de sintaxe.

Também é recomendável testar o comportamento em diferentes shells e ambientes.

---

# 🧪 Matriz de testes

| Ambiente   | Teste |
| ---------- | :---: |
| Ubuntu     |   ✅   |
| Debian     |   ✅   |
| Fedora     |   ✅   |
| Arch       |   ✅   |
| Kali Linux |   ✅   |
| WSL        |   ✅   |
| Git Bash   |   ✅   |
| MSYS2      |   ✅   |
| Cygwin     |   ⚠️  |

O comportamento de determinadas informações pode variar conforme os comandos instalados e permissões disponíveis.

---

# 🔐 Segurança

O Sysinfo Shell foi projetado como uma ferramenta **informativa**.

Ele não realiza:

* exploração de vulnerabilidades;
* alteração de firewall;
* alteração de permissões;
* criação de usuários;
* alteração de configurações;
* instalação automática de software;
* persistência;
* varredura de hosts remotos.

A principal operação externa é a consulta opcional do endereço IP público.

---

# 🌍 Privacidade

Existe uma diferença importante entre:

```text
IP LOCAL
```

e:

```text
IP PÚBLICO
```

O IP local é coletado diretamente da máquina.

O IP público é obtido através de uma requisição externa.

Portanto, ao utilizar a funcionalidade de IP público, o computador precisa acessar um serviço externo.

Em ambientes altamente restritos ou offline, o campo poderá retornar:

```text
Public IP : N/A
```

---

# 🧠 Casos de uso

## 👨‍💻 Desenvolvimento

Verificar rapidamente o ambiente de desenvolvimento:

```text
Qual SO?
Qual arquitetura?
Qual kernel?
Qual CPU?
Quanta RAM?
Qual IP?
```

---

## 🖥️ Administração

Ao acessar uma máquina pela primeira vez:

```sh
./sysinfo.sh
```

é possível obter rapidamente uma visão geral do ambiente.

---

## 🔧 Troubleshooting

Útil para obter informações iniciais antes de investigar um problema.

---

## 🧪 Laboratórios

Pode ser utilizado em:

* laboratórios Linux;
* máquinas virtuais;
* ambientes de desenvolvimento;
* WSL;
* máquinas de teste;
* ambientes educacionais.

---

## 📚 Aprendizado

O código também pode ser utilizado como referência para estudar:

* POSIX Shell;
* funções;
* `case`;
* `if`;
* pipelines;
* parsing de texto;
* `/proc`;
* variáveis de ambiente;
* detecção de SO;
* fallback de comandos;
* ANSI colors;
* portabilidade.

---

# 🗂️ Estrutura do projeto

```text
Sysinfo-Shell/
│
├── sysinfo.sh
│
└── README.md
```

### `sysinfo.sh`

Implementação completa da ferramenta.

### `README.md`

Documentação do projeto.

---

# 🧭 Roadmap

O projeto pode evoluir mantendo a filosofia de simplicidade.

## CLI

```text
sysinfo --help
sysinfo --version
sysinfo --system
sysinfo --hardware
sysinfo --network
```

---

## Formatos de saída

Possíveis formatos futuros:

```sh
sysinfo --json
sysinfo --plain
sysinfo --compact
```

---

## Hardware

Possíveis extensões:

```text
GPU
BIOS
Motherboard
Battery
Temperature
Disk health
```

---

## Rede

Possíveis extensões:

```text
Gateway
DNS
Interfaces
MAC address
IPv4
IPv6
```

---

## Ambiente

Possíveis extensões:

```text
Docker
Podman
VM
Container
Desktop Environment
Display Server
Shell
Package Manager
```

---

# 🤝 Contribuindo

Contribuições são bem-vindas.

Antes de abrir um Pull Request:

1. Mantenha o código POSIX sempre que possível.
2. Evite dependências desnecessárias.
3. Adicione fallbacks quando apropriado.
4. Não quebre ambientes existentes.
5. Teste em mais de uma plataforma.
6. Mantenha funções pequenas e objetivas.
7. Atualize a documentação quando necessário.

---

# 🧩 Adicionando novas informações

Novos collectors devem seguir uma estrutura semelhante:

```sh
get_example() {
    _value="N/A"

    if has_cmd example-command; then
        _value=$(example-command 2>/dev/null)
    fi

    if [ -z "${_value}" ]; then
        _value="N/A"
    fi

    echo "${_value}"

    unset _value
}
```

A função deve:

1. Definir um fallback.
2. Verificar se o comando existe.
3. Executar silenciosamente quando apropriado.
4. Validar o resultado.
5. Retornar `N/A` quando necessário.
6. Liberar variáveis temporárias.

---

# 📐 Princípios de desenvolvimento

### 01 — Portabilidade

Priorize POSIX Shell.

### 02 — Simplicidade

Não introduza uma dependência quando um comando padrão resolver o problema.

### 03 — Fallback

Sempre que possível:

```text
Método A
   ↓
Método B
   ↓
Método C
   ↓
N/A
```

### 04 — Resiliência

Uma informação indisponível não deve derrubar o programa inteiro.

### 05 — Clareza

O usuário deve entender o resultado imediatamente.

---

# ⚠️ Limitações atuais

O projeto atualmente é propositalmente focado em **snapshot de sistema**.

Não é:

* um monitor em tempo real;
* um dashboard;
* um SIEM;
* um scanner;
* uma ferramenta de inventário corporativo;
* um monitor de processos;
* uma plataforma de observabilidade.

Ele responde essencialmente:

> **"Como está esta máquina agora?"**

---

# 📈 Possíveis evoluções

Uma evolução natural seria transformar o projeto em uma pequena suíte:

```text
sysinfo
│
├── system
├── hardware
├── memory
├── storage
├── network
├── processes
├── services
└── report
```

Mantendo, porém, a característica principal:

> **rápido, simples e portátil.**

---

# 📝 Licença

Este projeto é distribuído como software open source.

Caso uma licença formal seja adicionada ao repositório, esta seção deve ser atualizada para refletir exatamente os termos definidos no arquivo `LICENSE`.

---

# 👤 Autor

Desenvolvido por **excanear**.

GitHub:

https://github.com/excanear

Repositório:

https://github.com/excanear/Sysinfo-Shell

---

<div align="center">

## `Sysinfo Shell`

**Uma visão rápida do seu sistema.**

<br>

`POSIX Shell` · `Linux` · `Windows` · `WSL`

<br>

⭐ Se o projeto for útil, considere deixar uma estrela no repositório.

</div>
