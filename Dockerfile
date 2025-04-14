# Use an official Python image
FROM python:3.11-slim

# Install ffmpeg and yt-dlp system-wide
RUN apt-get update && \
    apt-get install -y ffmpeg curl && \
    curl -L https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp -o /usr/local/bin/yt-dlp && \
    chmod a+rx /usr/local/bin/yt-dlp && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Copy all project files
COPY . .

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Expose port for Render
EXPOSE 10000

# Start app
CMD ["gunicorn", "-b", "0.0.0.0:10000", "app:app"]
