--
--  Copyright (C) 2021 Jeremy Grosser <jeremy@synack.me>
--
--  SPDX-License-Identifier: BSD-3-Clause
--
with Graphics;
with Bitmaps;

package Game is

   procedure Initialize;
   procedure Update;

   procedure HBlank (Y : Graphics.Row);
   procedure VBlank (N : Graphics.Frame_Number);

private

   type Any_Bitmap is not null access all Bitmaps.Bitmap;

   type Screen_Coordinate is record
      Y : Graphics.Row;
      X : Graphics.Column;
   end record;

   procedure Blit
      (Position : Screen_Coordinate;
       B        : Any_Bitmap);

   subtype Grid_Row is Integer range 1 .. (Graphics.Row'Last / Bitmaps.Height);
   subtype Grid_Column is Integer range 1 .. (Graphics.Column'Last / Bitmaps.Width);

   function To_Screen_Coordinate
      (Y : Grid_Row;
       X : Grid_Column)
       return Screen_Coordinate;

end Game;
