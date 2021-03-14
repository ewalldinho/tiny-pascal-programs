program velykos;
   uses Crt;
   type mas = array [0..100] of char;

   {----------izanga----------}
  procedure izanga (var siand: integer; a: mas);
        var i: integer;
      begin
         a := 'PROGRAMA VELYKOS';
         TextBackGround (green);
         ClrScr;
         TextColor (black);
         GoToXY(25,7);
         for i := 1 to 5 do begin
                                Write ('*');
                                Delay (300);
                              end;
         Write('  ');
         for i := 0 to 17 do
           begin
              Write (a[i]);
              Delay (200);
           end;
         for i := 1 to 5 do begin
                                  Write ('*');
                                  Delay (150);
                            end;
         TextColor (red);
         GoToXY(29,12);
         WriteLn ('(c) 2005 by EWARuDO ');
         TextColor(3);
         GoToxy (37,20);
         WriteLn('press');
         TextColor (20);
         GoToxy (37,21);
         WriteLn ('ENTER');
         ReadLn; ClrScr;
 {--------------siandien-----------------------------}
         TextBackGround(blue);
         TextColor(green);
         ClrScr;
         GoToxy  (28,7);
         WriteLn ('Iveskite siandienos metus.');
         GoToxy  (30,9);
         WriteLn ('Siandien yra: ');
         GoToXY  (50,9);
         WriteLn ('metai.');
         Window (44,9,48,9);
         TextBackground (white);
         TextColor (black);
         ClrScr;
         ReadLn (siand);
         Window(1,1,80,25);
         TextBackGround (green);
         TextColor (blue);
         ClrScr;
      end;
   {---------ivestis----------}
  procedure ivesti (var M: integer);

      begin
         GoToXY(23,7);
         WriteLn ('Iveskite metus.');
         GoToXY(23,8);
         Write ('Metai kuriu Velyku data norite suzinoti: ');
         Window (64,8,68,8);
         TextBackground (white);
         ClrScr;
         ReadLn (M);
         Window (1,1,80,25);
      end;

   {---------vykdyti-----------}
  procedure vykdyti (var M, d1, d2, N:integer; G, C, x, z, D, E: integer);

      begin
         G := M mod 19 +1;       { Aukso skaicius }
         C := M div 100 +1;      {    Simtmetis   }
         x := 3*C div 4 -12;     {    Pataisos    }
         z := (8*C+5)div 25 -5 ;
{------------------------------------------------------------------}
{ Sekmadienio pataisa }
         D := 5*M div 4 -x -10;
         E := (11*G +20 +z -x) mod 30;
         N := 44 -E;
              if N<21 then N := N+30
                      else N := N;
         N := N+7 -((D+N)mod 7);
         if N>31 then d1 := N-31      {-balandzio N-31 diena---}
                 else d2 := N;        { kovo ',N,'diena}
      end;

   {----------isvesti----------}
  procedure isvesti ( N, d1, d2, M, siand: integer);
      begin
        TextBackGround (black);
        TextColor (Red);
        ClrScr;
        if N > 31 then
             begin
               if M < siand then
               begin
                   GoToxy(20,10);
                   WriteLn (M,' metais Velykos buvo balandzio ',d1,' diena.');
               end
               else begin
                   GoToxy(20,10);
                   WriteLn (M,' metais Velykos bus balandzio ',d1,' diena.');
               end;
             end
             else begin
                 if M<siand then
                 begin
                     GoToxy(20,10);
                     WriteLn (M,' metais Velykos bus kovo ',d2,' diena.');
                 end
                 else begin
                     GoToxy(20,10);
                     WriteLn (M,' metais Velykos bus kovo ',d2,' diena.');
                 end;
             end;
      end;

  {-------------------------pabaiga--------------------------}
  procedure pabaiga ;
      begin
         Gotoxy(65,19);
         WriteLn ('Press');
         TextColor(20);
         GoToxy(65,20);
         WriteLn ('ENTER');
         ReadLn;
         ClrScr;
      end;

  {---------programos pradzia------------}
   var siand,M,G,C,x,z,D,E,N,d1,d2 : integer;
       a: mas;

begin
   izanga  (siand,a);
   ivesti  (M);
   vykdyti (M, d1, d2, N, G, C, x, z, D, E);
   isvesti (N, d1, d2, M, siand);
   pabaiga;
end.
