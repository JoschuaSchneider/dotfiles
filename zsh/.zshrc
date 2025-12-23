# eval "$(starship init zsh)"

export PATH=/opt/homebrew/bin:~/Library/Python/3.9/bin:$PATH
export PATH=$PATH:`go env GOPATH`/bin
export SPACESHIP_GIT_STATUS_COLOR="magenta"
export SPACESHIP_VI_MODE_COLOR=249
export SPACESHIP_VI_MODE_INSERT="@insert"
export SPACESHIP_VI_MODE_NORMAL="@normal"
export KEYTIMEOUT=1
export SPACESHIP_KUBECTL_SHOW=true
export SPACESHIP_KUBECTL_VERSION_SHOW=false
export SPACESHIP_KUBECTL_SYMBOL="ctx/"
export SPACESHIP_GCLOUD_SHOW=false
export SPACESHIP_AZURE_SHOW=false
export SPACESHIP_BUN_SYMBOL="bun/"
export SPACESHIP_NODE_SYMBOL="node/"
export SPACESHIP_GOLANG_SYMBOL="go/"
export SPACESHIP_GIT_SYMBOL="git/"
export SPACESHIP_LUA_SYMBOL="lua/"
export SPACESHIP_RUST_SYMBOL="rust/"

# Remove older command from the history if a duplicate is to be added.
setopt HIST_IGNORE_ALL_DUPS

# Vi keymaps
bindkey -v

# Remove path separator from WORDCHARS.
WORDCHARS=${WORDCHARS//[\/]}

# Disable automatic widget re-binding on each precmd. This can be set when
# zsh-users/zsh-autosuggestions is the last module in your ~/.zimrc.
ZSH_AUTOSUGGEST_MANUAL_REBIND=1

# Set what highlighters will be used.
# See https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/docs/highlighters.md
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)

# ------------------
# Initialize modules
# ------------------

# Prevent zimfw completion module from calling compinit
# (it will be called by later completion scripts like dart-cli, tinygo, etc.)
zstyle ':zim:completion' disable-compinit yes

ZIM_HOME=${ZDOTDIR:-${HOME}}/.zim
# Download zimfw plugin manager if missing.
if [[ ! -e ${ZIM_HOME}/zimfw.zsh ]]; then
  if (( ${+commands[curl]} )); then
    curl -fsSL --create-dirs -o ${ZIM_HOME}/zimfw.zsh \
        https://github.com/zimfw/zimfw/releases/latest/download/zimfw.zsh
  else
    mkdir -p ${ZIM_HOME} && wget -nv -O ${ZIM_HOME}/zimfw.zsh \
        https://github.com/zimfw/zimfw/releases/latest/download/zimfw.zsh
  fi
fi
# Install missing modules, and update ${ZIM_HOME}/init.zsh if missing or outdated.
if [[ ! ${ZIM_HOME}/init.zsh -nt ${ZDOTDIR:-${HOME}}/.zimrc ]]; then
  source ${ZIM_HOME}/zimfw.zsh init -q
fi
# Initialize modules.
source ${ZIM_HOME}/init.zsh

# ------------------------------
# Post-init module configuration
# ------------------------------

#
# zsh-history-substring-search
#

zmodload -F zsh/terminfo +p:terminfo
# Bind ^[[A/^[[B manually so up/down works both before and after zle-line-init
for key ('^[[A' '^P' ${terminfo[kcuu1]}) bindkey ${key} history-substring-search-up
for key ('^[[B' '^N' ${terminfo[kcud1]}) bindkey ${key} history-substring-search-down
for key ('k') bindkey -M vicmd ${key} history-substring-search-up
for key ('j') bindkey -M vicmd ${key} history-substring-search-down
unset key
# }}} End configuration added by Zim install

# Spaceship customization
spaceship add --before time vi_mode
spaceship_vi_mode_enable

# ------------------------------
# Custom configuration
# ------------------------------
# TODO: Modularize

export LC_CTYPE=de_DE.UTF-8
export LANG="en_US.UTF-8"
export HOMEBREW_NO_AUTO_UPDATE=1
export JAVA_HOME="/opt/homebrew/Cellar/openjdk/21.0.3"

# fnm
eval "$(fnm env --use-on-cd)"

# pnpm
export PNPM_HOME="/Users/joschua/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

# enable fzf fuzzy-finder
# TODO: Broken, fix
# [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# enable zoxide
eval "$(zoxide init zsh --cmd cd)"

# alias vi="nvim"
alias n="nvim"
alias nvimc="nvim -c\"cd ~/.config/nvim\""
alias nvault="nvim -c\"cd ~/.obsidian/nvault\""
alias qrpaste='zbarimg -q --raw <(pngpaste -)'
alias patchgen="PATCHNAME=\"$(uuidgen | tr A-f a-f).patch\" && git diff > ~/patches/\$PATCHNAME && open -R ~/patches/\$PATCHNAME"

export ANDROID_HOME=~/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/tools/bin:$ANDROID_HOME/platform-tools
 
# export PATH=~/.local/bin:/usr/local/bin/omnisharp:$PATH

# fzf tab completion
# TODO: Broken, fix
# source ~/.config/zsh/fzf-tab-completion/zsh/fzf-zsh-completion.sh
# bindkey '^I' fzf_completion
zstyle ':completion:*:*:git:*' fzf-search-display true

# bun completions
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

## [Completion]
## Completion scripts setup. Remove the following line to uninstall
[[ -f "$HOME/.dart-cli-completion/zsh-config.zsh" ]] && . "$HOME/.dart-cli-completion/zsh-config.zsh" || true
## [/Completion]
export GEM_HOME=$(ruby -e 'puts Gem.user_dir')
export PATH="$HOME/.gem/ruby/3.4.0/bin:$PATH"


eval "$(tinygo-edit --completion-script-zsh)"

eval "$(direnv hook zsh)"

export PATH="/opt/homebrew/opt/mysql@8.0/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"



# The next line updates PATH for the Google Cloud SDK.
if [ -f "$HOME/Downloads/google-cloud-sdk/path.zsh.inc" ]; then . "$HOME/Downloads/google-cloud-sdk/path.zsh.inc"; fi

# The next line enables shell command completion for gcloud.
if [ -f "$HOME/Downloads/google-cloud-sdk/completion.zsh.inc" ]; then . "$HOME/Downloads/google-cloud-sdk/completion.zsh.inc"; fi

# Ensure compinit is called (in case no completion script called it)
autoload -Uz compinit && compinit -C

. "$HOME/.local/bin/env"


# Shopify Hydrogen alias to local projects
alias h2='$(npm prefix -s)/node_modules/.bin/shopify hydrogen'
