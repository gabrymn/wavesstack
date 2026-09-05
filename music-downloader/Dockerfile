FROM python:3.11-slim

# Installazione dipendenze di sistema per lo script bash (ffmpeg e openssl)
RUN apt-get update && apt-get install -y --no-install-recommends \
    ffmpeg \
    openssl \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY main.py .
COPY downloader.sh .

RUN chmod +x downloader.sh

EXPOSE 8080

CMD ["python", "main.py"]
