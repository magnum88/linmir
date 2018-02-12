Boot Easy2Boot and try the different fonts.

Test 16-high fonts - copy the $FontTest.mnu file to the \_ISO\MAINMENU folder.
OR copy "\_ISO\docs\Sample mnu files\E2B Menus\Change_Font.mnu" to \_ISO\MAINMENU
Test 24-high Large fonts -  copy "\_ISO\docs\Sample mnu files\E2B Menus\Change_Font24.mnu" to \_ISO\MAINMENU

When you find the one that you want
 make a \_ISO\MyE2B.cfg file (See the Sample_MyE2B.cfg file) 
 and add a FONT parameter,
 for example:

24-pixel high fonts end in .f24. sft.f24 and yxt.f24 have English_Chinese (simplified or Traditional), terminal and developer fonts have European glyphs, X11.f24 and lt*.f24 only support English + some European.

If no font is specified, defaul is 16-pixel high unifont
If set FONTH=24, then default 24-pixel high large fonts loaded are stf.f24 + developerbold.f24.

grub4dos 0.4.5c does not support large fonts.

MyE2B.cfg
=========

    !BAT
    # MyE2B.cfg must always start with !BAT
    # set font to ROMAN
    set FONT=()/_ISO/docs/Fonts/ROMAN.uni.gz

If you prefer the BIOS font use 
    set BIOSFONT=1

If you don't need the non-ASCII characters, use
    set NOUNIFONT=1

The fonts in _ISO\docs\Fonts are just characters 0x20-0x7e so English only.
Character codes 0-17 will always be taken from the font file
unless BIOSFONT=1 is used.

To view all the 16-high fonts run \_ISO\docs\Fonts\showfonts.g4b from the grub4dos command line.

You can make 24-pixel high fonts by converting .bdf files to hex files using the MAKE_FONT24.ZIP download (Alternate Downloads - Other Files).

Refer to www.easy2boot.com