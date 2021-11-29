with Picosystem.Pins;
with RP.Clock;
with RP.Timer;
with RP.GPIO;

package body Sound is
   use RP.Timer;
   use RP.PWM;

   P       : constant PWM_Point := To_PWM (Picosystem.Pins.AUDIO);
   Stop_At : Time := Time'First;
   Playing : Boolean := False;

   procedure Initialize is
      use RP.GPIO;
   begin
      if not RP.PWM.Initialized then
         RP.PWM.Initialize;
      end if;

      Set_Mode (P.Slice, Free_Running);
      Set_Divider (P.Slice, Divider'Last);
      Set_Duty_Cycle (P.Slice, P.Channel, 0);
      Enable (P.Slice);

      Picosystem.Pins.AUDIO.Configure (Output, Floating, RP.GPIO.PWM);
   end Initialize;

   procedure Update is
   begin
      if Playing and then Clock >= Stop_At then
         Stop;
      end if;
   end Update;

   function Is_Playing
      return Boolean
   is (Playing);

   procedure Play
      (Note   : Notes;
       Octave : Octaves;
       Length : Milliseconds)
   is
      use type RP.PWM.Period;
      Div      : constant RP.PWM.Divider := Lookup_Div (Octave);
      Interval : constant RP.PWM.Period := Lookup_Interval (Octave, Note);
   begin
      Set_Divider (P.Slice, Div);
      Set_Interval (P.Slice, Interval);
      Set_Duty_Cycle (P.Slice, P.Channel, Interval / 1000); -- TODO volume control?
      Stop_At := Clock + RP.Timer.Milliseconds (Length);
      Playing := True;
   end Play;

   procedure Stop is
   begin
      RP.PWM.Set_Duty_Cycle (P.Slice, P.Channel, 0);
      Playing := False;
   end Stop;

end Sound;
