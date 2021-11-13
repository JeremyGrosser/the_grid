--
--  Copyright (C) 2021 Jeremy Grosser <jeremy@synack.me>
--
--  SPDX-License-Identifier: BSD-3-Clause
--
package body Graphics is
   type Buffer_Index is mod 2;
   Buffers      : array (Buffer_Index) of aliased Picosystem.Screen.Scanline;
   Swap         : Buffer_Index := Buffer_Index'First;

   procedure Initialize renames Picosystem.Screen.Initialize;

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

   procedure Update is
   begin
      Picosystem.Screen.Wait_VSync;

      for Y in Row'Range loop
         Swap := Swap + 1;
         Buffers (Swap) := Scanline (Current, Y);
         Picosystem.Screen.Write (Buffers (Swap)'Access);
         if HBlank /= null then
            HBlank.all (Y);
         end if;
      end loop;
      if VBlank /= null then
         VBlank.all (Frame);
      end if;

      Frame := Frame + 1;
   end Update;

end Graphics;
