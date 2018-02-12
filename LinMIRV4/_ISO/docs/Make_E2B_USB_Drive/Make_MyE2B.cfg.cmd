@if not "%DEBUG%"=="1" @echo off
color 1f
TITLE %~n0

::echo %0 "%AUTODRV%" "%AUTOLANG%" "%AUTOKBD%"
::pause

:: set cmd shell window size
if "%1"=="" mode con: cols=120 lines=60

if not "%~d1"=="" set DRIVE=%~d1& goto :cc1

echo.
echo Create MyE2B.cfg configuration file
echo ===================================
echo.

wmic logicaldisk get caption,volumename,description,Size | find "Disk" | sort /+1
echo.
echo.

set ask=%1
if "%ask%"=="" set /P ask=E2B USB Drive Letter? (e.g. E) : 
if "%ask%"=="" goto :EOF

set DRIVE=%ask%:

if exist "%ask%:\_ISO\e2b\grub\menu.lst" goto :cc1
echo.
echo WARNING: Drive %ask%: does not contain E2B (or cannot be accessed)!
echo.
set /P cont=Continue to update? ([N]/Y) : 
if /i not "%cont%"=="Y" goto :eof


:cc1
echo.
echo Create MyE2B.cfg configuration file
echo ===================================
echo.
echo %DRIVE%\_ISO\MyE2B.cfg
echo.
set ask=
if exist %DRIVE%\_ISO\MyE2B.cfg set /p ask=WARNING: A MyE2B.cfg configuration file already exists on %DRIVE% (D=Delete, E=Edit, [ENTER]=Skip) : 
if /i "%ask%"=="E" notepad %DRIVE%\_ISO\MyE2B.cfg
if /i "%ask%"=="D" del %DRIVE%\_ISO\MyE2B.cfg
if exist %DRIVE%\_ISO\MyE2B.cfg goto :EOF
echo.
echo Tip: Press ENTER for default (ENG US) settings.
echo.
echo The %DRIVE%\_ISO\MyE2B.cfg file can contain many configuration settings for Easy2Boot.
echo Please read the \_ISO\Sample_MyE2B.cfg file for details of all possible configuration settings.
echo.

:: -- ASK FOR OPTIONS --

:getlang
if "%DD%"=="" goto :skipr
if exist r.tmp del r.tmp
wmic /LOCALE:ms_409 diskdrive get MediaType,deviceid | find "DRIVE%DD%" > r.tmp 2>nul
find /i "Removable" r.tmp > nul && set DTYPE=REMOVABLE DISK
if not "%DTYPE%"=="" echo INFORMATION: Drive %DRIVE% is of the "%DTYPE%" type
if exist r.tmp del r.tmp
:skipr

echo.
echo.

REM -- LANGUAGES
echo SET LANGUAGE
echo ============
echo.
echo 0  = Default US (choose Keyboard)
echo 1  = Chinese (Traditional)
echo 2  = Chinese (Simplified)
echo 3  = English (UK + UK Keyboard)
echo 4  = English (US + US Keyboard)
echo 5  = French
echo 6  = German
echo 7  = Italian
echo 8  = Polish
echo 9  = Portuguese (Brazilian)
echo 10 = Romanian
echo 11 = Spanish
echo 12 = Swedish
echo 13 = Arabic
echo 14 = Dutch (NL)
echo 15 = Russian
echo.
echo S       = Skip (do not create a MyE2B.cfg file)
echo.
echo [ENTER] = Default (use 'ENG US' settings)
echo.
set ask=0
if "%AUTOLANG%"=="" set /p ask=Please choose a Language (e.g. 4 or S=Skip) : 
if not "%AUTOLANG%"=="" set ask=%AUTOLANG%
if /i "%ask%"=="S" goto :EOF

:: CHECK ANSWER NOT TOO BIG
if %ask% GTR 15 goto :getlang

set LANG=ENG
if "%ask%"=="" set LANG=ENG
if "%ask%"=="1" set LANG=TRAD_CHINESE
if "%ask%"=="2" set LANG=SIMP_CHINESE
if "%ask%"=="3" set LANG=ENG
if "%ask%"=="4" set LANG=ENG
if "%ask%"=="5" set LANG=FRENCH
if "%ask%"=="6" set LANG=GERMAN
if "%ask%"=="7" set LANG=ITALIAN
if "%ask%"=="8" set LANG=POLISH
if "%ask%"=="9" set LANG=PORTU_BRAZIL
if "%ask%"=="10" set LANG=ROMANIAN
if "%ask%"=="11" set LANG=SPANISH
if "%ask%"=="12" set LANG=SWEDISH
if "%ask%"=="13" set LANG=ARABIC
if "%ask%"=="14" set LANG=DUTCH
if "%ask%"=="15" set LANG=RUSSIAN

if "%ask%"=="3" set KBD=KBD_QWERTY_UK.g4b& goto :skipkbd
if "%ask%"=="4" set KBD=& goto :skipkbd

REM -- KBD ---
:getkbd
echo.
echo SET KEYBOARD TYPE
echo =================
echo.
echo 0 = Default (English US)
echo 1 = AZERTY
echo 2 = QWERTZ
echo 3 = English (UK)
echo 4 = English (US)
echo 5 = French  (France)
echo 6 = German  (Germany)
echo 7 = Italian (Italy)
echo 8 = Japan
echo.
set ask=0
if "%AUTOKBD%"=="" set /p ask=Choose a Keyboard type (e.g. 4) : 
if not "%AUTOKBD%"=="" set ask=%AUTOKBD%
if %ask% GTR 8 goto :getkbd

set KBD=
if "%ask%"=="1" set KBD=KBD_AZERTY.g4b
if "%ask%"=="2" set KBD=KBD_QWERTZ.g4b
if "%ask%"=="3" set KBD=KBD_QWERTY_UK.g4b
if "%ask%"=="5" set KBD=KBD_FRENCH.g4b
if "%ask%"=="6" set KBD=KBD_GERMAN.g4b
if "%ask%"=="7" set KBD=KBD_ITALIANO.g4b
if "%ask%"=="8" set KBD=KBD_JAPAN_106.g4b


:skipkbd
REM -- SHOW FILE EXTENSIONS --
echo.
echo SHOW FILENAME EXTENSIONS IN MENU ENTRIES
echo ========================================
echo.
set ask=
if "%AUTOKBD%"=="" set /p ask=Show filename extensions in menu (Y/[N]) : 
if not "%AUTOKBD%"=="" set ask=N
set EXTOFF=1
if /i "%ask%"=="Y" set EXTOFF=
echo.
echo.

:anim
REM -- ADD ANIMATED GIF --
echo.
echo DISPLAY ANIMATED E2B ICON?
echo ==========================
echo.
echo I = E2B icon only 
echo Y = E2B icon + E2B Boiler Plate stamp
echo Q = E2B icon + QR code stamp (Easy2Boot website URL - tested payloads page)
echo N = No rotating icon or stamp
echo.
set ask=
if "%AUTOKBD%"=="" set /p ask=Display rotating E2B icon on menu (I/Y/Q/[N]) : 
if not "%AUTOKBD%"=="" set ask=Y
set ANIM=
if /i "%ask%"=="Y" set ANIM=1
if /i "%ask%"=="I" set ANIM=0
if /i "%ask%"=="Q" set ANIM=Q
echo.
echo.
echo.

if not "%AUTOLANG%"=="" cls
 
echo SUMMARY
echo =======
echo LANGUAGE=%LANG%
if not "%KBD%"=="" echo KEYBOARD=%KBD%
if "%KBD%"=="" echo KEYBOARD=ENG US
if "%EXTOFF%"=="" echo Show filename extensions in menus
if "%EXTOFF%"=="1" echo Do NOT show filename extensions in menus
if /i "%DTYPE%"=="REMOVABLE DISK"  echo Do NOT look for WINHELPER USB Flash drive
if "%LANG%"=="ARABIC" echo ARABIC Right-to-Left (RTL=1)
if "%ANIM%"=="1" echo Show animated E2B icon + Boiler Plate
if "%ANIM%"=="Q" echo Show animated E2B icon + QR code
if "%ANIM%"=="0" echo Show animated E2B icon

echo.
echo.
echo MyE2B.cfg
echo =========
echo !BAT
echo if "%%LANG%%"=="" set LANG=%LANG%
echo set KBD=%KBD%
echo set EXTOFF=%EXTOFF%
if /i "%DTYPE%"=="REMOVABLE DISK"  echo set NOHELPER=1
if "%LANG%"=="ARABIC" echo set RTL=1
if "%ANIM%"=="1" echo set ANIMFD3=/_ISO/docs/Templates/Animate/E2B_GIF.ima
if "%ANIM%"=="1" echo set ANIMATE=0x90=3=9=615=160 (fd3)/frame_0001.bmp
if "%ANIM%"=="1" echo set STAMP1=0x80=570=23 /_ISO/e2b/grub/E2BPlate.bmp
if "%ANIM%"=="Q" echo set ANIMFD3=/_ISO/docs/Templates/Animate/E2B_GIF.ima
if "%ANIM%"=="Q" echo set ANIMATE=0x90=3=9=615=225 (fd3)/frame_0001.bmp
if "%ANIM%"=="Q" echo set STAMP1=0x00=570=23 /_ISO/e2b/grub/QR.bmp
if "%ANIM%"=="0" echo set ANIMFD3=/_ISO/docs/Templates/Animate/E2B_GIF.ima
if "%ANIM%"=="0" echo set ANIMATE=0x90=3=9=615=25 (fd3)/frame_0001.bmp

echo.
set ask=
if "%AUTOKBD%"=="" set /p ask=Write %DRIVE%\_ISO\MyE2B.cfg file? ([Y]/N) : 
if /i "%ask%"=="N" goto :EOF

echo.
echo !BAT>> %DRIVE%\_ISO\MyE2B.cfg
echo # See \_ISO\Sample_MyE2B.cfg for many more settings>> %DRIVE%\_ISO\MyE2B.cfg
echo if "%%LANG%%"=="" set LANG=%LANG%>> %DRIVE%\_ISO\MyE2B.cfg
if "%LANG%"=="ARABIC" (echo set RTL=1)>> %DRIVE%\_ISO\MyE2B.cfg
echo set KBD=%KBD%>> %DRIVE%\_ISO\MyE2B.cfg
echo # ---- ADVANCED MENU SETTINGS ----- >> %DRIVE%\_ISO\MyE2B.cfg
echo set EXTOFF=%EXTOFF%>> %DRIVE%\_ISO\MyE2B.cfg
if /i "%DTYPE%"=="REMOVABLE DISK"  echo # This drive is the removable type - so don't look for a WINHELPER USB Flash drive>> %DRIVE%\_ISO\MyE2B.cfg
if /i "%DTYPE%"=="REMOVABLE DISK"  (echo set NOHELPER=1)>> %DRIVE%\_ISO\MyE2B.cfg

:: Add animated logo
if "%ANIM%"=="1" echo set ANIMFD3=/_ISO/docs/Templates/Animate/E2B_GIF.ima>> %DRIVE%\_ISO\MyE2B.cfg
if "%ANIM%"=="1" echo set ANIMATE=0x90=3=9=615=160 (fd3)/frame_0001.bmp>> %DRIVE%\_ISO\MyE2B.cfg
if "%ANIM%"=="1" echo set STAMP1=0x80=570=23 /_ISO/e2b/grub/E2BPlate.bmp>> %DRIVE%\_ISO\MyE2B.cfg
if "%ANIM%"=="Q" echo set ANIMFD3=/_ISO/docs/Templates/Animate/E2B_GIF.ima>> %DRIVE%\_ISO\MyE2B.cfg
if "%ANIM%"=="Q" echo set ANIMATE=0x90=3=9=615=225 (fd3)/frame_0001.bmp>> %DRIVE%\_ISO\MyE2B.cfg
if "%ANIM%"=="Q" echo set STAMP1=0x00=570=23 /_ISO/e2b/grub/QR.bmp>> %DRIVE%\_ISO\MyE2B.cfg
if "%ANIM%"=="0" echo set ANIMFD3=/_ISO/docs/Templates/Animate/E2B_GIF.ima>> %DRIVE%\_ISO\MyE2B.cfg
if "%ANIM%"=="0" echo set ANIMATE=0x90=3=9=615=25 (fd3)/frame_0001.bmp>> %DRIVE%\_ISO\MyE2B.cfg

REM Notepad %DRIVE%\_ISO\MyE2B.cfg
echo %DRIVE%\_ISO\MyE2B.cfg written OK
