@echo off
TITLE %~n0 v1.1
:: set cmd shell window size
mode con: cols=60 lines=20
color 1f
echo.

if not exist %~d0\_ISO\docs\WINCONTIG\MAKE_ROOT_FOLDER_CONTIGUOUS.cmd echo ERROR: Please run this from the drive that you want to make contiguous! & pause & exit
call %~d0\_ISO\docs\WINCONTIG\MAKE_ROOT_FOLDER_CONTIGUOUS.cmd
if not exist %~d0\_ISO\docs\WINCONTIG\MAKE_ISO_FOLDER_CONTIGUOUS.cmd echo ERROR: Please run this from the drive that you want to make contiguous! & pause & exit
%~d0\_ISO\docs\WINCONTIG\MAKE_ISO_FOLDER_CONTIGUOUS.cmd

