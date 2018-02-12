@Echo off
if not exist %~d0\_ISO\docs\Boot_Me_Using_QEMU\QEMU_BOOT_ME.cmd  echo ERROR: Please run this from the E2B USB drive! & pause & exit
%~d0\_ISO\docs\Boot_Me_Using_QEMU\QEMU_BOOT_ME.cmd