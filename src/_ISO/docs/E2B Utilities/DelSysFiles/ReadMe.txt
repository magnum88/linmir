DelSysFiles (run as admin).cmd
==============================

This script deletes the "\System Volume Information" folder and then creates a "\System Volume Information" file to prevent the folder from being created again by the OS.

It also changes the attributes on all files in the root to remove Hidden, System and ReadOnly attributes.

It also deletes the following files (if they exist)
\$RECYCLE.BIN
\hiberfil.sys
\swapfile.sys
\pagefile.sys
\RECYCLER

This results in all the files and folders on the drive being accessible and able to be copied.

You may also find the InstallTakeOwnership.reg fragment useful - it adds a right-click Explorer menu option to allow you to change the access rights of any file or folder.
