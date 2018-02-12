EASY2BOOT
=========
To make an E2B USB drive: Extract the E2B Zip file to an empty folder and then run \MAKE_E2B_USB_DRIVE (run as admin).cmd.
I recommend formatting the E2B USB drive as NTFS.
Also read \_ISO\docs\Make_E2B_USB_Drive\Make_E2B_USB_Drive.txt.

Please visit www.easy2boot.com for full instructions and watch the YouTube videos.

Afterwards, you can simply copy most bootable files (e.g. .ISO, .IMA, .IMG, .BIN, .VHD, .WIM), to the \_ISO\MAINMENU folder.

WINDOWS INSTALL ISOs should be copied to the correct sub-folder, e.g. \_ISO\WINDOWS\WIN8\Windows8_64.iso.

Always test using a real system NOT a Virtual Machine, because it may not always work on a VM.

Avoid using file names with spaces or special characters such as & or (). Once it works, you can try using file name with spaces, or use a .txt file.
Do not use spaces in the file names of the following types of file: .VHD, .WIM, any linux ISO that uses persistence, any persistence file, any file booted via CONTIG.ISO.

If you get an 'Error 60: File for emulation must be in one contiguous area' message, you must make all the files contiguous. 
To make all files contiguous, just double-click on \MAKE_THIS_DRIVE_CONTIGUOUS.cmd
OR run RMPrepUSB and select the USB drive, then press CTRL+F2 to run WinContig.

UEFI
====
You cannot UEFI-boot directly from an ISO file, you must convert it to a .imgPTN file and then 'switch-in' the image.
You cannot boot via UEFI to the E2B menu system.
To UEFI-boot, you need to convert each ISO to a .imgPTN file using the MPI Tool Kit.
Use the MPI_FAT32 Desktop shortcut to convert the ISO to a FAT32 partition image. 
The ISO must support UEFI-booting and so must contain UEFI boot files.
Copy the .imgPTN file to the E2B USB drive (e.g. \_ISO\MAINMENU).
Double-click on \MAKE_THIS_DRIVE_CONTIGUOUS.cmd to make the file contiguous.
Boot to E2B and select the .imgPTN file from the menu (or run \_ISO\SWITCH_E2B.exe and double-click on the .imgPTN file).
Now the E2B USB drive will directly UEFI-boot (Secure Boot is possible if the UEFI boot files are signed correctly).

Read http://www.easy2boot.com/add-payload-files/adding-uefi-images/

Check http://www.easy2boot.com/add-payload-files/list-of-tested-payload-files/ for a list of supported bootable files.


Windows Vista/7/8/10 Installer ISOs
===================================
Windows Install ISOs must be copied to the correct folder under \_ISO\WINDOWS\xxxxx.

E2B USB Hard Disks:
If your Easy2boot USB drive is of the 'Fixed disk' type (appears as 'Local Disk' in Windows Explorer)
then you also will need a small USB HELPER Flash drive for Windows Vista/7/8/10 installs or WinPE/WinBuilder ISO files to work.
See \_ISO\docs\USB FLASH DRIVE HELPER FILES for details.

If you prefer, you can convert the ISO to a .imgPTN file using MakePartImage (MPI Tool Kit) - then a USB Helper Flash drive is not needed and UEFI-booting may also work.

\_ISO\CONTIG.ISO (500MB)
========================
This file is used by E2B if your ISO and other payload files are below 500MB and are not contiguous.
\_ISO\CONTIG.ISO needs to be contiguous to work.
E2B will copy a non-contiguous ISO file into CONTIG.ISO so that it will be contiguous and it will then boot from that copy.
If you always make sure all your payload files are contiguous (e.g. use  \MAKE_THIS_DRIVE_CONTIGUOUS.cmd or run RMPrepUSB - WinContig (Ctrl+F2)) 
then you can delete CONTIG.ISO to save 500MB of space.

\_ISO\SWITCH_E2B
================
This is a Windows 32-bit utility which allows you to switch-in or switch-out .imgPTN image partition files.
See http://www.easy2boot.com/add-payload-files/makepartimage/ and http://www.easy2boot.com/add-payload-files/switch-e2b/
for more information

\_ISO\E2B_Editor.exe
====================
This is a Windows 32-bit utility which allows you to design your own menu.
You can load a background wallpaper .bmp (or .jpg) file and specify a config file.
E2B uses \_ISO\MyE2B.cfg as the user confog file (if it exists).
See http://www.easy2boot.com/configuring-e2b/e2b-editor/ for more details.

To change wallpaper, language, main heading, text colours, etc. copy \_ISO\Sample_MyE2B.CFG to \_ISO\MyE2B.CFG - then edit MyE2B.cfg.

To change other headings and menu text do NOT edit any of the E2B files (otherwise you will lose the changes if you update E2B later).
See http://www.easy2boot.com/configuring-e2b/changing-the-e2b-preset-text/ for details on how make any changes.

\_ISO\TXT_Maker.exe
===================
Each payload file can have a .txt file of the same file name which specifies a menu entry (and hotkey) for it.
The text in the .txt file will be used for the menu entry, instead of the name of the actual payload file.
The TXT_Maker.exe Windows GUI utility allows you to create .txt files for your payload files.
Just drag-and-drop a payload file onto the blank area and then fill in the Menu entry and Help lines as required.

Please visit www.easy2boot.com for full instructions.
