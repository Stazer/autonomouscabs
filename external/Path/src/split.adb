with Ada.Text_IO; use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;

procedure split is
   type arrayLength is range 0 .. I;
   type colorArray is array(arrayLength) of Integer;

   blue : colorArray;
   green : colorArray;
   red : colorArray;
   gray : colorArray;
   J : Integer := 0;
   M : Integer := 1;
   N : Integer := 2;
   B : Integer := 0;
   G : Integer := 0;
   R : Integer := 0;
   gr : Integer := 0;
   procedure getGray is

   begin

      loop
         exit when J < I;
         blue(B) := wholeImage(J);
         G := G + 1;
         J := J + 4;
      end loop;

      loop
         exit when M < I;
         green := wholeImage(M);
         G := G + 1;
         M := M + 4;
      end loop;

      loop
         exit when N < I;
         red(R) := wholeImage(J);
         R := R + 1;
         N := N + 4;
      end loop;

      while gr < G loop
         gray(gr) := Integer(blue (gr))*114/1000 + Integer(green (gr)) *587/1000 + Integer(red (gr))*299/1000;
         Put(Integer'Image(gray(gr)))
      end loop;
