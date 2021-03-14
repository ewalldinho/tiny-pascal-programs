(************************)
{
   programa: EWARuDO logo - paremta Komenskio principais
   autorius: Evaldas Naujanis
   metai: 2005
}

Program vezlio_and_EWARuDO_logo;
  Uses Graph, Grafika;
  
  const N = 6;
        v : array[0..N] of string = ('pabaiga', 'padek', 'priekin', 'atgal',
                                     'kairen', 'desinen', 'kartok');

   var x,y, laips : real;

{ Randa komanda ir gràþina per parametrus }
  Procedure Komanda (var ka : integer; var kiek : real);
        var uzd,
            veik : string;
            i    : integer;
    begin
      ReadLn(uzd);               // skaito komanda ir komandos parametra
      veik := '';
      i := 1;
      ka := -1;  // kol kas neaiðku, ar ivesta gera komanda
      kiek := 0;

      // atskiria komanda nuo parametro
      While (i <= Length(uzd)) and (uzd[i] <> ' ') do
        begin
          veik := veik + uzd[i];
          i := i + 1
        end;
      uzd := Copy(uzd, i, Length(uzd));

      For i := 0 to N do             // iesko ar yra tokia komanda
        if veik = v[i] then ka := i;
      For i := 1 to Length(uzd) do   // skaiciuoja argumento reiksme
        if uzd[i] in ['0'..'9']
          then kiek := kiek * 10 + (Ord(uzd[i]) - 48);
    end; // komanda

{ ----- Pradþia - inicijuoja pradines reikðmes ----- }
  Procedure pradzia;
    begin
      x := 0; y := 0;    // vezlys vidury ekrano
      laips := 0;        // ziuri i virsu
      MoveTo(GetMaxX div  2, GetMaxY div 2)
    end;  // pradzia
    
{ ----- pagalba ----- }
  Procedure padek;
    begin
      WriteLn('+--- Pagalba --------------------+');
      WriteLn('|                                |');
      WriteLn('| Suprantamu komandu sarasas:    |');
      WriteLn('|  * priekin atstumas            |');
      WriteLn('|  * atgal atstumas              |');
      WriteLn('|  * kairen kampas               |');
      WriteLn('|  * desinen kampas              |');
      WriteLn('|  * padek - rodoma pagalba      |');
      WriteLn('|  * pabaiga - isjungti          |');
      WriteLn('|                                |');
      WriteLn('| Atstumas nurodomas pikseliais  |');
      WriteLn('| Kampas nurodomas laipsniais    |');
      WriteLn('+--------------------------------+');
    end;
  
{ ----- Pirmyn ----- Atgal ----- }
  Procedure priekin (ilgis : real);
    begin
      x := x + ilgis * sin(Pi * laips / 180);
      y := y + ilgis * cos(Pi * laips / 180);
      if x < -400 then x := 400;
      if y < -300 then y := 300;
      WriteLn('(x = ',GetMaxX div 2 + round(x),', y = ',GetMaxY div 2 - round(y),')');
      LineTo(GetMaxX div 2 + round(x), GetMaxY div 2 - round(y))
    end;  //priekin
    
  Procedure atgal (ilgis : real);
    begin
      x := x - ilgis * sin(Pi * laips / 180);
      y := y - ilgis * cos(Pi * laips / 180);
      LineTo(GetMaxX div 2 + round(x), GetMaxY div 2 - round(y))
    end;  // atgal
    
{ ----- Kairen ----- Desinen ----- }
  Procedure kairen (kampas : real);
    begin
      laips := laips - kampas;
      While laips >= 360 do laips := laips - 360;
      While laips   <  0 do laips := laips + 360
    end;  // kairen

  Procedure desinen (kampas : real);
    begin
      laips := laips + kampas;
      While laips >= 360 do laips := laips - 360;
      While laips   <  0 do laips := laips + 360
    end;  // desinen
    
  Procedure VykdytiKomanda(komandosNumeris : integer; parametras : real);
    begin
        Case komandosNumeris of
            1 : padek;
            2 : priekin(parametras);  // priekin
            3 : atgal  (parametras);  // atgal
            4 : kairen (parametras);  // kairen
            5 : desinen(parametras);  // desinen
            { 6 : kartok (parametras); }
        end;
    end;
    
{ ----- kartojimas: kol kas kartoja tik viena komanda ----- }
  Procedure kartok (kiekKartu : real);
      var kom, i : integer;
          kiek : real;
    begin
        Write('Komanda (kuria kartoti): ');
        Komanda(kom, kiek);

        if (kom > 0) and (kom < 6) then
        begin
            i := 0;
            while i < kiekKartu do
            begin
                VykdytiKomanda(kom, kiek);
                i := i + 1;
            end;
        end
        else begin
            WriteLn('Nurodyta nesuprantama arba netinkama komanda.');
        end;
    end;

{  Procedure ratas (zingsnis : real);
        var i : integer;
    begin
      for i := 1 to 360 do
        begin
          priekin(zingsnis);
          desinen(1)
        end
    end;
    
  Procedure sukinys (dydis : real; kiek : integer);
        var i : integer;
    begin
      for i := 1 to kiek do
        begin
          ratas(dydis);
          desinen(360 / kiek)
        end
    end;   // sukinys}



   var  mx, my : integer;
        ende : boolean;
        i   : integer;
        kom : integer;
        kiek : real;

Begin
  Ekranas(mx,my);
  Pradzia;
  ende := FALSE;
  WriteLn(' ------------------------------------------------------------------');
  WriteLn('|Jusu komanda (parametro reiksme)  | padek - komandu sarasas       |');
  WriteLn('|------------------------------------------------------------------|');
  repeat
    Komanda(kom, kiek);
    Case kom of
      0 : ende := TRUE;    // PABAIGA
      1 : padek;
      2 : priekin(kiek);  // priekin
      3 : atgal  (kiek);  // atgal
      4 : kairen (kiek);  // kairen
      5 : desinen(kiek);  // desinen
      6 : kartok (kiek);
      else begin
          WriteLn('EWARuDO nesuprato Jusu komandos :(  bandykit dar karta');
          WriteLn('Jei nezinote komandu iveskite ''padek''');
      end;
    end;
  until ende;
  
//  Sukinys(1, 20);  // kol kas suspenduotas :)
  
  CloseGraph
End.

