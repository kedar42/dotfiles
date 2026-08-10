#!/usr/bin/env bash

input=$(cat)

c_reset='\033[0m'
c_violet='\033[38;2;149;127;184m'
c_blue='\033[38;2;126;156;216m'
c_dim='\033[38;2;84;84;109m'
c_orange='\033[38;2;255;160;102m'
c_grey='\033[38;2;114;113;105m'

sep=" ${c_dim}|${c_reset} "

model=$(printf '%s' "$input" | jq -r '.model.display_name // "Claude"')
used_pct=$(printf '%s' "$input" | jq -r '(.context_window.used_percentage // 0) | floor')
five_h=$(printf '%s' "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
five_h_reset=$(printf '%s' "$input" | jq -r '.rate_limits.five_hour.resets_at // empty')
seven_d=$(printf '%s' "$input" | jq -r '.rate_limits.seven_day.used_percentage // empty')

[ -z "$used_pct" ] && used_pct=0
used_pct=${used_pct%.*}
[ -z "$used_pct" ] && used_pct=0

gradient_rgb() {
  local p=$1
  local r0=152 g0=187 b0=108
  local r1=230 g1=195 b1=132
  local r2=255 g2=160 b2=102
  local r3=232 g3=36 b3=36
  local r g b t span

  [ -z "$p" ] && p=0
  [ "$p" -lt 0 ] && p=0
  [ "$p" -gt 100 ] && p=100

  if [ "$p" -le 33 ]; then
    t=$p; span=33
    r=$(( r0 + (r1 - r0) * t / span )); g=$(( g0 + (g1 - g0) * t / span )); b=$(( b0 + (b1 - b0) * t / span ))
  elif [ "$p" -le 66 ]; then
    t=$((p - 33)); span=33
    r=$(( r1 + (r2 - r1) * t / span )); g=$(( g1 + (g2 - g1) * t / span )); b=$(( b1 + (b2 - b1) * t / span ))
  else
    t=$((p - 66)); span=34
    [ "$t" -gt 34 ] && t=34
    r=$(( r2 + (r3 - r2) * t / span )); g=$(( g2 + (g3 - g2) * t / span )); b=$(( b2 + (b3 - b2) * t / span ))
  fi
  printf '%d;%d;%d' "$r" "$g" "$b"
}

if   [ "$used_pct" -lt 20 ]; then emoji="🟢"
elif [ "$used_pct" -lt 70 ]; then emoji="⚡"
elif [ "$used_pct" -lt 90 ]; then emoji="🔥"
else emoji="🚨"
fi

filled=$(( used_pct / 10 ))
[ "$filled" -gt 10 ] && filled=10
bar=""
for ((i = 1; i <= 10; i++)); do
  if [ "$i" -le "$filled" ]; then
    rgb=$(gradient_rgb $((i * 10)))
    bar="${bar}\033[38;2;${rgb}m█${c_reset}"
  else
    bar="${bar}${c_grey}░${c_reset}"
  fi
done
pct_rgb=$(gradient_rgb "$used_pct")

reset_str=""
if [ -n "$five_h_reset" ]; then
  remaining=$(( ${five_h_reset%.*} - $(date +%s) ))
  [ "$remaining" -lt 0 ] && remaining=0
  h=$(( remaining / 3600 )); m=$(( (remaining % 3600) / 60 ))
  if [ "$h" -gt 0 ]; then reset_str="⏳ ${h}h ${m}m"; else reset_str="⏳ ${m}m"; fi
fi

rate_str=""
if [ -n "$five_h" ]; then
  five_i=${five_h%.*}
  rate_str="${c_blue}5h${c_reset} \033[38;2;$(gradient_rgb "$five_i")m$(printf '%.0f' "$five_h")%${c_reset}"
fi
if [ -n "$seven_d" ]; then
  seven_i=${seven_d%.*}
  [ -n "$rate_str" ] && rate_str="${rate_str} "
  rate_str="${rate_str}${c_blue}7d${c_reset} \033[38;2;$(gradient_rgb "$seven_i")m$(printf '%.0f' "$seven_d")%${c_reset}"
fi

out="${c_violet}🤖 ${model}${c_reset}"
out="${out}${sep}${emoji} ${bar} \033[38;2;${pct_rgb}m${used_pct}%${c_reset}"
[ -n "$rate_str" ] && out="${out}${sep}${rate_str}"
[ -n "$reset_str" ] && out="${out}${sep}${c_orange}${reset_str}${c_reset}"

printf "%b\n" "$out"
