library ieee;
use ieee.std_logic_1164.all; 
use ieee.numeric_std.all; 

entity cam482 is
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
end cam482;

architecture rtl of cam482 is

	component key_file is
		port(
			clk, reset: 		in std_logic;
			wr_en: 				in std_logic;
			key_in: 			in std_logic_vector(47 downto 0);
			next_replace_addr:	in std_logic_vector(4 downto 0);
			next_replace_en:	in std_logic;
			hit: 				out std_logic;
			addr_out: 			out std_logic_vector(4 downto 0)
		);
	end component;

	component reg_file is
		port(
			clk, reset: 	in std_logic;
			wr_en: 			in std_logic;
			w_addr:			in std_logic_vector(4 downto 0);
			w_data:			in std_logic_vector(1 downto 0);
			r_addr:			in std_logic_vector(4 downto 0);		
			r_data:			out std_logic_vector(1 downto 0)
		);
	end component;

	component HitandValidFile is 
		port (
			valid_out: 			out std_logic_vector(31 downto 0);
			hit_out:				out std_logic_vector(31 downto 0);
			reg_out:				out std_logic_vector(1 downto 0);
			CAMselectWrite: 	in std_logic_vector(4 downto 0); 
			Clear_Valid:		in std_logic; 
			Clear_Hit:			in 	std_logic; 
			CAMWriteEnable: 	in std_logic;
			clk : 				in std_logic;
			reset: 				in std_logic 
		);
	end component;

	component one_bit_reg_file is
		port(
			clk, reset: 	in std_logic;
			wr_en: 			in std_logic;
			w_addr:			in std_logic_vector(4 downto 0);
			w_bit:			in std_logic;
			r_addr:			in std_logic_vector(4 downto 0);		
			r_bit:			out std_logic;
			overwrite:		in std_logic_vector(31 downto 0);
			overwrite_en:	in std_logic;
			full_data:		out std_logic_vector(31 downto 0)
		);
	end component;

	signal addr_signal: std_logic_vector(4 downto 0);
	signal key_hit, valid_bit: std_logic;
	signal reg_out_s: std_logic_vector(1 downto 0);

begin

	key_file_inst: key_file
	port map(
		clk =>		clk,
		reset =>	reset,
		wr_en =>	wr_en,
		key_in =>	key_in,
		next_replace_addr => next_replace_addr,
		next_replace_en => next_replace_en,
		hit =>		key_hit,
		addr_out =>	addr_signal
	);

	reg_file_inst: reg_file
	port map(
		clk => 		clk,
		reset => 	reset,
		wr_en =>	wr_en,
		w_addr =>	addr_signal,
		w_data =>	data_in,
		r_addr =>	addr_signal,
		r_data => 	data_out
	);

	hit_valid_file_inst: HitandValidFile
	port map(
		valid_out => valid_bits,	
		hit_out => hit_bits,
		reg_out => reg_out_s,
		CAMselectWrite => addr_signal,
		Clear_Valid => overwrite_valid_en,
		Clear_Hit => overwrite_hit_en,	
		CAMWriteEnable => wr_en,
		clk => clk,
		reset => reset		
	);

	valid_bit <= reg_out_s(1);
	hit <= (key_hit and valid_bit);
end rtl;










