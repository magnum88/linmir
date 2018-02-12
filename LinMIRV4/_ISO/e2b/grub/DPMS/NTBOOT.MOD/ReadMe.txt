NTBOOT
======
NTBOOT allows you to boot directly to a Win7/8/10 .WIM, .VHD, .VHDX file and others
http://chenall.net/post/ntboot/

For copyright reasons, bootmgr is not included in the Easy2Boot download but it is required for NTBOOT NT6 support.

Note: If you use MAKE_E2B_USB_DRIVE.CMD or UPDATE_E2B_DRIVE.CMD then bootmgr will be copied from C:\ if it is available.

For NT6 VHD and WIM booting to work, the \_ISO\e2b\grub\DPMS\NTBOOT.MOD folder should contain the bootmgr file.



FULL NTBOOT SUPPORT in Easy2Boot
================================

The NTBOOT version in Easy2Boot does not support NT5 (XP) booting unless you add extra files from the NTBOOT download.

e.g. Support for wimpe1, imgXP, .imgNT5, .VHDNT5 and .VHDXNT5 all require extra files and folders.

DOWNLOAD: http://chenall.net/post/ntboot/

Copy all the files from inside the NTBOOT.MOD folder to the Easy2Boot \_ISO\e2b\grub\DPMS\NTBOOT.MOD folder. 

The following missing files are not included in E2B for copyright reasons:
	\_ISO\e2b\grub\DMPS\NTBOOT.MOD\NTBOOT.NT5
	\_ISO\e2b\grub\DMPS\NTBOOT.MOD\NTBOOT.PE1 
	\_ISO\e2b\grub\DMPS\NTBOOT.MOD\VBOOT.ISO
You will also need to copy the NTBOOT.LST and NTBOOT.IMG folders too:
	\_ISO\e2b\grub\DMPS\NTBOOT.LST
	\_ISO\e2b\grub\DMPS\NTBOOT.IMG

You can make your own .mnu files that use NTBOOT: e.g.

	title NT5.x From IMG (ramdisk)
	call NTBOOT NT5=/BOOT/ramdisk.IMG
	boot

	title NT5.x (PE) From iso/img etc.
	call NTBOOT pe1=/boot/imgs/xppe.is_
	boot

	title NT6.X From VHD
	call NTBOOT NT6=/boot/boot.vhd
	boot

	title NT6.X (PE3) From WIM
	call NTBOOT NT6=/boot/imgs/win7pe.wim
	boot

	title Boot From VHD (vboot)
	call NTBOOT vboot=/boot/vboot.vhd
	boot

	title Setup Windows from ISO to HDD (FiraDisk)
	call NTBOOT iso_inst=firadisk cdrom=/Win$.iso
	boot

	title Setup Windows from ISO to HDD Step 1 (vboot)
	call NTBOOT iso_inst=vboot cdrom=/WinXp.iso
	boot

	title Setup Windows from ISO to HDD Step 2 (vboot)
	call NTBOOT iso_inst=vboot cdrom=/WinXp.iso boot=harddisk
	boot

Type NTBOOT at the grub4dos command line to see Usage syntax.
