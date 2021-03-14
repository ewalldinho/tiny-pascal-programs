Program perkodavimas;   { Windows --> DOS }
  Const kodas : array[128..255] of 0..255 =
                (126, 126, 126, 126, 247, 126, 126, 126,   // 128 - 135
                 126, 126, 126, 126, 126, 126, 126, 126,   // 136 - 143
                 126, 126, 239, 242, 166, 126, 126, 126,   // 144 - 151
                 126, 126, 126, 126, 126, 126, 126, 126,   // 152 - 159
                 255, 126, 150, 156, 159, 126, 167, 245,   // 160 - 167
                 157, 168, 138, 174, 170, 240, 169, 146,   // 168 - 175
                 248, 241, 253, 252, 126, 230, 244, 250,   // 176 - 183
                 155, 251, 139, 175, 172, 171, 243, 145,   // 184 - 191
                 181, 189, 160, 128, 142, 143, 183, 237,   // 192 - 199
                 182, 144, 141, 164, 149, 232, 161, 234,   // 200 - 207
                 190, 227, 238, 224, 226, 229, 153, 158,   // 208 - 215
                 198, 173, 151, 199, 154, 163, 207, 225,   // 216 - 223
                 208, 212, 131, 135, 132, 134, 210, 137,   // 224 - 231
                 209, 130, 165, 211, 133, 233, 140, 235,   // 232 - 239
                 213, 231, 236, 162, 147, 228, 148, 246,   // 240 - 247
                 214, 136, 152, 215, 129, 164, 216, 126);  // 248 - 255
                 
  var prad,
      rez   : file of char;
      bvard : string;       // bylos vardas
      s     : char;
Begin
  WriteLn('Pradiniu duomenu byla (Windows): ');
  ReadLn (bvard);
  Assign (prad, bvard);  Reset(prad);
  WriteLn('Rezultatu byla (DOS): ');
  ReadLn(bvard);
  Assign (rez, bvard);  Rewrite(rez);
  While not EoF(prad) do
    begin
      Read(prad, s);
      if Ord(s) >= 128 then s := Chr(kodas[ord(s)]);
      Write(rez, s)
    end;
  Close(prad);
  Close(rez)
End.