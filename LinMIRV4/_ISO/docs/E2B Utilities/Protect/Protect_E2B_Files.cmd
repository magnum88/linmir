@echo off
title Protect sensitive E2B files
echo.
REM add more to this list
pushd "%~dp0"
if not exist \_ISO\e2b\grub\E2B.cfg (echo NOT AN E2B DRIVE!& pause&goto :EOF)

if exist \_ISO\MyE2B.cfg call protect.cmd \_ISO\MyE2B.cfg
call protect.cmd \menu.lst
call protect.cmd \_ISO\e2b\grub\E2B.cfg 
call protect.cmd \_ISO\e2b\grub\menu.lst 
call protect.cmd \_ISO\e2b\grub\QRUN.g4b 
call protect.cmd \_ISO\e2b\grub\QAUTO.g4b 
call protect.cmd \_ISO\e2b\grub\tp.g4b

set F=\_ISO\MAINMENU\$$$$CONFIG\$$$$GUEST_MENU_ESC_PWD.mnu
if exist %F% call protect.cmd %F%
set F=\_ISO\MAINMENU\$$$$CONFIG\$$$$GUEST_MENU_PWD.mnu
if exist %F% call protect.cmd %F%
set F=\_ISO\MAINMENU\$$$$CONFIG\$$$$GUEST_MENU_F4.mnu
if exist %F% call protect.cmd %F%

popd
REM clear CMD so prompt user for action in running from console
set CMD=
set F=

