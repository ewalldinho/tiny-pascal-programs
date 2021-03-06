program Spindulys;
  Uses CRT, Graph;
  
  const kelias = 'D:\TP\UNITS';

 procedure skaiciuoti (var a : word; var b : word);
     var width, height : word;
   begin
      width := GetMaxX();
      height := GetMaxY();
      
      if ( a >= 1 )and( a <= width-1 ) and (b = 1)
        then a := a+1;
      if ( a = width ) and (b >= 1)and( b<=height-1 )
        then b := b+1;
      if ( a>=2 )and( a<=width ) and (b=height)
        then a := a-1;
      if ( a=1 ) and (b>=2)and(b<=height)
        then b := b-1;
   end;
   
   
  var gd, gm : integer;
      plotis, aukstis : word;
      x0, y0, x, y : word;
      i, j ,
      W, dx, dy : word;
      tipas, kodas, storis : word;
      sim : char;
      gana : boolean;
      
Begin
  Write('  Spindulio plotis (1 iki 1000): ');
  ReadLn(W);
  gd := Detect;
  InitGraph(gd, gm, kelias);
  plotis := GetMaxX();
  aukstis := GetMaxY();
  SetBkColor(YELLOW);
  SetColor(GREEN);
  ClearDevice();  // isvalo ekrana
  tipas := 4;  // vartotojo nurodyta,  isstisine 0, punktyras 1, asine 2, taskine 3
  kodas := $9249;  //  spalvos kodas = 10101010 10101010  - 16 bitu
  storis := 3;   //  triju tasku
  SetLineStyle(tipas, kodas, storis);
  Line(10,10, 800,600);
  Line(10, 600, 800, 10);
  Line(450, 10, 360, 600);
  MoveTo(800, 100);    // zymeklis perkeliamas i tas koordinates
  LineTo(700, 200);

  ClearDevice;

  WriteLn('  kai atsibos spausk [ESC] ');
  sim := '0';
  x0 := plotis div 2;
  y0 := aukstis div 2;

  x := 1+W;
  y := 1;
  dx := 1;
  dy := 1;
  while not gana do
    begin
      skaiciuoti(x, y);
      SetColor(GREEN);
      Line(x0, y0, x, y);
      skaiciuoti(dx, dy);
      SetColor(YELLOW);
      Line(x0, y0, dx, dy);

      If KeyPressed
         then sim := ReadKey;
      if sim = #27
        then gana := TRUE;
    end;

  Randomize;

  j := 1;
  while j < 25 do
    begin
      for i := 1 to 65000 do
        begin
          x := Random(plotis)+1;
          y := Random(aukstis)+1;
          PutPixel(x, y, 10);
        end;
GoToXY(3, 4);
WriteLn('  Liko: ', 25-j:2);
      j := j+1;
    end;
  CloseGraph();

End.
