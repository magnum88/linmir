
@echo off
cls
title MOVE_IMGPTN v1.01
call :checkperms
if "%ADMIN%"=="FAIL" goto :EOF

pushd "%~dp0"
color 1f
set FNAME=%~dpn1
set F1=%~dpnx1
set NAME=%~n1
set NAMEX=%~nx1
echo.
if "%~1"=="" echo USAGE: Drag-and-drop a .imgPTN file onto this file & echo. & pause & goto :EOF
setlocal EnableDelayedExpansion
set COUNT=0

::cls
echo.
echo RE-ORDER .IMGPTN FILE
echo =====================
echo.
call :check_Permissions
if "%ADMIN%"=="FAIL" goto :EOF
echo.
echo %F1%
echo %FNAME%
echo.
echo %F1% should be before %FNAME%
echo.
echo This script will change the file positions on an NTFS drive
echo e.g. For UEFI-booting %~nx1 needs to be before %~n1
echo.
set ERR=
if not exist "%F1%" echo ERROR: %F1% DOES NOT EXIST! && set ERR=1&& color 4f
if not exist "%FNAME%" echo ERROR: %FNAME% DOES NOT EXIST! && set ERR=1&& color 4f
if "%F1%"=="%FNAME%" echo ERROR: NO FILE EXTENSION - PLEASE SPECIFY A TYPE .IMGPTN FILE (e.g. FRED.imgPTNLBAa23) && set ERR=1&& color 4f
if "%ERR%"=="1" pause && goto :EOF
set FL=%FNAME%
call :TESTPOS
if %SZ1% LSS 500 (color 4f & echo ERROR: %F1% TOO SMALL! && pause && goto :EOF)
if %SZL% LSS 500 (color 4f & echo ERROR: %FL% TOO SMALL! && pause && goto :EOF)
if "%RESULT%"=="PASS" goto :ALLOK

pause

echo Moving %FNAME% - please wait...
FOR /L %%G IN (1,1,200) DO if "!RESULT!"=="FAIL" call :LOOP
if "%RESULT%"=="PASS" goto :ALLOK

:: Copy files again to get them closer?
echo MOVING BOTH FILES...
copy "%F1%" "%F1%rtmp"
copy "%FNAME%" "%FNAME%rtmp"
if exist "%FNAME%rtmp" del "%FNAME%"
if exist "%F1%rtmp" del "%F1%"
if exist "%FNAME%rtmp" ren "%FNAME%rtmp" "%NAME%"
if exist "%F1%rtmp" ren "%F1%rtmp" "%NAMEX%"
:: try again
FOR /L %%G IN (1,1,200) DO if "!RESULT!"=="FAIL" call :LOOP

:ALLOK
set ERR=
set CONT1=
FOR /F "skip=1 tokens=3 delims= " %%G IN ('"getfileextents.exe "%F1%""') DO if not defined CONT1 set "CONT1=0x%%G"
set CONTL=
FOR /F "skip=1 tokens=3 delims= " %%G IN ('"getfileextents.exe "%FNAME%""') DO if not defined CONTL set "CONTL=0x%%G"
if defined CONT1 echo WARNING: %F1% IS NOT CONTIGUOUS! && set ERR=1&& color 4f
if defined CONTL echo WARNING: %FNAME% IS NOT CONTIGUOUS!  && set ERR=1&& color 4f

echo FINISHED
if "%RESULT%"=="FAIL" echo ERROR: COULD NOT MOVE FILE - PLEASE TRY AGAIN OR DELETE SOME FILES FROM THE DRIVE && color 4f
if "%RESULT%_%ERR%"=="PASS_" echo SUCCESS! - FILE POSITIONS ARE OK  && color 2f
pause
goto :EOF

:CHECK




:LOOP
set /A COUNT=%COUNT% + 1
call :TESTPOS
if "%RESULT%"=="PASS" goto :EOF
copy "%FNAME%" "%FNAME%zzz" > nul
if exist "%FNAME%zzz" del "%FNAME%"
if exist "%FNAME%zzz" ren "%FNAME%zzz" "%NAME%"
goto :EOF



:TESTPOS
set SZ1=0
set SZL=0
FOR /F "tokens=5 delims= " %%G IN ('"getfileextents.exe "%F1%""') DO set SZ1=0x%%G
FOR /F "tokens=5 delims= " %%G IN ('"getfileextents.exe "%FL%""') DO set SZL=0x%%G
echo FILESTART=%SZL% %FL%   FILESTART=%SZ1% %F1%      
if %SZ1% GTR %SZL% echo %FL% is before %F1%
if %SZL% GTR %SZ1% echo %F1% is before %FL% - OK
if "%LASTL%"=="%SZL%" echo FILE POSITION %FL% UNCHANGED!
::if "%LAST1%"=="%SZ1%" echo WARNING: FILE POSITION %F1% UNCHANGED!
set LAST1=%SZ1%
set LASTL=%SZL%
set RESULT=FAIL
if %SZL% GTR %SZ1% set RESULT=PASS
goto :EOF

:check_Permissions
   :: net session >nul 2>&1
   :: sfc 2>&1 | find /i "/SCANNOW"
    setlocal enabledelayedexpansion
    fsutil dirty query %systemdrive% >nul
    if not errorLevel 1 (
        echo Administrative permissions confirmed.
    ) else (
        echo Sorry - you need to run as Administrator [use right-click - Run as administrator].
		echo.
		echo If you ran as Administrator, please check your PATH environment variable includes the Windows\system32 folder.
		echo.
		echo PATH VARIABLE = "!PATH!"
	echo.
	color cf
	pause
	Set ADMIN=FAIL
    )
	endlocal
goto :eof

:checkperms
set randname=%random%%random%%random%%random%%random%
md %windir%\%randname% 2>nul
if %errorlevel%==0 (echo Administrative permissions confirmed.
goto end)
if %errorlevel%==1 (
    echo Sorry - you need to run as Administrator [use right-click - Run as administrator].
	echo.
	color cf
	pause
	Set ADMIN=FAIL
	goto end)
goto checkperms
:end
rd %windir%\%randname% 2>nul
goto :eof

