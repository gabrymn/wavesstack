import subprocess
from fastapi import FastAPI, Query
from typing import Optional

app = FastAPI(title="URL Receiver API")

LOG_FILE = "requests.log"
SCRIPT_NAME = "./downloader.sh"

@app.get("/")
def home():
    return {"status": "ok", "message": "Server online"}

@app.get("/process")
def receive_url(
    URL: Optional[str] = Query(default=None),
    url: Optional[str] = Query(default=None)
):
    target_url = URL or url

    if target_url:
    
        with open(LOG_FILE, "a", encoding="utf-8") as f:
            f.write(f"{target_url}\n")
        
        subprocess.Popen([SCRIPT_NAME, target_url])

        return {
            "status": "success",
            "message": "Background download started",
            "saved_url": target_url
        }
    
    return {
        "status": "error",
        "message": "You must provide an URL"
    }

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8080)
