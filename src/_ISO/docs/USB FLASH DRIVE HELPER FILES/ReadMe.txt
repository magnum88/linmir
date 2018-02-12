Easy2Boot works best with a USB Flash drive that is of the 'Removable' type (as listed by RMPrepUSB).

If you are using a USB HARD DISK DRIVE or a USB FLASH DRIVE that is listed by Windows Explorer as a 'Local Disk',
then Windows Install ISOs won't work correctly (you will not get the blue LOADISO.CMD console window
and you will get a Windows Install message about 'a required CD\DVD drive device driver is missing').

Please copy the other files in this folder to the root of a spare 'helper' USB Flash drive (which must appear as a removable drive in RMPrepUSB).

When you boot from the Easy2Boot USB drive and run a Windows Vista/7/8/2012/SVR2K8R2 install, make sure the 'Helper' USB Flash drive is also connected.

It is important that \WINHELPER.USB only exists on the USB Flash drive and not on any hard disk or CD-ROM in the system.
It is important that the Easy2Boot \_ISO\e2b folder is not present on the 'Helper' USB drive.

Required files for HELPER flash drive
=====================================
\WINHELPER.USB
\Unattend.xml
\AutoUnattend.xml


E2B_WinHelper_&DW.zip
=====================

If you have a IODD 2531 or IODD 2541, unzip this file to E2B_WinHelper_&DW.RMD.
Now load the file using the IODD. 
You will now have a virtual Removable USB drive which you can use with E2B. A real WINHELPER flash drive is not required.