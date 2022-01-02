--
--  Copyright (C) 2021 Jeremy Grosser <jeremy@synack.me>
--
--  SPDX-License-Identifier: BSD-3-Clause
--
with Random;
with Sound;

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

   type Tile_Grid is array (Grid_Row, Grid_Column) of Tile
      with Pack;

   Grid : Tile_Grid;

   procedure Blit
      (Position : Screen_Coordinate;
       B        : not null Bitmaps.Any_Bitmap)
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

   procedure Initialize is
      Default_Tile : constant Tile :=
         (Dirty => True,
          Bitmap => Bitmaps.Blank'Access);
   begin
      Grid := (others => (others => Default_Tile));
   end Initialize;

   procedure VBlank
      (N : Graphics.Frame_Number)
   is
      use type Graphics.Frame_Number;
      GY : Grid_Row;
      GX : Grid_Column;
   begin
      if N <= 30 and N mod 10 = 0 then
         Sound.Play
            (Note   => Sound.A,
             Octave => 4,
             Length => 50);
      end if;

      for I in 1 .. 4 loop
         GY := Random.In_Range (Grid_Row'First, Grid_Row'Last);
         GX := Random.In_Range (Grid_Column'First, Grid_Column'Last);
         Grid (GY, GX).Bitmap := Bitmaps.Blank'Access;
         Grid (GY, GX).Dirty := True;

         GY := Random.In_Range (Grid_Row'First, Grid_Row'Last);
         GX := Random.In_Range (Grid_Column'First, Grid_Column'Last);
         Grid (GY, GX).Bitmap := Bitmaps.X'Access;
         Grid (GY, GX).Dirty := True;
      end loop;

      for Y in Grid'Range (1) loop
         for X in Grid'Range (2) loop
            if Grid (Y, X).Dirty then
               Blit (To_Screen_Coordinate (Y, X), Grid (Y, X).Bitmap);
               Grid (Y, X).Dirty := False;
            end if;
         end loop;
      end loop;
   end VBlank;

   procedure HBlank
      (Y : Graphics.Row)
   is
   begin
      null;
   end HBlank;

end Game;
