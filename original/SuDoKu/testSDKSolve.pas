(*******************************)
{
	Programa: Testine programa.
	Funkcionalumas: susideda sudoku ið string eilutës ir testuoja Sudoku API funkcionaluma.
	Autorius: Evaldas Naujanis (evaldas.naujanis@gmail.com) 
	
}

Program SuDoKu_sprendejas;
   Uses CRT, SuDoKu_API;


   Var sdkString : array[1..20] of string;
       SDK : SuDoKu;
       k, sk, selectSDK : byte;
       x, y : byte;
       ivestas, viskas : boolean;
       
Begin

    
    InitSuDoKu(SDK);
    sdkString[1] := '12345678.45678912.78912345.2345678.15678912.48912345.7345678.12678912.45912345.78';
    sdkString[2] := '..1..6.3.......9.58..7...4.983.2...7..48.5.....7.6.1...3.1....94.56......6.9845..';
    sdkString[3] := '.3.5..81....76..9.4.........439.5..6.1.....7.6..8.193.........9.9..86....61..2.8.';

    sdkString[4] := '..1..4.......6.3.5...9.....8.....7.3.......285...7.6..3...8...6..92......4...1...';
    sdkString[5] := '.......39.....1..5..3.5.8....8.9...6.7...2...1..4.......9.8..5..2....6..4..7.....';
    sdkString[6] := '.2.4.37.........32........4.4.2...7.8...5.........1...5.....9...3.9....7..1..86..';
    sdkString[7] := '.......39.....1..5..3.5.8....8.9...6.7...2...1..4.......9.8..5..2....6..4..7.....';
    sdkString[8] := '1.......2.9.4...5...6...7...5.9.3.......7.......85..4.7.....6...3...9.8...2.....1';
    
    sdkString[9] := '1..45678.45678912.78912345.2345678.15678912.48912345.7345678.12678912.45912345.78';
   sdkString[10] := '4.7.5.39....3....1.9.7....6..9....83....7....52....7..7....1.6.9....6....18.9.2.5';
   sdkString[11] := '7..1....2.....6.8....8..1.9..7..9.1..93...54..6.4..9..3.8..4....4.3.....1....5..3';
   sdkString[12] := '1234567892345.7198345678..745......656..9.7.567..7..5478...5.43891....3298765432.';
   
    selectSDK := 2;
    for y := 1 to 9 do
        for x := 1 to 9 do
        begin
            if sdkString[selectSDK][(y-1)*9+x] = '.'
            then SDK[y][x] := 0
            else SDK[y][x] := Ord( sdkString[selectSDK][(y-1)*9+x] )-48;
        end;

    TextBackground(White);
    ClrScr;
    
    DrawSuDoKuTable();
    ShowSuDoKu(SDK);
    InitSolveTemplate(SDK);

    GoToXY(1, 20);
    if IsValidSuDoKu(SDK)
    then WriteLn('Geras Sudoku!')
    else WriteLn('Negeras nx...');

    for y := 1 to 9 do
    begin
        for x := 1 to 9 do
        begin
            k := KiekLiko(x, y, sk);
            Write(k, ' ');
        end;
        WriteLn;
    end;
    WriteLn('- inited -');  Write('[enter]');
    ReadLn;
    
    Solve(SDK);

    if not Solved(SDK)
    then begin
        WriteLn('Time for BruteForce');
        ReadLn;
        viskas := BruteForce(SDK, 1);
        Readln;
    end;

    DrawSuDoKuTable();
    ShowSuDoKu(SDK);

    GoToXY(1, 20);
    if IsValidSuDoKu(SDK)
    then WriteLn('Geras Sudoku!')
    else WriteLn('Negeras nx...');

    for y := 1 to 9 do
    begin
        for x := 1 to 9 do
        begin
            k := KiekLiko(x, y, sk);
            Write(k, ' ');
        end;
        WriteLn;
    end;
    WriteLn;


    Write('[enter]');
    ReadLn;
End.
