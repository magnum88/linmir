@Echo off
cls
TITLE %~n0
:: set cmd shell window size
mode con: cols=180 lines=10
if /i "%~d0"=="C:" echo CANNOT BE RUN FROM C: DRIVE! PLEASE RUN FROM USB DRIVE. & pause & goto :EOF

::call :check_Permissions
call :checkperms
if "%ADMIN%"=="FAIL" goto :EOF

pushd %~dp0
cd .\QEMU
set MEM=500

cscript /NoLogo GetDno.vbs %~d0 > GetDrv.cmd
call GetDrv.cmd
if exist GetDrv.cmd del GetDrv.cmd


echo DRIVE NUMBER=%DN% (%~d0)
echo MEMORY SIZE=%MEM%

REM Flush cache (esp. if NTFS filesystem still writing cache to slow disks)
sync 2> nul

set qemu=qemu.exe

SET CMD=%qemu% -L . -name "32-bit Emulation RAM %MEM%MB NO HDD [Release: Alt+LCtrl]" -boot c -m %MEM% -drive file=\\.\PhysicalDrive%DN%,if=ide,index=0,media=disk,format=raw


echo Sending command %CMD% to shell...
echo.
echo THIS CONSOLE WINDOW WILL REMAIN OPEN UNTIL YOU QUIT QEMU
echo.

%CMD% 2> nul

if errorlevel 1 echo FAILED!
if errorlevel 1 PAUSE
popd

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


