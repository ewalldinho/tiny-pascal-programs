(*******************************************************************************)
(*   Programa dirba su HTML dokumentu. Ji uþbaigia tagus sudarytus is 2 daliu  *)
(*     ( pvz.: <p> </p> ).                                                     *)
(*   Nurodoma:                                                                 *)
(*        kur iterpti [ pradzia , pabaiga , abi pusës ] ,                      *)
(*        tago dalis kuri jau yra (pvz.: <p> arba </p>) ,                      *)
(*   'Abi puses'  sulygina tagus (kad bûtø po lygiai <p> ir </p>)              *)
(*******************************************************************************)

Program insert_begin_end;

  uses CRT;
  type  eil_sarasas = ^t_rod;
        t_rod = record
            eil : string;
            kitas : eil_sarasas;
        end;


  function Tikrinti ( pav : string ): boolean;
      var F : text;
    begin

      Assign(F, pav);
    {$I-}
      Reset(F);
    {$I+}

      if ( IOResult() = 0 )
        then begin
           Close(F);
           Tikrinti := TRUE;
        end
        else Tikrinti := FALSE;
    end;
    
    
  procedure GautiInfo (var txt : string; var vieta : integer);
      var numInt : integer;
          numStr : string;
          numReal : real;
          error : integer;
    begin
      Write(' Tekstas kuri norite iterpti: ');
      ReadLn(txt);
      WriteLn(' Vieta kur iterpti: ');
      WriteLn('   [1] - pradþioje ');
      WriteLn('   [2] - gale ');
      WriteLn('   [3] - (nespausk-lus) ');
      WriteLn('--------------------');
      Write(' Pasirinkimas: ');
      ReadLn(numStr);

      Val(numStr, numInt, error);

      if ( error  = 0)
        then vieta := numInt
        else WriteLn(' Klaidingas skaiciaus formatas!');

    end;

  var pav : string;
      sim : char;
      gana : boolean;
      txt : string;
      kur : integer;
      F : text;
 // teksto skaitymas / raðymas
      tekstas : eil_sarasas;
      r1, r2 : eil_sarasas;
      tmp : eil_sarasas;
      rod : eil_sarasas;
      s1, s2 : string;
      tag : string;

      
Begin
  TextColor(white);
  TextBackground(black);
  ClrScr;
  gana := FALSE;
  tekstas := NIL;

  repeat
    Write(' Failo pavadinimas: ');
    ReadLn(pav);
    if ( Tikrinti(pav) )
      then begin
        GautiInfo(txt, kur);
        Assign (F, pav);
        Reset (F);
        While not EoF(F) do
          begin
            new(tmp);
            ReadLn(F, tmp^.eil);
            tmp^.kitas := NIL;
            if ( tekstas = NIL )
              then begin
                tekstas := tmp;
                rod := tmp;
              end;
            rod^.kitas := tmp;
            rod := rod^.kitas;
          end;
        Close(F);  { duomenys nuskaityti }
        case kur of
          1: begin
               s1 := txt;
               s2 := '';
             end;
          2: begin
               s1 := '';
               s2 := txt;
             end;
        else begin
               s1 := '';
               s2 := '';
             end;
        end;
        Write('Tago dalis kuri jau yra: ');
        ReadLn(tag);
        Assign(F, pav);
        Rewrite(F);
        tmp := tekstas;
        repeat
          if pos(tag, tmp^.eil) > 0
            then WriteLn(F, s1, tmp^.eil, s2)
            else WriteLn(F, tmp^.eil);
          tmp := tmp^.kitas;
        until tmp^.kitas = NIL;
        Close(F);
        gana := TRUE;
      end
      else begin
        WriteLn(' Failo ', pav, ' atidaryti nepavyko!');
        WriteLn(' Jei norite baigti darba - spauskite [ESC]. ');
        WriteLn(' Jei nori kartoti ivedima - bet kuri kita...');
        Write(' Pasirinkimas: ');
        sim := ReadKey();
        if sim = #27
          then gana := TRUE;
        ClrScr;
      end;

  until gana;



  

{--------------------------------------------------------------}
if (tekstas <> NIL) then

  repeat
    r1 := tekstas;
    r2 := tekstas;
    repeat
      r1 := r1^.kitas;
    until r1^.kitas = NIL;
    while r2^.kitas <> r1 do
      r2 := r2^.kitas;
    r2^.kitas := NIL;
    Dispose(r1);
    r2^.kitas := NIL;
  until tekstas^.kitas = NIL;
    Dispose(tekstas);
    
  WriteLn('[enter]');
  Readln;
End.

