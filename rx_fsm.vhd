library ieee;
use ieee.std_logic_1164.all; 

entity rx_fsm is
	port(
		clk, reset: in std_logic;
		start: 		in std_logic;
		DA_in:		in std_logic_vector(47 downto 0);
		SA_in:		in std_logic_vector(47 downto 0);
		port_in: 	in std_logic_vector(1 downto 0);
		DA_out:	out std_logic_vector(47 downto 0);
		SA_out:	out std_logic_vector(47 downto 0);
		port_out: 	out std_logic_vector(1 downto 0);
		DA_start:	out std_logic;
		DA_done:	in std_logic;
		SA_start:	out std_logic;
		SA_done:	in std_logic;
		aging_start: out std_logic;
		aging_done: in std_logic
	);
end rx_fsm;

architecture rx_fsm_rtl of rx_fsm is

	type state_type is (initial, lookup, learning, aging);
	signal state_reg, state_next: state_type;
	signal DA_reg, SA_reg: std_logic_vector(47 downto 0);
	signal port_reg: std_logic_vector(1 downto 0);
	signal DA_next, SA_next: std_logic_vector(47 downto 0);
	signal port_next: std_logic_vector(1 downto 0);

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

	INPUT_REGISTER: process(clk, DA_next, SA_next, port_next)
	begin
		if((clk'event) and clk = '1') then 
			DA_reg <= DA_next;
			SA_reg <= SA_next;
			port_reg <= port_next;
		end if;
	end process;
	
	REG_ENABLE_LOGIC: process(clk, start, DA_in, SA_in, port_in, DA_reg, SA_reg, port_reg)
	begin
		if(start = '1') then 
			DA_next <= DA_in;
			SA_next <= SA_in;
			port_next <= port_in;
		else
			DA_next <= DA_reg;
			SA_next <= SA_reg;
			port_next <= port_reg;
		end if;
	end process;

	-- Define state transitions for the FSM
	NEXT_STATE: process(state_reg, start, DA_done, SA_done, aging_done) 
	begin
		case state_reg is 
			when initial =>
				if(start = '1') then 
					state_next <= lookup;
				else
					state_next <= initial;
				end if; 
			when lookup =>
				if(DA_done = '1') then
					state_next <= learning;
				else
					state_next <= lookup;
				end if;
			when learning => 
				if(SA_done = '1') then
					state_next <= aging;
				else
					state_next <= learning;
				end if;
			when aging => 
				if(aging_done = '1') then
					state_next <= initial;
				else
					state_next <= aging;
				end if;
		end case;
	end process;

	-- Specify Moore outputs for the FSM
	STATE_OUTPUT: process(state_reg)
	begin
		if(state_reg = lookup) then
			DA_start <= '1';
		else
			DA_start <= '0'; 
		end if;
		if(state_reg = learning) then
			SA_start <= '1';
		else
			SA_start <= '0'; 
		end if;
		if(state_reg = aging) then
			aging_start <= '1';
		else
			aging_start <= '0'; 
		end if;
	end process;
	
	DA_out <= DA_reg;
	SA_out <= SA_reg;
	port_out <= port_reg;
end rx_fsm_rtl;










