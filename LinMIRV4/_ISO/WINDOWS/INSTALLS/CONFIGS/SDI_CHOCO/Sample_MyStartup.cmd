:: Environment variables that are already available:
:: %USB% is the USB drive - e.g. D:  NOTE: IT MAY BE DISCONNECTED BY NOW!
:: %BIT% will either be x86 or amd64
:: %WINVER% will be 7 or 8 or 10
:: %log% will be the log file
:: %errlog% will be a log file to record errors
:: %systemdrive%\DRIVERS folder will hold all files that were in %USB%\_ISO\WINDOWS\INSTALLS\CONFIGS\SDI_CHOCO

:: Stop automatic updates (uncomment to enable)
:: reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update" /v AUOptions /t REG_DWORD /d 1 /f


if exist %systemdrive%\DRIVERS\NoChoco.TAG start /wait %systemdrive%\DRIVERS\nircmd speak text "WARNING: The file No Choco dot tag was found - choco installs will not work"

:: configure choco to allow non-checksummed packages and not prompt user for 'Yes' (-y is not needed)
choco feature enable -n allowEmptyChecksums
choco feature enable -n allowGlobalConfirmation


echo Installing Classic shell...
%systemdrive%\DRIVERS\nircmd.exe speak text "Downloading and installing Classic Shell"
choco install classic-shell -r -y >> %log%

:: Install Google Chrome (internet connection required) - automatic install
echo Installing Google Chrome...
%systemdrive%\DRIVERS\nircmd.exe speak text "Downloading and installing Google Chrome"
choco install googlechrome -y -r >> %log%

echo Installing TeamViewer...
%systemdrive%\DRIVERS\nircmd.exe speak text "Downloading and installing Team Viewer"
choco install teamviewer -r -y >> %log%

::More examples:
::choco install 7zip.install -y -r >> %log%
::choco install notepadplusplus -y -r >> %log%
::choco install vlc -r -y >> %log%
::choco install sysinternals -r -y >> %log%
::choco install keepass.install -r -y >> %log%
::choco install virtualbox -r -y >> %log%
::choco install ccleaner -r -y >> %log%
::choco install 7zip.install -y -r >> %log%
::choco install notepadplusplus.install -y -r >> %log%
::choco install jre8 -r -y >> %log%
::choco install vlc -r -y >> %log%
::choco install filezilla -r -y >> %log%
::choco install malwarebytes -r -y >> %log%
::choco install winrar -r -y >> %log%
::choco install winmerge -r -y >> %log%
::choco install irfanview -r -y >> %log%
::choco install audacity -r -y >> %log%
::choco install qbittorrent -r -y >> %log%
::choco install cpu-z -r -y >> %log%
::choco install everything -r -y >> %log%
::choco install firefox -packageParameters "l=en-GB"  -r -y >> %log%
::choco install googledrive -r -y >> %log%
::choco install dropbox -r -y >> %log%
::choco install adobereader -r -y >> %log%
::choco install libreoffice -r -y >> %log%
::choco install classic-shell -r -y >> %log%



:: Activate if get_win8key.exe has been added
:: get_win8key.exe can be downloaded from github.com/christian-korneck/get_win8key#files
:: Right-click - Properties - UnBlock  before using the file
:: Must be run as Admin
if exist %systemdrive%\DRIVERS\get_win8key.exe call %systemdrive%\DRIVERS\autoactivate.cmd
