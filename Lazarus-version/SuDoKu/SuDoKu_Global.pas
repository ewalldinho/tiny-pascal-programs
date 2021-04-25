(*******************************)
{
	Modulis: SuDoKU_Global.
	Funkcionalumas: modulis skirtas žaidimo globalizavimui, pateikimui skirtingomis kalbomis.
	Autorius: Evaldas Naujanis (evaldas.naujanis@gmail.com) 
	
}

Unit SuDoKu_Global;

interface

  Type LanguageType = word;

  Const // languages
        LANG_LT = 101;
        LANG_EN = 102;
        // codes
        TITLE = 1;
        PRESS_ENTER = 1000;
        SuDoKu_FIRST = 1001;
        NOT_SELECTED = 1002;
        

  var lang : LanguageType;

  Procedure SetLanguage(language : LanguageType);
  Function GetWord(code : word) : string;
//  Function LT_Word(code : word) : string;
//  Function EN_Word(code : word) : string;

{----------------------------------------------}

implementation

  Function LT_Word(code : word) : string;
    begin
        case code of
          TITLE: LT_Word := 'SuDoKu sprendejas';
        else LT_Word := 'fraze nerasta';
        end;
    end;
    
  Function EN_Word(code : word) : string;
    begin
        case code of
          TITLE: EN_Word := 'SuDoKu solver';
        else EN_Word := 'phrase not found';
        end;
    end;

{-- nustatoma kalba --}	
  Procedure SetLanguage(language : LanguageType);
    begin
        lang := language;
    end;
    
{-- funkcjija gauti žodžiui ar frazei --}
  Function GetWord(code : word) : string;
    begin
        case lang of
          LANG_LT: GetWord := LT_Word(code);
          LANG_EN: GetWord := EN_Word(code);
        else GetWord := '-';
        end;
    end;
	
    
{----------------------------------------------}

begin
end.

