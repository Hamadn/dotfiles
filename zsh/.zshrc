# =============================================================================
#  .zshrc — Zsh configuration
# =============================================================================
# ---------------------------------------------------------------------------
#  1. EARLY STARTUP — compinit & instant prompt
# ---------------------------------------------------------------------------
autoload -Uz compinit
compinit

if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# ---------------------------------------------------------------------------
#  2. PATH
# ---------------------------------------------------------------------------
export PATH="$PATH:/usr/local/go/bin"
export PATH="$PATH:/home/linuxbrew/.linuxbrew/bin"
export PATH="$PATH:/home/hamad/.local/bin"
export PATH="$PATH:$HOME/go/bin"

export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

export PATH="/home/hamad/.opencode/bin:$PATH"

# ---------------------------------------------------------------------------
#  3. SHELL COMPLETIONS
# ---------------------------------------------------------------------------
if type brew &>/dev/null; then
  FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"
fi
source <(kubectl completion zsh)

[ -s "/home/hamad/.bun/_bun" ] && source "/home/hamad/.bun/_bun"

# ---------------------------------------------------------------------------
#  4. CORE ENVIRONMENT VARIABLES
# ---------------------------------------------------------------------------
export ZSH="$HOME/.oh-my-zsh"
export ZETTELKASTEN="$HOME/void-brain/"
export VISUAL=nvim
export EDITOR=nvim
export BROWSER="zen-browser"
export TERM="tmux-256color"

# ---------------------------------------------------------------------------
#  5. OH-MY-ZSH
# ---------------------------------------------------------------------------
ZSH_THEME="powerlevel10k/powerlevel10k"

plugins=(git web-search sudo command-not-found zsh-autosuggestions zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh

[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# ---------------------------------------------------------------------------
#  6. KEY BINDINGS
# ---------------------------------------------------------------------------
bindkey "^[[A" history-search-backward
bindkey "^[[B" history-search-forward

# ---------------------------------------------------------------------------
#  7. ALIASES
# ---------------------------------------------------------------------------
alias v="nvim"
alias cl="clear"
alias tmain="tmux new-session -A -s main"
alias config='/home/linuxbrew/.linuxbrew/bin/git --git-dir=/home/hamad/dotfiles --work-tree=/home/hamad'
alias mks="minikube start"
alias lg="lazygit"
alias cd="z"
alias zrc="v ~/.zshrc"
alias ls="eza --icons=always"
alias tree="eza --tree --icons=always --git-ignore"
alias tag="setfattr -n user.project -v 1"
alias untag="setfattr -x user.project"

# ---------------------------------------------------------------------------
#  8. ZOXIDE — smart cd
# ---------------------------------------------------------------------------
eval "$(zoxide init zsh)"

# ---------------------------------------------------------------------------
#  9. FZF — fuzzy finder
# ---------------------------------------------------------------------------
eval "$(fzf --zsh)"

fg="#CBE0F0"
bg="#011628"
bg_highlight="#143652"
purple="#B388FF"
blue="#06BCE4"
cyan="#2CF9ED"

export FZF_DEFAULT_OPTS="--color=fg:${fg},bg:${bg},hl:${purple},fg+:${fg},bg+:${bg_highlight},hl+:${purple},info:${blue},prompt:${cyan},pointer:${cyan},marker:${cyan},spinner:${cyan},header:${cyan}"

export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude .git"

_fzf_compgen_path() {
  fd --hidden --exclude .git . "$1"
}

_fzf_compgen_dir() {
  fd --type=d --hidden --exclude .git . "$1"
}

source ~/fzf-git.sh/fzf-git.sh

export FZF_CTRL_T_OPTS="--preview 'bat -n --color=always --line-range :500 {}'"
export FZF_ALT_C_OPTS="--preview 'eza --tree --color=always {} | head -200'"

_fzf_comprun() {
  local command=$1
  shift
  case "$command" in
    cd)           fzf --preview 'eza --tree --color=always {} | head -200' "$@" ;;
    export|unset) fzf --preview "eval 'echo \$'{}"         "$@" ;;
    ssh)          fzf --preview 'dig {}'                   "$@" ;;
    *)            fzf --preview "bat -n --color=always --line-range :500 {}" "$@" ;;
  esac
}

# ---------------------------------------------------------------------------
# 11. BAT — better cat
# ---------------------------------------------------------------------------
export GROFF_NO_SGR=1
export MANPAGER="sh -c 'col -bx | bat -l man -p'"
alias -s {md,txt,json,yaml,yml,toml}=nvim

# ---------------------------------------------------------------------------
# 12. YAZI — terminal file manager
# ---------------------------------------------------------------------------
function yy() {
  local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
  yazi "$@" --cwd-file="$tmp"
  if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
    builtin cd -- "$cwd"
  fi
  rm -f -- "$tmp"
}



