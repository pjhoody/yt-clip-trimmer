# Base image with Python and ffmpeg preinstalled
FROM python:3.11-slim

# Install ffmpeg and system dependencies
RUN apt-get update && \
    apt-get install -y ffmpeg && \
    apt-get clean

# Set work directory
WORKDIR /app

# Copy project files
COPY . .

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt
RUN pip install yt-dlp

# Expose port Render expects
EXPOSE 10000

# Start the app with gunicorn
CMD ["gunicorn", "-b", "0.0.0.0:10000", "app:app"]
