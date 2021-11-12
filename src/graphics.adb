--
--  Copyright (C) 2021 Jeremy Grosser <jeremy@synack.me>
--
--  SPDX-License-Identifier: BSD-3-Clause
--
package body Graphics is
   function Scanline
      (This : Plane;
       Y    : Row)
      return Picosystem.Screen.Scanline
   is
      Line : Picosystem.Screen.Scanline;
   begin
      for X in Column'Range loop
         Line (X) := This.Palette (This.Bitmap (Y, X));
      end loop;
      return Line;
   end Scanline;
end Graphics;
