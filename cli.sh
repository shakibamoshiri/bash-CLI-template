#!/bin/bash

################################################################################
# Bash CLI template
# A more flexible CLI parser (way of parsing)
# 20XX (C) Shakiba Moshiri
################################################################################

################################################################################
# an associative array for storing color and a function for colorizing
################################################################################
declare -A _colors_;
_colors_[ 'red' ]='\x1b[0;31m';
_colors_[ 'green' ]='\x1b[0;32m';
_colors_[ 'yellow' ]='\x1b[0;33m';
_colors_[ 'cyan' ]='\x1b[0;36m';
_colors_[ 'white' ]='\x1b[0;37m';
_colors_[ 'reset' ]='\x1b[0m';

function colorize(){
    if [[ ${_colors_[ $1 ]} ]]; then
        echo -e "${_colors_[ $1 ]}$2${_colors_[ 'reset' ]}";
    else
        echo 'wrong color name!';
    fi
}

function print_title(){
    echo $(colorize cyan "$@");
}


################################################################################
# key-value array
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


################################################################################
# __help function
################################################################################
function _os_help(){
    echo -e  "
 -O │ --os              OS actions
    ├── $(colorize 'cyan' 'type')            show / check the name
    ├── $(colorize 'cyan' 'version')         show / check the version
    ├── $(colorize 'cyan' 'update')          update the OS
    ├── $(colorize 'cyan' 'upgrade')         upgrade the OS
    └── $(colorize 'cyan' 'info')            more info about OS ";
}

function _docker_help(){
    echo -e "
 -D │ --docker          docker actions
    ├── $(colorize 'cyan' 'docker')          install docker
    ├── $(colorize 'cyan' 'remove')          uninstall docker
    ├── $(colorize 'cyan' 'compose')         install docker-compose
    └── $(colorize 'cyan' 'kubectl')         install kubernetes CLI";
}

function _port_help(){
    echo -e "
 -P │ --port            manage firewall
    ├── $(colorize 'cyan' 'stop')            stop all firewalls
    ├── $(colorize 'cyan' 'start')           start all firewalls
    ├── $(colorize 'cyan' 'disable')         disable all firewalls
    ├── $(colorize 'cyan' 'enable')          enable all firewalls
    └── $(colorize 'yellow' '<NUMBER>')        open this port number";
}

function _help(){
    echo -e  " $0
 -h │ --help            print this help

$(_os_help)
$(_docker_help)
$(_port_help)

Developer Shakiba Moshiri
source    https://github.com/k-five/bash-CLI-template"

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
    mapfile -t _options_ < <(tr ' ' '\n' <<< "$arg");
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
