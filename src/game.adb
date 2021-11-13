--
--  Copyright (C) 2021 Jeremy Grosser <jeremy@synack.me>
--
--  SPDX-License-Identifier: BSD-3-Clause
--
with Bitmaps;

package body Game is

   type Coordinate is record
      Y : Integer;
      X : Integer;
   end record;

   type Tile is record
      Position : Coordinate;
      Bitmap   : access Bitmaps.Bitmap;
   end record;

   Box : Tile :=
      (Position => (34, 93),
       Bitmap   => Bitmaps.X'Access);

   Velocity : Coordinate := (3, 5);

   procedure Initialize is
   begin
      Graphics.Initialize;
      Graphics.VBlank := VBlank'Access;
      Graphics.HBlank := HBlank'Access;
      Graphics.Update;
   end Initialize;

   procedure Update renames Graphics.Update;

   procedure VBlank
      (N : Frame_Number)
   is
   begin
      --  Clear dirty region
      for Y in Box.Bitmap'Range (1) loop
         for X in Box.Bitmap'Range (2) loop
            Current.Bitmap (Box.Position.Y + Y, Box.Position.X + X) := Graphics.Color_Value'First;
         end loop;
      end loop;

      --  Invert velocity if we hit an edge
      if (Box.Position.X + Bitmaps.Width + Velocity.X > Column'Last) or
         (Box.Position.X + Velocity.X < Column'First)
      then
         Velocity.X := (-1) * Velocity.X;
      end if;

      if (Box.Position.Y + Bitmaps.Height + Velocity.Y > Row'Last) or
         (Box.Position.Y + Velocity.Y < Row'First)
      then
         Velocity.Y := (-1) * Velocity.Y;
      end if;

      --  Update box position
      Box.Position.X := Box.Position.X + Velocity.X;
      Box.Position.Y := Box.Position.Y + Velocity.Y;

      --  Copy the bitmap to the plane at the box position
      for Y in Box.Bitmap'Range (1) loop
         for X in Box.Bitmap'Range (2) loop
            Current.Bitmap (Box.Position.Y + Y, Box.Position.X + X) := Box.Bitmap (Y, X);
         end loop;
      end loop;
   end VBlank;

   procedure HBlank
      (Y : Row)
   is null;
end Game;
