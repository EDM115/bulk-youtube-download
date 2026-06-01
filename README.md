<div align="center">

# Bulk `/(YouTube|Video)/` Downloader
## Download multiple videos at once with one simple script
Works with Youtube and [all other sites supported by `yt-dlp`](https://github.com/yt-dlp/yt-dlp/blob/master/supportedsites.md).  
![Total downloads](https://img.shields.io/github/downloads/EDM115/bulk-youtube-download/total?style=for-the-badge&label=Total%20downloads)

</div>

## Prerequisites
- Download `yt-dlp`
  - For Linux-based systems, [`apt`](https://github.com/yt-dlp/yt-dlp/wiki/Installation#apt) is probably the easiest way
  - For Windows, [`winget`](https://github.com/yt-dlp/yt-dlp/wiki/Installation#winget) might be the easiest, although if you don't have winget, just download the [`.exe`](https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp.exe) and put it somewhere in your PATH (if you don't know what that is, create a folder called `yt-dlp` in `%APPDATA%`, put the exe there, do <kbd>Win</kbd> + <kbd>R</kbd>, `systempropertiesadvanced`, Environment Variables, in System variables double click on `Path`, new, `%APPDATA%\yt-dlp` and OK all the way out), in that case use `yt-dlp -U` to update it later
  - If you have it installed with `pip`, make sure to update it to the latest version that has `ejs` support by running `pip install -U yt-dlp[default]`
- Download `FFmpeg`
  - For Linux-based systems, it should already be installed, otherwise check [this](https://www.ffmpeg.org/download.html#build-linux)
  - For Windows, either run `winget install Gyan.FFmpeg` or download [this](https://www.gyan.dev/ffmpeg/builds/ffmpeg-git-full.7z) and follow the same instructions as above to add it to your PATH
- Download `Deno` (required to support YouTube download with the latest `yt-dlp` versions)
  - For Linux-based systems, run `curl -fsSL https://deno.land/install.sh | sh`
  - For Windows, either run `winget install DenoLand.Deno` or `irm https://deno.land/install.ps1 | iex` in Powershell

## Usage
- Download the script file [`bulk-youtube-download.bat`](https://github.com/EDM115/bulk-youtube-download/releases/latest/download/bulk-youtube-download.bat) (or [`bulk-youtube-download.sh`](https://github.com/EDM115/bulk-youtube-download/releases/latest/download/bulk-youtube-download.sh) for Linux/Mac) and put it somewhere you want
- Create a text file called `links.txt` in the same folder as the script
- Put your links in the `links.txt` file as a JSON array, for example :
  ```json
  [
    "https://youtu.be/7ssVNgOK_MM",
    "https://youtu.be/xyLWY2wXbho",
    "https://youtu.be/p0dw-276t7w",
    "https://www.youtube.com/watch?v=dYVoZJXuhxk",
    "https://www.youtube.com/watch?v=1TwBc7B46X0",
    "https://www.youtube.com/watch?v=h2csePLbahQ",
    "https://www.youtube.com/watch?v=-m1EzV-i3WI",
    "https://www.youtube.com/watch?v=-JdZsKzYWhI",
    "https://www.youtube.com/playlist?list=PLliBvQE3gg9doyZ2XgGOFMn4FHzdZquuZ",
    "https://www.youtube.com/@snaptic.3d/videos",
    "https://www.youtube.com/@snaptic.3d/shorts"
  ]
  ```
> [!NOTE]  
> Supported URL types :
> - Single videos
> - Playlists
> - Channel `/videos` pages
> - Mixed URLs together

- Open a terminal/command prompt in the folder where you put the script and the `links.txt` file
- Run the script :
  - On Windows : `.\bulk-youtube-download.bat`
  - On Linux/Mac : `./bulk-youtube-download.sh`
- Congrats, the videos are now in the `downloads` folder !

## Default download options and how to change them
By default, the script uses the following options :
- Format : best video + best audio, fallback to best if not available
- Embed subtitles (if available)
- Embed thumbnail
- Embed metadata
- Embed chapters (if available)
- Playlist support in addition to single videos
- Resume interrupted downloads
- Parallel fragment downloading for faster downloads
- Retry failed downloads automatically
- Output folder : `downloads` (created if it doesn't exist), filename format : `Video Title [Video ID].ext`, in a subfolder named after the playlist if the video is part of a playlist
  Downloads are automatically organized like this :
  ```text
  downloads/
  ├── Video title [VideoID].mp4
  └── Channel name/
      ├── 1 - Video title [VideoID].mp4
      └── 2 - Video title [VideoID].mp4
  └── Playlist name/
      ├── 1 - Video title [VideoID].mp4
      └── 2 - Video title [VideoID].mp4
  ```

To change these options, just pass what you want after the script name, for example `.\bulk-youtube-download.bat -f "bestvideo[height<=720]+bestaudio/best" --no-embed-subs -o "downloads/%%(title)s.%%(ext)s"`.  
A list of options can be found [here](https://github.com/yt-dlp/yt-dlp#usage-and-options).  
Here are some options that might be worth using :
- `no-playlist` if you want to skip playlist links
- `--cookies-from-browser chrome` for private/age restricted videos
- `-s -F` to see the available formats for each video without downloading
- `-f "format"` to specify the format to download, see [this](https://github.com/yt-dlp/yt-dlp#format-selection)
- `-o "downloads/output_template"` : change the output folder and/or filename format, see [this](https://github.com/yt-dlp/yt-dlp#output-template)  
  ⚠️ **WARNING** : on Windows, make sure to double the `%` signs in the output template (example : use `%%(title)s` instead of `%(title)s`). Also it's best to keep the `downloads/` part to avoid cluttering the script folder with all the downloaded videos
- `--sub-langs` to specify which subtitles to download, use `--list-subs` before to see available languages
- `-x` to extract audio only for videos that don't provide separate audio and video streams
- `--force-keyframes-at-cuts --sponsorblock-remove sponsor,selfpromo` to remove segments of the video, see [this](https://github.com/yt-dlp/yt-dlp#sponsorblock-options) for available categories. The `--force-keyframes-at-cuts` option is recommended to have better results when cutting the video, although it takes longer to process

---

## How to download all videos from a channel ?
1. Go on the Youtube channel, go on the Videos tab, reload the page and scroll down until no new video pops out (yes it can take some time)
2. Open the console (<kbd>F12</kbd> -> Console) paste the following line and hit enter :
   ```js
   copy(Array.from(new Set(Array.from(document.links).filter((l) => l.href?.includes("watch?v=")).map((x) => x.href.split("&")[0]))))
   ```
3. Open the `links.txt` file, delete everything, paste (<kbd>Ctrl</kbd> + <kbd>V</kbd>) and save the file

> [!TIP]  
> if you see no link, run the following command instead :
>
> ```js
> copy(Array.from(new Set(Array.from(document.links).filter((l) => l.href?.includes(".be/")).map((x) => x.href.split("&")[0]))))
> ```

## Demo
<video src="https://github.com/user-attachments/assets/6ebc63ea-737e-46e0-87ee-b403b2272ae4" width="1920" height="1080"></video>

# You have an error ?
- The video may be geo-restricted
- The video may be private
- The video may be age-restricted and require cookies
- Youtube is rate limiting you
- Missing cookies (in some cases)
- [Outdated `yt-dlp`](https://github.com/yt-dlp/yt-dlp#update)
- If you have any special error message, [open an issue **here first**](https://github.com/EDM115/bulk-youtube-download/issues/new/choose) to not bloat yt-dlp's repo

---

## Credits
- Script created by myself ([@EDM115](https://github.com/EDM115))
- Inspired by a request of [Crystal](https://t.me/Cris_admin)
- With improvements from [@Abhijithsp](https://github.com/Abhijithsp)
