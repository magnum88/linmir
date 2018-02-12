@echo off
echo Reset Permissions on all files on a drive

set D=
set /p D=Enter Drive Letter (e.g. U:) : 
if "%D%"=="" goto :EOF
if /i "%D%"=="C" goto :EOF

if not "%D:~-1,1%"==":" set D=%D%:

echo Run commands: icacls %D%\* /setowner %username% /T /C /Q  and  icacls %d%\* /reset /T /C /Q
set /p sure=Are you sure (Y/N) : 
if /i "%sure%"=="Y" (
cls
icacls %D%\* /setowner %username% /T /C /Q
icacls %d%\* /reset /T /C /Q
)

dir %D%\*.lst /Q
echo.
if exist %D%\menu.lst icacls %D%\menu.lst /Q
echo.
if exist %D%\_ISO\MyE2B.cfg icacls %D%\_ISO\MyE2B.cfg /Q
echo.
echo Finished!
pause