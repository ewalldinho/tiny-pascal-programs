program Cezario_sifras_by_EWARuDO;
  Uses Crt, Cezario_sifras;
   Const kiek = 3;
   Type eil = string[15];
        MenuLangas = array[1..5] of byte;
        MenuLangai = array[1..kiek] of MenuLangas;

   Const p : array[1..kiek] of eil = ('Encrypt', 'Decrypt', 'Exit');
         L : MenuLangai = ((5, 3, 25, 3, blue),
                           (5, 5, 25, 5, blue),
                           (5, 7, 25, 7, blue));

  Procedure langas (x1, y1, x2, y2, sp : byte);
    begin
      Window(x1, y1, x2, y2);
      TextBackGround(sp);
      ClrScr;
    end; // langas

{------------------------------------------------------------------------------}
  Procedure perkoduoti (n : byte);
        var F1, F2 :text;
            s : char;
            b1, b2 : string;
    begin
      Langas (39, 1, 75, 24, white);
      Write  (' Bylos, kuria norite ');
      If n mod 2 = 1 then WriteLn('u',#216,#213,'ifruoti')
                     else WriteLn('i',#213,#213,'ifruoti');
      WriteLn(' vardas (*.hid arba *.txt):');   Write(' ');
      ReadLn (b1);
      Write  (' Irasyti i: ');
      ReadLn (b2);
      Assign (F1, b1);  Reset (F1);
      Assign (F2, b2);  Rewrite(F2);
      If n mod 2 = 1
         then while not Eof(F1) do
                begin
                  Read (F1, s);
                  Write(F2, Cezaris(s))
                end
         else while not Eof(F1) do
                begin
                  Read (F1, s);
                  Write(F2, decrypter(s))
                end;
      Close(F1);
      Close(F2)
    end;  // pasirinkti
    
  Procedure pasirinkti;
       var k   : byte;
           jau : boolean;
           sim : char;
    begin
      TextColor(Black);
      For k := 1 to kiek do
        begin
          Langas(L[k,1], L[k,2], L[k,3], L[k,4], L[k,5]);
          Write (' ':4, p[k]);
        end;
      k := 1;
      Langas(L[k,1], L[k,2], L[k,3], L[k,4], Red);  // keiciama punkto k spalva
      Write (' ':4, p[k]);
      jau := FALSE;
      while not jau do
        begin
          sim := ReadKey;               // skaitomas paspausto klaviso kodas
          if sim = #13 then jau := TRUE; // [Enter]
          if sim = #0 then
            begin
              sim := ReadKey;           // antrasis klaviso baitas
              Langas(L[k,1], L[k,2], L[k,3], L[k,4], L[k,5]);
              Write(' ':4, p[k]);
              if sim = #72 then k := k-1;   // virsun
              if sim = #80 then k := k+1;   // apacion
              if k < 1 then k := kiek;      //kai pasiektas meniu virsus
              if k > kiek then k := 1;       //kai pasiekta meniu apacia
              Langas (L[k,1], L[k,2], L[k,3], L[k,4], Red);       //kita spalva uzrasomas punktas k
              Write (' ':4, p[k]);
            end;
        end;
      Case k of
        1..2 : perkoduoti(k);
      end;
    end;   // pasirinkti
    
    
   var byla   : string;
       s      : char;

begin
  Pasirinkti;
  Langas(1, 1, 80, 25 ,0);
  GoToXY(32 ,12);
  TextColor(red);
  WriteLn('P A B A I G A !!');
  Delay(1500)
end.
