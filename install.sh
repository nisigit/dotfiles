#!/usr/bin/env bash
# Symlink these dotfiles into $HOME and clone the Neovim config.
# Safe to re-run. An existing file that is not already our symlink is moved to <file>.bak.
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

link() {
  local src="$DOTFILES/$1" dest="$2"
  if [[ -L "$dest" && "$(readlink "$dest")" == "$src" ]]; then
    echo "ok       $dest"
    return
  fi
  if [[ -e "$dest" || -L "$dest" ]]; then
    mv "$dest" "$dest.bak"
    echo "backup   $dest -> $dest.bak"
  fi
  mkdir -p "$(dirname "$dest")"
  ln -s "$src" "$dest"
  echo "linked   $dest -> $src"
}

link zsh/.zshrc "$HOME/.zshrc"
link zsh/.zprofile "$HOME/.zprofile"

# Local overrides start empty; they are where work setup and secrets live.
for f in .zshrc.local .zprofile.local; do
  [[ -e "$HOME/$f" ]] || { touch "$HOME/$f"; echo "created  $HOME/$f"; }
done

# Neovim lives in its own repo.
if [[ -d "$HOME/.config/nvim/.git" ]]; then
  echo "ok       $HOME/.config/nvim"
else
  [[ -e "$HOME/.config/nvim" ]] && mv "$HOME/.config/nvim" "$HOME/.config/nvim.bak" && echo "backup   ~/.config/nvim -> ~/.config/nvim.bak"
  git clone https://github.com/nisigit/nvim-config.git "$HOME/.config/nvim"
fi

# Oh My Zsh, if missing. KEEP_ZSHRC stops its installer replacing our .zshrc.
if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
  KEEP_ZSHRC=yes RUNZSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

echo
echo "Done. Install the tools from the README if you have not, then open a new shell."
