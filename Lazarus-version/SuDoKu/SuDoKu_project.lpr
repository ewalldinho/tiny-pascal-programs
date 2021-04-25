(*******************************)
{
	Programa: Sudoku žaidimas (projektas perdarytas iš Fps į Lazarus)
	Funkcionalumas: sudoku įvedimas, užkrovimas iš failo, išsprendimas, išsaugojimas faile.
	Autorius: Evaldas Naujanis (evaldas.naujanis@gmail.com)
}

program SuDoKu_project;

   Uses SuDoKu_API, GUI_Toolkit, SuDoKu_Global;

  //const EXTS : array[1..2] of string = ('sdk', 'txt');
        //EXTC = 2;

   Var SDK : SuDoKu;
       menuItem : integer;
       i, j : integer;
       ivestas,  // ar SuDoKU buvo ivestas
       // kai buna ivestas ir spaudziama Create -> Cancel inputed FALSE
       // bet SuDoKU buna jau ivestas prieš tai (ivestas = TRUE)
       inputed,
       viskas : boolean;

begin
    SetLanguage(LANG_LT);
    ChangeCursor(OFF);
    inputed := FALSE;
    viskas := FALSE;

    ShowSuDoKuScreen;
    FullScreen;

    menuItem := 1;

    repeat
        if inputed then ivestas := TRUE;
        FullScreen;

        Langas(30, 3, 75, 23, 7, 1);
        if IsValidSuDoKu(SDK)
        then ShowSuDoKu(SDK)
        else WriteLn('Invalid SuDoKu!');

        Langas(1, 1, 29, 25, 7, 1);
        Menu(menuItem);
        case menuItem of
			{ Exit sudoku }
            0: viskas := TRUE;
			{ Create sudoku }
            1: begin
                   Langas(30, 3, 70, 23, 7, 1);
                   if ivestas then
                   begin
                       WriteLn('Esamas SuDoKu bus užmirštas.');
                       WriteLn('Ar norite testi?');
                       if ConfirmDialog(35, 9, 24, 'Taip', 'ne')
                       then begin
                           Langas(30, 3, 70, 23, 7, 1);
                           InitSuDoKu(SDK);
                           CreateSuDoKu(SDK, inputed);
                       end;
                   end
                   else begin
                       InitSuDoKu(SDK);
                       CreateSuDoKu(SDK, inputed);
                   end;
               end;
			{ Load sudoku }
            2: begin
                   Langas(30, 3, 75, 23, 6, 1);
                   if ivestas then
                   begin
                       WriteLn('Esamas SuDoKu bus užmirštas.');
                       WriteLn('Ar norite testi?');
                       if ConfirmDialog(35, 9, 24, 'Taip', 'Ne')
                       then begin
                           Langas(30, 3, 75, 23, 6, 1);
                           InputFromFile('sdk', SDK, inputed);
                           if not IsValidSuDoKu(SDK)
                           then ivestas := FALSE;
                       end;
                   end
                   else begin
                       InputFromFile('sdk', SDK, inputed);
                       if not IsValidSuDoKu(SDK)
                       then ivestas := FALSE;
                   end;
               end;
			{ Edit sudoku }
            3: begin
                  Langas(30, 3, 75, 23, 7, 1);
                  if ivestas
                  then EditSuDoKu(SDK)
                  else begin
                    WriteLn('Pirma ivesk SuDoKu.');
                    ReadLn;
                  end;
               end;
			{ Solve sudoku }
            4: begin
                  Langas(30, 3, 75, 23, 7, 1);
                  if ivestas
                  then begin
                      InitSolveTemplate(SDK);
                      Solve(SDK);
                      if not Solved(SDK)
                      then begin
                          WriteLn('Nepavyko išpręsti loginiu mąstymu.');
                          WriteLn('Ar norite bandyti spėjimo būdu?');
                          WriteLn('Time for BruteForce?');
                          if ConfirmDialog(35, 9, 24, 'Taip', 'Ne')
                          then begin
                            Langas(30, 3, 75, 23, 7, 1);
                            WriteLn('BruteForce sprendimas pradetas');
                            WriteLn('Palaukite...');

                            if BruteForce(SDK, 1)
                            then WriteLn('Ispresta BruteForce metodu.')
                            else WriteLn('Nepavyko ispresti BruteForce metodu.');
                            WriteLn('spausk [enter]');
                            ReadLn;
                          end;
                      end;
                  end
                  else begin
                      WriteLn('Pirma ivesk SuDoKu.');
                      ReadLn;
                  end;
               end;
            { Save sudoku }
			5: begin
                  Langas(30, 3, 75, 23, 7, 1);
                  if ivestas
                  then SaveSuDoKu(SDK, 'sdk')
                  else begin
                     WriteLn('Pirma ivesk SuDoKu.');
                     ReadLn;
                  end;
               end;
			{ default: }
			else WriteLn('Nepasirinko');
        end;
    until viskas;


    Palaukti(500);
end.

