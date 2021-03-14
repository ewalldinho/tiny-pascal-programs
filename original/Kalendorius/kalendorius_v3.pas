Program kalendorius_v3;
   Uses Crt, DOS;
   Type metai = array[1..12] of string[17];
        septyni = array[1..7] of string[20];
        langelis = array[1..5] of byte;
        langeliai = array[1..8] of langelis;

   Const men : metai = ('     Sausis  ', '     Vasaris  ', '     Kovas   ',
                        '    Balandis ', '     Geguze   ', '    Birzelis ',
                        '     Liepa   ', '    Rugpjutis ', '    Rugsejis ',
                        '     Spalis  ', '    Lapkritis ', '     Gruodis ');
         lan : langeliai = ((4, 3,20,11, white), (23, 3,39,11, white), (42, 3,58,11, white), (61, 3,77,11, white),
                            (4,15,20,23, white), (23,15,39,23, white), (42,15,58,23, white), (61,15,77,23, white));
         s_d : septyni = ('                 ', 'P', 'A', 'T', 'K', 'P', 'Ð');

  Procedure draw_template;
      var i, j : byte;
    begin
    //---------- langeliai ----------
      For i := 1 to 8 do
        begin
          TextColor(black);
          Window(lan[i, 1], lan[i, 2], lan[i, 3], lan[i, 4]);
          TextBackground(lan[i, 5]);  ClrScr;
          TextBackGround(brown);
          GoToXY(1, 2);
          Write(s_d[1]);
          For j := 2 to 7 do
            WriteLn(s_d[j]);
          TextColor(red);
          Write('S');
        end;
    end;


  Procedure design (M : word);
        var i : byte;
    begin
//      Clrscr;
//      TextBackGround(black);
      For i := 40 downto 1 do
        begin
          draw_template;
          TextBackGround(black);
          Window(   1, 1,  i, 25); ClrScr;
          Window(81-i, 1, 80, 25); ClrScr;
          
//          Window( i, 1, 40, 25); ClrScr;
//          Window(41, 1, 81-i, 25); ClrScr;
//          Window( i, 1, 81-i, 25); ClrScr;
          Delay(50);
        end;
      Window(1, 1, 80, 25);
      TextBackground(black); ClrScr;
      TextColor(red);
      GoToXY(36, 1); Write (M, ' metai');
      GoToXY(36,25); Write ('ESC - Exit');

      draw_template;

      TextColor(black);
    end;  // design

  Function kel (m : word): boolean;  // ar metai 'm' keliamieji
    begin
      kel := (m mod 400 = 0) or
             (m mod 100 <> 0) and (m mod 4 = 0)
// si funkcija tinka tik Grigalijaus kalendoriui, naudojamam daugelyje saliu
    end;  // kel
    
  Function d_sk (M : word; men : byte) : byte;
    begin
      Case men of
         1, 3, 5, 7, 8, 10, 12 : d_sk := 31;
         2 : if kel(M)
               then d_sk := 29
               else d_sk := 28;
         4, 6, 9, 11 : d_sk := 30;
       else write (' ERROR!!! ');
      end;
    end;  // d_sk
    
  Function sav_d (M, men: word) : byte;     { kelintadienis sausio 1d. }
       var i : byte;
    begin
      If ((M-2) mod 28=0) or ((M-8) mod 28=0) or               { Pirmadienis }
         ((M-13)mod 28=0) or ((M-19)mod 28=0) then sav_d := 1;
      If ((M+8) mod 28=0) or ((M+3) mod 28=0) or               { Antradienis }
         ((M-3) mod 28=0) or ((M-14)mod 28=0) then sav_d := 2;
      If ((M+2) mod 28=0) or ((M-4) mod 28=0) or               { Treciadienis }
         ((M-9) mod 28=0) or ((M-15)mod 28=0) then sav_d := 3;
      If ((M+7) mod 28=0) or ((M+1) mod 28=0) or               { Ketvirtadienis }
         ((M-10)mod 28=0) or ((M-16)mod 28=0) then sav_d := 4;
      If ((M+6) mod 28=0) or ((M-5) mod 28=0) or               { Penktadienis }
                             ((M-11)mod 28=0) then sav_d := 5;
      If ((M+5) mod 28=0) or ((M-6) mod 28=0) or               { Sestadienis }
         ((M-12)mod 28=0) or ((M-17)mod 28=0) then sav_d := 6;
      If ((M+4) mod 28=0) or ((M-1) mod 28=0) or               { Sekmadienis }
         ((M-7) mod 28=0) or ((M-18)mod 28=0) then sav_d := 7;
      If M = 1900 then sav_d := 1;
      If M = 1800 then sav_d := 3;
      For i := 2 to men do
        begin
          sav_d := sav_d + d_sk(M, i-1) mod 7;
          if sav_d > 7 then sav_d := sav_d - 7;
        end;
    end;
    
  Procedure langas (k : byte);
    begin
      Window(lan[k, 1], lan[k, 2], lan[k, 3], lan[k, 4]);
      TextBackground(lan[k, 5]);
    end;  // langas

  Procedure langas2 (k : byte);
    begin
      Window(lan[k, 1]+1, lan[k, 2]+2, lan[k, 3], lan[k, 4]);
      TextBackground(lan[k, 5]);
      ClrScr;
      Write('                ');
    end;   // langas 2

  Procedure dienos (M : word; kiek, kur, kuris : byte); // kiek dienu, kur isvesri, kuris menuo
        var d : byte;
            x, y, n :byte;
    begin
      Langas2(kur);
      y := sav_d(M, kuris); x := 1;
      For d := 1 to kiek do
         begin                           //    if d <= 9
           GoToXY(x,y);                  //       then if sav_d >= 6
           If d <= 9
             then if sav_d(M, kuris) >= 6
                     then n := 2
                     else begin
                           if d <= 8 - sav_d(M, kuris)
                             then n := 2
                             else n := 3
                          end
              else n := 3;
           Write(d:n);
           y := y + 1;
           If y > 7 then begin x := x + n; y := 1; end;
         end;
    end;

  Procedure isvesti (var M : word; dalis : byte; M2 : word);
        var i : byte;
    begin
      Window(1, 1,80,25);
      TextBackground(Black);
      TextColor(red);
      GoToXY(36, 1);   Write(M, ' metai');
      GoToXY(36,13);
      If M2 > M
          then Write(M2, ' metai')
          else ClrEoL;
      TextColor(black);
      
      Case dalis of
        1 : begin
              for i := 1 to 4 do       //  sausis - balandis
                begin
                 Langas(i);
                 Write (men[i]);
                 Dienos(M, d_sk(M, i),i,i);
                end;
            end;
        2 : begin
              for i := 5 to 8 do        // geguþë - rugpjûtis
                begin
                 Langas(i-4);
                 Write (men[i]);
                 Dienos(M, d_sk(M, i), i-4, i);
                end;
            end;
        3 : begin                       //  rugsëjis - gruodis
              for i:= 9 to 12 do
                begin
                 Langas(i-8);
                 Write (men[i]);
                 Dienos(M, d_sk(M, i), i-8, i);
                end;
            end;
      end;

      Case dalis of                          //  geguþë - rugpjûtis
        1 : begin
              for i := 5 to 8 do
                begin
                  Langas(i);
                  Write (men[i]);
                  Dienos(M, d_sk(M, i), i, i);
                end;
            end;
        2 : begin                             //   rugsëjis - gruodis
              for i := 9 to 12 do
                begin
                 Langas(i-4);
                 Write (men[i]);
                 Dienos(M, d_sk(M, i), i-4, i);
                end;
            end;
        3 : begin                            //   k. m. sausis - balandis
              for i := 1 to 4 do
                begin
                  Langas(i+4);
                  Write (men[i]);
                  Dienos(M, d_sk(M, i), i+4, i);
                end;
            end;
      end;
    end; // isvesti
  
  Procedure vykdymas (var M : word; var skiltis : byte);
        var pabaiga : boolean;
            sim : char;
            M2 : word;
    begin                   //   M - M              M - M           M - M+1
      Case skiltis of       // sausis-rugpjutis, !geguze-gruodis!, rugsejis-balandis,
        1 : M2 := M;
        2 : M2 := M;
        3 : M2 := M + 1;
      end;
      Pabaiga := FALSE;
      Repeat
        Isvesti(M, skiltis, M2);
        sim := ReadKey;
        Case sim of
          #0: begin
                sim := ReadKey;
                Case sim of
                  #72: begin                  { Up }
                         if skiltis = 1 then M := M - 1;
                         if skiltis = 3 then M2 := M2 - 1;
                         skiltis := skiltis - 1;
                       end;
                  #75: begin                  { Left }
                         M := M - 1;
                         M2 := M2 - 1;
                         If M < 1900 then M := 1900;
                       end;
                  #77: begin                  { Right }
                         M := M + 1;
                         M2 := M2 + 1;
                         If M > 2099 then M := 2099;
                       end;
                  #80: begin                  { Down }
                         if skiltis = 2 then M2 := M2 + 1;
                         if skiltis = 3 then M := M + 1;
                         skiltis := skiltis + 1;
                       end;
                end; // case
              end; //#0: begin
          #27 : pabaiga := True;
        end;  // Case sim of
        If skiltis < 1
           then skiltis := 3;
        If skiltis > 3
           then skiltis := 1;
    Until pabaiga;
    end;  // vykdymas
    
{-------------------------------------  Programa  -----------------------------}
   var M,
       mn,
       d,
       savd : word;
       skiltis : byte;
Begin
  CursorOff;
  GetDate(M, mn, d,savd);
  Design(M);
  
  Case mn of
    1..4 : skiltis := 1;
    5..8 : skiltis := 2;
   9..12 : skiltis := 3;
  end;
  Vykdymas(M, skiltis);
  
  TextBackGround(black);
  For savd := 1 to 40 do
    begin
      Window(1,1, savd,25);
      ClrScr;
      Window(81-savd,1,80,25);
      ClrScr;
      Delay(75);
    end;
  Window(1, 1, 80, 25);
  TextColor(red);
  GoToXY(37, 12);
  WriteLn('The  End');
  Delay(1000)
End.
