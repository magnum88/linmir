DPMS Automatic Driver Detection (DPMS/SRS)for E2B
=================================================

If installing XP to a system which has a SATA (AHCI), SCSI or RAID storage system, XP Setup will need to install a Mass Storage Driver.
If this is not done, the internal hard disk(s) will not be listed by XP setup. See www.rmprepusb.com Tutorial 72b for more details.

To add auto-driver detection to E2B:

1. Download the latest Mass Storage Driver Pack for XP x86 NT5 from http://driverpacks.net/driverpacks/windows/xp/x86/mass-storage
  e.g. Currently: Sep. 24 2012  Windows 200/XP/2003  x86 Mass Storage version 12.09     (DP_MassStorage_wnt5_x86-32_1209.7z)
   Click on the Download button which will download a Torrent file for the 7z file 
   Use BitTorrent (or your favourite Torrent app) to download the .7z file (double-click on the torrent file)

2. Use 7Zip to extract the contents of the 7zip file to your USB drive at \_ISO\E2B\grub\DPMS using 7Zip or some other utility.

3. Rename the file at \_ISO\e2b\grub\DPMS\DriverPack_MassStorage_wnt5_x86-32.ini to \_ISO\e2b\grub\DPMS\DriverPack.ini

\_ISO\e2b\grub\DPMS\driverpack.ini      (renamed by you)
\_ISO\e2b\grub\DPMS\D                   empty folder (only M folder)
\_ISO\e2b\grub\DPMS\D\M                 folder containing driver folders (e.g. I3, I4, V, etc.) extracted by you from the DP_MassStorage_wnt5_x86-32_XXXX.7z)

Note: 
The files oem0.txt and oem1.txt will contain copies for the two oemsetup.txt files used by the previous install. 
The files dir0.txt and dir1.txt will contain directory listings of the two floppies.
These files can be inspected after an unsuccessful install or sent to me for problem solving - do not change their size or delete them.

email: rmprep@gmail.com

Donations for this software can be made via PayPal - please visit the www.rmprepusb.com website to make a donation if you enjoy using this software!





