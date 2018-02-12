DisableRemovableDriveIndexing.reg         - Modifies your Win8/10 Registry so \System Volume Information folder is not created on USB drives
Undo_DisableRemovableDriveIndexing.reg    - Restore normal Windows behaviour (creates \System Volume Information folder)

http://rmprepusb.blogspot.co.uk/2016/09/disabling-system-volume-information.html

To delete the System Volume Information folder:

1. Disable the 'Storage Service'
2. Install the Registry Fragment
3. Reboot
4. Press WINKEY+X - click on "Computer Prompt (Admin)"
5. From an Admin command prompt, type rd /s "L:\System Volume Information" to delete the folder on the L: drive if it is already there (or whatever letter your USB drive is using).

