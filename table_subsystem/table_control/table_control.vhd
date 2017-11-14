library ieee;
use ieee.std_logic_1164.all; 

entity table_control is
	port(
		clk, reset: 	in std_logic;
		DA_start: 		in std_logic;
		DA:				in std_logic_vector(47 downto 0);
		DA_port:		out std_logic_vector(1 downto 0);
		DA_hit:			out std_logic;
		DA_done: 		out std_logic;
		SA_start:		in std_logic;
		SA:				in std_logic_vector(47 downto 0);
		SA_port:		in std_logic_vector(1 downto 0);
		SA_done:		out std_logic;
		aging_start: 	in std_logic;
		aging_done:		out std_logic;
		
		cam_key:			out std_logic_vector(47 downto 0);
		cam_SA_port:		out std_logic_vector(1 downto 0);
		cam_w_en:			out std_logic;
		cam_DA_port:		in std_logic_vector(1 downto 0);
		cam_hit:			in std_logic;
		cam_valid_bits: 	in std_logic_vector(31 downto 0);
		cam_hit_bits:		in std_logic_vector(31 downto 0);
		cam_overw_v_en: 	out std_logic;
		cam_overw_h_en:		out std_logic;
		cam_next_rep_addr: 	out std_logic_vector(4 downto 0);
		cam_next_rep_en:	out std_logic
	);
end table_control;

architecture table_control_rtl of table_control is

	component write_fsm is
		port(
			clk, reset: in std_logic;
			start: 		in std_logic;
			key_in:		in std_logic_vector(47 downto 0);
			data_in: 	in std_logic_vector(1 downto 0);
			key_out:	out std_logic_vector(47 downto 0);
			data_out: 	out std_logic_vector(1 downto 0);
			write_en:	out std_logic;
			done:		out std_logic
		);
	end component;

	component read_fsm is
		port(
			clk, reset: in std_logic;
			start: 		in std_logic;
			key_in:		in std_logic_vector(47 downto 0);
			key_out:	out std_logic_vector(47 downto 0);
			data_in: 	in std_logic_vector(1 downto 0);
			hit_in:		in std_logic;
			data_out:	out std_logic_vector(1 downto 0);
			hit_out:	out std_logic;
			done:		out std_logic
		);
	end component;
	
	component replacement_fsm is
		port(
			clk, reset: 		in std_logic;
			start: 				in std_logic;
			valid_bits:			in std_logic_vector(31 downto 0);
			hit_bits:			in std_logic_vector(31 downto 0);
			overw_valid_en:		out std_logic;
			overw_hit_en:		out std_logic;
			next_rep_addr: 		out std_logic_vector(4 downto 0);
			next_rep_en:		out std_logic;
			done: 				out std_logic
		);
	end component;
	
	type state_type is (lookup, learning, aging);
	signal state_reg, state_next: state_type;
	signal DA_key_signal, SA_key_signal: std_logic_vector(47 downto 0);
	
begin

	DA_Lookup_FSM_inst: read_fsm
	port map(
		clk => clk,
		reset => reset,
		start => DA_start,
		key_in => DA,
		key_out => DA_key_signal,
		data_in => cam_DA_port,
		hit_in => cam_hit,
		data_out => DA_port,
		hit_out => DA_hit,
		done => DA_done
	);
	
	SA_Learning_FSM_inst: write_fsm
	port map(
		clk => clk,
		reset => reset,
		start => SA_start,
		key_in => SA,
		data_in => SA_port,
		key_out => SA_key_signal,
		data_out => cam_SA_port,
		write_en => cam_w_en,
		done => SA_done
	);
	
	replacement_fsm_inst: replacement_fsm 
	port map(
		clk => clk,
		reset => reset,
		start => aging_start,
		valid_bits => cam_valid_bits,
		hit_bits => cam_hit_bits,
		overw_valid_en => cam_overw_v_en,
		overw_hit_en => cam_overw_h_en,
		next_rep_addr => cam_next_rep_addr,
		next_rep_en => cam_next_rep_en,
		done => aging_done
	);
		
	STATE_REGISTER: process(clk,reset) 
	begin
		if(reset = '1') then 
			state_reg <= lookup;
		elsif (clk'event and clk = '1') then 
			state_reg <= state_next;
		end if;
	end process;
	
	NEXT_STATE: process(state_reg, DA_start, SA_start, aging_start) 
	begin
		case state_reg is 
			when lookup =>
				if(SA_start = '1') then
					state_next <= learning;
				elsif(aging_start = '1') then
					state_next <= aging;
				else
					state_next <= lookup;
				end if;
			when learning => 
				if(DA_start = '1') then
					state_next <= lookup;
				elsif(aging_start = '1') then
					state_next <= aging;
				else
					state_next <= learning;
				end if;
			when aging => 
				if(DA_start = '1') then
					state_next <= lookup;
				elsif(SA_start = '1') then
					state_next <= learning;
				else
					state_next <= aging;
				end if;
		end case;
	end process;
	
	STATE_OUTPUT: process(state_reg, DA_key_signal, SA_key_signal)
	begin
		if(state_reg = lookup) then
			cam_key <= DA_key_signal;
		else
			cam_key <= SA_key_signal;
		end if;
	end process;
	
end table_control_rtl;










