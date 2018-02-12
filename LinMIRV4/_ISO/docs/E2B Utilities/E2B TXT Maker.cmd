@echo off
color 1f
TITLE %~n0
:: set cmd shell window size
mode con: cols=120 lines=60
echo E2B .txt File Maker v1.2
echo ========================
echo.
echo.
if "%~n1"=="" echo Usage: Please Drag and Drop a payload file onto this file to make a .txt file. && echo. && pause && goto :EOF

#Setlocal EnableDelayedExpansion

set FILE="%~dpn1.txt"
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
if "%MTEXT%"=="" goto :EOF

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

if "%TEST64%"=="64" set "LINE=iftitle [checkrange 2,3 is64bit] %MTEXT%\n%HTEXT%"
if "%TEST64%"=="32" set "LINE=iftitle [checkrange 0,1 is64bit] %MTEXT%\n%HTEXT%"
if "%TEST64%"==""   set "LINE=title %MTEXT%\n%HTEXT%"

echo.
echo.
echo.
echo SAVE THE .TXT FILE?
echo ===================
echo.
echo %FILE% will contain the line:
echo.
echo.
echo ----------------------------------------------------------------------------------
echo %LINE%
echo ----------------------------------------------------------------------------------
echo.
echo.
set ask=
echo.
set /p ask=Save .txt file ([Y]/N) : 

if /i "%ask%"=="N" goto :EOF
if "%ask%"=="" goto :SS
if /i not  "%ask%"=="Y" goto :EOF


:SS
if exist %FILE% del %FILE%
echo %LINE% > %FILE%

call "%~dp0Convert Unicode file to UTF8\UNICODEToUTF8.cmd" %FILE%

