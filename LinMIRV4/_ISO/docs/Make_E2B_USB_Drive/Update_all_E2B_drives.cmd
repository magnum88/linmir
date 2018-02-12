@echo off
pushd "%~dp0"
echo UPDATE ALL E2B DRIVES...
if not exist Update_e2B_Drive.cmd if exist ..\..\..\Update_e2B_Drive.cmd pushd ..\..\..
if not exist Update_e2B_Drive.cmd echo ERROR: UPDATE_E2B_DRIVE.CMD not found && pause && exit
FOR %%D IN (C D E F G H I J K L M N O P Q R S T U V W X Y Z) DO (
DIR %%D:\_ISO\e2b\grub\e2b.cfg > nul 2>&1 && (call set USBDRIVE=%%D:) && start cmd /c Update_e2B_Drive.cmd %%D: && echo Updated %%D
)
