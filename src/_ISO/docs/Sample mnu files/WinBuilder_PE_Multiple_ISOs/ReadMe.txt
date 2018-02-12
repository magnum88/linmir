
You can have multiple WinBuilder ISOs of slightly different builds all on one E2B drive.

This folder is an example (without the WBSS_x86.ISO file).

Typical File arrangement
========================

\Win7PESE.ini                      <--- Taken from WinBuilder ISO folder (keep filename same)

\_ISO\MAINMENU\WBSS\WinSS_x86.iso  <--- you can change this name if you like
\_ISO\MAINMENU\WBSS\WinSS_x86.WB   <--- this filename MUST match the ISO filename
\_ISO\MAINMENU\WBSS\WinSS_x86.mnu  <--- you can change this name (does not need to match the ISO name)

Each WinBuilder ISO is coded to look for a particular INI file in the root of the USB drive (the name will vary depending on the Project).
There should be a .INI file in the same folder as the .ISO when you build it.
Copy the INI file to the root of your E2B drive.

IMPORTANT: The INI file must be 1K bytes or more (for use on NTFS E2B drives) so add spaces to the end - it's contents are overwritten by E2B

Please read the .mnu file under .\_ISO\MAINMENU\WB1 for more instructions.

AVOID FILENAMES WITH & or ( or ) or other strange characters as these may cause problems!
