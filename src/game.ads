--
--  Copyright (C) 2021 Jeremy Grosser <jeremy@synack.me>
--
--  SPDX-License-Identifier: BSD-3-Clause
--
with Graphics;

package Game is
   Grayscale : constant Graphics.Color_Palette :=
      (Graphics.Color'(0, 0, 0),
       Graphics.Color'(7, 15, 7),
       Graphics.Color'(15, 31, 15),
       Graphics.Color'(31, 63, 31));

   Plane : Graphics.Plane :=
      (Palette => Grayscale,
       Bitmap  => (others => (others => Graphics.Color_Id'First)));

   procedure HBlank;
   procedure VBlank;
end Game;
