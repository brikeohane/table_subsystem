library ieee;
use ieee.std_logic_1164.all; 

entity replacement_fsm is
	port(
		clk, reset: 		in std_logic;
		start: 				in std_logic;
		valid_bits:			in std_logic_vector(31 downto 0);
		hit_bits:			in std_logic_vector(31 downto 0);
		overw_valid_bits:	out std_logic_vector(31 downto 0);
		overw_hit_bits:		out std_logic_vector(31 downto 0);
		overw_valid_en:		out std_logic;
		overw_hit_en:		out std_logic;
		next_rep_addr: 		out std_logic_vector(4 downto 0);
		next_rep_en:		out std_logic;
		done: 				out std_logic
	);
end replacement_fsm;

architecture replacement_fsm_rtl of replacement_fsm is

	component first_zero_decoder is
		port(
			input:		in std_logic_vector(31 downto 0);
			one_hot:	out std_logic_vector(31 downto 0);
			no_zero:	out std_logic
		);
	end component;
	
	component counter32v2 is
		port
		(
			clock: 	in std_logic;
			cnt_en: 	in std_logic;
			sset: 	in std_logic;
			q:		 	out std_logic_vector(31 downto 0)
		);
	end component;

	type state_type is (initial, clean_valid_file, clean_hit_file, update_replacement, finished);
	signal state_reg, state_next: state_type;
	signal timer_done: std_logic;
	signal timer_en: std_logic;

	signal valid_file_rep_1hot: std_logic_vector(31 downto 0);
	signal valid_file_rep_addr: std_logic_vector(4 downto 0);
	signal valid_file_full: std_logic;

	signal hit_file_rep_1hot: std_logic_vector(31 downto 0);
	signal hit_file_rep_addr: std_logic_vector(4 downto 0);
	signal hit_file_full: std_logic;
	
	signal counter_set: std_logic;
	signal counter_value: std_logic_vector(31 downto 0);

begin

	-- Update the current state every clock cycle
	STATE_REGISTER: process(clk,reset) 
	begin
		if(reset = '1') then 
			state_reg <= initial;
		elsif (clk'event and clk = '1') then 
			state_reg <= state_next;
		end if;
	end process;

	-- Define state transitions for the FSM
	NEXT_STATE: process(state_reg, start, timer_done) 
	begin
		case state_reg is 
			when initial =>
				if(start = '1') then
					state_next <= update_replacement;
				else
					state_next <= initial;
				end if;
			when update_replacement =>
				if(timer_done = '1') then
					state_next <= clean_valid_file;
				else
					state_next <= finished;
				end if;
			when clean_valid_file =>
				state_next <= clean_hit_file;
			when clean_hit_file => 
				state_next <= finished;
			when finished =>
				state_next <= initial;
		end case;
	end process;

	-- Specify Moore outputs for the FSM
	STATE_OUTPUT: process(state_reg, valid_file_full, hit_file_full)
	begin
		if(state_reg = finished) then
			done <= '1';
		else
			done <= '0'; 
		end if;
		if(state_reg = clean_valid_file) then
			overw_valid_en <= '1';
		else
			overw_valid_en <= '0'; 
		end if;
		if(state_reg = clean_hit_file) then
			overw_hit_en <= '1';
			counter_set <= '1';
		else
			overw_hit_en <= '0';
			counter_set	<= '0';
		end if;
		if(state_reg = update_replacement) then
			next_rep_en <= not(valid_file_full) or not(hit_file_full);
		else
			next_rep_en <= '0';
		end if;
	end process;

	overw_valid_bits <= (hit_bits and valid_bits);
	overw_hit_bits <= (others => '0');

	valid_bit_decoder_inst: first_zero_decoder
	port map(
		input => valid_bits,
		one_hot => valid_file_rep_1hot,
		no_zero => valid_file_full
	);

	hit_bit_decoder_inst: first_zero_decoder
	port map(
		input => hit_bits,
		one_hot => hit_file_rep_1hot,
		no_zero => hit_file_full
	);

	with
	valid_file_rep_1hot select
		valid_file_rep_addr <=
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

	with
	hit_file_rep_1hot select
		hit_file_rep_addr <=
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

	NEXT_REPLACE: process(valid_file_full, hit_file_full, valid_file_rep_addr, hit_file_rep_addr)
	begin
		if(valid_file_full = '0') then
			next_rep_addr <= valid_file_rep_addr;
		elsif(hit_file_full = '0') then
			next_rep_addr <= hit_file_rep_addr;
		else
			next_rep_addr <= (others => '0');
		end if;
	end process;
	
	big_counter_inst: counter32v2
	port map(
		clock => clk, 
		cnt_en => timer_en,
		sset => counter_set,
		q => counter_value
	);
	
	timer_done <= '1' when (counter_value = "00000000000000000000000000000000") else '0';
	timer_en <= not(timer_done);
		
end replacement_fsm_rtl;










