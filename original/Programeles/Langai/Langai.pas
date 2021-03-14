program langu_valdymas;
   uses Crt;
    var Ch: char;
        done: boolean;
        x1,y1,x2,y2,SP1,SP2: byte;


  procedure Pradzia;
    begin
      GoToXY(1,25);
      TextBackground(Black);
      TextColor(White);
      Write(' Alt-N - NewWindow  ',
        #27#24#25#26'-Cursor  ',
        'Alt-L - Legenda  ',
        'Alt-T - RandomText  ',
        'Esc-Exit');
      GoToXY(1,24);
      Write(' Window:',
            ' Alt-C-BgCol',
            ' Ctrl-E/S/D/F-Position ',
            ' Alt-E/S/D/F-Size+',
            ' Alt-U/I/O/K-Size-');
    end; { Pradzia }

  procedure fonosp (var SP1: byte; C1: byte);
      begin
        C1 := SP1;
        C1 := C1 + 1;
        if C1 > 7 then C1 := 0;
        TextBackGround(C1);
        ClrScr;
        SP1 := C1;
      end;
  procedure textsp (var SP2: byte; C2: byte);
      begin
        C2 := SP2;
        C2 := C2 + 1;
        if C2 > 15 then C2 := 0;
        TextColor(C2);
        SP2 := C2;
      end;

  procedure langas (x1,y1,x2,y2,C1:byte);
      begin
        Window (x1,y1,x2,y2);
        TextBackGround(C1);
        ClrScr;
      end;

procedure RandomText;
    begin
      repeat
        Write(Chr(Random(256-32)+32));
      until KeyPressed;
    end; { RandomText }


  Procedure NaujasLangas (var x1,y1,x2,y2,sp1: byte);
      begin
        x1 := Random(60)+1; x2:=x1+20;
        y1 := Random(12)+1; y2:=y1+10;
        sp1:= Random(15);
        Window(x1,y1,x2,y2);
        TextBackground(sp1);
        ClrScr;
      end;
                    { Lango didinimas }
  Procedure plusvirsun(var x1,y1,x2,y2,sp1:byte; C1: byte);
    begin
      C1 := sp1;
      if y1 > 1 then begin            { Alt-E }
         Langas(x1,y1,x2,y2,0);
         y1:=y1-1;
         Langas(x1,y1,x2,y2,C1);
         end;
    end;  {lanp}
   Procedure pluszemyn (var x1,y1,x2,y2,sp1: byte; C1:byte);
    begin
      C1 := sp1;
      if y2 < 23 then begin           { Alt-D }
         Langas(x1,y1,x2,y2,0);
         y2:=y2+1;
         Langas(x1,y1,x2,y2,C1);
         end;
    end;
   Procedure pluskairen (var x1,y1,x2,y2,sp1: byte; C1: byte);
    begin
      C1 := sp1;
      if x1 > 1 then begin            { Alt-R }
         Langas(x1,y1,x2,y2,0);
         x1:=x1-1;
         Langas(x1,y1,x2,y2,C1);
         end;
    end;
  Procedure plusdesinen(var x1,y1,x2,y2,sp1: byte; C1: byte);
    begin
      C1 := sp1;
      if x2 < 80 then begin           { Alt-T }
         Langas(x1,y1,x2,y2,0);
         x2:=x2+1;
         Langas(x1,y1,x2,y2,C1);
         end;
    end;
                        {Lango mazinimas}
   Procedure minuszemyn (var x1,y1,x2,y2,sp1: byte; C1: byte);
     begin
      C1 := sp1;
      if y1 < y2 then begin           {Apacion Alt-K }
         Langas(x1,y1,x2,y2,0);
         y1 := y1 + 1;
         Langas(x1,y1,x2,y2,C1);
         end;
     end;
  Procedure minuskairen(var x1,y1,x2,y2,sp1: byte; C1: byte);
     begin
      C1 := sp1;
      if x1 < x2 then begin           {kairen Alt-U }
         Langas(x1,y1,x2,y2,0);
         x2 := x2 - 1;
         Langas(x1,y1,x2,y2,C1);
         end;
     end;
  Procedure minusvirsun (var x1,y1,x2,y2,sp1: byte; C1: byte);
    begin
      C1 := sp1;
      if y1 < y2 then begin           {Virsun Alt-I}
         Langas(x1,y1,x2,y2,0);
         y2 := y2 - 1;
         Langas(x1,y1,x2,y2,C1);
         end;
    end;
  Procedure minusdesinen (var x1,y1,x2,y2,sp1: byte; C1: byte);
    begin
      C1 := sp1;
      if x1 < x2 then begin           {desinen Alt-O}
         Langas(x1,y1,x2,y2,0);
         x1 := x1 + 1;
         Langas(x1,y1,x2,y2,C1);
         end;
    end;

             { Lango slankiojimas }
  Procedure virsun (var x1,y1,x2,y2: byte; C1: byte);    { Ctrl-E }
    begin
      if y1 > 1 then begin
         Langas(x1,y1,x2,y2,0);
         y1:=y1-1; y2:=y2-1;
         Langas(x1,y1,x2,y2,C1);
         end;
    end;  {virsun}
  Procedure zemyn(var x1,y1,x2,y2: byte; C1: byte);                  { Ctrl-D }
    begin
      if y2 < 23 then begin
        Langas(x1,y1,x2,y2,0);
        y1:=y1+1; y2:=y2+1;
        Langas(x1,y1,x2,y2,C1);
        end;
    end;
  Procedure kairen (var x1,y1,x2,y2: byte; C1: byte);
    begin
      if x1 > 1 then begin                 { Ctrl-S }
      WriteLn('(', x1, ';', y1, ')x(', x2, ';', y2, ')');
         Langas(x1,y1,x2,y2,0);
         x1:=x1-1; x2:=x2-1;
         Langas(x1,y1,x2,y2,C1);
         end;
    end;
  Procedure desinen (var x1,y1,x2,y2: byte; C1: byte);                  { Ctrl-F }
    begin
      if x2 < 80 then begin
         Langas(x1,y1,x2,y2,0);
         x1:=x1+1; x2:=x2+1;
         Langas(x1,y1,x2,y2,C1);
         end;
    end;

  Procedure Legenda(var x1,y1,x2,y2,sp1: byte);
    begin
      Window( 5, 2,76,23);
      TextBackground(0);
      ClrScr;
      TextColor(white);
      GoToXY( 6, 2);
      Write(#27#24#25#26,'-zymeklis,  Home - zymeklis grizta i eilutes pradzia');
      GoToXY( 6, 3);
      Write('Ins-iterpti eilute,  Del-istrinti eilute ');
      GoToXY( 6, 4);
      Write('Ctrl+', #24, '/', #25, ', Ctrl+E/D, - langas paslenkamas Virsun / Apacion');
      GoToXY( 6, 5);
      Write('Ctrl+', #27, '/', #26, ', Ctrl+S/F - langas paslenkamas Kairen / Desinen');
      GoToXY( 6, 6);
      Write('Alt + E/D - padidinamas lango aukstis');
      GoToXY( 6, 7);
      Write('Alt + S/F - padidinamas lango plotis');
      GoToXY( 6, 8);
      Write('Alt + I/K - sumazinamas lango aukstis');
      GoToXY( 6, 9);
      Write('Alt + U/O - sumazinamas lango plotis');
      GoToXY( 6,10);
      Write('Alt + C - keiciama fono spalva');
      GoToXY( 6,11);
      Write('Alt + V - keiciama teksto spalva');
      GoToXY( 6,12);
      Write('Alt-N - naujas langas');
      GoToXY( 6,13);
      Write('Enter - perkelia zymekli i nauja eilute');
      GoToXY( 6,14);
      Write('Alt-T - Random Text');
      GoToXY( 6,15);
      Write('Esc, Alt-X - Exit Program');
      GoToXY(11,20);
      Write(' Noredami grizti spauskit ENTER');
      ReadLn;
      Langas( 1, 1,80,23,0);
      Delay(100);
      NaujasLangas (x1,y1,x2,y2,sp1);
    end;


begin
  Pradzia;
  Window(1,1,80,24);
  sp1 := 0;
  sp2 := sp1 + 1;
  repeat
    Ch := ReadKey;
    case Ch of
     #0:  begin            {Alt+'raide','rodykles',Ins,Del }
           Ch:=ReadKey;
           case Ch of
             #18: plusvirsun (x1,y1,x2,y2,sp1,sp1);     { Alt+E }
             #31: pluskairen (x1,y1,x2,y2,sp1,sp1);     { Alt+S }
             #33: plusdesinen(x1,y1,x2,y2,sp1,sp1);     { Alt+F }
             #32: pluszemyn  (x1,y1,x2,y2,sp1,sp1);     { Alt+D }
             #20: RandomText;
             #22: minuskairen (x1,y1,x2,y2,sp1,sp1);    { Alt-U }
             #23: minusvirsun (x1,y1,x2,y2,sp1,sp1);    { Alt-I }
             #24: minusdesinen(x1,y1,x2,y2,sp1,sp1);    { Alt-O }
             #37: minuszemyn  (x1,y1,x2,y2,sp1,sp1);    { Alt-K }
             #38: Legenda(x1,y1,x2,y2,sp1);
             #25: WriteLn ('Alt-P');
             #30: WriteLn ('Alt-A');
             #34: WriteLn ('Alt-G');
             #35: WriteLn ('Alt-H');
             #36: WriteLn ('Alt-J');
             #45: Done:=True;                           { Alt-X }
             #46: fonosp(SP1,sp1);                      { Alt-C }
             #47: textsp(SP2,sp2);                      { Alt-V }
             #49: NaujasLangas(x1,y1,x2,y2,sp1);        { Alt-N }
             #71: GoToXY(1,WhereY);                      { Home }
             #72: GotoXY(WhereX,WhereY-1);               { Up }
             #75: GotoXY(WhereX-1,WhereY);               { Left }
             #77: GotoXY(WhereX+1,WhereY);               { Right }
             #80: GotoXY(WhereX,WhereY+1);               { Down }
             #82: InsLine;                               { Ins }
             #83: DelLine;                               { Del }
            #115: Kairen(x1,y1,x2,y2,sp1);   { Ctrl + Left }
            #116: Desinen(x1,y1,x2,y2,sp1);  { Ctrl + Right }
            #141: Virsun(x1,y1,x2,y2,sp1);   { Ctrl + Up }
            #145: Zemyn (x1,y1,x2,y2,sp1);   { Ctrl + Down }
           end;
          end;
     #3: Done:=True;                   { Ctrl-C }
     #4: Zemyn (x1,y1,x2,y2,sp1);      { Ctrl-D }
     #5: Virsun(x1,y1,x2,y2,sp1);      { Ctrl-E }
     #6: Desinen(x1,y1,x2,y2,sp1);     { Ctrl-F }
     #19: Kairen(x1,y1,x2,y2,sp1);      { Ctrl-S }
     #13: WriteLn;                     { Enter }
     #27: Done:=True;                  { Esc }
    else Write(Ch);
    end;
  until Done;
  Window(1,1,80,25);
  TextBackground(0);
  TextColor(red);
  ClrScr;
  GoToXY(39,12);
  WriteLn('END');
  Delay(1000);
end.

