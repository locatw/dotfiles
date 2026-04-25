#!/bin/bash
# Claude Code status line - session info display
# Reads JSON from stdin, outputs formatted status

input=$(cat)

# --- Extract all fields in a single jq call (newline-delimited) ---
{
read -r MODEL
read -r COST
read -r DURATION_MS
read -r API_MS
read -r LINES_ADD
read -r LINES_DEL
read -r PCT
read -r CTX_SIZE
read -r IN_TOKENS
read -r OUT_TOKENS
read -r CACHE_CREATE
read -r CACHE_READ
read -r RATE_5H
read -r RATE_7D
read -r CURRENT_DIR
read -r PROJECT_DIR
} <<< "$(echo "$input" | jq -r '
  (.model.display_name // "?"),
  (.cost.total_cost_usd // 0),
  (.cost.total_duration_ms // 0 | floor),
  (.cost.total_api_duration_ms // 0 | floor),
  (.cost.total_lines_added // 0),
  (.cost.total_lines_removed // 0),
  (.context_window.used_percentage // 0 | floor),
  (.context_window.context_window_size // 0),
  (.context_window.current_usage.input_tokens // 0),
  (.context_window.current_usage.output_tokens // 0),
  (.context_window.current_usage.cache_creation_input_tokens // 0),
  (.context_window.current_usage.cache_read_input_tokens // 0),
  (.rate_limits.five_hour.used_percentage | if . == null then "null" else floor end),
  (.rate_limits.seven_day.used_percentage  | if . == null then "null" else floor end),
  (.workspace.current_dir // ""),
  (.workspace.project_dir // "")
')"

# --- Colors ---
GREEN='\033[32m'
YELLOW='\033[33m'
RED='\033[31m'
CYAN='\033[36m'
DIM='\033[2m'
RESET='\033[0m'

# --- Helper: format token count (850, 15.2K, 1.2M) ---
fmt_tokens() {
  local n=$1
  if [ "$n" -ge 1000000 ]; then
    printf '%s.%sM' "$((n / 1000000))" "$((n % 1000000 / 100000))"
  elif [ "$n" -ge 1000 ]; then
    printf '%s.%sK' "$((n / 1000))" "$((n % 1000 / 100))"
  else
    printf '%s' "$n"
  fi
}

# --- Helper: format ms to Xm Ys ---
fmt_duration() {
  local ms=$1
  local sec=$((ms / 1000))
  local min=$((sec / 60))
  local s=$((sec % 60))
  if [ "$min" -gt 0 ]; then
    printf '%dm %ds' "$min" "$s"
  else
    printf '%ds' "$s"
  fi
}

# --- Helper: color for rate limit percentage ---
fmt_rate() {
  local pct=$1
  local label=$2
  if [ "$pct" -ge 80 ]; then
    printf '%b' "${RED}${label}:${pct}%${RESET}"
  elif [ "$pct" -ge 50 ]; then
    printf '%b' "${YELLOW}${label}:${pct}%${RESET}"
  else
    printf '%b' "${GREEN}${label}:${pct}%${RESET}"
  fi
}

# --- Build context bar ---
if [ "$PCT" -ge 90 ]; then
  BAR_COLOR="$RED"
elif [ "$PCT" -ge 70 ]; then
  BAR_COLOR="$YELLOW"
else
  BAR_COLOR="$GREEN"
fi

BAR_WIDTH=10
FILLED=$((PCT * BAR_WIDTH / 100))
EMPTY=$((BAR_WIDTH - FILLED))
BAR=""
[ "$FILLED" -gt 0 ] && BAR=$(printf "%${FILLED}s" | tr ' ' '=')
[ "$EMPTY" -gt 0 ] && BAR="${BAR}$(printf "%${EMPTY}s" | tr ' ' '-')"

# --- Relative directory ---
REL_DIR="${CURRENT_DIR#$PROJECT_DIR}"
REL_DIR="${REL_DIR#/}"

# --- Format values ---
COST_FMT=$(printf '$%.2f' "$COST")
IN_FMT=$(fmt_tokens "$IN_TOKENS")
OUT_FMT=$(fmt_tokens "$OUT_TOKENS")
CTX_SIZE_FMT=$(fmt_tokens "$CTX_SIZE")
DUR_FMT=$(fmt_duration "$DURATION_MS")
API_FMT=$(fmt_duration "$API_MS")

# --- Rate limits (only when available, i.e. not API key) ---
RATE_FMT=""
if [ "$RATE_5H" != "null" ] && [ "$RATE_7D" != "null" ]; then
  RATE_FMT=" | $(fmt_rate "$RATE_5H" "5h") $(fmt_rate "$RATE_7D" "7d")"
fi

# --- Cache info ---
CACHE_FMT=""
if [ "$CACHE_CREATE" -gt 0 ] || [ "$CACHE_READ" -gt 0 ]; then
  CACHE_FMT=" ($(fmt_tokens "$CACHE_CREATE")+$(fmt_tokens "$CACHE_READ") cached)"
fi

# --- Relative dir suffix ---
DIR_FMT=""
if [ -n "$REL_DIR" ]; then
  DIR_FMT=" ${DIM}| ${REL_DIR}${RESET}"
fi

# --- Line 1: model, cost, tokens, code changes, rate limits, rel dir ---
printf '%b' "${CYAN}[${MODEL}]${RESET} ${YELLOW}${COST_FMT}${RESET} | ${IN_FMT} in / ${OUT_FMT} out | +${LINES_ADD}/-${LINES_DEL} lines${RATE_FMT}${DIR_FMT}\n"

# --- Line 2: context bar, cache, duration ---
printf '%b' "${BAR_COLOR}${BAR}${RESET} ${PCT}%/${CTX_SIZE_FMT} ctx${CACHE_FMT} | ${DUR_FMT} ${DIM}(API ${API_FMT})${RESET}\n"
