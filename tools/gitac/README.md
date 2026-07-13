# gitac — Git Add-Commit

Stage all changes and commit in one command.

## Origin

Ported from a shell alias in [`~/.dotfiles/home/home.nix`](../../) (line 144):

```bash
gitac = "git status; echo 'adding all changes + committing them for:' ; pwd;  git add -A; git commit -m";
```

This version expands the one-liner into a proper tool with help text, a `--push` flag, a `--dry-run` mode, colored output, and error handling.

## Usage

```
gitac <message>                 Stage all changes and commit
gitac -p|--push <message>       Stage, commit, and push
gitac -n|--dry-run <message>    Show what would be committed (no changes made)
gitac -h|--help                 Show this help
```

## Examples

```bash
# Basic usage — stage everything and commit
gitac "fix typo in README"

# Commit and push in one shot
gitac --push "release v1.2.0"

# Preview what would be committed without making changes
gitac --dry-run "check before committing"
```

## What it does

1. Verifies you are inside a git repository.
2. Displays the current working directory and commit message.
3. Shows `git status --short` so you can see what changed.
4. Stages all changes (`git add -A`).
5. Shows `git diff --cached --stat` summarizing what will be committed.
6. Commits with your message (`git commit -m "<message>"`).
7. Optionally pushes to the remote (`--push`).

In `--dry-run` mode, steps 6–7 are skipped and staged changes are reset.

## Dependencies

| Dependency | Purpose          |
|------------|------------------|
| `bash`     | Shell runtime    |
| `git`      | Version control  |

Both are expected to be available on any standard development machine.
