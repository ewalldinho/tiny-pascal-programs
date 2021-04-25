(*******************************)
{
	Modulis: GUI_Toolkit
	Funkcionalumas: failų nuskaitymas, parodymas; dialogai; atskiru GUI zonu reguliavimas.
	Autorius: Evaldas Naujanis (evaldas.naujanis@gmail.com) 
	
}

Unit GUI_Toolkit;

INTERFACE

   Uses CRT, DOS;

   Const KEY_UP = 72;
         KEY_DOWN = 75;
         KEY_LEFT = 77;
         KEY_RIGHT = 80;
         KEY_BACKSPACE = 8;
         KEY_TAB = 9;
         KEY_ENTER = 13;
         KEY_ESC = 27;

         EXTS_MAX = 10; // didžiausias extensionu kiekis
         FPP = 15;  // FILES_PER_PAGE
         
         BIG = 'b';
         OFF = 'f';
         ONN = 'n';
{
#174 <<
#175 >>
#176 [|]
#177 [//]
#178 [*]
#179  |
#180 -|
#181 Ą
#182 Č
#183 Ę
#184 Ė
#185 =||
#186 ||
#187 =\\
#188 =//
#189 I
#190 Š
#191 '|
#192 |_
#193 _|_
#194 '|'
#195 |-
#196 -
#197 -|-
#198 Ų
#199 Ū
#200 \\=
#201 //=
#202 =''=
#203 =,,=
#204 ||=
#205 =
#206 =||=
#207 Ž
#208 ą
#209 č
#210 ę
#211 ė
#212 į
#213 š
#214 ų
#215 ū
#216 ž
#217 _|
#218 ,-
-- blokai --
#219 []
#220 __
#221 [
#222  ]
#223 ''
}
   Type ExtsType = array[1..EXTS_MAX] of string;


  // nupiešia langą
  Procedure Langas(x1, y1, x2, y2 : Byte; BackgroundColor, ForegroundColor : Byte);
  // perrašo delay procedura
  Procedure Palaukti(time: word);
  // padaro langą 1,1, 80,25 ir jį išvalo
  Procedure FullScreen();
  
  Function ConfirmDialog(posX, posY, width : byte; yesTitle, noTitle : string) : boolean;
  
  (*  Rodo meniu su failų sąrašu ir leidžia pasirinkti vieną failą
   *   (+) failas : string - pasirinkto failo pavadinimas
   *   (+) exts : ExtsType - extensionu masyvas (['txt', 'sdk'])
   *   (+) maxSize  - maksimalus rodomo failo dydis baitais
   *   (+) maxFiles - kiek maxFailų parenka iš tinkamų
   *)
  Procedure SelectFile(dir : string; var failas : string; exts : ExtsType; maxSize : word);
  
  // išjungia, įjungia, padidina kursorių
  Procedure ChangeCursor(mode : char);

  // nubrėžia mygtuką kurio viršutinis kairys kampas X, Y ir jo plotis width
  Procedure DrawButton(btnTitle : string; width, startX, startY : integer);


  // nuskaito iš klaviatūros paspaudimą ir grąžina vieną iš atitinkamų const.
  Function GetKey() : word;


{------------------------------------------------------------------------------}

IMPLEMENTATION

  // nupiešia langą
  Procedure Langas(x1, y1, x2, y2 : Byte; BackgroundColor, ForegroundColor : Byte);
    begin
        Window(x1, y1, x2, y2);
        TextBackground(BackgroundColor);
        TextColor(ForegroundColor);
        ClrScr;
    end;

  // perrašo Delay procedura
  Procedure Palaukti(time: word);
    begin
        Delay(time);
    end;
    
  // išvalo visą ekraną
  Procedure FullScreen();
    begin
        Window(1, 1, 80, 25);
        TextBackground(WHITE);
        TextColor(BLACK);
        ClrScr;
    end;

  Function ConfirmDialog(posX, posY, width : byte; yesTitle, noTitle : string) : boolean;
      var done : boolean;
          key, select, i, j, height : byte;

      procedure YesNoButton(selected : boolean; title : string; x, y : byte);
          var bWidth, i : byte;
        begin
            bWidth := Length(title) +2;
            // išvalomas senas
            TextBackground(GREEN);
            GoToXY(x, y);
            for i := 1 to bWidth+1 do
                Write(' ');
            GoToXY(x+1, y+1);
            for i := 1 to bWidth do
                Write(' ');
            // piešiamas naujas
            if selected
            then begin
                TextBackground(RED);
                TextColor(YELLOW);
                GoToXY(x+1, y);
                Write(' ', title, ' ');
            end
            else begin
                TextColor(BLACK);
                GoToXY(x, y);
                for i := 1 to bWidth do
                    Write(' ');
                Write(#220);
                GoToXY(x+1, y+1);
                for i := 1 to bWidth do
                    Write(#223);

                TextBackground(BLUE);
                TextColor(WHITE);
                GoToXY(x    , y);
                Write(' ', title, ' ');
            end;
        end;
    begin
        done := FALSE;
        height := 7;
        select := 2;
        if posX + width > 80 then width := 80 - posX;
        Langas(posX, posY, posX+width, posY+height, GREEN, WHITE);
        Write(#201);
        for i := 1 to width-1 do
            Write(#205);
        Write(#187);
        GoToXY(1,2);
        for j := 1 to height-1 do
            begin
                Write(#186);
                for i := 1 to width-1 do
                    Write(' ');
                Write(#186);
            end;
        GoToXY(1, height);
        Write(#200);
        for i := 1 to width-1 do
            Write(#205);
        Write(#188);
        GoToXY(1, height+1);
        Write(' Use: '+ #27#26 +' or TAB');
        
        repeat
            YesNoButton(select=1, yesTitle, 4, 4);
            YesNoButton(select=2, noTitle, 12, 4);
            
            key := GetKey();
            case key of
              KEY_ENTER: done := TRUE;
              KEY_LEFT: select := 1;
              KEY_RIGHT: select := 2;
              KEY_TAB: if select = 1 then select := 2
                       else select := 1;
              KEY_ESC: begin
                           select := 2;
                           done := TRUE;
                       end;
            end;
        until done;

        ConfirmDialog := select = 1;
    end;

    
  // vidine funkcija surasti extensionu skaiciui
  Function CountExts(exts : ExtsType) : word;
      var i : word;
          yra : boolean;
    begin
        i := 0;
        yra := TRUE;
        repeat
            i := i + 1;
            if exts[i] = ''
            then yra := FALSE;
        until not yra;
        
        CountExts := i-1;
    end;
  // vidine funkcija suskaičiuoti tinkamiems failams
  Function CountPages(dir : string; exts : ExtsType; numOfExts : word; maxSize : word) : word;
        var numOfPages, i, numOfFiles : word;
            f : SearchRec;
    begin
        numOfFiles := 0;
        
        for i := 1 to numOfExts do
        begin
            // ieškoma *.exts[i] failų
            FindFirst(Concat(dir, '/*.', exts[i]), ARCHIVE, f);
            while (DosError=0) do
            begin
                if (f.Size <= maxSize) // pvz apribojama iki 512B
                then begin
                    numOfFiles := numOfFiles + 1;
                end;
                FindNext(f);
            end;
            FindClose(f);
        end;
        
        if numOfFiles mod FPP = 0
        then numOfPages := numOfFiles div FPP
        else numOfPages := numOfFiles div FPP + 1;
        
        CountPages := numOfPages;
    end;
    
  // suteikia GUI pasirenkant SuDoKu failą
  Procedure SelectFile(dir : string; var failas : string; exts : ExtsType; maxSize : word);
      var rec : SearchRec;
          i, nr, inPage, numOfFiles, numOfExts,
          p, page, pages : word;
          files : array[1..FPP] of string;
          done, telpaFailai : boolean;
    begin
        {if (dir = '.')
        then dir := ''
        else dir := Concat(dir, '/'); }
        nr := 0;   // pasirinktas failas
        done := FALSE;
        numOfExts := CountExts(exts);  // randamas exts skaičius
        pages := CountPages(dir, exts, numOfExts, maxSize);  // kiek iš viso puslapių
        
        if pages > 0
        then begin
            page := 1;  // dabartinis puslapis
            nr := 1;  // pažymėtas pirmas failas sąraše
            
            repeat
                numOfFiles := 0; // iš viso nuskaityta failų
                inPage := 0;   // nuskaityta į masyvą
                telpaFailai := TRUE;

                // nuskaitomi tinkami failai
                for i := 1 to numOfExts do
                begin
                    // ieškoma *.exts[i] failų
                    FindFirst(Concat(dir, '/*.', exts[i]), ARCHIVE, rec);
                    while (DosError=0) and telpaFailai do
                    begin
                        if (rec.Size <= maxSize) // pvz apribojama iki 512B
                        then begin
                            numOfFiles := numOfFiles + 1;
                            if numOfFiles > FPP*page
                            then telpaFailai := FALSE;
                            if (numOfFiles > FPP*(page-1)) and (numOfFiles <= FPP*page)
                            then begin
                                inPage := inPage + 1;
                                files[inPage] := rec.Name;
                            end;
                        end;
                        FindNext(rec);
                    end;
                    FindClose(rec);
                end;

                // atvaizduojami rasti failai
                ClrScr;
                //TextColor(BLACK);
                TextColor(YELLOW);
                WriteLn;
                Write(' Sudoku files: ');
                TextColor(LIGHTGRAY);
                Write('  <');
                for i := 1 to pages do
                begin
                    if (i = page) then TextColor(WHITE);

                    if (i < pages) then Write(i, ' ')
                    else Write(i);
                    if (i = page) then TextColor(LIGHTGRAY);
                end;
                TextColor(LIGHTGRAY);
                WriteLn('>');
                TextColor(LIGHTGRAY);
                
                // išrašomi failų pavadinimai
                for i := 1 to inPage do
                    if i = nr
                    then begin
                        TextColor(WHITE);
                        WriteLn('->', files[i]);
                        TextColor(LIGHTGRAY);
                    end
                    else WriteLn('  ', files[i]);

                // laukiama vartotojo veiksmų
                case (GetKey) of
                    KEY_UP: begin
                                nr := nr-1;
                                if (nr < 1) then nr := inPage;
                            end;
                    KEY_DOWN: begin
                                nr := nr+1;
                                if (nr > inPage) then nr := 1;
                              end;
                    KEY_LEFT: if (page > 1) then page := page - 1;
                    KEY_RIGHT: if (page < pages) then page := page + 1;
                    KEY_ENTER: done := TRUE;
                    KEY_ESC: begin
                                 nr := 0;
                                 done := TRUE;
                             end;
                end; // case
            until done;
        end
        else begin
            WriteLn('Nerasta tinkamu SuDoKu failu.');
            WriteLn('[enter]');
            ReadLn;
        end;
                
        if nr = 0
        then failas := ''
        else failas := files[nr];
    end;

  // keičia kursorių
  Procedure ChangeCursor(mode : char);
    begin
        if mode = OFF then CursorOff;
        if mode = ONN then CursorOn;
        if mode = BIG then CursorBig;
    end;

  // nupiešia mygtuką
  Procedure DrawButton(btnTitle : string; width, startX, startY : integer);
      var i, ilgis, spaces : integer;
          xSpace : boolean;
    begin
        ilgis := length(btnTitle);
        if (ilgis > width) then
        begin
            btnTitle := copy(btnTitle, 1, width);
            ilgis := length(btnTitle);
        end;
        spaces := width-ilgis;
        if spaces mod 2 = 0 then xSpace := FALSE
                            else xSpace := TRUE;
        spaces := spaces div 2;

        GoToXY(startX, startY);
        Write(#201); for i := 1 to width do Write(#205); Write(#187);
        //Write('╔'); for i := 1 to width do Write('═'); Write('╗');

        GoToXY(startX, startY+1);
        Write(#186); // ('║');
        for i := 1 to spaces do
            Write(' ');
        Write(btnTitle);
        for i := 1 to spaces do
            Write(' ');
        if xSpace then Write(' ');
        Write(#186); // ('║');

        GoToXY(startX, startY+2);
        Write(#200); for i := 1 to width do Write(#205); Write(#188);
        //Write('╚'); for i := 1 to width do Write('═'); Write('╝');
    end;

  // nuskaito paspaustą klavišą ir grąžina vieną iš konstantų arba simbolio kodą
  Function GetKey() : word;
        var key : char;
     begin
         key := ReadKey;
         case key of
           #0: begin
                key := ReadKey;
                case key of
                  #72: GetKey := KEY_UP;    { Up }
                  #75: GetKey := KEY_LEFT;  { Left }
                  #77: GetKey := KEY_RIGHT; { Right }
                  #80: GetKey := KEY_DOWN;  { Down }
                  else GetKey := 0;
                end;
           end;
           #8: GetKey := KEY_BACKSPACE; { BS }
           #9: GetKey := KEY_TAB;       { TAB }
           #13: GetKey := KEY_ENTER;    { ENTER }
           #27: GetKey := KEY_ESC;      { Esc }
           else GetKey := Ord(key);
         end;
     end;

{------------------------------------------------------------------------------}

begin

end.

