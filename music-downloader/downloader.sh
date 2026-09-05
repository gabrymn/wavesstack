#!/bin/bash

if [ -z "$1" ]; then
  echo "Errore: inserisci un URL."
  exit 1
fi

URL="$1"
DOWNLOAD_DIR="downloads"
mkdir -p "$DOWNLOAD_DIR"

RANDOM_ALBUM=$(openssl rand -hex 6 | tr '[:lower:]' '[:upper:]')

# Controlla se l'URL proviene da Spotify
if [[ "$URL" =~ spotify\.com ]]; then
  echo "Rilevato link Spotify. Avvio download con spotDL..."
  
  # spotDL gestisce nativamente download, copertine e metadati in alta qualità
  spotdl "$URL" \
    --output "$DOWNLOAD_DIR/{track-number} - {artist} - {title}.{output-ext}" \
    --format mp3 \
    --bitrate 320k

else
  echo "Rilevato link generico/YouTube. Avvio download con yt-dlp..."
  
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
    -o "$DOWNLOAD_DIR/%(track_number,playlist_index)02d - %(artist,creator,uploader)s - %(track,title)s.%(ext)s" \
    "$URL"
fi
