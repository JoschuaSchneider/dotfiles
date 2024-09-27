if ! command -v "stow" &>/dev/null; then
    echo "Warning: stow not installed"
    exit 1
fi

# stow nvim config
stow nvim
