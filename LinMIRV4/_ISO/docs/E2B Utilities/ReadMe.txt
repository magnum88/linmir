http://rmprepusb.blogspot.co.uk/2014/02/how-to-quickly-make-easy2boot-txt-and.html

E2B TXT Maker.cmd            - generates an Easy2Boot .txt file
E2B MNU Maker.cmd            - generates an Easy2Boot .mnu file
E2B SUBMENU Maker.cmd        - generates a .mnu file from a \_ISO\xxxx new folder - use if you want a new SubMenu in the Main Menu
DelSysFiles.cmd              - deletes the "\System Volume Information" folder and other difficult files from a drive to allow copying\access
LZMA folder                  - encode or decode E2B files such a MyE2B.cfg or MyBitmap.bmp for security or compression purposes
MD5 folder                   - find the MD5 value of a string to use as an MD5-encrypted password
Protect                      - scripts to protect essential files on your E2B drive from being viewed/modified/deleted
Fribidi                      - used to convert right-to-left language UTF-8 text files for E2B
WinNTSetup                   - WinNTSetup should be copied into this folder. Used for installing Windows after booting to WinPE
Disable_System_Volume_Information_Folder_Creation - stop Windows from making this folder (use with care!)
Convert Unicode file to UTF8 - guess!
MOVE_IMGPTN folder           - Windows script to re-order a pair of partition image files - e.g. win81.imgPTN and win81.

The easiest way to use these files is to first copy this folder to your Windows Desktop.

E2B TXT Maker and MNU Maker
===========================
Now to make a .txt file or .mnu file for any payload file on your E2B USB drive, simply Drag-and-Drop the payload file onto the E2B TXT Maker.cmd icon or the E2B MNU Maker.cmd icon on your Windows Desktop. 
The script will then ask you what menu text and help text you want and then make a new .mnu or .txt file (in the same folder as the payload file) on your E2B USB drive. 
You can specify a hotkey key by using ^^ before the keyname (^^ will be translated into ^ when the file is made).

Note: You may prefer the \_ISO\TXT_Maker.exe utility which does the same job as E2B TXT Maker.cmd.

E2B SUBMENU Maker.cmd
=====================
If you want to make a new SubMenu folder:

1. Create a new folder under \_ISO (spaces not allowed) - e.g.  \_ISO\RESCUE_WIN
2. Drag-and-drop the new \_ISO\RESCUE_WIN folder onto the E2B SUBMENU Maker.cmd file and answer the questions

OR double-click on the E2B SUBMENU Maker.cmd file and you will be prompted for the name of the subfolder that you want to create.

This will make a new .mnu file in the \_ISO\MAINMENU folder for \_ISO\RESCUE_WIN.
Now put your ISO files, etc. in the \_ISO\RESCUE_WIN folder and you will see the new menu entry appear in the Main Menu.

MOVE_IMGPTN
===========
Scenario:
\_ISO\MAINMENU\Win81.imgPTN    (NTFS)
\_ISO\MAINMENU\Win81           (FAT32)
>>> You find that you get no UEFI boot option from the system, even though the EFI boot files are present in one or both partition images.

This script is only needed if you have a pair of partition image files such as Win81.imgPTN and Win81.
For UEFI-booting, the .imgPTN file must be located on the E2B drive before the file that has no file extension - otherwise you may not get a UEFI boot option from your system UEFI firmware.
This script re-orders the two files.
You can also re-order the two files by selecting the .imgPTN file using \_ISO\SWITCH_E2B.exe.