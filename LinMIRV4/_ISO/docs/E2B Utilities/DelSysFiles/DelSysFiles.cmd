@echo off
:: SteveSi  (c)2014  www.rmprepusb.com   www.easy2boot.com
cls
color 1f
echo.
echo DELETE SYSTEM FILES AND FOLDERS FROM A DRIVE
echo ============================================
echo.
echo THIS COMMAND: %0 %1
echo.
echo USAGE: %0 (DRIVELETTER:)
echo.
if /i "%~d1"=="C:" echo BAD PARAMETER - DRIVE C: NOT ALLOWED! & pause & goto :eof
if not exist %~dpnx1nul echo Please use a DRIVE VOLUME LETTER not a file! & pause & goto :eof
if not exist "%~d1\System Volume Information"  echo "System Volume information" does not exist on %~d1 & pause
echo.
echo Before running this, install TakeOwnership .reg fragment and Right-click - TakeOwnership on the file/folder
echo.
echo See https://www.raymond.cc/blog/about-recycler-and-system-volume-information-folder-in-xp-and-vista/
echo.
echo.
echo STATUS
echo ======
call :show %1
echo.
echo.
set ask=
set /p ask=OK to delete these root system files and folders from %~d1 ? (Y/N) : 
if not "%ask%"=="y" goto :eof

echo.
echo Resetting hidden\read-only\system attributes on all files - please wait...
if exist %~1\nul attrib -h -r -s %~d1\*.*
rmdir %~d1\"System Volume information" /S /Q 2> nul && echo dummy > %~d1\"System Volume information"

set FLD=%~d1\$RECYCLE.BIN
if exist %FLD% rmdir %FLD% /S /Q 
set FL=%~d1\hiberfil.sys
if exist %FL% del %FL%
set FL=%~d1\swapfile.sys
if exist %FL% del %FL%
set FL=%~d1\pagefile.sys
if exist %FL% del %FL%
set FL=%~d1\RECYCLER
if exist %FL% del %FL%

:end

echo.
echo RESULT
echo ======
call :show %1
echo.
if "%SVI%_%SVIFILE%"=="1_" color cf
if "%SVI%_%SVIFILE%"=="1_" echo WARNING: SYSTEM VOLUME INFORMATION folder could not be deleted!
if "%SVI%_%SVIFILE%"=="1_" echo Please Right-Click on the folder and run "Take Ownership" and try again!
echo.
echo Finished!

pause

goto :eof

:show
set SVI=
set SVIFILE=
if exist %~d1\hiberfil.sys echo HIBERFIL.SYS EXISTS!
if exist %~d1\swapfile.sys echo SWAPFILE.SYS EXISTS!
if exist %~d1\pagefile.sys echo PAGEFILE.SYS EXISTS!
if exist %~d1\RECYCLER     echo RECYCLER folder EXISTS!
if exist %~d1\$RECYCLE.BIN echo $RECYCLE.BIN folder EXISTS!
if exist "%~d1\System Volume Information" set SVI=1
if "%SVI%"=="1" find "dummy" "%~d1\System Volume Information" > nul 2> nul && set SVIFILE=YES
if "%SVI%_%SVIFILE%"=="1_YES" echo dummy SYSTEM VOLUME INFORMATION file EXISTS!
if "%SVI%_%SVIFILE%"=="1_" echo SYSTEM VOLUME INFORMATION folder EXISTS!
goto :eof
