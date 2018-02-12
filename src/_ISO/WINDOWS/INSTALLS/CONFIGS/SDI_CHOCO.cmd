@echo off
:: don't run this twice!
if exist %systemroot%\DONE_SDI.tag exit

set VER=0.05
set USB=%~d0

:: CONFIGDIR folder contains the startup.cmd, setupcomplete.cmd and other files that will be copied to C:\DRIVERS
set CONFIGDIR=%USB%\_ISO\WINDOWS\INSTALLS\CONFIGS\SDI_CHOCO

::DRIVERSDIR - copy over any bespoke driver folders to C:\DRIVERS, they should be in x86 amd64 or BOTH subfolders
::set DRIVERSDIR=%USB%\_ISO\WINDOWS\INSTALLS\DRIVERS\IdeaPad300W8_10

:: BIT will be either x86 or amd64
set BIT=%PROCESSOR_ARCHITECTURE%
md %systemdrive%\Temp > nul
set log=%systemdrive%\temp\%~n0.log
set errlog=%systemdrive%\temp\%~n0_ERRORS.log
set WINVER=
prompt $P_$T$G
title %~0  -  Version %VER%
color 1f
echo.
echo This calls the SNAPPY Driver Installer (SDI) to install Windows drivers
echo and then calls CHOCOLATEY (choco) to download and install apps from the internet
echo.


:: ---- LOG ENVIRONMENT ---
echo %date% %time% %~0   -  Version %VER% >> %log%
echo. >> %log%
set >> %log%
echo. >> %log%
:: Show no user profiles present
dir %SystemDrive%\users\*.* >> %log%
:: Network diagnostic logging (network drivers may not be installed or maybe no Host Name?)
ipconfig /all >> %log%
ping -n 1 8.8.4.4 >> %log%
echo. >> %log%
echo. >> %log%


:: -------- COPY FILES FROM USB DRIVE TO HDD C:\DRIVERS folder ---------------

:: COPY FILES TO C:\DRIVERS FOLDER
xcopy /herky %CONFIGDIR%\*.* %SystemDrive%\DRIVERS\ >> %log%
:: tell user - but speech\audio may not be working yet...
start /wait %systemdrive%\DRIVERS\nircmd speak text "%~n0 script has started"

ver | find " 10." && set WINVER=10
ver | find " 6.2." && set WINVER=8
ver | find " 6.3." && set WINVER=8
ver | find " 6.1." && set WINVER=7
if /i "%BIT%"=="x86" set B=32 bit
if /i "%BIT%"=="amd64" set B=64 bit
if "%WINVER%"=="7"  start /wait %systemdrive%\DRIVERS\nircmd.exe speak text "WINDOWS SEVEN %B% DETECTED"
if "%WINVER%"=="8"  start /wait %systemdrive%\DRIVERS\nircmd.exe speak text "WINDOWS EIGHT %B% DETECTED"
if "%WINVER%"=="10" start /wait %systemdrive%\DRIVERS\nircmd.exe speak text "WINDOWS TEN %B% DETECTED"

:: Look for special files
if exist %systemdrive%\DRIVERS\mys*.cmd dir %systemdrive%\DRIVERS\Mys*.cmd
if exist %systemdrive%\DRIVERS\MySpecialize.cmd    start /wait %systemdrive%\DRIVERS\nircmd speak text "The file My specialize dot cmd was found"
if exist %systemdrive%\DRIVERS\Mysetupcomplete.cmd start /wait %systemdrive%\DRIVERS\nircmd speak text "The file My setup complete dot cmd was found"
if exist %systemdrive%\DRIVERS\MyStartup.cmd       start /wait %systemdrive%\DRIVERS\nircmd speak text "The file My start up dot cmd was found"
if exist %systemdrive%\DRIVERS\No*.TAG dir %systemdrive%\DRIVERS\No*.TAG
if exist %systemdrive%\DRIVERS\NoChoco.TAG         start /wait %systemdrive%\DRIVERS\nircmd speak text "The file No Choco dot tag was found - choco will be suppressed"
if exist %systemdrive%\DRIVERS\NoSDI.TAG           start /wait %systemdrive%\DRIVERS\nircmd speak text "The file No S D I dot tag was found - Snappy Driver Install will be suppressed"
if exist %systemdrive%\DRIVERS\NoWSUS.TAG          start /wait %systemdrive%\DRIVERS\nircmd speak text "The file No W S U S dot tag was found - Windows offline Updates will be suppressed"
if exist %systemdrive%\DRIVERS\NoInternet.TAG      start /wait %systemdrive%\DRIVERS\nircmd speak text "The file No internet dot tag was found - Internet connectivity will not be tested"

:: copy this file to temp folder for later reference
xcopy /y "%~0"  %SystemDrive%\temp\ >> %log%

:: ------ SETUPCOMPLETE and STARTUP -----

:: SETUPCOMPLETE.CMD - this will run silently just before first user login
xcopy /y %CONFIGDIR%\setupcomplete.cmd %WINDIR%\SETUP\SCRIPTS\ >> %log%
:: List file to check it is there!
echo. >> %log%
dir %WINDIR%\SETUP\SCRIPTS\*.* >> %log%

:: STARTUP.CMD to run once on first user login
copy /y %CONFIGDIR%\startup.cmd "%systemdrive%\startup.cmd" >> %log%
REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce" /V "startup.cmd" /t REG_SZ /F /D "C:\startup.cmd"
echo. >> %log%


:: -------- COPY BESPOKE DRIVERS TO C:\DRIVERS -----------
::copy over bespoke drivers (either x86 or amd64) so we can later install them later on without needing the USB drive
::xcopy /herky %DRIVERSDIR%\%BIT%\*.*  %SystemDrive%\DRIVERS\ >> %log%
::xcopy /herky %DRIVERSDIR%\BOTH\*.*   %SystemDrive%\DRIVERS\ >> %log%

:: -------- COPY BESPOKE APPS TO C:\DRIVERS\APPS ------------
:: Chrome app install example - copy files to DRIVERS\APPS folder - any .cmd will automatically run when Startup.cmd runs
:: Any *.cmd file in C:\DRIVERS\APPS folder will automatically be run by Startup.cmd, or you can script them separately
::xcopy /hrky %USB%\_ISO\WINDOWS\INSTALLS\APPS\CHROME\BOTH\*.*  %SystemDrive%\DRIVERS\APPS\ >> %log%
::xcopy /herky %USB%\_ISO\WINDOWS\INSTALLS\APPS\CHROME\%BIT%\*.* %SystemDrive%\DRIVERS\APPS\ >> %log%

:: Add in file to always run on login (even if reboot) - it can delete itself when all installs completed - BUT it does not run as admin!
::xcopy /y %CONFIGDIR%\startup_user.cmd "%systemdrive%\ProgramData\Microsoft\Windows\Start Menu\Programs\StartUp\" >> %log%


:: ------- COPY WSUSoffline folder and relevant updates ------
:: check for tag file
if exist %systemdrive%\DRIVERS\NoWSUS.tag echo NoWSUS.TAG file found - skipping WSUS>> %log% & goto :NoWSUS
if "%WINVER%"=="7" echo Windows 7 detected - skipping WSUS>> %log% & goto :NoWSUS

	:: as it takes quite a while to run WSUS Offline, we will do it after a reboot so we can remove the USB drive as soon as possible.
	:: WSUS update folders: Windows 10 uses w10 folder, Windows 8 uses w63 folder - exclude update folders we don't need to copy
	if "%WINVER%"=="10" if /i "%BIT%"=="x86"   set XB=/EXCLUDE:%systemdrive%\DRIVERS\WSUS_W10x86.txt
	if "%WINVER%"=="10" if /i "%BIT%"=="amd64" set XB=/EXCLUDE:%systemdrive%\DRIVERS\WSUS_W10x64.txt
	if "%WINVER%"=="8"  if /i "%BIT%"=="x86"   set XB=/EXCLUDE:%systemdrive%\DRIVERS\WSUS_W8x86.txt
	if "%WINVER%"=="8"  if /i "%BIT%"=="amd64" set XB=/EXCLUDE:%systemdrive%\DRIVERS\WSUS_W8x64.txt
	if "%XB%"=="" echo ERROR SETTING EXCLUSION FILE! & pause
	if not exist %USB%\_ISO\WINDOWS\INSTALLS\wsusoffline\client\cmd\DoUpdate.cmd echo INFO: No WSUS file found at %USB%\_ISO\WINDOWS\INSTALLS\wsusoffline\client\cmd\DoUpdate.cmd

if exist %USB%\_ISO\WINDOWS\INSTALLS\wsusoffline\client\cmd\DoUpdate.cmd (
	start /wait %systemdrive%\DRIVERS\nircmd speak text "Copying Windows Update Offline files to system drive"
	echo  %date% %time% Copying WSUS Offline files to %systemdrive% >> %log%
	echo Copying wsusoffline folder using exclusion file >> %log%
	echo WSUS XCOPY EXCLUSION FILTER SWITCH=%XB% >> %log%
	echo Xcopy is using FILTER TEXT FILE=%XB%
	xcopy /herky %USB%\_ISO\WINDOWS\INSTALLS\wsusoffline\client\*.* %systemdrive%\DRIVERS\wsusoffline\client\ %XB%>> %log%
	if errorlevel 1 pause
)
:NoWSUS


:: ---- SDI - SNAPPY DRIVER INSTALLATION (AT LEAST CHIPSET, LAN and WIFI) ----
if exist %systemdrive%\DRIVERS\NoSDI.tag echo NoSDI.TAG file found - skipping SNAPPY DRIVER INSTALLER>> %log% & goto :NoSDI
echo Snappy Driver Installer...
echo %date% %time% Starting SDI >> %log%
:: some other options are -showconsole -autoupdate -nogui
:: Update version - currently does not work in SDI
::call %USB%\_ISO\WINDOWS\INSTALLS\SNAPPY\AUTO.cmd -autoclose -log_dir:%systemdrive%\temp -autoupdate

call %USB%\_ISO\WINDOWS\INSTALLS\SNAPPY\AUTO.cmd -autoclose -log_dir:%systemdrive%\temp -autoinstall -showconsole
:: errorlevel reporting doesn't work

echo SDI pass 1 done! >> %log%
:: Run twice in case of internet connection issues
::if "%BADNET%"=="1" call %USB%\_ISO\WINDOWS\INSTALLS\SNAPPY\AUTO.cmd -autoclose -log_dir:%systemdrive%\temp -autoinstall -showconsole & echo SDI pass 2 done! >> %log%
echo %date% %time% Finished SDI  >> %log%
:noSDI


if exist %systemdrive%\DRIVERS\NoInternet.TAG echo NoInternet.TAG file found - skipping internet checks>> %log% & goto :skipchoco

:: --- CHECK INTERNET ACCESS ---

:: Some version of Windows have a bug (e.g. Win10 TH2 first release)! 
:: Internet access does not work in the specialize pass - maybe no Host Name???
:: If ping fails, run msoobe, wait a while and then kill it!
:: By running msoobe.exe we can sometimes force networking to start
ping -n 1 BBC.CO.UK >> %log%
if errorlevel 1 ping BBC.CO.UK >> %log%
ping -n 1 BBC.CO.UK >> %log%
if errorlevel 1 (
  echo NETWORK IS NOT WORKING! Please wait 10 seconds for msoobe to finish...
  start /wait %systemdrive%\DRIVERS\nircmd.exe speak text "NETWORK IS NOT WORKING! Please wait 10 seconds for m s oobee to finish"
  set BADNET=1
  timeout 3 > nul
  echo MSOOBE called >> %log%
  start %windir%\system32\oobe\msoobe /x 
  timeout 10 > nul
  %CONFIGDIR%\nircmd.exe killprocess msoobe.exe
  %CONFIGDIR%\nircmd64.exe killprocess msoobe.exe
  ipconfig /all >> %log%
  ping -n 1 bbc.co.uk >> %log%
  IF NOT ERRORLEVEL 1 ECHO NETWORK IS NOW WORKING AFTER MSOOBE AUTORUN >> %log%
)


:: ---- SET UP WIFI IF NO INTERNET ACCESS (MAY BE NEEDED IN LATER STAGES) ------------

:: Win 8 may not have WiFi drivers, so skip if not WIN10
if NOT "%WINVER%"=="10" goto :skipwifi
:: Optional - if WiFi drivers were added and you want to set the SSID+password, run msoobe (only works for Win10 or Win8 if WiFi drivers available)
ping -n 1 BBC.CO.UK >> %log%
if errorlevel 1 (
echo.
echo NO INTERNET ACCESS!
echo Internet access is needed for Chocolatey to download applications.
echo We will now use MSOOBE to set up a WiFi connection [if possible]
echo.
echo --------------- WI-FI SETUP USING MSOOBE DIALOG ----------------
echo.
echo 1. Press ENTER
echo 2. Proceed to select WiFi [SSID]
echo 3. Enter WiFi Password [do not proceed any further]
echo 4. Press ALT+TAB 
echo 5. Press ENTER to continue...
echo.
start /wait %systemdrive%\DRIVERS\nircmd.exe speak text "Please set up a wireless connection to the internet"
pause
echo MSOOBE called >> %log%
start %windir%\system32\oobe\msoobe /x
echo.
start /wait %systemdrive%\DRIVERS\nircmd.exe speak text "Use m s oobee to set up a wireless connection"
timeout 10 > nul
start /wait %systemdrive%\DRIVERS\nircmd.exe speak text "As soon as you have connected successfully, press the ALT plus TAB keys to switch back"
timeout 2 > nul
start /wait %systemdrive%\DRIVERS\nircmd.exe speak text "Then press the ENTER key to kill em es ooh be and continue"
cls
echo Press ENTER to kill msoobe and continue
pause
echo.
%CONFIGDIR%\nircmd.exe killprocess msoobe.exe
%CONFIGDIR%\nircmd64.exe killprocess msoobe.exe
ping -n 1 BBC.CO.UK >> %log%
if errorlevel 1 echo NETWORK IS STILL NOT WORKING!
if not errorlevel 1 echo NETWORK IS WORKING! && echo SDI pass 2 done!>> %log%
)
:skipwifi




:: ---- CHOCO (NEEDS INTERNET) ------
if exist %systemdrive%\DRIVERS\NoChoco.TAG echo NoChoco.TAG file found - skipping choco>> %log% & goto :skipchoco
if not exist %systemdrive%\DRIVERS\MySpecialize.cmd echo MySpecialize.cmd file not found - skipping choco>>%log% & goto :skipchoco
ping -n 1 BBC.CO.UK >> %log%
if errorlevel 1 echo INTERNET NOT WORKING! - SKIPPING choco & (echo NO INTERNET: CHOCO APP INSTALL SKIPPED>> %errlog%) & (start /wait %systemdrive%\DRIVERS\nircmd.exe speak text "WARNING  NO INTERNET CONNECTION") & goto :skipchoco
echo Starting Chocolatey...
echo %date% %time% DOWNLOAD CHOCOLATEY FROM NETWORK AND INSTALL... >> %log%
:: Some packages may not install correctly at this stage due to no user account but may still work OK - if not, use choco in the startup.cmd file instead!
:: Packages may not be listed by choco list command if installed in this phase
@powershell -NoProfile -ExecutionPolicy unrestricted -Command "iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1'))" && SET PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin
if errorlevel 1 echo CHOCO POWERSHELL INSTALL reported errorlevel %errorlevel% >> %errlog%
echo Downloading and installings apps - please wait...
echo See https://chocolatey.org/packages for choco packages >> %log%

:skipchoco

::because we have two entries in the XML file (one for amd64 and one for x86) a 64-bit system will run this cmd file twice so add a tag file to prevent this
echo stop > %systemroot%\DONE_SDI.tag

:: --- CALL USERS SCRIPT - MySpecialize.cmd ----
:: NOTE: It is generally better to install apps in startup.cmd (when a user account is available)
:: Not all installs may register correctly with choco or in Registry if installed using this cmd file.
if not exist %systemdrive%\DRIVERS\MySpecialize.cmd start  /wait %systemdrive%\DRIVERS\nircmd speak text "Information: My Specialize dot cmd was not found"
if not exist %systemdrive%\DRIVERS\MySpecialize.cmd echo INFO: MySpecialize.cmd was not found! >> %log%
:: prompt user for packages to install, change console to white on black (otherwise looks messy!)
color 0f
if exist %systemdrive%\DRIVERS\MySpecialize.cmd call %systemdrive%\DRIVERS\MySpecialize.cmd
:: go back to white on blue console
color 1f

:: open command prompt now (will be visible to user) - uncomment out next 3 lines if you want it to stop
::echo Type EXIT to continue
::cmd /K
::pause

:: ---- FINISHED ------

echo %date% %time% Finished %~n0  >> %log%
:: all systems green!
color 2f
start /wait %systemdrive%\DRIVERS\nircmd.exe speak text "%~n0 script has finished"
:: This script is run directly from the E2B USB drive
echo.
echo YOU CAN REMOVE THE E2B USB DRIVE IF [CAPS LOCK] OR [SCROLL LOCK] LED IS LIT...
echo.
start /wait %systemdrive%\DRIVERS\nircmd.exe speak text "You can remove the USB drive now"
:: Turn on CAPSLOCK to indicate safe to remove E2B
start /wait %systemdrive%\DRIVERS\capslock on
start /wait %systemdrive%\DRIVERS\scrolllock on
timeout 5
exit
