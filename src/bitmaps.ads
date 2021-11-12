--
--  Copyright (C) 2021 Jeremy Grosser <jeremy@synack.me>
--
--  SPDX-License-Identifier: BSD-3-Clause
--
with Picosystem.Screen; use Picosystem.Screen;
with System.Storage_Elements; use System.Storage_Elements;
with System;

package Bitmaps is
   --  XIP access, cacheable, non-allocating - Check for hit, don’t update cache on miss
   No_Cache : constant Storage_Offset := 16#0100_0000#;

   subtype Frame is Pixels (1 .. Width * Height);

   type Gray is mod 4
      with Size => 2;

   Width  : constant := 8;
   Height : constant := 8;

   type Bitmap is array (1 .. Height, 1 .. Width) of Gray
      with Component_Size => 2;

   X : aliased Bitmap
      with Import, External_Name => "_binary_x_bin_start";
end Bitmaps;
