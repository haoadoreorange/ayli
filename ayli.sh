#!/bin/bash
set -euo pipefail

if [[ "$(which realpath)" =~ "which: no realpath in" ]]; then
    echo "ERROR: Dependency missing, please install realpath"
    exit 1
fi

WORKSPACE="$(dirname "$(realpath "$BASH_SOURCE")")"
mkdir -p "$WORKSPACE"/alias

get_template() {
    if [[ -z "${1-}" ]]; then
        echo "ERROR: fn get_template requires 1 argument"
        exit 1
    fi
    if [[ "$1" == "default" ]]; then
        echo "Use default template"
    fi
    if [[ -d "$WORKSPACE"/templates/"$1" ]]; then
        template="$1"
    elif [[ -f "$WORKSPACE"/alias/"$1" ]]; then
        template="$(cat "$WORKSPACE"/alias/"$1")"
    else
        if [[ "${2-}" != "fail-silent" ]]; then
            echo "ERROR: template $1 not found"
        fi
        return 1
    fi
}

if [[ -z "${1-}" ]]; then
    get_template default
else
    {
        get_template "$1" fail-silent && path="${2-}"
    } || {
        get_template default
        path="$1"
    }
fi

if [[ -z "${path-}" ]]; then
    read -rp "Path to new package folder: " path
fi

if [[ -f "$WORKSPACE"/config ]]; then
    . "$WORKSPACE"/config
fi

cp -R "$WORKSPACE"/templates/"$template" "$path"
cd "$path"
git init
name="$(basename "$path")"
if [[ -f package.json ]]; then
    echo "Config yarn package"
    sed -i "s|\$name|$name|g" package.json
    if [[ -n "${REPOSITORY-}" ]]; then
        sed -i "s|\$repository|$REPOSITORY|g" package.json
    fi
    if [[ -n "${AUTHOR-}" ]]; then
        sed -i "s|\$author|$AUTHOR|g" package.json
    fi
    for file in .git/hooks/*; do
        filename="$(basename "$file")"
        if [[ ! "$filename" =~ "." ]]; then
            if [[ ! -f .husky/"$filename" ]]; then
                cp .git/hooks/"$filename" .husky/
            else
                cp .git/hooks/"$filename" .husky/"$filename".local
            fi
        fi
    done
    yarn init
fi
