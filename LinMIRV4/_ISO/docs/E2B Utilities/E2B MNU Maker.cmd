@echo off
color 1f
TITLE %~n0
:: set cmd shell window size
mode con: cols=120 lines=60
echo E2B .mnu File Maker
echo ===================
echo.
echo.
if "%~n1"=="" echo Usage: Please Drag and Drop a payload file onto this file to make a .mnu file. && echo. && pause && goto :EOF

set FILE="%~dpn1.mnu"
echo File = %FILE%
echo.
echo ENTER MENU TEXT
echo ===============
echo.
echo Hotkey tip: Type ^^^^ where one ^^ is required
echo.

echo Examples:
echo             Ubuntu 32-bit v1.2.1
echo             ^^^^Ctrl+U Ubuntu [Ctrl+U]    (sets hotkey of Ctrl+U)
echo             ^^^^U Ubuntu [U]              (sets hotkey of U)
echo.
echo.
set /p MTEXT=Menu text : 

echo.
echo.
echo.
echo ENTER HELP TEXT
echo ===============
echo.
echo Examples:
echo             Run Ubuntu from an ISO
echo             Run Ubuntu from an ISO.\n Select the 2nd menu entry\n to install Ubuntu.
echo.
set /p HTEXT=Help text : 

echo.
echo.
echo CPU TYPE TEST
echo =============
echo.
echo 64 = only show menu if 64-bit CPU
echo 32 = only show menu if 32-bit CPU
echo ENTER (or anything else) = always show menu
echo.
set /p TEST64=Display menu only if 32-bit or 64-bit (32, 64 or [Both])? :
if not "%TEST64%"=="64" if not "%TEST64%"=="32" set TEST64=

if "%TEST64%"=="64" set "LINE=iftitle [checkrange 2,3 is64bit ^&^& if exist $HOME$/%~nx1] %MTEXT%\n%HTEXT%"
if "%TEST64%"=="32" set "LINE=iftitle [checkrange 0,1 is64bit ^&^& if exist $HOME$/%~nx1] %MTEXT%\n%HTEXT%"
if "%TEST64%"==""   set "LINE=iftitle [if exist $HOME$/%~nx1] %MTEXT%\n%HTEXT%"


echo.
echo.
echo.
echo SAVE THE .TXT FILE?
echo ===================
echo.
echo %FILE% will contain the lines:
echo.
echo.
echo ----------------------------------------------------------------------------------
echo %LINE%
echo /%%grub%%/QRUN.g4b force%~x1 $HOME$/%~nx1
echo errorcheck off
echo boot
echo errorcheck on
echo configfile (md)0x3000+0x50
echo ----------------------------------------------------------------------------------
echo.


echo.
echo.
set ask=
echo Press ENTER or Y to confirm...
echo.
set /p ask=OK to write .mnu file ([Y]/N) : 

if /i "%ask%"=="N" goto :EOF
if "%ask%"=="" goto :SS
if /i not  "%ask%"=="Y" goto :EOF


:SS
if exist %FILE% del %FILE%
echo %LINE% > %FILE%
echo /%%grub%%/QRUN.g4b force%~x1 $HOME$/%~nx1 >> %FILE%
echo errorcheck off >> %FILE%
echo boot >> %FILE%
echo errorcheck on >> %FILE%
echo configfile (md)0x3000+0x50 >> %FILE%

call "%~dp0Convert Unicode file to UTF8\UNICODEToUTF8.cmd" %FILE%




