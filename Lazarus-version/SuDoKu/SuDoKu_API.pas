(*******************************)
{
	Modulis: SuDoKu_API
	Funkcionalumas: Įgyvendina esmines sudoku žaidimo funkcijas: meniu rodymas, sprendimas, failo pasirinkimas ir pan.
	Autorius: Evaldas Naujanis (evaldas.naujanis@gmail.com)
}

Unit SuDoKu_API;

interface

    Uses UnicodeCRT, LazUTF8, GUI_Toolkit, SuDoKU_Global;

    Type // number = [1..9];
        SuDoKu_Row = array[1..9] of byte;
        SuDoKu = array[1..9] of SuDoKu_Row;
        
        // tipai reikalingi Sudoku prendimui
        SDK_BAibe = array[1..9] of boolean;
        SolveTemplate = array[1..81] of SDK_BAibe;
        
        
    // globalus 'sprendimo tinklelis'
    var sTmp : SolveTemplate;
    
(***************  SuDoKu  GUI  ************************************************)

  Procedure ShowSuDoKuScreen();
  Procedure Menu(var m : integer);
  Procedure DrawSuDoKuTable();
  Procedure ShowSuDoKu(SDK : SuDoKu);
    
(*************  SuDoKu  valdymas  *********************************************)

  // nunulina SuDoKu ([[0,0,0|0,0,0|0,0,0]x9)
  Procedure InitSuDoKu(out SDK : SuDoKu);
  Procedure CreateSuDoKu(var SDK : SuDoKu; var created : boolean);
  Procedure EditSuDoKu(var SDK : SuDoKu);
  Procedure SaveSuDoKu(SDK : SuDoKu; dir : string);
  
  Procedure InputFromFile (dir : string; var SDK : SuDoKu; var sdkIn : boolean);
  Procedure InputFromKeyboard (var SDK : SuDoKu; out confirmed : boolean);


(*************  SuDoKu  sprendimas  *******************************************)
  // grąžina kiek liko galimų variantų tame langelyje ir likusia reiksme jei 1
  Function KiekLiko(x, y : byte; var sk : byte) : byte;
  
  Procedure InitSolveTemplate(SDK : SuDoKu);
  
  Procedure Solve(var SDK : SuDoKu);
  // rekursyvi funkcija sprendiniui rasti
  Function BruteForce(var SDK : SuDoKu; gIndex : byte) : boolean;
  // patikrina ar urašytos tinkamos reikšmės
  Function IsValidSuDoKu(SDK : SuDoKu) : boolean;
  // tikrina ar užpildytas sudoku
  Function Solved(SDK : SuDoKu) : boolean;



{------------------------------------------------------------------------------}

implementation

  procedure CenterText(x, y: word; text : string);
    var posX, i : integer;
  begin
      posX := x - UTF8Length(text) div 2;
      GoToXY(1, y);
      for i := 1 to 40 do
        Write('  ');
      GoToXY(posX, y);
      Write(text);
  end;

  procedure SetColors(backgroundColor, foregroundColor : Byte; isSelected : Boolean);
  begin
    if isSelected then
    begin
        TextBackground(foregroundColor);
        TextColor(backgroundColor);
    end
    else begin
        TextBackground(backgroundColor);
        TextColor(foregroundColor);
    end
  end;

  Procedure ShowSuDoKuScreen();
        var i : integer;
            enterGame : boolean;
            k : word;
    begin
        TextBackground(Yellow);
        TextColor(Red + Blink);
        ClrScr;
        GoToXY(1, 3);
        //WriteLn('       ', #219,#219,#219,#219,#219, '                  ',                                  #220,#220,#220,#220,#220,#220,#220,#220, '                 ',#220,#220,#220,#220,#220, '   ', #220,#220,#220, '        ');
        //WriteLn('    ', #219,#223,#223,#223,#223,#223,#223,#223,#223,#223,#219, '                ',                   #219,#219,#219,#219,#219,#219,#219,#219,#219, '                ', #219,#219,#219, '   ', #222,#219, '         ');
        //WriteLn('   ', #222,#219,#221, '       ', #222, #219, #221, '               ',                                #219,#219,#219, '     ', #223,#219,#219, '              ', #219,#219,#219, '   ', #219,#221, '         ');
        //WriteLn('  ', #222,#219,#221, '        ', #223, #219, #223, '               ',                                #219,#219,#219, '      ', #219,#219,#219, '             ', #219,#219,#219, '    ', #219,#221, '        ');
        //WriteLn('   ', #222,#219,#221, '                         ',                                                   #219,#219,#219, '      ', #219,#219,#219, '             ', #219,#219,#219, '    ', #219,#219, '        ');
        //WriteLn('    ', #222,#219,#219,#219,#219,#219,#219,#221, '                   ',                               #219,#219,#219, '      ', #219,#219,#219, '             ', #219,#219,#219, '   ', #219,#219, '         ');
        //WriteLn('      ', #222,#219,#219,#219,#219,#219,#219,#221, '    ',#177,#177,#177,'   ',#177,#177,#177,'    ', #219,#219,#219, '      ', #219,#219,#219, '    ', #178,#178,#178,#178, '     ', #219,#219,#219,#219,#219,#219,#219, '   ', #176,#176,#176, '   ', #176,#176,#176);
        //WriteLn('            ',                   #222,#219,#219, '    ', #177,#177, '    ', #177,#177, '    ',       #219,#219,#219, '      ', #219,#219,#219, '  ', #178,#178,#178,#178, #178,#178,#178,#178, '   ', #219,#219,#219,#219,#219,#219, '     ', #176,#176, '    ', #176,#176);
        //WriteLn('              ',                  #222,#219,#221, '  ',  #177,#177, '    ', #177,#177, '    ',       #219,#219,#219, '      ', #219,#219,#219, '  ', #178,#178, '    ', #178,#178, '   ', #219,#219,#219, ' ', #219,#219,#219, '    ', #176,#176, '    ', #176,#176);
        //WriteLn('  ', #220,#219,#220, '         ', #222,#219,#221, '  ',  #177,#177, '    ', #177,#177, '    ',       #219,#219,#219, '      ', #219,#219,#219, '  ', #178,#178, '    ', #178,#178, '   ', #219,#219,#219, '   ', #219,#219, '   ', #176,#176, '    ', #176,#176);
        //WriteLn('  ', #222,#219,#221, '        ', #222,#219,#221, '   ',  #177,#177, '    ', #177,#177, '    ',       #219,#219,#219, '     ', #220,#219,#219, '   ', #178,#178, '    ', #178,#178, '   ', #219,#219,#219, '    ', #219,#219, '  ', #176,#176, '    ', #176,#176);
        //WriteLn('   ', #219,#220,#220,#220,#220,#220,#220,#220,#220,#220,#220,#219, '    ', #177,#177,#177,#177,#177,#177,#177,#177, '    ', #219,#219,#219,#219,#219,#219,#219,#219,#219, '     ', #178,#178,#178,#178, #178,#178,#178,#178, '   ', #219,#219,#219, '   ', #222,#219, '   ', #176,#176,#176,#176,#176,#176,#176,#176);
        //WriteLn('     ', #219,#219,#219,#219,#219,#219,#219, '        ',  #177,#177,#177,#177, ' ', #177,#177,#177, '  ', #223,#223,#223,#223,#223,#223,#223,#223, '         ', #178,#178,#178,#178, '    ', #223,#223,#223,#223,#223 ,'  ', #223,#223,#223, '   ', #176,#176,#176,#176, ' ', #176,#176,#176);
        WriteLn('       █████                  ▄▄▄▄▄▄▄▄                 ▄▄▄▄▄   ▄▄▄        ');
        WriteLn('    █▀▀▀▀▀▀▀▀▀█                █████████                ███   ▐█         ');
        WriteLn('   ▐█▌       ▐█▌               ███     ▀██              ███   █▌         ');
        WriteLn('  ▐█▌        ▀█▀               ███      ███             ███    █▌        ');
        WriteLn('   ▐█▌                         ███      ███             ███    ██        ');
        WriteLn('    ▐██████▌                   ███      ███             ███   ██         ');
        WriteLn('      ▐██████▌    ▒▒▒   ▒▒▒    ███      ███    ▓▓▓▓     ███████   ░░░   ░░░');
        WriteLn('            ▐██    ▒▒    ▒▒    ███      ███  ▓▓▓▓▓▓▓▓   ██████     ░░    ░░');
        WriteLn('              ▐█▌  ▒▒    ▒▒    ███      ███  ▓▓    ▓▓   ███ ███    ░░    ░░');
        WriteLn('  ▄█▄         ▐█▌  ▒▒    ▒▒    ███      ███  ▓▓    ▓▓   ███   ██   ░░    ░░');
        WriteLn('  ▐█▌        ▐█▌   ▒▒    ▒▒    ███     ▄██   ▓▓    ▓▓   ███    ██  ░░    ░░');
        WriteLn('   █▄▄▄▄▄▄▄▄▄▄█    ▒▒▒▒▒▒▒▒    █████████     ▓▓▓▓▓▓▓▓   ███   ▐█   ░░░░░░░░');
        WriteLn('     ███████        ▒▒▒▒ ▒▒▒  ▀▀▀▀▀▀▀▀         ▓▓▓▓    ▀▀▀▀▀   ▀▀▀   ░░░░ ░░░');
        WriteLn;
        GoToXY(3, WhereY);
        for i := 1 to 38 do Write('█'); // (#219);
        for i := 1 to 38 do Write('▀'); // (#223);

        enterGame := FALSE;
        repeat
            CenterText(40, 20, GetWord(TXT_PRESS_ENTER));

            GoToXY(37, 22);
            SetColors(Yellow, Red, CurrentLanguage=LANG_LT);
            Write(' LT ');
            GoToXY(41, 22);
            SetColors(Yellow, Red, CurrentLanguage=LANG_EN);
            Write(' EN ');

            k := GetKey;
            case (k) of
                KEY_LEFT: ToggleLanguage();
                KEY_RIGHT: ToggleLanguage();
                KEY_ENTER: enterGame := TRUE;
            end;
            //ReadLn;
            SetColors(Yellow, Red+Blink, FALSE);
        until enterGame;
    end;



  Procedure Menu(var m : integer);
        var total : integer;
            done : boolean;

        // set color according if button is selected
        procedure SetButtonColor(isSelected : boolean);
        begin
            if isSelected
              then TextColor(Green)
              else TextColor(Blue);
        end;

        // procedura pažymėti menu punktui
        procedure showMenu(select : integer);
        begin

            GoToXY(5, 3);
            TextColor(BLACK);
            PrintWord(TXT_MENU_TITLE);

            { Create Sudoku }
            SetButtonColor(select = 1);
            DrawButton(GetWord(TXT_MENU_CREATE), 15, 5, 5);

            { Load sudoku }
            SetButtonColor(select = 2);
            DrawButton(GetWord(TXT_MENU_LOAD), 15, 5, 8);

            { Edit sudoku }
            SetButtonColor(select = 3);
            DrawButton(GetWord(TXT_MENU_EDIT), 15, 5, 11);

            { Solve sudoku }
            SetButtonColor(select = 4);
            DrawButton(GetWord(TXT_MENU_SOLVE), 15, 5, 14);

            { Save sudoku }
            SetButtonColor(select = 5);
            DrawButton(GetWord(TXT_MENU_SAVE), 15, 5, 17);

            { Exit sudoku }
            SetButtonColor(select = 0);
            DrawButton(GetWord(TXT_MENU_EXIT), 15, 5, 20);

            TextColor(BLACK);
        end;
    begin
        done := FALSE;
        total := 5;
        // turėtų jau būti inicijuotas, bet patikrinam vistiek
        if m < 1 then
        begin
             m := 1;
        end;

        repeat
            showMenu(m);
            case (GetKey) of
                KEY_UP: begin
                            m := m-1;
                            if (m < 0) then m := total;
                        end;
                KEY_DOWN: begin
                            m := m+1;
                            if (m > total) then m := 0;
                          end;
               // KEY_LEFT: WriteLn('<-');
               // KEY_RIGHT: WriteLn('->');
                KEY_ENTER: if (m >= 0)
                           then done := TRUE;
                KEY_ESC: begin
                            m := -1;
                            done := TRUE;
                         end;
                KEY_L: begin
                          if CurrentLanguage = LANG_LT
                            then CurrentLanguage := LANG_EN
                            else CurrentLanguage := LANG_LT;
                       end;
            end;

        until done;
    end;

  Procedure DrawSuDoKuTable();
    var x, y : integer;
        NumBGColor, BGColor : byte;
    begin
        NumBGColor := WHITE;
        BGColor := LightGray;
        TextColor(BLACK);
        ClrScr;

        Write('╔'); // (#201);
        for x := 1 to 35 do
            if x mod 12 = 0
            then Write('╦') // (#203)
            else Write('═'); // (#205)
        WriteLn('╗'); // (#187)

        for y := 1 to 17 do
        begin
            if y mod 2 = 1 then
            begin
                for x := 1 to 36 do
                    if (x-1) mod 4 <> 0           // atskiriami stulpeliai
                    then begin
                        TextBackground(NumBGColor);
                        Write(' ');
                        TextBackground(BGColor);
                    end
                    else
                        if (x-1) mod 12 = 0
                        then Write('║')    // (#186) po 3 (Rašo ||)
                        else Write('│');   // (#179) po 1 (rašo |)
                WriteLn('║'); // (#186)
            end
            else begin
                if y mod 6 = 0 then
                begin
                    Write('╠'); // (#204) ||=
                    for x := 1 to 17 do
                        if x mod 6 = 0
                        then Write('═╬')  // (#205, #206) =||=
                        else Write('══'); // (#205, #205) =
                    WriteLn('═╣');  // (#205, #185) =||
                end
                else begin
                    Write('║');  // (#186) #204 ||=
                    for x := 1 to 35 do
                        if x mod 12 = 0
                        then Write('║')  // (#186) #206 =||=
                        else if x mod 4 = 0
                             then Write('┼')    // (#197) rašo -|-
                             else Write('─');   // (#196) rašo -
                    WriteLn('║');  // (#186) =||
                end;
            end;
        end;

        Write('╚'); // (#200);
        For x := 1 to 35 do
            if x mod 12 = 0
            then Write('╩')   // (#202)
            else Write('═');  // (#205)
        WriteLn('╝');  // (#188);
    end;

  Procedure ShowSuDoKu(SDK : SuDoKu);
      var x, y : byte;
    begin
        DrawSuDoKuTable;
        for y := 1 to 9 do
            for x := 1 to 9 do
            begin
                GoToXY(X*4-1, Y*2);
                if SDK[y][x] = 0
                then Write(' ')
                else Write(SDK[y][x]);
            end;

    end;

(******************************************************************************)

  Procedure InitSuDoKu(out SDK : SuDoKu);
      var x, y : byte;
    begin
        for y := 1 to 9 do
            for x := 1 to 9 do
            begin
                SDK[y][x] := 0;
            end;
    end;

  Procedure CreateSuDoKu(var SDK : SuDoKu; var created : boolean);
    begin
        DrawSuDoKuTable;
        InputFromKeyboard(SDK, created);
    end;

  Procedure EditSuDoKu(var SDK : SuDoKu);
      var confirmed : boolean; // TRUE - nes jau editina
    begin
        DrawSuDoKuTable;
        ShowSuDoKu(SDK);
        InputFromKeyboard(SDK, confirmed);
    end;

  Procedure SaveSuDoKu(SDK : SuDoKu; dir : string);
      var failoPav : string;
          F : text;
          x, y, pavIlgis : byte;
          key : word;
          escape, enter : boolean;
    begin
        CursorOn;
        failoPav := '';
        pavIlgis := 0;
        enter := FALSE;
        escape := FALSE;
        Write(GetWord(TXT_SAVE_AS), ' ');
        repeat
            key := GetKey;
            case key of
              KEY_BACKSPACE: begin
                 if (pavIlgis > 0)
                 then begin
                    delete(failoPav, length(failoPav), 1);
                    GoToXY(WhereX-1, WhereY);
                    ClrEol;
                    pavIlgis := pavIlgis - 1;
                 end;
              end;

             // KEY_LEFT: WriteLn('Left'); // pasirinkti ext: *.sdk | *.txt
             // KEY_RIGHT: WriteLn('Right');
              KEY_ENTER: enter := TRUE;
              KEY_ESC: escape := TRUE;
              else begin
                if key in [Ord('A')..Ord('Z'), Ord('a')..Ord('z'), Ord('0')..Ord('9')]
                then begin
                    Write(Char(key));
                    failoPav := failoPav + Char(key);
                    pavIlgis := pavIlgis + 1;
                end;
              end;
            end;
        until escape or enter;

        WriteLn;

        if enter then
        begin
            if (dir <> '.')
            then failoPav :=  concat(dir, '/', failoPav);
            failoPav := concat(failoPav, '.sdk');

            Assign(F, failoPav);
            {$I-}
            Rewrite(F);
            {$I+}
            if IOResult = 0
            then begin
                for y := 1 to 9 do
                begin
                    for x := 1 to 9 do
                    begin
                        Write(F, SDK[y][x], ' ');
                    end;
                    WriteLn(F);
                end;
                Close(F);
                WriteLn(GetWord(TXT_SAVED_IN_FILE), ' "', failoPav, '".');
            end
            else PrintWord(TXT_SAVING_FAILED);
        end
        else PrintWord(TXT_ACTION_CANCELED);

        PrintWord(TXT_PRESS_ENTER);
        ReadLn;
        CursorOff;
    end;



  Procedure InputFromFile (dir : string; var SDK : SuDoKu; var sdkIn : boolean);
      var fSDK : text;
          failoPav : string;
          x, y : byte;
          exts : ExtsType;
    begin
        failoPav := '';
        exts[1] := 'sdk';
        exts[2] := 'txt';
        SelectFile(dir, failoPav, exts, 512);

        if failoPav = ''  { failas nepasirinktas - ESC }
        then begin
            GoToXY(3, WhereY + 1);
            TextColor(BLACK);
            PrintWord(TXT_ACTION_CANCELED);
            sdkIn := FALSE;
        end
        else begin     { failas pasirinktas - bandoma nuskaityti }
            if dir <> '.'
            then failoPav := Concat(dir, '/', failoPav);
            Assign(fSDK, failoPav);
            {$I-}
            Reset(fSDK);
            {$I+}
            if (IOResult <> 0)
            then begin
                GoToXY(2, WhereY + 1);
                TextColor(BLACK);
                WriteLn(GetWord(TXT_LOAD_SUDOKU_FAILED), ' "', failoPav, '".');
                sdkIn := FALSE;
            end
            else begin
                while not Eof(fSDK) do
                begin
                    for y := 1 to 9 do
                    begin
                        for x := 1 to 9 do
                            Read(fSDK, SDK[y][x]);
                        ReadLn(fSDK);
                    end;
                end;
                Close(fSDK);
                GoToXY(3, WhereY + 1);
                TextColor(BLACK);
                PrintWord(TXT_LOAD_SUDOKU_SUCCESS);
                sdkIn := TRUE;
            end;
        end;
        GoToXY(3, WhereY);
        PrintWord(TXT_PRESS_ENTER);
        ReadLn;
    end;

  Procedure InputFromKeyboard (var SDK : SuDoKu; out confirmed : boolean);
        var X, Y : byte;
            key : smallint;
            done : boolean;
    begin
        X := 1;
        Y := 1;
        done := FALSE;
        confirmed := FALSE;

        // kursorius tampa stačiakampis (kaip insert)
        CursorBig;
        // vykdomas įvedimas
        repeat
            GoToXY(X*4-1, Y*2);
            key := GetKey;
            case (key) of
                KEY_UP: begin
                            Y := Y-1;
                            if (Y < 1) then Y := 9;
                        end;
                KEY_DOWN: begin
                            Y := Y+1;
                            if Y > 9 then Y := 1;
                          end;
                KEY_LEFT: begin
                             X := X - 1;
                             if X < 1 then X := 9;
                          end;
                KEY_RIGHT: begin
                             X := X + 1;
                             if X > 9 then X := 1;
                           end;
                KEY_ENTER: begin
                             done := TRUE;
                             confirmed := TRUE;
                           end;
                KEY_ESC: begin
                            done := TRUE;
                            confirmed := FALSE;
                         end;
                32, 48: begin
                            Write(' ');
                            SDK[Y][X] := 0;
                        end;
                49..57: begin
                            Write(char(key));
                            SDK[Y][X] := key - 48;
                        end;
            end;

        until done;
        CursorOff;
    end;  // ivedimo


(******************************************************************************)

  // grąžina kiek liko galimų variantų tame langelyje ir likusia reiksme jei 1
  Function KiekLiko(x, y : byte; var sk : byte) : byte;
        var i, kiek, index : byte;
    begin
        sk := 0;
        kiek := 0;
        index := (y-1)*9+x;
        for i := 1 to 9 do
            if sTmp[index][i]
            then begin
                kiek := kiek + 1;
                sk := i;
            end;
        if kiek > 1 then sk := 0;
        KiekLiko := kiek;
    end;
    
  Function HasVariant(index, v : byte) : boolean;
    begin
        HasVariant := sTmp[index][v];
    end;
    
  Procedure MarkVariant(index, v : byte);
        var i : byte;
    begin
        for i := 1 to 9 do
            if i = v
            then sTmp[index][i] := TRUE
            else sTmp[index][i] := FALSE;
    end;
    
  Procedure InitSolveTemplate(SDK : SuDoKu);
       var x, y : byte;
    begin
        // nustatomos pradinės reikšmės
        for y := 1 to 81 do
            for x := 1 to 9 do
                sTmp[y][x] := TRUE;
        // pakeičiamos pagal sudoku reikšmes
        for y := 1 to 9 do
            for x := 1 to 9 do
                if SDK[y][x] > 0
                then MarkVariant((y-1)*9+x, SDK[y][x]);
    end;
    
  Procedure EliminateVariants(SDK : SuDoKu; x, y : byte);
        var row,col, i,j, qX,qY, index : byte;
    begin
        col := x;
        row := y;
        index := (y-1)*9 + x;
        
        // tikrina eilute
        for i := 1 to 9 do
        begin
            if (SDK[row][i] > 0) and (i <> col)
            then sTmp[index][SDK[row][i]] := FALSE;
        end;

        // tikrina stulpeli
        for i := 1 to 9 do
        begin
            if (SDK[i][col] > 0) and (i <> row)
            then sTmp[index][SDK[i][col]] := FALSE;
        end;

        qY := ((y-1) div 3 +1) *3;
        qX := ((x-1) div 3 +1) *3;

        // tikrina kvadrateli
        for j := qY-2 to qY do
            for i := qX-2 to qX do
            begin
                if (SDK[j][i] > 0) and ((i <> col) AND (j <> row))
                then sTmp[index][SDK[j][i]] := FALSE;
            end;
    end;

  Procedure CheckIfOnePossible(SDK : SuDoKu; x, y : byte);
      var i,j, v, qX,qY, index : byte;
          onlyR, onlyC, onlyQ : boolean;
    begin
        index := (y-1)*9 + x;

        for v := 1 to 9 do
            if hasVariant(index, v)   // sTmp[index][SDK[row][i]])
            then begin
                onlyR := TRUE;
                onlyC := TRUE;
                onlyQ := TRUE;

                // patikrinti eilute
                i := 1;
                while (i <= 9) and onlyR do
                begin
                    if hasVariant((y-1)*9+i, v) and (i<>x)
                    then onlyR := FALSE;
                    i := i+1;
                end;

                if not onlyR
                then begin
                    // patikrinti stulpeli
                    i := 1;
                    while (i <= 9) and onlyC do
                    begin
                        if hasVariant((i-1)*9+x, v) and (i<>y)
                        then onlyC := FALSE;
                        i := i+1;
                    end;
                end;
                
                if  not (onlyR OR onlyC)
                then begin
                    qY := ((y-1) div 3 +1) *3;
                    qX := ((x-1) div 3 +1) *3;
                    // patikrinti kvadrateli
                    j := qY-2;
                    while (j <= qY) and onlyQ do
                    begin
                        for i := qX-2 to qX do
                            if hasVariant((j-1)*9+i, v) and ((i <> x) OR (j <> y))
                            then onlyQ := FALSE;
                        j := j + 1;
                    end;
                end;

                if onlyR OR onlyC OR onlyQ
                then MarkVariant(index, v);
            end;
    end;
    
  Function Minimal(index : byte; var min : byte) : boolean;
      var found : boolean;
    begin
        found := FALSE;
        while (min < 9) and (not found) do
        begin
            min := min + 1;  // jei buvo 3, tai prades nuo 4
            if sTmp[index][min]
            then found := TRUE;
        end;
        if found
        then Minimal := TRUE
        else Minimal := FALSE;
    end;
    
  Function BruteForce(var SDK : SuDoKu; gIndex : byte) : boolean;
      var gX, gY : byte;
          min : byte;
          isMin, valid, BF : boolean;
    begin
        gX := (gIndex-1) mod 9 + 1;
        gY := (gIndex-1) div 9 + 1;
        
        if gIndex = 81
        then begin
            if SDK[gY][gX] = 0
            then begin
                min := 0;
                repeat
                    isMin := Minimal(gIndex, min);
                    if isMin
                    then begin
                        SDK[gY][gX] := min;
                        valid := IsValidSuDoKu(SDK);
                    end;
                until valid or (not isMin);
                (* atvejis kai BF := TRUE yra, kai
                 * isValid(SDK) and gIndex=81 and  isMin = TRUE
                 *)
                if valid and isMin
                then BF := TRUE
                else begin
                    SDK[gY][gX] := 0;  // grąžinam pradinę reikšmę
                    BF := FALSE;
                end;
            end
            else begin
                (* atvejis kai BF := TRUE yra, kai
                 *  gIndex=81 and isValid(SDK) and SDK[Y][X] > 0
                 *)
                BF := TRUE;
            end;
        end
        else begin
            if SDK[gY][gX] = 0
            then begin
                min := 0;
                // ciklas spėti dar kart, jei prieš tai nepavyko
                repeat
                    repeat
                        isMin := Minimal(gIndex, min);
                        if isMin
                        then begin
                            SDK[gY][gX] := min;
                            valid := IsValidSuDoKu(SDK);
                        end;
                    until valid or (not isMin);

                  if valid and isMin
                    then BF := BruteForce(SDK, gIndex+1)
                    else begin
                        SDK[gY][gX] := 0;  // grąžinam pradinę reikšmę
                        BF := FALSE;
                    end;
                until BF or (not isMin);
            end
            else begin
                BF := BruteForce(SDK, gIndex+1);
            end;
        end;
        // grąžina ar ką pavyko padaryti su iki šiol spėtomis reikšmėmis
        // t.y. ar ta seka buvo tinkama ar ne.
        BruteForce := BF;
    end;

  Procedure Solve(var SDK : SuDoKu);
      var rasta : boolean;
          x, y, liko, sk : byte;
    begin
        sk := 0;
        repeat
            rasta := FALSE;
            for y := 1 to 9 do
                for x := 1 to 9 do
                    if SDK[y][x] = 0
                    then begin
                        EliminateVariants(SDK, x, y);
                        CheckIfOnePossible(SDK, x, y);
                        liko := KiekLiko(x, y, sk);
                        if liko = 1
                        then begin
                            SDK[y][x] := sk;
                            rasta := TRUE;
                        end;
                    end;
        until not rasta;
    end;
    
    
  Function Check(SDK : SuDoKu; nr : byte) : boolean;
      var quadX, quadY, i, j : byte;
          numbs : array[1..9] of boolean;
    begin
        Check := TRUE;
        for i:= 1 to 9 do
            numbs[i] := FALSE;
        // tikrina eilute
        for i := 1 to 9 do
            if SDK[nr][i] > 0
            then
                if numbs[SDK[nr][i]]
                then Check := FALSE
                else numbs[SDK[nr][i]] := TRUE;

        for i:= 1 to 9 do
            numbs[i] := FALSE;
        // tikrina stulpeli
        for i := 1 to 9 do
            if SDK[i][nr] > 0
            then
                if numbs[SDK[i][nr]]
                then Check := FALSE
                else numbs[SDK[i][nr]] := TRUE;

        for i:= 1 to 9 do
            numbs[i] := FALSE;
        quadY := (nr-1) div 3 + 1;
        quadX := (nr-1) mod 3 + 1;

        // tikrina kvadrateli
        for i := quadX*3-2 to quadX*3 do
            for j := quadY*3-2 to quadY*3 do
            begin
                if SDK[i][j] > 0
                then
                    if numbs[SDK[i][j]]
                    then begin
                        Check := FALSE;
                    end
                    else numbs[SDK[i][j]] := TRUE;
            end;
    end;

  Function IsValidSuDoKu(SDK : SuDoKu) : boolean;
      var tikrina : boolean;
          zone : byte;
    begin
        zone := 1;
        tikrina := TRUE;
        IsValidSuDoKu := TRUE; // tarkim

        while tikrina do
        begin
            if not check(SDK, zone)
            then begin
                tikrina := FALSE;
                IsValidSuDoKu := FALSE;
            end;
            zone := zone + 1;
            if zone > 9
            then tikrina := FALSE;
        end;
    end;

  // tikrina ar užpildytas sudoku
  Function Solved(SDK : SuDoKu) : boolean;
        var x, y, left : byte;  // left - kiek sk. trūksta iki užpildymo
    begin
      left := 0;
      for y := 1 to 9 do
        for x := 1 to 9 do
          if (SDK[y][x] = 0)
          then left := left + 1;
      if left > 0
      then Solved := FALSE
      else Solved := TRUE;
    end;



begin

end.

