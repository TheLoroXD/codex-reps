#!/bin/sh
set -eu

mode="${1:-hourly}"
payload="$(cat || true)"
log_dir="$HOME/.vibereps"
mkdir -p "$log_dir"
printf '%s\t%s\t%s\n' "$(date '+%Y-%m-%dT%H:%M:%S%z')" "$mode" "$payload" >> "$log_dir/hook-payloads.jsonl"
out_file="$(mktemp "${TMPDIR:-/tmp}/codex-reps-hook.XXXXXX")"

case "$mode" in
  notify)
    if printf '%s' "$payload" | "$(dirname "$0")/vibereps.py" >"$out_file" 2>&1; then code=0; else code=$?; fi
    ;;
  hourly)
    if printf '%s' "$payload" | env VIBEREPS_MODE=hourly_squats "$(dirname "$0")/vibereps.py" >"$out_file" 2>&1; then code=0; else code=$?; fi
    ;;
  *)
    echo "unknown mode: $mode" >&2
    exit 2
    ;;
esac

sed 's/\x1b/[esc]/g' "$out_file" >> "$log_dir/hook-output.log"
rm -f "$out_file"
exit "$code"
