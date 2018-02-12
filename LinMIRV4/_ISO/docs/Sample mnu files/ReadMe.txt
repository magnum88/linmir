

To use a .mnu file
==================

1. Copy it to a menu folder (typically \_ISO\MAINMENU\MNU)
2. Copy the payload file (e.g. xxxx.iso) to the same folder
3. Open the \_ISO\MAINMENU\MNU\xxxx.mnu file in Notepad and follow the instructions inside


IMPORTANT: PLEASE READ THE INSTRUCTIONS INSIDE EACH OF THE .mnu FILES
The instructions will vary depending on the function of the .mnu file.

Save .mnu files as a UTF-8 files if you want to use non-ASCII characters in the titles.

You can place .mnu and payload files in the \_ISO\MAIMMENU folder or sub-folders - e.g. \_ISO\MAINMENU\MNU

If a payload file (e.g. xxx.iso) is at the 2nd folder level (e.g. \_ISO\LINUX folder) then it will be listed in the menu as well as the .mnu file (i.e. you will see two entries).
If a payload file is at the 3rd folder level or lower (e.g. \_ISO\LINUX\FRED) then only the .mnu file will appear in the menu - the payload file itself will not be listed.

For example, if the instructions say to place files in the \_ISO\xxxx\Utility folder:
If you place the .mnu file and .iso file in the \_ISO\MAINMENU\Utility folder, the entry will be listed in the Main Menu.
If you place the .mnu file and .iso file in the \_ISO\BACKUP\Utility folder, the menu entry will be listed in the BACKUP menu.
If you place the .mnu file and .iso file in the \_ISO\UTILITIES\Utility folder, it will be listed in the UTILITIES sub-Menu.
If you place the .mnu file and .iso file in the \_ISO\UTILITIES_MEMTEST\Utility folder, it will be listed in the UTILITIES - MEMTEST Sub-Sub-Menu.


SPECIAL KEYWORDS
================
%MFOLDER% will always be replaced with the \_ISO\xxx folder (2nd level) - e.g. \_ISO\LINUX.
$HOME$ will always be replaced with the same folder that the .mnu file is in - e.g. \_ISO\LINUX.
$NAME$ will always be replaced with the filename of the .mnu file (without the file extension) - e.g. Ubuntu14.01  if the file is Ubuntu14.01.mnu.

See http://www.easy2boot.com/add-payload-files/list-of-tested-payload-files/ to see if a .mnu file is required for any particular payload.

