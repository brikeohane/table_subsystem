library ieee;
use ieee.std_logic_1164.all; 

entity table_interface is
	port(
		clk, reset: 	in std_logic;
		fwd_port_in: 	in std_logic_vector(1 downto 0);
		fwd_DA:			in std_logic_vector(47 downto 0);
		fwd_SA:			in std_logic_vector(47 downto 0);
		fwd_start:		in std_logic;
		fwd_done:		out std_logic;
		fwd_port_out:	out std_logic_vector(1 downto 0);
		fwd_broadcast:	out std_logic;
	
		ctrl_DA_start:		out std_logic;
		ctrl_DA:				out std_logic_vector(47 downto 0);
		ctrl_DA_port:		in std_logic_vector(1 downto 0);
		ctrl_DA_hit:		in std_logic;
		ctrl_DA_done:		in std_logic;
		ctrl_SA_start: 	out std_logic;
		ctrl_SA:				out std_logic_vector(47 downto 0);
		ctrl_SA_port: 		out std_logic_vector(1 downto 0);
		ctrl_SA_done: 		in std_logic;
		ctrl_aging_start: out std_logic;
		ctrl_aging_done:	in std_logic
	);
end table_interface;

architecture table_interface_rtl of table_interface is

	component rx_fsm is
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
	end component;
	
	component tx_fsm is
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
	end component;
	
	signal ctrl_DA_start_sig: std_logic;

begin

	rx_fsm_inst: rx_fsm
	port map(
		clk => clk,
		reset => reset,
		start => fwd_start,
		DA_in => fwd_DA,
		SA_in => fwd_SA,
		port_in => fwd_port_in,
		DA_out => ctrl_DA,
		SA_out => ctrl_SA,
		port_out => ctrl_SA_port,
		DA_start => ctrl_DA_start_sig,
		DA_done => ctrl_DA_done,
		SA_start => ctrl_SA_start,
		SA_done => ctrl_SA_done,
		aging_start => ctrl_aging_start,
		aging_done => ctrl_aging_done
	);
	
	tx_fsm_inst: tx_fsm
	port map(
		clk => clk,
		reset => reset,
		port_in => ctrl_DA_port,
		hit_in => ctrl_DA_hit,
		DA_done => ctrl_DA_done,
		fwd_start => fwd_start,
		port_out => fwd_port_out,
		broadcast => fwd_broadcast,
		done => fwd_done
	);
	
	ctrl_DA_start <= ctrl_DA_start_sig;
	
end table_interface_rtl;










