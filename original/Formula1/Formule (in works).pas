Program FORMULA_1_TM;
   Uses Crt;
   Type formule1 = record
                     xfp, yfp : byte;        { formules priekio koordinates }
                                             {  xfg, yfg,  formules galo koordinates    }
                     sp : byte;       { formules spalva              }
                   end;
                   
{ ------------ paruosiama trasa ------------ }
  Procedure design;
      begin
        Window(1,1,80,25);            { paruosia ekrana }
        TextBackground(0); ClrScr;
        GoToXY(32,5); TextColor(red);
        Write('FORMULA ONE 2oo5');
        GoToXY(31,15); TextColor(brown);
        Write(#168,' by EWARuDO 2005 ');
        GoToXY(65,23);
        TextColor(red+blink);
        WriteLn('[+ENTER+]');
        ReadLn;
        TextBackground(green);
        ClrScr;
        Window(32,1,49,25);
        TextBackground(brown);
        ClrScr;
        Window(33,1,48,25);
        TextBackground(black);
        ClrScr;
        Window(55,2,75,24);
        TextBackground(3);
        ClrScr;
        Randomize;
      end;  {design}
      
      
      
  Procedure formule(bolid : formule1);
      begin
        With bolid do
          begin
            Window(xfp, yfp, xfp+6, yfp+4);
            Textbackground(sp);
            ClrScr;
          end;
      end;  { formule }
      
  Procedure player(var car : formule1; sim: char);
    begin
      Formule(car);
      sim := ReadKey;
      Case sim of
        #0: begin
              sim := ReadKey;
              Case sim of
                #72: if car.yfp > 1 then begin   { Up }
                                         car.sp := black;
                                         formule(car);
                                         car.yfp := car.yfp - 1;
                                         car.sp := red;
                                         formule(car);
                                       end;
                #75: if car.xfp = 41 then begin   { Left }
                                         car.sp := black;
                                         formule (car);
                                         car.xfp := car.xfp - 7;
                                         car.sp := red;
                                         formule(car);
                                       end;
                #77: if car.xfp = 34 then begin   { Right }
                                         car.sp := black;
                                         formule (car);
                                         car.xfp := car.xfp + 7;
                                         car.sp := red;
                                         formule (car);
                                       end;
                #80: if car.yfp+4 < 25 then begin  { Down }
                                         car.sp := black;
                                         formule (car);
                                         car.yfp := car.yfp + 1;
                                         car.sp := red;
                                         formule (car);
                                       end;
              end;  {Case sim of}
            end;  {begin}
      end;    {case sim of}
    end;  { player }
      
      
  Procedure rancar (var rcar : formule1);
      begin
        if rcar.yfp < 5 then begin                    { masina ivaziuoja i ekrana}
                        TextBackGround(rcar.sp);
                        Window (rcar.xfp,1,rcar.xfp+6,rcar.yfp);
                        ClrScr;
                       end;
        if (rcar.yfp >= 5) and (rcar.yfp <= 25)              { vaziuoja per ekrana }
           then begin
                 Window (rcar.xfp,rcar.yfp-4,rcar.xfp+6,rcar.yfp);
                 TextBackGround(rcar.sp);
                 ClrScr;
                end;
        if rcar.yfp > 25                               { ir is jo isvaziuoja }
           then begin
                Window (rcar.xfp,rcar.yfp-4,rcar.xfp+6,25);
                TextBackGround(rcar.sp);
                ClrScr;
                end;
      end;  { rancar }
    
    
{ --------------------------- Programos veiksmai --------------------------- }
   var  f1,
        rc1,
        rc2 : formule1;   { formules }
        vieta, sk: byte;
        sim: char;
        avarija: boolean;
Begin
  Design;
  f1.xfp := 34;           { pradines reiksmes }
  f1.yfp := 21;
  f1.sp  := red;
  sk := 0;
  formule(f1);
  repeat
    vieta := Random(10);
    if vieta <= 5 then rc1.xfp := 34
                  else rc1.xfp := 41;
    rc1.yfp := 1;
    rc1.sp  := green;
    Rancar(rc1);
    Delay(100);
    rc1.yfp := rc1.yfp + 1;
    repeat
      formule(f1);
      rc1.sp := 0;
      Rancar(rc1);
      rc1.sp := green;
      Rancar(rc1);
      Delay(100);

      if KeyPressed
        then player(f1,sim);
    until rc1.yfp > 29;
    rc1.yfp := rc1.yfp-1;  rc1.sp := black;
    Rancar(rc1);
    rc1.yfp := rc1.yfp+1;
    sk := sk + 1;
  until sk = 10;
  ReadLn;
End.
