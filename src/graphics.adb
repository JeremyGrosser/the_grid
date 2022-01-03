--
--  Copyright (C) 2021 Jeremy Grosser <jeremy@synack.me>
--
--  SPDX-License-Identifier: BSD-3-Clause
--
package body Graphics is
   type Buffer_Index is mod 2;
   Buffers      : array (Buffer_Index) of aliased Picosystem.Screen.Scanline;
   Swap         : Buffer_Index := Buffer_Index'First;

   protected body Shared_Plane is
      procedure Set_Palette
         (P : Color_Palette)
      is
      begin
         Palette := P;
      end Set_Palette;

      procedure Set_Pixel
         (Y : Row;
          X : Column;
          V : Palette_Index)
      is
      begin
         Bitmap (Y, X) := V;
      end Set_Pixel;

      function Get_Pixel
         (Y : Row;
          X : Column)
          return Color
      is (Palette (Bitmap (Y, X)));

      procedure Clear is
         Default_Color : constant Palette_Index := Palette_Index'First;
      begin
         Bitmap := (others => (others => Default_Color));
      end Clear;
   end Shared_Plane;

   procedure Initialize is
   begin
      Picosystem.Screen.Initialize;
      Current.Set_Palette (Grayscale);
      Current.Clear;
   end Initialize;

   function Scanline
      (This : Shared_Plane;
       Y    : Row)
      return Picosystem.Screen.Scanline
   is
      Line : Picosystem.Screen.Scanline;
   begin
      for X in Column'Range loop
         Line (X) := This.Get_Pixel (Y, X);
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

   task body Run is
   begin
      Initialize;
      loop
         Update;
      end loop;
   end Run;

end Graphics;
