Program Gronsfeldo_shifras;

  Procedure Gronsfeldas(r : integer;   // raktas, 5-zenklis skaicius
                        var prad, rez : text);
      Const DMr = 'AÀBCÈDEÆËFGHIÁYJKLMNOPRSÐTUØÛVZÞ' +
                  'aàbcèdeæëfghiáyjklmnoprsðtuøûvzþ';
            Rsk = 3*2;
       Type Skaitmuo = 0..9;
       var s : char;
           raktas : array[0..4] of Skaitmuo;
           i : 0..4;     // raktø masyvo indeksas
     Function sifr (s : char; r : skaitmuo): char;
                // duotos raides sifravimas raktu r
          var i : integer;
        begin
          if pos(s, DMr) <> 0
            then sifr := DMr[(pos(s, DMr) + r - 1) mod Rsk +1];
        end;  // funkcija sifr
        
    begin  // Gronsfeldas
      for i := 4 downto 0 do
        begin
          raktas[i] := r mod 10;
          r := r div 10
        end;
      i := 0;
      while not EoF(prad) do
        begin
          Read (prad, s);
          if pos(s, DMr) <> 0
            then begin
                   s := sifr(s, raktas[i]);
                   i := (i + 1) mod 5
                 end;
          Write(rez, s);
          if EoLn(prad)
            then begin
                   ReadLn(prad);
                   WriteLn(rez);
                 end;
        end;
    end;

  var F1, F2 : text;
Begin
  Assign(F1, 'slapta.dat'); Reset  (F1);
  Assign(F2, 'slapta.txt'); Rewrite(F2);
  Gronsfeldas(11111, F1, f2);
  Close(F1);
  Close(F2);
  Readln
End.
