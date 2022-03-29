----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Harold Karpen & Vincent Hodgins
-- 
-- Create Date: 11/10/2021 10:26:42 AM
-- Design Name: 
-- Module Name: Test_ARM_SC - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Test_ARM_SC is
end Test_ARM_SC;

architecture Behavioral of Test_ARM_SC is

--Component declaration for UUT
	COMPONENT ARM
	generic(IM_addr_width : positive := 9;
          DM_addr_width : positive := 9);
          port(clk, reset, en_ARM : in  STD_LOGIC;
                 Switch   : in STD_LOGIC_VECTOR(7 downto 0);
                 PC       : out STD_LOGIC_VECTOR(7 downto 0);
                 Instr    : out STD_LOGIC_VECTOR(31 downto 0);
                ReadData : out STD_LOGIC_VECTOR(7 downto 0));
	end COMPONENT;

	--Inputs
	signal clk, reset : std_logic := '0';
	signal en_ARM : std_logic := '1';
	signal Switch : std_logic_vector(7 downto 0) := (others => '0');
	
	--Outputs
	signal PC, ReadData : std_logic_vector(7 downto 0) := (others => '0');
	signal Instr : std_logic_vector(31 downto 0) := (others => '0');

	--clk period
	constant clk_period : time := 10ns;

begin

	--Instantiate UUT
	uut : ARM
		generic map (IM_addr_width => 9,
					 DM_addr_width => 9)
		port map ( clk => clk, reset => reset, en_ARM => en_ARM, Switch => Switch,
			   		 PC => PC, Instr => Instr, ReadData => ReadData);

	--clk process
	clk_process : process
	begin
		wait for clk_period/2;
		clk <= not clk;
	end process;

end Behavioral;
