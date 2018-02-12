Use this theme to gives you a Main menu with Vista, Win7, Win8, Win10 specific ISO installs and XP installs all in the Main Menu.
The XP menu will ask the user to pick an ISO (or auto-pick if only one ISO).


Example Main Menu
=================

Install XP - Step 1
Install XP - Step 2
Install XP - Step 2

Install XP using WinPE

Install Win7 SP1 32-bit
Install Win8.1 32-bit

ubuntu.iso (if added to \_ISO\MAINMENU)
DOS Menu        [Ctrl+D]
UTILITIES Menu  [Ctrl+U]
Help            [F1]



No '0 set default menu' entry
No Install Windows menu entry
Menu entries are not numbered
Add your own \_ISO\MyBackground.bmp 800x600 bitmap.
It has no messages on startup
If you copy FASTLOAD.YES to the root of the E2B drive then Ctrl+R hotkey will cause a refresh.

INSTRUCTIONS
============

1. Copy MyE2B.cfg to \_ISO

2. If you don't want the UTILITIES and DOS menus, then delete the contents of the \_ISO\BACKUP, DOS and UTILITIES folders

3. Add the MAINMENU\$$xxxx files to \_ISO\MAINMENU and edit the $$AddWin2Main.mnu to match the ISOs that you have - add more entries if you wish

4. Add your other ISOs and payload files to \_ISO\MAINMENU (or \_ISO\Linux or \_ISO\xxxx) as usual
   Windows Install ISOs must go in the correct folder under \_ISO\WINDOWS\xxx as usual (or you can edit MFOLDER for a different path).

5. Delete any $$Addxxxxxx.mnu files you don't want.

6. As there is no 'Set default menu and timeout' menu entry (due to set DEFMENU=0), if you want to pre-set defaults for the Main menu,
   make a new \_ISO\menu_defaults.txt file and add the following text lines (edit as required)

# set default menu item number to fourth entry
default 3
# set default main menu timeout
timeout -1
#prevent menu number from being displayed in top right of menu
debug 0

7. Edit the MyE2B.cfg file to suit your needs and add your own Background .bmp file.

Tip: If you leave just one .xml file in the VISTA/Win7/SVR2K8/Win10 folders, then it will be automatically picked.

See also \_ISO\docs\Sample mnu files  folder for other Windows install menus, e.g.
XP_Inst_from_MainMenu.mnu  will make XP menu entries for one specific XP ISO.
