#!/usr/bin/env bash
set -u
set -o pipefail

echo "╭──────────────────────────────────────────╮"
echo "│   📥 Bulk /(YouTube|Video)/ Downloader   │"
echo "│                by EDM115                 │"
echo "╰──────────────────────────────────────────╯"
echo

fatal() {
  echo
  echo "❗ Exiting..."
  exit 1
}

require_cmd() {
  if ! command -v "$1" >/dev/null 2>&1; then
    echo "❌ \"$1\" not found in PATH"
    echo "   💡 Tip : install it/add it to your PATH"
    return 1
  fi

  echo "🔰 Found $1"
  return 0
}

echo "🔍 Checking requirements..."
require_cmd yt-dlp || fatal
require_cmd ffmpeg || fatal
require_cmd ffprobe || fatal

LINKS_FILE="links.txt"

if [[ ! -f "$LINKS_FILE" ]]; then
  echo "❌ $LINKS_FILE not found in \"$(pwd)\""
  fatal
fi

mkdir -p "downloads"

echo "✅ All good !"
echo

if [[ $# -gt 0 ]]; then
  echo "🧩 Extra yt-dlp args detected (they override defaults if duplicated) :"
  printf "   %q " "$@"
  echo
fi

echo "📜 Parsing $LINKS_FILE..."
urls=()

while IFS= read -r line || [[ -n "$line" ]]; do
  # Remove indentation/whitespace, quotes, and trailing commas
  line="${line//[[:space:]]/}"
  line="${line//\"/}"
  line="${line%,}"

  # Skip empty/brackets
  [[ -z "$line" || "$line" == "[" || "$line" == "]" ]] && continue

  urls+=("$line")
done < "$LINKS_FILE"

count="${#urls[@]}"

if [[ "$count" -eq 0 ]]; then
  echo "❌ No URLs found in $LINKS_FILE !"
  fatal
fi

echo "🎯 $count links found !"
echo

DEFAULT_ARGS=(
  -f "bestvideo[height<=1080]+bestaudio/best[height<=1080]"
  --merge-output-format mp4
  --embed-subs
  --embed-thumbnail
  --embed-metadata
  --embed-chapters
  --progress
  --console-title
  --concurrent-fragments 4
  --retries 10
  --fragment-retries 10
  --ignore-errors
  --continue
  --download-archive downloaded.txt
  --sleep-requests 1
  --sleep-interval 2
  --max-sleep-interval 5
  -o "downloads/%(uploader|UnknownUploader)s/%(playlist_title|Singles)s/%(playlist_index|1)s - %(title)s [%(id)s].%(ext)s"
)

for i in "${!urls[@]}"; do
  n=$((i + 1))
  current_url="${urls[$i]}"

  echo "🔗 Processing link $n/$count"
  echo "⏬ Downloading $current_url ..."
  echo

  yt-dlp "${DEFAULT_ARGS[@]}" "$@" "$current_url"
  echo
done

echo "🎉 Download done !"
echo "🗃️ Your files are in the \"downloads\" folder"
echo
echo "🫂 Follow me on GitHub :"
echo "   https://github.com/EDM115"
echo
