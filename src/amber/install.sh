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
    local text_68="${1}"
    local prefix_69="${2}"
    [[ "${text_68}" == "${prefix_69}"* ]]
    __status=$?
    ret_starts_with22_v0="$(( __status == 0 ))"
    return 0
}

# slice(text: Text, index: Int, length: Int)
slice__24_v0() {
    local text_70="${1}"
    local index_71="${2}"
    local length_72="${3}"
    local result_73=""
    if [ "$(( length_72 == 0 ))" != 0 ]; then
        local __length_0="${text_70}"
        length_72="$(( ${#__length_0} - index_71 ))"
    fi
    if [ "$(( length_72 <= 0 ))" != 0 ]; then
        ret_slice24_v0="${result_73}"
        return 0
    fi
    result_73="${text_70: ${index_71}: ${length_72}}"
    __status=$?
    ret_slice24_v0="${result_73}"
    return 0
}

# file_exists(path: Text)
file_exists__39_v0() {
    local path_101="${1}"
    [ -f "${path_101}" ]
    __status=$?
    ret_file_exists39_v0="$(( __status == 0 ))"
    return 0
}

# file_chmod(path: Text, mode: Text)
file_chmod__47_v0() {
    local path_99="${1}"
    local mode_100="${2}"
    file_exists__39_v0 "${path_99}"
    local ret_file_exists39_v0__153_8="${ret_file_exists39_v0}"
    if [ "${ret_file_exists39_v0__153_8}" != 0 ]; then
        chmod "${mode_100}" "${path_99}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            ret_file_chmod47_v0=''
            return "${__status}"
        fi
        ret_file_chmod47_v0=''
        return 0
    fi
    echo "The file ${path_99} doesn't exist"'!'""
    ret_file_chmod47_v0=''
    return 1
}

# env_var_test(name: Text)
env_var_test__117_v0() {
    local name_43="${1}"
    if [ "$([ "_${EXEC_SHELL}" != "_zsh" ]; echo $?)" != 0 ]; then
        [[ ! -z ${(P)name_43+z} ]]
        __status=$?
        if [ "${__status}" != 0 ]; then
            ret_env_var_test117_v0=0
            return 0
        fi
    elif [ "$([ "_${EXEC_SHELL}" != "_bash" ]; echo $?)" != 0 ]; then
        declare -p -- "${name_43}" > /dev/null 2> /dev/null
        __status=$?
        if [ "${__status}" != 0 ]; then
            ret_env_var_test117_v0=0
            return 0
        fi
    elif [ "$([ "_${EXEC_SHELL}" != "_ksh" ]; echo $?)" != 0 ]; then
        eval "[ \"\${$name_43+x}\" = x ]"
        __status=$?
        if [ "${__status}" != 0 ]; then
            ret_env_var_test117_v0=0
            return 0
        fi
    fi
    ret_env_var_test117_v0=1
    return 0
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
    local name_44="${1}"
    if [ "$([ "_${EXEC_SHELL}" != "_bash" ]; echo $?)" != 0 ]; then
        local command_1
        command_1="$(printf "%s
" "${!name_44}")"
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
" "${(P)name_44}")"
        __status=$?
        if [ "${__status}" != 0 ]; then
            ret_env_var_get120_v0=''
            return "${__status}"
        fi
        ret_env_var_get120_v0="${command_2}"
        return 0
    elif [ "$([ "_${EXEC_SHELL}" != "_ksh" ]; echo $?)" != 0 ]; then
        local command_3
        command_3="$(eval "echo \${$name_44}")"
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
    local arch_76="${command_6}"
    if [ "$([ "_${arch_76}" != "_amd64" ]; echo $?)" != 0 ]; then
        ret_get_architecture164_v0="x86_64"
        return 0
    elif [ "$([ "_${arch_76}" != "_arm64" ]; echo $?)" != 0 ]; then
        ret_get_architecture164_v0="aarch64"
        return 0
    else
        echo_error__138_v0 "Unsupported architecture: ${arch_76}" 1
        ret_get_architecture164_v0=''
        return 1
    fi
}

# ensure_packages(packages: [Text])
ensure_packages__165_v0() {
    local packages_47=("${!1}")
    # Check if packages are already installed
    dpkg -s ${packages_47[@]} > /dev/null 2>&1
    __status=$?
    if [ "${__status}" != 0 ]; then
        # At least some packages are missing
        # We first check, if we need an update
        local command_7
        command_7="$(find /var/lib/apt/lists -mindepth 1 2> /dev/null | wc -l)"
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
        apt-get -y install --no-install-recommends ${packages_47[@]}
        __status=$?
        if [ "${__status}" != 0 ]; then
            ret_ensure_packages165_v0=''
            return "${__status}"
        fi
    fi
}

# read_param(name: Text, default: Text)
read_param__170_v0() {
    local name_41="${1}"
    local default_42="${2}"
    # env_var_get succeeds with "" for an unset variable, so its failure cannot drive the fallback
    env_var_test__117_v0 "${name_41}"
    local ret_env_var_test117_v0__6_8="${ret_env_var_test117_v0}"
    if [ "${ret_env_var_test117_v0__6_8}" != 0 ]; then
        env_var_get__120_v0 "${name_41}"
        __status=$?
        ret_read_param170_v0="${ret_env_var_get120_v0}"
        return 0
    fi
    ret_read_param170_v0="${default_42}"
    return 0
}

# fetch_latest_version(repo_owner: Text, repo_name: Text)
fetch_latest_version__175_v0() {
    local repo_owner_51="${1}"
    local repo_name_52="${2}"
    local url_53="https://api.github.com/repos/${repo_owner_51}/${repo_name_52}/releases/latest"
    # Rate-limited and error responses are valid JSON without a tag_name: without -f, -e and
    # pipefail they would resolve to the version "null" and fail later in the download.
    local command_8
    command_8="$(set -o pipefail; curl -fsSL ${url_53} | jq -er .tag_name)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        echo_error__138_v0 "Could not resolve the latest release of ${repo_owner_51}/${repo_name_52} via the GitHub API (possibly rate limited). Specify a version instead." 1
        ret_fetch_latest_version175_v0=''
        return 1
    fi
    ret_fetch_latest_version175_v0="${command_8}"
    return 0
}

# normalize_version(version: Text)
normalize_version__176_v0() {
    local version_67="${1}"
    starts_with__22_v0 "${version_67}" "v"
    local ret_starts_with22_v0__17_8="${ret_starts_with22_v0}"
    if [ "${ret_starts_with22_v0__17_8}" != 0 ]; then
        slice__24_v0 "${version_67}" 1 0
        ret_normalize_version176_v0="${ret_slice24_v0}"
        return 0
    fi
    ret_normalize_version176_v0="${version_67}"
    return 0
}

# download_file(url: Text, local_filename: Text)
download_file__177_v0() {
    local url_82="${1}"
    local local_filename_83="${2}"
    echo "Downloading from ${url_82}..."
    wget -qO ${local_filename_83} ${url_82}
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_download_file177_v0=''
        return "${__status}"
    fi
}

# extract_archive(filename: Text)
extract_archive__182_v0() {
    local filename_85="${1}"
    echo "Extracting ${filename_85}..."
    tar -xf ${filename_85}
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_extract_archive182_v0=''
        return "${__status}"
    fi
}

# install_binary(file_name: Text, binary_name: Text, install_dir: Text)
install_binary__183_v0() {
    local file_name_96="${1}"
    local binary_name_97="${2}"
    local install_dir_98="${3}"
    echo "Installing ${file_name_96} as ${binary_name_97} to ${install_dir_98}..."
    file_chmod__47_v0 "${file_name_96}" "+x"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_install_binary183_v0=''
        return "${__status}"
    fi
    mv "${file_name_96}" "${install_dir_98}/${binary_name_97}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_install_binary183_v0=''
        return "${__status}"
    fi
}

# cleanup_temp_dir(temp_dir: Text)
cleanup_temp_dir__184_v0() {
    local temp_dir_103="${1}"
    cd "-"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_cleanup_temp_dir184_v0=''
        return "${__status}"
    fi
    rm -rf /var/lib/apt/lists/*
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_cleanup_temp_dir184_v0=''
        return "${__status}"
    fi
    rm -rf ${temp_dir_103}
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_cleanup_temp_dir184_v0=''
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
read_param__170_v0 "VERSION" "latest"
version_45="${ret_read_param170_v0}"
# Ensure necessary packages
if [ "$([ "_${version_45}" != "_latest" ]; echo $?)" != 0 ]; then
    array_add_12=("${base_packages_7[@]}" "${dependencies_6[@]}")
    array_13=("jq" "curl")
    array_add_14=("${array_add_12[@]}" "${array_13[@]}")
    ensure_packages__165_v0 array_add_14[@]
    __status=$?
    if [ "${__status}" != 0 ]; then
        exit "${__status}"
    fi
    fetch_latest_version__175_v0 "${__REPO_OWNER_4}" "${__REPO_NAME_5}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        exit "${__status}"
    fi
    version_45="${ret_fetch_latest_version175_v0}"
else
    array_add_15=("${base_packages_7[@]}" "${dependencies_6[@]}")
    ensure_packages__165_v0 array_add_15[@]
    __status=$?
    if [ "${__status}" != 0 ]; then
        exit "${__status}"
    fi
fi
normalize_version__176_v0 "${version_45}"
version_45="${ret_normalize_version176_v0}"
# Setup temporary directory
temp_dir_74="/tmp/amber-feature"
echo "Preparing installation in ${temp_dir_74}..."
mkdir -p ${temp_dir_74}
__status=$?
if [ "${__status}" != 0 ]; then
    exit "${__status}"
fi
cd "${temp_dir_74}"
__status=$?
if [ "${__status}" != 0 ]; then
    exit "${__status}"
fi
get_architecture__164_v0 
__status=$?
if [ "${__status}" != 0 ]; then
    exit "${__status}"
fi
arch_77="${ret_get_architecture164_v0}"
filename_78="${__BINARY_NAME_3}-linux-musl-${arch_77}.tar.xz"
url_79="https://github.com/${__REPO_OWNER_4}/${__REPO_NAME_5}/releases/download/${version_45}/${filename_78}"
echo "Installing ${__BINARY_NAME_3} ${version_45}..."
download_file__177_v0 "${url_79}" "${filename_78}"
__status=$?
if [ "${__status}" != 0 ]; then
    exit "${__status}"
fi
extract_archive__182_v0 "${filename_78}"
__status=$?
if [ "${__status}" != 0 ]; then
    exit "${__status}"
fi
install_binary__183_v0 "${__BINARY_NAME_3}" "${__BINARY_NAME_3}" "/usr/local/bin"
__status=$?
if [ "${__status}" != 0 ]; then
    exit "${__status}"
fi
# Clean up
cleanup_temp_dir__184_v0 "${temp_dir_74}"
__status=$?
if [ "${__status}" != 0 ]; then
    exit "${__status}"
fi
echo "Done"'!'""
