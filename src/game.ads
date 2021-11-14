--
--  Copyright (C) 2021 Jeremy Grosser <jeremy@synack.me>
--
--  SPDX-License-Identifier: BSD-3-Clause
--
with Graphics;

package Game is

   procedure Initialize;
   procedure Update;

   procedure HBlank (Y : Graphics.Row);
   procedure VBlank (N : Graphics.Frame_Number);

end Game;
