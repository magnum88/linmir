LZMA_ENCODE and LZMA_DECODE
===========================

LZMA encoding compresses a file.
LZMA files are usually smaller than .gz files.
grub4dos will automatically decompress LZMA-compressed files.
This means that you can 'hide' the contents of a file from prying eyes by LZMA-encoding it.

For instance, you can encode your \_ISO\MyE2B.cfg file which may contain a password setting.
Other suitable files that you can encode are .bmp, .hdr, .lst, .g4b, .mnu and .txt file extension.


e.g. to compress a .bmp file...

fred.bmp  >>  fred.bmp (now in lzma format)  + fred.bmp.orig  (original uncompressed file)


INSTRUCTIONS
============

1. In WIndows Explorer, select the file())s you want to encode on your E2B drive (but do not select PAYLOAD FILES such as .ISO files)

2. Drag-and-drop the selected files onto the LZMA_ENCODE.CMD file

A copy of the original is made as .orig

3. You can choose to keep the original un-encoded backup file(s) (.orig) or delete it.

The file will now be LZMA encoded but will be the same file name as it was before.

You can restore the file to it's uncompressed form by repeating the process using LZMA_DECODE.CMD. A backup (.comp) can be deleted or kept.


Note: If you update your E2B USB drive with a later version of E2B, any encoded E2B files will be replaced with the original text files.

