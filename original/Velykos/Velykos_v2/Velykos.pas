(******************************************************************************) 
(*                                                                            *)
(*   Autorius: Evaldas Naujanis                                               *)
(*   Sukûrimo laikas: 2008 m. vasario 5 d., 22:23:00                          *)
(*   Paskutiná kartà redaguota: 2008 m. geguþës 28 d.                         *)
(*                                                                            *)
(******************************************************************************)

Program Velykos;
    uses CRT, DOS;
    const men : array [1..4] of String = ('Sausio', 'Vasario', 'Kovo', 'Balandþio');
          mX = 41;  mY = 5;
          VX = 14;  VY = 8;
          minM = 326;
          maxM = 4099;
 {---  Y - metai ---}
    var Y : word;
        
    procedure vaizdas(lanSp : byte; txtSp : byte);
            var i, j : integer;
        begin
            GoToXY(1,1);
            TextColor(lanSp);
            Write(#201);
            for i := 1 to 77 do Write(#205);
            WriteLn(#187);

            Write(#186, '                    ');  TextColor(txtSp);
            Write('* Velyk',#214,' Datos Skai',#209,'iavimo Programa *');
            TextColor(lanSp);
            WriteLn    ('                    ', #186);

            Write(#204);
            for j := 1 to 77 do Write(#205);
            WriteLn(#185);

            for i := 1 to 16 do
                begin
                   Write(#186);
                   for j := 1 to 77 do Write(' ');
                   WriteLn(#186);
                end;
            Write(#204);
            for j := 1 to 77 do Write(#205);
            WriteLn(#185);
            Write(#186, '   ');  TextColor(txtSp);
            Write('[', #27, '][', #24, '] - praeiti metai');
            TextColor(lanSp);  Write(' ', #186, ' ');  TextColor(txtSp);
            Write('[', #25, '][', #26, '] - kiti metai');
            TextColor(lanSp);  Write('  ', #186, ' ');  TextColor(txtSp);
            Write('[Ins] - pasirinkti metus');
            TextColor(lanSp);
            WriteLn('  ', #186);

            Write(#186, '   ');  TextColor(txtSp);
            Write('[TAB] - keisti spalvas');
            TextColor(lanSp);  Write(' ', #186, ' ');  TextColor(txtSp);
            Write('[ESC] - baigti darb',#208);
            TextColor(lanSp);  Write(' ', #186, ' ');  TextColor(txtSp);
            Write('[BS] - rodyt ',#213,'iuos metus');
            TextColor(lanSp);
            WriteLn('  ', #186);

            Write(#200);
            for j := 1 to 77 do Write(#205);
            WriteLn(#188);
            
            TextColor(white);
            GoToXY(mX-7, mY);
            Write ('Metai: ', Y);
            GoToXY(VX-9, VY);
            Write('Velykos: ');
        end;
        
    procedure sieMetai();
          var mm, d, sav: word;
          { GetDate(metai,mënuo,diena, savaitës diena) }
        begin
            GetDate(Y,mm,d,sav);
            if (mm > 4) then Y:=Y+1;
            GoToXY(mX,mY);
            Write(Y);
        end;

    procedure tema();
           var w, t : byte;
        begin
            Randomize;
            w := Random(7)+1;
            t := Random(7)+1;
            vaizdas(w, t);
        end;
    procedure rasyti(kurX, kurY : integer; txt : String; sp : byte);
        begin
            GoToXY(kurX, kurY);
            Write('                ');
            GoToXY(kurX, kurY);
            TextColor(sp);
            Write(txt);
        end;

    procedure copyrights();
            var i : integer;
        begin
            ClrScr;
            TextColor(RED);
            rasyti(15, 6, '*******************************************************', BROWN);
            for i := 7 to 15 do
                rasyti(15, i, '*                                                     *', BROWN);
            rasyti(15,WhereY+1, '*******************************************************', BROWN);
            rasyti(18, 8, 'Data: 2008 m. vasario 6 d.', white);
            rasyti(18,10, 'Autorius: Evaldas Naujanis, VU, MIF ', RED);
            rasyti(18,12, 'E-Mail: ewalldinho@gmail.com', white);
            rasyti(18,14, 'Kalba: Pascal', RED);
        end;

    function VelykuData( Y : word ) : String;
          var a, b,c,d,e,f,g,h,i,k,L, m, month, day : word;
              diena : String;
        begin
        	a := Y mod 19;	         // 1961 mod 19 = 4	2008 mod 19 = 13
			b := Y div 100;	         // 1961 / 100 = 19	2008 / 100 = 20
			c := Y mod 100;          //	1961 mod 100 = 61	2008 mod 100 = 8
			d := b div 4;            //	19 / 4 = 4	20 / 4 = 5
			e := b mod 4;            //	19 mod 4 = 3	20 mod 4 = 0
			f := (b+8) div 25;       //	(19 + 8) / 25 = 1	(20 + 8) / 25 = 1
			g := (b-f+1) div 3;               //	(19 - 1 + 1) / 3 = 6	(20 - 1 + 1) / 3 = 6
			h := (19*a+b-d-g+15) mod 30;      //	(19 × 4 + 19 - 4 - 6 + 15) mod 30 = 10	(19 × 13 + 20 - 5 - 6 + 15) mod 30 = 1
			i := c div 4;                     //	61 / 4 = 15	8 / 4 = 2
			k := c mod 4;                     //	61 mod 4 = 1	8 mod 4 = 0
			L := (32+2*e+2*i-h-k) mod 7;      //	(32 + 2 × 3 + 2 × 15 - 10 - 1) mod 7 = 1	(32 + 2 × 0 + 2 × 2 - 1 - 0) mod 7 = 0
			m := (a+11*h+22*L) div 451;       //	(4 + 11 × 10 + 22 × 1) / 451 = 0	(13 + 11 × 1 + 22 × 0) / 451 = 0
			month := (h+L-7*m+114) div 31;    //	(10 + 1 - 7 × 0 + 114) / 31 = 4 (April)	(1 + 0 - 7 × 0 + 114) / 31 = 3 (March)
			day := ((h+L-7*m+114) mod 31)+1;  //	(10 + 1 - 7 × 0 + 114) mod 31 + 1 = 2	(1 + 0 - 7 × 0 + 114) mod 31 + 1 = 23
            Str(day, diena);
            VelykuData := men[month] + ' ' + diena + ' d.';
        end;
        
      var gana : boolean;
          sim : char;
          tLan, tTxt : byte;
          Y_str : string;
          err : integer;
          Y_tmp : word;
          
Begin
    TextBackground(black);
    ClrScr;
    gana := FALSE;
    tLan := green;
    tTxt := white;
    
    vaizdas(tLan, tTxt);
    sieMetai();
    rasyti( VX, VY, Velykudata(Y), white );

    Repeat
        while KeyPressed do
            sim := Readkey;
        sim := ReadKey;      { nuskaitomas mygtukas }
        case sim of
            #0 : begin
                sim := ReadKey;
                case sim of
          { Alt-S } #31: begin
                            if (Y > 326+10 )
                                then Y := Y-10;
                            GoToXY(mX,mY);
                            Write(Y);
                         end;
          { Alt-D } #32: begin
                            if (Y < 4099-10 )
                                then Y := Y+10;
                            GoToXY(mX,mY);
                            Write(Y);
                         end;
                    
             { UP } #72: begin
                            if Y > 326
                                then Y := Y-1;
                            GoToXY(mX,mY);
                            Write(Y);
                     //  ClrEoL;  // iðtrina likusius simbolius eilutëje
                     // negerai nes nutrina paskutiná simbolá kuris yra rëmelis
                            Write('   ');
                         end;
           { Left } #75: begin
                            if Y > 326
                                then Y := Y-1;
                            GoToXY(mX,mY);
                            Write(Y, '   ');
                         end;
          { Right } #77: begin
                            if Y < 4099
                                then Y := Y+1;
                            GoToXY(mX, mY);
                            Write(Y);
                         end;
           { Down } #80: begin
                            if Y < 4099
                                then Y := Y+1;
                            GoToXY(mX, mY);
                            Write(Y);
                         end;
            { Ins } #82: begin
                            GoToXY(mX, mY);
                            Window(mX, mY, mx+4, my);
                            Write('____');
                            GoToXY(1, 1);
                            ReadLn(Y_str);
                            Y_tmp := Y;
                            val(Y_str, Y, err);
                            if (err <> 0)
                                then Y := Y_tmp;
                            if (Y < minM)
                                then Y := minM;
                            if (Y > maxM)
                                then Y := maxM;

                            GoToXY(1, 1);
                            Write(Y);

							Window(1,1, 80, 25);
                         end;
                  //  #83: DelLine;                 { Del }
                    else {WriteLn('   sim = ', Ord(sim) )};
                end;
            end;
           // #3:    { Ctrl-C}
            #8: sieMetai();               { BackSpace }
            #9: tema();                   { TAB}

           // #13: WriteLn;                     { Enter }
            #27: gana := TRUE;                  { Esc }
            else {WriteLn('   sim = ', Ord(sim) )};
        end;
        rasyti(VX, VY, VelykuData(Y), white );
    Until gana;
    copyrights();
    Delay(3000);
End.
