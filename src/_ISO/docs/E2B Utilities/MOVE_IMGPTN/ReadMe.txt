Instructions for MOVE_IMGPTN (run as admin).cmd
===============================================

Note: SWITCH_E2B.exe will perform the same function as this script, when you switch to a .imgPTN file.


See http://www.easy2boot.com/add-payload-files/adding-windows-install-isos-without-needing-a-helper-flash-drive/

Method 4 - MBR and UEFI install of large >4GB Install.wim files

Method 4 requires the NTFS .imgPTN file to be first on the E2B USB drive.

e.g. required order of files on E2B drive
  [..... WinABC.imgPTN ....... WinABC ......]

Both the xxxxx.imgPTN and the xxxxx files must be present.
The E2B USB drive must be formatted as NTFS.


How to use MOVE_IMGPTN
======================

1. Copy this whole folder to your Windows desktop
2. Create a new shortcut for the file "MOVE_IMGPTN (run as admin).cmd"
3. Right-click - Properties on the shortcut file and set Advanced - Run as Administrator
4. Drag-and-drop any partition image file onto the shorcut

e.g. if you have:
F:\_ISO\MAINMENU\Win81Install.imgPTNLBAa        - NTFS image
F:\_ISO\MAINMENU\Win81Install                   - FAT32 image

drag-and-drop F:\_ISO\MAINMENU\Win81Install.imgPTNLBAa onto "MOVE_IMGPTN (run as admin).cmd - Shortcut"

The script will check the two file positions and move them if required until the file without a file extension is located after the .imgPTN file.
