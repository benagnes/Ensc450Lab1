-------------------------------------------------------------------------------
--
-- Project:	<Floating Point Unit Core>
--  	
-- Description: test bench for the FPU core
-------------------------------------------------------------------------------
--
--				100101011010011100100
--				110000111011100100000
--				100000111011000101101
--				100010111100101111001
--				110000111011101101001
--				010000001011101001010
--				110100111001001100001
--				110111010000001100111
--				110110111110001011101
--				101110110010111101000
--				100000010111000000000
--
-- 	Author:		 Jidan Al-eryani 
-- 	E-mail: 	 jidan@gmx.net
--
--  Copyright (C) 2006
--
--	This source file may be used and distributed without        
--	restriction provided that this copyright statement is not   
--	removed from the file and that any derivative work contains 
--	the original copyright notice and the associated disclaimer.
--                                                           
--		THIS SOFTWARE IS PROVIDED ``AS IS'' AND WITHOUT ANY     
--	EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED   
--	TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS   
--	FOR A PARTICULAR PURPOSE. IN NO EVENT SHALL THE AUTHOR      
--	OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,         
--	INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES    
--	(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE   
--	GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR        
--	BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF  
--	LIABILITY, WHETHER IN  CONTRACT, STRICT LIABILITY, OR TORT  
--	(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT  
--	OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE         
--	POSSIBILITY OF SUCH DAMAGE. 
--

library ieee;
use work.fpupack.all;
use work.comppack.all;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
use ieee.std_logic_misc.all;
use std.textio.all;
use work.txt_util.all;

        -- fpu operations (fpu_op_i):
		-- ========================
		-- 000 = add, 
		-- 001 = substract, 
		-- 010 = multiply, 
		-- 011 = unused,
		-- 100 = unused
		-- 101 = unused
		-- 110 = unused
		-- 111 = unused
		
        -- Rounding Mode: 
        -- ==============
        -- 00 = round to nearest even(default), 
        -- 01 = round to zero, 
        -- 10 = round up, 
        -- 11 = round down


entity fpu_double_tb is
end fpu_double_tb;

architecture rtl of fpu_double_tb is

	component fpu_double
	port(
		clk : in std_logic;
		rst : in std_logic;
		enable : in std_logic;
		rmode : in std_logic_vector(1 downto 0);
		fpu_op : in std_logic_vector(2 downto 0);
		opa : in std_logic_vector(63 downto 0);
		opb : in std_logic_vector(63 downto 0);
		out_fp : out std_logic_vector(63 downto 0);
		ready : out std_logic;
		underflow : out std_logic;
		overflow : out std_logic;
		inexact : out std_logic;
		exception : out std_logic;
		invalid : out std_logic );
	end component;



	signal clk : std_logic := '1';
	signal rst : std_logic;
	signal enable : std_logic;
	signal rmode : std_logic_vector(1 downto 0);
	signal fpu_op : std_logic_vector(2 downto 0);
	signal opa : std_logic_vector(63 downto 0);
	signal opb : std_logic_vector(63 downto 0);
	signal out_fp : std_logic_vector(63 downto 0);	   
	
	signal ready : std_logic;
	signal underflow : std_logic;
	signal overflow : std_logic;
	signal inexact : std_logic;
	signal exception : std_logic;
	signal invalid : std_logic;

	signal simend : std_logic := '0';



signal out_fp_uut, out_fp_expect : std_logic_vector(63 downto 0);	   

constant CLK_PERIOD :time := 100 ns; -- period of clk period


begin
    ---------------------------------------------------------------------------
    -- toggle clock
    ---------------------------------------------------------------------------
	-- clk <= not(clk) after 50 ns;
	process
	begin
		while (simend = '0') loop
			clk <= not clk;
			wait for 50 ns;
		end loop;
		wait;
	end process;
	

	out_fp_uut <= out_fp;
    -- instantiate fpu
	UUT : fpu_double
	port map (
		clk => clk,
		rst => rst,
		enable => enable,
		rmode => rmode,
		fpu_op => fpu_op,
		opa => opa,
		opb => opb,
		out_fp => out_fp,
		ready => ready,
		underflow => underflow,
		overflow => overflow,
		inexact => inexact,
		exception => exception,
		invalid => invalid
	);	


    verify : process 
		--The operands and results are in Hex format. The test vectors must be placed in a strict order for the verfication to work.
		file testcases_file: TEXT open read_mode is "../vhdl/testcases.txt"; --Name of the file containing the test cases. 

		variable file_line: line;
		variable str_in: string(64 downto 1);
		variable str_fpu_op: string(3 downto 1);
		variable str_rmode: string(2 downto 1);
    begin


		---------------------------------------------------------------------------------------------------------------------------------------------------
		---------------------------------------------------SoftFloat test vectors (10000 test cases for each operation) --------------------------------------------------------------------
		
		rst <= '1';
		wait for CLK_PERIOD;
		rst <= '0';
		enable <= '1';

		while not endfile(testcases_file) loop

			wait for CLK_PERIOD; enable <= '1';
			
			str_read(testcases_file,str_in);
			opa <= to_std_logic_vector(str_in);
			
			str_read(testcases_file,str_in);
			opb <= to_std_logic_vector(str_in);

			str_read(testcases_file,str_fpu_op);
			fpu_op <= to_std_logic_vector(str_fpu_op);
			
			str_read(testcases_file,str_rmode);
			rmode <= to_std_logic_vector(str_rmode);
			
			str_read(testcases_file,str_in);
			out_fp_expect <= to_std_logic_vector(str_in);
			
			wait for CLK_PERIOD;
			enable <= '0'; wait until ready='1';

			wait for CLK_PERIOD;
			wait for CLK_PERIOD;
			wait for CLK_PERIOD;
			wait for CLK_PERIOD;
			wait for CLK_PERIOD;
			wait for CLK_PERIOD;
			wait for CLK_PERIOD;
			wait for CLK_PERIOD;
			wait for CLK_PERIOD;
			wait for CLK_PERIOD;

			assert out_fp_uut = out_fp_expect
			report "Error!!!"
			severity failure;
			str_read(testcases_file,str_in);
			
		end loop;		

		-------- Boundary values-----
		
		-- start_i <= '0';
		-- --		  seeeeeeeefffffffffffffffffffffff
		-- --infinity
		-- wait for CLK_PERIOD; start_i <= '1'; 
		-- opa_i <= "01111111011111111111111111111111";  
		-- opb_i <= "01111111011111111111111111111111"; 
		-- fpu_op_i <= "000";
		-- rmode_i <= "00";
		-- wait for CLK_PERIOD; start_i <= '0'; wait until ready_o='1';
		-- assert output_o="01111111100000000000000000000000"
		-- report "Error!!!"
		-- severity failure;
		
		-- --		  seeeeeeeefffffffffffffffffffffff
		-- -- 1 x1.001 - 1x1.000 = 0x0.001
		-- wait for CLK_PERIOD; start_i <= '1'; 
		-- opa_i <= "00000000100100000000000000000000";  
		-- opb_i <= "10000000100000000000000000000000"; 
		-- fpu_op_i <= "000";
		-- rmode_i <= "00";
		-- wait for CLK_PERIOD; start_i <= '0'; wait until ready_o='1';
		-- assert output_o="00000000000100000000000000000000"
		-- report "Error!!!"
		-- severity failure;	

		-- --		  seeeeeeeefffffffffffffffffffffff
		-- -- 10 x 1.0001 - 10 x 1.0000 = 
		-- wait for CLK_PERIOD; start_i <= '1'; 
		-- opa_i <= "00000001000010000000000000000000";  
		-- opb_i <= "10000001000000000000000000000000"; 
		-- fpu_op_i <= "000";
		-- rmode_i <= "00";
		-- wait for CLK_PERIOD; start_i <= '0'; wait until ready_o='1';
		-- assert output_o="00000000000100000000000000000000"
		-- report "Error!!!"
		-- severity failure;
		

		-- --		  seeeeeeeefffffffffffffffffffffff
		-- -- -0 -0 = -0  
		-- wait for CLK_PERIOD; start_i <= '1'; 
		-- opa_i <= "10000000000000000000000000000000";  
		-- opb_i <= "10000000000000000000000000000000"; 
		-- fpu_op_i <= "000";
		-- rmode_i <= "00";
		-- wait for CLK_PERIOD; start_i <= '0'; wait until ready_o='1';
		-- assert output_o="10000000000000000000000000000000"
		-- report "Error!!!"
		-- severity failure;
		
		-- --		  seeeeeeeefffffffffffffffffffffff
		-- -- 0 + x = x 
		-- wait for CLK_PERIOD; start_i <= '1'; 
		-- opa_i <= "00000000000000000000000000000000";  
		-- opb_i <= "01000010001000001000000000100000"; 
		-- fpu_op_i <= "000";
		-- rmode_i <= "00";
		-- wait for CLK_PERIOD; start_i <= '0'; wait until ready_o='1';
		-- assert output_o="01000010001000001000000000100000"
		-- report "Error!!!"
		-- severity failure;
		

		----------------------------------------------------------------------------------------------------------------------------------------------------

		simend <= '1';

		-- assert false
		-- report "Success!!!.......Yahoooooooooooooo"
		-- severity failure;	
				
    	wait;

    end process verify;

end rtl;

