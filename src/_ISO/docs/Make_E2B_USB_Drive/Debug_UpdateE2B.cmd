pushd "%~dp0"
cd ..\..\..
set DEBUG=
call "UPDATE_E2B_DRIVE.CMD" | .\_ISO\docs\Make_E2B_USB_DRIVE\wtee .\_ISO\docs\Make_E2B_USB_DRIVE\e2b.log

