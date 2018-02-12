\_ISO\WINDOWS\INSTALLS using SDI_CHOCO
======================================

See http://www.easy2boot.com/add-payload-files/windows-install-isos/sdi-choco/

This folder is for Vista\7\8\10 installs from a standard Microsoft ISO installer file.
Note: Use the latest Windows 10 ISOs (the first 2015 WIN10 TH2 ISOs had problems with network\internet connectivity!).

XP Installer ISOs are not supported.

An XML file must be used (e.g. ***SDI_CHOCO.XML) which contains special sections which will cause a file in the
\_ISO\WINDOWS\INSTALLS\CONFIGS folder to be run after all the Windows files have been copied to the target hard disk.

The \_ISO\WINDOWS\INSTALLS\CONFIGS folder should contain the .cmd file that is specified in the XML file.
e.g. \_ISO\WINDOWS\INSTALLS\CONFIGS\904_W10.cmd

There are four main folders:

\_ISO\WINDOWS\INSTALLS\APPS     - If you have bespoke apps (e.g. Chrome), copy the installations files to a folder here
\_ISO\WINDOWS\INSTALLS\CONFIGS  - contains the .cmd file that runs during the 'Specialize' pass + any special drivers, etc.
\_ISO\WINDOWS\INSTALLS\SNAPPY   - contains the Snappy Driver Installer (SDI) software and large DriverPacks
\_ISO\WINDOWS\INSTALLS\DRIVERS	- contains any bespoke machine-specific drivers, e.g. \_ISO\WINDOWS\INSTALLS\DRIVERS\904_W10\x86 (or amd64)

wsusoffline is used for WSUS Offline Updater files.


Main script files
=================

Typically, there are three .cmd scripts that run during installation:
\_ISO\WINDOWS\INSTALLS\CONFIGS\SDI_CHOCO.cmd - this runs with admin (system) rights during the Specialize pass (after first reboot, "Getting ready" phase)
\_ISO\WINDOWS\INSTALLS\CONFIGS\SDI_CHOCO\setupcomplete.cmd - this runs once just before first login as 'system'. There is no mouse pointer and the console is hidden.
\_ISO\WINDOWS\INSTALLS\CONFIGS\SDI_CHOCO\startup.cmd - this runs once after first user login - it has Administrator rights.

These are the main three files that you can edit to modify the install process.
Note that SDI_CHOCO.cmd will run whether the system is a 32-bit system or 64-bit system, so your .cmd files need to cope with both types of system.
Tip: The %BIT% variable will be either 'x86' or 'amd64'.

CONFIGS Folder
==============

Under here should be a machine-specific folder for different configurations - e.g. SDI_CHOCO.
Under that folder, should be another folder containing any special files that you want to be copied to the target hard disk.
Amongst these files should be a file called startup.cmd (and possibly setupcomplete.cmd).

The main config file (specified in the XML - e.g. \_ISO\WINDOWS\INSTALLS\CONFIGS\904_W10.cmd) will typically:
	Find the USB drive letter
	Copy over any apps and configuration\driver files to the hard disk
	Copy the startup.cmd and setupcomplete.cmd files to the correct folders on the hard disk
	Run SDI to install all drivers automatically
	Run Chocolatey to install any apps (network connection required)
	Tidy up any files
	Enable UAC.


APPS Folder
===========

The main config batch file (e.g. SDI_CHOCO.cmd) can copy the correct folders (x86/amd64/both) to C:\DRIVERS\APPS.
When startup.cmd runs at first user login, it can automatically run any .cmd file located in C:\DRIVERS\APPS folder.
Note: This is NOT anything to do with Chocolatey app installs. It is for any special apps that you want to install.

Example:
This folder should contain special application installation files - e.g. CHROME

Example: Under this (CHROME) folder, there can be 1, 2 or 3 sub-folders: e.g. 

\_ISO\WINDOWS\INSTALLS\APPS\CHROME\AMD64
\_ISO\WINDOWS\INSTALLS\APPS\CHROME\X86
\_ISO\WINDOWS\INSTALLS\APPS\CHROME\BOTH

If your install files (e.g. .exe, .msi, etc.) will install to both 32-bit and 64-bit OS's
(or if it is a 32-bit application and there is no 64-bit version) then place the application files in the BOTH folder.
Otherwise, place the 32-bit installation files in the X86 folder and the 64-bit installation files in the AMD64 folder.

Any .cmd file that is present in the folder will be called by StartUp.cmd on first user logon.
So make sure only one .cmd file is present in each folder.
All applications folders will be copied to the C:\DRIVERS\APPS\ folder, so the .cmd file must expect to be run from C:\DRIVERS\APPS.

You can download application install files from npackd.appspot.com, choose a version and copy them to the E2B USB drive \_ISO\WINDOWS\INSTALLS\APPS folder.

You can then either install them directly from the USB drive, or copy the .exe or .msi files to the C:\DRIVERS folder, and install them from the hard disk. 
To install them silently, use this syntax (examples for 7z and Foxit Reader):

start /wait msiexec /qb- /i %USB%\_ISO\WINDOWS\INSTALLS\APPS\7zip\BOTH\7z1602.msi

or if you copy them to the C:\DRIVERS folder...

start /wait C:\DRIVERS\FoxitReader734_enu_Setup_Prom.exe /silent

e.g. To add Foxit Reader:
\_ISO\WINDOWS\INSTALLS\APPS\Foxit\BOTH\FoxitReader734_enu_Setup_Prom.exe
\_ISO\WINDOWS\INSTALLS\APPS\Foxit\BOTH\FoxitReader.cmd    <---- contains command to install Foxit

To copy the whole folder, add this line to your \_ISO\WINDOWS\INSTALLS\CONFIGS\xxxxx.cmd file:
xcopy /herky %USB%\_ISO\WINDOWS\INSTALLS\APPS\Foxit\BOTH\ %systemdrive%\DRIVERS\ > nul

then the .cmd file will automatically be run by the code lines in startup.cmd, e.g. 
:: Install any apps we have added - run all .cmd files in DRIVERS\APPS folder...
FOR %%I IN (C:\DRIVERS\APPS\*.cmd) DO CALL :loopbody %%I



DRIVERS folder
==============

This folder can contain machine-specific drivers for different systems.
Note: This folder is NOT anything to do with Snappy Driver Installer.

The correct drivers should be copied to C:\DRIVERS by your main config script (e.g. 904_W10.cmd).
The drivers can then be installed from the C:\DRIVERS folder (use subfolder).
Use Start /wait when installing drivers that run a Windows .exe program (e.g. start \wait C:\DRIVERS\Audio\setup.exe -s)



SNAPPY Folder
=============

This folder contains the Snappy Driver Installer application and any DriverPacks.
All required Driverpacks must be added first before you start an installation.
You should first run SDI_auto.bat and download at least the Index, chipset and network driver packs.
If you wish, you can download any of the other packs too (depending on what you think you will need).

wsusoffline folder
==================
This folder is used for WSUS Offline Updater files. Just download and copy the WSUS Offline Update files to this folder.
Run the WSUS utility UpdateGenerator.exe to download the desired update packs first, before you boot to E2B.
