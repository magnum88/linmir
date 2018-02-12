pushd "%~dp0"
if not exist SDI*.exe echo ERROR: SDI EXECUTABLES ARE MISSING! Please extract the SDI download to the %~p0 folder & pause & goto :EOF
call :RUNSDI %1 %2 %3 %4 %5 %6 %7 %8 %9
popd
goto :EOF

:RUNSDI
rem EXECEPTION: 32-bit version of SDI cannot run on Windows PE x64.
rem 64-bit version is faster and doesn't have the 2GB RAM per process limitation.
IF %PROCESSOR_ARCHITECTURE% == x86 (IF NOT DEFINED PROCESSOR_ARCHITEW6432 goto bit32)
goto bit64
:bit32
echo 32-bit
set xOS="R"
goto cont
:bit64
echo 64-bit
set xOS="x64_R"
:cont

for /f "tokens=*" %%a in ('dir /b /od "%~dp0SDI_%xOS%*.exe"') do set "SDIEXE=%%a"
if exist "%~dp0%SDIEXE%" (
   start /wait "Snappy Driver Installer" /d"%~dp0" "%~dp0%SDIEXE%" -verbose:511 -license -expertmode -norestorepnt -showdrpnames2 -norestorepnt -nosnapshot %1 %2 %3 %4 %5 %6 %7 %8 %9
   goto :eof
) else (
 echo.
 echo 'Snappy Driver Installer' NOT FOUND!
 echo.
 timeout 6
 goto :eof
)
