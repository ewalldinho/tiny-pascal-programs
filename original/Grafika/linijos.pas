program linijos;
   Uses Graph, grafika, Crt;
   Const mano : FillPatternType = ($3F, $3F, $30, $3F, $30, $3F, $3F,$00);
  var mx, my, i,
      gt, gb : integer;
begin
  Ekranas(mx, my);
  Randomize;
  for i := 1 to 100 do
    Line(random(mx), random(my), random(mx), random(my));
  Delay(1500);
  ClearDevice;
  SetfillStyle(1,red);
  Bar(300, 350, 350, 450);
  SetColor(blue);
  SetfillPattern(mano, green);
  Circle(200, 100, 50);
  FloodFill(200, 100, blue);
  SetLineStyle(4, $B6DB, 3);
  Rectangle(400, 300, 500, 400);
  SetfillPattern(mano, yellow);
  FloodFill(200, 100, blue);
  SetfillPattern(mano, LightGreen);
  FloodFill(450, 350, blue);
  Write('enter');
  ReadLn;
  CloseGraph
end.
