library ieee;
use ieee.std_logic_1164.all; 
use ieee.numeric_std.all;

entity first_zero_decoder is
	port(
		input:		in std_logic_vector(31 downto 0);
		addr_out : 	out std_logic_vector(4 downto 0);
		no_zero:	out std_logic
	);
end first_zero_decoder;

architecture first_zero_decoder_rtl of first_zero_decoder is

	signal one_hot_s : std_logic_vector(31 downto 0);
	
	
--	-- translate one_hot encoding into an address
--	function one_hot_to_binary (
--		one_hot_encoding : std_logic_vector(31 downto 0))
--		return std_logic_vector is
--		
--		variable bin_vec : std_logic_vector(4 downto 0);
--	begin
--		bin_vec := (others => '0');
--		-- if the Ith bit is 1, then translate the unsigned of that number into an SLV
--		for I in 0 to 31 loop
--			if (one_hot_encoding(I) = '1') then
--				bin_vec := std_logic_vector(to_unsigned(I, 5));
--			end if;
--		end loop;
--		return bin_vec;
--	end function;
		

begin

	
	one_hot_s <=	x"00000001" when input(0) = '0' else
						x"00000002" when input(1) = '0' else
						x"00000004" when input(2) = '0' else
						x"00000008" when input(3) = '0' else
						x"00000010" when input(4) = '0' else
						x"00000020" when input(5) = '0' else
						x"00000040" when input(6) = '0' else
						x"00000080" when input(7) = '0' else
						x"00000100" when input(8) = '0' else
						x"00000200" when input(9) = '0' else
						x"00000400" when input(10) = '0' else
						x"00000800" when input(11) = '0' else
						x"00001000" when input(12) = '0' else
						x"00002000" when input(13) = '0' else
						x"00004000" when input(14) = '0' else
						x"00008000" when input(15) = '0' else
						x"00010000" when input(16) = '0' else
						x"00020000" when input(17) = '0' else
						x"00040000" when input(18) = '0' else
						x"00080000" when input(19) = '0' else
						x"00100000" when input(20) = '0' else
						x"00200000" when input(21) = '0' else
						x"00400000" when input(22) = '0' else
						x"00800000" when input(23) = '0' else
						x"01000000" when input(24) = '0' else
						x"02000000" when input(25) = '0' else
						x"04000000" when input(26) = '0' else
						x"08000000" when input(27) = '0' else
						x"10000000" when input(28) = '0' else
						x"20000000" when input(29) = '0' else
						x"40000000" when input(30) = '0' else
						x"80000000" when input(31) = '0' else
						x"00000000";
						
	-- Output: high when the output contains no zeros
	no_zero <= '1' when (input = x"FFFFFFFF") else '0';
	
	
	--addr_out <= one_hot_to_binary(one_hot_s);
	
	
	with
	one_hot_s select
		addr_out <=
			"00000" when "00000000000000000000000000000001",
			"00001" when "00000000000000000000000000000010",
			"00010" when "00000000000000000000000000000100",
			"00011" when "00000000000000000000000000001000",
			"00100" when "00000000000000000000000000010000",
			"00101" when "00000000000000000000000000100000",
			"00110" when "00000000000000000000000001000000",
			"00111" when "00000000000000000000000010000000",
			"01000" when "00000000000000000000000100000000",
			"01001" when "00000000000000000000001000000000",
			"01010" when "00000000000000000000010000000000",
			"01011" when "00000000000000000000100000000000",
			"01100" when "00000000000000000001000000000000",
			"01101" when "00000000000000000010000000000000",
			"01110" when "00000000000000000100000000000000",
			"01111" when "00000000000000001000000000000000",
			"10000" when "00000000000000010000000000000000",
			"10001" when "00000000000000100000000000000000",
			"10010" when "00000000000001000000000000000000",
			"10011" when "00000000000010000000000000000000",
			"10100" when "00000000000100000000000000000000",
			"10101" when "00000000001000000000000000000000",
			"10110" when "00000000010000000000000000000000",
			"10111" when "00000000100000000000000000000000",
			"11000" when "00000001000000000000000000000000",
			"11001" when "00000010000000000000000000000000",
			"11010" when "00000100000000000000000000000000",
			"11011" when "00001000000000000000000000000000",
			"11100" when "00010000000000000000000000000000",
			"11101" when "00100000000000000000000000000000",
			"11110" when "01000000000000000000000000000000",
			"11111" when others;

	
end first_zero_decoder_rtl;










