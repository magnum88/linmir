@echo off
pushd %cd%
del message
DIR %~dp0files /A-D /B /ON > %~dp0cpio_contents.txt
CD %~dp0files
%~dp0cpio\cpio.exe -ov < %~dp0cpio_contents.txt > %~dp0message
DEL %~dp0cpio_contents.txt
cd ..
dir message
if not exist message (echo ERROR: message file not created) & pause
