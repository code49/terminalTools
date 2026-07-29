# dup — Terminal State Duplicator

Duplicates the state of your current shell (working directory, Nix environment, Python virtualenv, and Conda environment) into a new pane/tab/window.

## How it works

1. Reads the current working directory (`cwd`) of the target shell PID.
2. Traverses the parent process tree of the shell to detect active `nix-shell` or `nix develop/shell` environments, capturing their original startup command-line arguments.
3. Examines the environment variables (`/proc/<pid>/environ`) of the target shell to identify active Python virtual environments (`VIRTUAL_ENV`) and Conda environments (`CONDA_PREFIX`).
4. If inside a `tmux` session, it splits the window or creates a new window in the same directory, running the reconstructed environment activation commands.
5. If outside `tmux`, it detects the active graphical terminal emulator (e.g. Kitty, Alacritty, GNOME Terminal) and spawns a new window running the reconstructed environment activation commands.

## Usage

```
dup <shell_pid>                 Duplicate terminal (horizontal split in tmux, new window otherwise)
dup <shell_pid> -v | --vertical  Split vertically (tmux only)
dup <shell_pid> -t | --tab       New window/tab (tmux or terminal emulator)
dup <shell_pid> -w | --window    Force launch a new graphical terminal window (bypasses tmux)
dup <shell_pid> -n | --dry-run   Print the command that would be executed (no split/window created)
dup -h | --help                  Show this help
```

## Setup Aliases

Source the main `aliases.sh` in your `.bashrc` or `.zshrc` to get the short aliases that automatically pass the current shell PID (`$$`):

```bash
alias dup='dup $$'
alias dupv='dup $$ -v'
alias dupt='dup $$ -t'
alias dupw='dup $$ -w'
```

## Dependencies

- **Python 3** (used to parse the `/proc` directory robustly)
- Linux environment (relies on `/proc` filesystem)
- Supported terminal emulators: Kitty, Alacritty, WezTerm, GNOME Terminal, Konsole, XFCE Terminal, Foot, xterm.
