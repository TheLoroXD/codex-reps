#!/bin/sh
set -eu

mode="${1:-hourly}"
payload="$(cat || true)"
log_dir="$HOME/.vibereps"
mkdir -p "$log_dir"
printf '%s\t%s\t%s\n' "$(date '+%Y-%m-%dT%H:%M:%S%z')" "$mode" "$payload" >> "$log_dir/hook-payloads.jsonl"

case "$mode" in
  notify)
    printf '%s' "$payload" | "$(dirname "$0")/vibereps.py"
    ;;
  hourly)
    printf '%s' "$payload" | env VIBEREPS_MODE=hourly_squats VIBEREPS_EXERCISES=squats "$(dirname "$0")/vibereps.py"
    ;;
  *)
    echo "unknown mode: $mode" >&2
    exit 2
    ;;
esac
