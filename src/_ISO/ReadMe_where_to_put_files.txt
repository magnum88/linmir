WHERE TO PUT YOUR PAYLOAD FILES
===============================

Copy your payload (e.g. .iso) file to a Menu folder.

For a simple test just copy an ISO file to \_ISO\MAINMENU folder then run \MAKE_THIS_DRIVE_ CONTIGUOUS.cmd.

Notes: 
	Windows Install ISOs ->>  correct \_ISO\WINDOWS\xxxx folder.
	DO NOT USES SPACES IN FILE NAMES (most payloads will work if there are spaces in the filename, but some do not work).
	Remember to run \MAKE_THIS_DRIVE_CONTIGUOUS.cmd after copying payload files.

Check http://www.easy2boot.com/add-payload-files/list-of-tested-payload-files/ for a complete list of all tested payload files and any special instructions.

1. Normal Menu folders
======================
Payload files (e.g. .iso) can be put in any 2nd level (\_ISO\xxxx) folder. 
They will be automatically added to a menu.
E2B does not automatically search for payload files BELOW these folders, it only looks at the 2nd level folder.
E2B will search for .mnu (menu) files in the 2nd level folders AND ALL FOLDERS BELOW THESE FOLDERS.

1.1 Main Menu folder
====================
\_ISO\MAINMENU is the folder that holds payload files for the Main Menu.
\_ISO\MAINMENU\MNU can be used for special .mnu files + payload files. Payload files in this folder are not automatically added to the Main menu - so you must use a .mnu file.

1.2 Sub-Menu folders
====================
Pre-defined Sub-Menu folders are: ANTIVIRUS, BACKUP, DOS, BACKUP, DOS, LINUX, UTILITIES, WIN, WINPE
These behave in an identical way to the \_ISO\MAINMENU folder, except that they are sub-menus.

Sub-menu entries will only appear in the Main menu if the folder contains one or more folders or files.

1.3 Sub-Sub-Menu folders
========================
\_ISO\UTILITIES_MEMTEST folder is a sub-menu of the UTILITIES sub-Menu.
This behaves in an identical way to the \_ISO\MAINMENU folder, except that it will appear in the MEMORY TEST sub-menu of the UTILITIES Menu.

1.4 Special Folders
===================
\_ISO\AUTO    - Can be used only for most payload files (all payload files in all sub-folders are listed in the menu) Note: all .mnu files are ignored.
\_ISO\WINDOWS - Only for Windows Install ".ISO" and ".imgPTN" files (must go in correct sub-folder) - e.g. \_ISO\WINDOWS\WIN8\Win864-bit.iso or \_ISO\WINDOWS\WIN10\Win10x86Pro.imgPTN
                Note: Windows XP Install .imgPTN files are NOT supported in the \_ISO\WINDOWS\XP folder.

2. About .txt and .mnu files
============================
PAYLOAD FILES + .txt files  - .txt filename must match payload file - e.g. ubuntu.iso + ubuntu.txt
PAYLOAD FILES + .mnu files  - normally belong in the MNU subfolder (.mnu filenames do not need to match payload filename)

2.1 Examples
============

\_ISO\ANTIVIRUS
 fred.iso   <- will be auto-detected
 fred.txt   <- will be used as the menu entry title for fred.iso if present (filename must be same)

\_ISO\ANTIVIRUS\MNU
 jim.iso    <- will NOT be auto-detected because not at top level of a menu folder (must use a .mnu file)
 jim.mnu    <- will be auto-detected and added to the menu (filename does not need to match the .iso)

.mnu files are detected at the 2nd level and below.
Payload files (.iso, etc.) are only auto-detected at the 2nd level (top level of a menu folder).

NOTE: WINDOWS INSTALLER ISOs must go in the correct sub-folder under \_ISO\WINDOWS.
      e.g. a Windows 7 Install ISO goes in \_ISO\WINDOWS\WIN7.
	  Windows Installer ISOs will not work correctly unless in a \_ISO\WINDOWS\xxxx folder (3rd level).


2.2 .mnu files
==============
.mnu files must start with 'title' or 'iftitle'.

If a .mnu file uses 'iftitle' then the test case in square brackets must be TRUE for the menu to appear. e.g.

  iftitle [if exist $HOME$/Ubuntu_32.iso] Ubuntu 32-bit Live CD \n Boot to Ubuntu

The menu entry 'Ubuntu 32-bit Live CD' will only be listed in the menu if Ubuntu_32.iso is in the same folder as the .mnu file.
.mnu files are detected at the 2nd folder level and all levels below that level.
$HOME$ when used in a .mnu file means 'current path of this .mnu file' - e.g. /_ISO/ANTIVIRUS.
$NAME$ when used in a .mnu file means 'filename, without extension, of the .mnu file' - e.g. Ubuntu_32.iso
You can use $HOME$/$NAME$.iso as a 'portable' file specification. The .mnu filename must match the .iso filename.
Any text afte \n defines the help text that appears under the menu.

2.3 .txt files
==============
.txt files can start with 'title' or 'iftitle'.
A .txt file should consist of a single line of text only, example:

  title here is the menu entry\n here is the help text below the menu\n here is the 2nd line of help

The filename of the .txt file must exactly match the name of the payload file (e.g. ubuntu123.iso and ubuntu123.txt).
.txt files only work at the 2nd folder level in Menu folders (\_ISO\xxxx) or in the \_ISO\WINDOWS\xxxx folders
Any text afte \n defines the help text that appears under the menu.

3. MORE INFORMATION
===================
If a .mnu file is placed in a valid menu folder at \_ISO\xxxx (2nd level) or anywhere below, it will be auto-detected by Easy2Boot.

WARNING: If a .mnu + .iso file are both placed in \_ISO\xxxx, you will get TWO MENU ENTRIES, one for the .mnu file and one for the .iso file.

For this reason, typically a ISO file and .mnu file are usually placed at the 3rd level - e.g. \_ISO\LINUX\MNU.

Please visit www.easy2boot.com for more information.