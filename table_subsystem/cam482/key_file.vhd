library ieee;
use ieee.std_logic_1164.all; 
use ieee.numeric_std.all; 

entity key_file is
	port(
		clk, reset: 		in std_logic;
		wr_en: 				in std_logic;
		key_in: 			in std_logic_vector(47 downto 0);
		next_replace_addr:	in std_logic_vector(4 downto 0);
		next_replace_en:	in std_logic;
		hit: 				out std_logic;
		addr_out: 			out std_logic_vector(4 downto 0)
	);
end key_file;

architecture rtl of key_file is
	constant WORD_LENGTH: 	natural:=5;
	constant BIT_LENGTH: 	natural:=48;

	type reg_file_type is array (2**WORD_LENGTH-1 downto 0) of
		std_logic_vector(BIT_LENGTH-1 downto 0);
	signal array_reg: 	reg_file_type;
	signal array_next:	reg_file_type;
	signal en: 			std_logic_vector(2**WORD_LENGTH-1 downto 0);
	signal match: 		std_logic_vector(2**WORD_LENGTH-1 downto 0);
	signal replace_reg: unsigned(WORD_LENGTH-1 downto 0);
	signal replace_next: unsigned(WORD_LENGTH-1 downto 0);
	signal addr_match: 	std_logic_vector(WORD_LENGTH-1 downto 0);
	signal wr_key: 		std_logic;
	signal hit_flag:	std_logic;

begin
	REG: process(clk, reset)
	begin
		if(reset = '1') then
			array_reg(0) <= (others=>'0');
			array_reg(1) <= (others=>'0');
			array_reg(2) <= (others=>'0');
			array_reg(3) <= (others=>'0');
			array_reg(4) <= (others=>'0');
			array_reg(5) <= (others=>'0');
			array_reg(6) <= (others=>'0');
			array_reg(7) <= (others=>'0');
			array_reg(8) <= (others=>'0');
			array_reg(9) <= (others=>'0');
			array_reg(10) <= (others=>'0');
			array_reg(11) <= (others=>'0');
			array_reg(12) <= (others=>'0');
			array_reg(13) <= (others=>'0');
			array_reg(14) <= (others=>'0');
			array_reg(15) <= (others=>'0');
			array_reg(16) <= (others=>'0');
			array_reg(17) <= (others=>'0');
			array_reg(18) <= (others=>'0');
			array_reg(19) <= (others=>'0');
			array_reg(20) <= (others=>'0');
			array_reg(21) <= (others=>'0');
			array_reg(22) <= (others=>'0');
			array_reg(23) <= (others=>'0');
			array_reg(24) <= (others=>'0');
			array_reg(25) <= (others=>'0');
			array_reg(26) <= (others=>'0');
			array_reg(27) <= (others=>'0');
			array_reg(28) <= (others=>'0');
			array_reg(29) <= (others=>'0');
			array_reg(30) <= (others=>'0');
			array_reg(31) <= (others=>'0');
		elsif (clk'event and clk='1') then
			array_reg(0) <= array_next(0);
			array_reg(1) <= array_next(1);
			array_reg(2) <= array_next(2);
			array_reg(3) <= array_next(3);
			array_reg(4) <= array_next(4);
			array_reg(5) <= array_next(5);
			array_reg(6) <= array_next(6);
			array_reg(7) <= array_next(7);
			array_reg(8) <= array_next(8);
			array_reg(9) <= array_next(9);
			array_reg(10) <= array_next(10);
			array_reg(11) <= array_next(11);
			array_reg(12) <= array_next(12);
			array_reg(13) <= array_next(13);
			array_reg(14) <= array_next(14);
			array_reg(15) <= array_next(15);
			array_reg(16) <= array_next(16);
			array_reg(17) <= array_next(17);
			array_reg(18) <= array_next(18);
			array_reg(19) <= array_next(19);
			array_reg(20) <= array_next(20);
			array_reg(21) <= array_next(21);
			array_reg(22) <= array_next(22);
			array_reg(23) <= array_next(23);
			array_reg(24) <= array_next(24);
			array_reg(25) <= array_next(25);
			array_reg(26) <= array_next(26);
			array_reg(27) <= array_next(27);
			array_reg(28) <= array_next(28);
			array_reg(29) <= array_next(29);
			array_reg(30) <= array_next(30);
			array_reg(31) <= array_next(31);
		end if;
	end process;
	
	ENABLE_LOGIC: process(array_reg, en, key_in)
	begin
		array_next(0) <= array_reg(0);
		array_next(1) <= array_reg(1);
		array_next(2) <= array_reg(2);
		array_next(3) <= array_reg(3);
		array_next(4) <= array_reg(4);
		array_next(5) <= array_reg(5);
		array_next(6) <= array_reg(6);
		array_next(7) <= array_reg(7);
		array_next(8) <= array_reg(8);
		array_next(9) <= array_reg(9);
		array_next(10) <= array_reg(10);
		array_next(11) <= array_reg(11);
		array_next(12) <= array_reg(12);
		array_next(13) <= array_reg(13);
		array_next(14) <= array_reg(14);
		array_next(15) <= array_reg(15);
		array_next(16) <= array_reg(16);
		array_next(17) <= array_reg(17);
		array_next(18) <= array_reg(18);
		array_next(19) <= array_reg(19);
		array_next(20) <= array_reg(20);
		array_next(21) <= array_reg(21);
		array_next(22) <= array_reg(22);
		array_next(23) <= array_reg(23);
		array_next(24) <= array_reg(24);
		array_next(25) <= array_reg(25);
		array_next(26) <= array_reg(26);
		array_next(27) <= array_reg(27);
		array_next(28) <= array_reg(28);
		array_next(29) <= array_reg(29);
		array_next(30) <= array_reg(30);
		array_next(31) <= array_reg(31);
		if(en(0) = '1') then 
			array_next(0) <= key_in; 
		end if;
		if(en(1) = '1') then 
			array_next(1) <= key_in; 
		end if;
		if(en(2) = '1') then 
			array_next(2) <= key_in; 
		end if;
		if(en(3) = '1') then 
			array_next(3) <= key_in; 
		end if;
		if(en(4) = '1') then 
			array_next(4) <= key_in; 
		end if;
		if(en(5) = '1') then 
			array_next(5) <= key_in; 
		end if;
		if(en(6) = '1') then 
			array_next(6) <= key_in; 
		end if;
		if(en(7) = '1') then 
			array_next(7) <= key_in; 
		end if;
		if(en(8) = '1') then 
			array_next(8) <= key_in; 
		end if;
		if(en(9) = '1') then 
			array_next(9) <= key_in; 
		end if;
		if(en(10) = '1') then 
			array_next(10) <= key_in; 
		end if;
		if(en(11) = '1') then 
			array_next(11) <= key_in; 
		end if;
		if(en(12) = '1') then 
			array_next(12) <= key_in; 
		end if;
		if(en(13) = '1') then 
			array_next(13) <= key_in; 
		end if;
		if(en(14) = '1') then 
			array_next(14) <= key_in; 
		end if;
		if(en(15) = '1') then 
			array_next(15) <= key_in; 
		end if;
		if(en(16) = '1') then 
			array_next(16) <= key_in; 
		end if;
		if(en(17) = '1') then 
			array_next(17) <= key_in; 
		end if;
		if(en(18) = '1') then 
			array_next(18) <= key_in; 
		end if;
		if(en(19) = '1') then 
			array_next(19) <= key_in; 
		end if;
		if(en(20) = '1') then 
			array_next(20) <= key_in; 
		end if;
		if(en(21) = '1') then 
			array_next(21) <= key_in; 
		end if;
		if(en(22) = '1') then 
			array_next(22) <= key_in; 
		end if;
		if(en(23) = '1') then 
			array_next(23) <= key_in; 
		end if;
		if(en(24) = '1') then 
			array_next(24) <= key_in; 
		end if;
		if(en(25) = '1') then 
			array_next(25) <= key_in; 
		end if;
		if(en(26) = '1') then 
			array_next(26) <= key_in; 
		end if;
		if(en(27) = '1') then 
			array_next(27) <= key_in; 
		end if;
		if(en(28) = '1') then 
			array_next(28) <= key_in; 
		end if;
		if(en(29) = '1') then 
			array_next(29) <= key_in; 
		end if;
		if(en(30) = '1') then 
			array_next(30) <= key_in; 
		end if;
		if(en(31) = '1') then 
			array_next(31) <= key_in; 
		end if;
	end process;
	
	wr_key <= '1' when (wr_en='1' and hit_flag='0') else '0';
	
	DECODE_REPLACE: process(wr_key, replace_reg)
	begin
		en <= (others=>'0');
		if(wr_key='1') then
			case replace_reg is
				when "00000" => 	en <= "00000000000000000000000000000001";
				when "00001" => 	en <= "00000000000000000000000000000010";
				when "00010" => 	en <= "00000000000000000000000000000100";
				when "00011" => 	en <= "00000000000000000000000000001000";
				when "00100" => 	en <= "00000000000000000000000000010000";
				when "00101" => 	en <= "00000000000000000000000000100000";
				when "00110" => 	en <= "00000000000000000000000001000000";
				when "00111" => 	en <= "00000000000000000000000010000000";
				when "01000" => 	en <= "00000000000000000000000100000000";
				when "01001" => 	en <= "00000000000000000000001000000000";
				when "01010" => 	en <= "00000000000000000000010000000000";
				when "01011" => 	en <= "00000000000000000000100000000000";
				when "01100" => 	en <= "00000000000000000001000000000000";
				when "01101" => 	en <= "00000000000000000010000000000000";
				when "01110" => 	en <= "00000000000000000100000000000000";
				when "01111" => 	en <= "00000000000000001000000000000000";
				when "10000" => 	en <= "00000000000000010000000000000000";
				when "10001" => 	en <= "00000000000000100000000000000000";
				when "10010" => 	en <= "00000000000001000000000000000000";
				when "10011" => 	en <= "00000000000010000000000000000000";
				when "10100" => 	en <= "00000000000100000000000000000000";
				when "10101" => 	en <= "00000000001000000000000000000000";
				when "10110" => 	en <= "00000000010000000000000000000000";
				when "10111" => 	en <= "00000000100000000000000000000000";
				when "11000" => 	en <= "00000001000000000000000000000000";
				when "11001" => 	en <= "00000010000000000000000000000000";
				when "11010" => 	en <= "00000100000000000000000000000000";
				when "11011" => 	en <= "00001000000000000000000000000000";
				when "11100" => 	en <= "00010000000000000000000000000000";
				when "11101" => 	en <= "00100000000000000000000000000000";
				when "11110" => 	en <= "01000000000000000000000000000000";
				when "11111" => 	en <= "10000000000000000000000000000000";
			end case;
		end if;
	end process;
	
	UPDATE_REPLACE: process(clk, reset)
	begin
		if(reset = '1') then
			replace_reg <= (others=>'0');
		elsif(clk'event and clk='1') then
			replace_reg <= replace_next;
		end if;
	end process;
	
	REPLACE_LOGIC: process(replace_reg, wr_key, next_replace_addr, next_replace_en)
	begin
		replace_next <= replace_reg;
		if(next_replace_en = '1') then
			replace_next <= unsigned(next_replace_addr);
		elsif(wr_key = '1') then
			replace_next <= (replace_reg + 1);
		end if;
	end process;
	
	
	KEY_MATCHING: process(array_reg, key_in)
	begin
		match <= (others=>'0');
		if (array_reg(0) = key_in) then 
			match(0) <= '1'; 
		end if;
		if (array_reg(1) = key_in) then 
			match(1) <= '1'; 
		end if;
		if (array_reg(2) = key_in) then 
			match(2) <= '1'; 
		end if;
		if (array_reg(3) = key_in) then 
			match(3) <= '1'; 
		end if;
		if (array_reg(4) = key_in) then 
			match(4) <= '1'; 
		end if;
		if (array_reg(5) = key_in) then 
			match(5) <= '1'; 
		end if;
		if (array_reg(6) = key_in) then 
			match(6) <= '1'; 
		end if;
		if (array_reg(7) = key_in) then 
			match(7) <= '1'; 
		end if;
		if (array_reg(8) = key_in) then 
			match(8) <= '1'; 
		end if;
		if (array_reg(9) = key_in) then 
			match(9) <= '1'; 
		end if;
		if (array_reg(10) = key_in) then 
			match(10) <= '1'; 
		end if;
		if (array_reg(11) = key_in) then 
			match(11) <= '1'; 
		end if;
		if (array_reg(12) = key_in) then 
			match(12) <= '1'; 
		end if;
		if (array_reg(13) = key_in) then 
			match(13) <= '1'; 
		end if;
		if (array_reg(14) = key_in) then 
			match(14) <= '1'; 
		end if;
		if (array_reg(15) = key_in) then 
			match(15) <= '1'; 
		end if;
		if (array_reg(16) = key_in) then 
			match(16) <= '1'; 
		end if;
		if (array_reg(17) = key_in) then 
			match(17) <= '1'; 
		end if;
		if (array_reg(18) = key_in) then 
			match(18) <= '1'; 
		end if;
		if (array_reg(19) = key_in) then 
			match(19) <= '1'; 
		end if;
		if (array_reg(20) = key_in) then 
			match(20) <= '1'; 
		end if;
		if (array_reg(21) = key_in) then 
			match(21) <= '1'; 
		end if;
		if (array_reg(22) = key_in) then 
			match(22) <= '1'; 
		end if;
		if (array_reg(23) = key_in) then 
			match(23) <= '1'; 
		end if;
		if (array_reg(24) = key_in) then 
			match(24) <= '1'; 
		end if;
		if (array_reg(25) = key_in) then 
			match(25) <= '1'; 
		end if;
		if (array_reg(26) = key_in) then 
			match(26) <= '1'; 
		end if;
		if (array_reg(27) = key_in) then 
			match(27) <= '1'; 
		end if;
		if (array_reg(28) = key_in) then 
			match(28) <= '1'; 
		end if;
		if (array_reg(29) = key_in) then 
			match(29) <= '1'; 
		end if;
		if (array_reg(30) = key_in) then 
			match(30) <= '1'; 
		end if;
		if (array_reg(31) = key_in) then 
			match(31) <= '1'; 
		end if;
	end process;

	with
	match select
		addr_match <=
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

	hit_flag <= '1' when (match /= "00000000000000000000000000000000") else '0';

	hit <= hit_flag;

	addr_out <= addr_match when (hit_flag = '1') else std_logic_vector(replace_reg);
end rtl;














