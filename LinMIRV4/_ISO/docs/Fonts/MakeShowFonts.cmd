@echo off
color 1f
cls
echo.
echo This Windows batch file generates a demo ShowFonts.g4b grub4dos batch file
echo.
pause


echo !BAT > showfonts.g4b
echo graphicsmode -1 1024 >> showfonts.g4b
echo errorcheck off >> showfonts.g4b
echo clear >> showfonts.g4b
echo set F=BIOS >> showfonts.g4b
echo font >> showfonts.g4b
echo call :demo >> showfonts.g4b
echo errorcheck on >> showfonts.g4b
echo set F=/_ISO/e2b/grub/unifont.hex.gz >> showfonts.g4b
echo call :demo >> showfonts.g4b

for %%a in (/_ISO/docs/Fonts/*.gz) do echo set F=/_ISO/docs/fonts/%%a ;; call :demo >> showfonts.g4b

echo exit>> showfonts.g4b
echo. >> showfonts.g4b
echo :demo >> showfonts.g4b
echo font >> showfonts.g4b
echo echo Testing %%F%% >> showfonts.g4b
echo font %%F%% >> showfonts.g4b

echo ^echo 0123456789 !£$%^^&^(^)^_^+^-^=^[^]^{^}^:^@^~^;^'^#^<^>^?^,^.^/ abcdefghijklmnopqrstuvwxyz ABCDEFGHIJKLMNOPQRSTUVWXYZ >> showfonts.g4b
echo goto :eof >> showfonts.g4b
echo. >> showfonts.g4b
