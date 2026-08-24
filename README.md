# terminalTools

**A collection of portable terminal tools and smart shell scripts.**

System-agnostic utilities that work on any Linux or macOS installation. No dependency on Nix, Homebrew, or any specific distribution — just standard shell scripting with optional enhancements.

---

## Tools

| Tool | Description | Dependencies |
|------|-------------|--------------|
| `lss` | Smart LS with split view, tree mode, git status, and repo launcher | bash, (optional: python3, tree, git, firefox) |
| `ff` | Firefox shortcut launcher with fzf interactive selector | bash, firefox, (optional: fzf) |
| `gitac` | Quick git add-all and commit | bash, git |
| `dup` | Duplicate terminal state (cwd, nix-shell, venv, conda) | python3, (optional: tmux, kitty/alacritty) |

## Installation

Clone the repo and run the install script:

```bash
git clone https://github.com/youruser/terminalTools.git
cd terminalTools
./install.sh
```

This creates symlinks in `~/.local/bin` (or wherever `INSTALL_DIR` points), so updates to the repo are immediately available — no reinstall needed.

To customize the install location:

```bash
INSTALL_DIR=~/bin ./install.sh
```

To uninstall:

```bash
./install.sh --uninstall
```

### Optional Aliases

Source the aliases file in your `.bashrc` or `.zshrc` for convenient shortcuts:

```bash
source /path/to/terminalTools/aliases.sh
```

## Quick Usage

### lss — Smart LS

```bash
lss              # smart directory listing with split view
lss -t           # tree mode
lss -g           # include git status
lss -gh          # open git repository in Firefox (profile dchan-personal)
lss -t -g        # tree mode with git status
```

### ff — Firefox Launcher

```bash
ff               # interactive fzf selector for bookmarks/shortcuts
ff github        # launch a named shortcut directly
```

### gitac — Git Add & Commit

```bash
gitac "fix typo in README"    # stages all changes and commits
```

### dup — Terminal State Duplicator

```bash
dup              # duplicate current terminal state (splits in tmux, opens new window otherwise)
dupv             # split vertically (tmux only)
dupt             # new window/tab (tmux or terminal emulator)
dupw             # force launch new graphical terminal window (bypasses tmux)
```

## License

[MIT](LICENSE) © 2025 David Chan
