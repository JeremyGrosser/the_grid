with Ada.Unchecked_Conversion;
with USB.Device.MIDI;
with USB.Device;
with RP.Device;
with Sound;
with HAL;

package body MIDI is
   USB_Stack : USB.Device.USB_Device_Stack (Max_Classes => 1);
   USB_MIDI  : aliased USB.Device.MIDI.Default_MIDI_Class
      (TX_Buffer_Size => 64,
       RX_Buffer_Size => 64);

   type Command_Kind is (Note_Off,
                         Note_On,
                         Aftertouch,
                         Continous_Controller,
                         Patch_Change,
                         Channel_Pressure,
                         Pitch_Bend)
     with Size => 4;

   for Command_Kind use (Note_Off             => 16#8#,
                         Note_On              => 16#9#,
                         Aftertouch           => 16#A#,
                         Continous_Controller => 16#B#,
                         Patch_Change         => 16#C#,
                         Channel_Pressure     => 16#D#,
                         Pitch_Bend           => 16#E#);

   subtype MIDI_Data is HAL.UInt8 range 2#0000_0000# .. 2#0111_1111#;
   subtype MIDI_Key is MIDI_Data;
   type MIDI_Channel is mod 2**4 with Size => 4;

   type Message (Kind : Command_Kind := Note_On) is record
      Chan : MIDI_Channel;
      case Kind is
         when Note_On | Note_Off | Aftertouch =>
            Key      : MIDI_Key;
            Velocity : MIDI_Data;
         when Continous_Controller =>
            Controller       : MIDI_Data;
            Controller_Value : MIDI_Data;
         when Patch_Change =>
            Instrument : MIDI_Data;
         when Channel_Pressure =>
            Pressure : MIDI_Data;
         when Pitch_Bend =>
            Bend : MIDI_Data;
      end case;
   end record
     with Size => 32;

   for Message use record
      Kind             at 1 range 4 .. 7;
      Chan             at 1 range 0 .. 3;
      Key              at 2 range 0 .. 7;
      Velocity         at 3 range 0 .. 7;
      Controller       at 2 range 0 .. 7;
      Controller_Value at 3 range 0 .. 7;
      Instrument       at 2 range 0 .. 7;
      Pressure         at 2 range 0 .. 7;
      Bend             at 2 range 0 .. 7;
   end record;

   Current_Key : MIDI_Key := MIDI_Key'First;

   function To_Message is new Ada.Unchecked_Conversion
      (Source => USB.Device.MIDI.MIDI_Event,
       Target => Message);

   procedure Initialize is
      use type USB.Device.Init_Result;
      Status : USB.Device.Init_Result;
   begin
      if not USB_Stack.Register_Class (USB_MIDI'Access) then
         return;
      end if;

      Status := USB_Stack.Initialize
         (Controller       => RP.Device.UDC'Access,
          Manufacturer     => USB.To_USB_String ("Pimoroni"),
          Product          => USB.To_USB_String ("Picosystem"),
          Serial_Number    => USB.To_USB_String ("42"),
          Max_Packet_Size  => 64);

      if Status /= USB.Device.Ok then
         return;
      end if;

      USB_Stack.Start;
   end Initialize;

   procedure Update is
      use HAL;
      Event : USB.Device.MIDI.MIDI_Event;
      M     : Message;
   begin
      USB_Stack.Poll;

      if USB_MIDI.Receive (Event) then
         M := To_Message (Event);
         case M.Kind is
            when Note_On =>
               Current_Key := M.Key;
               declare
                  Note   : constant Sound.Notes := Sound.Notes'Val (Natural (M.Key) mod 12);
                  Octave : constant Sound.Octaves := Sound.Octaves
                     ((Natural (M.Key) / 12) mod Natural (Sound.Octaves'Last));
               begin
                  Sound.Play (Note, Octave, 0);
               end;
            when Note_Off =>
               if M.Key = Current_Key then
                  Sound.Stop;
               end if;
            when others =>
               null;
         end case;
      end if;

      Sound.Update;
   end Update;
end MIDI;
