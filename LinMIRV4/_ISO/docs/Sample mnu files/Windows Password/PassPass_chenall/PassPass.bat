!BAT
setlocal
set *
debug off
set osDrv = (md)0x2000+2
set patchDrv = (md)0x2300+2
set Temp = (md)0x5800+80
set BASE_NAME=%~nx0
set dll = /system32/msv1_0.dll

# Clear memory in case it contains bytes that look like a compressed file header!

delmod -l %~nx0 > nul  || insmod %0 > nul  || pause WARNING: %~nx0 name too long for insmod && configfile /menu.lst
:: Call the subroutine specified as first parameter of the script
if not "%1"=="" goto :%1 || goto :forceDetect

:: Attempt to auto-detect Windows installation

:BOOTDEV
:autoDetect
set BOOTDEV=%1
echo > %osDrv%		## Initialize mem drive
:: If debug is off, nothing is written to memdrive
:: If debug is on, output is too verbose
:: So, set debug to normal and turn it off immediately after
debug normal
find --devices=h | call :autoLoop=
debug off
goto displayMenu

:autoLoop
if #%1#==## goto :displayMenu
set dev=%1
shift 1
if exist BOOTDEV goto :skipBoot
if "%?_BOOT:~0,4%"=="%dev:~0,4%" goto %0		## Prevents searching boot device
:skipBoot
call :findDLL %dev%
goto %0


:: Force detection of Windows installation
:forceDetect
set max_dev=%1
set max_part=%2
if not exist max_part goto :autoDetect
echo -e \x0 > %osDrv%		## Initialize mem drive

:detect_dev
set b=%max_part%

:detect_part
::## Blindly try to iterate over HD partitions
call :findDll %max_dev% %b%
if "%b%"=="0" goto :detect_dev_next
set /a b=%b%-1
goto :detect_part
:detect_dev_next
if "%max_dev%"=="0" goto :displayMenu
set /a max_dev=max_dev-1
goto :detect_dev

:displayMenu
if "%os%"==""  echo No Windows installation found!	&& pause && goto :EOF
## Display Windows installations found
echo -e \ntitle Back to Main Menu \nconfigfile /menu.lst >> %osDrv%
echo -e \x0 >> %osDrv%	## EOF marker for configfile
configfile %osDrv%
goto :EOF


:: =======================  SUBROUTINES  =======================


:: Searches for msv1_0.dll, %0 = findDLL, %1 = Disk#, %1 = Partition#
:findDLL
set dllRoot = %1
if not "%dllRoot:~0,1%"=="(" set dllRoot = (hd%1,%2)
echo Checking %dllRoot%...
# Turn errorcheck OFF to prevent the script aborting while probing dummy partition
errorcheck off
:: only checking the directory prefix with 'win'
ls %dllRoot%/ | call :isWinDir=
errorcheck on
goto :EOF


:: Checks if the directory contains Windows installation, %0 = isWinDir, %1 = Directory
:isWinDir
if #%1#==## goto :Eof
set dllPath = %dllRoot%/%1%dll%
shift
cat --length=0 %dllPath% || goto :isWinDir
:: Check for Windows version based on Major and Minor version no. of msv1_0.dll
call :findWinVer %dllPath%
:: Start forming menu items and Write configfile to mem drive
echo -e \ntitle Windows %os% at %dllRoot%/%0 \n%BASE_NAME% patchUnpatch %dllRoot% %0 \npause \nboot >> %osDrv%
:: Next Item
goto :isWinDir


:: Find version of Windows installed
:: This batch should print the version of
:: .dll's tested on 32-bit ONLY
:: You must provide a fully qualified path as parameter.
:: Example: (hd0,0)/Windows/System32/msv1_0.dll
:: or a valid relative path from current ROOT:
:: /Windows/System32/msv1_0.dll
:findWinVer
# String is "FileV" in Unicode
set file=%~f1
set string=\x01\x00\x46\x00\x69\x00\x6C\x00\x65\x00\x56\x00

cat --hex --locate=%string% %file% > nul
set /a offbase = %?% + 27 > nul
:: Only get majmin version
dd if=%file% of=%Temp% bs=1 skip=%offbase% count=32 > nul
cat --skip=1 %Temp% | set majmin=
cat --skip=3 %Temp% | set majmin=%majmin%
cat --skip=5 %Temp% | set majmin=%majmin%
set os=(Unknown)
if "%majmin%"=="5.0" set os=2000
if "%majmin%"=="5.1" set os=XP
if "%majmin%"=="5.2" set os=XP 64-bit or Server 2003
if "%majmin%"=="6.0" set os=Vista or Server 2008
if "%majmin%"=="6.1" set os=7 or Server 2008 R2
if "%majmin%"=="6.2" set os=8 or Server 2012
if "%majmin%"=="6.3" set os=8.1 or Server 2012 R2
goto :EOF


:: Patch or Unpatch?
:patchUnpatch
echo -e iftitle [if exist (bd)/PassPass.bak] Backup %2/%3%dll% \\nBackup to \\\\PassPass.bak \ndd if=%2/%3%dll% of=(bd)/PassPass.bak \nif not "%^?%"=="0x0" pause \nconfigfile %patchDrv% > %patchDrv%
echo -e iftitle [if exist (bd)/PassPass.bak] Restore %2/%3%dll% \\nRestore from \\\\PassPass.bak \ndd of=%2/%3%dll% if=(bd)/PassPass.bak \nif "%?%"=="1" pause \nconfigfile %patchDrv% >> %patchDrv%
echo -e title Patch Windows on %2\\\\%3 \\n \n%BASE_NAME% patchDLL %2 %3 \npause \nconfigfile %patchDrv% >> %patchDrv%
echo -e title UnPatch Windows on %2\\\\%3 \\n \n%BASE_NAME% unPatchDLL %2 %3 \npause \nconfigfile %patchDrv% >> %patchDrv%
echo -e title Back to OS detection menu \nconfigfile %osDrv% \npause \nconfigfile %osDrv% >> %patchDrv%
echo -e title Boot from Internal HDD \nif "%^?_BOOT:~0,3%"=="(hd" map (hd0) (hd1)\nif "%^?_BOOT:~0,3%"=="(hd" map (hd1) (hd0) \nif "%^?_BOOT:~0,3%"=="(hd" map --hook \nchainloader (hd0)+1 >> %patchDrv%
echo -e \x0 >> %patchDrv%			## EOF marker for configfile
configfile %patchDrv%
goto :EOF


:: Patches DLL file, %1 = patchDLL, %2 = (hdX,Y), %3 = WinDir
:patchDLL
set dllPath = %2/%3%dll%
call :findWinVer %dllPath%						# Check Windows version
cat --locate=\x64\x86 --number=1 %dllPath% > nul	# Check for 0x6486 to identify 64-bit PE
if "%@retval%"=="1" goto :64BitPatch

:32BitPatch
set patt=\x83\xF8\x10
set rpatt=\x33\xC0\x90
if "%majmin%"=="6.2" set patt=\x3B\xC6\x75\x13 && set rpatt=\x33\xC0\x75\x13
if "%majmin%"=="6.3" set patt=\x4d\x3b\xc6\x0F\x85 && set rpatt=\x4d\x33\xc0\x0F\x85
goto :DoPatch

:64BitPatch
set patt=\x48\x3B\xC6\x0F\x85
set rpatt=\x33\xC0\x90\x0F\x85
if "%majmin%"=="6.2" set patt=\x49\x3B\xC6\x0F\x85 && set rpatt=\x33\xC0\x90\x0F\x85
if "%majmin%"=="6.3" set patt=\x49\x3B\xC6\x0F\x85 && set rpatt=\x33\xC0\x90\x0F\x85

:DoPatch
:: Check whether we can unpatch
cat --locate=%rpatt% --number=1 %dllPath% > nul
if "%@retval%"=="1" goto :warnUserP
cat --hex --locate=%patt% --replace=%rpatt% %dllPath% > nul
if "%@retval%"=="0" goto :warnUserP
echo DLL at %dllPath% patched
goto :EOF

:warnUserP
pause This DLL is not compatible or has been already been patched
configfile %osDrv%
goto :EOF


:: Unpatches DLL file, %1 = patchDLL, %2 = (hdX,Y), %3 = WinDir
:unPatchDLL
set dllPath = %2/%3%dll%
call :findWinVer %dllPath%						# Check Windows version
cat --locate=\x64\x86 --number=1 %dllPath% > nul	# Check for 0x6486 to identify 64-bit PE
if "%@retval%"=="1" goto :64BitUnpatch

:32BitUnpatch
set patt=\x83\xF8\x10
set rpatt=\x33\xC0\x90
if "%majmin%"=="6.2" set patt=\x3B\xC6\x75\x13 && set rpatt=\x33\xC0\x75\x13
if "%majmin%"=="6.3" set patt=\x4d\x3b\xc6\x0F\x85 && set rpatt=\x4d\x33\xc0\x0F\x85
goto :DoUnpatch

:64BitUnpatch
set patt=\x48\x3B\xC6\x0F\x85
set rpatt=\x33\xC0\x90\x0F\x85
if "%majmin%"=="6.2" set patt=\x49\x3B\xC6\x0F\x85 && set rpatt=\x33\xC0\x90\x0F\x85
if "%majmin%"=="6.3" set patt=\x49\x3B\xC6\x0F\x85 && set rpatt=\x33\xC0\x90\x0F\x85

:DoUnpatch
cat --hex --locate=%rpatt% --replace=%patt% %dllPath% > nul
if "%@retval%"=="0" goto :warnUserU
echo DLL at %dllPath% unpatched
goto :EOF

:warnUserU
pause This DLL is not compatible or has been already been unpatched
configfile %osDrv%
goto :EOF


:help
echo -e \nPassPass v1.2 - Idea by jaclaz, Coded by Sherlock
echo Released under the jaclaz's CAREWARE license
echo -e \nUsage: PassPass.g4b [BOOTDEV] | [<MaxDisk#> <MaxPartition#>]\n
echo By default, PassPass tries to search for Windows installations
echo on all but boot device. BOOTDEV switch makes PassPass search boot media, too.
echo If autodetection fails, provide MaxDisk# and MaxPartition# 
echo to forcedetect and guide the script manually 
echo PassPass.g4b script need to be present on the root of the boot media.