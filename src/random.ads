with HAL; use HAL;

package Random is

   function Next
      return UInt16;

   function In_Range
      (First, Last : Natural)
      return Natural;

end Random;
