#!/usr/bin/env bash
#
# install.sh — Install (or uninstall) terminalTools by symlinking into your PATH.
#
# Usage:
#   ./install.sh              Install all tools
#   ./install.sh --uninstall  Remove installed symlinks
#   ./install.sh --help       Show this help
#
# Environment:
#   INSTALL_DIR   Where to place symlinks (default: ~/.local/bin)
#

set -euo pipefail

# ── Colors ───────────────────────────────────────────────────────────────────

if [ -t 1 ]; then
    RED='\033[0;31m'
    GREEN='\033[0;32m'
    YELLOW='\033[0;33m'
    BLUE='\033[0;34m'
    BOLD='\033[1m'
    RESET='\033[0m'
else
    RED='' GREEN='' YELLOW='' BLUE='' BOLD='' RESET=''
fi

info()  { printf "${BLUE}::${RESET} %s\n" "$*"; }
ok()    { printf "${GREEN}✓${RESET}  %s\n" "$*"; }
warn()  { printf "${YELLOW}!${RESET}  %s\n" "$*"; }
err()   { printf "${RED}✗${RESET}  %s\n" "$*" >&2; }

# ── Configuration ────────────────────────────────────────────────────────────

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
INSTALL_DIR="${INSTALL_DIR:-$HOME/.local/bin}"

# ── Help ─────────────────────────────────────────────────────────────────────

show_help() {
    cat <<EOF
${BOLD}terminalTools installer${RESET}

Usage:
  ./install.sh              Install all tools (symlink into PATH)
  ./install.sh --uninstall  Remove installed symlinks
  ./install.sh --help       Show this help

Environment variables:
  INSTALL_DIR   Target directory for symlinks (default: ~/.local/bin)

Available tools:
EOF
    discover_tools
    exit 0
}

# ── Tool Discovery ───────────────────────────────────────────────────────────

# Finds all executable tool scripts under tools/*/
# Prints each tool name and its path.
discover_tools() {
    local found=0
    for tool_dir in "$SCRIPT_DIR"/tools/*/; do
        [ -d "$tool_dir" ] || continue
        local tool_name
        tool_name="$(basename "$tool_dir")"
        # Look for the main executable (same name as the directory)
        local tool_bin="$tool_dir/$tool_name"
        if [ -f "$tool_bin" ] && [ -x "$tool_bin" ]; then
            printf "  %-12s %s\n" "$tool_name" "$tool_bin"
            found=$((found + 1))
        fi
    done
    if [ "$found" -eq 0 ]; then
        warn "No tools found in $SCRIPT_DIR/tools/*/"
    fi
}

# Returns a newline-separated list of "name\tpath" for each tool.
get_tools() {
    for tool_dir in "$SCRIPT_DIR"/tools/*/; do
        [ -d "$tool_dir" ] || continue
        local tool_name
        tool_name="$(basename "$tool_dir")"
        local tool_bin="$tool_dir/$tool_name"
        if [ -f "$tool_bin" ] && [ -x "$tool_bin" ]; then
            printf '%s\t%s\n' "$tool_name" "$tool_bin"
        fi
    done
}

# ── Install ──────────────────────────────────────────────────────────────────

do_install() {
    info "Installing terminalTools into ${INSTALL_DIR}"

    # Create install directory if needed
    if [ ! -d "$INSTALL_DIR" ]; then
        mkdir -p "$INSTALL_DIR"
        ok "Created ${INSTALL_DIR}"
    fi

    local count=0
    while IFS=$'\t' read -r name path; do
        local link="$INSTALL_DIR/$name"
        if [ -L "$link" ]; then
            # Symlink already exists — update it
            ln -sf "$path" "$link"
            ok "Updated symlink: $name -> $path"
        elif [ -e "$link" ]; then
            warn "Skipping $name: $link already exists and is not a symlink"
            continue
        else
            ln -s "$path" "$link"
            ok "Linked: $name -> $path"
        fi
        count=$((count + 1))
    done < <(get_tools)

    if [ "$count" -eq 0 ]; then
        err "No tools were installed. Make sure tools/*/ directories exist."
        exit 1
    fi

    echo ""
    info "$count tool(s) installed."

    # Check if INSTALL_DIR is in PATH
    check_path
}

# ── Uninstall ────────────────────────────────────────────────────────────────

do_uninstall() {
    info "Uninstalling terminalTools from ${INSTALL_DIR}"

    local count=0
    while IFS=$'\t' read -r name path; do
        local link="$INSTALL_DIR/$name"
        if [ -L "$link" ]; then
            rm "$link"
            ok "Removed symlink: $link"
            count=$((count + 1))
        elif [ -e "$link" ]; then
            warn "Skipping $name: $link exists but is not a symlink (not ours?)"
        fi
    done < <(get_tools)

    if [ "$count" -eq 0 ]; then
        warn "No symlinks were found to remove."
    else
        echo ""
        info "$count tool(s) uninstalled."
    fi
}

# ── PATH Check ───────────────────────────────────────────────────────────────

check_path() {
    case ":$PATH:" in
        *":$INSTALL_DIR:"*)
            ok "$INSTALL_DIR is in your PATH"
            ;;
        *)
            echo ""
            warn "$INSTALL_DIR is NOT in your PATH."
            warn "Add this to your shell config (.bashrc, .zshrc, etc.):"
            echo ""
            printf '    export PATH="%s:$PATH"\n' "$INSTALL_DIR"
            echo ""
            ;;
    esac
}

# ── Main ─────────────────────────────────────────────────────────────────────

case "${1:-}" in
    --help|-h)
        show_help
        ;;
    --uninstall)
        do_uninstall
        ;;
    "")
        do_install
        ;;
    *)
        err "Unknown option: $1"
        echo "Run './install.sh --help' for usage."
        exit 1
        ;;
esac
