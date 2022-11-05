export HISTSIZE=1000000
export SAVEHIST=1000000

# Brew
HOMEBREW_PREFIX="/usr/local"
# On ARM macOS, this script installs to /opt/homebrew only
if [[ "$(uname -m)" == "arm64" ]]; then
    HOMEBREW_PREFIX="/opt/homebrew"
fi
eval "$(${HOMEBREW_PREFIX}/bin/brew shellenv)"

# Pyenv
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --path)"

# NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
