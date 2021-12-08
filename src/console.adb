with Picosystem.Pins;
with RP.Device;
with RP.UART;
with RP.GPIO;
with HAL.UART;
with HAL;

package body Console is
   Initialized : Boolean := False;
   Port        : RP.UART.UART_Port renames RP.Device.UART_0;

   procedure Initialize is
      use RP.GPIO;
   begin
      Port.Configure;
      Picosystem.Pins.UART_RX.Configure (Output, Floating, RP.GPIO.UART);
      Picosystem.Pins.UART_TX.Configure (Output, Floating, RP.GPIO.UART);
      Initialized := True;
   end Initialize;

   procedure Put
      (C : Character)
   is
      use HAL.UART;
      Data   : UART_Data_8b (1 .. 1)
         with Address => C'Address;
      Status : UART_Status;
   begin
      if Initialized then
         Port.Transmit (Data, Status, Timeout => 0);
      end if;
   end Put;
end Console;
