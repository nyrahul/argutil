#!/bin/bash

arg_shortopts="h"
arg_longopts="help "
declare -A arg_desclist
declare -A arg_handlers
declare -A arg_nvlist

argopt()
{
	mand=""
	arg=""
	handler="none"
	OPTS=$(getopt -o "s:l:d:" --long "needval sopt: lopt: desc: reqarg mandatory handler:" -n 'parse-options' -- "$@")
    eval set -- "$OPTS"
    while true; do
        case "$1" in
            --sopt | -s ) sopt="$2";    shift 2;;
            --lopt | -l ) lopt="$2";    shift 2;;
            --desc | -d ) desc="$2";    shift 2;;
            --handler)    handler="$2"; shift 2;;
            --needval)    arg=":";      shift 1;;
            --mandatory)  mand="*";     shift 1;;
            -h | --help )              return 2;;
            -- ) shift; break ;;
            * ) break ;;
        esac
    done
	[[ "$lopt" == "" ]] && echo "ERROR(argopt): long option is a mandatory field!" && return 1
	arg_desclist["$lopt"]=$(echo "-$sopt|--$lopt $arg => $desc. $mand")
	arg_handlers["$lopt"]=$handler
	arg_shortopts="$arg_shortopts$sopt$arg"
	arg_longopts="$arg_longopts$lopt$arg "
	arg_nvlist["$lopt"]=$arg
	return 0
}

arghelp()
{
	echo "Supported options:"
	printf '\t%s\n' "${arg_desclist[@]}"
}

arghandle()
{
	handler=${arg_handlers["$1"]}
	needval=${arg_nvlist["$1"]}
	[[ "$needval" == ":" ]] && $handler "$2" && return 2
	$handler
	return 1
}

argrun()
{
	[[ "$arg_shortopts" == "" ]] && [[ "$arg_longopts" == "" ]] && echo "no cmdopt() specified" && return

    OPTS=`getopt -o $arg_shortopts --long "$arg_longopts" -n 'parse-options' -- "$@"`
    eval set -- "$OPTS"
    while true; do
		case "$1" in
			-h | --help) arghelp; exit 2;;
			--) shift; break ;;
			*) arghandle ${1/--/} $2; shift $?;;
		esac
    done
}

