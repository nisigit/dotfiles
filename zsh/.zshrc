# Portable zsh config. Machine-specific, work and secret settings go in
# ~/.zshrc.local, which is sourced at the end and never committed.

# Add a directory to PATH only if it exists, so this file works on any machine.
path_prepend() { [[ -d "$1" ]] && export PATH="$1:$PATH"; }
path_append() { [[ -d "$1" ]] && export PATH="$PATH:$1"; }

###############################################################################
# Oh My Zsh
###############################################################################
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="bira"
plugins=(git z)
[[ -f "$ZSH/oh-my-zsh.sh" ]] && source "$ZSH/oh-my-zsh.sh"

# Show the active Python venv on the right instead of in front of the prompt.
export VIRTUAL_ENV_DISABLE_PROMPT=1
virtualenv_info() { [[ -n "$VIRTUAL_ENV" ]] && echo "(${VIRTUAL_ENV:t})"; }
RPROMPT='$(virtualenv_info)'

###############################################################################
# fzf: Ctrl+R fuzzy history search, Ctrl+T file picker, Alt+C cd into a directory
###############################################################################
command -v fzf >/dev/null && source <(fzf --zsh)

###############################################################################
# Toolchains (each one is skipped if it is not installed)
###############################################################################
[[ -f "$HOME/.local/bin/env" ]] && . "$HOME/.local/bin/env"   # uv
path_append "$HOME/go/bin"

# Node comes from fnm, not Homebrew.
command -v fnm >/dev/null && eval "$(fnm env --use-on-cd --shell zsh)"

export BUN_INSTALL="$HOME/.bun"
path_prepend "$BUN_INSTALL/bin"
[[ -s "$BUN_INSTALL/_bun" ]] && source "$BUN_INSTALL/_bun"

export PNPM_HOME="$HOME/Library/pnpm"
[[ ":$PATH:" != *":$PNPM_HOME:"* ]] && path_prepend "$PNPM_HOME"

path_prepend /opt/homebrew/opt/postgresql@16/bin
[[ -d /opt/homebrew/opt/openjdk ]] && export JAVA_HOME=/opt/homebrew/opt/openjdk/libexec/openjdk.jdk/Contents/Home

###############################################################################
# Aliases
###############################################################################
alias rfmt="uv run ruff format && uv run ruff check --fix"

###############################################################################
# cmux: open a URL as a browser tab in the current pane, in front of the terminal.
# Define bookmark aliases with it, e.g. in ~/.zshrc.local:
#   alias prs='cmuxtab "https://github.com/pulls"'
###############################################################################
cmuxtab() {
  cmux new-surface --type browser --focus true --url "$1" \
    --pane "$(cmux identify | jq -r .caller.pane_ref)" >/dev/null
}
alias ghprs='cmuxtab "https://github.com/pulls"'

###############################################################################
# Local overrides: work setup, secrets, machine-specific paths
###############################################################################
[[ -f "$HOME/.zshrc.local" ]] && source "$HOME/.zshrc.local"
