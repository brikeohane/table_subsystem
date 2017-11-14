library ieee;
use ieee.std_logic_1164.all; 

entity table_subsystem is
	port(
		clk, reset: in std_logic;
		start: 		in std_logic;
		DA:			in std_logic_vector(47 downto 0);
		SA: 			in std_logic_vector(47 downto 0);
		port_in:		in std_logic_vector(1 downto 0);
		port_out: 	out std_logic_vector(1 downto 0);
		broadcast:	out std_logic;
		done:			out std_logic
	);
end table_subsystem;

architecture table_subsystem_rtl of table_subsystem is

	component cam482 is
		port(
			clk, reset: 			in std_logic;
			wr_en: 					in std_logic;
			key_in: 				in std_logic_vector(47 downto 0);
			data_in:				in std_logic_vector(1 downto 0);
			data_out: 				out std_logic_vector(1 downto 0);
			hit:					out std_logic;
			overwrite_valid_en:		in std_logic;
			valid_bits:				out std_logic_vector(31 downto 0);
			overwrite_hit_en:		in std_logic;
			hit_bits:				out std_logic_vector(31 downto 0);
			next_replace_addr:		in std_logic_vector(4 downto 0);
			next_replace_en:		in std_logic
		);
	end component;
	
	component table_control is
		port(
			clk, reset: 	in std_logic;
			DA_start: 		in std_logic;
			DA:				in std_logic_vector(47 downto 0);
			DA_port:			out std_logic_vector(1 downto 0);
			DA_hit:			out std_logic;
			DA_done: 		out std_logic;
			SA_start:		in std_logic;
			SA:				in std_logic_vector(47 downto 0);
			SA_port:			in std_logic_vector(1 downto 0);
			SA_done:			out std_logic;
			aging_start: 	in std_logic;
			aging_done:		out std_logic;
			
			cam_key:				out std_logic_vector(47 downto 0);
			cam_SA_port:		out std_logic_vector(1 downto 0);
			cam_w_en:			out std_logic;
			cam_DA_port:		in std_logic_vector(1 downto 0);
			cam_hit:				in std_logic;
			cam_valid_bits: 	in std_logic_vector(31 downto 0);
			cam_hit_bits:		in std_logic_vector(31 downto 0);
			cam_overw_v_bits:	out std_logic_vector(31 downto 0);
			cam_overw_h_bits:	out std_logic_vector(31 downto 0);
			cam_overw_v_en: 	out std_logic;
			cam_overw_h_en:	out std_logic;
			cam_next_rep_addr: out std_logic_vector(4 downto 0);
			cam_next_rep_en:	out std_logic
		);
	end component;
	
	component table_interface is
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
	end component;

	signal cam_key_sig: std_logic_vector(47 downto 0);
	signal cam_SA_port_sig: std_logic_vector(1 downto 0);
	signal cam_w_en_sig: std_logic;
	signal cam_DA_port_sig: std_logic_vector(1 downto 0);
	signal cam_hit_sig: std_logic;
	signal cam_valid_bits_sig: std_logic_vector(31 downto 0);
	signal cam_hit_bits_sig: std_logic_vector(31 downto 0);
	signal cam_overw_v_en_sig: std_logic;
	signal cam_overw_h_en_sig: std_logic;
	signal cam_next_rep_addr_sig: std_logic_vector(4 downto 0);
	signal cam_next_rep_en_sig: std_logic;
	
	signal ctrl_DA_start_sig: std_logic;
	signal ctrl_DA_sig:	std_logic_vector(47 downto 0);
	signal ctrl_DA_port_sig: std_logic_vector(1 downto 0);
	signal ctrl_DA_hit_sig: std_logic;
	signal ctrl_DA_done_sig: std_logic;
	signal ctrl_SA_start_sig:	std_logic;
	signal ctrl_SA_sig: std_logic_vector(47 downto 0);
	signal ctrl_SA_port_sig: std_logic_vector(1 downto 0);
	signal ctrl_SA_done_sig: std_logic;
	signal ctrl_aging_start_sig: std_logic;
	signal ctrl_aging_done_sig: std_logic;
	
begin

	table_CAM_inst: cam482
	port map(
		clk => clk,
		reset => reset,
		wr_en => cam_w_en_sig,
		key_in => cam_key_sig,
		data_in => cam_SA_port_sig,
		data_out => cam_DA_port_sig,
		hit => cam_hit_sig,
		overwrite_valid_en => cam_overw_v_en_sig,
		valid_bits => cam_valid_bits_sig,
		overwrite_hit_en => cam_overw_h_en_sig,
		hit_bits => cam_hit_bits_sig,
		next_replace_addr => cam_next_rep_addr_sig,
		next_replace_en => cam_next_rep_en_sig
	);
	
	table_control_inst: table_control
	port map(
		clk => clk,
		reset => reset,
		DA_start => ctrl_DA_start_sig,
		DA => ctrl_DA_sig,
		DA_port => ctrl_DA_port_sig,
		DA_hit => ctrl_DA_hit_sig,
		DA_done => ctrl_DA_done_sig,
		SA_start => ctrl_SA_start_sig,
		SA => ctrl_SA_sig,
		SA_port => ctrl_SA_port_sig,
		SA_done => ctrl_SA_done_sig,
		aging_start => ctrl_aging_start_sig,
		aging_done => ctrl_aging_done_sig,
		
		cam_key => cam_key_sig,
		cam_SA_port => cam_SA_port_sig,
		cam_w_en => cam_w_en_sig,
		cam_DA_port => cam_DA_port_sig,
		cam_hit => cam_hit_sig,
		cam_valid_bits => cam_valid_bits_sig,
		cam_hit_bits => cam_hit_bits_sig,
		cam_overw_v_bits => cam_overw_v_bits_sig,
		cam_overw_h_bits => cam_overw_h_bits_sig,
		cam_overw_v_en => cam_overw_v_en_sig,
		cam_overw_h_en => cam_overw_h_en_sig,
		cam_next_rep_addr => cam_next_rep_addr_sig,
		cam_next_rep_en => cam_next_rep_en_sig
	);
	
	table_interface_inst: table_interface
	port map(
		clk => clk,
		reset => reset,
		fwd_port_in => port_in,	
		fwd_DA => DA,			
		fwd_SA => SA,			
		fwd_start => start,		
		fwd_done => done,		
		fwd_port_out => port_out,	
		fwd_broadcast => broadcast,
	
		ctrl_DA_start => ctrl_DA_start_sig,	
		ctrl_DA => ctrl_DA_sig,	 			
		ctrl_DA_port => ctrl_DA_port_sig,		
		ctrl_DA_hit => ctrl_DA_hit_sig,		
		ctrl_DA_done => ctrl_DA_done_sig,		
		ctrl_SA_start => ctrl_SA_start_sig,
		ctrl_SA => ctrl_SA_sig,			
		ctrl_SA_port => ctrl_SA_port_sig, 		
		ctrl_SA_done => ctrl_SA_done_sig, 		
		ctrl_aging_start => ctrl_aging_start_sig,
		ctrl_aging_done => ctrl_aging_done_sig	
	);

end table_subsystem_rtl;