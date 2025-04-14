from flask import Flask, request, send_file, render_template_string, Response
import subprocess
import os
import uuid

app = Flask(__name__)  # ✅ This is the app Gunicorn needs to find

HTML_FORM = """
<!doctype html>
<title>YouTube Clip Trimmer</title>
<h2>Trim a YouTube Video</h2>
<form method=post>
  YouTube URL:<br><input type=text name=url size=60><br><br>
  Start Time (hh:mm:ss):<br><input type=text name=start><br><br>
  End Time (hh:mm:ss):<br><input type=text name=end><br><br>
  <input type=submit value=Trim>
</form>
"""

@app.route('/', methods=['GET', 'POST'])
def index():
    if request.method == 'POST':
        url = request.form['url']
        start = request.form['start']
        end = request.form['end']

        video_id = str(uuid.uuid4())
        input_file = f"{video_id}.mp4"
        output_file = f"{video_id}_clip.mp4"

        try:
            # Download the video
            subprocess.run(["yt-dlp", "-f", "best", "-o", input_file, url], check=True)

            # Trim it
            subprocess.run([
                "ffmpeg", "-y", "-i", input_file, "-ss", start, "-to", end,
                "-c", "copy", output_file
            ], check=True)

            return send_file(output_file, as_attachment=True)

        except subprocess.CalledProcessError as e:
            return f"<p>Error: {e}</p><a href='/'>Go back</a>"

        finally:
            # Clean up the big input file
            if os.path.exists(input_file):
                os.remove(input_file)

    return render_template_string(HTML_FORM)

if __name__ == '__main__':
    app.run(debug=True)
