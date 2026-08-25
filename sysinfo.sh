#!/bin/sh
# sysinfo.sh - System information script for Linux and Windows (Git Bash/MSYS2/WSL)
# POSIX Shell compliant - no bashisms, no arrays, no [[ ]], no source

# ANSI color codes (use moderately)
RESET='\033[0m'
BOLD='\033[1m'
CYAN='\033[36m'
YELLOW='\033[33m'
GREEN='\033[32m'
RED='\033[31m'
BLUE='\033[34m'

# Detect if stdout is a terminal before using colors
if [ -t 1 ]; then
    COLOR_RESET="${RESET}"
    COLOR_BOLD="${BOLD}"
    COLOR_CYAN="${CYAN}"
    COLOR_YELLOW="${YELLOW}"
    COLOR_GREEN="${GREEN}"
    COLOR_RED="${RED}"
    COLOR_BLUE="${BLUE}"
else
    COLOR_RESET=''
    COLOR_BOLD=''
    COLOR_CYAN=''
    COLOR_YELLOW=''
    COLOR_GREEN=''
    COLOR_RED=''
    COLOR_BLUE=''
fi

# Global variables
OS=""
IS_WSL=0

# ------------------------------------------------------------
# OS detection
# ------------------------------------------------------------
detect_os() {
    _kernel_name=$(uname -s 2>/dev/null)

    case "${_kernel_name}" in
        Linux*)
            OS="Linux"
            # Check for WSL
            if grep -qi "microsoft\|wsl" /proc/version 2>/dev/null; then
                IS_WSL=1
                OS="Linux (WSL)"
            fi
            ;;
        MSYS*|MINGW*|CYGWIN*)
            OS="Windows"
            ;;
        *)
            OS="Unknown"
            ;;
    esac
    unset _kernel_name
}

# ------------------------------------------------------------
# Helper: check if command exists
# ------------------------------------------------------------
has_cmd() {
    command -v "$1" >/dev/null 2>&1
}

# ------------------------------------------------------------
# Helper: safe read from /proc or file
# ------------------------------------------------------------
read_file() {
    _file="$1"
    if [ -r "${_file}" ] 2>/dev/null; then
        cat "${_file}" 2>/dev/null | tr -d '\n'
    else
        echo ""
    fi
    unset _file
}

# ------------------------------------------------------------
# Helper: trim whitespace
# ------------------------------------------------------------
trim() {
    _str="$1"
    echo "${_str}" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//'
}

# ------------------------------------------------------------
# get_os_name
# ------------------------------------------------------------
get_os_name() {
    echo "${OS}"
}

# ------------------------------------------------------------
# get_os_version
# ------------------------------------------------------------
get_os_version() {
    _version="N/A"

    case "${OS}" in
        Linux*)
            # Try /etc/os-release first
            if [ -r /etc/os-release ] 2>/dev/null; then
                _version=$(grep -E '^PRETTY_NAME=' /etc/os-release 2>/dev/null | cut -d= -f2- | tr -d '"')
            fi
            # Fallback to lsb_release
            if [ -z "${_version}" ] && has_cmd lsb_release; then
                _version=$(lsb_release -d 2>/dev/null | cut -d: -f2- | sed 's/^[[:space:]]*//')
            fi
            # Fallback to /etc/issue
            if [ -z "${_version}" ] && [ -r /etc/issue ] 2>/dev/null; then
                _version=$(cat /etc/issue 2>/dev/null | head -1 | sed 's/\\[a-z]//g' | sed 's/[[:space:]]*$//')
            fi
            ;;
        Windows)
            # Try wmic first
            if has_cmd wmic; then
                _version=$(wmic os get Caption,Version 2>/dev/null | tail -n 1 | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
            fi
            # Fallback to systeminfo
            if [ -z "${_version}" ] && has_cmd systeminfo; then
                _version=$(systeminfo 2>/dev/null | grep -i "OS Name" | head -1 | cut -d: -f2- | sed 's/^[[:space:]]*//')
            fi
            # Fallback to cmd ver
            if [ -z "${_version}" ] && has_cmd cmd; then
                _version=$(cmd.exe /c ver 2>/dev/null | head -1 | sed 's/[[:space:]]*$//')
            fi
            # Trim extra whitespace and handle wmic output
            _version=$(echo "${_version}" | sed 's/[[:space:]]*$//')
            ;;
        *)
            _version="N/A"
            ;;
    esac

    if [ -z "${_version}" ] || [ "${_version}" = "N/A" ]; then
        echo "N/A"
    else
        echo "${_version}"
    fi
    unset _version
}

# ------------------------------------------------------------
# get_hostname
# ------------------------------------------------------------
get_hostname() {
    _hostname="N/A"
    if has_cmd hostname; then
        _hostname=$(hostname 2>/dev/null)
    fi
    if [ -z "${_hostname}" ] || [ "${_hostname}" = "N/A" ]; then
        echo "N/A"
    else
        echo "${_hostname}"
    fi
    unset _hostname
}

# ------------------------------------------------------------
# get_user
# ------------------------------------------------------------
get_user() {
    _user="N/A"
    if has_cmd whoami; then
        _user=$(whoami 2>/dev/null)
    fi
    if [ -z "${_user}" ] || [ "${_user}" = "N/A" ]; then
        # Fallback to USER environment variable
        _user="${USER:-N/A}"
    fi
    echo "${_user}"
    unset _user
}

# ------------------------------------------------------------
# get_kernel
# ------------------------------------------------------------
get_kernel() {
    _kernel="N/A"
    if has_cmd uname; then
        _kernel=$(uname -r 2>/dev/null)
    fi
    if [ -z "${_kernel}" ] || [ "${_kernel}" = "N/A" ]; then
        echo "N/A"
    else
        echo "${_kernel}"
    fi
    unset _kernel
}

# ------------------------------------------------------------
# get_arch
# ------------------------------------------------------------
get_arch() {
    _arch="N/A"
    if has_cmd uname; then
        _arch=$(uname -m 2>/dev/null)
    fi
    if [ -z "${_arch}" ] || [ "${_arch}" = "N/A" ]; then
        # Fallback to environment variable on Windows
        _arch="${PROCESSOR_ARCHITECTURE:-N/A}"
        # Convert Windows arch names
        case "${_arch}" in
            AMD64) _arch="x86_64" ;;
            ARM64) _arch="ARM64" ;;
            x86)   _arch="x86" ;;
        esac
    fi
    echo "${_arch}"
    unset _arch
}

# ------------------------------------------------------------
# get_cpu
# ------------------------------------------------------------
get_cpu() {
    _cpu="N/A"

    case "${OS}" in
        Linux*)
            # Read from /proc/cpuinfo
            if [ -r /proc/cpuinfo ] 2>/dev/null; then
                _cpu=$(grep -E '^model name|^Processor' /proc/cpuinfo 2>/dev/null | head -1 | cut -d: -f2- | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
            fi
            # If empty, try lscpu
            if [ -z "${_cpu}" ] && has_cmd lscpu; then
                _cpu=$(lscpu 2>/dev/null | grep -E '^Model name|^CPU' | head -1 | cut -d: -f2- | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
            fi
            ;;
        Windows)
            # Try wmic first
            if has_cmd wmic; then
                _cpu=$(wmic cpu get name 2>/dev/null | tail -n 1 | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
            fi
            # Fallback to environment variable
            if [ -z "${_cpu}" ] || [ "${_cpu}" = "N/A" ] || [ -z "${_cpu}" ]; then
                _cpu="${PROCESSOR_IDENTIFIER:-N/A}"
            fi
            ;;
        *)
            _cpu="N/A"
            ;;
    esac

    if [ -z "${_cpu}" ] || [ "${_cpu}" = "N/A" ] || [ "${_cpu}" = "" ]; then
        echo "N/A"
    else
        echo "${_cpu}"
    fi
    unset _cpu
}

# ------------------------------------------------------------
# get_cores
# ------------------------------------------------------------
get_cores() {
    _cores="N/A"

    case "${OS}" in
        Linux*)
            # Try nproc first
            if has_cmd nproc; then
                _cores=$(nproc 2>/dev/null)
            fi
            # Fallback to /proc/cpuinfo
            if [ -z "${_cores}" ] || [ "${_cores}" = "N/A" ] || [ -z "${_cores}" ]; then
                if [ -r /proc/cpuinfo ] 2>/dev/null; then
                    _cores=$(grep -c '^processor' /proc/cpuinfo 2>/dev/null)
                fi
            fi
            # Fallback to sysctl (macOS/BSD compatibility)
            if [ -z "${_cores}" ] || [ "${_cores}" = "N/A" ] || [ -z "${_cores}" ]; then
                if has_cmd sysctl; then
                    _cores=$(sysctl -n hw.ncpu 2>/dev/null)
                fi
            fi
            ;;
        Windows)
            # Use environment variable
            _cores="${NUMBER_OF_PROCESSORS:-}"
            # Fallback to wmic
            if [ -z "${_cores}" ] && has_cmd wmic; then
                _cores=$(wmic cpu get NumberOfLogicalProcessors 2>/dev/null | tail -n 1 | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
            fi
            ;;
        *)
            _cores="N/A"
            ;;
    esac

    if [ -z "${_cores}" ] || [ "${_cores}" = "N/A" ] || [ -z "${_cores}" ] || [ "${_cores}" -le 0 ] 2>/dev/null; then
        echo "N/A"
    else
        echo "${_cores}"
    fi
    unset _cores
}

# ------------------------------------------------------------
# get_ram
# ------------------------------------------------------------
get_ram() {
    _ram="N/A"

    case "${OS}" in
        Linux*)
            if has_cmd free && [ -r /proc/meminfo ] 2>/dev/null; then
                # Use /proc/meminfo for consistent parsing
                _total=$(grep -E '^MemTotal:' /proc/meminfo 2>/dev/null | awk '{print $2}')
                _available=$(grep -E '^MemAvailable:' /proc/meminfo 2>/dev/null | awk '{print $2}')
                if [ -n "${_total}" ] && [ -n "${_available}" ]; then
                    _used=$((_total - _available))
                    _total_mb=$((_total / 1024))
                    _used_mb=$((_used / 1024))
                    _ram="${_used_mb}MiB / ${_total_mb}MiB"
                fi
            fi
            # Fallback to free -h
            if [ "${_ram}" = "N/A" ] && has_cmd free; then
                _ram=$(free -h 2>/dev/null | grep -E '^Mem:' | awk '{print $3 "/" $2}')
            fi
            # Fallback to reading /proc/meminfo manually
            if [ "${_ram}" = "N/A" ] && [ -r /proc/meminfo ] 2>/dev/null; then
                _total=$(grep -E '^MemTotal:' /proc/meminfo 2>/dev/null | awk '{print $2}')
                _free=$(grep -E '^MemFree:' /proc/meminfo 2>/dev/null | awk '{print $2}')
                _buffers=$(grep -E '^Buffers:' /proc/meminfo 2>/dev/null | awk '{print $2}')
                _cached=$(grep -E '^Cached:' /proc/meminfo 2>/dev/null | awk '{print $2}')
                _sreclaimable=$(grep -E '^SReclaimable:' /proc/meminfo 2>/dev/null | awk '{print $2}')
                if [ -n "${_total}" ] && [ -n "${_free}" ]; then
                    _used=$((_total - _free - _buffers - _cached - _sreclaimable))
                    _total_mb=$((_total / 1024))
                    _used_mb=$((_used / 1024))
                    _ram="${_used_mb}MiB / ${_total_mb}MiB"
                fi
            fi
            ;;
        Windows)
            # Try wmic first
            if has_cmd wmic; then
                _total=$(wmic os get TotalVisibleMemorySize 2>/dev/null | tail -n 1 | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
                _free=$(wmic os get FreePhysicalMemory 2>/dev/null | tail -n 1 | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
                if [ -n "${_total}" ] && [ -n "${_free}" ] && [ "${_total}" -gt 0 ] 2>/dev/null; then
                    _used=$((_total - _free))
                    _total_mb=$((_total / 1024))
                    _used_mb=$((_used / 1024))
                    _ram="${_used_mb}MiB / ${_total_mb}MiB"
                fi
            fi
            # Fallback to systeminfo
            if [ "${_ram}" = "N/A" ] && has_cmd systeminfo; then
                _total_line=$(systeminfo 2>/dev/null | grep -i "Total Physical Memory" | head -1)
                _avail_line=$(systeminfo 2>/dev/null | grep -i "Available Physical Memory" | head -1)
                _total=$(echo "${_total_line}" | grep -o '[0-9,]*' | tr -d ',')
                _avail=$(echo "${_avail_line}" | grep -o '[0-9,]*' | tr -d ',')
                if [ -n "${_total}" ] && [ -n "${_avail}" ] && [ "${_total}" -gt 0 ] 2>/dev/null; then
                    _used=$((_total - _avail))
                    _ram="${_used}MiB / ${_total}MiB"
                fi
            fi
            ;;
        *)
            _ram="N/A"
            ;;
    esac

    if [ -z "${_ram}" ] || [ "${_ram}" = "N/A" ] || [ -z "${_ram}" ]; then
        echo "N/A"
    else
        echo "${_ram}"
    fi
    unset _ram _total _available _used _total_mb _used_mb _free _buffers _cached _sreclaimable _avail_line _total_line
}

# ------------------------------------------------------------
# get_disk
# ------------------------------------------------------------
get_disk() {
    _disk="N/A"
    _mount_point="/"

    # On Windows, try to use df for the root mount point
    if [ "${OS}" = "Windows" ]; then
        # Try to find the Windows root drive (C: or where Git Bash is installed)
        if has_cmd df; then
            _disk=$(df -h / 2>/dev/null | tail -n 1 | awk '{print $3 "/" $2}')
        fi
        # Fallback to wmic for Windows drives
        if [ "${_disk}" = "N/A" ] && has_cmd wmic; then
            _disk=$(wmic logicaldisk where DriveType=3 get DeviceID,Size,FreeSpace 2>/dev/null | \
                    tail -n +2 | \
                    while read -r _dev _size _free; do
                        if [ -n "${_dev}" ] && [ -n "${_size}" ] && [ -n "${_free}" ] && [ "${_size}" -gt 0 ] 2>/dev/null; then
                            _used=$((_size - _free))
                            _size_gb=$((_size / 1073741824))
                            _used_gb=$((_used / 1073741824))
                            if [ "${_size_gb}" -gt 0 ] 2>/dev/null; then
                                echo "${_used_gb}GiB / ${_size_gb}GiB"
                                break
                            fi
                        fi
                    done)
        fi
        # Fallback to df for all mounted filesystems
        if [ "${_disk}" = "N/A" ] && has_cmd df; then
            _disk=$(df -h / 2>/dev/null | tail -n 1 | awk '{print $3 "/" $2}')
        fi
    else
        # Linux: use df for root partition
        if has_cmd df; then
            _disk=$(df -h / 2>/dev/null | tail -n 1 | awk '{print $3 "/" $2}')
        fi
    fi

    if [ -z "${_disk}" ] || [ "${_disk}" = "N/A" ] || [ -z "${_disk}" ]; then
        echo "N/A"
    else
        echo "${_disk}"
    fi
    unset _disk _mount_point
}

# ------------------------------------------------------------
# get_local_ip
# ------------------------------------------------------------
get_local_ip() {
    _ip="N/A"

    case "${OS}" in
        Linux*)
            # Try ip command first
            if has_cmd ip; then
                _ip=$(ip -4 addr show 2>/dev/null | grep -v 127.0.0.1 | grep -E 'inet ' | head -1 | awk '{print $2}' | cut -d/ -f1)
            fi
            # Fallback to hostname -I
            if [ -z "${_ip}" ] && has_cmd hostname; then
                _ip=$(hostname -I 2>/dev/null | awk '{print $1}')
            fi
            # Fallback to ifconfig
            if [ -z "${_ip}" ] && has_cmd ifconfig; then
                _ip=$(ifconfig 2>/dev/null | grep -v 127.0.0.1 | grep -E 'inet ' | head -1 | awk '{print $2}')
                # Some ifconfig versions use "inet addr:" format
                if [ -z "${_ip}" ]; then
                    _ip=$(ifconfig 2>/dev/null | grep -v 127.0.0.1 | grep -E 'inet addr:' | head -1 | sed 's/.*inet addr:\([^ ]*\) .*/\1/')
                fi
            fi
            ;;
        Windows)
            # Try ipconfig
            if has_cmd ipconfig; then
                _ip=$(ipconfig 2>/dev/null | grep -i "IPv4" | head -1 | awk -F: '{print $2}' | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
                # If no IPv4, try "IP Address" (older Windows)
                if [ -z "${_ip}" ]; then
                    _ip=$(ipconfig 2>/dev/null | grep -i "IP Address" | head -1 | awk -F: '{print $2}' | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
                fi
            fi
            # Fallback to wmic
            if [ -z "${_ip}" ] && has_cmd wmic; then
                _ip=$(wmic nicconfig where "IPEnabled='TRUE'" get IPAddress 2>/dev/null | grep -E '[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+' | head -1 | sed 's/^[[:space:]]*//;s/[[:space:]]*$//' | sed 's/[{}\"]//g')
                # Extract first IP from the list
                if echo "${_ip}" | grep -q ','; then
                    _ip=$(echo "${_ip}" | cut -d, -f1 | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
                fi
            fi
            ;;
        *)
            _ip="N/A"
            ;;
    esac

    if [ -z "${_ip}" ] || [ "${_ip}" = "N/A" ] || [ -z "${_ip}" ]; then
        echo "N/A"
    else
        echo "${_ip}"
    fi
    unset _ip
}

# ------------------------------------------------------------
# get_public_ip
# ------------------------------------------------------------
get_public_ip() {
    _ip="N/A"
    _services="ifconfig.me icanhazip.com api.ipify.org"

    for _service in ${_services}; do
        if has_cmd curl; then
            _ip=$(curl -s --connect-timeout 3 --max-time 5 "https://${_service}" 2>/dev/null | tr -d '\n\r')
        elif has_cmd wget; then
            _ip=$(wget -qO- --timeout=5 "https://${_service}" 2>/dev/null | tr -d '\n\r')
        fi
        # Validate IP format (basic)
        if echo "${_ip}" | grep -qE '^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$'; then
            break
        else
            _ip="N/A"
        fi
    done

    echo "${_ip}"
    unset _ip _services _service
}

# ------------------------------------------------------------
# get_uptime
# ------------------------------------------------------------
get_uptime() {
    _uptime="N/A"

    case "${OS}" in
        Linux*)
            # Try uptime -p first (human-readable)
            if has_cmd uptime; then
                if uptime -p 2>/dev/null | grep -q 'up'; then
                    _uptime=$(uptime -p 2>/dev/null | sed 's/up //')
                else
                    # Fallback: parse uptime output
                    _uptime=$(uptime 2>/dev/null | awk -F 'up ' '{print $2}' | awk -F ',' '{print $1}' | sed 's/^[[:space:]]*//')
                fi
            fi
            # If still empty, try /proc/uptime
            if [ -z "${_uptime}" ] && [ -r /proc/uptime ] 2>/dev/null; then
                _seconds=$(cat /proc/uptime 2>/dev/null | awk '{print int($1)}')
                if [ -n "${_seconds}" ] && [ "${_seconds}" -gt 0 ] 2>/dev/null; then
                    _days=$((_seconds / 86400))
                    _hours=$(( (_seconds % 86400) / 3600 ))
                    _minutes=$(( (_seconds % 3600) / 60 ))
                    if [ "${_days}" -gt 0 ]; then
                        _uptime="${_days} day"
                        [ "${_days}" -gt 1 ] && _uptime="${_uptime}s"
                        _uptime="${_uptime}, ${_hours}h ${_minutes}m"
                    else
                        _uptime="${_hours}h ${_minutes}m"
                    fi
                fi
            fi
            ;;
        Windows)
            # Try uptime command (might work in Git Bash/MSYS2)
            if has_cmd uptime; then
                _uptime=$(uptime 2>/dev/null | awk -F 'up ' '{print $2}' | awk -F ',' '{print $1}' | sed 's/^[[:space:]]*//')
            fi
            # Fallback: get boot time from systeminfo
            if [ -z "${_uptime}" ] && has_cmd systeminfo; then
                _boot=$(systeminfo 2>/dev/null | grep -i "System Boot Time" | head -1 | cut -d: -f2- | sed 's/^[[:space:]]*//')
                if [ -n "${_boot}" ]; then
                    _uptime="Boot: ${_boot}"
                fi
            fi
            # Fallback: wmic
            if [ -z "${_uptime}" ] && has_cmd wmic; then
                _boot=$(wmic os get LastBootUpTime 2>/dev/null | tail -n 1 | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
                if [ -n "${_boot}" ]; then
                    # Format: YYYYMMDDHHMMSS.ffffff+zzzz
                    _year=$(echo "${_boot}" | cut -c1-4)
                    _month=$(echo "${_boot}" | cut -c5-6)
                    _day=$(echo "${_boot}" | cut -c7-8)
                    _hour=$(echo "${_boot}" | cut -c9-10)
                    _min=$(echo "${_boot}" | cut -c11-12)
                    # Only show if we got valid numbers
                    if [ -n "${_year}" ] && [ -n "${_month}" ] && [ -n "${_day}" ]; then
                        _uptime="Boot: ${_year}-${_month}-${_day} ${_hour}:${_min}"
                    fi
                fi
            fi
            ;;
        *)
            _uptime="N/A"
            ;;
    esac

    if [ -z "${_uptime}" ] || [ "${_uptime}" = "N/A" ] || [ -z "${_uptime}" ]; then
        echo "N/A"
    else
        echo "${_uptime}"
    fi
    unset _uptime _seconds _days _hours _minutes _boot _year _month _day _hour _min
}

# ------------------------------------------------------------
# get_date
# ------------------------------------------------------------
get_date() {
    _date="N/A"
    if has_cmd date; then
        _date=$(date "+%Y-%m-%d %H:%M:%S" 2>/dev/null)
    fi
    if [ -z "${_date}" ] || [ "${_date}" = "N/A" ] || [ -z "${_date}" ]; then
        echo "N/A"
    else
        echo "${_date}"
    fi
    unset _date
}

# ------------------------------------------------------------
# Pad string to fixed width
# ------------------------------------------------------------
pad_right() {
    _str="$1"
    _width="$2"
    _len=$(printf "%s" "${_str}" | wc -c | tr -d ' ')
    _pad=$((_width - _len))
    printf "%s" "${_str}"
    while [ "${_pad}" -gt 0 ]; do
        printf " "
        _pad=$((_pad - 1))
    done
    unset _str _width _len _pad
}

# ------------------------------------------------------------
# Print the info box
# ------------------------------------------------------------
print_info() {
    _os_name=$(get_os_name)
    _os_version=$(get_os_version)
    _hostname=$(get_hostname)
    _user=$(get_user)
    _kernel=$(get_kernel)
    _arch=$(get_arch)
    _cpu=$(get_cpu)
    _cores=$(get_cores)
    _ram=$(get_ram)
    _disk=$(get_disk)
    _local_ip=$(get_local_ip)
    _public_ip=$(get_public_ip)
    _uptime=$(get_uptime)
    _date=$(get_date)

    # Box width
    _width=48

    # Top border
    printf "${COLOR_CYAN}╔"
    _i=0
    while [ "${_i}" -lt "$((_width - 2))" ]; do
        printf "═"
        _i=$((_i + 1))
    done
    printf "╗${COLOR_RESET}\n"

    # Title
    printf "${COLOR_CYAN}║${COLOR_RESET}"
    _title="SYSTEM INFO"
    _title_len=$(printf "%s" "${_title}" | wc -c | tr -d ' ')
    _left=$(( (_width - 2 - _title_len) / 2 ))
    _right=$(( _width - 2 - _title_len - _left ))
    _i=0
    while [ "${_i}" -lt "${_left}" ]; do
        printf " "
        _i=$((_i + 1))
    done
    printf "${COLOR_BOLD}${COLOR_YELLOW}%s${COLOR_RESET}" "${_title}"
    _i=0
    while [ "${_i}" -lt "${_right}" ]; do
        printf " "
        _i=$((_i + 1))
    done
    printf "${COLOR_CYAN}║${COLOR_RESET}\n"

    # Separator line
    printf "${COLOR_CYAN}╠"
    _i=0
    while [ "${_i}" -lt "$((_width - 2))" ]; do
        printf "═"
        _i=$((_i + 1))
    done
    printf "╣${COLOR_RESET}\n"

    # Helper: print a line with label and value
    _print_line() {
        _label="$1"
        _value="$2"
        _label_colored="${COLOR_BOLD}${COLOR_GREEN}${_label}${COLOR_RESET}"
        _label_len=$(printf "%s" "${_label}" | wc -c | tr -d ' ')
        # Fixed label width of 14 characters
        _label_pad=$((14 - _label_len))
        printf "${COLOR_CYAN}║${COLOR_RESET} "
        printf "%s" "${_label_colored}"
        _i=0
        while [ "${_i}" -lt "${_label_pad}" ]; do
            printf " "
            _i=$((_i + 1))
        done
        printf ": "
        _value_len=$(printf "%s" "${_value}" | wc -c | tr -d ' ')
        # Truncate value if too long (leave room for the right border)
        _max_value_len=$((_width - 2 - 2 - 14 - 2 - 1))  # border + space + label + ": " + border
        if [ "${_value_len}" -gt "${_max_value_len}" ]; then
            _value=$(printf "%s" "${_value}" | cut -c1-"${_max_value_len}")
        fi
        printf "%s" "${_value}"
        # Pad to align
        _value_len_new=$(printf "%s" "${_value}" | wc -c | tr -d ' ')
        _pad_right=$((_width - 2 - 2 - 14 - 2 - _value_len_new - 1))
        _i=0
        while [ "${_i}" -lt "${_pad_right}" ]; do
            printf " "
            _i=$((_i + 1))
        done
        printf "${COLOR_CYAN}║${COLOR_RESET}\n"
        unset _label _value _label_colored _label_len _label_pad _value_len _max_value_len _pad_right _value_len_new
    }

    # Print all info lines
    _print_line "OS"           "${_os_name}"
    _print_line "Version"      "${_os_version}"
    _print_line "Hostname"     "${_hostname}"
    _print_line "User"         "${_user}"
    _print_line "Kernel"       "${_kernel}"
    _print_line "Architecture" "${_arch}"
    _print_line "CPU"          "${_cpu}"
    _print_line "Cores"        "${_cores}"
    _print_line "RAM"          "${_ram}"
    _print_line "Disk"         "${_disk}"
    _print_line "Local IP"     "${_local_ip}"
    _print_line "Public IP"    "${_public_ip}"
    _print_line "Uptime"       "${_uptime}"
    _print_line "Date"         "${_date}"

    # Bottom border
    printf "${COLOR_CYAN}╚"
    _i=0
    while [ "${_i}" -lt "$((_width - 2))" ]; do
        printf "═"
        _i=$((_i + 1))
    done
    printf "╝${COLOR_RESET}\n"

    unset _os_name _os_version _hostname _user _kernel _arch _cpu _cores _ram _disk _local_ip _public_ip _uptime _date _width _i _title _title_len _left _right
}

# ------------------------------------------------------------
# Main
# ------------------------------------------------------------
main() {
    detect_os
    print_info
}

# Run main
main "$@"