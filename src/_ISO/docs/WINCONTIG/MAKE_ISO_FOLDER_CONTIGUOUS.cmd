@echo off
set WC=

TITLE %~n0
:: set cmd shell window size
mode con: cols=120 lines=10
::if not exist %~d0\_ISO\e2b\grub\menu.lst echo ERROR: Please run %~nx0 from the E2B drive. & color 4f & pause & goto :EOF

if exist %~d0\_ISO\docs\WINCONTIG\WinContig64.exe set WC=%~d0\_ISO\docs\WINCONTIG\WinContig64.exe
if exist %~d0\_ISO\docs\WINCONTIG\WinContig.exe set WC=%~d0\_ISO\docs\WINCONTIG\WinContig.exe

if "%WC%"=="" echo ERROR: Cannot find WinContig on this drive! & pause & goto :EOF
pushd "%~dp0%"
echo.
echo Making all files under %~d0\_ISO contiguous - please wait...
echo %WC% "%~d0\_ISO\" /DEFRAG /CLOSEIFOK /CLEAN:0 /LANG:Auto /NOINI /QUICK /NOTOPATEND
%WC% "%~d0\_ISO\" /DEFRAG /CLOSEIFOK  /CLEAN:0 /LANG:Auto /NOINI /QUICK /NOTOPATEND
