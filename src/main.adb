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
   use PS.Screen;
   use PS.LED;

   Console : Serial_Console.Port (UART => RP.Device.UART_0'Access);
   T       : Time;
   Elapsed : Time := 0;
   N       : Positive := 1;
   FPS     : Natural;

   type Buffer_Index is mod 2;
   Buffers : array (Buffer_Index) of aliased Picosystem.Screen.Scanline;
   Swap    : Buffer_Index := Buffer_Index'First;
begin
   RP.Clock.Initialize (PS.XOSC_Frequency);
   RP.Clock.Enable (RP.Clock.PERI);

   declare
      use RP.GPIO;
   begin
      PS.Pins.UART_RX.Configure (Output, Pull_Up, UART);
      PS.Pins.UART_TX.Configure (Output, Pull_Up, UART);
      RP.Device.UART_0.Configure;
      Console.New_Line;
      Console.Put_Line ("picosystem");
   end;

   PS.LED.Initialize;
   Set (Backlight, Brightness'First);
   PS.LED.Set (16#000000#);

   PS.Screen.Initialize;
   Set (Backlight, (Brightness'Last / 100) * 70);

   Game.VBlank;

   loop
      Wait_VSync;

      T := Clock;

      for Y in Graphics.Row'Range loop
         Swap := Swap + 1;
         Buffers (Swap) := Graphics.Scanline (Game.Plane, Y);
         Picosystem.Screen.Write (Buffers (Swap)'Unchecked_Access);
         Game.HBlank;
      end loop;

      Game.VBlank;
      Elapsed := Elapsed + (Clock - T);

      if N = 50 then
         Console.Put ("FPS");
         Elapsed := Elapsed / Time (N);
         FPS := Natural (fdiv (1.0, fdiv (Float (Elapsed), Float (Ticks_Per_Second))));
         Console.Put_Line (FPS'Image);
         Elapsed := 0;
         N := 1;
      end if;
      N := N + 1;
   end loop;
end Main;
