{      Programa, ivedus kuriuos nors metus, pvz. 2005       }
{       i ekrana isveda tu metu kalendoriu.                 }

Program kalendorius;
   Uses Crt;

   Type sarasas = array[1..12] of string[18];
   Const menesiai : sarasas = ('     Sausis      ', '     Vasaris     ',
                               '     Kovas       ', '     Balandis    ',
                               '     Geguþë      ', '     Birþelis    ',
                               '     Liepa       ', '     Rugpjûtis   ',
                               '     Rugsëjis    ', '     Spalis      ',
                               '     Lapkritis   ', '     Gruodis     ');
         savaite : array[0..7] of char = (' ', 'P', 'A', 'T', 'K', 'P', #190, 'S');
    var M: word;
        savd: byte;


  Procedure Langas (x1,y1,x2,y2,sp1,sp2: byte);
      begin
        Window(x1,y1,x2,y2);
        TextBackGround(sp1);
        TextColor(sp2);
        ClrScr;
      end; { Langas }

  Procedure start;
    begin
      Window(1,1,80,25);
      TextBackground(0);
      ClrScr;
      GoToXY(35,7);
      Write('Kalendorius');
      GoToXY(55,23);
      TextColor(red+blink);
      WriteLn('[+ENTER+]');
      Readln;
      TextBackGround(black);
      ClrScr;
      TextColor(brown);
      GoToXY(37,7);
      Write('by EWARuDO');
      GoToXY(55,23);
      TextColor(red+blink);
      WriteLn('[+ENTER+]');
      Readln;
      ClrScr;
      GoToXY(25,5); TextColor(4);
      Write('Ivesk metus (pvz. 2005). ');
      GoToXY(27,7);  Write('Metai: ');
      Read(M);
      ClrScr;  GoToXY(79,25);
      Delay(500);
    end;    { Start }

  Procedure design (M: word);
        var i : byte;
      begin
       GoToXY(30,2);    TextColor(red);
       Write(M,' METU KALENDORIUS');
       Langas ( 2, 4, 19,12, white,blue);
       WriteLn (menesiai[1]);
       TextColor(0);      TextBackground (brown);
       For i := 0 to 6 do
         WriteLn(savaite[i]);
       TextColor(4);  Write(savaite[7]);

       Langas (22, 4, 39, 12, white, blue);
       WriteLn (menesiai[2]);
       TextColor(0);      TextBackground (brown);
       For i := 0 to 6 do
         WriteLn(savaite[i]);
       TextColor(4);  Write(savaite[7]);

       Langas (42, 4, 59,12, white, blue);
       WriteLn (menesiai[3]);
       TextColor(0);      TextBackground (brown);
       For i := 0 to 6 do
         WriteLn(savaite[i]);
       TextColor(4);  Write(savaite[7]);

       Langas (62, 4,79,12,white,blue);
       WriteLn ('     Balandis    ');
       TextColor(0);      TextBackground (brown);
       For i := 0 to 6 do
         WriteLn(savaite[i]);
       TextColor(4);  Write(savaite[7]);
  Langas ( 2, 5,19, 5, brown,0);
  Langas (22, 5,39, 5, brown,0);
  Langas (42, 5,59, 5, brown,0);
  Langas (62, 5,79, 5, brown,0);

  Window(15, 24, 65, 25);
  For i := 5 to 12 do
    Write (menesiai[i]);

 end;

  Procedure savaites_diena (var M: word; var savd: byte);     { kelintadienis sausio 1d. }
    begin
      If ((M-2) mod 28=0) or ((M-8) mod 28=0) or               { Pirmadienis }
         ((M-13)mod 28=0) or ((M-19)mod 28=0) then savd := 1;
      If ((M+8) mod 28=0) or ((M+3) mod 28=0) or               { Antradienis }
         ((M-3) mod 28=0) or ((M-14)mod 28=0) then savd := 2;
      If ((M+2) mod 28=0) or ((M-4) mod 28=0) or               { Treciadienis }
         ((M-9) mod 28=0) or ((M-15)mod 28=0) then savd := 3;
      If ((M+7) mod 28=0) or ((M+1) mod 28=0) or               { Ketvietadienis }
         ((M-10)mod 28=0) or ((M-16)mod 28=0) then savd := 4;
      If ((M+6) mod 28=0) or ((M-5) mod 28=0) or               { Penktadienis }
                             ((M-11)mod 28=0) then savd := 5;
      If ((M+5) mod 28=0) or ((M-6) mod 28=0) or               { Sestadienis }
         ((M-12)mod 28=0) or ((M-17)mod 28=0) then savd := 6;
      If ((M+4) mod 28=0) or ((M-1) mod 28=0) or               { Sekmadienis }
         ((M-7) mod 28=0) or ((M-18)mod 28=0) then savd := 7;
    end;


    
  Procedure rodyti (var savd: byte);                   { RODYTI }
      var x,y, d, n: byte;
    begin
      Langas( 62, 6, 79, 12, white, 0);
      y := 1; x := 1;
      TextBackground(white);
      For d := 1 to 12 do
        WriteLn(menesiai[d]);
    end;

  Procedure iseiti;
      var done: boolean;
          sim: char;
    begin
      Done := False;
      Repeat
        sim := ReadKey;
        Case sim of
          #0:  begin
                 sim := ReadKey;
                 Case sim of
                   #16: Done := true;        { Alt-Q }
                   #45: Done := true;        { Alt-X }
                 end;
               end;
               
          #17: Done := true;                { Ctrl-Q }
          #27: Done := true;                { Esc }
        end;
      until done;
    end;
{----------------------  bandymai  -------------------------------------------}

{ --------- kiek dienu turi tam tikras menuo ------------------ }
  Function d_sk(M : word; men : byte): word;
    begin
      Case men of
         1 : d_sk := 31;
         2 : if M mod 4 = 0 then d_sk := 29
                            else d_sk := 28;
         3 : d_sk := 31;
         4 : d_sk := 30;
         5 : d_sk := 31;
         6 : d_sk := 30;
         7 : d_sk := 31;
         8 : d_sk := 31;
         9 : d_sk := 30;
        10 : d_sk := 31;
        11 : d_sk := 30;
        12 : d_sk := 31;
      end; { case of }
    end; { d_sk pabaiga }
    
  Procedure isvesti (var savd : byte; M : word; dalis : byte);
        var x,y, i, k : byte;            // metai ;   skiltis;
    {-----  menesis  -----}
      procedure menesis(kel : byte);
            var posx, posy,      // zymeklio koordinates
                d, n, j: byte;
        begin
          For j := kel to kel + 3 do
            begin
              posy := savd; posx := 1;
              For d := 1 to d_sk(M, j) do
                begin
                 GoToXY(posx,posy);
                 If d <= (8-savd)
                   then n := 2
                   else n := 3;
                 Write(d:n);
                 posy := posy + 1;
                 If posy > 7
                   then begin posx := posx + n; posy := 1; end;
                end;
              savd := savd + d_sk(M, j) mod 7;
              if savd > 7 then savd := savd - 7;
            end;  // for
        end; // proced. menesis
        
    begin
      x := 3;
      Case dalis of
        1 : k := 1;
        2 : k := 5;
        3 : k := 9;
      end;
      For i :=  1 to 4 do
        begin
          Langas( x, 6, x+16,12,white,0);
          x := x + 20;
          Menesis(k);
        end;

      x := 3;
      For i :=  1 to 4 do
        begin
          Langas( x, 17, x+16,23,white,0);
          x := x + 20;
          Menesis(k);
          end;
    end; // isvesti
    
  Procedure vykdymas (var savd : byte; M : word);
        var skiltis : byte;
            pabaiga : boolean;
            sim : char;
    begin                //   M - M              M - M           M - M+1
      Skiltis := 1;     // sausis-rugpjutis, !geguze-gruodis!, rugsejis-balandis,
      Isvesti(savd, M, skiltis);   // isveda M-uju metu sausio - rugpjucio kalendoriu
      Pabaiga := FALSE;
      Repeat
        sim := ReadKey;
        Case sim of
          #0: begin
                sim := ReadKey;
                Case sim of
                  #72: begin                  { Up }
                         skiltis := skiltis - 1;
                       end;
                  #75: begin                  { Left }
                         M := M + 1;
                       end;
                  #77: begin                  { Right }
                         M := M + 1;
                       end;
                  #80: begin                  { Down }
                         skiltis := skiltis + 1;
                       end;
                end; // case
              end; //#0: begin
          #27 : pabaiga := True;
        end;  // Case sim of
        If skiltis < 1 then skiltis := 3;
        If skiltis > 3 then skiltis := 1;
        Isvesti(savd, M, skiltis);
    Until pabaiga;
    end;  // vykdymas
{-------------------------------------  bandymai  -----------------------------}

Begin
  Start;
  Design(M);
  Savaites_diena(M,savd);
  
  Rodyti   (savd);
  Iseiti;
End.
