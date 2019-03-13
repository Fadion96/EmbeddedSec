--  Hello world program
use std.textio.all; -- Imports the standard textio package.

--  Defines a design entity, without any ports.
entity hello_world is
end hello_world;

architecture behaviour of hello_world is
begin
  process
    variable l : line;
    variable z : line;
  begin
    write (l, String'("Hello world!"));
    writeline (output, l);
    readline (input, z);
    writeline (output, z);
    wait;
  end process;
end behaviour;
