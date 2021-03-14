unit Grafika;

interface

  uses Graph;

  procedure Ekranas ( var dx, dy : integer; kelias : string );
  
  {----------------------------------------------------------------------------------------------------------} 
  
implementation 

  procedure Ekranas();
      var gd, gm : integer;
    begin 
		GD := Detect();
		InitGraph( gd, gm, kelias );
		if GraphResult() <> GrOK 
			then begin
			  Write('');
			  Halt(1);
			end;
		dx := GetMaxX;
		dy := GetMaxY;
    end;
	
  {----------------------------------------------}
  
  begin
  end. 
  
 