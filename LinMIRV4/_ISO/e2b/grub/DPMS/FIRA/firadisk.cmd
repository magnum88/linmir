REGEDIT4
;@echo off && cls
;color 3f
;pushd %~dp0

;set RUNXP=\_ISO\e2b\firadisk\RUNXP.cmd
;FOR %%D IN (C D E F G H I J K L M N O P Q R S T U V W X Y Z) DO (if exist %%D:%RUNXP% call %%D:%RUNXP% %%D)

;(echo [%date% %time%] )>> %systemdrive%\XPSetup.log
;echo http://www.rmprepusb.com - %~f0 >> %systemdrive%\XPSetup.log
;set /p del=Remove the FiraDisk driver? (Y/N) : 
;if /i not "%del%"=="y" goto :next

;echo Removing FiraDisk - please wait...
;echo Devcon is removing the Firadisk driver >> %systemdrive%\XPSetup.log
;echo Listing drivers... >> %systemdrive%\XPSetup.log
;devcon find *fira*  >> %systemdrive%\XPSetup.log 2>>&1 
;devcon remove *\firadisk >> %systemdrive%\XPSetup.log 2>>&1
;del %WinDir%\system32\drivers\firadi*.sys >> %systemdrive%\XPSetup.log 2>>&1

;echo Listing drivers... >> %systemdrive%\XPSetup.log
;devcon find *fira*  >> %systemdrive%\XPSetup.log 2>>&1
>>%~f0 echo [-HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\services\Firadisk]
>>%~f0 echo [-HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\FiraDisk]
>>%~f0 echo [-HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Enum\FIRADISK]

:next
;start /w regedit /s %~f0 
;::ren %~f0 %~nx0.deleted >> %systemdrive%\XPSetup.log
;exit

[HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\services\Firadisk\Parameters]
"StartOptions"=-
[HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Run]
"GrubDiskClean"=-

;
