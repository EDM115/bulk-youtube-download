# Bulk Youtube Downloader

## How to download all videos from a channel ?

0. Extract the `ffmpeg.7z` archive (use any good program like PeaZip, 7Zip or WinRar for this)  
**THE FILES MUST BE IN THE SAME FOLDER AS THE OTHERS, NOT IN A SUBFOLDER !**
1. Go on the Youtube channel, go on the Videos tab, and scroll down until no new video pops out (yes it takes time)
2. Open the console (F12 -> Console) and paste the following line :
```javascript
copy(Array.from(new Set(Array.from(document.links).filter((l) => l.href?.includes('watch?v=')).map(x => x.href.split('&')[0]))))
```
Then hit enter  
3. Open the `yt.txt` file, delete everything and paste (Ctrl + V)
*if you see no link, run the following command instead :*
```javascript
copy(Array.from(new Set(Array.from(document.links).filter((l) => l.href?.includes('.be/')).map(x => x.href.split('&')[0]))))
```
4. Run the `dl.bat` file

## Tutorial in video :
https://github.com/EDM115/bulk-youtube-download/assets/82015596/8ab3de7d-27ca-42b4-890b-e596f1592e8e
*(also available in the repo)*

## Error ?

- The `yt.txt` should look like this :
```
[
    "https://www.youtube.com/watch?v=dYVoZJXuhxk",
    "https://www.youtube.com/watch?v=1TwBc7B46X0",
    "https://www.youtube.com/watch?v=h2csePLbahQ",
    "https://www.youtube.com/watch?v=-m1EzV-i3WI",
    "https://www.youtube.com/watch?v=-JdZsKzYWhI"
]
```
- The video may be geo-restricted

## Scalability :

- Just open the `dl.bat` and edit the line 69
- All yt-dlp options can be found on their README (check the very next link)

## Attribution :

- `yt-dlp` is an open-source project released under the Unilicence licence : https://github.com/yt-dlp/yt-dlp
- `FFmpeg` is an open-source project released under the LGPL v2.1+ and GPL v2+ licences : https://github.com/FFmpeg/FFmpeg
- This simple project is released under the MIT Licence

## Versions used :

- `yt-dlp` : 2023.09.24
- `FFmpeg` : 2023-08-10

## Credits :
- Program created by me ([@EDM115](https://github.com/EDM115))
- Inspired by a request of [Crystal](https://t.me/Cris_admin)
