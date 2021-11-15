--
--  Copyright (C) 2021 Jeremy Grosser <jeremy@synack.me>
--
--  SPDX-License-Identifier: BSD-3-Clause
--
with Random;

package body Game is

   function To_Screen_Coordinate
      (Y : Grid_Row;
       X : Grid_Column)
      return Screen_Coordinate
   is (Y => Graphics.Row'First + (Y - Grid_Row'First) * Bitmaps.Height,
       X => Graphics.Column'First + (X - Grid_Column'First) * Bitmaps.Width);

   type Tile is record
      Bitmap : Bitmaps.Any_Bitmap;
      Dirty  : Boolean;
   end record;

   Grid : array (Grid_Row, Grid_Column) of Tile :=
      (others => (others =>
         (Dirty  => True,
          Bitmap => Bitmaps.Clear'Access)));

   procedure Blit
      (Position : Screen_Coordinate;
       B        : Bitmaps.Any_Bitmap)
   is
   begin
      for Y in B'Range (1) loop
         for X in B'Range (2) loop
            Graphics.Current.Bitmap
               (Position.Y + Y - 1,
                Position.X + X - 1)
                := B.all (Y, X);
         end loop;
      end loop;
   end Blit;

   procedure Initialize is null;

   procedure Update is
      Y : Grid_Row;
      X : Grid_Column;
   begin
      Y := Random.In_Range (Grid_Row'First, Grid_Row'Last);
      X := Random.In_Range (Grid_Column'First, Grid_Column'Last);
      Grid (Y, X).Bitmap := Bitmaps.Clear'Access;
      Grid (Y, X).Dirty := True;

      Y := Random.In_Range (Grid_Row'First, Grid_Row'Last);
      X := Random.In_Range (Grid_Column'First, Grid_Column'Last);
      Grid (Y, X).Bitmap := Bitmaps.X'Access;
      Grid (Y, X).Dirty := True;

      for GY in Grid'Range (1) loop
         for GX in Grid'Range (2) loop
            if Grid (GY, GX).Dirty then
               Blit (To_Screen_Coordinate (GY, GX), Grid (GY, GX).Bitmap);
               Grid (GY, GX).Dirty := False;
            end if;
         end loop;
      end loop;
   end Update;

   procedure VBlank
      (N : Graphics.Frame_Number)
   is null;

   procedure HBlank
      (Y : Graphics.Row)
   is null;
end Game;
