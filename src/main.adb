--
--  Copyright (C) 2021 Jeremy Grosser <jeremy@synack.me>
--
--  SPDX-License-Identifier: BSD-3-Clause
--
with Picosystem.LED;
with RP.Clock;
with Console;
with Graphics;
with Sound;
with Game;
with MIDI;
with Ada.Text_IO;

procedure Main is
   package PS renames Picosystem;
   use type PS.LED.Brightness;
begin
   RP.Clock.Initialize (PS.XOSC_Frequency);
   RP.Clock.Enable (RP.Clock.PERI);

   Console.Initialize;
   Ada.Text_IO.New_Line;
   Ada.Text_IO.Put_Line ("picosystem");

   PS.LED.Initialize;
   PS.LED.Set_Color (16#008000#);
   PS.LED.Set_Backlight (0);

   Sound.Initialize;
   Graphics.Initialize;
   MIDI.Initialize;

   Game.Initialize;
   Graphics.HBlank := Game.HBlank'Access;
   Graphics.VBlank := Game.VBlank'Access;

   --  PS.LED.Set_Color (16#000000#);
   --  PS.LED.Set_Backlight ((PS.LED.Brightness'Last / 100) * 70);

   loop
      --  Graphics.Update;
      MIDI.Update;
   end loop;
end Main;
