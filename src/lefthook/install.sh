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
    local text_64="${1}"
    local prefix_65="${2}"
    [[ "${text_64}" == "${prefix_65}"* ]]
    __status=$?
    ret_starts_with22_v0="$(( __status == 0 ))"
    return 0
}

# slice(text: Text, index: Int, length: Int)
slice__24_v0() {
    local text_66="${1}"
    local index_67="${2}"
    local length_68="${3}"
    local result_69=""
    if [ "$(( length_68 == 0 ))" != 0 ]; then
        local __length_0="${text_66}"
        length_68="$(( ${#__length_0} - index_67 ))"
    fi
    if [ "$(( length_68 <= 0 ))" != 0 ]; then
        ret_slice24_v0="${result_69}"
        return 0
    fi
    result_69="${text_66: ${index_67}: ${length_68}}"
    __status=$?
    ret_slice24_v0="${result_69}"
    return 0
}

# file_exists(path: Text)
file_exists__39_v0() {
    local path_114="${1}"
    [ -f "${path_114}" ]
    __status=$?
    ret_file_exists39_v0="$(( __status == 0 ))"
    return 0
}

# file_chmod(path: Text, mode: Text)
file_chmod__47_v0() {
    local path_112="${1}"
    local mode_113="${2}"
    file_exists__39_v0 "${path_112}"
    local ret_file_exists39_v0__153_8="${ret_file_exists39_v0}"
    if [ "${ret_file_exists39_v0__153_8}" != 0 ]; then
        chmod "${mode_113}" "${path_112}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            ret_file_chmod47_v0=''
            return "${__status}"
        fi
        ret_file_chmod47_v0=''
        return 0
    fi
    echo "The file ${path_112} doesn't exist"'!'""
    ret_file_chmod47_v0=''
    return 1
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
    local name_40="${1}"
    if [ "$([ "_${EXEC_SHELL}" != "_bash" ]; echo $?)" != 0 ]; then
        local command_1
        command_1="$(printf "%s
" "${!name_40}")"
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
" "${(P)name_40}")"
        __status=$?
        if [ "${__status}" != 0 ]; then
            ret_env_var_get120_v0=''
            return "${__status}"
        fi
        ret_env_var_get120_v0="${command_2}"
        return 0
    elif [ "$([ "_${EXEC_SHELL}" != "_ksh" ]; echo $?)" != 0 ]; then
        local command_3
        command_3="$(eval "echo \${$name_40}")"
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
    local arch_72="${command_6}"
    if [ "$([ "_${arch_72}" != "_amd64" ]; echo $?)" != 0 ]; then
        ret_get_architecture164_v0="x86_64"
        return 0
    elif [ "$([ "_${arch_72}" != "_arm64" ]; echo $?)" != 0 ]; then
        ret_get_architecture164_v0="aarch64"
        return 0
    else
        echo_error__138_v0 "Unsupported architecture: ${arch_72}" 1
        ret_get_architecture164_v0=''
        return 1
    fi
}

# ensure_packages(packages: [Text])
ensure_packages__165_v0() {
    local packages_43=("${!1}")
    # Check if packages are already installed
    dpkg -s ${packages_43[@]} > /dev/null 2>&1
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
        apt-get -y install --no-install-recommends ${packages_43[@]}
        __status=$?
        if [ "${__status}" != 0 ]; then
            ret_ensure_packages165_v0=''
            return "${__status}"
        fi
    fi
}

# read_param(name: Text, default: Text)
read_param__169_v0() {
    local name_38="${1}"
    local default_39="${2}"
    env_var_get__120_v0 "${name_38}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        :
    fi
    ret_read_param169_v0="${ret_env_var_get120_v0}"
    return 0
}

# fetch_latest_version(repo_owner: Text, repo_name: Text)
fetch_latest_version__173_v0() {
    local repo_owner_47="${1}"
    local repo_name_48="${2}"
    local url_49="https://api.github.com/repos/${repo_owner_47}/${repo_name_48}/releases/latest"
    local command_8
    command_8="$(curl -sL ${url_49} | jq -r .tag_name)"
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
    local version_63="${1}"
    starts_with__22_v0 "${version_63}" "v"
    local ret_starts_with22_v0__11_8="${ret_starts_with22_v0}"
    if [ "${ret_starts_with22_v0__11_8}" != 0 ]; then
        slice__24_v0 "${version_63}" 1 0
        ret_normalize_version174_v0="${ret_slice24_v0}"
        return 0
    fi
    ret_normalize_version174_v0="${version_63}"
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

# download_file(url: Text, local_filename: Text)
download_file__184_v0() {
    local url_95="${1}"
    local local_filename_96="${2}"
    echo "Downloading from ${url_95}..."
    wget -qO ${local_filename_96} ${url_95}
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_download_file184_v0=''
        return "${__status}"
    fi
}

# verify_sha256_from_manifest(checksum_url: Text, artifact_name: Text)
verify_sha256_from_manifest__187_v0() {
    local checksum_url_91="${1}"
    local artifact_name_92="${2}"
    echo "Checking sha256sum..."
    local manifest_filename_93=".checksum-manifest"
    local entry_filename_94=".checksum-entry"
    download_file__184_v0 "${checksum_url_91}" "${manifest_filename_93}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_verify_sha256_from_manifest187_v0=''
        return "${__status}"
    fi
    local command_9
    command_9="$(grep -F "  ${artifact_name_92}" ${manifest_filename_93} | grep -Fv "  ${artifact_name_92}.gz" || true)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_verify_sha256_from_manifest187_v0=''
        return "${__status}"
    fi
    local checksum_entries_97="${command_9}"
    local command_10
    command_10="$(printf "%s" "${checksum_entries_97}" | grep -c . || true)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_verify_sha256_from_manifest187_v0=''
        return "${__status}"
    fi
    local match_count_98="${command_10}"
    if [ "$([ "_${match_count_98}" == "_1" ]; echo $?)" != 0 ]; then
        echo_error__138_v0 "Checksum manifest must contain exactly one entry for ${artifact_name_92}" 1
        ret_verify_sha256_from_manifest187_v0=''
        return 1
    fi
    printf "%s
" "${checksum_entries_97}" > ${entry_filename_94}
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_verify_sha256_from_manifest187_v0=''
        return "${__status}"
    fi
    sha256sum -c ${entry_filename_94}
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_verify_sha256_from_manifest187_v0=''
        return "${__status}"
    fi
    rm -f ${entry_filename_94}
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_verify_sha256_from_manifest187_v0=''
        return "${__status}"
    fi
    rm -f ${manifest_filename_93}
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_verify_sha256_from_manifest187_v0=''
        return "${__status}"
    fi
}

# install_binary(file_name: Text, binary_name: Text, install_dir: Text)
install_binary__191_v0() {
    local file_name_109="${1}"
    local binary_name_110="${2}"
    local install_dir_111="${3}"
    echo "Installing ${file_name_109} as ${binary_name_110} to ${install_dir_111}..."
    file_chmod__47_v0 "${file_name_109}" "+x"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_install_binary191_v0=''
        return "${__status}"
    fi
    mv "${file_name_109}" "${install_dir_111}/${binary_name_110}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_install_binary191_v0=''
        return "${__status}"
    fi
}

# cleanup_temp_dir(temp_dir: Text)
cleanup_temp_dir__192_v0() {
    local temp_dir_116="${1}"
    cd "-"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_cleanup_temp_dir192_v0=''
        return "${__status}"
    fi
    rm -rf /var/lib/apt/lists/*
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_cleanup_temp_dir192_v0=''
        return "${__status}"
    fi
    rm -rf ${temp_dir_116}
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_cleanup_temp_dir192_v0=''
        return "${__status}"
    fi
}

# Config
__BINARY_NAME_3="lefthook"
__REPO_OWNER_4="evilmartians"
__REPO_NAME_5="lefthook"
base_packages_6=("ca-certificates" "wget")
prepare__161_v0 
__status=$?
if [ "${__status}" != 0 ]; then
    exit "${__status}"
fi
# Read parameters
read_param__169_v0 "VERSION" "latest"
version_41="${ret_read_param169_v0}"
# Ensure necessary packages
if [ "$([ "_${version_41}" != "_latest" ]; echo $?)" != 0 ]; then
    array_13=("jq" "curl")
    array_add_14=("${base_packages_6[@]}" "${array_13[@]}")
    ensure_packages__165_v0 array_add_14[@]
    __status=$?
    if [ "${__status}" != 0 ]; then
        exit "${__status}"
    fi
    fetch_latest_version__173_v0 "${__REPO_OWNER_4}" "${__REPO_NAME_5}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        exit "${__status}"
    fi
    version_41="${ret_fetch_latest_version173_v0}"
else
    ensure_packages__165_v0 base_packages_6[@]
    __status=$?
    if [ "${__status}" != 0 ]; then
        exit "${__status}"
    fi
fi
normalize_version__174_v0 "${version_41}"
version_41="${ret_normalize_version174_v0}"
# Setup temporary directory
temp_dir_70="/tmp/lefthook-feature"
echo "Preparing installation in ${temp_dir_70}..."
mkdir -p ${temp_dir_70}
__status=$?
if [ "${__status}" != 0 ]; then
    exit "${__status}"
fi
cd "${temp_dir_70}"
__status=$?
if [ "${__status}" != 0 ]; then
    exit "${__status}"
fi
get_architecture__164_v0 
__status=$?
if [ "${__status}" != 0 ]; then
    exit "${__status}"
fi
arch_73="${ret_get_architecture164_v0}"
filename_74="${__BINARY_NAME_3}_${version_41}_Linux_${arch_73}"
release_url_75="https://github.com/${__REPO_OWNER_4}/${__REPO_NAME_5}/releases/download/v${version_41}"
url_76="${release_url_75}/${filename_74}"
echo "Installing ${__BINARY_NAME_3} ${version_41}..."
download_file__175_v0 "${url_76}" "${filename_74}"
__status=$?
if [ "${__status}" != 0 ]; then
    exit "${__status}"
fi
verify_sha256_from_manifest__187_v0 "${release_url_75}/${__BINARY_NAME_3}_checksums.txt" "${filename_74}"
__status=$?
if [ "${__status}" != 0 ]; then
    exit "${__status}"
fi
install_binary__191_v0 "${filename_74}" "${__BINARY_NAME_3}" "/usr/local/bin"
__status=$?
if [ "${__status}" != 0 ]; then
    exit "${__status}"
fi
# Clean up
cleanup_temp_dir__192_v0 "${temp_dir_70}"
__status=$?
if [ "${__status}" != 0 ]; then
    exit "${__status}"
fi
echo "Done"'!'""
