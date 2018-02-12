pushd "%~dp0"
set DEBUG=1
"make_e2b_usb_drive.cmd" | wtee e2b.log
