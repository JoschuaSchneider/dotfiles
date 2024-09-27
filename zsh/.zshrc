export SPACESHIP_GIT_STATUS_COLOR="magenta"
export SPACESHIP_VI_MODE_COLOR=249
export SPACESHIP_VI_MODE_INSERT="I"
export SPACESHIP_VI_MODE_NORMAL="N"
export KEYTIMEOUT=1

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
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

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
source ~/.config/zsh/fzf-tab-completion/zsh/fzf-zsh-completion.sh
bindkey '^I' fzf_completion
zstyle ':completion:*:*:git:*' fzf-search-display true
