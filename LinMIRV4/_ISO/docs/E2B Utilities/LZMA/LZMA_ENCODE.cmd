@echo off
color 9f
echo.
echo.
if @%1==@ goto :USAGE
pushd %~dp0
if not exist lzma.exe echo CANNOT FIND lzma.exe at %~dp0 & pause & goto :EOF

:loop

echo FILE=%1
echo.

REM Check if file is encrypted
lzma.exe d -so "%~1" > nul 2>&1
if not errorlevel 1 echo ERROR: %1 is already compressed & pause & goto :EOF

::if exist %1.orig set /P ask=The backup file %1.ORIG is already present - delete it (Y/N=abort)
::if exist %1.orig if /i "%ask%"=="Y" del %1.orig > nul
::if exist %1.orig goto :EOF

lzma.exe e "%~1" "%~1.lzma" 2>nul
if errorlevel 1 echo ERROR: %1 cannot be compressed & pause & goto :EOF

if exist "%~1.orig" del "%~1.orig" > nul
ren "%~1" "%~nx1.orig"
ren "%~1.lzma" "%~nx1"
echo %1 is now COMPRESSED
echo.
echo Backup of original made as .orig
echo.
if "%ask1%"=="" set /P ask1=Delete .orig backup file(s) (Y/[N])? 
if /i "%ask1%"=="Y" del %1.orig
::pause
shift
if not "%~1"=="" goto :loop
goto :EOF

:USAGE
echo COMPRESS A FILE (or FILES) to LZMA
echo.
echo USAGE: %0  fred.txt menu.txt J:\_ISO\MyE2B.cfg
echo.
echo Or select files in Windows Explorer and drag and drop onto %0
echo.
pause
