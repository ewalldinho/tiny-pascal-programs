Program ms;
uses crt;
type mas = array [0..10, 0..10] of integer;

procedure nuliai (var lenta : mas);
var i, j : integer;
begin
    for i:=0 to 10 do
        for j:=0 to 10 do
            lenta[i, j]:=0;
end;

procedure randLenta (var lenta : mas);
var x, y, i : integer;
begin
    for i:=1 to 10 do begin
        x:=random(9)+1;
        y:=random(9)+1;
        if (lenta[x,y]=0) then lenta[x,y]:=9
        else i:=i-1;
    end;
end;

procedure skaiciai (var lenta : mas);
var i, j : integer;
begin
    for i:=1 to 9 do for j:=1 to 9 do if (lenta[i, j]=9) then begin
        if (lenta[i-1, j-1]<>9) then lenta[i-1, j-1]:=lenta[i-1, j-1]+1;
        if (lenta[i-1, j]<>9) then lenta[i-1, j]:=lenta[i-1, j]+1;
        if (lenta[i-1, j+1]<>9) then lenta[i-1, j+1]:=lenta[i-1, j+1]+1;
        if (lenta[i, j-1]<>9) then lenta[i, j-1]:=lenta[i, j-1]+1;
        if (lenta[i, j+1]<>9) then lenta[i, j+1]:=lenta[i, j+1]+1;
        if (lenta[i+1, j-1]<>9) then lenta[i+1, j-1]:=lenta[i+1, j-1]+1;
        if (lenta[i+1, j]<>9) then lenta[i+1, j]:=lenta[i+1, j]+1;
        if (lenta[i+1, j+1]<>9) then lenta[i+1, j+1]:=lenta[i+1, j+1]+1;
    end;
end;

procedure isvedimas (lenta : mas);
var i, j : integer;
begin
    for i:=1 to 9 do begin
        for j:=1 to 9 do write(lenta[i, j],' ');
        writeln;
    end;
end;

procedure isvesti (lenta, zaidimoLenta : mas);
var i, j : integer;
begin
    write('   ');
    for i:=1 to 9 do write(i,' ');
    writeln;
    writeln('   _ _ _ _ _ _ _ _ _');
    writeln;
    for i:=1 to 9 do begin
        write(i,'| ');
        for j:=1 to 9 do begin
            if (zaidimoLenta[i, j]=1) then if (lenta[i, j]=9) then write('M ') else write(lenta[i, j],' ')
            else begin
            textcolor(blue);
            write('X ');
            textcolor(white);
            end;
        end;
        writeln;
    end;
end;

procedure aplink(lenta, nuliams:mas; var zaidimoLenta:mas);
var i, j : integer;
    rasta : boolean;
    speta : mas;
begin
    nuliai(speta);
    for i:=1 to 9 do for j:=1 to 9 do if (nuliams[i, j]=1) then begin
        writeln(i,' ',j);
        speta[i, j]:=1;
        rasta:=false;
        nuliams[i, j]:=0;
        zaidimoLenta[i-1, j-1]:=1;
        zaidimoLenta[i-1, j]:=1;
        zaidimoLenta[i-1, j+1]:=1;
        zaidimoLenta[i, j-1]:=1;
        zaidimoLenta[i, j]:=1;
        zaidimoLenta[i, j+1]:=1;
        zaidimoLenta[i+1, j-1]:=1;
        zaidimoLenta[i+1, j]:=1;
        zaidimoLenta[i+1, j+1]:=1;
        if (lenta[i-1, j-1]=0)and(speta[i-1, j-1]=0) then begin nuliams[i-1, j-1]:=1; rasta:=true; end;
        if (lenta[i-1, j]=0)and(speta[i-1, j]=0) then begin nuliams[i-1, j]:=1; rasta:=true; end;
        if (lenta[i-1, j+1]=0)and(speta[i-1, j+1]=0) then begin nuliams[i-1, j+1]:=1; rasta:=true; end;
        if (lenta[i, j-1]=0)and(speta[i, j-1]=0) then begin nuliams[i, j-1]:=1; rasta:=true; end;
        if (lenta[i, j+1]=0)and(speta[i, j+1]=0) then begin nuliams[i, j+1]:=1; rasta:=true; end;
        if (lenta[i+1, j-1]=0)and(speta[i+1, j-1]=0) then begin nuliams[i+1, j-1]:=1; rasta:=true; end;
        if (lenta[i+1, j]=0)and(speta[i+1, j]=0) then begin nuliams[i+1, j]:=1; rasta:=true; end;
        if (lenta[i+1, j+1]=0)and(speta[i+1, j+1]=0) then begin nuliams[i+1, j+1]:=1; rasta:=true; end;
        if (rasta=true) then begin i:=1; j:=1; end;
    end;
end;

function won(zaidimoLenta:mas):boolean;
var i, j, nespeta:integer;
begin
    nespeta:=0;
    for i:=1 to 9 do for j:=1 to 9 do if (zaidimoLenta[i, j]=0) then nespeta:=nespeta+1;
    if (nespeta=10) then won:=true;
end;

procedure zaidimas (lenta, zaidimoLenta, nuliams : mas);
var pabaiga, laimeta : boolean;
    x, y : integer;
begin
    repeat
    pabaiga:=false;
    laimeta:=false;
    writeln('spejimas:');
    readln(x,y);
    zaidimoLenta[x, y]:=1;
    if (lenta[x, y]=9) then begin
        pabaiga:=true;
        laimeta:=false;
    end else if (lenta[x, y]=0) then begin

        nuliams[x, y]:=1;
        aplink(lenta, nuliams, zaidimoLenta);
        write('as');
    end;
    //writeln;
    clrscr;
    isvesti(lenta, zaidimoLenta);
    if (won(zaidimoLenta)=true) then begin pabaiga:=true; laimeta:=true; end;
    until pabaiga;
    if laimeta then writeln('laimeta') else writeln('pralaimeta');
end;
    

    var lenta, zaidimoLenta, nuliams : mas;

Begin
    randomize;
    nuliai(lenta);
    randLenta(lenta);
    skaiciai(lenta);
    nuliai(zaidimoLenta);
    nuliai(nuliams);
    isvesti(lenta,zaidimoLenta);
    zaidimas(lenta, zaidimoLenta, nuliams);
    readln;
End.
