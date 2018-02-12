Bespoke machine-specific drivers can be copied here.
Then write some lines in the CONFIGS\xxxx.cmd script to copy the correct drivers to C:\DRIVERS

Note that the system may be x86 or amd64, so use the %BIT% variable to copy the correct 'flavour'

e.g.

\_ISO\WINDOWS\INSTALLS\DRIVERS\IdeaPad300_W10\x86
\_ISO\WINDOWS\INSTALLS\DRIVERS\IdeaPad300_W10\amd64
\_ISO\WINDOWS\INSTALLS\DRIVERS\IdeaPad300_W10\both


in CONFIG\xxxx.cmd file, copy across the correct drivers
xcopy /herky %USB%\_ISO\WINDOWS\INSTALLS\DRIVERS\IdeaPad300_W8_and_10\%BIT%\*.*  %SystemDrive%\DRIVERS\ >> %log%
xcopy /herky %USB%\_ISO\WINDOWS\INSTALLS\DRIVERS\IdeaPad300_W8_and_10\BOTH\*.*   %SystemDrive%\DRIVERS\ >> %log%

and later

start /wait %systemdrive%\DRIVERS\Install_all_drivers.cmd


