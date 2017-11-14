library ieee;
use ieee.std_logic_1164.all; 

entity tx_fsm is
	port(
		clk, reset: in std_logic;
		port_in: 	in std_logic_vector(1 downto 0);
		hit_in:		in std_logic;
		DA_done:		in std_logic;
		fwd_start:	in std_logic;
		port_out: 	out std_logic_vector(1 downto 0);
		broadcast:	out std_logic;
		done: 		out std_logic
	);
end tx_fsm;

architecture tx_fsm_rtl of tx_fsm is

	type state_type is (initial, finished);
	signal state_reg, state_next: state_type;
	signal port_reg: std_logic_vector(1 downto 0);
	signal hit_reg: std_logic;
	signal port_next: std_logic_vector(1 downto 0);
	signal hit_next: std_logic;

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

	OUTPUT_REGISTER: process(clk, port_next, hit_next)
	begin
		if(clk'event and clk = '1') then 
			port_reg <= port_next;
			hit_reg <= hit_next;
		end if;
	end process;
	
	REG_ENABLE_LOGIC: process(clk, DA_done, port_in, hit_in, port_reg, hit_reg)
	begin
		if(DA_done = '1') then 
			port_next <= port_in;
			hit_next <= hit_in;
		else
			port_next <= port_reg;
			hit_next <= hit_reg;
		end if;
	end process;

	-- Define state transitions for the FSM
	NEXT_STATE: process(state_reg, DA_done, fwd_start) 
	begin
		case state_reg is 
			when initial =>
				if(DA_done = '1') then 
					state_next <= finished;
				else
					state_next <= initial;
				end if; 
			when finished =>
				if(fwd_start = '1') then
					state_next <= initial;
				else
					state_next <= finished;
				end if;
		end case;
	end process;

	-- Specify Moore outputs for the FSM
	STATE_OUTPUT: process(state_reg)
	begin
		if(state_reg = finished) then
			done <= '1';
		else
			done <= '0'; 
		end if;
	end process;
	
	broadcast <= not(hit_reg);
	port_out <= port_reg;
end tx_fsm_rtl;










