# LinMIR
UNE NOUVELLE MOUTURE EST EN PREPARATION Version 4.0.1

LinMIR pour Lin(ux)M(aintenance)I(nformatique)R(éseau)
est un projet GNU GPL libre et en open source.
Il regroupe une pléiade d'outils de diagnostique,
d'administration mais aussi des distributions prête à l'emploi,
tel que des serveurs, des clients stations de travail en live.
Ce produit ne nécessite aucune installation.
Création Clef USB MULTIBOOT BIOS ou EFI
-----------------------------------------------------------------------------------------
Pour Linux:

1. Formater clef USB
sudo mkfs.vfat -n LinMir -F 32 /dev/sdx1
Remplacer sdx1 par votre média
 ou avec GPARTED (Graphiquement ne pas oublier la gestion drapeaux cocher boot)
 
2. entrée dans le projet:
cd \_ISO\docs\linux_utils
sudo chmod 777 *
 
3. transferer le boot sur la clef usb
sudo ./bootlace.com --time-out=0 /dev/sdx
Remplacer sdx par votre média
 
4. copier les fichier sur la clef.
exemple tout le contenu du répertoire src

5. et en fin de projet défragmenter la fat32
sudo perl defragfs.pl /media/user/linmir/ -f
 
Changer /media/user/LINMIR/ par votre chemin
 
6. Test de la clef changer /dev/sdc par votre chemin
sudo qemu-system-x86_64 -machine accel=kvm:tcg -m 512 -hda /dev/sdc
 
Read more: http://www.easy2boot.com/make-an-easy2boot-usb-drive/make-using-linux/
 
-----------------------------------------------------------------------------------------
Pour Windows:
 
1. Insérer votre clef usb 
2. lancer le programme Make_E2B_USB_Drive.cmd mais il faut le lancer en  'Démarrer comme Administrateur...'
3. Au prompt la clef usb sera formter et il installera les fichier pour Easy2Boot démmarage.
4. Puis copier votre projet.
e.g. Copy any ISOs that you want to appear in the first Main menu to \_ISO\MAINMENU  (except Windows Install ISOs)
     Copy linux ISOs to \_ISO\LINUX
     Copy Windows Install ISOs to correct folder under \_ISO\WINDOWS (e.g. Windows 7 ISOs --> \_ISO\WINDOWS\WIN7 folder)
 
5. Puis toujours faire à la fin un défrag démarrer \MAKE_THIS_DRIVE_CONTIGUOUS.cmd (or RMPrepUSB-CTRL+F2). 
