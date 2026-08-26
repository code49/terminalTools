# lss — Smart LS

An improved `ls` wrapper that groups directory contents by type (directories, files, symlinks — and their hidden counterparts) and displays them in a columnar side-by-side layout. Always shows hidden files.

## Features

- **Split view** (default): Groups entries into labeled sections (directories, hidden directories, files, hidden files, symlinks, hidden symlinks) and renders them side-by-side in columns that fit the terminal width.
- **Flat view**: A standard `ls -A` with `--group-directories-first`, for when you just want a quick listing.
- **Tree view**: Wraps the `tree` command with sensible defaults (`-a`, `--dirsfirst`, color, classify) and adds the absolute path on the first line for relative targets.
- **Git status**: Optionally appends `git status` output at the bottom when inside a git repository.
- **GitHub repo**: Optionally opens the project repository in Firefox (profile `dchan-personal`) if inside a git repository.
- **Symlink targets**: In split view, symlinks are displayed with `->` arrows pointing to their targets, both colorized.
- **Pass-through flags**: Flags like `-l`, `-h`, `-S`, etc. are forwarded to the underlying `ls` or `tree` commands.

## Usage

```
lss [options] [directory]
```

### Options

| Flag | Description |
|---|---|
| `-s`, `--split` | Split view — grouped columns (default) |
| `-f`, `--flat`, `--no-split` | Flat view — standard `ls -A` output |
| `-t`, `-T`, `--tree` | Tree view (default depth: 3). Optionally specify depth: `-t 2` |
| `-g`, `--git` | Append `git status` output if inside a git repo |
| `-gh`, `--github` | Open project repository in Firefox (profile `dchan-personal`) if inside a git repo |
| `-h`, `--help` | Show built-in help |

Any other flags (e.g., `-l`, `-S`) are passed through to `ls` or `tree`.

### Examples

```bash
# Default split view of current directory
lss

# Split view of a specific directory
lss ~/projects

# Flat listing (like ls -A)
lss -f

# Long listing in split view
lss -lh

# Tree view with depth 2
lss -t 2

# Tree view with long listing
lss -t -lh

# Any mode with git status appended
lss -g
lss -t -g
lss -f -g

# Open project repository in Firefox (profile dchan-personal)
lss -gh
```

## How Split View Works

1. Entries are discovered with `find` and grouped into six categories:
   - directories, hidden directories, files, hidden files, symlinks, hidden symlinks
   Within file listings (`files` and `hidden files`), `.zip` files appear before all other files.
2. Each non-empty category is rendered as a labeled section.
3. If `python3` is available and neither `-l` nor `-1` is active, sections are laid out side-by-side in columns that fit the terminal width (with a 4-space gap).
4. Otherwise, sections are stacked vertically with standard `ls` column formatting.

## Dependencies

| Dependency | Required? | Purpose |
|---|---|---|
| `bash` | **Yes** | Shell interpreter |
| `find`, `sort`, `xargs` | **Yes** | Entry discovery and sorting |
| `ls` | **Yes** | Formatting and colorizing output |
| `tput` | **Yes** | Terminal width detection (falls back to 80 columns) |
| `readlink` | **Yes** | Resolving symlink targets |
| `python3` | Optional | Side-by-side column layout in split view |
| `tree` | Optional | Required only for tree mode (`-t`) |
| `git` | Optional | Required only for `--git` or `--github` flags |
| `firefox` | Optional | Required only for `--github` flag |

## Installation

Ensure `lss` is on your `PATH`:

```bash
# Example: symlink into a directory on your PATH
ln -s /path/to/terminalTools/tools/lss/lss ~/.local/bin/lss
```
