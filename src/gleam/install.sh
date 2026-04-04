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
    result_8="${command_0}"
    ret_starts_with23_v0="$([ "_${result_8}" != "_1" ]; echo $?)"
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

env_var_set__98_v0() {
    local name=$1
    local val=$2
    export $name="$val" 2> /dev/null
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_env_var_set98_v0=''
        return "${__status}"
    fi
}

env_var_get__99_v0() {
    local name=$1
    command_3="$(echo ${!name})"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_env_var_get99_v0=''
        return "${__status}"
    fi
    ret_env_var_get99_v0="${command_3}"
    return 0
}

printf__107_v0() {
    local format=$1
    local args=("${!2}")
    args=("${format}" "${args[@]}")
    __status=$?
    printf "${args[@]}"
    __status=$?
}

echo_error__117_v0() {
    local message=$1
    local exit_code=$2
    array_4=("${message}")
    printf__107_v0 "\\x1b[1;3;97;41m%s\\x1b[0m
" array_4[@]
    if [ "$(( ${exit_code} > 0 ))" != 0 ]; then
        exit "${exit_code}"
    fi
}

# Lib
ensure_run_as_root__124_v0() {
    command_5="$(id -u)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_ensure_run_as_root124_v0=''
        return "${__status}"
    fi
    id_4="${command_5}"
    if [ "$([ "_${id_4}" == "_0" ]; echo $?)" != 0 ]; then
        echo_error__117_v0 "This script must be run as root" 1
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
    arch_6="${command_6}"
    if [ "$([ "_${arch_6}" != "_amd64" ]; echo $?)" != 0 ]; then
        ret_get_architecture126_v0="x86_64"
        return 0
    elif [ "$([ "_${arch_6}" != "_arm64" ]; echo $?)" != 0 ]; then
        ret_get_architecture126_v0="aarch64"
        return 0
    else
        echo_error__117_v0 "Unsupported architecture: ${arch_6}" 1
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

# Specific
# Config
needed_packages_3=("ca-certificates" "wget")
# Preparations
ensure_run_as_root__124_v0 
__status=$?
if [ "${__status}" != 0 ]; then
    exit "${__status}"
fi
clean_up__125_v0 
__status=$?
if [ "${__status}" != 0 ]; then
    exit "${__status}"
fi
# Read params
env_var_get__99_v0 "VERSION"
__status=$?
if [ "${__status}" != 0 ]; then
    :
fi
version_5="${ret_env_var_get99_v0}"
# Use tmp directory for installation
echo "Change into tmp directory"
mkdir -p /tmp/gleam-feature
__status=$?
if [ "${__status}" != 0 ]; then
    exit "${__status}"
fi
cd "/tmp/gleam-feature" || exit
env_var_set__98_v0 "DEBIAN_FRONTEND" "noninteractive"
__status=$?
if [ "${__status}" != 0 ]; then
    exit "${__status}"
fi
get_architecture__126_v0 
__status=$?
if [ "${__status}" != 0 ]; then
    exit "${__status}"
fi
arch_7="${ret_get_architecture126_v0}"
if [ "$([ "_${version_5}" != "_latest" ]; echo $?)" != 0 ]; then
    array_10=("jq" "curl")
    array_add_11=("${needed_packages_3[@]}" "${array_10[@]}")
    ensure_packages__127_v0 array_add_11[@]
    __status=$?
    if [ "${__status}" != 0 ]; then
        exit "${__status}"
    fi
    command_12="$(curl -sL https://api.github.com/repos/gleam-lang/gleam/releases/latest | jq -r .tag_name)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        exit "${__status}"
    fi
    version_5="${command_12}"
else
    ensure_packages__127_v0 needed_packages_3[@]
    __status=$?
    if [ "${__status}" != 0 ]; then
        exit "${__status}"
    fi
fi
# Remove leading "v" if present
starts_with__23_v0 "${version_5}" "v"
ret_starts_with23_v0__72_8="${ret_starts_with23_v0}"
if [ "${ret_starts_with23_v0__72_8}" != 0 ]; then
    slice__25_v0 "${version_5}" 1 0
    version_5="${ret_slice25_v0}"
fi
url_9="https://github.com/gleam-lang/gleam/releases/download/v${version_5}/gleam-v${version_5}-${arch_7}-unknown-linux-musl.tar.gz"
echo "Downloading Gleam ${version_5} for ${arch_7} from ${url_9}..."
wget -qO "gleam-v${version_5}-${arch_7}-unknown-linux-musl.tar.gz" ${url_9}
__status=$?
if [ "${__status}" != 0 ]; then
    exit "${__status}"
fi
echo "Checking sha256sum..."
wget -qO- "${url_9}.sha256" | sha256sum -c -
__status=$?
if [ "${__status}" != 0 ]; then
    exit "${__status}"
fi
echo "Extract and move to /usr/local/bin..."
tar xf "gleam-v${version_5}-${arch_7}-unknown-linux-musl.tar.gz"
__status=$?
if [ "${__status}" != 0 ]; then
    exit "${__status}"
fi
file_chmod__45_v0 "gleam" "+x"
__status=$?
if [ "${__status}" != 0 ]; then
    exit "${__status}"
fi
mv "gleam" "/usr/local/bin/"
__status=$?
if [ "${__status}" != 0 ]; then
    exit "${__status}"
fi
# Clean up
cd "-" || exit
clean_up__125_v0 
__status=$?
if [ "${__status}" != 0 ]; then
    exit "${__status}"
fi
rm -rf /tmp/gleam-feature
__status=$?
if [ "${__status}" != 0 ]; then
    exit "${__status}"
fi
echo "Done"'!'""
