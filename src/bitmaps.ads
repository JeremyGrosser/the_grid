--
--  Copyright (C) 2021 Jeremy Grosser <jeremy@synack.me>
--
--  SPDX-License-Identifier: BSD-3-Clause
--
with Graphics;

package Bitmaps is

   Width  : constant := 8;
   Height : constant := 8;

   --  All bitmaps are stored as row-major, 2-bit per pixel color value. The
   --  actual display color is determined by a lookup from this value into a
   --  Graphics.Color_Palette.
   type Bitmap is array (1 .. Height, 1 .. Width) of Graphics.Color_Value
      with Component_Size => 2;

   X : aliased Bitmap
      with Import, External_Name => "_binary_x_bin_start";
end Bitmaps;
