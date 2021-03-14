Program datos_isvedimas;
  Type metai = 1583..5000;
       menuo = 1..12;
       diena = 1..31;
       data = record
                m : metai;
                mn : menuo;
                d : diena;
              end;
       savdienos = (pir, ant, tre, ket, pen, ses, sek);
       savd = array [0..6] of string[12];
  Const dias : savd = ('sekma', 'pirma', 'antra', 'trecia', 'ketvirta',
                       'penkta', 'sesta');

  Function kel (m : metai): boolean;  // ar metai 'm' keliamieji
    begin
      kel := (m mod 400 = 0) or
             (m mod 100 <> 0) and (m mod 4 = 0)
// si funkcija tinka tik Grigalijaus kalendoriui, naudojamam daugelyje saliu
    end;  // kel

  Function dmen (m : metai; mn : menuo) : integer;
                  // kiek dienu turi 'm' m. mn menuo
    begin
      if (mn = 4) or (mn =  6) or
         (mn = 9) or (mn = 11)
        then dmen := 30
        else if mn = 2
                then if kel(m) then dmen := 29
                               else dmen := 28
                else dmen := 31;
    end;  // dmen
  Procedure rasyti (d : data);
    begin
      Write (d.m,                            // metai
             (d.mn div 10):2, d.mn mod 10:1, // menuo
              d.d div 10: 2, d.d mod 10: 1)
    end;  //rasyti

  Function ankstesne (a,b: data): boolean;
      // tikrina ar data a ankstesne uz data b
    begin
      If a.m < b.m then ankstesne := true
        else if a.m > b.m then ankstesne := false
          else if a.mn < b.mn then ankstesne := true
            else if a.mn > b.mn then ankstesne := false
              else if a.d < b.d then ankstesne := true
                else ankstesne := false
    end;  // ankstesne
    
  Function dienos(d1, d2 : data): integer;
         // dienu skaicius nuo 'd1' iki 'd2', 'd2' velesne data
      var x, y, z : integer;
    function dskmet(d1, d2 : data): integer;
         var d, m : integer;
      begin
        d := 0;
        for m := d1.m to d2.m-1 do
          if kel(m) then d := d + 366
                    else d := d + 365;
        dskmet := d
      end; // dskmet
    function dsk (dd : data): integer; // dienu skaicius nuo dd.m pradzios iki dd
         var d_sk, min : integer;
      begin
        d_sk := 0;
        for min := 1 to dd.mn-1 do
          d_sk := d_sk + dmen(dd.m, min);
        dsk := d_sk + dd.d
      end;
    
    begin
      x := dskmet(d1, d2);
      y := dsk(d1);
      z := dsk(d2);
      dienos := x - y + z;
    end;  // dienos

  Function savdiena (dt : data): string; // randa duotos datos savaites diena
       var zd : data; // data kurios savaites diena sekmadienis
    begin
      zd.m := 2000; zd.mn := 1; zd.d := 2;
      If ankstesne(zd, dt)
        then savdiena := dias[dienos(zd, dt) mod 7]
        else savdiena := dias[dienos(dt, zd) mod 7]
    end; //sav diena
    
  var d : data;
Begin
  Write ('  Metai: ');  ReadLn(d.m);
  Write ('  menuo: ');  ReadLn(d.mn);
  Write ('  diena: ');  ReadLn(d.d);
  Rasyti(d);
  WriteLn;
  If kel(d.m) then writeln(d.m, 'm. - keliamieji.')
              else writeLn(d.m, 'm. - nekeliamieji.');
  WriteLn('Savaites diena: ', savdiena(d), 'dienis');
  Readln
End.
