TITLE LOADISOPE.CMD
color 1f
@echo off
cls
echo LOADISOPE.CMD running...
set USBDRIVE=%~d0
@echo USB DRIVE AT DRIVE %USBDRIVE%
cd /d %USBDRIVE%\

:: check if we have already run LOADISO once (may be multiple drives with E2B files)!
call %USBDRIVE%\_ISO\E2B\firadisk\ISONAME.cmd
if "%MYISO%"=="DONE" exit
if "%MYISO%"=="" exit
if exist %USBDRIVE%\WINHELPER.USB exit

TITLE LOADING ISO USING IMDISK
call \_ISO\E2B\firadisk\IMDISK_installpe.cmd
call \_ISO\E2B\firadisk\IMDISK_instiso.cmd
FOR /L %%A IN (0,1,5000) DO ECHO NOTHING > nul
if exist "%POSTCMD%" call "%POSTCMD%"
exit

