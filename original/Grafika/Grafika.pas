unit Grafika;

interface
  uses Graph;
  const Vieta = 'C:\Program Files\Fps\fpk106\';
  Procedure Ekranas (var dx, dy : integer);
{----------------------------------------------}

implementation

  Procedure Ekranas (var dx, dy : integer);
    var gd, gm : integer;
  begin
  gd := Detect;
  InitGraph (gd, gm, Vieta);
  if GraphResult <> grOk
     then begin
            WriteLn ('Aparaturos klaida!');
            Halt(1);
          end;
  dx := GetMaxX; dy := GetMaxY;
  end;

begin
end.
