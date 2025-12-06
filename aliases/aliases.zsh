#!/bin/zsh

# Aliases de navegación
alias cdh="cd $HOME"
alias cdc="cd $HOME/$CODE_DIR"
alias cdw="cd $HOME/$CODE_DIR/$WORK_DIR"
alias ls='ls -GA'

# NPM aliases
alias na="npm add"
alias ni="npm install"
alias nig="npm install --global"
alias nins="npm install --no-save"
alias nip="npm install --save-prod"
alias nid="npm install --save-dev"
alias nie="npm install --save-exact"
alias nide="npm install --save-dev --save-exact"
alias nipe="npm install --save-prod --save-exact"
alias nu="npm uninstall"
alias nr="npm remove"

# YARN aliases
alias y="yarn"
alias yi="yarn install"
alias ya="yarn add"
alias yad="yarn add --dev"
alias yap="yarn add --peer"
alias yag="yarn global add"
alias yre="yarn remove"
alias yreg="yarn global remove"
alias yl="yarn link"
alias yu="yarn unlink"
alias yw="yarn workspace"
alias ywi="yarn workspaces info"
alias yx="yarn dlx"

# GRUPO_SANTANDER aliases
alias eth0mtu="sudo ip link set dev eth0 mtu 1360"
alias app="cd app"

alias run:dev="yarn dev:nodemon"
alias run:start="yarn start"
alias run:start:cc="yarn start:cc"
alias run:start:unlinked="yarn start:unlinked"
alias run:start:unlinked:cc="yarn start:unlinked:cc"
alias run:wiremock="wiremock_run_server"
alias npm:jfrog='npm login --auth-type=web'

# FZF aliases
alias gswz="git for-each-ref refs/heads --format '%(refname:short)' | fzf | xargs git switch"

# ZSH aliases
alias zrc="vim $HOME/.zshrc"
alias zp="vim $HOME/.zprofile"

# BREW aliases
alias brew:cask:on='export HOMEBREW_CASK_OPTS="--appdir=$HOME/Applications"'
alias brew:cask:off="unset HOMEBREW_CASK_OPTS"

# Directory cleanup aliases
alias sad="seek_and_destroy"
alias sad:node_modules="seek_and_destroy --dir node_modules --verbose"
alias sad:dist="seek_and_destroy --dir dist --verbose"
alias sad:yalc="seek_and_destroy --dir .yalc --verbose"
alias sad:all="sad:node_modules --no-confirm && sad:dist --no-confirm && sad:yalc --no-confirm"

# Git aliases
alias gcls="no_branch_for_old_refs"
alias gcls:all="no_branch_for_old_refs --all"
alias gmup="paranoid_sync"
alias gmup:all="paranoid_sync --all"
alias gce="git commit --allow-empty -m 'empty commit'"
alias gmomn='gmom --no-edit'
alias gmn='gm --no-edit'

# Utility aliases
alias goto="goto"
alias deploy="deploy"
alias sudo="sudo "
