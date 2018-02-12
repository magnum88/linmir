Put all apps, packages, etc. under here

Ensure they are copied to C:\DRIVERS\APPS from the Main  Model_Win.cmd file in \INSTALLS -

e.g.  \INSTALLS\904_W1032 should contain one of these two lines (or both lines if you like, but only one will work)
xcopy /herky %USB%\INSTALLS\APPS\MYAPP\BOTH\*.*  %SystemDrive%\DRIVERS\APPS\ >> %log%
xcopy /herky %USB%\INSTALLS\APPS\MYAPP\%BIT%\*.* %SystemDrive%\DRIVERS\APPS\ >> %log%

Any .cmd file will be automatically copied and later run from the C:\DRIVERS\APPS folder

If your files are both 32-bit and 64-bit (or there is no 64-bit version) then place them in the BOTH folder

e.g.  for "MYAPP"
\INSTALLS\APPS\MYAPP\BOTH  ---  place .cmd and other files here if they will run on both 32-bit and 64-bit systems
\INSTALLS\APPS\MYAPP\x86   ---  place .cmd and other files here if they will run only on 32-bit systems
\INSTALLS\APPS\MYAPP\AMD64 ---  place .cmd and other files here if they will run only on 64-bit systems

Only one .cmd file should be present in each folder. 

You can download application install files from npackd.appspot.com, choose a version and copy them to the E2B USB drive \_ISO\WINDOWS\INSTALLS\APPS folder.

You can then either install them directly from the USB drive, or copy the .exe or .msi files to the C:\DRIVERS folder, and install them from the hard disk. 
To install them silently, use this syntax (examples for 7z and Foxit Reader):

start /wait msiexec /qb- /i C:\DRIVERS\7z1602.msi
start /wait FoxitReader734_enu_Setup_Prom.exe /silent


