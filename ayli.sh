#!/bin/bash
set -euo pipefail

if [[ "$(which readlink)" =~ "which: no readlink in" ]]; then
    echo "ERROR: Dependency missing, please install readlink"
    exit 1
fi

WORKSPACE="$(dirname "$(readlink -f "$BASH_SOURCE")")"
mkdir -p "$WORKSPACE"/alias

get_template() {
    if [[ -z "${1-}" ]]; then
        echo "ERROR: function get_template requires 1 argument"
        exit 1
    fi
    if [[ -d "$WORKSPACE"/templates/"$1" ]]; then
        template="$1"
    elif [[ -f "$WORKSPACE"/alias/"$1" ]]; then
        template="$(cat "$WORKSPACE"/alias/"$1")"
    else
        echo "ERROR: template $1 not found"
        return 1
    fi
}

if [[ -z "${1-}" ]]; then
    get_template default
else
    {
        get_template "$1"
        name="${2-}"
    } || {
        echo "Fallbak to default template"
        get_template default
        name="$1"
    }
fi

if [[ -z "${name-}" ]]; then
    read -rp "Package name: " name
fi

cp -R "$WORKSPACE"/templates/"$template" "$name"
cd "$name"
git init
if [[ -f package.json ]]; then
    echo "Config yarn package"
    sed -i "s|\$name|$name|g" package.json
    for file in .git/hooks/*; do
        filename="$(basename "$file")"
        if [[ ! "$filename" =~ "." ]]; then
            cp .git/hooks/"$filename" .husky/
        fi
    done
    yarn
    yarn init
fi
