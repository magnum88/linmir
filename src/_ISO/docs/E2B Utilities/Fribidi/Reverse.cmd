pushd "%~dp0"
fribidi.exe -c, --charset UTF-8 --nopad --nobreak --clean %1 > "%~dpn1rev%~x1"
