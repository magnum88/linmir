http://reboot.pro/files/file/320-passpass/

PassPass patches a Windows DLL on the Windows partition so that when you boot, local account passwords are not checked.
It does not work for Domain or 'cloud' logins using an email address - only for local accounts.
Version 4.7 works on Windows XP/7/8/8.1/10

Copy the whole PassPass folder to \_ISO\UTILITIES folder on E2B USB drive.

To use it, copy the files in this folder to an E2B sub-menu folder - e.g. \_ISO\UTILITIES\PASSPASS

1. MBR-boot to E2B and select the PassPass menu entry.
2. Next, select the Windows partition and make a backup of the DLL (first menu entry)
3. Then Patch the DLL on the Windows partition
4. Now you can boot to Windows from the internal hard disk and any password will be accepted.
5. Next, create an Administrator account.
6. Next, log out and log back in on the new Administrator account.
7. You now have full access.
8. Now restore the DLL by booting to E2B, run PassPass an choose the UnPatch option.
   If, for any reason this does not work, restore the previous backup (as long as you are sure that it is the correct backup that you made previously)

If you need to access a GPT partition, you may need to boot to WinPE and then run PEPassPass from WinPE to patch the DLL.
http://reboot.pro/files/file/533-pepasspass/

Latest version of PEPassPass for XP-Win10 is available from E2B website - Alternate Downloads area.