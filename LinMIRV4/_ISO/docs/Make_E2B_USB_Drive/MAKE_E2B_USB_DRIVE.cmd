@if not "%DEBUG%"=="1" @echo off
REM Version 4.2 2015-03-12 - run from .\_ISO\docs\Make_E2B_USB_Drive folder (Uses LockDisMount), check for grubinst_new and new version of grubinst with silent-boot option, remove touchdrv.exe command, check 4K drives
REM Version 4.3 2015-04-07 - change method of detection of admin privileges
REM Version 4.4 2015-05-03 - Use RMPartUSB and grubinst in same folder if present.
REM version 4.5 2015-06-03 - copy bootmgr to NTBOOT.MOD folder if possible
REM version 4.6 2015-09-28 - default NTFS, add UEFI help text
REM version 4.7 2016-01-18 - bugfix for removable drive detection
REM version 4.8 2016-02-04 - ignore errors on xcopy (in case \autorun.inf is WP), tidy up .tmp file
REM version 4.9 2016-02-12 - if XP don't use wmic
REM version 4.10 2016-03-22 - versions displayed using wget.exe
REM version 4.11 2016-05-24 - new admin permissions test
REM version 4.12 2016-07-08 - only copy compatible bootmgr
REM version 4.13 2016-07-12 - bugfix for bootmgr copy causing exit if no \bootmgr found
REM version 4.14 2016-08-15 - extra bootmgr versions added
REM version 4.15 2016-10-10 - check latest version using LatestE2B.txt file
REM version 4.16 2016-10-29 - help on where to put files added
REM version 4.17 2017-01-12 - allow user to run this from a source E2B USB drive, check target drive <> source drive
REM version 4.18 2017-01-13 - bugfix for bootmgr overwrite when cloning E2B driive
REM version 4.19 2017-01-30 - modify to work with Make_E2B.exe, test for larger than 137GB

cls
TITLE %~n0 v4.19
:: set cmd shell window size
mode con: cols=130 lines=60
color 1f
echo Make an Easy2Boot USB drive (using RMPartUSB)
echo =============================================
echo.
set SRCDL=%~d0
::set str=%~dp0
::set str=%str:~1,6%
::if /i "%str%"==":\_ISO" echo ERROR: This drive is an E2B drive! Please run from a folder on your hard disk. & color 4f & pause & goto :EOF
::set str=

call :checkperms
::call :check_Permissions
if "%ADMIN%"=="FAIL" goto :EOF

pushd "%~dp0"

if "%1"=="AUTO" (set AUTODRV=%2) & (set AUTOLANG=%3) & (set AUTOKBD=%4) & (set AUTOSIZE=%5)

::echo AUTODRV="%AUTODRV%" AUTOLANG="%AUTOLANG%" AUTOKBD="%AUTOKBD%"
::pause

echo.%~pn0 | find /I "Desktop\_ISO\docs\Make_e2b">nul && (set ERR=0) || (set ERR=1)
if "%ERR%"=="0" echo ERROR: Please extract the Easy2Boot files to an EMPTY FOLDER - not the Desktop! & color 4f & pause & goto :EOF
set ERR=

set str=%~dp0
set str=%STR:~-2,2%
if "%str%"==":\" echo ERROR: Source is a drive! Please run %~nx0 from the download folder & color 4f & pause & goto :EOF
set str=

if not exist ..\..\..\menu.lst echo ERROR: Cannot find Easy2Boot files in %~dp0 & color 4f & pause & exit
if not exist ..\..\e2b\grub\menu.lst echo ERROR: Cannot find Easy2Boot files in %~dp0 & color 4f & pause & exit
if not exist ..\..\e2b\grub\E2B_GRUB.txt echo ERROR: Cannot find Easy2Boot files in %~dp0 & color 4f & pause & exit

REM change to our working folder
set WF=%~dp0
if exist "%WF%\rmpartusb.exe" goto :gotwf
set WF=%ProgramFiles(x86)%\RMPrepUSB
if exist "%WF%\rmpartusb.exe" goto :gotwf
set WF=%ProgramFiles%\RMPrepUSB
if exist "%WF%\rmpartusb.exe" goto :gotwf


:NF
echo.
echo Sorry - I cannot find RMPartUSB!
echo Please install RMPrepUSB to your default Program Files folder
echo OR
echo Specify the folder where RMPartUSB.exe is located.
echo.
set /p WF=RMPartUSB folder is at (e.g. D:\temp\RMPrepUSB) ? : 
if exist "%WF%\rmpartusb.exe" goto :gotwf
set /p ask=Sorry - couldn't find it - press R to Retry or any other key to exit (Retry\Abort) : 
if /i "%ask%"=="R" goto :NF
exit
:gotwf

:: Check for more recent version
if exist LatestE2B.txt del LatestE2B.txt
echo.
echo Getting current release version from easy2boot.com...
wget.exe -q -t 1 -T 5 http://files.easy2boot.com/200001618-08ab00a9dd/LatestE2B.txt -O LatestE2B.txt > nul
if errorlevel 1 goto :wget_end
if not exist LatestE2B.txt goto :wget_end
find LatestE2B.txt "set LVER=" > nul || goto :wget_end
set LVER=
set VER=
set LDATE=
setlocal enableextensions enabledelayedexpansion
FOR /F "tokens=2 delims=^=" %%K IN (latestE2B.txt) DO (
    if "!LVER!"=="" (SET LVER=%%K) else if "!LDATE!"=="" SET LDATE=%%K
)
setlocal disabledelayedexpansion
if exist LatestE2B.txt del LatestE2B.txt

:: get current version of E2B
if exist %temp%\mdtemp.cmd del %temp%\mdtemp.cmd > nul
find "set VER=" "%~dp0..\..\e2b\grub\E2B.cfg" > %temp%\mdtemp.cmd
call %temp%\mdtemp.cmd > nul 2> nul
echo.
if not "%VER%"==""  echo INFORMATION: E2B version = %VER%
if not "%LVER%"=="" echo              Latest E2B  = v%LVER%  %LDATE%  (www.easy2boot.com/download)
:wget_end
echo.

set ALL=
set A=
pushd "%WF%"
RMPARTUSB FIND > %temp%\mdtemp.cmd
call %temp%\mdtemp.cmd > nul
if exist %temp%\mdtemp.cmd del %temp%\mdtemp.cmd > nul
if not "%DRIVESIZE%"=="0" goto :skipa
echo.
echo.
set /P A=WARNING: NO USB DRIVES DETECTED - DO YOU WANT TO LIST ALL THE DRIVES (Y/[N]) : 
if /I not "%A%"=="Y" goto :EOF
set ALL=ALLDRIVES
RMPARTUSB FIND %ALL% > %temp%\mdtemp.cmd
call %temp%\mdtemp.cmd 2> nul
if exist %temp%\mdtemp.cmd del %temp%\mdtemp.cmd > nul

:skipa
if "%DRIVESIZE%"=="0" color 4f & echo. & echo NO USB DRIVES FOUND! & pause & exit
echo ERASE AND FORMAT USB DRIVE
echo ==========================
echo.
REM list all USB drives so user can see them and their drive number
RMPARTUSB LIST  %ALL% | find "DRIVE"
echo.
REM Ask user for a drive number

set DD=
if "%AUTODRV%"=="" set /P DD=TARGET USB DRIVE NUMBER (e.g. %DRIVE%) : 
if not "%AUTODRV%"=="" set DD=%AUTODRV%
if "%DD%"=="" echo. & echo Please enter a number! & pause & cls & goto :skipa
set /A DD=%DD%+0
if "%DD%"=="0" echo. & echo Please enter a number above 0! & pause & cls & goto :skipa

:: Check user did not select this drive as the drive to format!
set TGTERR=ERROR: You are trying to format the source drive!
if "%DD%"=="1" if /i "%DRIVE1LETTER%"=="%SRCDL%" cls & echo %TGTERR% & echo. & goto :skipa
if "%DD%"=="2" if /i "%DRIVE2LETTER%"=="%SRCDL%" cls & echo %TGTERR% & echo. & goto :skipa
if "%DD%"=="3" if /i "%DRIVE3LETTER%"=="%SRCDL%" cls & echo %TGTERR% & echo. & goto :skipa
if "%DD%"=="4" if /i "%DRIVE4LETTER%"=="%SRCDL%" cls & echo %TGTERR% & echo. & goto :skipa
if "%DD%"=="5" if /i "%DRIVE5LETTER%"=="%SRCDL%" cls & echo %TGTERR% & echo. & goto :skipa
if "%DD%"=="6" if /i "%DRIVE6LETTER%"=="%SRCDL%" cls & echo %TGTERR% & echo. & goto :skipa
if "%DD%"=="7" if /i "%DRIVE7LETTER%"=="%SRCDL%" cls & echo %TGTERR% & echo. & goto :skipa
if "%DD%"=="8" if /i "%DRIVE8LETTER%"=="%SRCDL%" cls & echo %TGTERR% & echo. & goto :skipa
if "%DD%"=="9" if /i "%DRIVE9LETTER%"=="%SRCDL%" cls & echo %TGTERR% & echo. & goto :skipa
if "%DD%"=="10" if /i "%DRIVE9LETTER%"=="%SRCDL%" cls & echo %TGTERR% & echo. & goto :skipa
if "%DD%"=="11" if /i "%DRIVE10LETTER%"=="%SRCDL%" cls & echo %TGTERR% & echo. & goto :skipa
if "%DD%"=="12" if /i "%DRIVE12LETTER%"=="%SRCDL%" cls & echo %TGTERR% & echo. & goto :skipa
if "%DD%"=="13" if /i "%DRIVE13LETTER%"=="%SRCDL%" cls & echo %TGTERR% & echo. & goto :skipa
if "%DD%"=="14" if /i "%DRIVE14LETTER%"=="%SRCDL%" cls & echo %TGTERR% & echo. & goto :skipa
if "%DD%"=="15" if /i "%DRIVE15LETTER%"=="%SRCDL%" cls & echo %TGTERR% & echo. & goto :skipa
if "%DD%"=="16" if /i "%DRIVE16LETTER%"=="%SRCDL%" cls & echo %TGTERR% & echo. & goto :skipa
if "%DD%"=="17" if /i "%DRIVE17LETTER%"=="%SRCDL%" cls & echo %TGTERR% & echo. & goto :skipa
if "%DD%"=="18" if /i "%DRIVE18LETTER%"=="%SRCDL%" cls & echo %TGTERR% & echo. & goto :skipa
if "%DD%"=="19" if /i "%DRIVE19LETTER%"=="%SRCDL%" cls & echo %TGTERR% & echo. & goto :skipa

cls
echo.
REM execute RMPARTUSB (add SURE if you don't want the user prompt)
RMPARTUSB DRIVE=%DD% GETDRV %ALL% > %temp%\mdtemp.cmd
call %temp%\mdtemp.cmd > nul
if exist %temp%\mdtemp.cmd del %temp%\mdtemp.cmd > nul
if "%USBDRIVESIZE%"=="0" echo ERROR: NOT A USB DRIVE? & color 4f & pause & exit




ver | find " XP " > nul && goto :skp4k
:: check if 4K sector drive
wmic DISKDRIVE get caption, description, Deviceid, bytespersector | find "DRIVE%DD%" > %temp%\DD.tmp
find "4096" %temp%\DD.tmp > nul
if not errorlevel 1 color 4f & echo. & echo. & type %temp%\DD.tmp & echo. & echo SORRY: THIS DRIVE HAS 4K SECTORS AND IS NOT BOOTABLE! & echo. & pause & del %temp%\DD.tmp & goto :EOF
if exist %temp%\DD.tmp del %temp%\DD.tmp
:skp4k

cls
echo.
echo.
RMPARTUSB LIST  %ALL% | find "DRIVE"
echo.
if "%DD%"=="0" echo WARNING: DRIVE 0 IS YOUR SYSTEM DRIVE!!! & pause & exit

if exist r.tmp del r.tmp
ver | find " XP " > nul && goto :skprem

wmic /LOCALE:ms_409 diskdrive get MediaType,deviceid | find "DRIVE%DD%" > r.tmp 2>nul
set DTYPE=UNKNOWN DISK TYPE (may be Fixed or Removable)!
set dt=
find /i "Removable" r.tmp > nul && set DTYPE=REMOVABLE DISK
find /i "hard" r.tmp > nul && set  DTYPE=FIXED DISK (WARNING: must use .imgPTN files or a Helper Flash drive for Windows 7/8/10 INSTALLER ISOs) && set dt=1
find /i "Fixed" r.tmp > nul && set DTYPE=FIXED DISK (WARNING: must use .imgPTN files or a Helper Flash drive for Windows 7/8/10 INSTALLER ISOs) && set dt=1
::type r.tmp
echo INFORMATION: Drive %DD% is a %DTYPE%
echo.
echo.
if exist r.tmp del r.tmp
:: make sure user sees message
if "%dt%"=="1" pause
:skprem





echo WARNING: ALL PARTITIONS ON DRIVE %dd% WILL BE DESTROYED...
echo.
if not "%AUTODRV%"=="" set FMT=NTFS
if not "%AUTODRV%"=="" goto :cc1

set /p ask=Are you sure it is OK to format DRIVE %DD% (Y/N) : 
if /i not "%ask%"=="Y" exit
if "%DD%"=="0" exit	

:lpf
cls
echo.
echo CHOOSE A FILESYSTEM 
echo ===================
echo.
echo N = NTFS  - If you want to boot from large files over 4GB.   ***RECOMMENDED***
echo F = FAT32 - If all payload files are below 4GB in size.    
echo.
echo Note: FAT32 and NTFS both support UEFI-booting. SWITCH_E2B.exe only works on NTFS volumes.
echo.
set ask=
set /p ask=Format as FAT32 or NTFS? (F/[N]) : 
set FMT=NTFS
if /i "%ask%"=="F" set FMT=FAT32& goto :cc1
if "%ask%"=="" goto :cc1
if /i not "%ask%"=="N" goto :lpf
:cc1

:: get drive size
if not "%AUTOSIZE%"=="" goto :skpsz
FOR /F "tokens=*" %%A IN ('RMPARTUSB DRIVE^=%dd% GETDRV %ALL%') DO %%A
:: reduce to 100MB units
set USBDRIVESIZE=%USBDRIVESIZE:~0,-8%
if "%USBDRIVESIZE%"=="" goto :skpsz
:: test for 137.4 GB
if %USBDRIVESIZE% LSS 1374 goto :skpsz
echo.
echo WARNING: USB Drive is larger than 137GB
echo For best compatibility, maximum partition size should be 137GB
set /p ask=Reduce partition size to 137GB ([Y]/N) : 
if /i not "%ask%"=="N" set AUTOSIZE=131000
if not "%AUTOSIZE%"=="" echo Partition 1 size reduced
:skpsz

echo.
echo ERASE AND FORMAT DRIVE %DD% as %FMT%...
RMPARTUSB DRIVE=%dd% CLEAN %ALL% > nul
if errorlevel 1 (color 4f & echo. & echo RMPARTUSB CLEAN COMMAND FAILED OR ABORTED BY USER - IF ERROR TRY AGAIN! & pause & exit)
REM delay to allow Windows to see empty drive
RMPARTUSB DRIVE=%DD% GETDRV %ALL% > nul

if "%AUTOSIZE%"=="" RMPARTUSB DRIVE=%dd% WINPE %FMT% 2PTN %ALL% SURE VOLUME=E2B> nul
if not "%AUTOSIZE%"=="" RMPARTUSB DRIVE=%dd% SIZE=%AUTOSIZE% WINPE %FMT% 2PTN %ALL% SURE VOLUME=E2B> nul

if "%FMT%"=="NTFS" if errorlevel 1 (color 4f & echo NTFS FORMAT FAILED! Format as FAT32 first and ensure Windows has given it a drive letter. & pause & exit)
if errorlevel 1 (color 4f & echo RMPARTUSB COMMAND FAILED! Ensure Windows has given it a drive letter. & pause & exit)
set USBDRIVELETTER=
REM get the drive letter of the newly formatted drive
FOR /F "tokens=*" %%A IN ('RMPARTUSB DRIVE^=%dd% GETDRV %ALL%') DO %%A
If "%USBDRIVELETTER%"=="" (echo FAILED! No drive letter was given by Windows!& pause & exit)
echo Format completed OK (%USBDRIVELETTER%)

popd

if not exist ..\..\..\menu.lst exit
echo.
echo INFORMATION: Some Anti-Virus programs (e.g. Trend Micro AV) may cause this copy phase to fail!
echo.
echo Copying over Easy2Boot files in \     to %USBDRIVELETTER% ...
REM Only copy files in root, no subdirs; System Volume Information & $RECYCLE.BIN case problems with /herky
xcopy /hrky ..\..\..\*.* %USBDRIVELETTER%\*.*  > nul
if errorlevel 1 color 4f & echo ERROR IN COPYING FILES & pause & exit
REM Copy _ISO subdir
echo Copying over Easy2Boot files in \_ISO to %USBDRIVELETTER% - please wait...

xcopy /herky ..\..\..\_ISO\*.* %USBDRIVELETTER%\_ISO\*.*  > nul 

echo.
if errorlevel 1 color 4f & echo ERROR IN COPYING FILES & pause & exit

:: copy correct bootmgr for NTBOOT if present (doesn't seem to work if do it later!)
:: Windows 10 bootmgr gives BCD error so don't use it if possible!
if not exist %USBDRIVELETTER%\_ISO\e2b\grub\DPMS\NTBOOT.MOD\bootmgr call :copybmgr C:\bootmgr
if "%GD%"=="" call :copybmgr %SystemRoot%\Panther\Rollback\bootmgr
if "%GD%"=="" call :copybmgr %SystemRoot%\Boot\PCAT\bootmgr

pushd "%WF%"
if "%dd%"=="0" exit

REM install grub4dos - use new grubinst to install to PBR
echo Installing grub4dos to PBR of %USBDRIVELETTER%...
set GR=grubinst.exe
REM check if silent-boot supported
if exist gr.txt del gr.txt
if exist gr1.txt del gr1.txt
%GR% -h 2> gr.txt
set SILENT=
find "--silent-boot" gr.txt > nul
if not errorlevel 1 set SILENT=--silent-boot
if "%SILENT%"=="" set GR=grubinst_new.exe

if not exist %GR% color 4f & echo ERROR: %GR% not found or is an old version! & pause & exit

REM Dismount the drive, run grubinst, remount the drive
"%~dp0LockDismount.exe" -force %dd% %GR% -t=0 %SILENT% --install-partition=0 (hd%dd%) >> gr1.txt
If errorlevel 1 color 4f & pause & exit


REM also install to MBR
echo.
echo Installing grub4dos to MBR of %USBDRIVELETTER%...
::set GR=grubinst.exe
"%~dp0LockDismount.exe" -force %dd% %GR% -t=0 %SILENT% --skip-mbr-test (hd%dd%) >> gr1.txt
If errorlevel 1 color 4f & pause & exit

if exist gr.txt del gr.txt
if exist gr1.txt del gr1.txt

popd

REM if it is not FAT32 the no point in having EFI folder for UEFI booting
if not "%FMT%"=="FAT32" if exist %USBDRIVELETTER%\EFI\nul rd /s /q %USBDRIVELETTER%\EFI > nul

REM delete this batch file from the USB drive
::echo Deleting %USBDRIVELETTER%\_ISO\docs\%~n0%~x0
::if exist %USBDRIVELETTER%\_ISO\docs\%~n0%~x0 del %USBDRIVELETTER%\_ISO\docs\%~n0%~x0

if exist %USBDRIVELETTER%\UPDATE_E2B_DRIVE.CMD del %USBDRIVELETTER%\UPDATE_E2B_DRIVE.CMD
if exist "%USBDRIVELETTER%\MAKE_E2B_USB_DRIVE (run as admin).cmd" del "%USBDRIVELETTER%\MAKE_E2B_USB_DRIVE (run as admin).cmd"
if exist %USBDRIVELETTER%\E2B_ReadMe.txt del %USBDRIVELETTER%\E2B_ReadMe.txt
if exist "%USBDRIVELETTER%\MAKE_E2B.exe" del "%USBDRIVELETTER%\MAKE_E2B.exe"

REM Make new user MyE2B.cfg file
if not exist %USBDRIVELETTER%\_ISO\MyE2B.cfg call "%~dp0Make_MyE2B.cfg.cmd" %USBDRIVELETTER%

echo.
echo Now add your ISOs and other payload files
echo =========================================
echo.
echo \_ISO\MAINMENU      - copy ISOs here for Main Menu (except Windows Install ISOs)
echo \_ISO\LINUX         - copy linux ISOs here
echo \_ISO\WINDOWS\WIN8  - copy Windows 8  Install ISOs here
echo \_ISO\WINDOWS\WIN10 - copy Windows 10 Install ISOs here
echo.
echo Hirens HBCD ISO     - use .isoHW file extension
echo.
echo For other payloads see www.easy2boot.com - 'List of tested ISOs' page
echo.

echo.
if not exist %USBDRIVELETTER%\_ISO\e2b\grub\DPMS\NTBOOT.MOD\bootmgr echo WARNING: Compatible version of bootmgr for booting .VHD\.WIM files was not found.
echo.
color 2f
echo FINISHED - ALL OK.
echo.
pause
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
md "%windir%\%randname%" 2>nul
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
rd "%windir%\%randname%" 2>nul
goto :eof


:copybmgr
:: %1 has file spec
set GD=
if "%~z1"=="" goto :EOF
if %~z1==389720 set GD=1
if %~z1==398144 set GD=1
if %~z1==398156 set GD=1
if %~z1==398356 set GD=1
if %~z1==400517 set GD=1
if %~z1==403390 set GD=1
if %~z1==404250 set GD=1
if %~z1==409154 set GD=1
if %~z1==427680 set GD=1
if "%GD%"=="1" xcopy /yh %~1 %USBDRIVELETTER%\_ISO\e2b\grub\DPMS\NTBOOT.MOD > nul
if "%GD%"=="1" attrib -s -h -r %USBDRIVELETTER%\_ISO\e2b\grub\DPMS\NTBOOT.MOD\bootmgr
goto :EOF




