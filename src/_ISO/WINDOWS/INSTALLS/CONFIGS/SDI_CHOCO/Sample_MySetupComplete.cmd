:: Environment variables that are already available:
:: %USB% is the USB drive - e.g. D:  NOTE: IT MAY BE DISCONNECTED BY NOW!
:: %BIT% will either be x86 or amd64
:: %WINVER% will be 7 or 8 or 10
:: %log% will be the log file
:: %errlog% will be a log file to record errors
:: %systemdrive%\DRIVERS folder will hold all files that were in %USB%\_ISO\WINDOWS\INSTALLS\CONFIGS\SDI_CHOCO

:: --- WARNING: No console is visible and no mouse pointer!!!

if exist %systemdrive%\DRIVERS\NoChoco.TAG start /wait %systemdrive%\DRIVERS\nircmd speak text "WARNING: The file No Choco dot tag was found - choco installs will not work"

:: configure choco to allow non-checksummed packages and not prompt user for 'Yes' (-y is not needed)
choco feature enable -n allowEmptyChecksums
choco feature enable -n allowGlobalConfirmation

%systemdrive%\DRIVERS\nircmd.exe speak text "Downloading and installing NotePad + +"
choco install notepadplusplus -y -r >> %log%

