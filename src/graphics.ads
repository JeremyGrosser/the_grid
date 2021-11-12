--
--  Copyright (C) 2021 Jeremy Grosser <jeremy@synack.me>
--
--  SPDX-License-Identifier: BSD-3-Clause
--
with Picosystem.Screen;

package Graphics is

   subtype Row    is Integer range 1 .. Picosystem.Screen.Height;
   subtype Column is Integer range 1 .. Picosystem.Screen.Width;

   subtype Color is Picosystem.Screen.Color;

   type Color_Id is range 0 .. 3;
   type Color_Palette is array (Color_Id) of Color;
   type Color_Map is array (Row, Column) of Color_Id;

   type Plane is record
      Palette : Color_Palette;
      Bitmap  : Color_Map;
   end record;

   function Scanline
      (This : Plane;
       Y    : Row)
       return Picosystem.Screen.Scanline;

end Graphics;
