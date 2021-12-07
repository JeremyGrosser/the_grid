with RP.PWM;

package Sound is

   type Octaves is range 0 .. 11;
   type Notes is (C, Cs, D, Ds, E, F, Fs, G, Gs, A, As, B);
   subtype Milliseconds is Natural;

   procedure Initialize;
   procedure Update;

   procedure Play
      (Note   : Notes;
       Octave : Octaves;
       Length : Milliseconds);
   --  Length = 0 will play until Stop or Play are called.

   function Is_Playing
      return Boolean;

   --  Stop playing immediately, aborts any in progress playback
   procedure Stop;

private

   --  See finddiv.py
   Lookup_Div : constant array (Octaves) of RP.PWM.Divider :=
      (77.5625, 36.0000, 18.0000, 9.0000, 4.5000, 2.2500, 1.1250, 1.0000, 1.2500, 1.2500, 1.2500, 1.1875);

   Lookup_Interval : constant array (Octaves, Notes) of RP.PWM.Period := (
      0      => (58603, 55314, 52210, 49279, 46513, 43903, 41439, 39113, 36918, 34846, 32890, 31044),
      1 .. 6 => (63131, 59588, 56243, 53086, 50107, 47295, 44640, 42135, 39770, 37538, 35431, 33442),
      7      => (35511, 33518, 31637, 29861, 28185, 26603, 25110, 23700, 22370, 21115, 19930, 18811),
      8      => (14204, 13407, 12654, 11944, 11274, 10641, 10044, 9480, 8948, 8446, 7972, 7524),
      9      => (7102, 6703, 6327, 5972, 5637, 5320, 5022, 4740, 4474, 4223, 3986, 3762),
      10     => (3551, 3351, 3163, 2986, 2818, 2660, 2511, 2370, 2237, 2111, 1993, 1881),
      11     => (1869, 1764, 1665, 1571, 1483, 1400, 1321, 1247, 1177, 1111, 1048, 990)
   );

end Sound;
