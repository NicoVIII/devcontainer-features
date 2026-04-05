#!/usr/bin/env bash
# Written in [Amber](https://amber-lang.com/)
# version: 0.5.1-alpha
# We cannot import `bash_version` from `env.ab` because it imports `text.ab` making a circular dependency.
# This is a workaround to avoid that issue and the import system should be improved in the future.
starts_with__23_v0() {
    local text=$1
    local prefix=$2
    command_0="$(if [[ "${text}" == "${prefix}"* ]]; then
    echo 1
  fi)"
    __status=$?
    result_10="${command_0}"
    ret_starts_with23_v0="$([ "_${result_10}" != "_1" ]; echo $?)"
    return 0
}

slice__25_v0() {
    local text=$1
    local index=$2
    local length=$3
    if [ "$(( ${length} == 0 ))" != 0 ]; then
        __length_1="${text}"
        length="$(( ${#__length_1} - ${index} ))"
    fi
    if [ "$(( ${length} <= 0 ))" != 0 ]; then
        ret_slice25_v0=""
        return 0
    fi
    command_2="$(printf "%.${length}s" "${text: ${index}}")"
    __status=$?
    ret_slice25_v0="${command_2}"
    return 0
}

file_exists__37_v0() {
    local path=$1
    [ -f "${path}" ]
    __status=$?
    ret_file_exists37_v0="$(( ${__status} == 0 ))"
    return 0
}

file_chmod__45_v0() {
    local path=$1
    local mode=$2
    file_exists__37_v0 "${path}"
    ret_file_exists37_v0__153_8="${ret_file_exists37_v0}"
    if [ "${ret_file_exists37_v0__153_8}" != 0 ]; then
        chmod "${mode}" "${path}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            ret_file_chmod45_v0=''
            return "${__status}"
        fi
        ret_file_chmod45_v0=''
        return 0
    fi
    echo "The file ${path} doesn't exist"'!'""
    ret_file_chmod45_v0=''
    return 1
}

env_var_set__97_v0() {
    local name=$1
    local val=$2
    export $name="$val" 2> /dev/null
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_env_var_set97_v0=''
        return "${__status}"
    fi
}

env_var_get__98_v0() {
    local name=$1
    command_3="$(echo ${!name})"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_env_var_get98_v0=''
        return "${__status}"
    fi
    ret_env_var_get98_v0="${command_3}"
    return 0
}

printf__106_v0() {
    local format=$1
    local args=("${!2}")
    args=("${format}" "${args[@]}")
    __status=$?
    printf "${args[@]}"
    __status=$?
}

echo_error__116_v0() {
    local message=$1
    local exit_code=$2
    array_4=("${message}")
    printf__106_v0 "\\x1b[1;3;97;41m%s\\x1b[0m
" array_4[@]
    if [ "$(( ${exit_code} > 0 ))" != 0 ]; then
        exit "${exit_code}"
    fi
}

ensure_run_as_root__124_v0() {
    command_5="$(id -u)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_ensure_run_as_root124_v0=''
        return "${__status}"
    fi
    id_7="${command_5}"
    if [ "$([ "_${id_7}" == "_0" ]; echo $?)" != 0 ]; then
        echo_error__116_v0 "This script must be run as root" 1
        ret_ensure_run_as_root124_v0=''
        return 1
    fi
}

clean_up__125_v0() {
    rm -rf /var/lib/apt/lists/*
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_clean_up125_v0=''
        return "${__status}"
    fi
}

get_architecture__126_v0() {
    command_6="$(dpkg --print-architecture)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_get_architecture126_v0=''
        return "${__status}"
    fi
    arch_12="${command_6}"
    if [ "$([ "_${arch_12}" != "_amd64" ]; echo $?)" != 0 ]; then
        ret_get_architecture126_v0="x86_64"
        return 0
    elif [ "$([ "_${arch_12}" != "_arm64" ]; echo $?)" != 0 ]; then
        ret_get_architecture126_v0="aarch64"
        return 0
    else
        echo_error__116_v0 "Unsupported architecture: ${arch_12}" 1
        ret_get_architecture126_v0=''
        return 1
    fi
}

ensure_packages__127_v0() {
    local packages=("${!1}")
    # Check if packages are already installed
    dpkg -s ${packages[@]} > /dev/null 2>&1
    __status=$?
    if [ "${__status}" != 0 ]; then
        # At least some packages are missing
        # We first check, if we need an update
        command_7="$(find /var/lib/apt/lists/* | wc -l)"
        __status=$?
        if [ "${__status}" != 0 ]; then
            ret_ensure_packages127_v0=''
            return "${__status}"
        fi
        if [ "$([ "_${command_7}" != "_0" ]; echo $?)" != 0 ]; then
            echo "Running apt-get update..."
            apt-get update -y
            __status=$?
            if [ "${__status}" != 0 ]; then
                ret_ensure_packages127_v0=''
                return "${__status}"
            fi
        fi
        apt-get -y install --no-install-recommends ${packages[@]}
        __status=$?
        if [ "${__status}" != 0 ]; then
            ret_ensure_packages127_v0=''
            return "${__status}"
        fi
    fi
}

prepare__128_v0() {
    ensure_run_as_root__124_v0 
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_prepare128_v0=''
        return "${__status}"
    fi
    clean_up__125_v0 
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_prepare128_v0=''
        return "${__status}"
    fi
    env_var_set__97_v0 "DEBIAN_FRONTEND" "noninteractive"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_prepare128_v0=''
        return "${__status}"
    fi
}

read_param__129_v0() {
    local name=$1
    local default=$2
    env_var_get__98_v0 "${name}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        :
    fi
    ret_read_param129_v0="${ret_env_var_get98_v0}"
    return 0
}

fetch_latest_version__130_v0() {
    local repo_owner=$1
    local repo_name=$2
    url_9="https://api.github.com/repos/${repo_owner}/${repo_name}/releases/latest"
    command_8="$(curl -sL ${url_9} | jq -r .tag_name)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_fetch_latest_version130_v0=''
        return "${__status}"
    fi
    ret_fetch_latest_version130_v0="${command_8}"
    return 0
}

normalize_version__131_v0() {
    local version=$1
    starts_with__23_v0 "${version}" "v"
    ret_starts_with23_v0__66_8="${ret_starts_with23_v0}"
    if [ "${ret_starts_with23_v0__66_8}" != 0 ]; then
        slice__25_v0 "${version}" 1 0
        ret_normalize_version131_v0="${ret_slice25_v0}"
        return 0
    fi
    ret_normalize_version131_v0="${version}"
    return 0
}

download_file__132_v0() {
    local url=$1
    local local_filename=$2
    echo "Downloading from ${url}..."
    wget -qO ${local_filename} ${url}
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_download_file132_v0=''
        return "${__status}"
    fi
}

verify_sha256__133_v0() {
    local url=$1
    echo "Checking sha256sum..."
    wget -qO- "${url}.sha256" | sha256sum -c -
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_verify_sha256133_v0=''
        return "${__status}"
    fi
}

extract_archive__134_v0() {
    local filename=$1
    echo "Extracting ${filename}..."
    tar -xf ${filename}
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_extract_archive134_v0=''
        return "${__status}"
    fi
}

install_binary__135_v0() {
    local binary_name=$1
    local install_dir=$2
    echo "Installing ${binary_name} to ${install_dir}..."
    file_chmod__45_v0 "${binary_name}" "+x"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_install_binary135_v0=''
        return "${__status}"
    fi
    mv "${binary_name}" "${install_dir}/${binary_name}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_install_binary135_v0=''
        return "${__status}"
    fi
}

cleanup_temp_dir__136_v0() {
    local temp_dir=$1
    cd "-" || exit
    clean_up__125_v0 
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_cleanup_temp_dir136_v0=''
        return "${__status}"
    fi
    rm -rf ${temp_dir}
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_cleanup_temp_dir136_v0=''
        return "${__status}"
    fi
}

# Config
__BINARY_NAME_3="gleam"
__REPO_OWNER_4="gleam-lang"
__REPO_NAME_5="gleam"
base_packages_6=("ca-certificates" "wget")
prepare__128_v0 
__status=$?
if [ "${__status}" != 0 ]; then
    exit "${__status}"
fi
# Read parameters
read_param__129_v0 "VERSION" "latest"
version_8="${ret_read_param129_v0}"
# Ensure necessary packages
if [ "$([ "_${version_8}" != "_latest" ]; echo $?)" != 0 ]; then
    array_11=("jq" "curl")
    array_add_12=("${base_packages_6[@]}" "${array_11[@]}")
    ensure_packages__127_v0 array_add_12[@]
    __status=$?
    if [ "${__status}" != 0 ]; then
        exit "${__status}"
    fi
    fetch_latest_version__130_v0 "${__REPO_OWNER_4}" "${__REPO_NAME_5}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        exit "${__status}"
    fi
    version_8="${ret_fetch_latest_version130_v0}"
else
    ensure_packages__127_v0 base_packages_6[@]
    __status=$?
    if [ "${__status}" != 0 ]; then
        exit "${__status}"
    fi
fi
normalize_version__131_v0 "${version_8}"
version_8="${ret_normalize_version131_v0}"
# Setup temporary directory
temp_dir_11="/tmp/gleam-feature"
echo "Preparing installation in ${temp_dir_11}..."
mkdir -p ${temp_dir_11}
__status=$?
if [ "${__status}" != 0 ]; then
    exit "${__status}"
fi
cd "${temp_dir_11}" || exit
get_architecture__126_v0 
__status=$?
if [ "${__status}" != 0 ]; then
    exit "${__status}"
fi
arch_13="${ret_get_architecture126_v0}"
filename_14="${__BINARY_NAME_3}-v${version_8}-${arch_13}-unknown-linux-musl.tar.gz"
url_15="https://github.com/${__REPO_OWNER_4}/${__REPO_NAME_5}/releases/download/v${version_8}/${filename_14}"
echo "Installing ${__BINARY_NAME_3} ${version_8}..."
download_file__132_v0 "${url_15}" "${filename_14}"
__status=$?
if [ "${__status}" != 0 ]; then
    exit "${__status}"
fi
verify_sha256__133_v0 "${url_15}"
__status=$?
if [ "${__status}" != 0 ]; then
    exit "${__status}"
fi
extract_archive__134_v0 "${filename_14}"
__status=$?
if [ "${__status}" != 0 ]; then
    exit "${__status}"
fi
install_binary__135_v0 "${__BINARY_NAME_3}" "/usr/local/bin"
__status=$?
if [ "${__status}" != 0 ]; then
    exit "${__status}"
fi
# Clean up
cleanup_temp_dir__136_v0 "${temp_dir_11}"
__status=$?
if [ "${__status}" != 0 ]; then
    exit "${__status}"
fi
echo "Done"'!'""
