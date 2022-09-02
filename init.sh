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

# Install Xcode command line tools
if [[ ! $(xcode-select -p 1>/dev/null;echo $?) ]]; then
    xcode-select --install
    echo
fi

# Install oh-my-zsh
OMZ_INSTALLED=$(test -d ~/.oh-my-zsh)
if ! $OMZ_INSTALLED; then
    printf "Install oh-my-zsh (https://github.com/ohmyzsh/ohmyzsh)? [Y/n] "
    if read_confirm; then
        sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    fi
    echo
fi

if $OMZ_INSTALLED; then
    omz_plugins=(
        npm
        macos
        zsh-autosuggestions
    )

    echo "Enabling the following oh-my-zsh plugins:"
    printf "  %s\n" "${omz_plugins[@]}"
    printf "Continue? [Y/n] "
    if read_confirm; then
        echo "Installing zsh-autosuggestions..."
        git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
        eval "omz plugin enable ${omz_plugins[@]}"
    fi
fi
echo

# Check brew
BREW_INSTALLED=$(command -v brew &> /dev/null)

if ! $BREW_INSTALLED; then
    printf "brew not found. Install? [Y/n] "
    if read_confirm; then
        echo "Installing brew (https://brew.sh/)"
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

        # brew shellenv for Apple Silicon
        if [[ $(uname -p) == 'arm' ]]; then
            echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
        fi

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
current_git_user="$(git config user.name)"
current_git_email="$(git config user.email)"

printf "Git User Name (current: $current_git_user): "; read fullname
fullname=${fullname:-$current_git_user}
printf "Git Email (current: $current_git_email): "; read email
email=${email:-$current_git_email}
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
    git config --global add.interactive.useBuiltin false
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
echo

# NVM
printf "Install NVM? [Y/n] "
if read_confirm; then
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash

    printf "Install latest Node LTS? [Y/n] "
    if read_confirm; then
        nvm install --lts
    fi
    echo

    printf "Enable Corepack? (enables yarn and pnpm) [Y/n] "
    if read_confirm; then
        corepack enable
    fi
    echo
fi
