#!/usr/bin/env bash

input=$(cat)

# The effort level is only surfaced when it deviates from this baseline.
STANDARD_EFFORT="high"

# --- load the theme (colors + glyphs) from next to the *real* script, so it
#     works whether or not the dotfiles have been re-stowed into ~/.claude ---
_real="$(readlink -f "${BASH_SOURCE[0]}" 2>/dev/null || echo "${BASH_SOURCE[0]}")"
_dir="$(dirname "$_real")"
if [ -f "$_dir/statusline-theme.sh" ]; then
  source "$_dir/statusline-theme.sh"
elif [ -f "$HOME/.claude/statusline-theme.sh" ]; then
  source "$HOME/.claude/statusline-theme.sh"
fi

# Fallbacks so the script still runs if the theme file is missing.
: "${TH_SEP:=|}" "${TH_DIM:=8}"
: "${TH_MODEL_OPUS:=13}" "${TH_MODEL_SONNET:=12}" "${TH_MODEL_HAIKU:=10}" "${TH_MODEL_FABLE:=13}" "${TH_MODEL_DEFAULT:=7}"
: "${TH_DIR_FG:=4}" "${TH_CTX_FG:=7}" "${TH_RATE_LABEL:=6}" "${TH_RESET_FG:=3}" "${TH_COST_FG:=8}"
: "${TH_GRAD0:=152 187 108}" "${TH_GRAD1:=230 195 132}" "${TH_GRAD2:=255 160 102}" "${TH_GRAD3:=232 36 36}"
# NOTE: `=` (not `:=`) so an intentional empty icon in the theme file is respected;
# defaults apply only when the theme file is absent (var truly unset).
: "${G_MODEL=🤖}" "${G_DIR=📁}" "${G_CTX=}" "${G_RESET=⏳}" "${G_COST=}" "${G_FAST=⚡}"

esc=$'\033'
reset="${esc}[0m"

# --- parse the statusline JSON (single jq call; \x1f-joined so empty fields
#     are preserved — a whitespace IFS like tab collapses consecutive delimiters) ---
IFS=$'\037' read -r model model_id effort fast used_pct five_h five_h_reset seven_d cost root <<< "$(
  printf '%s' "$input" | jq -r '[
    (.model.display_name // "Claude"),
    (.model.id // ""),
    (.effort.level // ""),
    (.fast_mode // false),
    ((.context_window.used_percentage // 0) | floor),
    (.rate_limits.five_hour.used_percentage // ""),
    (.rate_limits.five_hour.resets_at // ""),
    (.rate_limits.seven_day.used_percentage // ""),
    (.cost.total_cost_usd // ""),
    (.workspace.project_dir // "")
  ] | map(tostring) | join("")'
)"

[ -z "$used_pct" ] && used_pct=0
used_pct=${used_pct%.*}
[ -z "$used_pct" ] && used_pct=0

read -r gr0 gg0 gb0 <<< "$TH_GRAD0"
read -r gr1 gg1 gb1 <<< "$TH_GRAD1"
read -r gr2 gg2 gb2 <<< "$TH_GRAD2"
read -r gr3 gg3 gb3 <<< "$TH_GRAD3"

gradient_rgb() {
  local p=$1 r g b t span
  [ -z "$p" ] && p=0
  [ "$p" -lt 0 ] && p=0
  [ "$p" -gt 100 ] && p=100
  if [ "$p" -le 33 ]; then
    t=$p; span=33
    r=$(( gr0 + (gr1 - gr0) * t / span )); g=$(( gg0 + (gg1 - gg0) * t / span )); b=$(( gb0 + (gb1 - gb0) * t / span ))
  elif [ "$p" -le 66 ]; then
    t=$((p - 33)); span=33
    r=$(( gr1 + (gr2 - gr1) * t / span )); g=$(( gg1 + (gg2 - gg1) * t / span )); b=$(( gb1 + (gb2 - gb1) * t / span ))
  else
    t=$((p - 66)); span=34
    [ "$t" -gt 34 ] && t=34
    r=$(( gr2 + (gr3 - gr2) * t / span )); g=$(( gg2 + (gg3 - gg2) * t / span )); b=$(( gb2 + (gb3 - gb2) * t / span ))
  fi
  printf '%d;%d;%d' "$r" "$g" "$b"
}
fg()  { printf '%s' "${esc}[38;5;$1m"; }   # ANSI palette fg (theme-following)
fgt() { printf '%s' "${esc}[38;2;$1m"; }   # truecolor fg

# --- ordered segment registry: plugins in $HOME/.claude/statusline.d/*.sh
#     register alongside the core modules below, then everything is emitted
#     sorted by order (core reserves 10/20/30/40/80/90; plugins use 41-79) ---
SEG_ORDER=()
SEG_TEXT=()
add_segment() { # add_segment <order:int> <text> — empty text is skipped, not registered
  [ -z "$2" ] && return 0
  SEG_ORDER+=("$1")
  SEG_TEXT+=("$2")
}

# --- model (name accent by tier) + effort/fast badge ---
case "$model_id" in
  *opus*)   maccent=$TH_MODEL_OPUS ;;
  *sonnet*) maccent=$TH_MODEL_SONNET ;;
  *haiku*)  maccent=$TH_MODEL_HAIKU ;;
  *fable*)  maccent=$TH_MODEL_FABLE ;;
  *)        maccent=$TH_MODEL_DEFAULT ;;
esac
badge=""
[ "$fast" = "true" ] && badge="${badge} $(fg "$TH_DIM")${G_FAST}"
if [ -n "$effort" ] && [ "$effort" != "$STANDARD_EFFORT" ]; then
  case "$effort" in
    low) e="L";; medium) e="M";; high) e="H";; xhigh) e="XH";; max) e="MAX";;
    *) e=$(printf '%s' "$effort" | tr '[:lower:]' '[:upper:]');;
  esac
  badge="${badge} $(fg "$TH_DIM")${e}"
fi
add_segment 10 "$(fg "$maccent")${G_MODEL} ${model}${badge}${reset}"

# --- context bar (truecolor gradient) ---
filled=$(( used_pct / 10 )); [ "$filled" -gt 10 ] && filled=10
bar=""
for ((i = 1; i <= 10; i++)); do
  if [ "$i" -le "$filled" ]; then
    bar="${bar}$(fgt "$(gradient_rgb $((i * 10)))")█"
  else
    bar="${bar}$(fg "$TH_DIM")░"
  fi
done
ctx_icon=""; [ -n "$G_CTX" ] && ctx_icon="${G_CTX} "
add_segment 20 "$(fg "$TH_CTX_FG")${ctx_icon}${bar} $(fgt "$(gradient_rgb "$used_pct")")${used_pct}%${reset}"

# --- 5h + 7d usage ---
if [ -n "$five_h" ]; then
  rt="$(fg "$TH_RATE_LABEL")5h $(fgt "$(gradient_rgb "${five_h%.*}")")$(printf '%.0f' "$five_h")%"
  [ -n "$seven_d" ] && rt="${rt} $(fg "$TH_RATE_LABEL")7d $(fgt "$(gradient_rgb "${seven_d%.*}")")$(printf '%.0f' "$seven_d")%"
  add_segment 30 "${rt}${reset}"
fi

# --- 5h reset ---
if [ -n "$five_h_reset" ]; then
  remaining=$(( ${five_h_reset%.*} - $(date +%s) )); [ "$remaining" -lt 0 ] && remaining=0
  h=$(( remaining / 3600 )); m=$(( (remaining % 3600) / 60 ))
  if [ "$h" -gt 0 ]; then rtxt="${h}h ${m}m"; else rtxt="${m}m"; fi
  add_segment 40 "$(fg "$TH_RESET_FG")${G_RESET} ${rtxt}${reset}"
fi

# --- launch folder (set once per conversation, so kept near the end) ---
if [ -n "$root" ]; then
  dir_icon=""; [ -n "$G_DIR" ] && dir_icon="${G_DIR} "
  add_segment 80 "$(fg "$TH_DIR_FG")${dir_icon}$(basename "$root")${reset}"
fi

# --- session cost ---
if [ -n "$cost" ]; then
  cost_icon=""; [ -n "$G_COST" ] && cost_icon="${G_COST} "
  add_segment 90 "$(fg "$TH_COST_FG")${cost_icon}$(printf '$%.2f' "$cost")${reset}"
fi

# --- plugin segments: each file calls add_segment itself (order 41-79 reserved) ---
if [ -d "$HOME/.claude/statusline.d" ]; then
  while IFS= read -r -d '' _plugin; do
    source "$_plugin"
  done < <(find "$HOME/.claude/statusline.d" -maxdepth 1 -name '*.sh' -print0 | LC_ALL=C sort -z)
fi

# --- emit: stable sort by order, join with the dim separator ---
out=""
first=1
_n=${#SEG_ORDER[@]}
_sorted_idx=$(
  for ((_i = 0; _i < _n; _i++)); do printf '%s\t%s\n' "${SEG_ORDER[$_i]}" "$_i"; done \
    | sort -n -s -k1,1 | cut -f2
)
while IFS= read -r _idx; do
  [ -z "$_idx" ] && continue
  if [ $first -eq 1 ]; then out+="${SEG_TEXT[$_idx]}"; first=0
  else out+=" $(fg "$TH_DIM")${TH_SEP}${reset} ${SEG_TEXT[$_idx]}"; fi
done <<< "$_sorted_idx"

printf "%b\n" "$out"
