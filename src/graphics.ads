--
--  Copyright (C) 2021 Jeremy Grosser <jeremy@synack.me>
--
--  SPDX-License-Identifier: BSD-3-Clause
--
with Picosystem.Screen;

package Graphics is

   subtype Row    is Integer range 1 .. Picosystem.Screen.Height;
   subtype Column is Integer range 1 .. Picosystem.Screen.Width;
   type Frame_Number is mod 2 ** 32 - 1;

   subtype Color is Picosystem.Screen.Color;

   type Color_Id is range 0 .. 3;
   type Color_Palette is array (Color_Id) of Color;
   type Color_Map is array (Row, Column) of Color_Id;

   type Plane is record
      Palette : Color_Palette;
      Bitmap  : Color_Map;
   end record;

   Grayscale : constant Color_Palette :=
      (Color'(0, 0, 0),
       Color'(7, 15, 7),
       Color'(15, 31, 15),
       Color'(31, 63, 31));

   Current : Plane :=
      (Palette => Grayscale,
       Bitmap  => (others => (others => Color_Id'First)));

   Frame : Frame_Number := 0;

   type HBlank_Callback is access procedure
      (Y : Row);
   type VBlank_Callback is access procedure
      (N : Frame_Number);

   HBlank : HBlank_Callback := null;
   VBlank : VBlank_Callback := null;

   procedure Initialize;
   procedure Update;

private

   function Scanline
      (This : Plane;
       Y    : Row)
       return Picosystem.Screen.Scanline;

end Graphics;
