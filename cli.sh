#!/bin/bash

################################################################################
# Bash CLI template
# A more flexible CLI parser (way of parsing)
# 20XX (C) Shakiba Moshiri
################################################################################

declare -A _os;
_os['flag']=0;
_os['args']='';

declare -A _docker;
_docker['flag']=0;
_docker['args']='';

declare -A _port;
_port['flag']=0;
_port['args']='';

function _help(){
echo "
 --os      os commands
 --docker  Docker commands
 --port    Port commands
"; 
exit 0;
}

if [[ ${#} == 0 ]]; then
    _help;
fi

# /--?[a-zA-Z][^-]*
# this pattern does not work well when we have more dashes -
#
# new one non-group match
# https://stackoverflow.com/questions/36754105/not-group-in-regex
# (?:(?! -).)+
# (?:(?! -)[\s\S])+
mapfile -t ARGS < <( perl -lne 'print $& while /(?:(?! -)[\s\S])+/ig' <<< "$@");
if [[ ${#ARGS[@]} == 0 ]]; then
    _help;
fi

function _os_call(){
    echo "_os_call";
    echo "flag: ${_os['flag']}";
    echo "args: ${_os['args']}";
}

function _docker_call(){
    echo "_docker_call";
    echo "flag: ${_docker['flag']}";
    echo "args: ${_docker['args']}";
}

function _port_call(){
    echo "_port_call";
    echo "flag: ${_port['flag']}";
    echo "args: ${_port['args']}";
}

for arg in "${ARGS[@]}"; do
    # echo "arg: $arg";
    mapfile -t _options_ < <(echo "$arg" | tr ' ' '\n');
    # echo "'${_options_[0]}' =>  ${_options_[@]:1}"

    case ${_options_[0]} in
        --os )
            _os['flag']=1;
            _os['args']=${_options_[@]:1}
            _os_call;
        ;;
        --docker )
            _docker['flag']=1;
            _docker['args']=${_options_[@]:1}
            _docker_call;
        ;;
        --port )
            _port['flag']=1;
            _port['args']=${_options_[@]:1}
            _port_call;
        ;;
        -h | --help )
            _help;
        ;;
        * )
            echo "unknown options: ${_options_[0]}";
        ;;
    esac
done
