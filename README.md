# Sysinfo Shell

<div align="center">

# `Sysinfo Shell`

### Lightweight Cross-Platform System Information Tool

**A simple, portable and dependency-conscious system information utility written entirely in POSIX Shell.**

[![Shell](https://img.shields.io/badge/Shell-POSIX%20sh-4EAA25?style=for-the-badge\&logo=gnu-bash\&logoColor=white)](https://www.gnu.org/software/bash/)
[![Linux](https://img.shields.io/badge/Linux-Supported-FCC624?style=for-the-badge\&logo=linux\&logoColor=black)](https://www.kernel.org/)
[![Windows](https://img.shields.io/badge/Windows-Supported-0078D4?style=for-the-badge\&logo=windows\&logoColor=white)](https://www.microsoft.com/windows)
[![WSL](https://img.shields.io/badge/WSL-Supported-0D1117?style=for-the-badge\&logo=linux\&logoColor=white)](https://learn.microsoft.com/windows/wsl/)
[![License](https://img.shields.io/badge/License-Open%20Source-blue?style=for-the-badge)](#license)

</div>

---

## Overview

**Sysinfo Shell** is a lightweight command-line utility designed to provide a quick overview of the most important information about the machine where it is executed.

Instead of manually running several commands such as `uname`, `hostname`, `df`, `ip`, `free`, `uptime`, and other system utilities, Sysinfo Shell gathers the available information and presents it in a single, clean terminal interface.

The project is intentionally implemented using **POSIX Shell (`/bin/sh`)**, avoiding Bash-specific features and unnecessary dependencies.

The current implementation is designed to work with:

* Linux
* Windows through Git Bash
* Windows through MSYS2
* Windows through compatible MSYS/MINGW environments
* Windows through WSL

The script automatically detects the environment and selects the appropriate collection strategy for the detected operating system.

---

## Why Sysinfo Shell?

System information is often the first thing needed when troubleshooting a machine, documenting an environment, checking a development workstation, or quickly identifying the characteristics of a remote system.

Without a tool like this, a user may need to execute multiple commands:

```text
uname -a
hostname
whoami
free -h
df -h
ip addr
uptime
date
```

Sysinfo Shell consolidates these checks into one execution:

```sh
./sysinfo.sh
```

The result is a compact system overview designed to be immediately readable.

---

## Features

### System Information

The tool collects and displays:

* Operating system
* Operating system version
* Hostname
* Current user
* Kernel version
* System architecture
* CPU model
* CPU logical cores
* RAM usage
* Disk usage
* Local IPv4 address
* Public IPv4 address
* System uptime
* Current date and time

---

### Cross-Platform Detection

Sysinfo Shell identifies the environment automatically.

The script uses `uname` and platform-specific characteristics to distinguish between:

```text
Linux
Linux (WSL)
Windows
Unknown
```

For Linux environments, the script also checks whether it is running under WSL.

For Windows environments, it supports shells commonly exposing Windows functionality through:

* MSYS
* MINGW
* Cygwin-compatible environments

This allows the same `.sh` file to adapt its behavior instead of requiring completely separate scripts.

---

## POSIX Shell

One of the project's main technical goals is keeping the implementation portable.

The script begins with:

```sh
#!/bin/sh
```

It intentionally avoids Bash-specific constructs such as:

```bash
[[ ... ]]
```

Bash arrays:

```bash
array=(one two three)
```

and other Bash-only language features.

The implementation instead relies on traditional POSIX Shell constructs such as:

```sh
case
if
for
while
functions
command -v
```

This makes the script suitable for a much broader range of Unix-like shell environments.

---

## Supported Environments

### Linux

Native Linux environments are the primary Unix target.

Typical environments include:

* Ubuntu
* Debian
* Fedora
* Arch Linux
* Linux Mint
* Kali Linux
* Rocky Linux
* AlmaLinux
* openSUSE
* Other Linux distributions providing standard Unix utilities

The script primarily uses standard interfaces such as:

```text
/proc
/etc/os-release
```

when available.

---

### Windows

Windows does not natively provide a POSIX `/bin/sh` environment.

Therefore, Sysinfo Shell runs on Windows through environments that provide a Unix-compatible shell layer.

Supported approaches include:

#### Git Bash

Git Bash provides a Unix-like shell environment on Windows and is one of the easiest ways to execute the script.

#### MSYS2

MSYS2 provides a Unix-like environment with a POSIX-compatible shell and common command-line utilities.

#### WSL

Windows Subsystem for Linux provides a genuine Linux userspace running on Windows.

In WSL, Sysinfo Shell detects the environment as:

```text
Linux (WSL)
```

---

## Installation

Sysinfo Shell does not require a traditional installation process.

Clone the repository:

```sh
git clone https://github.com/excanear/Sysinfo-Shell.git
```

Enter the directory:

```sh
cd Sysinfo-Shell
```

Then execute:

```sh
./sysinfo.sh
```

---

## Alternative Execution

The script can also be executed explicitly through `sh`:

```sh
sh sysinfo.sh
```

This is useful when the executable permission has not been configured.

On Linux, executable permissions can be added with:

```sh
chmod +x sysinfo.sh
```

Then:

```sh
./sysinfo.sh
```

---

# Usage

Sysinfo Shell is intentionally simple.

Run:

```sh
./sysinfo.sh
```

No arguments are currently required.

The program automatically:

1. Detects the operating system.
2. Determines the available information sources.
3. Collects system information.
4. Applies platform-specific fallbacks when necessary.
5. Formats the results.
6. Displays the final report.

---

# Example Output

A typical execution produces an interface similar to:

```text
╔══════════════════════════════════════════════╗
║                 SYSTEM INFO                   ║
╠══════════════════════════════════════════════╣
║ OS           : Linux                         ║
║ Version      : Ubuntu 24.04 LTS              ║
║ Hostname     : workstation                   ║
║ User         : user                           ║
║ Kernel       : 6.x.x                          ║
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

Values naturally vary according to the machine and environment.

---

# Information Collection

## Operating System

The operating system is determined using:

```sh
uname -s
```

Linux environments are identified through the kernel name.

Windows environments exposed through MSYS/MINGW/Cygwin are identified through their corresponding `uname` output.

WSL is additionally detected through `/proc/version`.

---

## Operating System Version

### Linux

The script prioritizes:

```text
/etc/os-release
```

and reads `PRETTY_NAME` when available.

Fallbacks include:

```text
lsb_release
/etc/issue
```

This approach allows the script to continue operating even when a particular distribution utility is unavailable.

### Windows

The script attempts multiple sources, including:

```text
wmic
systeminfo
cmd.exe /c ver
```

depending on what is available in the execution environment.

---

## Hostname

The hostname is obtained through:

```sh
hostname
```

If the command is unavailable or returns no usable result, the tool reports:

```text
N/A
```

---

## Current User

The current user is normally detected through:

```sh
whoami
```

with an environment-variable fallback when necessary.

---

## Kernel

Kernel information is collected through:

```sh
uname -r
```

This is particularly useful for Linux and WSL environments.

---

## Architecture

The script uses:

```sh
uname -m
```

when available.

Windows-specific environment information can also be used as a fallback.

For example:

```text
AMD64 → x86_64
ARM64 → ARM64
x86   → x86
```

---

# CPU Information

Sysinfo Shell uses platform-specific mechanisms to obtain the processor model.

### Linux

The primary source is:

```text
/proc/cpuinfo
```

with `lscpu` used as an additional fallback.

### Windows

The script attempts to use:

```text
wmic
```

and can fall back to:

```text
PROCESSOR_IDENTIFIER
```

when available.

---

# CPU Cores

Linux environments can use:

```sh
nproc
```

with `/proc/cpuinfo` as a fallback.

Other available mechanisms may also be used when appropriate.

Windows environments can use:

```text
NUMBER_OF_PROCESSORS
```

or `wmic` when available.

---

# Memory Information

The tool reports memory in the following general form:

```text
Used / Total
```

For example:

```text
RAM : 5GiB / 16GiB
```

On Linux, the script reads `/proc/meminfo` and calculates memory usage from the available memory information.

Fallback mechanisms include:

```sh
free
```

and additional `/proc/meminfo` parsing.

On Windows, the script attempts Windows-specific mechanisms such as:

```text
wmic
systeminfo
```

when available.

---

# Disk Information

Disk usage is obtained through:

```sh
df -h
```

The primary filesystem is inspected and displayed in a compact form:

```text
Used / Total
```

Example:

```text
Disk : 120GiB / 500GiB
```

Windows environments can also use `df` when provided by the shell environment, with additional Windows-specific fallbacks.

---

# Local IP Address

Sysinfo Shell attempts to identify the machine's local IPv4 address.

### Linux

Possible sources include:

```text
ip
hostname -I
ifconfig
```

Loopback addresses such as:

```text
127.0.0.1
```

are excluded when possible.

### Windows

The script can use:

```text
ipconfig
```

and, where available:

```text
wmic
```

---

# Public IP Address

The public IP feature requires network access.

The script attempts to query public IP services through:

```text
curl
```

or:

```text
wget
```

It uses multiple fallback endpoints to improve resilience.

The implementation also performs a basic IPv4-format validation before accepting the result.

If no service is reachable, the output becomes:

```text
N/A
```

### Privacy Consideration

The public IP lookup necessarily sends a request to an external service.

If you are running Sysinfo Shell in a sensitive environment where external network requests are undesirable, consider removing or disabling the public IP functionality before execution.

---

# Uptime

### Linux

The script attempts:

```sh
uptime -p
```

and falls back to:

```sh
uptime
```

or `/proc/uptime`.

The output is normalized into a human-readable representation.

Example:

```text
Uptime : 2 days, 4h 32m
```

### Windows

Depending on the environment, the script may use:

```text
uptime
systeminfo
wmic
```

to obtain uptime or boot-time information.

---

# Date and Time

The current date and time are obtained through:

```sh
date "+%Y-%m-%d %H:%M:%S"
```

Example:

```text
Date : 2026-08-25 20:30:00
```

---

# Terminal Interface

The output is intentionally designed to be easy to scan.

The script creates a bordered information panel using Unicode box-drawing characters:

```text
╔══════════════════════════════════════════════╗
║                 SYSTEM INFO                   ║
╠══════════════════════════════════════════════╣
║ OS           : Linux                         ║
║ Version      : Ubuntu 24.04                  ║
║ ...                                            ║
╚══════════════════════════════════════════════╝
```

The interface uses ANSI colors when standard output is attached to a terminal.

When output is redirected or piped, colors are disabled automatically.

For example:

```sh
./sysinfo.sh > report.txt
```

will produce plain text without terminal color escape sequences.

---

# Architecture

The script follows a modular internal structure even though the project consists of a single Shell file.

Conceptually, the implementation is organized into:

```text
sysinfo.sh
│
├── Color configuration
│
├── Environment detection
│
├── Utility helpers
│
├── Operating system information
│
├── Host information
│
├── CPU information
│
├── Memory information
│
├── Storage information
│
├── Network information
│
├── Uptime information
│
├── Date/time information
│
├── Output formatting
│
└── Main execution
```

This makes individual information collectors easier to understand and modify.

---

# Internal Functions

The current script contains dedicated functions for the main information categories.

Examples include:

```text
detect_os()
get_os_name()
get_os_version()
get_hostname()
get_user()
get_kernel()
get_arch()
get_cpu()
get_cores()
get_ram()
get_disk()
get_local_ip()
get_public_ip()
get_uptime()
get_date()
pad_right()
print_info()
main()
```

Each collector is responsible for obtaining a specific category of information.

This structure avoids putting the entire program into one large procedural block.

---

# Command Availability Detection

A key part of the implementation is the helper:

```sh
has_cmd()
```

It uses:

```sh
command -v
```

to determine whether a command exists before attempting to execute it.

Conceptually:

```sh
if has_cmd curl; then
    ...
fi
```

This prevents missing optional utilities from unnecessarily terminating the script.

The goal is graceful degradation.

---

# Graceful Fallbacks

Sysinfo Shell does not assume that every environment has exactly the same utilities.

Instead, many information collectors follow a fallback strategy.

For example:

```text
Primary source
      ↓
Alternative source
      ↓
Secondary fallback
      ↓
N/A
```

This is especially important for cross-platform Shell applications because the available command set can differ considerably between Linux distributions, Git Bash, MSYS2, WSL and Windows environments.

---

# Missing Information

When information cannot be retrieved, Sysinfo Shell does not intentionally fail the entire report.

Instead, unavailable information is represented as:

```text
N/A
```

For example:

```text
CPU          : N/A
Public IP    : N/A
```

This allows the remaining system information to continue being displayed.

---

# Dependencies

Sysinfo Shell does not require a package manager or application framework.

It relies primarily on standard shell utilities and operating-system interfaces.

Depending on the operating system and the information being collected, the script may use utilities such as:

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

Not every command is required on every platform.

The script checks for optional commands before using them.

---

# No Root Required

Sysinfo Shell is designed to run as a normal user.

You normally do **not** need:

```sh
sudo
```

or administrator privileges.

Simply execute:

```sh
./sysinfo.sh
```

Some information may naturally be unavailable because of operating-system permissions or environment restrictions.

---

# Security Considerations

Sysinfo Shell is primarily an information-display utility.

It does not attempt to:

* modify system configuration
* change firewall rules
* install packages
* modify users
* change permissions
* exploit vulnerabilities
* scan remote hosts
* modify network configuration
* persist itself on the system

The main external interaction is the optional public-IP lookup.

---

# Network Privacy

The local IP address is collected locally.

The public IP address requires an external HTTP/HTTPS request.

Therefore:

```text
Local IP
└── collected locally

Public IP
└── obtained through an external service
```

If operating in a restricted, isolated or privacy-sensitive environment, be aware of this distinction.

---

# Performance

Sysinfo Shell is designed to be lightweight.

The script performs a relatively small number of short-lived system queries and exits after generating the report.

It is not intended to be a continuous monitoring platform.

For example, it does **not** currently provide:

```text
CPU monitoring
RAM monitoring
Disk monitoring
Network monitoring
Process monitoring
Historical metrics
Graphs
Dashboards
```

Its purpose is a **quick snapshot**, not continuous telemetry.

---

# Use Cases

Sysinfo Shell can be useful for:

### Troubleshooting

Quickly identify:

* OS version
* kernel
* CPU
* memory
* disk
* networking
* uptime

---

### Server Administration

When connecting to an unfamiliar server:

```sh
./sysinfo.sh
```

provides a quick environmental overview.

---

### Development

Useful when determining:

```text
Which OS am I running?
Which architecture?
Which kernel?
How much RAM?
Which CPU?
What is my IP?
```

---

### Documentation

The output can be redirected:

```sh
./sysinfo.sh > system-info.txt
```

creating a simple text report.

---

### Support

Instead of asking a user to manually execute several commands, a support workflow can request the output of:

```sh
./sysinfo.sh
```

and use the resulting snapshot as an initial diagnostic reference.

---

### Learning Shell

The project can also serve as a practical example of:

* POSIX Shell
* functions
* command detection
* conditional logic
* `case`
* pipelines
* text processing
* environment detection
* platform-specific fallbacks
* terminal formatting
* defensive scripting

---

# Portability Philosophy

The project follows a simple principle:

> **Use the simplest available mechanism, provide fallbacks, and gracefully handle missing information.**

Rather than assuming that every machine has the same command set, the script adapts to the environment.

This is particularly important for Shell applications because:

```text
Linux ≠ Git Bash ≠ MSYS2 ≠ WSL
```

even when they provide similar command-line interfaces.

---

# Why POSIX `sh` Instead of Bash?

Bash is extremely powerful, but it is not the only Shell implementation.

A project intentionally targeting `/bin/sh` can potentially operate in environments where Bash is unavailable or where `/bin/sh` points to another POSIX-compatible implementation.

Using POSIX-oriented syntax also encourages simpler and more portable shell programming.

Sysinfo Shell therefore avoids Bash-specific language features wherever possible.

---

# Project Structure

The repository currently has a deliberately minimal structure:

```text
Sysinfo-Shell/
│
├── sysinfo.sh
└── README.md
```

### `sysinfo.sh`

The main executable Shell script.

It contains:

* OS detection
* system information collectors
* platform-specific fallbacks
* terminal formatting
* program entry point

### `README.md`

Project documentation.

---

# Development

Clone the project:

```sh
git clone https://github.com/excanear/Sysinfo-Shell.git
cd Sysinfo-Shell
```

Make the script executable:

```sh
chmod +x sysinfo.sh
```

Run it:

```sh
./sysinfo.sh
```

---

# Testing

Because this is a cross-platform Shell project, testing should ideally be performed in multiple environments.

Recommended test matrix:

| Environment        | Expected    |
| ------------------ | ----------- |
| Ubuntu             | Supported   |
| Debian             | Supported   |
| Fedora             | Supported   |
| Arch Linux         | Supported   |
| Kali Linux         | Supported   |
| WSL                | Supported   |
| Git Bash           | Supported   |
| MSYS2              | Supported   |
| Other POSIX Shells | Best effort |

The goal is not merely to make the script execute, but to verify that each information field behaves correctly in the target environment.

---

# Testing Checklist

When testing a new version, verify:

* [ ] Script starts successfully.
* [ ] OS is detected correctly.
* [ ] WSL is detected correctly.
* [ ] Windows environments are detected correctly.
* [ ] Hostname is displayed.
* [ ] User is displayed.
* [ ] Kernel is displayed.
* [ ] Architecture is displayed.
* [ ] CPU is displayed.
* [ ] Core count is displayed.
* [ ] RAM information is displayed.
* [ ] Disk information is displayed.
* [ ] Local IP is displayed.
* [ ] Public IP works when network access is available.
* [ ] Public IP gracefully becomes `N/A` when unavailable.
* [ ] Uptime is displayed.
* [ ] Date/time is displayed.
* [ ] Colors work in an interactive terminal.
* [ ] Colors are suppressed when output is redirected.
* [ ] Missing commands do not unnecessarily terminate execution.
* [ ] Long values do not destroy the output layout.

---

# Output Redirection

Because the program writes its report to standard output, it can be combined with normal Shell tools.

Save the output:

```sh
./sysinfo.sh > system-info.txt
```

View it:

```sh
cat system-info.txt
```

Search it:

```sh
./sysinfo.sh | grep "RAM"
```

Store it while displaying it:

```sh
./sysinfo.sh | tee system-info.txt
```

---

# Automation

The script can also be incorporated into larger Shell workflows.

Example:

```sh
#!/bin/sh

echo "Collecting system information..."

./sysinfo.sh

echo "Collection complete."
```

It can also be used as part of diagnostic scripts, provisioning workflows or support procedures.

---

# Limitations

Sysinfo Shell intentionally keeps its scope small.

Current limitations include:

* No interactive menu.
* No command-line options.
* No JSON output.
* No CSV output.
* No persistent database.
* No historical system metrics.
* No continuous monitoring.
* No process listing.
* No service monitoring.
* No hardware temperature monitoring.
* No GPU-specific reporting.
* No network interface dashboard.
* Public IP collection requires external network access.
* Windows functionality depends on the shell environment and available Windows utilities.

These limitations are intentional and help keep the project lightweight.

---

# Roadmap

Possible future improvements include:

### CLI

```sh
sysinfo.sh --help
sysinfo.sh --version
sysinfo.sh --network
sysinfo.sh --hardware
sysinfo.sh --system
```

### Output Formats

```sh
sysinfo.sh --json
sysinfo.sh --plain
sysinfo.sh --compact
```

### Additional Information

Potential future collectors:

* GPU
* motherboard
* BIOS/UEFI
* battery
* temperature
* network interfaces
* DNS
* gateway
* logged-in users
* shell
* virtualization
* container environment
* package manager
* display server
* desktop environment

### Monitoring

A future monitoring mode could potentially provide:

```text
CPU       ███████░░░ 72%
RAM       █████░░░░░ 51%
DISK      ████████░░ 81%
NETWORK   ↑ 12 MB/s ↓ 48 MB/s
```

without changing the lightweight snapshot mode.

---

# Contributing

Contributions are welcome.

A good contribution should prioritize:

1. Portability.
2. Simplicity.
3. Reliability.
4. Readability.
5. Graceful failure.
6. Minimal dependencies.
7. POSIX compatibility where possible.

Before submitting a change, test it on at least one Linux environment and, when the change is platform-specific, the relevant Windows shell environment.

---

## Adding a New Information Collector

A new collector should ideally follow the existing pattern:

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

Then integrate the collector into the output formatter.

This keeps the architecture consistent and makes future maintenance easier.

---

# Code Quality Principles

When modifying the project, prefer:

### Portable syntax

Use:

```sh
[ ... ]
```

instead of Bash-specific:

```bash
[[ ... ]]
```

Prefer:

```sh
case
```

for platform detection.

Avoid unnecessary dependencies.

---

### Defensive execution

Commands that may not exist should be checked:

```sh
if has_cmd command; then
    ...
fi
```

---

### Graceful degradation

If a data source is unavailable:

```text
N/A
```

is preferable to terminating the complete report.

---

### Keep functions focused

A function should preferably have one responsibility.

For example:

```text
get_cpu()
```

should retrieve CPU information rather than also formatting the entire report.

---

# License

This project is open source.

If a formal license file is added to the repository, this section should be updated to reference the exact license and its terms.

---

# Disclaimer

Sysinfo Shell is provided for informational and diagnostic purposes.

System information can vary depending on:

* operating system
* shell environment
* permissions
* installed utilities
* virtualization
* containerization
* WSL configuration
* network connectivity

The tool should therefore be considered a convenience utility rather than an authoritative hardware or operating-system inventory system.

---

# Author

Developed by **excanear**.

GitHub:

**https://github.com/excanear**

Repository:

**https://github.com/excanear/Sysinfo-Shell**

---

# Project Status

Sysinfo Shell is a lightweight project focused on providing a practical system snapshot through a single POSIX Shell script.

The repository is intentionally minimal, making it easy to inspect, understand, modify and extend.

The current implementation contains the core functionality required for a cross-platform terminal-based system information utility, including OS detection, hardware information, memory, storage, networking, uptime and formatted output.

---

<div align="center">

### Built with POSIX Shell

**Simple • Portable • Lightweight • Practical**

</div>
