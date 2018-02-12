::https://www.google.com/intl/en/chrome/business/browser/admin/#

IF NOT EXIST %SystemRoot%\SysWOW64 start /w msiexec.exe /i "C:\DRIVERS\APPS\GoogleChromeStandaloneEnterprise32.msi" /q /norestart
IF EXIST %SystemRoot%\SysWOW64     start /w msiexec.exe /i "C:\DRIVERS\APPS\GoogleChromeStandaloneEnterprise64.msi" /q /norestart

