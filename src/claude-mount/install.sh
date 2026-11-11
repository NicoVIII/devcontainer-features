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
# env_var_test(name: Text)
env_var_test__117_v0() {
    local name_39="${1}"
    if [ "$([ "_${EXEC_SHELL}" != "_zsh" ]; echo $?)" != 0 ]; then
        [[ ! -z ${(P)name_39+z} ]]
        __status=$?
        if [ "${__status}" != 0 ]; then
            ret_env_var_test117_v0=0
            return 0
        fi
    elif [ "$([ "_${EXEC_SHELL}" != "_bash" ]; echo $?)" != 0 ]; then
        declare -p -- "${name_39}" > /dev/null 2> /dev/null
        __status=$?
        if [ "${__status}" != 0 ]; then
            ret_env_var_test117_v0=0
            return 0
        fi
    elif [ "$([ "_${EXEC_SHELL}" != "_ksh" ]; echo $?)" != 0 ]; then
        eval "[ \"\${$name_39+x}\" = x ]"
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
    local name_29="${1}"
    local val_30="${2}"
    export $name_29="$val_30" 2> /dev/null
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
        local command_0
        command_0="$(printf "%s
" "${!name_40}")"
        __status=$?
        if [ "${__status}" != 0 ]; then
            ret_env_var_get120_v0=''
            return "${__status}"
        fi
        ret_env_var_get120_v0="${command_0}"
        return 0
    elif [ "$([ "_${EXEC_SHELL}" != "_zsh" ]; echo $?)" != 0 ]; then
        local command_1
        command_1="$(printf "%s
" "${(P)name_40}")"
        __status=$?
        if [ "${__status}" != 0 ]; then
            ret_env_var_get120_v0=''
            return "${__status}"
        fi
        ret_env_var_get120_v0="${command_1}"
        return 0
    elif [ "$([ "_${EXEC_SHELL}" != "_ksh" ]; echo $?)" != 0 ]; then
        local command_2
        command_2="$(eval "echo \${$name_40}")"
        __status=$?
        if [ "${__status}" != 0 ]; then
            ret_env_var_get120_v0=''
            return "${__status}"
        fi
        ret_env_var_get120_v0="${command_2}"
        return 0
    fi
}

# printf(format: Text, args: [Text])
printf__128_v0() {
    local format_27="${1}"
    local args_28=("${!2}")
    args_28=("${format_27}" "${args_28[@]}")
    __status=$?
    printf "${args_28[@]}"
    __status=$?
}

# echo_error(message: Text, exit_code: Int)
echo_error__138_v0() {
    local message_25="${1}"
    local exit_code_26="${2}"
    local array_3=("${message_25}")
    printf__128_v0 "\\x1b[1;3;97;41m%s\\x1b[0m
" array_3[@]
    if [ "$(( exit_code_26 > 0 ))" != 0 ]; then
        exit "${exit_code_26}"
    fi
}

# ensure_run_as_root()
ensure_run_as_root__159_v0() {
    local command_4
    command_4="$(id -u)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_ensure_run_as_root159_v0=''
        return "${__status}"
    fi
    local id_24="${command_4}"
    if [ "$([ "_${id_24}" == "_0" ]; echo $?)" != 0 ]; then
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

# read_param(name: Text, default: Text)
read_param__165_v0() {
    local name_37="${1}"
    local default_38="${2}"
    # env_var_get succeeds with "" for an unset variable, so its failure cannot drive the fallback
    env_var_test__117_v0 "${name_37}"
    local ret_env_var_test117_v0__6_8="${ret_env_var_test117_v0}"
    if [ "${ret_env_var_test117_v0__6_8}" != 0 ]; then
        env_var_get__120_v0 "${name_37}"
        __status=$?
        ret_read_param165_v0="${ret_env_var_get120_v0}"
        return 0
    fi
    ret_read_param165_v0="${default_38}"
    return 0
}

# The devcontainer CLI bind-mounts the host's ~/.claude here (see the "mounts" entry in
# devcontainer-feature.json). A neutral, user-independent path keeps the symlink target
# stable regardless of which remote user the base image ships with.
__MOUNT_PATH_3="/mnt/host-claude"
prepare__161_v0 
__status=$?
if [ "${__status}" != 0 ]; then
    exit "${__status}"
fi
# _REMOTE_USER_HOME is injected by the devcontainer CLI and differs per base image
# (e.g. /root, /home/vscode). Symlinking here makes ~/.claude resolve to the mount.
read_param__165_v0 "_REMOTE_USER_HOME" "/root"
home_41="${ret_read_param165_v0}"
link_42="${home_41}/.claude"
# ln -sfn would silently create the link *inside* an existing real directory
[ ! -e "${link_42}" ] || [ -L "${link_42}" ]
__status=$?
if [ "$(( __status != 0 ))" != 0 ]; then
    echo_error__138_v0 "${link_42} already exists and is not a symlink. Remove it from the image or install this feature before whatever creates it." 1
    exit 1
fi
echo "Linking ${link_42} -> ${__MOUNT_PATH_3} ..."
ln -sfn "${__MOUNT_PATH_3}" "${link_42}"
__status=$?
if [ "${__status}" != 0 ]; then
    exit "${__status}"
fi
echo "Done"'!'""
