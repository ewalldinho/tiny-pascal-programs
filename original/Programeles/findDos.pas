Program Example7;
uses Dos;

{ Program to demonstrate the FindFirst and FindNext function. }

var
  direktorija : SearchRec;
begin
  FindFirst('*.txt',archive,direktorija);
  WriteLn('FileName'+Space(12),'FileSize':9);
  while (DosError=0) do
   begin
     Writeln(direktorija.Name + Space(20 - Length(direktorija.Name)), direktorija.Size:9);
     FindNext(direktorija);
   end;
  FindClose(direktorija);
  
  ReadLN;
end.
