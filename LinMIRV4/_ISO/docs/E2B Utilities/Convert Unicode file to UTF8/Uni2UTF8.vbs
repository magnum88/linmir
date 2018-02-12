Option Explicit

' If unicode file, output file new file as UTF-8

Private Const adReadAll = -1
Private Const adSaveCreateOverWrite = 2
Private Const adTypeBinary = 1
Private Const adTypeText = 2
Private Const adWriteChar = 0

Private Sub UNItoUTF8(ByVal UTF8FName, ByVal ANSIFName)
  Dim strText

  With CreateObject("ADODB.Stream")
    .Open
    .Type = adTypeBinary
    .LoadFromFile UTF8FName
    .Type = adTypeText
    .Charset = "Unicode"
    strText = .ReadText(adReadAll)
    .Position = 0
    .SetEOS
    .Charset = "utf-8"
    .WriteText strText, adWriteChar
    .SaveToFile ANSIFName, adSaveCreateOverWrite
    .Close
  End With
End Sub


'0000 FF FE 61 00 61 00 20 00 - 66 00 72 00 65 00 64 00  ÿþa.a. . f.r.e.d.   unicode

Function encoding(path) 
 With  CreateObject("ADODB.Stream") 
 .Open 
 .Type = 1 
 .LoadFromFile path 
 Dim data : data = .Read
 .Close 
 End With 
Dim a 
 a = Hex(AscB(MidB(data, 1, 1))) 
 Dim b
 b = Hex(AscB(MidB(data, 2, 1))) 
 Dim c
 c = Hex(AscB(MidB(data, 3, 1))) 
Wscript.Echo "Header bytes 1=" & a & " 2=" & b & " 3=" & c
 encoding = "ANSII"  ' (not UTF-8 or UTF-16 unicode)
 'U+FEFF | U+FFEE 
 If (a = "FE" AND b = "FF") OR (a = "FF" AND b = "FE") Then encoding = "UTF-16" 
 If a = "EF" AND b = "BB" AND c = "BF" Then encoding = "UTF-8" 
' If a = "FF" AND b = "FE" Then encoding = "unicode" 
 End Function 


Dim x
x = encoding(WScript.Arguments(0))
Wscript.echo "File=" & x 
if x = "UTF-16" Then UNItoUTF8 WScript.Arguments(0), WScript.Arguments(1)
if x = "UTF-16" Then Wscript.Echo "Converted to UTF-8"
