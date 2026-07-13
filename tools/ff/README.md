# ff — Firefox Shortcut Launcher

Open Firefox windows and tabs using short mnemonic shortcuts, powered by a
simple config file.

## Usage

```bash
ff <shortcut>      # Launch a site/profile directly
ff                 # Open an interactive fuzzy selector (requires fzf)
ff -h | --help     # Show all available shortcuts
ff -e | --edit     # Open the config file in $EDITOR
```

### Examples

```bash
ff gmail           # Open personal Gmail in the dchan-personal profile
ff c               # Open CMU Canvas in the dchan2-cmu profile
ff mails           # Open all three email inboxes at once
ff pri             # Launch a private browsing window
ff                 # Browse shortcuts interactively with fzf
```

## Configuration (`ff.conf`)

Shortcuts are defined in a plain-text config file. Each non-comment,
non-blank line follows this pipe-delimited format:

```
shortcut | category | label | profile | url
```

| Field      | Description                                              |
|------------|----------------------------------------------------------|
| `shortcut` | Short mnemonic key you type after `ff`                   |
| `category` | Grouping label shown in help/fzf (e.g. CMU, Personal)    |
| `label`    | Human-readable description                                |
| `profile`  | Firefox profile name (passed to `firefox -p`)             |
| `url`      | URL or local file path to open                            |

### Multi-URL shortcuts

To open several URLs at once (e.g. all email inboxes), set the profile
field to the literal string `MULTI` and list alternating `profile url`
pairs in the url field:

```
mails | General | All Emails | MULTI | profile1 url1 profile2 url2
```

### Comments and blank lines

Lines starting with `#` and blank lines are ignored.

## Config file search order

The script looks for `ff.conf` in the following locations (first match wins):

1. **`$FF_CONF`** — explicit path override via environment variable
2. **`$XDG_CONFIG_HOME/ff/ff.conf`** (defaults to `~/.config/ff/ff.conf`)
3. **Same directory as the `ff` script itself** — useful when running from
   the repository checkout

## Built-in shortcuts

These shortcuts are handled directly by the script and do **not** come from
the config file:

| Shortcut | Description                        |
|----------|------------------------------------|
| `pri`    | Open a private browsing window     |

## Dependencies

| Dependency    | Required | Purpose                                    |
|---------------|----------|--------------------------------------------|
| `bash`        | Yes      | Shell interpreter (uses `#!/usr/bin/env bash`) |
| `firefox`     | Yes      | Must be in `$PATH`                         |
| `fzf`         | No       | Interactive selector when no argument given |
| `ping`        | No       | Internet connectivity check (graceful skip) |
| `notify-send` | No       | Desktop notification on connection failure  |

## Installation

1. Symlink or copy `ff` somewhere in your `$PATH`.
2. Optionally copy `ff.conf` to `~/.config/ff/ff.conf` and customise.

```bash
# Example: symlink into ~/.local/bin
ln -sf "$(pwd)/ff" ~/.local/bin/ff
mkdir -p ~/.config/ff
cp ff.conf ~/.config/ff/ff.conf
```
