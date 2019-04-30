#!/bin/bash

set -Ce

PROJECT_DIR="${HOME}"/project
SETUP_DIR="${PROJECT_DIR}"/setup

function version {
    echo "$(basename ${0}) version 0.1 "
}

function usage {
    cat <<EOF
$(basename ${0}) is a tool for mac provision script

Usage:
    $(basename ${0}) [command] [<options>]

Command:
    run             execute provision
    version, -v     print $(basename ${0}) version
    help, -h        print this

Options:
    --debug, -d       set debug flug
EOF
}

function run {
    echo "[INFO] $(date "+%Y/%m/%d %H:%M:%S") install homebrew ..."
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

    echo "[INFO] $(date "+%Y/%m/%d %H:%M:%S") install python & ansible ..."
    brew install git, python, ansible

    echo "[INFO] $(date "+%Y/%m/%d %H:%M:%S") clone setup repo ..."
    mkdir "${PROJECT_DIR}"
    git clone https://github.com/tetu87kamura/setup.git "${SETUP_DIR}"

    echo "[INFO] $(date "+%Y/%m/%d %H:%M:%S") execute ansible ..."
    cd "${SETUP_DIR}"/mac/ansible
    ansible-playbook sites_localhost.yml -i hosts_localhost --ask-become-pass
}

if [[ ${#} == 0 || ${#} -gt 2 ]]; then
    usage
    exit 1
fi

case ${1} in
    run)
        if [[ ${2} == "" ]]; then
            run
        elif [[ ${2} =~ debug|--debug|-d ]]; then
            set -Cex
            run
        else
            echo "[ERROR] Invalid option '${2}'"
            usage
            exit 1
        fi
    ;;

    version|--version|-v)
        version
        exit 0
    ;;

    help|--help|-h)
        usage
        exit 0
    ;;

    *)
        echo "[ERROR] Invalid command '${1}'"
        usage
        exit 1
    ;;
esac
