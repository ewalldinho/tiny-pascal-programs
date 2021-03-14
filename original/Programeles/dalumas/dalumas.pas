program dalumas;
  uses CRT;
  function vns_dgs (sk : integer): string;
    begin
      case sk mod 10 of
        0 :
            begin
                vns_dgs := 'skaièiø, daliø';
            end;
        1 : vns_dgs := 'skaièius, dalus';
        else vns_dgs := 'skaièiai, dalûs';
      end;
      if (sk >= 11) and (sk <= 19)
        then vns_dgs := 'skaièiø, daliø';
    end;

  var nuo, iki, sk : longint;
      dal, kiek : integer;
begin
  TextBackground(black);
  TextColor(white);
  ClrScr;
  
  WriteLn('  ------------------------------------------------');
  WriteLn(' | Programa skaièiuoja kiek skaièiø iğ pasirinkto |');
  WriteLn(' | intevalo dalinasi iğ nurodytojo skaièiaus.     |');
  WriteLn('  ------------------------------------------------');
  WriteLn();
  WriteLn('   Intervalas: ');
  Write('       Nuo: ');
  ReadLn(nuo);
  Write('       Iki: ');
  ReadLn(iki);
  Write('   Daliklis: ');
  ReadLn(dal);
{  galima ir taip:  kiek := iki div dal; // ;D }
  for sk := nuo to iki do
    begin
      if sk mod dal = 0
          then kiek := kiek + 1;
    end;
    
  WriteLn('   ---');
  Write  ('   Intervale [', nuo, ';', iki, '] yra ');
  TextColor(green);
  Write(kiek);
  TextColor(white);
  Write(' ', vns_dgs(kiek) );
  WriteLn(' iğ ', dal, '. ');
  WriteLn();
  TextColor(red);
  WriteLn('        [enter]');
  Readln;
end.
