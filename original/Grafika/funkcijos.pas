program Spindulys;

  Uses CRT, Graph;
  
  const kelias = 'D:\TP\UNITS';

   
  var gd, gm : integer;
      plotis, aukstis : word;
      x0, y0, x, y : word;
      i, W, dx, dy : word;
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

  MoveTo(800, 100);    // zymeklis perkeliamas i tas koordinates

  LineTo(x1, y1);     //  breþia linija nuo þymeklio iki to taðko (x1, y1) 

  MoveRel(dx, dy : integer);   // perstumia zymekli tam tikra kryptimi
  
  LineRel(dx, dy : integer);   // kaip ir line to  tik tasko koordinates santykines
 
  Rectangle(x1, y1, x2, y2: integer);      //  staciakampis
  Circle(x,y:integer; r : word);  // apskritimas;  r - spindulys
  Arc(x,y: integer; k1, k2, r : word);   // apskritimo lankas;  k1, k2 - pradþios ir pabaigos kampai
  Ellipse(x,y: integer; k1, k2, rx, ry: word);  // elipse
  PieSlice(x1, y1, kampas1, kampas2 ,r);
  Bar( x1, y1, x2, y2 : integer );   //  uþpildytas  staciakampis
  Bar3D( x1, y1, x2, y2 : integer; z : word; virsus : boolean );   //  uþpildytas  3D staciakampis
  
  SetFillStyle(raðtas, spalva: word);   //  raðtas [0..11] , savas uþpildas: 12,  
  FloodFill (x,y: integer; KonturoSpalva : word); 
  
  SetFillPattern(savo_raðtas: FillPatternType; spalva: word);
        type FillPatternType = array[1..8] of byte;
		savo_ra6tas : FillPatternType = ($AA, $55, $AA, $55, $AA, $55, $AA, $55);
		
  SetViewPort(x1, y1, x2, y2: integer; boolean);
  
  OutTextXY(x1, x2: integer; tekstas: string);
  
  
{   
  function ImageSize (x1, y1, x2, y2 : integer) : word;   // skaiciuoja staciakampës ekrano srities (x2-x1) x (y2-y1) dydi baitais.

  procedure GetImage(x1, y1, x2, y2 : integer; var Adresas : pointer) ;nurodytos ekrano sritiesvaizda uzraso i atminties sriti, nurodoma rodykle Adresas. 
        //     Pirmi sesi baitai skirti issaugomos srities parametrams uþraðyti: plotis ir aukðtis.

procedure PutImage (x, y : integer; var Adresas : pointer; kaip : word);   // vaizdas kuris saugomas atmintyje ir kurio rodykle Adresas perkeliamas i ekrana (x, y). 
 {
	 CopyPut 	0    pakeicia ekrano dali anksciau issaugota
	 XorPut 	1    xor operacijas tarp buferio ir ekrano paveikslelio
	 OrPut 	2   or operacijas tarp buferio ir ekrano paveikslelio
	 AndPut  	3   and operacijas tarp buferio ir ekrano paveikslelio
	 NotPut 	4   invertuojamos spalvos
}  
  
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

  for i := 1 to 1000 do
    begin
        x := Random(plotis)+1;
        y := Random(aukstis)+1;
        PutPixel(x, y, (x+y) mod 100);
    end;

  Delay(1000);
  CloseGraph();

End.
