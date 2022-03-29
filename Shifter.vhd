----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/06/2021 10:54:02 AM
-- Design Name: 
-- Module Name: Shifter - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Shifter is
    Port ( DI : in STD_LOGIC_VECTOR (31 downto 0);
           shamt : in STD_LOGIC_VECTOR (4 downto 0);
           shtyp : in STD_LOGIC_VECTOR (1 downto 0);
           DO : out STD_LOGIC_VECTOR (31 downto 0);
           CO : out STD_LOGIC);
end Shifter;

architecture Behavioral of Shifter is

	--constant shamt : natural := to_integer(unsigned(shamt5));
	--constant rot : natural := to_integer(unsigned(shamt5(5 downto 1)));
	
	signal sh16,sh8,sh4,sh2,sh1 : std_logic_vector(31 downto 0) := (others=>'0');
	signal CO16, CO8, CO4, CO2, CO1 : std_logic := '0';
	
begin
	
    CO16 <= '1' when (not ((DI(31 downto 16) = x"0000") and shamt(4) = '1')) else '0';
    CO8  <= '1' when (not ((DI(31 downto 24) = x"00") and shamt(3) = '1')) else '0';
    CO4  <= '1' when (not ((DI(31 downto 27) = x"0") and shamt(2) = '1')) else '0';
    CO2  <= '1' when (not ((DI(31 downto 30) = "00") and shamt(1) = '1')) else '0';
    CO1  <= '1' when (not ((DI(31) = '0') and shamt(0) = '1')) else '0';
    CO   <= '0' when not (shtyp = "00") else (CO16 or CO8 or CO4 or CO2 or CO1);


	--CO <= '0';--CO16 or CO8 or CO4 or CO2 or CO1;
	
	
	sh16 <= DI when shamt(4) = '0' else DI(15 downto 0) & x"0000" when (shtyp = "00" and shamt(4) = '1') else 
			x"0000" & DI(31 downto 16) when ((shtyp = "01" or (shtyp = "10" and DI(31) = '0')) and shamt(4) = '1') else
			x"1111" & DI(31 downto 16) when (shtyp = "10" and DI(31) = '1' and shamt(4) = '1') else
			DI(15 downto 0) & DI(31 downto 16) when (shtyp = "11" and shamt(4) = '1') else DI;
	sh8  <= sh16 when shamt(3) = '0' else sh16(23 downto 0) & x"00" when (shtyp = "00" and shamt(3) = '1') else
			x"00" & sh16(31 downto 8) when ((shtyp = "01" or (shtyp = "10" and DI(31) = '0')) and shamt(3) = '1') else
			x"11" & sh16(31 downto 8) when ((shtyp = "10" and DI(31) = '1') and shamt(3) = '1') else
			sh16(7 downto 0) & sh16(31 downto 8) when (shtyp = "11" and shamt(3) = '1') else sh16;
	sh4  <= sh8 when shamt(2) = '0' else sh8(27 downto 0) & x"0" when (shtyp = "00" and shamt(2) = '1') else
			x"0" & sh8(31 downto 4) when ((shtyp = "01" or (shtyp = "10" and DI(31) = '0')) and shamt(2) = '1') else
			x"1" & sh8(31 downto 4) when (shtyp = "10" and DI(31) = '1' and shamt(2) = '1') else
			sh8(3 downto 0) & sh8(31 downto 4) when (shtyp = "11" and shamt(2) = '1') else sh8;
	sh2  <= sh4 when shamt(1) = '0' else sh4(29 downto 0) & "00" when (shtyp = "00" and shamt(1) = '1') else
			"00" & sh4(31 downto 2) when ((shtyp = "01" or (shtyp = "10" and DI(31) = '0')) and shamt(1) = '1') else
			"11" & sh4(31 downto 2) when (shtyp = "10" and DI(31) = '1' and shamt(1) = '1') else
			sh4(1 downto 0) & sh4(31 downto 2) when (shtyp = "11" and shamt(1) = '1') else sh4;
	sh1  <= sh2 when shamt(0) = '0' else sh2(30 downto 0) & '0' when (shtyp = "00" and shamt(0) = '1') else
			'0' & sh2(31 downto 1) when ((shtyp = "01" or (shtyp = "10" and DI(31) = '0')) and shamt(0) = '1') else
			'1' & sh2(31 downto 1) when (shtyp = "10" and DI(31) = '1' and shamt(0) = '1') else
			sh2(0) & sh2(31 downto 1) when (shtyp = "11" and shamt(0) = '1') else sh2;
			
	DO <= DI when shamt = "00000" else sh1;
	
end Behavioral;
