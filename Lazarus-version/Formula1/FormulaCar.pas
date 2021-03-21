Unit FormulaCar;

interface
  Uses CRT, FormulaTrack;
  
  Const { kryptys }
          LEFT  = $F01;
          RIGHT = $F02;
          FORTH = $F03;
          BACK  = $F04;
          

  Type CarType = record
           posX, posY: integer;
           length, width : byte;
           color : byte;
           clearColor : byte;
       end;
       TDirection = integer; { kryptis }

  Function NewCar(posX, posY, length, width, color, cColor : byte) : CarType;
  
  Procedure ClearCar(car : CarType);

  Procedure DrawCar(car : CarType);
  
  Procedure MoveCar(var car : CarType; dX, dY : byte);
  
  { patikrina ar ne avarija }
  Operator ** (car1, car2 : CarType) b  : boolean;
  
  Procedure MoveLeft(var car : CarType; track : TrackType);
  Procedure MoveRight(var car : CarType; track : TrackType);
  Procedure MoveUp(var car : CarType; track : TrackType);
  Procedure MoveDown(var car : CarType; track : TrackType);

implementation

  Function NewCar(posX, posY, length, width, color, cColor : byte) : CarType;
      var nCar : CarType;
    begin
        nCar.posX := posX;
        nCar.posY := posY;
        nCar.length := length-1;
        nCar.width := width-1; { nes piešia (posX,posY, posX+width-1, posY+height-1); }
        nCar.color := color;
        nCar.clearColor := cColor;
        NewCar := nCar;
    end;
    
  Procedure ClearCar(car : CarType);
      var nuo, iki : byte;
    begin
        if (car.posY+car.length <= 0) or (car.posY > 25)
        then begin
            nuo := 0;
            iki := 0;    { nepiešiama }
        end
        else begin
            if car.posY > 0 then nuo := car.posY
            else nuo := 1;
            if (car.posY + car.length > 25) then iki := 25
            else iki := car.posY+car.length;
        end;

        if (nuo > 0) and (iki > 0) then
        begin
            Window(car.posX, nuo, car.posX+car.width, iki);
            TextBackground(car.clearColor);
            ClrScr;
        end;
    end;
    
  Procedure DrawCar(car : CarType);
      var nuo, iki : byte;
    begin
        if (car.posY+car.length <= 0) or (car.posY > 25)
        then begin
            nuo := 0;
            iki := 0;    { nepiešiama }
        end
        else begin
            if car.posY > 0
            then nuo := car.posY
            else nuo := 1;
            if (car.posY + car.length > 25)
            then iki := 25
            else iki := car.posY+car.length;
        end;

        if (nuo > 0) and (iki > 0) then
        begin
            Window(car.posX, nuo, car.posX+car.width, iki);
            TextBackground(car.color);
            ClrScr;
        end;
    end;

  Procedure MoveCar(var car : CarType; dX, dY : byte);
    begin
        car.posX := car.posX + dX;
        car.posY := car.posY + dY;
    end;

  Operator ** (car1, car2 : CarType) b  : boolean;
    var X1, X2, Y1, Y2 : integer;
  begin
      if car1.posX >= car2.posX
      then begin
          X1 := car2.posX;
          X2 := car1.posX;
      end
      else begin
          X1 := car1.posX;
          X2 := car2.posX;
      end;
      if car1.posY >= car2.posY
      then begin
          Y1 := car2.posY;
          Y2 := car1.posY;
      end
      else begin
          Y1 := car1.posY;
          Y2 := car2.posY;
      end;
      b := (X1+car1.width >= X2) and (Y1+car1.length >= Y2);
  end;
  
  Procedure MoveLeft(var car : CarType; track : TrackType);
  begin
      if (car.posX > GetLeftBound(track)+car.width+1)
      then car.posX := car.posX - (car.width+1);
  end;

  Procedure MoveRight(var car : CarType; track : TrackType);
  begin
      if (car.posX+car.width < GetRightBound(track)-car.width-1)
      then car.posX := car.posX + (car.width+1);
  end;

  Procedure MoveUp(var car : CarType; track : TrackType);
  begin
      if (car.posY > 1)
      then car.posY := car.posY - 1;
  end;

  Procedure MoveDown(var car : CarType; track : TrackType);
  begin
      if (car.posY+car.length < 25)
      then car.posY := car.posY + 1;
  end;
  
  
begin

end.

