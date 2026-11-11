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
    local text_67="${1}"
    local prefix_68="${2}"
    [[ "${text_67}" == "${prefix_68}"* ]]
    __status=$?
    ret_starts_with22_v0="$(( __status == 0 ))"
    return 0
}

# slice(text: Text, index: Int, length: Int)
slice__24_v0() {
    local text_69="${1}"
    local index_70="${2}"
    local length_71="${3}"
    local result_72=""
    if [ "$(( length_71 == 0 ))" != 0 ]; then
        local __length_0="${text_69}"
        length_71="$(( ${#__length_0} - index_70 ))"
    fi
    if [ "$(( length_71 <= 0 ))" != 0 ]; then
        ret_slice24_v0="${result_72}"
        return 0
    fi
    result_72="${text_69: ${index_70}: ${length_71}}"
    __status=$?
    ret_slice24_v0="${result_72}"
    return 0
}

# file_exists(path: Text)
file_exists__39_v0() {
    local path_102="${1}"
    [ -f "${path_102}" ]
    __status=$?
    ret_file_exists39_v0="$(( __status == 0 ))"
    return 0
}

# file_chmod(path: Text, mode: Text)
file_chmod__47_v0() {
    local path_100="${1}"
    local mode_101="${2}"
    file_exists__39_v0 "${path_100}"
    local ret_file_exists39_v0__153_8="${ret_file_exists39_v0}"
    if [ "${ret_file_exists39_v0__153_8}" != 0 ]; then
        chmod "${mode_101}" "${path_100}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            ret_file_chmod47_v0=''
            return "${__status}"
        fi
        ret_file_chmod47_v0=''
        return 0
    fi
    echo "The file ${path_100} doesn't exist"'!'""
    ret_file_chmod47_v0=''
    return 1
}

# env_var_test(name: Text)
env_var_test__117_v0() {
    local name_42="${1}"
    if [ "$([ "_${EXEC_SHELL}" != "_zsh" ]; echo $?)" != 0 ]; then
        [[ ! -z ${(P)name_42+z} ]]
        __status=$?
        if [ "${__status}" != 0 ]; then
            ret_env_var_test117_v0=0
            return 0
        fi
    elif [ "$([ "_${EXEC_SHELL}" != "_bash" ]; echo $?)" != 0 ]; then
        declare -p -- "${name_42}" > /dev/null 2> /dev/null
        __status=$?
        if [ "${__status}" != 0 ]; then
            ret_env_var_test117_v0=0
            return 0
        fi
    elif [ "$([ "_${EXEC_SHELL}" != "_ksh" ]; echo $?)" != 0 ]; then
        eval "[ \"\${$name_42+x}\" = x ]"
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
    local name_32="${1}"
    local val_33="${2}"
    export $name_32="$val_33" 2> /dev/null
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_env_var_set119_v0=''
        return "${__status}"
    fi
}

# env_var_get(name: Text)
env_var_get__120_v0() {
    local name_43="${1}"
    if [ "$([ "_${EXEC_SHELL}" != "_bash" ]; echo $?)" != 0 ]; then
        local command_1
        command_1="$(printf "%s
" "${!name_43}")"
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
" "${(P)name_43}")"
        __status=$?
        if [ "${__status}" != 0 ]; then
            ret_env_var_get120_v0=''
            return "${__status}"
        fi
        ret_env_var_get120_v0="${command_2}"
        return 0
    elif [ "$([ "_${EXEC_SHELL}" != "_ksh" ]; echo $?)" != 0 ]; then
        local command_3
        command_3="$(eval "echo \${$name_43}")"
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
    local format_30="${1}"
    local args_31=("${!2}")
    args_31=("${format_30}" "${args_31[@]}")
    __status=$?
    printf "${args_31[@]}"
    __status=$?
}

# echo_error(message: Text, exit_code: Int)
echo_error__138_v0() {
    local message_28="${1}"
    local exit_code_29="${2}"
    local array_4=("${message_28}")
    printf__128_v0 "\\x1b[1;3;97;41m%s\\x1b[0m
" array_4[@]
    if [ "$(( exit_code_29 > 0 ))" != 0 ]; then
        exit "${exit_code_29}"
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
    local id_27="${command_5}"
    if [ "$([ "_${id_27}" == "_0" ]; echo $?)" != 0 ]; then
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
    local arch_75="${command_6}"
    if [ "$([ "_${arch_75}" != "_amd64" ]; echo $?)" != 0 ]; then
        ret_get_architecture164_v0="x86_64"
        return 0
    elif [ "$([ "_${arch_75}" != "_arm64" ]; echo $?)" != 0 ]; then
        ret_get_architecture164_v0="aarch64"
        return 0
    else
        echo_error__138_v0 "Unsupported architecture: ${arch_75}" 1
        ret_get_architecture164_v0=''
        return 1
    fi
}

# ensure_packages(packages: [Text])
ensure_packages__165_v0() {
    local packages_46=("${!1}")
    # Check if packages are already installed
    dpkg -s ${packages_46[@]} > /dev/null 2>&1
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
        apt-get -y install --no-install-recommends ${packages_46[@]}
        __status=$?
        if [ "${__status}" != 0 ]; then
            ret_ensure_packages165_v0=''
            return "${__status}"
        fi
    fi
}

# read_param(name: Text, default: Text)
read_param__170_v0() {
    local name_40="${1}"
    local default_41="${2}"
    # env_var_get succeeds with "" for an unset variable, so its failure cannot drive the fallback
    env_var_test__117_v0 "${name_40}"
    local ret_env_var_test117_v0__6_8="${ret_env_var_test117_v0}"
    if [ "${ret_env_var_test117_v0__6_8}" != 0 ]; then
        env_var_get__120_v0 "${name_40}"
        __status=$?
        ret_read_param170_v0="${ret_env_var_get120_v0}"
        return 0
    fi
    ret_read_param170_v0="${default_41}"
    return 0
}

# fetch_latest_version(repo_owner: Text, repo_name: Text)
fetch_latest_version__175_v0() {
    local repo_owner_50="${1}"
    local repo_name_51="${2}"
    local url_52="https://api.github.com/repos/${repo_owner_50}/${repo_name_51}/releases/latest"
    # Rate-limited and error responses are valid JSON without a tag_name: without -f, -e and
    # pipefail they would resolve to the version "null" and fail later in the download.
    local command_8
    command_8="$(set -o pipefail; curl -fsSL ${url_52} | jq -er .tag_name)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        echo_error__138_v0 "Could not resolve the latest release of ${repo_owner_50}/${repo_name_51} via the GitHub API (possibly rate limited). Specify a version instead." 1
        ret_fetch_latest_version175_v0=''
        return 1
    fi
    ret_fetch_latest_version175_v0="${command_8}"
    return 0
}

# normalize_version(version: Text)
normalize_version__176_v0() {
    local version_66="${1}"
    starts_with__22_v0 "${version_66}" "v"
    local ret_starts_with22_v0__17_8="${ret_starts_with22_v0}"
    if [ "${ret_starts_with22_v0__17_8}" != 0 ]; then
        slice__24_v0 "${version_66}" 1 0
        ret_normalize_version176_v0="${ret_slice24_v0}"
        return 0
    fi
    ret_normalize_version176_v0="${version_66}"
    return 0
}

# download_file(url: Text, local_filename: Text)
download_file__177_v0() {
    local url_81="${1}"
    local local_filename_82="${2}"
    echo "Downloading from ${url_81}..."
    wget -qO ${local_filename_82} ${url_81}
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_download_file177_v0=''
        return "${__status}"
    fi
}

# verify_sha256(url: Text)
verify_sha256__189_v0() {
    local url_84="${1}"
    echo "Checking sha256sum..."
    wget -qO- "${url_84}.sha256" | sha256sum -c -
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_verify_sha256189_v0=''
        return "${__status}"
    fi
}

# extract_archive(filename: Text)
extract_archive__193_v0() {
    local filename_86="${1}"
    echo "Extracting ${filename_86}..."
    tar -xf ${filename_86}
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_extract_archive193_v0=''
        return "${__status}"
    fi
}

# install_binary(file_name: Text, binary_name: Text, install_dir: Text)
install_binary__194_v0() {
    local file_name_97="${1}"
    local binary_name_98="${2}"
    local install_dir_99="${3}"
    echo "Installing ${file_name_97} as ${binary_name_98} to ${install_dir_99}..."
    file_chmod__47_v0 "${file_name_97}" "+x"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_install_binary194_v0=''
        return "${__status}"
    fi
    mv "${file_name_97}" "${install_dir_99}/${binary_name_98}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_install_binary194_v0=''
        return "${__status}"
    fi
}

# cleanup_temp_dir(temp_dir: Text)
cleanup_temp_dir__195_v0() {
    local temp_dir_104="${1}"
    cd "-"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_cleanup_temp_dir195_v0=''
        return "${__status}"
    fi
    rm -rf /var/lib/apt/lists/*
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_cleanup_temp_dir195_v0=''
        return "${__status}"
    fi
    rm -rf ${temp_dir_104}
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_cleanup_temp_dir195_v0=''
        return "${__status}"
    fi
}

# Config
__BINARY_NAME_3="gleam"
__REPO_OWNER_4="gleam-lang"
__REPO_NAME_5="gleam"
base_packages_6=("ca-certificates" "wget")
prepare__161_v0 
__status=$?
if [ "${__status}" != 0 ]; then
    exit "${__status}"
fi
# Read parameters
read_param__170_v0 "VERSION" "latest"
version_44="${ret_read_param170_v0}"
# Ensure necessary packages
if [ "$([ "_${version_44}" != "_latest" ]; echo $?)" != 0 ]; then
    array_11=("jq" "curl")
    array_add_12=("${base_packages_6[@]}" "${array_11[@]}")
    ensure_packages__165_v0 array_add_12[@]
    __status=$?
    if [ "${__status}" != 0 ]; then
        exit "${__status}"
    fi
    fetch_latest_version__175_v0 "${__REPO_OWNER_4}" "${__REPO_NAME_5}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        exit "${__status}"
    fi
    version_44="${ret_fetch_latest_version175_v0}"
else
    ensure_packages__165_v0 base_packages_6[@]
    __status=$?
    if [ "${__status}" != 0 ]; then
        exit "${__status}"
    fi
fi
normalize_version__176_v0 "${version_44}"
version_44="${ret_normalize_version176_v0}"
# Setup temporary directory
temp_dir_73="/tmp/gleam-feature"
echo "Preparing installation in ${temp_dir_73}..."
mkdir -p ${temp_dir_73}
__status=$?
if [ "${__status}" != 0 ]; then
    exit "${__status}"
fi
cd "${temp_dir_73}"
__status=$?
if [ "${__status}" != 0 ]; then
    exit "${__status}"
fi
get_architecture__164_v0 
__status=$?
if [ "${__status}" != 0 ]; then
    exit "${__status}"
fi
arch_76="${ret_get_architecture164_v0}"
filename_77="${__BINARY_NAME_3}-v${version_44}-${arch_76}-unknown-linux-musl.tar.gz"
url_78="https://github.com/${__REPO_OWNER_4}/${__REPO_NAME_5}/releases/download/v${version_44}/${filename_77}"
echo "Installing ${__BINARY_NAME_3} ${version_44}..."
download_file__177_v0 "${url_78}" "${filename_77}"
__status=$?
if [ "${__status}" != 0 ]; then
    exit "${__status}"
fi
verify_sha256__189_v0 "${url_78}"
__status=$?
if [ "${__status}" != 0 ]; then
    exit "${__status}"
fi
extract_archive__193_v0 "${filename_77}"
__status=$?
if [ "${__status}" != 0 ]; then
    exit "${__status}"
fi
install_binary__194_v0 "${__BINARY_NAME_3}" "${__BINARY_NAME_3}" "/usr/local/bin"
__status=$?
if [ "${__status}" != 0 ]; then
    exit "${__status}"
fi
# Clean up
cleanup_temp_dir__195_v0 "${temp_dir_73}"
__status=$?
if [ "${__status}" != 0 ]; then
    exit "${__status}"
fi
echo "Done"'!'""
