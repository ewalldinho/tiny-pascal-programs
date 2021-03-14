Unit FormulaTrack;

interface
    Uses CRT;

    Type TrackPoint = record
             x, y : byte;
             color : byte;
         end;
         TrackBound = array[1..25] of TrackPoint;
         FinishLineType = record
            posX, posY : byte; // pirmo taðko vieta
            color1, color2 : byte; // juoda / balta
            width : byte; // daþniausiai 1
            length : byte; // linijos ilgis
         end;
         TrackType = record
            leftBound : TrackBound;
            rightBound : TrackBound;
            laneWidth : byte;
            width : byte;
            lanes : byte;
         end;
         


  Procedure InitTrack(var track : TrackType; startX, laneWidth, lanes : byte);
  
  Procedure DrawTrack(track : TrackType);
  
  Function GetLeftBound(track : TrackType) : byte;
  Function GetRightBound(track : TrackType) : byte;

  Function NewFinishLine(color1, color2, width : byte; track : TrackType) : FinishLineType;
  Procedure MoveFinishLine(var fLine : FinishLineType);
  
(******************************************************************************)

implementation

  Procedure InitTrack(var track : TrackType; startX, laneWidth, lanes : byte);
      var i, width : byte;
    begin
        track.laneWidth := laneWidth;
        track.lanes := lanes;
        track.width := lanes * laneWidth;
        for i := 1 to 25 do
        begin
            track.leftBound[i].x := startX;
            track.leftBound[i].y := i;
            if i mod 3 = 0
            then track.leftBound[i].color := RED
            else track.leftBound[i].color := WHITE;
            
            track.rightBound[i].x := startX + track.width + 1;
            track.rightBound[i].y := i;
            if i mod 3 = 0
            then track.rightBound[i].color := RED
            else track.rightBound[i].color := WHITE;
        end;
    end;

  Procedure DrawTrack(track : TrackType);
      var i : byte;
    begin
        // viskas - þolë
        Window(1, 1, 80, 25);
        TextBackground(GREEN);
        ClrScr;
        // trasa
        Window(track.leftBound[1].x, 1, track.rightBound[25].x, 25);
        TextBackground(BLACK);
        ClrScr;
        // trasos kraðtai
        for i := 1 to 25 do
        begin
            Window(track.leftBound[i].x, track.leftBound[i].y, track.leftBound[i].x, track.leftBound[i].y);
            TextBackground(track.leftBound[i].color);
            ClrScr;
            Window(track.rightBound[i].x, track.rightBound[i].y, track.rightBound[i].x, track.rightBound[i].y);
            TextBackground(track.rightBound[i].color);
            ClrScr;
        end;
    end;


  Function GetLeftBound(track : TrackType) : byte;
    begin
        GetLeftBound := track.leftBound[1].x;
    end;
    
  Function GetRightBound(track : TrackType) : byte;
    begin
        GetRightBound := track.rightBound[1].x;
    end;


  Function NewFinishLine(color1, color2, width : byte; track : TrackType) : FinishLineType;
      var nLine : FinishLineType;
    begin
        nLine.posX := GetLeftBound(track)+1;
        nLine.posY := 1;
        nLIne.color1 := color1;
        nLine.color2 := color2;
        nLine.width := width;
        nLine.length := track.width;

        NewFinishLine := nLine;
    end;

  Procedure ClearFinishLine(fLine : FinishLineType);
    begin
        Window(fLine.posX, fLIne.posY, fLine.posX+fLine.length-1, fLine.posY+fLine.width-1);
        TextBackground(BLACK);
        ClrScr;
    end;
    
  Procedure DrawFinishLine(fLine : FinishLineType);
      var i, j : byte;
    begin
        Window(fLine.posX, fLIne.posY, fLine.posX+fLine.length-1, fLine.posY+fLine.width-1);
        TextColor(fLine.color1);
        TextBackground(fLine.color2);
        ClrScr;
        for j := 1 to fLine.width do
            for i := 1 to fLine.length do
                if (j < fLine.width) OR ((j=fLine.width) and (i < fLine.length))
                then if (j+i) mod 2 = 0
                     then Write(' ')
                     else Write(#219);
    end;

  Procedure MoveFinishLine(var fLine : FinishLineType);
    begin
        ClearFinishLine(fLine);
        fLine.posY := fLine.posY + 1;
        DrawFinishLine(fLine);
    end;


begin
end.

