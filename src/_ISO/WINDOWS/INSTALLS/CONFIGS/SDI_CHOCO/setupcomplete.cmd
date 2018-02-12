title %~0
prompt $P_$T$G
:: CMD CONSOLE IS INVISIBLE TO USER! NO MOUSE POINTER! MAKE SURE IT DOES NOT STOP!
set log=%systemdrive%\temp\%~n0.log
set errlog=%systemdrive%\temp\%~n0_ERRORS.log
md %systemdrive%\temp
echo %date% %time% %~0 started >> %log%
echo. >> %log%
dir %SystemDrive%\ >> %log%
echo. >> %log%
ver | find " 10." && set WINVER=10
ver | find " 6.2." && set WINVER=8
ver | find " 6.3." && set WINVER=8
ver | find " 6.1." && set WINVER=7
if /i "%BIT%"=="x86" set B=32 bit
if /i "%BIT%"=="amd64" set B=64 bit
set >> %log%
echo. >> %log%
echo whoami... >> %log%
whoami >> %log%
net user >> %log%
dir %SystemDrive%\Users  >> %log%

:: Turn on CAPSLOCK and SCROLL to indicate safe to remove E2B and tell user we are running
start /wait %systemdrive%\DRIVERS\nircmd sendkeypress capslock scroll
start /wait %systemdrive%\DRIVERS\nircmd.exe beep 500 1000  & start /wait %systemdrive%\DRIVERS\nircmd beep 400 1000
start /wait %systemdrive%\DRIVERS\nircmd.exe stdbeep
start /wait %systemdrive%\DRIVERS\nircmd.exe speak text "%~n0 script has started"

:: FIND USB DRIVE - if still connected
for %%i in (C D E F G H I J K L M N O P Q R S T U V W X Y Z) do if exist %%i:\_ISO\e2b\grub\e2b.cfg set USB=%%i:
echo Found USB drive as drive %USB% >> %log%

:: C:\DRIVERS folder will be present and can contain files, etc.
:: User account folder will NOT exist yet - e.g. \USERS\USER1 folder

:: example of how to add OS updates, drivers, etc.
::IF EXIST %SystemRoot%\SysWOW64 start /wait C:\DRIVERS\updates\windows-kbaaaaaaa-x64.exe /Q
::IF NOT EXIST %SystemRoot%\SysWOW64 start /wait C:\DRIVERS\updates\NDP40-KBbbbbbbb-x86.exe /passive /norestart
::IF EXIST %SystemRoot%\SysWOW64 start /wait C:\DRIVERS\updates\WinCal-Win7-amd64-en-us.exe /S /v/qb
::IF NOT EXIST %SystemRoot%\SysWOW64 start /wait C:\DRIVERS\updates\WinCal-Win7-x86-en-us.exe /S /v/qb
::start /wait REG ADD "HKEY_CURRENT_USER\Software\Microsoft\Internet Explorer\Main" /V "Disable Script Debugger" /T "REG_SZ" /D "no" /F
::start /wait REG ADD "HKEY_CURRENT_USER\Software\Microsoft\Internet Explorer\Main" /V "DisableScriptDebuggerIE" /T "REG_SZ" /D "no" /F
::IF NOT EXIST %SystemRoot%\SysWOW64 start /w msiexec.exe /i "C:\DRIVERS\GoogleChromeStandaloneEnterprise32.msi" /q /norestart
::IF EXIST %SystemRoot%\SysWOW64     start /w msiexec.exe /i "C:\DRIVERS\GoogleChromeStandaloneEnterprise64.msi" /q /norestart

:: ---- INSTALL APPS VIA CHOCO (NEEDS INTERNET) ------

ping -n 1 BBC.CO.UK >> %log%
if errorlevel 1 echo INTERNET NOT WORKING! - SKIPPING choco & (echo NO INTERNET: CHOCO APP INSTALL SKIPPED>> %errlog%) & (start /wait %systemdrive%\DRIVERS\nircmd.exe speak text "WARNING  NO INTERNET CONNECTION") & goto :skipchoco
if exist %systemdrive%\DRIVERS\NoChoco.TAG echo The file NoChoco.TAG was found - skipping choco>> %log% & goto :skipchoco
if not exist %systemdrive%\DRIVERS\MySetupComplete.cmd echo MySetupComplete.cmd not found - skipping choco>> %log% & goto :skipchoco
echo Starting Chocolatey...
echo %date% %time% DOWNLOAD CHOCOLATEY FROM NETWORK AND INSTALL... >> %log%
:: Some packages may not install correctly at this stage due to no user account but may still work OK - if not, use choco in the startup.cmd file instead!
:: Packages may not be listed by choco list command if installed in this phase
@powershell -NoProfile -ExecutionPolicy unrestricted -Command "iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1'))" && SET PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin
if errorlevel 1 echo CHOCO POWERSHELL INSTALL reported errorlevel %errorlevel% >> %errlog%
:skipchoco

:: ---- Call MySetupComplete.cmd user file -----

if not exist %systemdrive%\DRIVERS\MySetupComplete.cmd start  /wait %systemdrive%\DRIVERS\nircmd speak text "Information: MySetupComplete dot cmd was not found"
if not exist %systemdrive%\DRIVERS\MySetupComplete.cmd echo INFO: MySetupComplete.cmd not found! >> %log%
:: prompt user for packages to install, change console to white on black (otherwise looks messy!)
color 0f
if exist %systemdrive%\DRIVERS\MySetupComplete.cmd call %systemdrive%\DRIVERS\MySetupComplete.cmd
:: go back to white on blue console
color 1f

:: ----------------------

:: Add timeout to allow all processes to complete (e.g. regedit, etc.)
timeout 5

echo %date% %time% Finished %~n0  >> %log%
start /wait %systemdrive%\DRIVERS\nircmd.exe beep 500 1000  & start /wait %systemdrive%\DRIVERS\nircmd beep 600 1000
start /wait %systemdrive%\DRIVERS\nircmd.exe stdbeep
start  /wait %systemdrive%\DRIVERS\nircmd speak text "%~n0 script has finished"
:: Delete this file (must be followed immediately by exit)
DEL /F /Q %0 >nul & exit