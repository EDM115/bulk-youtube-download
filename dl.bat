@echo off
setlocal enabledelayedexpansion

echo ----- YouTube Bulk Downloader -----
echo -----        by EDM115        -----
echo.
echo.
echo ----- Checking required files... -----
echo.

if not exist yt-dlp.exe (
    echo yt-dlp.exe not found !
	echo Exiting now...
	pause
	endlocal
    exit /b
)
if not exist ffmpeg.exe (
    echo ffmpeg.exe not found !
	echo Exiting now...
	pause
	endlocal
    exit /b
)
if not exist ffprobe.exe (
    echo ffprobe.exe not found !
	echo Exiting now...
	pause
	endlocal
	exit /b
)
if not exist yt.txt (
    echo yt.txt not found !
	echo Exiting now...
	pause
	endlocal
    exit /b
)

echo ----- Required files found -----
echo.
echo ----- Parsing the yt.txt file... -----
echo.

set count=0
for /f "delims=" %%a in (yt.txt) do (
    if "%%a" neq "[" if "%%a" neq "]" (
        set /a count+=1
        set "url[!count!]=%%a"
    )
)

if %count% EQU 0 (
    echo No URLs found in yt.txt !
    pause
	endlocal
    exit /b
)

echo ----- %count% links found ! -----
echo.

for /l %%i in (1,1,%count%) do (
    echo ----- Processing string %%i/%count%... -----
	echo.
    set "current_url=!url[%%i]!"
    set "current_url=!current_url:"=!"
	set "current_url=!current_url:,=!"
    yt-dlp.exe --ffmpeg-location "ffmpeg.exe" -f bestvideo+bestaudio/best --embed-subs --embed-thumbnail --embed-metadata --no-playlist -o "downloads\%%(title)s [%%(id)s].%%(ext)s" !current_url!
	echo.
)

echo ----- Download done ! -----
echo TYour files are in the downloads folder
echo.
echo Follow me on GitHub :
echo https://github.com/EDM115
echo.

pause
endlocal
exit /b
