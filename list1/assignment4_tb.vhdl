--  A testbench has no ports.
entity assign4_tb is
end assign4_tb;

architecture behav of assign4_tb is
   --  Declaration of the component that will be instantiated.
   component assign4
     port (a, b, c : in bit; x, y : out bit);
   end component;

   --  Specifies which entity is bound with the component.
   for assign4_0: assign4 use entity work.assign4;
   signal a, b, c, x, y : bit;
begin
   --  Component instantiation.
   assign4_0: assign4 port map (a => a, b => b, c => c,
                            x => x, y => y);

   --  This process does the real job.
   process
      type pattern_type is record
         --  The inputs of the adder.
         a, b, c : bit;
         --  The expected outputs of the adder.
         x, y : bit;
      end record;
      --  The patterns to apply.
      type pattern_array is array (natural range <>) of pattern_type;
      constant patterns : pattern_array :=
        (('0', '0', '0', '0', '0'),
         ('0', '0', '1', '0', '0'),
         ('0', '1', '0', '0', '1'),
         ('0', '1', '1', '0', '0'),
         ('1', '0', '0', '1', '0'),
         ('1', '0', '1', '0', '1'),
         ('1', '1', '0', '0', '0'),
         ('1', '1', '1', '0', '1'));
   begin
      --  Check each pattern.
      for i in patterns'range loop
         --  Set the inputs.
         a <= patterns(i).a;
         b <= patterns(i).b;
         c <= patterns(i).c;
         --  Wait for the results.
         wait for 1 ns;
         --  Check the outputs.
         assert x = patterns(i).x
            report "bad y value" severity error;
         assert y = patterns(i).y
            report "bad x value" severity error;
      end loop;
      assert false report "end of test" severity note;
      --  Wait forever; this will finish the simulation.
      wait;
   end process;
end behav;
