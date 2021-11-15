--  Galois Linear Feedback Shift Register
--  https://en.wikipedia.org/wiki/Linear-feedback_shift_register#Galois_LFSRs
package body Random is

   State : UInt16 := 16#DEAD#;

   function Next
      return UInt16
   is
      Taps   : constant UInt16 := 16#B400#;
      LFSR   : UInt16 := State;
      LSB    : UInt16;
   begin
      loop
         LSB := LFSR and 1;
         LFSR := Shift_Right (LFSR, 1);
         LFSR := LFSR xor ((-LSB) and Taps);
         exit when LFSR /= State;
      end loop;
      State := LFSR;
      return LFSR;
   end Next;

   function In_Range
      (First, Last : Natural)
      return Natural
   is (First + (Natural (Next) mod Last));
end Random;
