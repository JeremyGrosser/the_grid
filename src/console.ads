package Console is
   procedure Initialize;

   procedure Put
      (C : Character)
      with Export,
           Convention    => C,
           External_Name => "putchar";
end Console;
