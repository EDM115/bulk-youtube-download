@echo off
setlocal EnableExtensions DisableDelayedExpansion

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

rem Delayed expansion is off here so "!" and "^" in links are kept
for /f "usebackq delims=" %%A in ("links.txt") do (
  set "line=%%A"
  call :parse_line
)

if %count% EQU 0 (
  echo ❌ No URLs found in links.txt !
  goto :fatal
)

echo 🎯 %count% links found !
echo.

set DEFAULT_ARGS=-f "bestvideo+bestaudio/best" --embed-subs --embed-thumbnail --embed-metadata --embed-chapters --yes-playlist --windows-filenames --progress --console-title --concurrent-fragments 4 --ignore-errors -P "downloads" -o "%%(playlist_title|.)s/%%(playlist_index&{} - |)s%%(title)s [%%(id)s].%%(ext)s"

setlocal EnableDelayedExpansion
for /l %%i in (1,1,%count%) do (
  echo 🔗 Processing link %%i/%count%
  set "current_url=!url[%%i]!"
  echo ⏬ Downloading !current_url! ...
  echo.

  yt-dlp %DEFAULT_ARGS% %* -- "!current_url!"
  echo.
)
endlocal

echo 🎉 Download done !
echo 🗃️ Your files are in the "downloads" folder
echo.
echo 🫂 Follow me on GitHub :
echo    https://github.com/EDM115
echo.
pause
endlocal
exit /b 0

:parse_line
setlocal EnableDelayedExpansion

rem Remove indentation/whitespace, quotes, and trailing commas
set "line=!line: =!"
set "line=!line:"=!"
set "line=!line:,=!"

rem Skip empty/brackets
if "!line!"=="" goto :parse_line_skip
if "!line!"=="[" goto :parse_line_skip
if "!line!"=="]" goto :parse_line_skip

rem Only accept http(s) links
if /i not "!line:~0,7!"=="http://" if /i not "!line:~0,8!"=="https://" (
  echo ⚠️ Skipping invalid link : !line!
  goto :parse_line_skip
)

set /a count+=1
for /f "tokens=1* delims=|" %%C in ("!count!|!line!") do endlocal & set "count=%%C" & set "url[%%C]=%%D"
exit /b 0

:parse_line_skip
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
