library ieee;
use ieee.std_logic_1164.all; 

entity first_zero_decoder is
	port(
		input:		in std_logic_vector(31 downto 0);
		one_hot:	out std_logic_vector(31 downto 0);
		no_zero:	out std_logic
	);
end first_zero_decoder;

architecture first_zero_decoder_rtl of first_zero_decoder is

	signal nots: std_logic_vector(31 downto 0);
	signal one_low: std_logic_vector(31 downto 0);

begin

	-- Obtain sequential bitwise-NOTs for all prefixes of the input
	nots(0) <= not(input(0));
	nots(1) <= not(input(1)) or nots(0);
	nots(2) <= not(input(2)) or nots(1);
	nots(3) <= not(input(3)) or nots(2);
	nots(4) <= not(input(4)) or nots(3);
	nots(5) <= not(input(5)) or nots(4);
	nots(6) <= not(input(6)) or nots(5);
	nots(7) <= not(input(7)) or nots(6);
	nots(8) <= not(input(8)) or nots(7);
	nots(9) <= not(input(9)) or nots(8);
	nots(10) <= not(input(10)) or nots(9);
	nots(11) <= not(input(11)) or nots(10);
	nots(12) <= not(input(12)) or nots(11);
	nots(13) <= not(input(13)) or nots(12);
	nots(14) <= not(input(14)) or nots(13);
	nots(15) <= not(input(15)) or nots(14);
	nots(16) <= not(input(16)) or nots(15);
	nots(17) <= not(input(17)) or nots(16);
	nots(18) <= not(input(18)) or nots(17);
	nots(19) <= not(input(19)) or nots(18);
	nots(20) <= not(input(20)) or nots(19);
	nots(21) <= not(input(21)) or nots(20);
	nots(22) <= not(input(22)) or nots(21);
	nots(23) <= not(input(23)) or nots(22);
	nots(24) <= not(input(24)) or nots(23);
	nots(25) <= not(input(25)) or nots(24);
	nots(26) <= not(input(26)) or nots(25);
	nots(27) <= not(input(27)) or nots(26);
	nots(28) <= not(input(28)) or nots(27);
	nots(29) <= not(input(29)) or nots(28);
	nots(30) <= not(input(30)) or nots(29);
	nots(31) <= not(input(31)) or nots(30);

	-- Intermediate signal: one_low(i) is only zero if it is the first zero in the input
	one_low(0) <= input(0);
	one_low(1) <= input(1) or (nots(0));
	one_low(2) <= input(2) or (nots(1));
	one_low(3) <= input(3) or (nots(2));
	one_low(4) <= input(4) or (nots(3));
	one_low(5) <= input(5) or (nots(4));
	one_low(6) <= input(6) or (nots(5));
	one_low(7) <= input(7) or (nots(6));
	one_low(8) <= input(8) or (nots(7));
	one_low(9) <= input(9) or (nots(8));
	one_low(10) <= input(10) or (nots(9));
	one_low(11) <= input(11) or (nots(10));
	one_low(12) <= input(12) or (nots(11));
	one_low(13) <= input(13) or (nots(12));
	one_low(14) <= input(14) or (nots(13));
	one_low(15) <= input(15) or (nots(14));
	one_low(16) <= input(16) or (nots(15));
	one_low(17) <= input(17) or (nots(16));
	one_low(18) <= input(18) or (nots(17));
	one_low(19) <= input(19) or (nots(18));
	one_low(20) <= input(20) or (nots(19));
	one_low(21) <= input(21) or (nots(20));
	one_low(22) <= input(22) or (nots(21));
	one_low(23) <= input(23) or (nots(22));
	one_low(24) <= input(24) or (nots(23));
	one_low(25) <= input(25) or (nots(24));
	one_low(26) <= input(26) or (nots(25));
	one_low(27) <= input(27) or (nots(26));
	one_low(28) <= input(28) or (nots(27));
	one_low(29) <= input(29) or (nots(28));
	one_low(30) <= input(30) or (nots(29));
	one_low(31) <= input(31) or (nots(30));

	-- Output: gives a one-hot signal for the first zero found in the input vector
	one_hot <= not(one_low);

	-- Output: high when the output contains no zeros
	no_zero <= '1' when (input = "11111111111111111111111111111111") else '0';
	
end first_zero_decoder_rtl;










