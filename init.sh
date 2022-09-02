#!/bin/bash

function read_confirm() {
    if [[ -n $ZSH_VERSION ]]; then
        read -rsq confirm
    else
        read -rsn1 confirm
    fi
    echo
    if [[ $confirm == "y" || -z $confirm ]]; then
        return 0
    fi
    return 1
}

# ---------------------------- Start ----------------------------

# Check brew
BREW_INSTALLED=$(command -v brew &> /dev/null)

if ! $BREW_INSTALLED; then
    printf "brew not found. Install? [Y/n] "
    if read_confirm; then
        echo "Installing brew (https://brew.sh/)"
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        BREW_INSTALLED=true
    else
        echo "Not installing brew"
    fi
fi

if $BREW_INSTALLED; then
    brew_packages=(
        bat
        diff-so-fancy
        git
        git-gui
        the_silver_searcher
        tig
    )

    echo "Installing the following brew packages:"
    printf "  %s\n" "${brew_packages[@]}"
    printf "Continue? [Y/n] "
    if read_confirm; then
        eval "brew install ${brew_packages[@]}"
    fi
fi
echo

# Get basic info
printf "Full Name (git): "; read fullname
printf "Email (git): "; read email
echo

COMMAND="    # basic config
    git config --global user.name \"$fullname\"
    git config --global user.email \"$email\"
    git config --global core.editor /usr/bin/vim
    git config --global core.excludesFile $(pwd)/gitignore_global
    git config --global init.defaultBranch main
    git config --global push.default simple
    git config --global rerere.enabled true

    # diff-so-fancy
    git config --global core.pager \"diff-so-fancy | less --tabs=4 -RFX\"
    git config --global interactive.diffFilter \"diff-so-fancy --patch\"
    git config --global color.ui true
    git config --global color.diff-highlight.oldNormal \"red bold\"
    git config --global color.diff-highlight.oldHighlight \"red bold 52\"
    git config --global color.diff-highlight.newNormal \"green bold\"
    git config --global color.diff-highlight.newHighlight \"green bold 22\"
    git config --global color.diff.meta \"11\"
    git config --global color.diff.frag \"magenta bold\"
    git config --global color.diff.func \"146 bold\"
    git config --global color.diff.commit \"yellow bold\"
    git config --global color.diff.old \"red bold\"
    git config --global color.diff.new \"green bold\"
    git config --global color.diff.whitespace \"red reverse\"
"

echo "Running the following commands:"
echo "$COMMAND"

printf "Continue? [Y/n] "
if read_confirm; then
    eval "$COMMAND"
fi
