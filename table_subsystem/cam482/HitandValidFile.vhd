library ieee ;
use ieee.std_logic_1164.all; 
use ieee.numeric_std.all;

entity HitandValidFile is 
		port (
		--a 32 bit vector of all valid bits
		valid_out: out std_logic_vector(31 downto 0);
		hit_out: out std_logic_vector(31 downto 0);
		reg_out: out std_logic_vector(1 downto 0);
		--select one of 32 registers with 5 bit select sequence to write to
		CAMselectWrite: in std_logic_vector(4 downto 0); 
		Clear_Valid:	in std_logic; --clears valid bits with hits = 0
		Clear_Hit:	in 	std_logic; --clears all hit bits
		CAMWriteEnable: in std_logic; --Write enable from the CAM
		clk : in std_logic;
		reset: in std_logic );
end HitandValidFile ;

architecture behavioral of HitandValidFile is
--32 2-bit registers
type reg_arr is array(0 to 31) of std_logic_vector(1 downto 0);
signal rData: reg_arr; --each register in 32 register file
--signal registervalue: std_logic_vector(1 downto 0); --holds the 2 bit value of one register
signal valid_bit: std_logic;
begin
			valid_out(0) <= rData(0)(1);
			valid_out(1) <= rdata(1)(1);
			valid_out(2) <= rData(2)(1);
			valid_out(3) <= rdata(3)(1);
			valid_out(4) <= rData(4)(1);
			valid_out(5) <= rdata(5)(1);
			valid_out(6) <= rData(6)(1);
			valid_out(7) <= rdata(7)(1);
			valid_out(8) <= rData(8)(1);
			valid_out(9) <= rdata(9)(1);
			valid_out(10) <= rData(10)(1);
			valid_out(11) <= rdata(11)(1);
			valid_out(12) <= rData(12)(1);
			valid_out(13) <= rdata(13)(1);
			valid_out(14) <= rData(14)(1);
			valid_out(15) <= rdata(15)(1);
			valid_out(16) <= rData(16)(1);
			valid_out(17) <= rdata(17)(1);
			valid_out(18) <= rData(18)(1);
			valid_out(19) <= rdata(19)(1);
			valid_out(20) <= rData(20)(1);
			valid_out(21) <= rdata(21)(1);
			valid_out(22) <= rData(22)(1);
			valid_out(23) <= rdata(23)(1);
			valid_out(24) <= rData(24)(1);
			valid_out(25) <= rdata(25)(1);
			valid_out(26) <= rData(26)(1);
			valid_out(27) <= rdata(27)(1);
			valid_out(28) <= rData(28)(1);
			valid_out(29) <= rdata(29)(1);
			valid_out(30) <= rData(30)(1);
			valid_out(31) <= rdata(31)(1);
			
			hit_out(0) <= rData(0)(0);
			hit_out(1) <= rdata(1)(0);
			hit_out(2) <= rData(2)(0);
			hit_out(3) <= rdata(3)(0);
			hit_out(4) <= rData(4)(0);
			hit_out(5) <= rdata(5)(0);
			hit_out(6) <= rData(6)(0);
			hit_out(7) <= rdata(7)(0);
			hit_out(8) <= rData(8)(0);
			hit_out(9) <= rdata(9)(0);
			hit_out(10) <= rData(10)(0);
			hit_out(11) <= rdata(11)(0);
			hit_out(12) <= rData(12)(0);
			hit_out(13) <= rdata(13)(0);
			hit_out(14) <= rData(14)(0);
			hit_out(15) <= rdata(15)(0);
			hit_out(16) <= rData(16)(0);
			hit_out(17) <= rdata(17)(0);
			hit_out(18) <= rData(18)(0);
			hit_out(19) <= rdata(19)(0);
			hit_out(20) <= rData(20)(0);
			hit_out(21) <= rdata(21)(0);
			hit_out(22) <= rData(22)(0);
			hit_out(23) <= rdata(23)(0);
			hit_out(24) <= rData(24)(0);
			hit_out(25) <= rdata(25)(0);
			hit_out(26) <= rData(26)(0);
			hit_out(27) <= rdata(27)(0);
			hit_out(28) <= rData(28)(0);
			hit_out(29) <= rdata(29)(0);
			hit_out(30) <= rData(30)(0);
			hit_out(31) <= rdata(31)(0);
			
			
			reg_out <= rData(to_integer(unsigned(CAMselectWrite)));
		
	process(clk, reset, CAMWriteEnable, Clear_Hit, Clear_Valid, rData) is
	begin
		if (rising_edge(clk)) then
			if (reset = '1') then
				for I in 0 to 31 loop
					rData(I) <= "00";
				end loop;
			elsif (CAMWriteEnable = '1') then
					rData(to_integer(unsigned(CAMselectWrite))) <= "11";
			elsif (CAMWriteEnable = '0') and (rData(to_integer(unsigned(CAMselectWrite)))) = "10" then
				rData(to_integer(unsigned(CAMselectWrite))) <= "11";
			elsif(Clear_Hit = '1') then
					for I in 0 to 31 loop
						if rData(I) = "11" then
							rData(I) <= "10";
						end if;
					end loop;
			elsif(Clear_Valid = '1') then
					for J in 0 to 31 loop
						if rData(J) = "10" then
							rData(J) <= "00";
						else
							rData(J) <= rData(J);
						end if;
					end loop;
			end if;
		else
			for L in 0 to 31 loop
				rData(L) <= rData(L);
			end loop;
		end if;
	end process;
end behavioral;
