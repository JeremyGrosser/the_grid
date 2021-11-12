--
--  Copyright (C) 2021 Jeremy Grosser <jeremy@synack.me>
--
--  SPDX-License-Identifier: BSD-3-Clause
--
package Bitmaps is

   Width  : constant := 8;
   Height : constant := 8;

   type Gray is mod 4
      with Size => 2;

   type Bitmap is array (1 .. Height, 1 .. Width) of Gray
      with Component_Size => 2;

   X : aliased Bitmap
      with Import, External_Name => "_binary_x_bin_start";
end Bitmaps;
