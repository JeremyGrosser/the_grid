--
--  Copyright (C) 2021 Jeremy Grosser <jeremy@synack.me>
--
--  SPDX-License-Identifier: BSD-3-Clause
--
with Picosystem.Screen;
with Picosystem.Pins;
with Picosystem.LED;
with Picosystem;

with Serial_Console;
with RP.ROM.Floating_Point; use RP.ROM.Floating_Point;
with RP.Device;
with RP.Clock;
with RP.GPIO;
with HAL; use HAL;
with Graphics;
with Game;

with RP.Timer; use RP.Timer;

procedure Main is
   package PS renames Picosystem;
begin
   RP.Clock.Initialize (PS.XOSC_Frequency);
   RP.Clock.Enable (RP.Clock.PERI);

   Game.Initialize;

   PS.LED.Initialize;
   PS.LED.Set_Color (16#000000#);
   PS.LED.Set_Backlight ((PS.LED.Brightness'Last / 100) * 70);

   loop
      Game.Update;
   end loop;
end Main;
