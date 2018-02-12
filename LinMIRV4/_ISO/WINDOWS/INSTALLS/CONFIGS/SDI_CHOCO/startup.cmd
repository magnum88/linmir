@echo off
:: This file is added into the default Startup folder C:\ProgramData\Microsoft\Windows\Start Menu\Programs\StartUp\
title %~pnx0
prompt $P_$T$G
md c:\temp 2>nul
set log=%systemdrive%\temp\%~n0.log
set errlog=%systemdrive%\temp\%~n0_ERRORS.log
echo ------------------------ >> %log% 
echo %~pnx0 is running>> %log% 
echo %~0 %date% %time% >> %log%
ver | find " 10." && set WINVER=10
ver | find " 6.2." && set WINVER=8
ver | find " 6.3." && set WINVER=8
ver | find " 6.1." && set WINVER=7
if /i "%BIT%"=="x86" set B=32 bit
if /i "%BIT%"=="amd64" set B=64 bit

start /wait %systemdrive%\DRIVERS\nircmd.exe beep 500 1000  & start /wait %systemdrive%\DRIVERS\nircmd beep 400 1000
start /wait %systemdrive%\DRIVERS\nircmd.exe stdbeep
start /wait %systemdrive%\DRIVERS\nircmd speak text "%~n0 script has started"

for %%i in (C D E F G H I J K L M N O P Q R S T U V W X Y Z) do if exist %%i:\_ISO\e2b\grub\e2b.cfg set USB=%%i:
echo Found USB drive as drive %USB% >> %log%


:: ----- BESPOKE APP INSTALL ---

:: Install any apps we have added - run all .cmd files in DRIVERS\APPS folder...
FOR %%I IN (%systemdrive%\DRIVERS\APPS\*.cmd) DO CALL :loopbody %%I

:: ------- INSTALL BESPOKE APPS -----------------

::Example:
::IF NOT EXIST %SystemRoot%\SysWOW64 start /w msiexec.exe /i "%systemdrive%\DRIVERS\GoogleChromeStandaloneEnterprise32.msi" /q /norestart >> %log% 
::IF EXIST     %SystemRoot%\SysWOW64 start /w msiexec.exe /i "%systemdrive%\DRIVERS\GoogleChromeStandaloneEnterprise64.msi" /q /norestart >> %log%

:: ----- WSUS Offline installer (requires activated OS) ------

:: You should have copied the \_ISO\WINDOWS\INSTALLS\wsusoffline folder to the C: drive previously - e.g. C:\DRIVERS\wsusoffline - 
:: The client\w100-x64 folder contains the Windows 10 x64 updates - if this is Win10 x64, you don't need to copy the other folders
:: Now add all Windows Updates
:: Note - if this reboots then it will not resume - it must be runs as administrator
:: It may be best to run it manually after installation
:: Log files are usually in C:\WINDOWS\wsusofflineupdate.log

:: check for tag file
if exist %systemdrive%\DRIVERS\NoWSUS.tag echo NoWSUS.TAG file found - skipping WSUS>> %log% & goto :NoWSUS

if exist %systemdrive%\DRIVERS\wsusoffline\client\cmd\DoUpdate.cmd (
	echo WSUS Offline Install - this will take a while!
	%systemdrive%\DRIVERS\nircmd.exe speak text "Running W S U S Offline Update installer from hard disk"
	call %systemdrive%\DRIVERS\wsusoffline\client\cmd\DoUpdate.cmd
	set WSUS=1
)
if "%WSUS%"=="" if exist %USB%\_ISO\WINDOWS\INSTALLS\wsusoffline\client\cmd\DoUpdate.cmd (
:: alternatively, if the USB drive is still connected, run it from the USB drive (may take a very long time!)
	echo WSUS Offline Install - this will take a while!
	%systemdrive%\DRIVERS\nircmd.exe speak text "Running W S U S Offline Update installer from USB drive"
	call %USB%\_ISO\WINDOWS\INSTALLS\wsusoffline\client\cmd\DoUpdate.cmd
	set WSUS=1
)
if exist %SystemRoot%\wsusofflineupdate.log copy %SystemRoot%\wsusofflineupdate.log %systemdrive%\Temp\wsusofflineupdate.log > nul
if "%WSUS%"=="" %systemdrive%\DRIVERS\nircmd.exe speak text "W S U S Offline Update installer script was not found"

:NoWSUS

:: Now enable UAC on next boot
regedit /S %systemdrive%\DRIVERS\UAC_Default.reg >> %log%



:: ---- CHOCOLATEY ---------
if exist %systemdrive%\DRIVERS\NoChoco.TAG echo The file NoChoco.TAG was found - skipping choco>> %log% & goto :skipchoco
if not exist %systemdrive%\DRIVERS\MyStartup.cmd echo MyStartup.cmd was not found - skipping choco>> %log% & goto :skipchoco
:: Requires administrator rights and internet
echo DOWNLOAD CHOCOLATEY FROM INTERNET AND INSTALL...
@powershell -NoProfile -ExecutionPolicy unrestricted -Command "iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1'))" && SET PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin
:: see https://chocolatey.org/packages for more packages - omit the -r -y >> %log%  portion for choice to install or not
echo Installing apps (internet access required)...
echo See https://chocolatey.org/packages for more packages
:skipchoco

:: --- Call User file MyStartup.cmd -----

if not exist %systemdrive%\DRIVERS\MyStartup.cmd start  /wait %systemdrive%\DRIVERS\nircmd speak text "Information: My Startup dot cmd was not found"
if not exist %systemdrive%\DRIVERS\MyStartup.cmd echo INFO: MyStartup.cmd not found! >> %log%
:: in case we prompt user for packages to install, change console to white on black (otherwise looks messy!)
color 0f
if exist %systemdrive%\DRIVERS\MyStartup.cmd call %systemdrive%\DRIVERS\MyStartup.cmd
:: go back to white on blue console
color 1f

:: ----- LIST APPS (not all may show!) ------
:: choco -list will list all packages available, -localonly for just this system - not all choco packages may register properly if installed earlier
echo ------ LIST APPS ------- >> %log%
if not exist %systemdrive%\NoChoco.TAG echo Installed choco packages: >> %log%
if not exist %systemdrive%\NoChoco.TAG choco list -localonly >> %log%
echo. >> %log%
echo List of apps using wmic: >> %log%
wmic product get name >> %log%
echo. >> %log%
echo. >> %log%
echo List of UnInstall apps from Registry: >> %log%
@powershell -NoProfile -ExecutionPolicy unrestricted -Command "Get-ItemProperty HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\* | Select-Object DisplayName, DisplayVersion, Publisher, InstallDate | Format-Table -AutoSize" >> %log%
echo. >> %log%

:: ---- TIDY UP ------

:: Allow user to run shell and type commands, etc.
::echo Type exit to continue...
::cmd /K
::pause



echo %date% %time% Finished %~0  >> %log%
echo.
echo %~0 FINISHED

:: Turn off CAPSLOCK for user
start /wait %systemdrive%\DRIVERS\capslock off
start /wait %systemdrive%\DRIVERS\scrolllock off
start /wait %systemdrive%\DRIVERS\nircmd beep 500 1000  & start /wait %systemdrive%\DRIVERS\nircmd beep 600 1000
start /wait %systemdrive%\DRIVERS\nircmd stdbeep
start /wait %systemdrive%\DRIVERS\nircmd speak text "The installation has finished. Reboot to enable UAC... Thank you for using Easy two Boot"

timeout 5 > nul

:: Can TIDY UP now
::rmdir /S /Q %systemdrive%\DRIVERS >> %log%
::rmdir /S /Q %systemdrive%\Temp >> %log%

if exist %log% echo Log files are at C:\Temp


:: reboot after WSUS, etc.
if exist %systemdrive%\Temp\wsusofflineupdate.log DEL /F /Q %systemdrive%\%~nx0 > nul & start shutdown -r -t 5 & exit


:: Delete this file too (I deliberately do not use %0 so it will only delete the file if it is in the root).
DEL /F /Q %systemdrive%\%~nx0 > nul & exit

exit


:: --- SUBROUTINES ---

:loopbody
ECHO Running %1 >> %log%
call %1 >> %log%
ECHO Finished %1 >> %log%
ECHO ---------------- >> %log%
GOTO :EOF
