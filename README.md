# Another Yarn-Like Init

### Installation

`git clone https://github.com/haoadoreorange/ayli.git "$HOME"/.ayli && bash "$HOME"/.ayli/install.sh` 

Include `"$HOME"/.local/bin` in your `PATH` if not yet.

### Usage
`ayli <template> <destination>`

OR

`ayli <destination>` // use default template

OR

`ayli` // use default template & prompt for destination

with

`<template>` name of the dir being used as a template in `templates/`.

`<destination>` path to the new package folder.

### Alias
You can define alias by creating files in `alias` dir, for example a file named `default` containing `ts-node` define an alias from `default` -> `ts-node`.

In fact this is how the default template is defined.

### config file
You can put package informations in a `config` file to be used automatically, for example
```
REPOSITORY=https://github.com/
AUTHOR=someone
```
