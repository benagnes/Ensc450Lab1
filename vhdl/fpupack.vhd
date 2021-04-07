---------------------------------------------------------------------
----                                                             ----
----  FPU                                                        ----
----  Floating Point Unit (Double precision)                     ----
----                                                             ----
----  Author: David Lundgren                                     ----
----          davidklun@gmail.com                                ----
----                                                             ----
---------------------------------------------------------------------
----                                                             ----
---- Copyright (C) 2009 David Lundgren                           ----
----                  davidklun@gmail.com                        ----
----                                                             ----
---- This source file may be used and distributed without        ----
---- restriction provided that this copyright statement is not   ----
---- removed from the file and that any derivative work contains ----
---- the original copyright notice and the associated disclaimer.----
----                                                             ----
----     THIS SOFTWARE IS PROVIDED ``AS IS'' AND WITHOUT ANY     ----
---- EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED   ----
---- TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS   ----
---- FOR A PARTICULAR PURPOSE. IN NO EVENT SHALL THE AUTHOR      ----
---- OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,         ----
---- INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES    ----
---- (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE   ----
---- GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR        ----
---- BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF  ----
---- LIABILITY, WHETHER IN  CONTRACT, STRICT LIABILITY, OR TORT  ----
---- (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT  ----
---- OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE         ----
---- POSSIBILITY OF SUCH DAMAGE.                                 ----
----                                                             ----
---------------------------------------------------------------------

library  ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

package fpupack is

    -- count the number of zeros starting from the left
    function count_l_zeros (signal s_vector: std_logic_vector) return std_logic_vector;
    function count_zeros_mul (signal s_vector: std_logic_vector) return std_logic_vector;
    FUNCTION clz64 (CONSTANT v : std_logic_vector(0 TO 63)) RETURN std_logic_vector;
    function reverse_any_vector (a: in std_logic_vector) return std_logic_vector;
    
end fpupack;

package body fpupack is
    
	function count_l_zeros (signal s_vector: std_logic_vector) return std_logic_vector is
		variable v_count : std_logic_vector(5 downto 0);	
	begin
		v_count := "000000";
		for i in s_vector'range loop
			case s_vector(i) is
				when '0' => v_count := v_count + "000001";
				when others => exit;
			end case;
		end loop;
		return v_count;	
	end count_l_zeros;
		
	-- count the zeros from the left for multiply
	function count_zeros_mul (signal s_vector: std_logic_vector) return std_logic_vector is
		variable v_count : std_logic_vector(5 downto 0);	
	begin
		v_count := "000000";
		for i in 105 downto 52 loop
			case s_vector(i) is
				when '0' => v_count := v_count + "000001";
				when others => exit;
			end case;
		end loop;
		return v_count;	
    end count_zeros_mul;
    
-- https://electronics.stackexchange.com/questions/196914/verilog-synthesize-high-speed-leading-zero-count
    FUNCTION enc(CONSTANT a : std_logic_vector(1 DOWNTO 0)) RETURN std_logic_vector IS
    BEGIN
      CASE a IS
        WHEN "00" => RETURN "10";
        WHEN "01" => RETURN "01";
        WHEN "10" => RETURN "00";
        WHEN OTHERS => RETURN "00";
      END CASE;
    END FUNCTION enc;
    
    FUNCTION clzi(
      CONSTANT n : IN natural;
      CONSTANT i : IN std_logic_vector) RETURN std_logic_vector IS
      VARIABLE v : std_logic_vector(i'length-1 DOWNTO 0):=i;  
    BEGIN
      IF v(n-1+n)='0' THEN
        RETURN (v(n-1+n) AND v(n-1)) & '0' & v(2*n-2 DOWNTO n);
      ELSE
        RETURN (v(n-1+n) AND v(n-1)) & NOT v(n-1) & v(n-2 DOWNTO 0);
      END IF;
    END FUNCTION clzi;
    
    FUNCTION clz64 (CONSTANT v : std_logic_vector(0 TO 63)) RETURN std_logic_vector IS
      VARIABLE e : std_logic_vector(0 TO 63);     -- 64
      VARIABLE a : std_logic_vector(0 TO 16*3-1); -- 48
      VARIABLE b : std_logic_vector(0 TO 8*4-1);  -- 32
      VARIABLE c : std_logic_vector(0 TO 4*5-1);  -- 20
      VARIABLE d : std_logic_vector(0 TO 2*6-1);  -- 12
    BEGIN
      FOR i IN 0 TO 31 LOOP e(i*2 TO i*2+1):=enc(v(i*2 TO i*2+1));  END LOOP;
      FOR i IN 0 TO 15 LOOP a(i*3 TO i*3+2):=clzi(2,e(i*4 TO i*4+3)); END   LOOP;
      FOR i IN 0 TO 7  LOOP b(i*4 TO i*4+3):=clzi(3,a(i*6 TO i*6+5)); END   LOOP;
     FOR i IN 0 TO 3  LOOP c(i*5 TO i*5+4):=clzi(4,b(i*8 TO i*8+7)); END LOOP;
     FOR i IN 0 TO 1  LOOP d(i*6 TO i*6+5):=clzi(5,c(i*10 TO i*10+9)); END LOOP;
     RETURN clzi(6,d(0 TO 11));
    END FUNCTION clz64;

    function reverse_any_vector (a: in std_logic_vector)
    return std_logic_vector is
    variable result: std_logic_vector(a'RANGE);
    alias aa: std_logic_vector(a'REVERSE_RANGE) is a;
    begin
    for i in aa'RANGE loop
        result(i) := aa(i);
    end loop;
    return result;
    end; -- function reverse_any_vector


end fpupack;
