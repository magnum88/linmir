@pushd "%~dp0"
@7z.exe x -o"%TEMP%\HBCD" -y Files\Tools.7z RegShot.exe
@start "" /D"%TEMP%\HBCD" "RegShot.exe"