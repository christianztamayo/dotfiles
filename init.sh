#!/bin/zsh

function read_confirm() {
    printf "${1:-"Continue?"} [Y/n] "
    read -sk1 confirm
    echo
    [[ $confirm == "y" || $confirm == $'\n' ]] && true || false
}

# ---------------------------- Start ----------------------------

# Install Xcode command line tools
if [[ ! $(
    xcode-select -p 1>/dev/null
    echo $?
) ]]; then
    xcode-select --install
    echo
fi

# Install oh-my-zsh
OMZ_INSTALLED=$(test -d ~/.oh-my-zsh)
if ! $OMZ_INSTALLED; then
    if read_confirm "Install oh-my-zsh (https://github.com/ohmyzsh/ohmyzsh)?"; then
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
    source $ZSH/oh-my-zsh.sh
    echo "Enabling the following oh-my-zsh plugins:"
    printf "  %s\n" "${omz_plugins[@]}"
    if read_confirm; then
        autosuggestions_path=${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
        if [[ ! -d $autosuggestions_path ]]; then
            echo "Installing zsh-autosuggestions..."
            git clone https://github.com/zsh-users/zsh-autosuggestions $autosuggestions_path
        fi
        omz plugin enable "${omz_plugins[@]}"

        # Agnoster theme
        omz theme set agnoster
        OMZ_AGNOSTER_THEME_SET=1
        if ! grep -q "prompt_context(){}" ~/.zshrc; then
            echo "
# Remove user@hostname from prompt with agnoster theme
prompt_context(){}" >>~/.zshrc

            echo "Added custom aliases to ~/.zshrc"
        fi
    fi
fi
echo

# Check brew
BREW_INSTALLED=$(command -v brew &>/dev/null)

if ! $BREW_INSTALLED; then
    if read_confirm "brew not found. Install?"; then
        echo "Installing brew (https://brew.sh/)"
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

        # brew shellenv for Apple Silicon
        if [[ $(uname -p) == "arm" ]]; then
            echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >>~/.zprofile
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
    if read_confirm; then
        eval "brew install ${brew_packages[@]}"
    fi
fi
echo

# Get basic info
current_git_user="$(git config user.name)"
current_git_email="$(git config user.email)"

printf "Git User Name (current: $current_git_user): "
read fullname
fullname=${fullname:-$current_git_user}
printf "Git Email (current: $current_git_email): "
read email
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

if read_confirm; then
    eval "$COMMAND"
fi
echo

# NVM
if read_confirm "Install NVM?"; then
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash

    if read_confirm "Install latest Node LTS?"; then
        nvm install --lts
    fi
    echo

    if read_confirm "Enable Corepack? (enables yarn and pnpm)"; then
        corepack enable
    fi
    echo
fi

# Aliases
if ! grep -q "dotfiles/zshrc" ~/.zshrc; then
    echo "
source \"$(pwd)/zshrc\"" >>~/.zshrc

    echo "Added custom aliases to ~/.zshrc"
fi

echo "Done! 🎉"

if [[ -n $OMZ_AGNOSTER_THEME_SET ]]; then
    echo "Don't forget to install the pre-patched fonts on your system to properly render the omz theme"
fi
