#!/usr/bin/env bash

echo "🔧 Installing ffmpeg and yt-dlp..."

# Install apt packages (ffmpeg)
apt-get update && apt-get install -y ffmpeg

# Install yt-dlp using pip
pip install yt-dlp

# Then install your Python dependencies
pip install -r requirements.txt

echo "✅ Build complete!"
