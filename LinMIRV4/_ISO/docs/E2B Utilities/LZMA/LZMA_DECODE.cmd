@echo off

color 9f
if @%1==@ goto :USAGE
pushd %~dp0
if not exist lzma.exe echo CANNOT FIND lzma.exe at %~dp0 & pause & goto :EOF

:loop

echo FILE=%1
echo.

REM Check if file is encrypted
lzma.exe d -so "%~1" > nul 2>&1
if errorlevel 1 echo ERROR: %1 is not compressed & pause & goto :EOF

::if exist "%~1.comp set /P ask=BACKUP "%~1.COMP is present - overwrite it (Y/N=abort)? 
::if exist "%~1.comp if /i "%ask%"=="Y" del "%~1.comp > nul
::if exist "%~1.comp goto :EOF

lzma.exe d "%~1" "%~1.uncomp" 2>nul
if errorlevel 1 echo ERROR: %1 cannot be decompressed & pause & goto :EOF

if exist "%~1.comp" del "%~1.comp" > nul
ren "%~1" "%~nx1.comp"
ren "%~1.uncomp" "%~nx1"
echo %1 is now DECOMPRESSED
if "%ask1%"=="" set /P ask1=Delete .comp backup file(s) (Y/[N])? 
if /i "%ask1%"=="Y" del "%~1.comp
::pause
shift
if not "%~1"=="" goto :loop
goto :EOF

:USAGE
echo DECOMPRESS AN LZMA FILE (or FILES)
echo.
echo USAGE: %0  fred.txt menu.txt J:\_ISO\MyE2B.cfg
echo.
echo Or select files in Windows Explorer and drag and drop onto %0
echo.
pause
pause
