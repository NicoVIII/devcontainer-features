#!/usr/bin/env bash
# Written in [Amber](https://amber-lang.com/)
# version: 0.6.0-alpha
[ "$EUID" -ne 0 ] && { { command -v sudo >/dev/null 2>&1 && __sudo=sudo; } || { command -v doas >/dev/null 2>&1 && __sudo=doas; }; }
if [ -n "$ZSH_VERSION" ]; then
    EXEC_SHELL="zsh"
    IFS='.' read -A EXEC_SHELL_VERSION <<< "$ZSH_VERSION"
elif [ -n "$KSH_VERSION" ]; then
    EXEC_SHELL="ksh"
    __exec_shell_version="${.sh.version##*/}"
    IFS='.' read -a EXEC_SHELL_VERSION <<< "${__exec_shell_version%% *}"
else
    EXEC_SHELL="bash"
    EXEC_SHELL_VERSION=("${BASH_VERSINFO[0]}" "${BASH_VERSINFO[1]}" "${BASH_VERSINFO[2]}")
fi
# starts_with(text: Text, prefix: Text)
starts_with__22_v0() {
    local text_65="${1}"
    local prefix_66="${2}"
    [[ "${text_65}" == "${prefix_66}"* ]]
    __status=$?
    ret_starts_with22_v0="$(( __status == 0 ))"
    return 0
}

# slice(text: Text, index: Int, length: Int)
slice__24_v0() {
    local text_67="${1}"
    local index_68="${2}"
    local length_69="${3}"
    local result_70=""
    if [ "$(( length_69 == 0 ))" != 0 ]; then
        local __length_0="${text_67}"
        length_69="$(( ${#__length_0} - index_68 ))"
    fi
    if [ "$(( length_69 <= 0 ))" != 0 ]; then
        ret_slice24_v0="${result_70}"
        return 0
    fi
    result_70="${text_67: ${index_68}: ${length_69}}"
    __status=$?
    ret_slice24_v0="${result_70}"
    return 0
}

# file_exists(path: Text)
file_exists__39_v0() {
    local path_98="${1}"
    [ -f "${path_98}" ]
    __status=$?
    ret_file_exists39_v0="$(( __status == 0 ))"
    return 0
}

# file_chmod(path: Text, mode: Text)
file_chmod__47_v0() {
    local path_96="${1}"
    local mode_97="${2}"
    file_exists__39_v0 "${path_96}"
    local ret_file_exists39_v0__153_8="${ret_file_exists39_v0}"
    if [ "${ret_file_exists39_v0__153_8}" != 0 ]; then
        chmod "${mode_97}" "${path_96}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            ret_file_chmod47_v0=''
            return "${__status}"
        fi
        ret_file_chmod47_v0=''
        return 0
    fi
    echo "The file ${path_96} doesn't exist"'!'""
    ret_file_chmod47_v0=''
    return 1
}

# env_var_set(name: Text, val: Text)
env_var_set__119_v0() {
    local name_33="${1}"
    local val_34="${2}"
    export $name_33="$val_34" 2> /dev/null
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_env_var_set119_v0=''
        return "${__status}"
    fi
}

# env_var_get(name: Text)
env_var_get__120_v0() {
    local name_41="${1}"
    if [ "$([ "_${EXEC_SHELL}" != "_bash" ]; echo $?)" != 0 ]; then
        local command_1
        command_1="$(printf "%s
" "${!name_41}")"
        __status=$?
        if [ "${__status}" != 0 ]; then
            ret_env_var_get120_v0=''
            return "${__status}"
        fi
        ret_env_var_get120_v0="${command_1}"
        return 0
    elif [ "$([ "_${EXEC_SHELL}" != "_zsh" ]; echo $?)" != 0 ]; then
        local command_2
        command_2="$(printf "%s
" "${(P)name_41}")"
        __status=$?
        if [ "${__status}" != 0 ]; then
            ret_env_var_get120_v0=''
            return "${__status}"
        fi
        ret_env_var_get120_v0="${command_2}"
        return 0
    elif [ "$([ "_${EXEC_SHELL}" != "_ksh" ]; echo $?)" != 0 ]; then
        local command_3
        command_3="$(eval "echo \${$name_41}")"
        __status=$?
        if [ "${__status}" != 0 ]; then
            ret_env_var_get120_v0=''
            return "${__status}"
        fi
        ret_env_var_get120_v0="${command_3}"
        return 0
    fi
}

# printf(format: Text, args: [Text])
printf__128_v0() {
    local format_31="${1}"
    local args_32=("${!2}")
    args_32=("${format_31}" "${args_32[@]}")
    __status=$?
    printf "${args_32[@]}"
    __status=$?
}

# echo_error(message: Text, exit_code: Int)
echo_error__138_v0() {
    local message_29="${1}"
    local exit_code_30="${2}"
    local array_4=("${message_29}")
    printf__128_v0 "\\x1b[1;3;97;41m%s\\x1b[0m
" array_4[@]
    if [ "$(( exit_code_30 > 0 ))" != 0 ]; then
        exit "${exit_code_30}"
    fi
}

# ensure_run_as_root()
ensure_run_as_root__159_v0() {
    local command_5
    command_5="$(id -u)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_ensure_run_as_root159_v0=''
        return "${__status}"
    fi
    local id_28="${command_5}"
    if [ "$([ "_${id_28}" == "_0" ]; echo $?)" != 0 ]; then
        echo_error__138_v0 "This script must be run as root" 1
        ret_ensure_run_as_root159_v0=''
        return 1
    fi
}

# clean_up()
clean_up__160_v0() {
    rm -rf /var/lib/apt/lists/*
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_clean_up160_v0=''
        return "${__status}"
    fi
}

# prepare()
prepare__161_v0() {
    ensure_run_as_root__159_v0 
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_prepare161_v0=''
        return "${__status}"
    fi
    clean_up__160_v0 
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_prepare161_v0=''
        return "${__status}"
    fi
    env_var_set__119_v0 "DEBIAN_FRONTEND" "noninteractive"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_prepare161_v0=''
        return "${__status}"
    fi
}

# get_architecture()
get_architecture__164_v0() {
    local command_6
    command_6="$(dpkg --print-architecture)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_get_architecture164_v0=''
        return "${__status}"
    fi
    local arch_73="${command_6}"
    if [ "$([ "_${arch_73}" != "_amd64" ]; echo $?)" != 0 ]; then
        ret_get_architecture164_v0="x86_64"
        return 0
    elif [ "$([ "_${arch_73}" != "_arm64" ]; echo $?)" != 0 ]; then
        ret_get_architecture164_v0="aarch64"
        return 0
    else
        echo_error__138_v0 "Unsupported architecture: ${arch_73}" 1
        ret_get_architecture164_v0=''
        return 1
    fi
}

# ensure_packages(packages: [Text])
ensure_packages__165_v0() {
    local packages_44=("${!1}")
    # Check if packages are already installed
    dpkg -s ${packages_44[@]} > /dev/null 2>&1
    __status=$?
    if [ "${__status}" != 0 ]; then
        # At least some packages are missing
        # We first check, if we need an update
        local command_7
        command_7="$(find /var/lib/apt/lists/* | wc -l)"
        __status=$?
        if [ "${__status}" != 0 ]; then
            ret_ensure_packages165_v0=''
            return "${__status}"
        fi
        if [ "$([ "_${command_7}" != "_0" ]; echo $?)" != 0 ]; then
            echo "Running apt-get update..."
            apt-get update -y
            __status=$?
            if [ "${__status}" != 0 ]; then
                ret_ensure_packages165_v0=''
                return "${__status}"
            fi
        fi
        apt-get -y install --no-install-recommends ${packages_44[@]}
        __status=$?
        if [ "${__status}" != 0 ]; then
            ret_ensure_packages165_v0=''
            return "${__status}"
        fi
    fi
}

# read_param(name: Text, default: Text)
read_param__169_v0() {
    local name_39="${1}"
    local default_40="${2}"
    env_var_get__120_v0 "${name_39}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        :
    fi
    ret_read_param169_v0="${ret_env_var_get120_v0}"
    return 0
}

# fetch_latest_version(repo_owner: Text, repo_name: Text)
fetch_latest_version__173_v0() {
    local repo_owner_48="${1}"
    local repo_name_49="${2}"
    local url_50="https://github.com/${repo_owner_48}/${repo_name_49}/releases/latest"
    local command_8
    command_8="$(bash -o pipefail -c "for attempt in 1 2 3; do (wget -S --max-redirect=0 --spider '${url_50}' 2>&1 || true) | sed -n 's#^[[:space:]]*[Ll]ocation:[[:space:]]*##p' | sed 's#[[:space:]]*\[following\]##' | tr -d '\r' | sed -n 's#^.*/releases/tag/##p' | tail -n1 | grep . && exit 0; if [ \$attempt -lt 3 ]; then sleep 1; fi; done; echo 'Unable to determine latest release version from ${url_50}' >&2; exit 1")"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_fetch_latest_version173_v0=''
        return "${__status}"
    fi
    ret_fetch_latest_version173_v0="${command_8}"
    return 0
}

# normalize_version(version: Text)
normalize_version__174_v0() {
    local version_64="${1}"
    starts_with__22_v0 "${version_64}" "v"
    local ret_starts_with22_v0__11_8="${ret_starts_with22_v0}"
    if [ "${ret_starts_with22_v0__11_8}" != 0 ]; then
        slice__24_v0 "${version_64}" 1 0
        ret_normalize_version174_v0="${ret_slice24_v0}"
        return 0
    fi
    ret_normalize_version174_v0="${version_64}"
    return 0
}

# download_file(url: Text, local_filename: Text)
download_file__175_v0() {
    local url_79="${1}"
    local local_filename_80="${2}"
    echo "Downloading from ${url_79}..."
    wget -qO ${local_filename_80} ${url_79}
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_download_file175_v0=''
        return "${__status}"
    fi
}

# extract_archive(filename: Text)
extract_archive__180_v0() {
    local filename_82="${1}"
    echo "Extracting ${filename_82}..."
    tar -xf ${filename_82}
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_extract_archive180_v0=''
        return "${__status}"
    fi
}

# install_binary(file_name: Text, binary_name: Text, install_dir: Text)
install_binary__181_v0() {
    local file_name_93="${1}"
    local binary_name_94="${2}"
    local install_dir_95="${3}"
    echo "Installing ${file_name_93} as ${binary_name_94} to ${install_dir_95}..."
    file_chmod__47_v0 "${file_name_93}" "+x"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_install_binary181_v0=''
        return "${__status}"
    fi
    mv "${file_name_93}" "${install_dir_95}/${binary_name_94}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_install_binary181_v0=''
        return "${__status}"
    fi
}

# cleanup_temp_dir(temp_dir: Text)
cleanup_temp_dir__182_v0() {
    local temp_dir_100="${1}"
    cd "-"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_cleanup_temp_dir182_v0=''
        return "${__status}"
    fi
    rm -rf /var/lib/apt/lists/*
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_cleanup_temp_dir182_v0=''
        return "${__status}"
    fi
    rm -rf ${temp_dir_100}
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_cleanup_temp_dir182_v0=''
        return "${__status}"
    fi
}

# Config
__BINARY_NAME_3="amber"
__REPO_OWNER_4="amber-lang"
__REPO_NAME_5="amber"
dependencies_6=("bc")
base_packages_7=("ca-certificates" "wget" "xz-utils")
prepare__161_v0 
__status=$?
if [ "${__status}" != 0 ]; then
    exit "${__status}"
fi
# Read parameters
read_param__169_v0 "VERSION" "latest"
version_42="${ret_read_param169_v0}"
# Ensure necessary packages
if [ "$([ "_${version_42}" != "_latest" ]; echo $?)" != 0 ]; then
    array_add_12=("${base_packages_7[@]}" "${dependencies_6[@]}")
    ensure_packages__165_v0 array_add_12[@]
    __status=$?
    if [ "${__status}" != 0 ]; then
        exit "${__status}"
    fi
    fetch_latest_version__173_v0 "${__REPO_OWNER_4}" "${__REPO_NAME_5}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        exit "${__status}"
    fi
    version_42="${ret_fetch_latest_version173_v0}"
else
    array_add_13=("${base_packages_7[@]}" "${dependencies_6[@]}")
    ensure_packages__165_v0 array_add_13[@]
    __status=$?
    if [ "${__status}" != 0 ]; then
        exit "${__status}"
    fi
fi
normalize_version__174_v0 "${version_42}"
version_42="${ret_normalize_version174_v0}"
# Setup temporary directory
temp_dir_71="/tmp/amber-feature"
echo "Preparing installation in ${temp_dir_71}..."
mkdir -p ${temp_dir_71}
__status=$?
if [ "${__status}" != 0 ]; then
    exit "${__status}"
fi
cd "${temp_dir_71}"
__status=$?
if [ "${__status}" != 0 ]; then
    exit "${__status}"
fi
get_architecture__164_v0 
__status=$?
if [ "${__status}" != 0 ]; then
    exit "${__status}"
fi
arch_74="${ret_get_architecture164_v0}"
filename_75="${__BINARY_NAME_3}-linux-musl-${arch_74}.tar.xz"
url_76="https://github.com/${__REPO_OWNER_4}/${__REPO_NAME_5}/releases/download/${version_42}/${filename_75}"
echo "Installing ${__BINARY_NAME_3} ${version_42}..."
download_file__175_v0 "${url_76}" "${filename_75}"
__status=$?
if [ "${__status}" != 0 ]; then
    exit "${__status}"
fi
extract_archive__180_v0 "${filename_75}"
__status=$?
if [ "${__status}" != 0 ]; then
    exit "${__status}"
fi
install_binary__181_v0 "${__BINARY_NAME_3}" "${__BINARY_NAME_3}" "/usr/local/bin"
__status=$?
if [ "${__status}" != 0 ]; then
    exit "${__status}"
fi
# Clean up
cleanup_temp_dir__182_v0 "${temp_dir_71}"
__status=$?
if [ "${__status}" != 0 ]; then
    exit "${__status}"
fi
echo "Done"'!'""
