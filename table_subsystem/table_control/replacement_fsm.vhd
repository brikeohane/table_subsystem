library ieee;
use ieee.std_logic_1164.all; 

entity replacement_fsm is
	port(
		clk, reset: 		in std_logic;
		start: 				in std_logic;
		valid_bits:			in std_logic_vector(31 downto 0);
		hit_bits:			in std_logic_vector(31 downto 0);
		overw_valid_en:		out std_logic;
		overw_hit_en:		out std_logic;
		next_rep_addr: 		out std_logic_vector(4 downto 0);
		next_rep_en:		out std_logic;
		counter_value_out	:	out std_logic_vector(31 downto 0);
		done: 				out std_logic
	);
end replacement_fsm;

architecture replacement_fsm_rtl of replacement_fsm is

	component first_zero_decoder is
		port(
			input:		in std_logic_vector(31 downto 0);
			addr_out:	out std_logic_vector(4 downto 0);
			no_zero:	out std_logic
		);
	end component;
	
	component counter32v2 is
		port
		(
			clock		: IN STD_LOGIC ;
			cnt_en		: IN STD_LOGIC ;
			data		: IN STD_LOGIC_VECTOR (31 DOWNTO 0);
			sload		: IN STD_LOGIC ;
			sset		: IN STD_LOGIC ;
			q		: OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
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

	

	-- return valid file replacement address
	valid_bit_decoder_inst: first_zero_decoder
	port map(
		input => valid_bits,
		addr_out => valid_file_rep_addr,
		no_zero => valid_file_full
	);
	
	-- return hit file replacement address
	hit_bit_decoder_inst: first_zero_decoder
	port map(
		input => hit_bits,
		addr_out => hit_file_rep_addr,
		no_zero => hit_file_full
	);


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
		data => x"F0000000",
		sload => counter_set,
		sset => '0',
		q => counter_value
	);
	
	counter_value_out <= counter_value;
	
	
	-- Only enable timer when it is not done (restarted!)
	timer_done <= '1' when (counter_value = x"00000000") else '0';

	timer_en <= not(timer_done);
		
end replacement_fsm_rtl;










