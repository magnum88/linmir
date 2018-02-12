:: Environment variables that are already available:
:: %USB% is the USB drive - e.g. D:
:: %BIT% will either be x86 or amd64
:: %WINVER% will be 7 or 8 or 10
:: %CONFIGDIR% will be %USB%\_ISO\WINDOWS\INSTALLS\CONFIGS\SDI_CHOCO
:: %log% will be the log file
:: %errlog% will be a log file to record errors
:: %systemdrive%\DRIVERS folder will hold all files that were in %USB%\_ISO\WINDOWS\INSTALLS\CONFIGS\SDI_CHOCO

:: Download and install some choco applications - it is best to install choco apps using Startup.cmd
:: Some choco apps installed at this stage of Setup may not register correctly

if exist %systemdrive%\DRIVERS\NoChoco.TAG start /wait %systemdrive%\DRIVERS\nircmd speak text "WARNING: The file No Choco dot tag was found - choco installs will not work"

:: configure choco to allow non-checksummed packages and not prompt user for 'Yes' (-y is not needed)
choco feature enable -n allowEmptyChecksums
choco feature enable -n allowGlobalConfirmation

:: prompt user to install 7zip
systemdrive%\DRIVERS\nircmd.exe speak text "Do you want to install 7 Zip?"
choco install 7zip.install

:: activate Windows if possible using BIOS OEM key
::call C:\DRIVERS\autoactivate.cmd >> %log%


:: Copy bespoke apps
::xcopy /herky %USB%\_ISO\WINDOWS\INSTALLS\APPS\FOXIT\*.* %systemdrive%\DRIVERS\APPS\FOXIT\
::REM copy .cmd file C:\DRIVERS\APPS folder so it will auto-run during startup.cmd
::xcopy %USB%\_ISO\WINDOWS\INSTALLS\APPS\FOXIT\Foxauto.cmd %systemdrive%\DRIVERS\APPS\


:: Remove this line if you want to install bespoke drivers (example below)
goto :eof

:: Install bespoke driver

:: Copy bespoke drivers for IdeaPad 300
xcopy /herky %USB%\_ISO\WINDOWS\INSTALLS\DRIVERS\IDPAD300\W8_10_64\*.* %systemdrive%\DRIVERS\IDPAD300\W8_10_64\

:: We can remove the USB drive now before we install the drivers

:: This script is now running directly from C:\DRIVERS - use 'exit' so it does not return to the USB drive cmd file
echo.
echo YOU CAN REMOVE THE E2B USB DRIVE IF [CAPS LOCK] OR [SCROLL LOCK] LED IS LIT...
echo.
start /wait %systemdrive%\DRIVERS\nircmd.exe speak text "You can remove the USB drive now"
:: Turn on CAPSLOCK to indicate safe to remove E2B
start /wait %systemdrive%\DRIVERS\nircmd sendkeypress capslock scroll
timeout 5

:: Now install drivers from the C: drive
echo %date% %time% Installing drivers >> %log%
call %systemdrive%\DRIVERS\IDPAD300\W8_10_64\ID300_DRIV_INST.cmd

start /wait %systemdrive%\DRIVERS\nircmd.exe speak text "Driver install completed"

:: Do NOT return back to the end of SD_CHOCO.cmd because it is running from the USB drive which is now gone!

exit

