(***************************)
{
  Modulis: Vienpusis sàraðas - KomanduSarasas,
  Autorius: Evaldas Naujanis
}
unit KomanduSarasasUnit;


interface

type Komanda = record
         veiksmas : integer;
         parametras : real;
     end;

type sarasoElementas = ^el;
     el = record
         _komanda : Komanda;
         kitas : sarasoElementas;
     end;
     
type KomanduSarasas = record
         pradzia : sarasoElementas;
         pabaiga : sarasoElementas;
     end;

{ funkcijø apraðymai }
function NaujaKomanda(veiksmas : integer; parametras : real) : Komanda;

procedure InicijuotiSarasa(var sar : KomanduSarasas);
procedure NaikintiSarasa(var sar : KomanduSarasas);
procedure SpausdintiSarasa(var sar : KomanduSarasas);

procedure PridetiKomanda(var sar : KomanduSarasas; nKomanda : Komanda);
function GautiKomanda(var sar : KomanduSarasas; nr : integer) : Komanda;
function SarasoIlgis(var sar : KomanduSarasas) : integer;



{ funkcijø realizacijos  }
implementation

{ naujos komandos sukûrimas }
function NaujaKomanda(veiksmas : integer; parametras : real) : Komanda;
  var nKomanda : Komanda;
begin
    nKomanda.veiksmas := veiksmas;
    nKomanda.parametras := parametras;
    NaujaKomanda := nKomanda;
end;

{ -  inicijuoja sàraðà - }
procedure InicijuotiSarasa(var sar : KomanduSarasas);
begin
    sar.pradzia := NIL;
    sar.pabaiga := NIL;
end;

{ - prideda komandà saraðo gale - }
procedure PridetiKomanda(var sar : KomanduSarasas; nKomanda : Komanda);
  var elem : sarasoElementas;
begin
  New (elem);
  elem^._komanda := nKomanda;
  elem^.kitas := NIL;
  // jei sarasas tuscias
  if (sar.pradzia = NIL) then
  begin
    sar.pradzia := elem;
    sar.pabaiga := elem;
  end  // jei netuscias prideda i gala
  else begin
    sar.pabaiga^.kitas := elem;
    sar.pabaiga := sar.pabaiga^.kitas;
  end;
end;

{ - gràþina komandà pagal numerá - }
function GautiKomanda(var sar : KomanduSarasas; nr : integer) : Komanda;
    var elem : sarasoElementas;
        i : integer;
begin
    i := 1;
    elem := sar.pradzia;
    // iesko elemento nurodytu numeriu
    while ((elem <> NIL) and (i < nr)) do
    begin
        elem := elem^.kitas;
        i := i + 1;
    end;

    if NOT((elem = NIL) or (nr<=0)) then
    begin
        GautiKomanda := elem^._komanda;
    end
    else begin
        // Nera elemento tokiu numeriu.
        GautiKomanda.veiksmas := 0;
        GautiKomanda.parametras := 0;
    end;

end;

{ - gràþina saraðo ilgá - }
function SarasoIlgis(var sar : KomanduSarasas) : integer;
    var elem : sarasoElementas;
        i: integer;
begin
  i := 0;
  elem := sar.pradzia;
  while (elem <> nil) do
  begin
    i := i + 1;
    elem := elem^.kitas;;
  end;
  
  SarasoIlgis := i;
end;

{ - saraso parodymas ekrane - }
procedure SpausdintiSarasa(var sar : KomanduSarasas);
  var elem : sarasoElementas;
begin
    elem := sar.pradzia;
    if (elem <> nil) then
    begin
        WriteLn('Komandu sarasas: ');
        while (elem <> nil) do
        begin
            WriteLn(' ', elem^._komanda.veiksmas, ' : ', elem^._komanda.parametras:3:2);
            elem := elem^.kitas;
        end;
    end
    else begin
        WriteLn('Komandu sarasas yra tuscias.');
    end;
    
  WriteLn;
end;

{ - sàraðo sunaikinimas - }
procedure NaikintiSarasa(var sar : KomanduSarasas);
  var elem : sarasoElementas;
begin
  elem := sar.pradzia;
  while (elem <> nil) do
  begin
    sar.pradzia := sar.pradzia^.kitas;
    dispose(elem);
    elem := sar.pradzia;
  end;
  sar.pabaiga := nil;
end;


  
// ---
Begin
End.


