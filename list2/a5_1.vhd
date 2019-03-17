library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity a5_1 is
    Port ( clk : in  STD_LOGIC;
           ld  : in STD_LOGIC;
           data1: in  STD_LOGIC_VECTOR(18 downto 0) := (OTHERS => '0');
           data2: in  STD_LOGIC_VECTOR(21 downto 0) := (OTHERS => '0');
           data3: in  STD_LOGIC_VECTOR(22 downto 0) := (OTHERS => '0');
           R   : out STD_LOGIC
			);
end a5_1;

ARCHITECTURE behav OF a5_1 IS

  signal q1 : STD_LOGIC_VECTOR(18 downto 0) := (OTHERS => '0');
  signal q2 : STD_LOGIC_VECTOR(21 downto 0) := (OTHERS => '0');
  signal q3 : STD_LOGIC_VECTOR(22 downto 0) := (OTHERS => '0');
BEGIN

  PROCESS(clk, ld, data1, data2, data3)
  BEGIN
    if(ld = '1')
    then
      q1 <= data1;
      q2 <= data2;
      q3 <= data3;
    elsif(clk'event and clk = '1')
    then
		if (q1(8) = q2(10))
		then
			q1(18 downto 1) <= q1(17 downto 0);
	  		q1(0) <= q1(18) XOR q1(17) XOR q1(16) XOR q1(13);

      		q2(21 downto 1) <= q2(20 downto 0);
      		q2(0) <= q2(21) XOR q2(20);
			if (q1(8) = q3(10))
			then
				q3(22 downto 1) <= q3(21 downto 0);
				q3(0) <= q3(22) XOR q3(21) XOR q3(20) XOR q3(7);
			end if;
		elsif (q1(8) = q3(10))
		then
			q1(18 downto 1) <= q1(17 downto 0);
			q1(0) <= q1(18) XOR q1(17) XOR q1(16) XOR q1(13);

			q3(22 downto 1) <= q3(21 downto 0);
			q3(0) <= q3(22) XOR q3(21) XOR q3(20) XOR q3(7);
		else
			q2(21 downto 1) <= q2(20 downto 0);
      		q2(0) <= q2(21) XOR q2(20);
			
			q3(22 downto 1) <= q3(21 downto 0);
			q3(0) <= q3(22) XOR q3(21) XOR q3(20) XOR q3(7);
		end if;

    end if;
  END PROCESS;
  R <= q1(18) XOR q2(21) XOR q3(22);
END behav;
