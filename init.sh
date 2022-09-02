#!/bin/bash

printf "Full Name (git): "; read fullname
printf "Email (git): "; read email

# basic config
git config --global user.name $fullname
git config --global user.email $email
git config --global core.editor /usr/bin/vim
git config --global core.excludesFile $(pwd)/gitignore_global
git config --global init.defaultBranch main
git config --global push.default simple
git config --global rerere.enabled true

# diff-so-fancy
git config --global core.pager "diff-so-fancy | less --tabs=4 -RFX"
git config --global interactive.diffFilter "diff-so-fancy --patch"
git config --global color.ui true
git config --global color.diff-highlight.oldNormal "red bold"
git config --global color.diff-highlight.oldHighlight "red bold 52"
git config --global color.diff-highlight.newNormal "green bold"
git config --global color.diff-highlight.newHighlight "green bold 22"
git config --global color.diff.meta "11"
git config --global color.diff.frag "magenta bold"
git config --global color.diff.func "146 bold"
git config --global color.diff.commit "yellow bold"
git config --global color.diff.old "red bold"
git config --global color.diff.new "green bold"
git config --global color.diff.whitespace "red reverse"
