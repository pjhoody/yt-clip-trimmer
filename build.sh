#!/usr/bin/env bash

echo "🔧 Installing ffmpeg and yt-dlp..."

# Install ffmpeg
apt-get update && apt-get install -y ffmpeg

# Install yt-dlp
pip install yt-dlp

# Then install app dependencies
pip install -r requirements.txt

echo "✅ Build complete!"

