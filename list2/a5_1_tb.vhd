library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use STD.textio.all;
use ieee.std_logic_textio.all;

entity a5_1_tb is
  end a5_1_tb;

architecture complex of a5_1_tb is
  constant clock_period : time := 10 ns;

  signal clock : std_logic :=  '0';
  signal q1 : std_logic_vector(18 downto 0) := (OTHERS => '0');
  signal q2 : std_logic_vector(21 downto 0) := (OTHERS => '0');
  signal q3 : std_logic_vector(22 downto 0) := (OTHERS => '0');
  signal load  : std_logic := '0';
  signal o : std_logic;

  component a5_1
    port(
          clk  : in STD_LOGIC;
          ld   : in STD_LOGIC;
          data1: in  STD_LOGIC_VECTOR(18 downto 0);
          data2: in  STD_LOGIC_VECTOR(21 downto 0);
          data3: in  STD_LOGIC_VECTOR(22 downto 0);
          R    : out STD_LOGIC );
  end component;

  for UUT1 : a5_1 use entity work.a5_1(behav);
	file file_RESULTS : text;
begin

  UUT1 : a5_1 port map ( clk => clock, ld => load, data1 => q1, data2 => q2, data3 => q3, R => o );


  -- this will run infinitely, stopping every few ns
  clocker : process
  begin
    clock <= not clock;
    wait for clock_period/2;
  end process;

  -- this will run once and then wait forever
  init : process
  	variable outputline : line;
  begin
	  file_open(file_RESULTS, "output_results.txt", write_mode);
    -- time to tell LFSRs to load up some data
    load <= '1';
    -- and give it to them (to one of them, at least)
    q1 <= "1010101010101010101";
    q2 <= "1010101010101010101010";
    q3 <= "10101010101010101010101";
    -- even though LFSRs are async, let's wait for a bit...
    wait until clock'event and clock = '0';
    -- ... and let them run freely
    load <= '0';
    for i in 0 to 1199 loop
    	wait until clock'event and clock = '0';
		write(outputline, o);

    end loop;
	writeline(file_RESULTS, outputline);
		file_close(file_RESULTS);
    wait;
  end process;

  -- okay, what's going on here? well, the 'clocker' process
  -- keeps running, changing clk -> NOT clk -> clk -> NOT clk ...
  -- and clk is fed to LFSRs, so they are busy working
  -- the simulation will continue until you kill it, or specify
  -- the stop time using '--stop-time=XXX' switch to ghdl

end complex;
