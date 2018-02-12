@echo off
REM Version 2.2 2016-03-25

title %~n0 %FILE% v2.2

REM set file path here
set FNAME=MyE2B.cfg
set PPATH=%~d0\_ISO

:loop
set FF=%~1

if not "%FF%"=="" (
For %%A in ("%FF%") do (
    Set PPATH=%%~dpA
    Set FNAME=%%~nxA
)
)

if "%PPATH:~-1,1%"=="\" set PPATH=%PPATH:~0,-1%
set DPATH=%PPATH%
if "%DPATH:~-1,1%"==":" set DPATH=%DPATH%\
set MEPATH=%~dp0
if "%MEPATH:~-1,1%"==":" set MEPATH=%DPATH%\

if not exist "%MEPATH%lzma.exe" echo ERROR: LZMA.EXE NOT FOUND IN THIS FOLDER! && pause && goto :EOF

REM Specify type of protection
REM Use %username% to lock the file to this user + owner
REM set GROUP=/g %username%:f
REM Use Everyone:n to block all users (only Owner can access)
set GROUP=/e /p everyone:n

set FILE=%PPATH%\%FNAME%
title %~n0 %FILE% v2.2
color 1f
cls

if not exist "%FILE%" echo ERROR: File %FILE% does not exist && pause && goto :EOF
if not exist %~d0\_ISO\e2b\grub\menu.lst (
color 4f
echo ERROR: %~d0 is not an E2B drive! 
goto :EOF)

REM If NTFS may be protected
type "%FILE%" > nul 2>&1 || set STATUS=PROTECTED
type "%FILE%" > nul 2>&1 && set STATUS=unprotected

echo.
if "%~1"=="" echo Usage: %~n0 [FILE]  or drag-and-drop file onto %~nx0
echo.
echo Protect or UnProtect %FILE%
echo.
echo   ACTION
echo   ======
echo   Set SYSTEM + HIDDEN attributes
echo   Set File Permissions (NTFS only)
echo   Encrypts the file (LZMA)
echo.
echo   P = Protect, LZMA Compress and Hide
echo   U = Unprotect, Uncompress and Unhide
echo   S = Status
echo.
echo ============ FILE DETAILS ============
echo:
echo ATTRIBUTES:
attrib "%FILE%"
echo:
echo OWNER:
:: list if not hidden
if exist qdir.tmp del qdir.tmp
(dir    %FILE% /Q 2> nul | find /i "%FNAME%" 2> nul)>qdir.tmp
for /F "delims=" %%i in (qdir.tmp) do set A=%%i
:: list if hidden
(dir    %FILE% /Q /ah 2> nul | find /i "%FNAME%" 2> nul)>qdir.tmp
for /F "delims=" %%i in (qdir.tmp) do set A=%%i
:: list if system
(dir    %FILE% /Q /as 2> nul | find /i "%FNAME%" 2> nul)>qdir.tmp
for /F "delims=" %%i in (qdir.tmp) do set A=%%i
if exist qdir.tmp del qdir.tmp
echo %A%
set A=

echo:
"%MEPATH%lzma.exe" d -so "%FILE%" > nul 2>&1
if not errorlevel 1 (echo COMPRESSED\ENCRYPTED) && echo:
echo PERMISSIONS:
cacls "%FILE%"
echo:
echo %STATUS% (protection only works on NTFS drives)
echo:
echo ======================================
echo:
echo:


:loop
if not "%CMD%"=="" (set ask=%CMD%&& goto :DoCMD)
set ask=
set /p ask=Protect and encrypt, UnProtect, show Status (P/U/S) : 
echo.
set CMD=%ask%
:DoCMD
if /i "%ask%"=="P" call :Protect
if /i "%ask%"=="U" call :UnProtect
if /i "%ask%"=="S" call :Status
if /i "%ask%"=="T" call :TakeOwn
shift
if not "%~1"=="" goto :loop
goto :EOF



:Status
cls
echo.
echo  DIR
echo  ===
dir "%FILE%" /ah /q /n
echo.
echo ATTRIBUTES
echo ==========
attrib "%FILE%"
echo.
echo CACLS
echo =====
cacls "%FILE%"
echo.
echo.
type "%FILE%" > nul 2>&1 || echo PROTECTED
type "%FILE%" > nul 2>&1 && echo unprotected

"%MEPATH%lzma.exe" d -so "%FILE%" > nul 2>&1
if not errorlevel 1 (echo COMPRESSED\ENCRYPTED)

echo.
echo Show file contents (type %FILE%)...
pause
type "%FILE%"
echo.
echo.
pause
goto :EOF


:Protect

if "%STATUS%"=="PROTECTED" echo. && echo FILE IS ALREADY PROTECTED! && pause && goto :EOF

if exist "%FILE%" (
pushd "%DPATH%"
attrib -s -h "%FILE%" > nul
REM Check if file is encrypted
"%MEPATH%lzma.exe" d -so "%FILE%" > nul 2>&1
if not errorlevel 1 echo WARNING: %FILE% is already compressed & pause & popd & goto :EOF
if exist "%FILE%lzma" del "%FILE%lzma"
"%MEPATH%lzma.exe" e "%FNAME%" "%FNAME%lzma" 2> nul
popd
if exist "%FILE%lzma" del "%FILE%"
if exist "%FILE%lzma" ren "%FILE%lzma" "%FNAME%"
attrib +h +s "%FILE%" > nul
REM cacls "%FILE%" /e /p everyone:n > nul
cacls "%FILE%" %GROUP% > nul
)
::attrib "%FILE%"
type "%FILE%" > nul 2>&1 || echo PROTECTED
type "%FILE%" > nul 2>&1 && echo unprotected
"%MEPATH%lzma.exe" d -so "%FILE%" > nul 2>&1
if not errorlevel 1 (echo COMPRESSED\ENCRYPTED)
echo OK
echo.
pause
goto :EOF


:TakeOwn
icacls "%FILE%" /reset

:Unprotect
::if not "%STATUS%"=="PROTECTED" goto :EOF
pushd "%DPATH%"
cacls "%FILE%" /e /p everyone:f > nul
REM if not XP use Reset
icacls "%FILE%" /reset > nul
attrib -s -h "%FILE%"
"%MEPATH%lzma.exe" d -so "%FILE%" > nul 2>&1
if errorlevel 1 echo WARNING: %FILE% is not compressed & pause & popd & goto :EOF
if exist "%FILE%dec" del "%FILE%dec"
"%MEPATH%lzma.exe" d "%FNAME%" "%FILE%dec" 2> nul
popd
if exist "%FILE%dec" del "%FILE%" 
if exist "%FILE%dec" ren "%FILE%dec" "%FNAME%"

type "%FILE%" > nul 2>&1 || echo PROTECTED
type "%FILE%" > nul 2>&1 && echo unprotected

"%MEPATH%lzma.exe" d -so "%FILE%" > nul 2>&1
if not errorlevel 1 (echo COMPRESSED\ENCRYPTED) ELSE (echo not compressed\encrypted)
echo OK
REM type "%FILE%"
echo.
pause
goto :EOF
