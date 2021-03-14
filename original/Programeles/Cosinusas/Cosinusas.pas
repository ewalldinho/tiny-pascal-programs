{
   Teiloro eilutë cos(x),
      x - kampo dydis radianais
      n = 0..Infinity
    cosx =  SUM( (-1)^n / (2n)! * x^(2n)
    cosx = 1 - x^2/2! + x^4/4! - x^6/6! + x^8/8! - ... su visais X
    
   Teiloro eilutë sin(x),
      x - kampo dydis radianais
      n = 0..Infinity
    sinx =  SUM( (-1)^n / (2n+1)! * x^(2n+1)
    sinx = x - x^3/3! + x^5/5! - x^7/7! + x^9/9! - ... su visais X

}

program Cosinusas;

    uses CRT;

    function calcElement(x : longint; nr: integer ) : real;
            var z : integer;
                i: integer;
                skait: real;
                vard: real;
        begin
            if (nr = 0)
            then calcElement := 1
            else begin
                if (nr mod 2 = 0)
                then z := 1
                else z := -1;
                skait := 1;
                vard := 1;
                for i := 1 to nr *2 do
                begin
                    skait := skait * x;
                    vard := vard * i;
                end;
                calcElement := z * skait/vard;
            end;
        end;

    function calcSinElement(x : longint; nr: integer ) : real;
            var z : integer;
                i: integer;
                skait: real;
                vard: real;
        begin
            if (nr = 0)
            then calcSinElement := x
            else begin
                if (nr mod 2 = 0)
                then z := 1
                else z := -1;
                skait := 1;
                vard := 1;
                for i := 1 to nr *2 +1 do
                begin
                    skait := skait * x;
                    vard := vard * i;
                end;
                calcSinElement := z * skait/vard;
            end;
        end;

    var cosx : real;
        sinx : real;
        x : longint;
        n : integer;
        elNr : integer;
        elem : real;
        paklaida : real;

begin
    WriteLn('      Programa skaiciuoja cos(x), sin(x) reiksme 1/n tikslumu. ');
    WriteLn('      x, n - sveiki skaièiai, x - kampas radianais ');
    WriteLn('  Reiksmes ');
    WriteLn('     x:           n: ');
    GoToXY(9, WhereY-1);
    ReadLn(x);
    GoToXY(22, WhereY-1);
    ReadLn(n);

    WriteLn(' Programa skaiciuoja cos(', x, ') reiksme 1/', n, ' tikslumu. ');

    cosx := 0;
    elNr := 0; // elemento eilës numeris
    paklaida := 1 / n;
    elem := calcElement(x, 0);
    
    TextColor(DARKGRAY);
    WriteLn(elNr, '-asis elementas: ', elem:2:5, ' paklaida: ', paklaida:2:3);
    TextColor(WHITE);

    while ( abs(elem) >= paklaida ) do
      begin
        cosx := cosx + elem;
        elNr := elNr + 1;
        elem := calcElement(x, elNr);
WriteLn(elNr, '-asis elementas: ', elem:2:5, ' paklaida: ', paklaida:2:3);
      end;
   
   
    WriteLn(' cos(', x, ') = ', cosx:1:10 );
    WriteLn();
  
    WriteLn(' Programa skaiciuoja sin(', x, ') reiksme 1/', n, ' tikslumu. ');
    sinx := 0;
    elNr := 0; // elemento eilës numeris
    paklaida := 1 / n;
    elem := calcSinElement(x, 0);
    WriteLn(elNr, '-asis elementas: ', elem:2:5, ' paklaida: ', paklaida:2:3);

    while ( abs(elem) >= paklaida ) do
      begin
        sinx := sinx + elem;
        elNr := elNr + 1;
        elem := calcSinElement(x, elNr);
        WriteLn(elNr, '-asis elementas: ', elem:2:5, ' paklaida: ', paklaida:2:3);
      end;
    WriteLn(' sin(', x, ') = ', sinx:1:10 );
    WriteLn();
  
    WriteLn('[enter]');
    Readln;
end.
