#!/bin/bash

DOTFILES_DIR="$HOME/dotfiles"
CONFIG_DIR="$HOME/.config"

echo "Starting Mac setup....."

if ! command -v brew &> /dev/null; then
    echo "Homebrew not found. Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    # Add Homebrew to PATH for Apple Silicon Macs
    if [ -d "/opt/homebrew/bin" ]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
else
    echo "Homebrew is already installed. Skipping installation."
fi

echo "Installing developer tools and packages..."
brew install git neovim tmux node fzf ripgrep

mkdir -p "$CONFIG_DIR"

create_symlink() {
    local source_file=$1
    local target_file=$2
    
    echo "Linking $source_file -> $target_file"
    ln -sfn "$source_file" "$target_file"
}

create_symlink "$DOTFILES_DIR/.tmux.conf" "$HOME/.tmux.conf"
create_symlink "$DOTFILES_DIR/nvim" "$CONFIG_DIR/nvim"
create_symlink "$DOTFILES_DIR/.zshrc" "$HOME/.zshrc"

if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
    echo "Installing Tmux Plugin Manager (TPM)..."
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
else
    echo "TPM is already installed."
fi

echo "Setup completed successfully."
echo "Please restart your terminal or run 'source ~/.zshrc'."
