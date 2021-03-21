program Formula1_game;

{$APPTYPE CONSOLE}

Uses CRT, FormulaCar, FormulaTrack, FormulaToolkit;


Procedure PlayGame(name : string; color, trackMode, speed : byte);
   var cars : Traffic;
       tr : TrackType;
       fl : FinishLineType;
       myCar : CarType;
       done, finish, crash, escape : boolean;
       code : longint;
       gone, counter, score, totalScore, lifes : word;
  begin
      Randomize;
      { inicijuoja kintamuosius }
      totalScore := 0;
      lifes := 3;
      done := FALSE;
      escape := FALSE;

      { pagrindinis ciklas }
      repeat
          crash := FALSE;
          finish := FALSE;
          counter := 0;
          gone := 0;
          score := 0;

          InitTrack(tr, 20, CAR_WIDTH, trackMode+1);
          fl := NewFinishLine(White, Black, 2, tr);
          InitMyCar(myCar, color);
          {               cars,  ilgis,     plotis,     atstumas,  trasa  }
          InitTrafficCars(cars, CAR_LENGTH, CAR_WIDTH, CAR_LENGTH*2, tr);
          DrawTrack(tr);
          DrawCar(myCar);
          DrawCars(cars);
          ShowStats(name, gone, speed, lifes, score);

          { lenktynių ciklas }
          repeat
              { clear, move, draw cars  }
              RunTraffic(cars, tr.lanes);

              counter := counter + 1;
              gone := (counter-11) div (3*CAR_LENGTH);
              score := gone * trackMode * 10;
              crash := CheckCollision(myCar, cars);

              ClearCar(myCar);

              { handle action  }
              if KeyPressed
              then begin
                  code := GetKey;
                  case code of
                  KEY_LEFT: MoveLeft(myCar, tr);
                  KEY_RIGHT: MoveRight(myCar, tr);
                  KEY_UP: MoveUp(myCar, tr);
                  KEY_DOWN:  MoveDown(myCar, tr);
                  KEY_ENTER: begin
                             if PauseDialog
                             then begin
                                 escape := FALSE;
                                 DrawTrack(tr);
                                 DrawCar(myCar);
                                 DrawCars(cars);
                                 ShowStats(name, gone, speed, lifes, score);
                             end
                             else escape := TRUE;
                           end;
                  KEY_ESC: begin
                               if PauseDialog
                               then begin
                                   escape := FALSE
                               end
                               else escape := TRUE;

                               DrawTrack(tr);
                               DrawCar(myCar);
                               DrawCars(cars);
                               ShowStats(name, gone, speed, lifes, score);
                           end;
                  end;
                  { išvalo kas liko KeyPressed! }
                  ClearInputBuffer;
              end;

              { check collision }
              crash := CheckCollision(myCar, cars);

              DrawCar(myCar);

              UpdateStats(name, gone, speed, lifes, score);

              if code = KEY_ESC
              then done := TRUE;
              if gone < NUM_OF_OPPONENTS
              then Delay(SPEEDS[speed])
              else finish := TRUE;

          until finish or crash or escape;

          if crash
          then begin
              Delay(500);
              if lifes > 0 then
                  if ConfirmCrashDialog(lifes)
                  then lifes := lifes - 1
                  else done := TRUE
              else begin
                  ShowLostInfo(totalScore+score, score);
                  done := TRUE;
              end;
          end;
          if finish
          then begin
              Delay(500);
              if speed < MAX_SPEED
              then begin
                  ShowFinishInfo(totalScore, score, speed * 100, speed);
                  totalScore := totalScore + speed * 100;
                  speed := speed + 1;
              end
              else begin
                  ShowChampInfo(totalScore, score, speed * 100, speed);
                  done := TRUE;
              end;
          end;
      until done or escape;  { kol išjungia ar kol pereina visą  }
  end;

Procedure SelectOptions(var nickName : string; var carColor, trackMode, speed : byte);
    var option, numOfOpts, colNum, i, posX, posY : byte;
        selected : boolean;
        Modes : array [1..3] of string;
        keyCode : longint;

    function ReadName(var name : string) : longint;
        var key : longint;
            len : word;
      begin
          CursorOn;
          len := Length(name);
          Write(name);
          repeat
              key := GetKey;
              case key of
                KEY_BSPACE: if len > 0
                            then begin
                                Delete(name, len, 1);
                                len := len - 1;
                                GoToXY(WhereX-1, WhereY);
                                ClrEol;
                            end;
                Ord('A')..Ord('Z'): begin
                                      Write(char(key));
                                      name := name + char(key);
                                      len := len + 1;
                                    end;
                Ord('a')..Ord('z'): begin
                                      Write(char(key));
                                      name := name + char(key);
                                      len := len + 1;
                                    end;
                Ord('0')..Ord('9'): begin
                                      Write(char(key));
                                      name := name + char(key);
                                      len := len + 1;
                                    end;
              end;
          until (key = KEY_DOWN) or (key = KEY_UP);
          ReadName := key;
          CursorOff;
      end;

  begin
      Window(1, 1, 80, 25);
      TextBackground(BLACK);
      TextColor(WHITE);
      ClrScr;

      Modes[1] := 'Easy';
      Modes[2] := 'Normal';
      Modes[3] := 'Hard';
      numOfOpts := 5;
      option := 1;
      selected := FALSE;
      colNum := carColor;
      if not trackMode in [1..3] then trackMode := 1;
      if not speed in [1..MAX_SPEED] then speed := 1;
      posX := 18;
      posY := 3;

      repeat
          // teksto ribos
          Window(posX, posY, posX+32, posY + 15);
          TextBackground(MENU_BACK_COLOR);
          ClrScr;

          if option = 1 then TextColor(MENU_SELECT)
          else TextColor(MENU_COLOR);
          DrawOption('Name:', 12, 1, 1);

          if option = 2 then TextColor(MENU_SELECT)
          else TextColor(MENU_COLOR);
          DrawOption('Car color:', 12, 1, 4);

          if option = 3 then TextColor(MENU_SELECT)
          else TextColor(MENU_COLOR);
          DrawOption('Track:', 12, 1, 7);

          if option = 4 then TextColor(MENU_SELECT)
          else TextColor(MENU_COLOR);
          DrawOption('Speed:', 12, 1, 10);
          WriteLn;
          if option = numOfOpts then TextColor(MENU_SELECT)
          else TextColor(MENU_COLOR);
          DrawButton('OK', 6, WhereX+15, WhereY);

          TextColor(MENU_COLOR);
          GoToXY(14, 2);
          Write(nickName);

          GoToXY(14, 5);
          TextBackground(COLORS[colNum]);
          Write('   ');
          GoToXY(14, 8);
          TextBackground(MENU_BACK_COLOR);
          for i := 1 to 3 do
              if trackMode = i then
              begin
                  TextColor(OPTION_SELECT);
                  Write(Modes[i], '   ');
                  TextColor(MENU_COLOR);
              end
              else Write(Modes[i], '   ');
          GoToXY(14, 11);
          for i := 1 to MAX_SPEED do
              if speed = i then
              begin
                  TextColor(OPTION_SELECT);
                  Write(i, ' ');
                  TextColor(MENU_COLOR);
              end
              else Write(i, ' ');

          {  vardo nuskaitymas  }
          if option = 1
          then begin
              Window(posX+13, posY+1, posX+23, posY+1);
              TextBackground(YELLOW);
              ClrScr;
              keyCode := ReadName(nickName);

              case keyCode of
                  KEY_UP: option := numOfOpts;
                  KEY_DOWN: option := option + 1;
              end;
          end
          else begin
              keyCode := GetKey;
              case keyCode of
                  KEY_UP: if option > 1 then option := option - 1
                          else option := numOfOpts;
                  KEY_DOWN: if option < numOfOpts then option := option + 1
                            else option := 1;
                  KEY_LEFT:  case option of
                         { 1: Read name }
                           2: if colNum > 1 then colNum := colNum - 1
                              else colNum := NUM_OF_COLORS;
                           3: if trackMode > 1 then trackMode := trackMode - 1
                              else trackMode := 3;
                           4: if speed > 1 then speed := speed - 1
                              else speed := MAX_SPEED;
                         { 5: - OK exit }
                         end;
                  KEY_RIGHT: case option of
                           2: if colNum < NUM_OF_COLORS then colNum := colNum + 1
                              else colNum := 1;
                           3: if trackMode < 3 then trackMode := trackMode + 1
                              else trackMode := 1;
                           4: if speed < MAX_SPEED then speed := speed + 1
                              else speed := 1;
                         end;
                  KEY_ENTER: if option = numOfOpts then selected := TRUE;
              end;
          end;

      until selected;

      carColor := COLORS[colNum];
  end;


Procedure MainMenu(selectedMenu : byte; firstTime : boolean);
  begin
      { logotipas piešiamas tik pirmą kartą  }
      if firstTime
      then begin
          Window(1, 1, 80, 25);
          TextBackground(MENU_BACK_COLOR);
          ClrScr;
          Window(20, 3, 60, 14);
          DrawLogo();
      end;

      Window(30, 15, 60, 25);
      { ClrScr; }
      if selectedMenu = 1 then TextColor(MENU_SELECT)
      else TextColor(MENU_COLOR);
      DrawButton('Play Game', 13, 1, 1);
      if selectedMenu = 2 then TextColor(MENU_SELECT)
      else TextColor(MENU_COLOR);
      DrawButton('Options', 13, 1, 4);
      if selectedMenu = 3 then TextColor(MENU_SELECT)
      else TextColor(MENU_COLOR);
      DrawButton('Exit', 13, 1, 7);
  end;


{------------------------------------------------------------------------------}

   var exitGame, selected : boolean;
       sMenu, numOfMenus : byte;
       name : string;
       color, trackMode, speed : byte;
       keyCode : longint;

begin
  { disable changing of characters CodePage, needed for box symbols to draw UI }
  SetUseACP(FALSE);

  CursorOff;
  numOfMenus := 3;
  sMenu := 1;
  exitGame := FALSE;
  name := 'anonym';
  color := RED;
  trackMode := 1;
  speed := 1;

  repeat
      MainMenu(sMenu, TRUE);

      selected := FALSE;
      repeat
          MainMenu(sMenu, FALSE);

          keyCode := GetKey;
          case keyCode of
              KEY_UP: if sMenu > 1 then sMenu := sMenu - 1
                  else sMenu := numOfMenus;
              KEY_DOWN: if sMenu < numOfMenus then sMenu := sMenu + 1
                     else sMenu := 1;
              KEY_ENTER: selected := TRUE;
          end;
      until selected;

      case sMenu of
        1: PlayGame(name, color, trackMode, speed);
        2: SelectOptions(name, color, trackMode, speed);
        3: exitGame := TRUE;
      end;

  until exitGame;

end.

