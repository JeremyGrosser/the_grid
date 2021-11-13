--
--  Copyright (C) 2021 Jeremy Grosser <jeremy@synack.me>
--
--  SPDX-License-Identifier: BSD-3-Clause
--
with Graphics; use Graphics;

package Game is

   procedure Initialize;
   procedure Update;

private

   procedure HBlank (Y : Row);
   procedure VBlank (N : Frame_Number);

end Game;
