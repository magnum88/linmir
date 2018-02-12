@echo off
:: get_win8key.exe can be downloaded from github.com/christian-korneck/get_win8key#files
:: Right-click - Properties - UnBlock  before using the file
:: Must be run as Admin
pushd "%~dp0"
set PKEY=
get_win8key.exe > WINKEY.txt
set /p PKEY=<WINKEY.txt
if not "%PKEY%"=="" (
echo Activating using key %PKEY%
cscript //NoLogo %systemroot%\system32\slmgr.vbs /ipk %PKEY% > act.log
cscript //NoLogo %systemroot%\system32\slmgr.vbs /ato >> act.log
type act.log
)
popd
