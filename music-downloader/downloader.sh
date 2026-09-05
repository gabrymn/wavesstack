#!/bin/bash

if [ -z "$1" ]; then
  echo "Errore: inserisci un URL. Es: $0 <URL_YOUTUBE>"
  exit 1
fi

mkdir -p downloads

RANDOM_ALBUM=$(openssl rand -hex 6 | tr '[:lower:]' '[:upper:]')

yt-dlp \
  --extractor-args "youtube:player_client=android,ios" \
  -x \
  --audio-format mp3 \
  --audio-quality 0 \
  --embed-thumbnail \
  --embed-metadata \
  --parse-metadata "title:%(artist)s - %(track,title)s" \
  --parse-metadata "$RANDOM_ALBUM:%(album)s" \
  --replace-in-metadata title " \([^\)]*Official[^\)]*\)" "" \
  --replace-in-metadata title " \([^\)]*Explicit[^\)]*\)" "" \
  --postprocessor-args "ffmpeg:-write_id3v2 1 -id3v2_version 3" \
  -o "downloads/%(track_number,playlist_index)02d - %(artist,creator,uploader)s - %(track,title)s.%(ext)s" \
  "$1"
