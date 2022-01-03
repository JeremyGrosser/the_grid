--
--  Copyright (C) 2021 Jeremy Grosser <jeremy@synack.me>
--
--  SPDX-License-Identifier: BSD-3-Clause
--
with Picosystem.Screen;

package Graphics
   with Elaborate_Body
is

   subtype Row    is Integer range 1 .. Picosystem.Screen.Height;
   subtype Column is Integer range 1 .. Picosystem.Screen.Width;
   type Frame_Number is mod 2 ** 32 - 1;

   subtype Color is Picosystem.Screen.Color;

   type Palette_Index is mod 4
      with Size => 2;
   type Color_Palette is array (Palette_Index) of Color;
   type Color_Map is array (Row, Column) of Palette_Index
      with Pack;

   type Plane is record
      Palette : Color_Palette;
      Bitmap  : Color_Map;
   end record;

   Grayscale : constant Color_Palette :=
      (Color'(0, 0, 0),
       Color'(7, 15, 7),
       Color'(15, 31, 15),
       Color'(31, 63, 31));

   protected type Shared_Plane is

      procedure Set_Palette
         (P : Color_Palette);

      procedure Set_Pixel
         (Y : Row;
          X : Column;
          V : Palette_Index);

      function Get_Pixel
         (Y : Row;
          X : Column)
          return Color;

      procedure Clear;

   private
      Palette : Color_Palette;
      Bitmap  : Color_Map;
   end Shared_Plane;

   Current : Shared_Plane;

   type HBlank_Callback is access procedure
      (Y : Row);
   type VBlank_Callback is access procedure
      (N : Frame_Number);

   HBlank : HBlank_Callback := null;
   VBlank : VBlank_Callback := null;

private

   Frame : Frame_Number := 0;

   function Scanline
      (This : Shared_Plane;
       Y    : Row)
       return Picosystem.Screen.Scanline;

   procedure Initialize;
   procedure Update;
   task Run;

end Graphics;
