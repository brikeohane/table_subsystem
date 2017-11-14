library ieee;
use ieee.std_logic_1164.all; 

entity write_fsm is
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
end write_fsm;

architecture write_fsm_rtl of write_fsm is

	type state_type is (initial, writing, finished);
	signal state_reg, state_next: state_type;
	signal key_reg: std_logic_vector(47 downto 0);
	signal data_reg: std_logic_vector(1 downto 0);

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

	INPUT_REGISTER: process(clk,key_in,data_in)
	begin
		if(clk'event and clk = '1') then 
			key_reg <= key_in;
			data_reg <= data_in;
		end if;
	end process;

	-- Define state transitions for the FSM
	NEXT_STATE: process(state_reg, start) 
	begin
		case state_reg is 
			when initial =>
				if (start = '1') then 
					state_next <= writing;
				else
					state_next <= initial;
				end if; 
			when writing =>
				state_next <= finished;
			when finished => 
				state_next <= initial;
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
		if(state_reg = writing) then
			write_en <= '1';
		else
			write_en <= '0';
		end if;
	end process;

	-- Output to CAM
	key_out <= key_reg;
	data_out <= data_reg;
end write_fsm_rtl;










