--
--  Copyright (C) 2021 Jeremy Grosser <jeremy@synack.me>
--
--  SPDX-License-Identifier: BSD-3-Clause
--
with Picosystem.LED;
with RP.Clock;
with Graphics;
with Sound;
with Game;

procedure Main is
   package PS renames Picosystem;
   use type PS.LED.Brightness;
begin
   RP.Clock.Initialize (PS.XOSC_Frequency);
   RP.Clock.Enable (RP.Clock.PERI);

   PS.LED.Initialize;
   PS.LED.Set_Color (16#008000#);
   PS.LED.Set_Backlight (0);

   Sound.Initialize;
   Graphics.Initialize;

   Game.Initialize;
   Graphics.HBlank := Game.HBlank'Access;
   Graphics.VBlank := Game.VBlank'Access;

   PS.LED.Set_Color (16#000000#);
   PS.LED.Set_Backlight ((PS.LED.Brightness'Last / 100) * 70);

   loop
      Graphics.Update;
   end loop;
end Main;
