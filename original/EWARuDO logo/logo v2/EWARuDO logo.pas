(************************)
{
   programa: EWARuDO logo - paremta Komenskio principais
   autorius: Evaldas Naujanis
   metai: 2005
}

Program vezlio_and_EWARuDO_logo;
  Uses Graph, Grafika, KomanduSarasasUnit;
  
  const N = 7;
        v : array[0..N] of string = ('pabaiga', 'padek', 'priekin', 'atgal',
                                     'kairen', 'desinen', 'kartok', 'trink');

   var x,y, laips : real;

{ Randa komanda ir gr??ina per parametrus }
  Procedure RastiKomanda (uzd : string; var ka : integer; var kiek : real);
        var veik : string;
            i    : integer;
    begin
      veik := '';
      i := 1;
      ka := -1;  // kol kas neai?ku, ar ivesta gera komanda
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

{ ----- Prad?ia - inicijuoja pradines reik?mes ----- }
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
      WriteLn('|  * kartok kiek                 |');
      WriteLn('|  * padek - rodoma pagalba      |');
      WriteLn('|  * trink - isvalyti ekrana     |');
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
      //if x < -400 then x := 400;
      //if y < -300 then y := 300;
     // WriteLn('(x = ', GetMaxX div 2 + round(x), ', y = ', GetMaxY div 2 - round(y), ')');
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
    
{ ----- kartojimas ----- }
  Procedure kartok (kiekKartu : real);
      var i, k : integer;
          kiek : real;
          gana : boolean;
          kom : Komanda;
          komandos : KomanduSarasas;
          kString : string; // ivesta komanda
          komanduSk : integer;
    begin
        // IVESKITE '[' PRADETI KOMANDU IVEDINEJIMA, NOREDAMI BAIGTI IVESKITE ']'
        // RastiKomanda(kom, kiek);
        // if (kom > 0) and (kom < 6) then Komandu Sarasas.ADd(komnada);
        //
        // for (int i=0; i< komanduSkaicius)
        // Vykdyti(GautiKomanda(komandos, i));
        
        WriteLn('Iveskite komandu seka, kuria norite kartoti arba '']'', noredami baigti');
        WriteLn('Komandos [');
        InicijuotiSarasa(komandos);
        
        gana := FALSE;
        repeat
            ReadLn(kString);
            if (kString <> ']') then
            begin
                RastiKomanda(kString, kom.veiksmas, kom.parametras);

                if (kom.veiksmas > 0) and (kom.veiksmas < 6) then
                    PridetiKomanda(komandos, kom)
                else begin
                    WriteLn('Nurodyta nesuprantama arba netinkama komanda.');
                    WriteLn('Noredami baigti iveskte '']''.');
                end;
            end
            else
                gana := TRUE;
        until gana;
        
        komanduSk := SarasoIlgis(komandos);
        if (komanduSk > 0) then
        begin
            i := 0;
            while i < kiekKartu do
            begin
                for k := 1 to komanduSk do
                begin
                    kom := GautiKomanda(komandos, k);
                    VykdytiKomanda(kom.veiksmas, kom.parametras);
                end;
                i := i + 1;
            end;
        end;

        NaikintiSarasa(komandos);
    end;
    
    
{ ----- trink ----- }
  Procedure trink( );
  begin
    ClearDevice;
    pradzia;
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
        komandaString : string;

Begin
  Ekranas(mx,my);
  Pradzia;
  ende := FALSE;
  WriteLn(' ------------------------------------------------------------------');
  WriteLn('|Jusu komanda (parametro reiksme)  | padek - komandu sarasas       |');
  WriteLn('|------------------------------------------------------------------|');
  repeat
    Write('>');
    ReadLn(komandaString);
    RastiKomanda(komandaString, kom, kiek);
    Case kom of
      0 : ende := TRUE;    // PABAIGA
      1 : padek;
      2 : priekin(kiek);  // priekin
      3 : atgal  (kiek);  // atgal
      4 : kairen (kiek);  // kairen
      5 : desinen(kiek);  // desinen
      6 : kartok (kiek);
      7 : trink; // ekrano isvalymas
      else begin
          WriteLn('EWARuDO nesuprato Jusu komandos :(  bandykit dar karta');
          WriteLn('Jei nezinote komandu iveskite ''padek''');
      end;
    end;
  until ende;
  
//  Sukinys(1, 20);  // kol kas suspenduotas :)
  
  CloseGraph
End.
