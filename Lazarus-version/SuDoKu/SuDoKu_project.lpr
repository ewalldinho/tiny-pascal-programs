(*******************************)
{
	Programa: Sudoku žaidimas (projektas perdarytas iš Fps į Lazarus)
	Funkcionalumas: sudoku įvedimas, užkrovimas iš failo, išsprendimas, išsaugojimas faile.
	Autorius: Evaldas Naujanis (evaldas.naujanis@gmail.com)
}

Program SuDoKu_project;

   Uses UnicodeCRT,
        SuDoKu_API, GUI_Toolkit, SuDoKu_Global;

   Var SDK : SuDoKu;
       menuItem : integer;
       ivestas,  // ar SuDoKu buvo ivestas
       // kai buna ivestas ir spaudziama Create -> Cancel inputed FALSE
       // bet SuDoKu buna jau ivestas prieš tai (ivestas = TRUE)
       confirmed,
       exitGame : boolean;

Begin
    { disable changing of characters CodePage, needed for box symbols to draw UI }
    //SetUseACP(FALSE);

    SetLanguage(LANG_LT);
    ChangeCursor(OFF);
    confirmed := FALSE;
    exitGame := FALSE;

    InitSuDoKu(SDK);

    ShowSuDoKuScreen;
    FullScreen;

    menuItem := 1;

    repeat
        if confirmed then ivestas := TRUE;
        FullScreen;

        Langas(30, 3, 75, 23, 7, 1);
        if IsValidSuDoKu(SDK)
        then ShowSuDoKu(SDK)
        else WriteLn(GetWord(TXT_INVALID_SUDOKU));

        Langas(1, 1, 29, 25, 7, 1);
        Menu(menuItem);
        case menuItem of
			{ Exit sudoku }
            0: exitGame := TRUE;
			{ Create sudoku }
            1: begin
                   Langas(30, 3, 70, 23, 7, 1);
                   if ivestas then
                   begin
                       PrintWord(TXT_CURRENT_SUDOKU_WILL_BE_LOST);
                       PrintWord(TXT_CONFIRM_CONTINUE);
                       if ConfirmDialog(35, 9, 24, GetWord(TXT_ANSWER_YES), GetWord(TXT_ANSWER_NO))
                       then begin
                           Langas(30, 3, 70, 23, 7, 1);
                           InitSuDoKu(SDK);
                           CreateSuDoKu(SDK, confirmed);
                       end;
                   end
                   else begin
                       InitSuDoKu(SDK);
                       CreateSuDoKu(SDK, confirmed);
                   end;
               end;
			{ Load sudoku }
            2: begin
                   Langas(30, 3, 75, 23, 6, 1);
                   if ivestas then
                   begin
                       PrintWord(TXT_CURRENT_SUDOKU_WILL_BE_LOST);
                       PrintWord(TXT_CONFIRM_CONTINUE);
                       if ConfirmDialog(35, 9, 24, GetWord(TXT_ANSWER_YES), GetWord(TXT_ANSWER_NO))
                       then begin
                           Langas(30, 3, 75, 23, 6, 1);
                           InputFromFile('sdk', SDK, confirmed);
                           if not IsValidSuDoKu(SDK)
                           then ivestas := FALSE;
                       end;
                   end
                   else begin
                       InputFromFile('sdk', SDK, confirmed);
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
                    PrintWord(TXT_NO_ACTIVE_SUDOKU);
                    PrintWord(TXT_PRESS_ENTER);
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
                          PrintWord(TXT_FAILED_TO_SOLVE_RATIONALLY);
                          PrintWord(TXT_ASK_SOLVE_BRUTEFORCE_LINE_1);
                          PrintWord(TXT_ASK_SOLVE_BRUTEFORCE_LINE_2);
                          if ConfirmDialog(35, 9, 24, GetWord(TXT_ANSWER_YES), GetWord(TXT_ANSWER_NO))
                          then begin
                            Langas(30, 3, 75, 23, 7, 1);
                            PrintWord(TXT_BRUTE_FORCE_STARTED);
                            PrintWord(TXT_WAIT_MESSAGE);

                            if BruteForce(SDK, 1)
                            then PrintWord(TXT_BRUTE_FORCE_SUCCESS)
                            else PrintWord(TXT_BRUTE_FORCE_FAILED);
                            PrintWord(TXT_PRESS_ENTER);
                            ReadLn;
                          end;
                      end;
                  end
                  else begin
                      PrintWord(TXT_NO_ACTIVE_SUDOKU);
                      PrintWord(TXT_PRESS_ENTER);
                      ReadLn;
                  end;
               end;
            { Save sudoku }
			5: begin
                  Langas(30, 3, 75, 23, 7, 1);
                  if ivestas
                  then SaveSuDoKu(SDK, 'sdk')
                  else begin
                     PrintWord(TXT_NO_ACTIVE_SUDOKU);
                     PrintWord(TXT_PRESS_ENTER);
                     ReadLn;
                  end;
               end;
			{ default: }
			else PrintWord(TXT_MENU_ITEM_UNKNOWN);
        end;
    until exitGame;


    Palaukti(500);
End.

