----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/26/2021 10:48:43 PM
-- Design Name: 
-- Module Name: Memory - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
library std;
use std.textio.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Memory is
  Generic ( data_width : positive := 32; addr_width : positive := 9);
  Port ( clk : in STD_LOGIC; 
         WE  : in STD_LOGIC;
         WD  : in  STD_LOGIC_VECTOR (data_width-1 downto 0);
         A  : in  STD_LOGIC_VECTOR (addr_width-1 downto 0);
         RD : out  STD_LOGIC_VECTOR (data_width-1 downto 0));
end Memory;

architecture Behavioral of Memory is

-- Declare type for the memory
   type instr_ROM_type is array(0 to 2**addr_width-1) 
	     	   of bit_vector(data_width-1 downto 0); 
   
   -- Declare function for reading a file and returning 
   -- a data array of the initial memory contents with the program
   impure function init_ROM (file_name : in string) 
	  return instr_ROM_type is  
          FILE     rom_file    : text open read_mode is file_name;                       
          variable instruction : line;                                 
          variable instr_ROM   : instr_ROM_type;
          variable I           : natural;	
   begin 
      -- Loop for reading each line in the file
	  -- until end of file is reached
	  -- Then, fill in remaining instr_ROMory with zeros
	  I := 0;
	  while not endfile(rom_file) loop
          readline (rom_file, instruction);                             
          read (instruction, instr_ROM(I));
		  I := I + 1;	
      end loop;
	  for J in I to instr_ROM_type'left loop
		  instr_ROM(J) := (others => '0');
	  end loop;
      return instr_ROM;
   end function;                                                

   -- Declare a constant for the instruction array read from the file
   signal Instr_MEM : instr_ROM_type := 
   init_ROM("../../program.txt"); -- Synthesis
   --init_ROM("../../../../program.txt"); -- Simulation

begin

	process (A)    -- Asynchronous Read                                            
	begin                                                        
		RD <= to_STDLogicVector(Instr_MEM(to_integer(unsigned(A))));      
	end process; 
	
	-- Synchronous Write to Data Memory
   process (clk)                                                
   begin
      if rising_edge(clk) then 
         if WE = '1' then
            Instr_Mem(to_integer(unsigned(A))) <= to_bitVector(WD); 
         end if;
      end if;                                                       
   end process; 

end Behavioral;
