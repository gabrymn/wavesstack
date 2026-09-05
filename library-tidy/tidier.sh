#!/bin/sh

# (findutils per avere il supporto a -printf su Alpine)
if ! command -v findutils >/dev/null 2>&1; then
  apk add --no-cache findutils >/dev/null 2>&1
fi

# ogni 900 secondi (15min) controlla la dimensione
CHECK_INTERVAL=900

while true; do
  LIMIT_GB=${MAX_SIZE_GB:-30}
  
  MAX_KB=$(awk -v gb="$LIMIT_GB" 'BEGIN { printf "%.0f", gb * 1024 * 1024 }')
  
  CURRENT_KB=$(du -sk /music | awk '{print $1}')
  
  if [ "$CURRENT_KB" -gt "$MAX_KB" ]; then
    echo "[CLEANER] Dimensione attuale (${CURRENT_KB} KB) > Limite (${MAX_KB} KB). Avvio pulizia..."
    
    find /music -type f -name "*.mp3" -printf "%T@ %p\n" | sort -n | while read -r ts file; do
      FILE_KB=$(du -k "$file" | awk '{print $1}')
      rm -f "$file"
      echo "[CLEANER] Rimosso: $file"
      
      CURRENT_KB=$((CURRENT_KB - FILE_KB))
      if [ "$CURRENT_KB" -le "$MAX_KB" ]; then
        echo "[CLEANER] Pulizia completata! Dimensione rientrata nei limiti."
        break
      fi
    done
  else
    echo "[CLEANER] OK - Dimensione attuale: ${CURRENT_KB} KB (Soglia: ${MAX_KB} KB)"
  fi

  sleep $CHECK_INTERVAL
done
