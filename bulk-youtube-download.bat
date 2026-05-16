@echo off
setlocal EnableExtensions EnableDelayedExpansion

echo ╭──────────────────────────────────────────╮
echo │   📥 Bulk /(YouTube^|Video)/ Downloader   │
echo │                by EDM115                 │
echo ╰──────────────────────────────────────────╯
echo.

echo 🔍 Checking requirements...
call :require_cmd yt-dlp || goto :fatal
call :require_cmd ffmpeg || goto :fatal
call :require_cmd ffprobe || goto :fatal

if not exist "links.txt" (
  echo ❌ links.txt not found in "%CD%"
  goto :fatal
)

if not exist "downloads\" (
  mkdir "downloads" >nul 2>&1
)

echo ✅ All good !
echo.

if not "%~1"=="" (
  echo 🧩 Extra yt-dlp args detected ^(they override defaults if duplicated^) :
  echo    %*
  echo.
)

echo 📜 Parsing links.txt...
set count=0

for /f "usebackq delims=" %%A in ("links.txt") do (
  set "line=%%A"

  rem Remove indentation/whitespace, quotes, and trailing commas
  set "line=!line: =!"
  set "line=!line:"=!"
  set "line=!line:,=!"

  rem Skip empty/brackets
  if not "!line!"=="" if /i not "!line!"=="[" if /i not "!line!"=="]" (
    set /a count+=1
    set "url[!count!]=!line!"
  )
)

if !count! EQU 0 (
  echo ❌ No URLs found in links.txt !
  goto :fatal
)

echo 🎯 !count! links found !
echo.

set DEFAULT_ARGS=-f "bestvideo+bestaudio/best" --merge-output-format mp4 --embed-subs --embed-thumbnail --embed-metadata --embed-chapters --windows-filenames --progress --console-title --concurrent-fragments 4 --retries 10 --fragment-retries 10 --ignore-errors --continue -o "downloads\%%(playlist_title,Unknown Playlist)s\%%(playlist_index)s - %%(title)s [%%(id)s].%%(ext)s"


@REM set DEFAULT_ARGS=-f "bestvideo+bestaudio/best" --embed-subs --embed-thumbnail --embed-metadata --embed-chapters --no-playlist --windows-filenames --progress --console-title -o "downloads\%%(title)s [%%(id)s].%%(ext)s"

for /l %%i in (1,1,!count!) do (
  echo 🔗 Processing link %%i/!count!
  set "current_url=!url[%%i]!"
  set "current_url=!current_url:"=!"
  set "current_url=!current_url:,=!"
  echo ⏬ Downloading !current_url! ...
  echo.

  yt-dlp %DEFAULT_ARGS% %* "!current_url!"
  echo.
)

echo 🎉 Download done !
echo 🗃️ Your files are in the "downloads" folder
echo.
echo 🫂 Follow me on GitHub :
echo    https://github.com/EDM115
echo.
pause
endlocal
exit /b 0

:require_cmd
where /q %~1 >nul 2>&1
if errorlevel 1 (
  echo ❌ "%~1" not found in PATH
  echo    💡 Tip : add the folder containing %~1.exe to your PATH
  exit /b 1
)
echo 🔰 Found %~1
exit /b 0

:fatal
echo.
echo ❗ Exiting...
pause
endlocal
exit /b 1
