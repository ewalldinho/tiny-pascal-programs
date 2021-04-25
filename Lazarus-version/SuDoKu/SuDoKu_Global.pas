(*******************************)
{
	Modulis: SuDoKu_Global.
	Funkcionalumas: modulis skirtas žaidimo globalizavimui, pateikimui skirtingomis kalbomis.
	Autorius: Evaldas Naujanis (evaldas.naujanis@gmail.com)

    Special symbols: arrow left: #27 (←), arrow right: #26 (→)
}

Unit SuDoKu_Global;

interface

  Uses SysUtils;

  Type LanguageType = word;

  Const // languages
        LANG_LT = 101;
        LANG_EN = 102;
        // codes
        TXT_TITLE = 1000;
        TXT_PRESS_ENTER = 1001;
        TXT_CONFIRM_CONTINUE = 1002;
        TXT_ANSWER_YES = 1003;
        TXT_ANSWER_NO = 1004;
        TXT_MENU_ITEM_UNKNOWN = 1005;
        TXT_MENU_TITLE = 1006;
        TXT_MENU_CREATE = 1007;
        TXT_MENU_LOAD = 1008;
        TXT_MENU_EDIT = 1009;
        TXT_MENU_SOLVE = 1010;
        TXT_MENU_SAVE = 1011;
        TXT_MENU_EXIT = 1012;
        TXT_INVALID_SUDOKU = 1013;
        TXT_SAVE_AS = 1014;
        TXT_SAVED_IN_FILE = 1015;
        TXT_SAVING_FAILED = 1016;
        TXT_ACTION_CANCELED = 1017;
        TXT_CURRENT_SUDOKU_WILL_BE_LOST = 1101;
        TXT_NO_ACTIVE_SUDOKU = 1102;
        TXT_FAILED_TO_SOLVE_RATIONALLY = 1103;
        TXT_ASK_SOLVE_BRUTEFORCE_LINE_1 = 1104;
        TXT_ASK_SOLVE_BRUTEFORCE_LINE_2 = 1105;
        TXT_BRUTE_FORCE_STARTED = 1106;
        TXT_WAIT_MESSAGE = 1107;
        TXT_BRUTE_FORCE_SUCCESS = 1108;
        TXT_BRUTE_FORCE_FAILED = 1109;
        TXT_PRESS_ENTER_SHORT = 1201;
        TXT_LOAD_SUDOKU_FAILED = 1202;
        TXT_LOAD_SUDOKU_SUCCESS = 1203;
        TXT_VALID_SUDOKU_FILE_NOT_FOUND = 1204;
        TXT_USE_ARROW_KEYS_OR_TAB = 1205;


  var CurrentLanguage : LanguageType;

  Procedure SetLanguage(language : LanguageType);
  Procedure ToggleLanguage();
  Function GetWord(code : word) : string;
  Procedure PrintWord(code : word);
//  Function LT_Word(code : word) : string;
//  Function EN_Word(code : word) : string;

{----------------------------------------------}

implementation

  Function LT_Word(code : word) : string;
    begin
        case code of
          TXT_TITLE: LT_Word := 'SuDoKu sprendėjas';
          TXT_PRESS_ENTER: LT_Word := 'spausk [enter]';
          TXT_INVALID_SUDOKU: LT_Word := 'Neteisingas SuDoKu!';
          TXT_ANSWER_YES: LT_Word := 'Taip';
          TXT_ANSWER_NO: LT_Word := 'Ne';
          TXT_CONFIRM_CONTINUE: LT_Word := 'Ar norite tęsti?';
          TXT_MENU_ITEM_UNKNOWN: LT_Word := 'Pasirinktas meniu punktas neegzistuoja';
          TXT_MENU_TITLE: LT_Word := '- SuDoKu meniu -';
          TXT_MENU_CREATE: LT_Word := 'Kurti naują';
          TXT_MENU_LOAD: LT_Word := 'Atidaryti';
          TXT_MENU_EDIT: LT_Word := 'Redaguoti';
          TXT_MENU_SOLVE: LT_Word := 'Išspręsti';
          TXT_MENU_SAVE: LT_Word := 'Išsaugoti';
          TXT_MENU_EXIT: LT_Word := 'Uždaryti';
          TXT_SAVE_AS: LT_Word := 'Išsaugoti kaip:';
          TXT_SAVING_FAILED: LT_Word := 'Klaida! SuDoKu išsaugoti nepavyko.';
          TXT_SAVED_IN_FILE: LT_Word := 'SuDoKu išsaugotas faile:';
          TXT_ACTION_CANCELED: LT_Word := 'Veiksmas atšauktas...';
          TXT_CURRENT_SUDOKU_WILL_BE_LOST: LT_Word := 'Esamas SuDoKu bus prarastas.';
          TXT_NO_ACTIVE_SUDOKU: LT_Word := 'Pirma įvesk SuDoKu.';
          TXT_FAILED_TO_SOLVE_RATIONALLY: LT_Word := 'Nepavyko išpręsti loginiu mąstymu.';
          TXT_ASK_SOLVE_BRUTEFORCE_LINE_1: LT_Word := 'Ar bandyti spręsti perrinkimo būdu?';
          TXT_ASK_SOLVE_BRUTEFORCE_LINE_2: LT_Word := 'Dėmesio! Perrinkimas gali ilgai užtrukti';
          TXT_BRUTE_FORCE_STARTED: LT_Word := 'Variantų perrinkimas pradetas.';
          TXT_WAIT_MESSAGE: LT_Word := 'Palaukite...';
          TXT_BRUTE_FORCE_SUCCESS: LT_Word := 'Išpręsta perrinkimo būdu.';
          TXT_BRUTE_FORCE_FAILED: LT_Word := 'Nepavyko išpręsti perrinkimo būdu.';
          TXT_PRESS_ENTER_SHORT: LT_Word := '[enter]';
          TXT_LOAD_SUDOKU_FAILED: LT_Word := 'Nepavyko atverti SuDoKu failo:';
          TXT_LOAD_SUDOKU_SUCCESS: LT_Word := 'SuDoku sekmingai nuskaitytas.';
          TXT_VALID_SUDOKU_FILE_NOT_FOUND: LT_Word := 'Nerasta tinkamų SuDoKu failų.';
          TXT_USE_ARROW_KEYS_OR_TAB: LT_Word := ' Naudok: ← → arba TAB';
        else LT_Word := '<frazė [' + IntToStr(code) + '] nerasta!>';
        end;
    end;

  Function EN_Word(code : word) : string;
    begin
        case code of
          TXT_TITLE: EN_Word := 'SuDoKu solver';
          TXT_PRESS_ENTER: EN_Word := 'press [enter]';
          TXT_INVALID_SUDOKU: EN_Word := 'Invalid SuDoKu!';
          TXT_ANSWER_YES: EN_Word := 'Yes';
          TXT_ANSWER_NO: EN_Word := 'No';
          TXT_CONFIRM_CONTINUE: EN_Word := 'Do you want to continue?';
          TXT_MENU_ITEM_UNKNOWN: EN_Word := 'Unknown menu item';
          TXT_MENU_TITLE: EN_Word := '- SuDoKu menu - ';
          TXT_MENU_CREATE: EN_Word := 'Create SuDoKu';
          TXT_MENU_LOAD: EN_Word := 'Load SuDoKu';
          TXT_MENU_EDIT: EN_Word := 'Edit SuDoKu';
          TXT_MENU_SOLVE: EN_Word := 'Solve SuDoKu';
          TXT_MENU_SAVE: EN_Word := 'Save SuDoKu';
          TXT_MENU_EXIT: EN_Word := 'Exit SuDoKu';
          TXT_SAVE_AS: EN_Word := 'Save current sudoku as: ';
          TXT_SAVING_FAILED: EN_Word := 'Error! Failed to save Sudoku.';
          TXT_SAVED_IN_FILE: EN_Word := 'SuDoKu saved in file:';
          TXT_ACTION_CANCELED: EN_Word := 'Action canceled...';
          TXT_CURRENT_SUDOKU_WILL_BE_LOST: EN_Word := 'Current sudoku will be lost.';
          TXT_NO_ACTIVE_SUDOKU: EN_Word := 'Firstly create new SuDoKu.';
          TXT_FAILED_TO_SOLVE_RATIONALLY: EN_Word := 'Failed to solve this sudoku rationally.';
          TXT_ASK_SOLVE_BRUTEFORCE_LINE_1: EN_Word := 'Do you want to run a BruteForce solution?';
          TXT_ASK_SOLVE_BRUTEFORCE_LINE_2: EN_Word := 'Warning! It may take some time.';
          TXT_BRUTE_FORCE_STARTED: EN_Word := 'BruteForce started.';
          TXT_WAIT_MESSAGE: EN_Word := 'Please wait...';
          TXT_BRUTE_FORCE_SUCCESS: EN_Word := 'Solved using BruteForce method.';
          TXT_BRUTE_FORCE_FAILED: EN_Word := 'Failed to solve using BruteForce method.';
          TXT_LOAD_SUDOKU_FAILED: EN_Word := 'Failed to load SuDoKu from file:';
          TXT_LOAD_SUDOKU_SUCCESS: EN_Word := 'SuDoku successfully loaded.';
          TXT_VALID_SUDOKU_FILE_NOT_FOUND: EN_Word := 'Did not find any valid SuDoKu file.';
          TXT_USE_ARROW_KEYS_OR_TAB: EN_Word := 'Use: ← → or TAB';
        else EN_Word := '<phrase [' + IntToStr(code) + '] not found!>';
        end;
    end;

{-- nustatoma kalba --}
  Procedure SetLanguage(language : LanguageType);
    begin
        CurrentLanguage := language;
    end;

{-- perjungiama sekanti kalba --}
  Procedure ToggleLanguage();
  begin
    if CurrentLanguage = LANG_LT
    then CurrentLanguage := LANG_EN
    else CurrentLanguage := LANG_LT;
  end;

{-- funkcija gauti žodžiui ar frazei --}
  Function GetWord(code : word) : string;
    begin
        case CurrentLanguage of
          LANG_LT: GetWord := LT_Word(code);
          LANG_EN: GetWord := EN_Word(code);
        else GetWord := '-';
        end;
    end;

{-- procedure to print translated phrase --}
  Procedure PrintWord(code : word);
  begin
      WriteLn(GetWord(code));
  end;

{----------------------------------------------}

Begin
End.

