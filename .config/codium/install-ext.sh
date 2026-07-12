#!/bin/sh

# List of all extensions to install from
# open-vsx registry
EXTENSIONS=(
    "ahmadalli.vscode-nginx-conf"
    "esbenp.prettier-vscode"
    "golang.go"
    "gruntfuggly.todo-tree"
    "jeanp413.open-remote-ssh"
    "josee9988.minifyall"
    "ms-azuretools.vscode-containers"
    "ms-azuretools.vscode-docker"
    "ms-python.debugpy"
    "ms-python.python"
    "ms-python.vscode-python-envs"
    "pkief.material-icon-theme"
    "redhat.vscode-yaml"
    "samuelcolvin.jinjahtml"
    "shardulm94.trailing-spaces"
    "svelte.svelte-vscode"
    "vue.volar"
)

for ext in ${EXTENSIONS[@]}; do
    codium --install-extension $ext
done

