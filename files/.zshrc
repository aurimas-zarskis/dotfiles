# Better history setup
HISTFILE=$HOME/.cache/.zhistory
SAVEHIST=10000
HISTSIZE=10000
setopt share_history
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_DUPS
setopt HIST_SAVE_NO_DUPS
setopt hist_verify

# Set up fzf key bindings and fuzzy completion
source <(fzf --zsh)

# Configure fzf-tab autocompletion
autoload -U compinit; compinit
source ~/.config/zsh/plugins/fzf-tab/fzf-tab.plugin.zsh
zstyle ':completion:*' menu no

# Configure fzf-tab-completion
# source ~/.config/zsh/plugins/fzf-tab-completion/zsh/fzf-zsh-completion.sh

# Enable zsh-autosuggestions plugin
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# Enable zsh-syntax-highlighting plugin
source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# oh-my-posh setup
if [ "$TERM_PROGRAM" != "Apple_Terminal" ]; then
  eval "$(oh-my-posh init zsh --config ~/.config/ohmyposh/atomic.custom.omp.json)"
fi
