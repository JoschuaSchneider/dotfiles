if ! command -v "stow" &>/dev/null; then
    echo "Warning: stow not installed"
    exit 1
fi

# stow nvim config
stow -t $HOME nvim-new

# stow zsh/zimfw config
stow -t $HOME zsh
