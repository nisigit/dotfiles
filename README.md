# dotfiles

My shell setup for macOS: zsh with Oh My Zsh, fzf history search, and a few
[cmux](https://cmux.dev) helpers. The Neovim config lives in its own repo,
[nvim-config](https://github.com/nisigit/nvim-config), and `install.sh` clones it.

## Install

```sh
brew install fzf jq fnm neovim ripgrep fd
git clone https://github.com/nisigit/dotfiles.git ~/dotfiles
~/dotfiles/install.sh
```

`install.sh` symlinks `~/.zshrc` and `~/.zprofile` into this repo, clones the
Neovim config into `~/.config/nvim`, and installs Oh My Zsh if it is missing.
It moves any file it would replace to `<file>.bak`, and it is safe to re-run.

## What's in it

| Key / command | What it does |
| --- | --- |
| `Ctrl+R` | fuzzy search shell history (fzf) |
| `Ctrl+T` | fuzzy pick a file and paste its path |
| `Alt+C` | fuzzy `cd` into a subdirectory |
| `z <name>` | jump to a frequently used directory |
| `cmuxtab <url>` | open a URL as a browser tab in the current cmux pane |
| `ghprs` | your open GitHub pull requests in a cmux tab |
| `rfmt` | `ruff format` and `ruff check --fix` via uv |

The prompt is the Oh My Zsh `bira` theme, with the active Python venv on the right.
Toolchains (uv, Go, fnm, bun, pnpm, Postgres, OpenJDK) are only added to `PATH`
when they are installed.

## Local, uncommitted config

`~/.zshrc` sources `~/.zshrc.local` last, and `~/.zprofile` sources
`~/.zprofile.local`. Put anything machine-specific, work-related or secret in
those files, for example tokens or bookmarks:

```sh
alias prs='cmuxtab "https://github.com/my-org/my-repo/pulls/me"'
export SOME_API_TOKEN=...
```

They are not in this repo, and `.gitignore` blocks `*.local` in case one is copied in.
