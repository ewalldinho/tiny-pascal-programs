Unit Cezario_sifras;

interface

  Function Cezaris (s : char): char;
  Function decrypter (s : char): char;
  
implementation

{--------------- S-I-F-R-A-V-I-M-A-S ------------------------------------------}
  Function Cezaris (s : char): char;
     Type alphabet = array[1..3] of string;
     Const Dr = 'AÀBCÈDEÆËFGHIJKLMNOPRSÐTUØÛVZÞ';
           Mr = 'aàbcèdeæëfghijklmnoprsðtuøûvzþ';
           Ks = ',<!=";/\>.(-&_% `?)012345+6789*@#$^:';
           abc : alphabet = (Dr, Mr, Ks);
       var nr  : integer;  // simbolio vieta eiluteje
           sim : shortstring;
           i   : byte;
    begin
      sim := s;
      If pos(s, abc[1]) <> 0
        then begin
               nr := pos(s, abc[1]);
               i := 1
             end
        else if pos(s, abc[2]) <> 0
               then begin
                      nr := pos(s, abc[2]);
                      i := 2
                    end
               else begin
                      nr := pos(s, abc[3]);
                      i := 3
                    end;
      if nr <> 0
        then if nr = length(abc[i])
               then sim := copy(abc[i], 2, 1)             //  Z keièiama su A
               else if nr = length(abc[i])-1
                      then sim := copy(abc[i], 1, 1)      //  Þ keièiama su À
                      else sim := copy(abc[i], nr+2, 1);  //  n + 2
      Cezaris := sim[1]
    end;  // Cezaris

  Function decrypter (s : char): char;
     Type alphabet = array[1..3] of string;
     Const Dr = 'AÀBCÈDEÆËFGHIJKLMNOPRSÐTUØÛVZÞ';
           Mr = 'aàbcèdeæëfghijklmnoprsðtuøûvzþ';
           Ks = ',<!=";/\>.(-&_% `?)012345+6789*@#$^:';
           abc : alphabet = (Dr, Mr, Ks);
       var nr  : integer;  // simbolio vieta eiluteje
           sim : shortstring;
           i   : byte;
    begin
      sim := s;
      If pos(s, abc[1]) <> 0
        then begin
               nr := pos(s, abc[1]);
               i := 1
             end
        else if pos(s, abc[2]) <> 0
               then begin
                      nr := pos(s, abc[2]);
                      i := 2
                    end
               else begin
                      nr := pos(s, abc[3]);
                      i := 3
                    end;
      if nr <> 0
        then if nr = 1                                            // kai pirmas
               then sim := copy(abc[i], length(abc[i])-1, 1)      //  A keièiama su Z
               else if nr = 2                                     // kai antras
                      then sim := copy(abc[i], length(abc[i]), 1) //  À keièiama su Þ
                      else sim := copy(abc[i], nr - 2, 1);      //  n + 2
      Decrypter := sim[1]
    end;  // Cezaris decrypter
    
begin
end.
