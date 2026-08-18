#!/usr/bin/env bash
# statusline-theme.sh — colors + icons for the Claude Code statusline (starship style).
# Sourced by statusline-command.sh from the same directory as the real script.
#
# COLORS are ANSI 256 palette indices. Indices 0-15 map to your TERMINAL THEME's
# 16 ANSI colors, so the statusline recolors automatically when you switch
# terminal themes — no edits here.
#     0 black    1 red      2 green    3 yellow
#     4 blue     5 magenta  6 cyan     7 white     8-15 bright variants
# To PIN a fixed palette (e.g. Catppuccin), set these to 16-255 cube indices —
# see the commented block at the bottom.
#
# ICONS are plain emoji — no special font needed, render everywhere.

TH_SEP="|"         # separator between modules (rendered dim with a space each side)
TH_DIM=8           # dim color for the separator + empty bar cells

# ---- model name accent (fg) by tier ----
TH_MODEL_OPUS=13        # bright magenta
TH_MODEL_SONNET=12      # bright blue
TH_MODEL_HAIKU=10       # bright green
TH_MODEL_FABLE=13       # bright magenta / pink
TH_MODEL_DEFAULT=7

# ---- per-module foreground colors ----
TH_DIR_FG=4            # launch folder (blue)
TH_CTX_FG=7            # context % (bar uses the gradient)
TH_RATE_LABEL=6        # "5h" / "7d" labels (percentages use the gradient)
TH_RESET_FG=3          # reset (yellow)
TH_STACK_UP=2          # stack running (green)
TH_STACK_DOWN=8        # stack down (dim)
TH_WARN_FG=1           # preview-swap warning (red)
TH_COST_FG=8           # session cost (dim)

# ---- context bar gradient (TRUECOLOR; semantic green→red, not theme-bound) ----
TH_GRAD0="152 187 108"   # green   (low usage)
TH_GRAD1="230 195 132"   # amber
TH_GRAD2="255 160 102"   # orange
TH_GRAD3="232 36 36"     # red     (near full)

# ---- icons (emoji). Leave G_CTX empty for no context icon (just the bar). ----
G_MODEL="🤖"
G_DIR="📁"
G_CTX=""
G_STACK_UP="▶"
G_STACK_DOWN="■"
G_RESET="⏳"
G_COST=""
G_WARN="⚠️"
G_FAST="⚡"

# ---------------------------------------------------------------------------
# PINNED PALETTE EXAMPLE — Catppuccin Mocha (uncomment to lock these colors,
# no longer following the terminal theme). 256-cube approximations.
# TH_DIM=239
# TH_MODEL_OPUS=183; TH_MODEL_SONNET=111; TH_MODEL_HAIKU=151; TH_MODEL_FABLE=218; TH_MODEL_DEFAULT=253
# TH_CTX_FG=253; TH_RATE_LABEL=117; TH_RESET_FG=223; TH_STACK_UP=151; TH_STACK_DOWN=244; TH_WARN_FG=210; TH_COST_FG=244
# ---------------------------------------------------------------------------
