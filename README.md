# Wavesstack — Quick Start Guide

Welcome to **Wavesstack**! Follow this guide to set up and manage your complete music stack on **Ubuntu**.

> **Requirement:** This guide is written specifically for **Ubuntu Linux** (20.04 LTS, 22.04 LTS, 24.04 LTS, or newer recommended).

---

## Prerequisites Installation

Before running Wavesstack, you must install **Docker**, **Docker Compose**, and **Tailscale** on your Ubuntu system.

### Install Docker & Docker Compose
Run the following block of commands in your terminal to install the official Docker Engine and Docker Compose plugin:

```bash
# Update package index and install initial required packages
sudo apt-get update
sudo apt-get install -y ca-certificates curl gnupg

# Add Docker's official GPG key
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

# Add Docker repository to Apt sources
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Install Docker packages and Docker Compose
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# (Optional) Allow running Docker commands without 'sudo'
sudo usermod -aG docker $USER
```

> **Note:** If you run `usermod`, log out and log back in for group changes to take effect.

*Verify installation:*
```bash
docker --version
docker compose version
```

---

### Install & Authenticate Tailscale
Install Tailscale to enable secure VPN remote access across your devices:

```bash
# Download and run the official Tailscale installer
curl -fsSL https://tailscale.com/install.sh | sh

# Authenticate and start Tailscale
sudo tailscale up
```

---

## Wavesstack First-Time Setup

Navigate into your local **Wavesstack** directory and configure script permissions and global system shortcuts:

```bash
# 1. Make the control scripts executable
chmod +x wavesstack-up.sh wavesstack-down.sh

# 2. Create global symlinks (allows running commands from any directory)
sudo ln -s "$(pwd)/wavesstack-up.sh" /usr/local/bin/wavesstack-up
sudo ln -s "$(pwd)/wavesstack-down.sh" /usr/local/bin/wavesstack-down
```

---

## Usage & Management

Once set up, you can control the entire stack globally from any terminal directory:

| Action | Global Command | Script Alternative |
| :--- | :--- | :--- |
| **Start All Services** | `wavesstack-up` | `./wavesstack-up.sh` |
| **Stop All Services** | `wavesstack-down` | `./wavesstack-down.sh` |

### Check Active Services
To view running containers and stack status:
```bash
docker ps -a
```

---

## Mobile Connection & Remote Access

To stream or download new music directly to your smartphone (iOS/Android):

1. **Enable Tailscale:** Open the Tailscale app on your phone and log in with the same account as the server.
2. **Install a Subsonic Client App:**
   * **iOS:** Install **Amplefin**, **substreamer**, or **play:Sub**
   * **Android:** Install **Symfonium** or **substreamer**
3. **Connect to Navidrome:**
   * **Server URL:** `http://<TAILSCALE_IP>:4533` *(Get IP with `tailscale ip -4` on the server)*
   * Enter your Navidrome credentials to access, stream, and download music locally to your phone.
4. **Download New Music from Mobile:**
   * **Web Interface:** Access **Music Downloader** at `http://<TAILSCALE_IP>:8080/process?URL=[youtube link | youtube-music link | spotify link]` via your mobile browser.
   * It will download directly into your Wavesstack library (Navidrome will auto-scan the new files).

