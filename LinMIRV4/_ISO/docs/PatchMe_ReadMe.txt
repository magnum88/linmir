To get rid of annoying grub4dos messages on boot up:

1. Boot to Easy2Boot menu (on a real system or a VM that allows writes to the USB drive such as RMPrepUSB - QEMU)
2. Press SHIFT+p and type in the password (easy2boot) then press SHIFT+c
3. On the grub4dos command line, type /_ISO/docs/patchme
4. Press a key to reboot

This patches the MBR boot code on the grub4dos boot disk and also patches the grldr file.
The patches will persist until you overwrite the grldr file and re-install grub4dos to the MBR.

PatchMyMBR just patches the MBR boot code (it does not patch the \grldr file)