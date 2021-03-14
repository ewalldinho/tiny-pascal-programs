Program html_gimtadieniai;
  Uses Crt;
  Type sablonai = array[1..9] of string;
  Const sab : sablonai =('<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">',
        '<html>',
        ' <head>',
        '  <meta http-equiv="Content-Type" content="text/html; charset=windows-1257"/>',
        '  <title> Gimtadieniai </title>',
        ' </head>',
        ' <body bgcolor="white" text="black" link="blue">',
        ' </body>',
        '</html>');

  Procedure langas(x1, x2, y1, y2, sp : byte);
    begin
      Window(x1, x2, y1, y2);
      TextBackground(sp);
      ClrScr;
    end; // langas

  Procedure design(sk : word);
    begin
      Langas(1,1,80, 1, blue);
      TextColor(black);
      Langas( 1, 2,80,25, green);
      GoToXY( 1, 3); WriteLn(sk:6, '.');
      TextColor(white);
      GoToXY(64, 3); Write('-');
      GoToXY(68, 3); Write('-');
      TextColor(black);
      Langas(1,2,80, 2, yellow);
      Write('Eil.Nr.  Vardas    |', '| Pavarde          |', '| Klase |', '| Gimimo Metai-Men-Diena |');
      Langas(10, 4,19, 4, white); WriteLn(' '); // vardo laukelis
      Langas(22, 4,39, 4, white); WriteLn(' '); // pavardes
      Langas(42, 4,48, 4, white); WriteLn(' '); // klases
      Langas(59, 4,63, 4, white); WriteLn(' '); // gimimoe metai
      Langas(65, 4,67, 4, white); WriteLn(' '); // menuo
      Langas(69, 4,71, 4, white); WriteLn(' '); // diena
      Langas( 1,25,80, 25, black);
      GoToXY(36,1);  TextColor(white);
      Write('ESC - Exit');
      TextColor(black);
    end;  // design

  Procedure gimtadieniai(var v : string[12]; var p: string[18];
                         var k : string[5]; var m, men, d : string; eilNr : word);
    begin
      Design(eilNr);
      Langas(10, 4,19, 4, white);  ReadLn(v);   Write(v);
      v := v + '            ';
      Langas(22, 4,39, 4, white);  ReadLn(p);   Write(p);
      p := p + '            ';
      Langas(42, 4,48, 4, white);  ReadLn(k);   Write(k);
      k := k + '     ';
      Langas(59, 4,63, 4, white);  ReadLn(m);   Write(m);
      Langas(65, 4,67, 4, white);  ReadLn(men); Write(men);
      Langas(69, 4,71, 4, white);  ReadLn(d);   Write(d);
    end; //gimtadieniai

  Procedure viskas (var ar : boolean);
        var sim : char;
    begin
      Langas(26, 10, 56, 16, lightgray);   // LightGray = 7;  DarkGray = 8;
      TextColor(red);
      WriteLn(' 1. press any Key to continue ');
      WriteLn(' 2. press "ESC" to Exit  ');
      sim := ReadKey;
      If sim = #27
        then ar := TRUE;
    end;  // tikrinti

    
  Var F1 : text;
      rezFailoPav : string;
      vardas  : string[12];
      pavarde : string[18];
      klase : string[5];
      pabaiga : boolean;
      metai, men, d : string;
      nr : word;  // eilės numeris
      i : integer;

Begin
  Write('  Rezultatu failo pavadinimas: ');
  ReadLn(rezFailoPav);
  Write('  Pradeti nuo nr = ');
  ReadLn(nr);
  rezFailoPav := '' + rezFailoPav;
  Assign(F1, rezFailoPav);
  {$I-}
  Rewrite(F1);
  {$I+}
  if IOResult <> 0
  then begin
    WriteLn('Nepavyko atverti/sukurti failo "', rezFailoPav, '".');
    Halt(0);
  end;
  For i := 1 to 7 do
    WriteLn(F1, sab[i]);
//  nr := 1;
  pabaiga := FALSE;
  Repeat
    Write (F1, '<b>', nr:3,'.</b> ');
    Gimtadieniai(vardas, pavarde, klase, metai, men, d, nr);
    WriteLn(F1, vardas, pavarde, klase, metai, '-', men:2, '-', d:2, ' <br>');
    nr := nr + 1;
    viskas(pabaiga);
  Until pabaiga;
  For i := 8 to 9 do
    WriteLn(F1, sab[i]);
  Close(F1);
  
  Langas(1, 1, 80, 25, black);
  Delay(1000);
End.
