Unit FormulaToolkit;

interface

    Uses CRT, FormulaCar, FormulaTrack;

    Const { klavišai }
          KEY_UP     = $F072;
          KEY_LEFT   = $F075;
          KEY_RIGHT  = $F077;
          KEY_DOWN   = $F080;
          KEY_BSPACE = $0008;
          KEY_TAB    = $0009;
          KEY_ENTER  = $0013;
          KEY_ESC    = $0027;
          KEY_SPACE  = $0032;

          TRAFFIC_SIZE = 24;
          CAR_LENGTH = 7;
          CAR_WIDTH = 6;

          MY_CAR_COLOR = RED;
          NUM_OF_COLORS = 7;
          COLORS : array[1..NUM_OF_COLORS] of byte = (Blue, Green, Cyan, Red, Magenta, Brown, LightGray);
          OPTION_SELECT = LightGreen;
          MENU_COLOR = White;
          MENU_BACK_COLOR = Black;
          MENU_SELECT = Yellow;
          
          NUM_OF_OPPONENTS = 20;
          MAX_SPEED = 10;
          SPEEDS : array[1..MAX_SPEED] of Word = (300, 200, 150, 100, 80, 60, 50, 40, 30, 20);

          
    Type Traffic = array[1..TRAFFIC_SIZE] of CarType; { 0 - mano, 1..N kompas }
         JuostuAibe = set of 0..3;


  { nupiešia mygtuką }
  Procedure DrawButton(btnTitle : string; width, startX, startY : integer);
  Procedure DrawOption(title : string; width, startX, startY : integer);
  { nuskaito paspaustą klavišą ir grąžina vieną iš konstantų arba simbolio kodą }
  Function GetKey() : longint;
  Procedure ClearInputBuffer();

  Procedure InitMyCar(var mCar : CarType; color : byte);
  Procedure InitTrafficCars(var cars : Traffic; length, width, distance : byte; track : TrackType);
  
{  Procedure ClearCars(cars : Traffic);  }
  Procedure DrawCars(cars : Traffic);
{  Procedure MoveCars(var cars : Traffic; lanes : byte);  }
  Procedure RunTraffic(var cars : Traffic; lanes : byte);
  Function CheckCollision(car : CarType; cars : Traffic) : boolean;

  Procedure ShowStats(nick : string; gone, speed, lives : byte; score : word);
  Procedure UpdateStats(nick : string; gone, speed, lives : byte; score : word);
  Function ConfirmCrashDialog(lifes : byte) : boolean;
  Function PauseDialog() : boolean;
  Procedure ShowLostInfo(totalScore, score : word);
  Procedure ShowChampInfo(var totalScore : word; score, bonus : word; speed : byte);
  Procedure ShowFinishInfo(var totalScore : word; score, bonus : word; speed : byte);

  Procedure DrawLogo();
  
(******************************************************************************)

implementation

  { nupiešia mygtuką }
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

        GoToXY(startX, startY+1);
        Write(#186);
        for i := 1 to spaces do
            Write(' ');
        Write(btnTitle);
        for i := 1 to spaces do
            Write(' ');
        if xSpace then Write(' ');
        Write(#186);

        GoToXY(startX, startY+2);
        Write(#200); for i := 1 to width do Write(#205); Write(#188);
    end;

  Procedure DrawOption(title : string; width, startX, startY : integer);
       var i, ilgis, spaces : integer;
    begin
        ilgis := length(title);
        if (ilgis > width) then
        begin
            title := copy(title, 1, width);
            ilgis := length(title);
        end;
        spaces := width-ilgis;

       { GoToXY(startX, startY);
        WriteLn('.'); for i := 1 to width do Write('_'); Write('.'); }

        GoToXY(startX, startY+1);
        for i := 1 to spaces do
            Write(' ');
        Write(title);
        Write(' ');

        GoToXY(startX, startY+2);
        for i:= 1 to spaces-1 do
            Write(' ');
        for i:= spaces to width do
            Write('-');
    end;
    
  { nuskaito paspaustą klavišą ir grąžina vieną iš konstantų arba simbolio kodą }
  Function GetKey() : longint;
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
           #8: GetKey := KEY_BSPACE;    { BackSpace }
           #9: GetKey := KEY_TAB;       { TAB }
           #13: GetKey := KEY_ENTER;    { ENTER }
           #27: GetKey := KEY_ESC;      { Esc }
           else GetKey := Ord(key);
         end;
     end;
     
  Procedure ClearInputBuffer();
    begin
        while KeyPressed do
            ReadKey;
    end;

  { grąžina atsitiktinę juostą 0-3 }
  Function GetRandomLane(numOfLanes : byte; genLanes : JuostuAibe) : byte;
      var lane : byte;
    begin
        repeat
            lane := Random(numOfLanes);
            WriteLn('  lane: ', lane);
            WriteLn('  numOfLane: ', numOfLanes);
        until not (lane in genLanes);
        GetRandomLane := lane;
    end;

  Procedure InitMyCar(var mCar : CarType; color : byte);
    begin
        mCar := NewCar(21, 25-CAR_LENGTH+1, CAR_LENGTH, CAR_WIDTH, color, BLACK);
    end;

  Procedure InitTrafficCars(var cars : Traffic; length, width, distance : byte; track : TrackType);
     var i, posY : integer; posX, lane : byte;
         lanes : JuostuAibe;
  begin
      lanes := []; { tuščia }
      posY := 1;
      for i := 1 to TRAFFIC_SIZE do
      begin
          { generuojama nauja formulių grupė: }
          { 1-oje eilėje, po 1/2/3 formules   }
          if (i-1) mod (track.lanes-1) = 0
          then begin
              lanes := [];
              posY := posY - length;
          end;
          if ((i-1) mod (track.lanes-1) = 0) and (i <> 1)
          then posY := posY - distance;
          
          lane := GetRandomLane(track.lanes, lanes);
          lanes := lanes + [lane];  { pridedama naujas elementas į aibę }
          
          posX := GetLeftBound(track) + lane * width + 1;
         { posY := posY - length; }
          cars[i].posX := posX;
          cars[i].posY := posY;
          cars[i].length := length-1;
          cars[i].width := width-1;
          cars[i].color := BLUE;  { GetRandomColor(); }
          cars[i].clearColor := BLACK;
      end;
  end;
  
  Procedure ClearCars(cars : Traffic);
    var i : byte;
  begin
      for i := 1 to TRAFFIC_SIZE do
          ClearCar(cars[i]);
  end;
  
  Procedure DrawCars(cars : Traffic);
     var i : byte;
  begin
      for i := 1 to TRAFFIC_SIZE do
          DrawCar(cars[i]);
  end;
  
  Procedure MoveCars(var cars : Traffic; lanes : byte);
    var i,j, n : byte;
  begin
      i := 1;
      lanes := lanes - 1;  { nes lanes = 2, 3, 4  }

      while i <= TRAFFIC_SIZE do
      begin
          for j := i to i+lanes-1 do
          begin
              cars[j].posY := cars[j].posY + 1;
              if cars[j].posY = 26 { išvažiavo iš ekrano }
              then begin
                  { parenkama paskutinė formule }
                  if (i = 1) then n := TRAFFIC_SIZE
                  else n := i-lanes;
                  cars[j].posY := cars[n].posY - 3*(cars[j].length+1)
              end;
          end;
          i := i + lanes;
      end;
  end;
  
  Procedure RunTraffic(var cars : Traffic; lanes : byte);
    begin
        ClearCars(cars);
        MoveCars(cars, lanes);
        DrawCars(cars);
    end;
  
  
  Function CheckCollision(car : CarType; cars : Traffic) : boolean;
      var i : byte;
          boom : boolean;
    begin
        boom := FALSE;
        for i := 1 to TRAFFIC_SIZE do
            if cars[i] ** car then boom := TRUE;

        CheckCollision := boom;
    end;

  Function CheckFinished(car : CarType; fLine : FinishLineType) : boolean;
    begin
        if fLine.posY > car.posY
        then CheckFinished := TRUE
        else CheckFinished := FALSE;
    end;
  
  
  Procedure WaveFinishLine();
    begin

    end;

  Procedure DrawFrame(posX, posY, width, height, backColor : byte; useLabel : string);
      var i, j : byte;
    begin
        Window(posX, posY, posX+width+2, posY+height+2);
        TextBackground(White);
        ClrScr;
        Window(20, 5, 20+width, 5+height);
        TextBackground(backColor);
        ClrScr;
        TextColor(MENU_COLOR);

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
        Write(' Use: ', useLabel);

    end;
  

  procedure DrawButton3D(selected : boolean; title : string; x, y, back : byte);
      var bWidth, i : byte;
    begin
        bWidth := Length(title) +2;
        { išvalomas senas }
        TextBackground(back);
        GoToXY(x, y);
        for i := 1 to bWidth+1 do
            Write(' ');
        GoToXY(x+1, y+1);
        for i := 1 to bWidth do
            Write(' ');
        { piešiamas naujas }
        if selected
        then begin
            TextBackground(BLUE);
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
  
  Function ConfirmCrashDialog(lifes : byte) : boolean;
      var done : boolean;
          key : longint;
          select, height, width : byte;

    begin
        done := FALSE;
        height := 11;
        width := 30;
        select := 1;
        
        DrawFrame(19, 4, width, height, RED, Concat(#24#25#27#26, ' or TAB'));
        
        GoToXY(3, 3);
        Write('You have crashed your car!');
        GoToXY(3, 5);
        Write('Do you want to restart?');

        repeat
            DrawButton3D(select=1, 'Restart', 4, 7, RED);
            DrawButton3D(select=2, 'Main Menu', 4, 9, RED);

            key := GetKey();
            case key of
              KEY_UP: select := 1;
              KEY_DOWN: select := 2;
              KEY_ENTER: done := TRUE;
              KEY_LEFT: select := 1;
              KEY_RIGHT: select := 2;
              KEY_TAB: if select = 1 then select := 2
                       else select := 1;
              KEY_ESC: begin
                           select := 1;
                           done := TRUE;
                       end;
            end;
        until done;

        ConfirmCrashDialog := select = 1;
    end;
    
  Function PauseDialog() : boolean;
      var unPause, resume : boolean;
          key : longint;
          select : byte;
    begin
        resume := TRUE;
        unPause := FALSE;

        DrawFrame(19, 4, 20, 11, BROWN, Concat(#24#25, ' and ENTER'));
        GoToXY(7, 3);
        Write('PAUSE');
        GoToXY(6, 4);
        Write('=======');

        repeat
            DrawButton3D(resume, 'Resume', 5, 7, BROWN);
            DrawButton3D(not resume, 'Exit', 5, 9, BROWN);
            key := GetKey();
            case key of
              KEY_UP: resume := TRUE;
              KEY_DOWN: resume := FALSE;
              KEY_ENTER: unPause := TRUE;
              KEY_ESC: begin
                           resume := TRUE;
                           unPause := TRUE;
                       end;
            end;
        until unPause;
        PauseDialog := resume;
    end;
    
  Procedure ShowLostInfo(totalScore, score : word);
    begin
        Window(19, 4, 51, 20);
        TextBackground(White);
        ClrScr;
        Window(20, 5, 50, 19);
        TextBackground(RED);
        ClrScr;
        TextColor(White);
        WriteLn;
        WriteLn('  You have LOST the race!');
        WriteLn;
        WriteLn('  Your score is ');
        WriteLn('     Level score: ', score);
        WriteLn('     Total score: ', totalScore);
        WriteLn;
        TextColor(MENU_SELECT);
        DrawButton('OK', 6, WhereX + 4, WhereY);
        repeat
        { wait for enter }
        until GetKey = KEY_ENTER;
    end;

    
  Procedure ShowFinishInfo(var totalScore : word; score, bonus : word; speed : byte);
    begin
        Window(19, 4, 51, 20);
        TextBackground(White);
        ClrScr;
        Window(20, 5, 50, 19);
        TextBackground(Brown);
        ClrScr;
        TextColor(White);
        WriteLn;
        WriteLn('  You have finished race ');
        WriteLn;
        WriteLn('  Your score is ');
        WriteLn('    Driving: ', score);
        WriteLn('      Speed: ', speed);
        WriteLn('      Bonus: ', bonus);
        WriteLn('  Total score: ', totalScore);
        WriteLn('  ------------------');
        WriteLn('   New score: ', totalScore + score + bonus);
        WriteLn;
        TextColor(MENU_SELECT);
        DrawButton('OK', 6, WhereX + 4, WhereY);
        repeat
        { wait for [enter] }
        until GetKey = KEY_ENTER;
    end;
  
  Procedure ShowChampInfo(var totalScore : word; score, bonus : word; speed : byte);
    begin
        Window(17, 4, 51, 21);
        TextBackground(White);
        ClrScr;
        Window(18, 5, 50, 20);
        TextBackground(Brown);
        ClrScr;
        TextColor(White);
        WriteLn;
        WriteLn('        CONGRATULATIONS!!! ');
        WriteLn(' You have finished championship');
        WriteLn;
        WriteLn('  Your score is ');
        WriteLn('    Driving: ', score);
        WriteLn('      Speed: ', speed);
        WriteLn('      Bonus: ', bonus);
        WriteLn('  ------------------');
        WriteLn('  Total score: ', totalScore);
        WriteLn('  ------------------');
        WriteLn('  Final score: ', totalScore + score + bonus);
        WriteLn;
        TextColor(MENU_SELECT);
        DrawButton('OK', 6, WhereX + 4, WhereY);
        repeat
        { wait for enter }
        until GetKey = KEY_ENTER;
    end;

  
  Procedure ShowStats(nick : string; gone, speed, lives : byte; score : word);
  begin
      Window(54, 3, 76, 23);
      TextBackground(WHITE);
      ClrScr;
      Window(55, 4, 75, 22);
      TextBackground(YELLOW);
      TextColor(BLACK);
      ClrScr;
      UpdateStats(nick, gone, speed, lives, score);
  end;
  
  Procedure UpdateStats(nick : string; gone, speed, lives : byte; score : word);
  begin
      Window(55, 4, 75, 22);
      TextBackground(YELLOW);
      TextColor(BLACK);
      WriteLn;
      WriteLn('  ', nick);
      WriteLn('----------------');
      WriteLn('   Score: ', score);
      WriteLn;
      WriteLn('   Gone: ', gone);
      WriteLn;
      WriteLn('   Speed: ', speed);
      WriteLn;
      WriteLn('   Lifes: ', lives);
  end;

(******************************************************************************)
  
  Procedure DrawLogo();
      var logo : array[1..11] of string;
          i, j : byte;
    begin
        logo[1] := '    ||||||||||           _|||| TM ';
        logo[2] := '    ||||||||"          ]|||||| ';
        logo[3] := '   ]||||[              ||||||[ ';
        logo[4] := '   ]||||[                ||||[ ';
        logo[5] := '   ||||||||[    ||||[   ]||||  ';
        logo[6] := '   |||||||"    ]||||    ]||||  ';
        logo[7] := '  ]||||[                ||||[  ';
        logo[8] := '  ]||||[                ||||[  ';
        logo[9] := ' ]||||||[             ]||||||[ ';
       logo[10] := ' _____________________________ ';
       logo[11] := ' """""""""""""""';
       

        TextColor(LightRed);
        for i := 1 to 11 do
        begin
            for j := 1 to Length(logo[i]) do
            begin
                case logo[i][j] of
                  ']': Write(#222);
                  '|': Write(#219);
                  '[': Write(#221);
                  '"': Write(#223);
                  '_': Write(#220);
                else Write(logo[i][j]);
                end;
            end;
            WriteLn;
        end;
    end;
  

{------------------------------------------------------------------------------}

begin

end.

