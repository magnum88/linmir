@echo off
if "%~1"=="" echo Please drag-and-drop a text file onto this file to convert it to UTF-8 && pause && exit
set SOURCE="%~1"
pushd "%~dp0"
echo Converting %1 to UTF-8...
cscript /nologo Uni2UTF8.vbs %SOURCE% "utf8.tmp"
copy "utf8.tmp" %1 > nul
if exist utf8.tmp del utf8.tmp
notepad %SOURCE%
popd
