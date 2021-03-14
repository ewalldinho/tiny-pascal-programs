Program formula_1_2006_first_edition;
  Uses Crt;
  Type car = record
               x1, y1,         // pr. kaire
               x2, y2 : byte;  // galo desine
               sp     : byte;  // spalva
             end;
       mas = array[1..20] of car;
  Const r_sp : array[1..7] of integer = (blue, green, cyan, magenta, brown, yellow, white);
        tr_sp = black;
        
  Procedure paruosimas (var r_c : mas; i : integer);
        var x : byte;
    begin
      x := Random(15);
      If x mod 2 = 0
        then r_c[i].x1 := 34
        else r_c[i].x1 := 41;
      r_c[i].x2 := r_c[i].x1 + 6;
      r_c[i].y1 := 1;  // ar 0 ar 1 ???
      r_c[i].y2 := 1;  // ar 0 ar 1 ???
      r_c[i].sp := r_sp[Random(6)+1];
    end;
{------------------------------------------------------------------------------}
  Procedure valyti (a : car);
    begin
      Window(a.x1, a.y1, a.x2, a.y2);
      TextBackGround(tr_sp);
      ClrScr;
    end; // valyti

  Procedure vaziuoti (var r_c : mas; i : integer);
     begin
       With r_c[i] do
         begin
           if y2 < 5
             then begin
                    Window(x1, y1, x2, y2);
                    TextBackground(sp);
                    ClrScr
                  end;
           if (y2 >= 6) and (y2 <= 25)
             then begin
                    y1 := y1 + 1;
                    y2 := y2 + 1;
                    Window(x1, y1, x2, y2);
                    TextBackground(sp);
                    ClrScr
                  end;
           if y2 > 25
             then begin
                    y1 := y1 + 1;
                    Window(x1, y1, x2, y2);
                    TextBackground(sp);
                    ClrScr;
                  end;
         end;
     end;  // vaziuoti
{------------------------------------------------------------------------------}
  Procedure player(var auto : car; sim : char);
     begin
       Case sim of
         #72: begin           { Up }
                Valyti(auto);
                if auto.y1 > 1
                  then begin
                         auto.y1 := auto.y1 - 1;
                         auto.y2 := auto.y2 - 1;
                       end;
                With auto do
                  Window(x1, y1, x2, y2);
                TextBackground(auto.sp);
                ClrScr;
              end;
         #75: begin               { Left }
                Valyti(auto);
                if auto.x1 > 7
                  then begin
                         auto.x1 := auto.x1 - 7;
                         auto.x2 := auto.x2 - 7;
                       end;
                With auto do
                  Window(x1, y1, x2, y2);
                TextBackground(auto.sp);
                ClrScr;
              end;
         #77: begin               { Right }
                Valyti(auto);
                if auto.x1 < 73
                  then begin
                         auto.x1 := auto.x1 + 7;
                         auto.x2 := auto.x2 + 7;
                       end;
                With auto do
                  Window(x1, y1, x2, y2);
                TextBackground(auto.sp);
                ClrScr;
              end;
         #80: begin               { Down }
                Valyti(auto);
                if auto.y2 < 25
                  then begin
                         auto.y1 := auto.y1 + 1;
                         auto.y2 := auto.y2 + 1;
                       end;
                With auto do
                  Window(x1, y1, x2, y2);
                TextBackground(auto.sp);
                ClrScr;
              end;
       end; //case of
     end;
{------------------------------------------------------------------------------}

  var p   : car;
      r_c : mas;
      sim : char;
      avarija,
      pravaziavo : boolean;
      i, j : integer;
Begin
  Randomize;
  avarija := FALSE;
  pravaziavo := FALSE;
  p.x1 := 34; p.y1 := 21;
  p.x2 := 40; p.y2 := 25;
  p.sp := red;
  i := 0;
  While (i < 20) and (not avarija) do
    begin
      i := i +1;
      paruosimas(r_c, i);
      while (not avarija) and (not pravaziavo) do
        begin
          valyti(r_c[i]);
          vaziuoti (r_c, i);
          sim := ReadKey;
          player(p, sim);
          if (p.x1 = r_c[i].x1) and (p.y1 = r_c[i].y1)
            then avarija := TRUE;
          if r_c[i].y1 > 25
            then pravaziavo := TRUE;
        end;
    //  if avarija
      //  then stabdom(... ; ..);
    end
End.
