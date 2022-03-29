----------------------------------------------------------------------------------
-- Company: 	   Binghamton University
-- Engineer(s):    Carl Betcher
-- 
-- Create Date:    23:13:36 11/13/2016 
-- Design Name:    ARM Processor Top Level
-- Module Name:    ARM_TopLevel - Behavioral 
-- Project Name:   ARM_Processor
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revisions: 
--    08/08/2017 - Modified for use with the Papilio Duo
--    10/26/2020 - modified for use with the Basys3 FPGA Board
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity ARM_TopLevel is
	Generic ( DELAY : integer := 640000 -- DELAY = 20 mS / clk_period
				  );								-- for Simulation, DELAY = 3
    Port (  Clk : in STD_LOGIC;
			DIR_Right : in STD_LOGIC; 	
	        DIR_Left : in STD_LOGIC;  
	        DIR_Down : in STD_LOGIC;  
	        DIR_Up : in STD_LOGIC;    
			Switch : in  STD_LOGIC_VECTOR (7 downto 0);
            LED : out  STD_LOGIC_VECTOR (7 downto 0);
			Seg7_SEG : out STD_LOGIC_VECTOR (6 downto 0); 
			Seg7_DP  : out STD_LOGIC; 
			Seg7_AN  : out STD_LOGIC_VECTOR (3 downto 0)
			  );
end ARM_TopLevel;

architecture Behavioral of ARM_TopLevel is

	COMPONENT ARM_Control
	GENERIC ( DELAY : integer := 640000 -- DELAY = 20 mS / clk_period
				  );								-- for Simulation, DELAY = 3
	PORT(
		clk : IN std_logic;
		stop_reset : IN std_logic;
		run : IN std_logic;
		step : IN std_logic;
		stop_at_BP : IN std_logic;          
        Switch, PC : in  STD_LOGIC_VECTOR(7 downto 0);
        reset_out : out  STD_LOGIC;
		en_ARM : OUT std_logic
		);
	END COMPONENT;

	COMPONENT HEXon7segDisp
	PORT(
		hex_data_in0 : in  STD_LOGIC_VECTOR (3 downto 0);
        hex_data_in1 : in  STD_LOGIC_VECTOR (3 downto 0);
        hex_data_in2 : in  STD_LOGIC_VECTOR (3 downto 0);
        hex_data_in3 : in  STD_LOGIC_VECTOR (3 downto 0);
		dp_in : IN std_logic_vector(2 downto 0);
		clk : IN std_logic;          
		seg_out : OUT std_logic_vector(6 downto 0);
        an_out : out  STD_LOGIC_VECTOR (3 downto 0);
		dp_out : OUT std_logic
		);
	END COMPONENT;
	
	component ARM 
	generic(addr_size : positive := 9);
    port(clk, reset, en_ARM   : in  STD_LOGIC;
         Switch               : in  STD_LOGIC_VECTOR(7 downto 0);
		 PC                   : out STD_LOGIC_VECTOR(7 downto 0);
		 Instr                : out STD_LOGIC_VECTOR(31 downto 0);
		 ReadData             : out STD_LOGIC_VECTOR(7 downto 0));
	end component;
	
	-- Constants defining memory address ranges
	constant addr_size : positive := 9;
	
	-- Signal for Hex Display Controller input
	signal HexDisp : std_logic_vector(15 downto 0) := x"0000";

	-- Signals connecting to ARM Processor
	signal Instr: std_logic_vector(31 downto 0);
	signal PC: std_logic_vector(7 downto 0);
	signal ReadData : std_logic_vector(7 downto 0);
	
	-- Signals needed to connect ARM_Control module
	signal stop_reset, run, stop_at_bp, step  : std_logic := '0';
	signal en_ARM, reset  : std_logic := '0';
		
begin
		
	-- Momentary switches used to control the ARM processor
	stop_reset <= DIR_LEFT; 
	run <= DIR_UP;				
	step <= DIR_RIGHT;		
	stop_at_bp <= DIR_DOWN; 
	
	-- Module to control the ARM processor using button inputs
	i_ARM_Control: ARM_Control 
	GENERIC MAP(DELAY => DELAY)
	PORT MAP(
		clk => Clk,
		stop_reset => stop_reset,
		run => run,
		step => step,
		stop_at_BP => stop_at_bp,
		Switch => Switch,
		PC => PC,
		reset_out => reset,
		en_ARM => en_ARM
	);

	-- Instantiate the ARM processor
	i_arm: ARM 
	generic map( addr_size => addr_size)
	port map(clk => Clk, 
	         reset => reset, 
	         en_ARM => en_ARM, 
	         Switch => Switch,
	         PC => PC,  
			 Instr => Instr, 
			 ReadData => ReadData);
	
	-- When program is stopped (en_ARM = '0'), 
	-- the program counter, PC(7 downto 0) is displayed 
	-- on the left two characters of the 7-segment display.
	-- Switch(7 downto 0) is the data memory word address, A(7 downto 0).
	-- The data in the addressed data memory location appears on ReadData(7 downto 0)  
	-- and is displayed on the right two characters of the 7-segment display 
    HexDisp <= PC(7 downto 0) & ReadData(7 downto 0);
	
	-- Instantiate Hex to 7-segment controller module
	i_HEXon7segDisp: HEXon7segDisp PORT MAP(
		hex_data_in0 => HexDisp(3 downto 0),
		hex_data_in1 => HexDisp(7 downto 4),
		hex_data_in2 => HexDisp(11 downto 8),
		hex_data_in3 => HexDisp(15 downto 12),
		dp_in => "000",  -- no decimal point
		seg_out => Seg7_SEG,
		an_out => Seg7_AN(3 downto 0),
		dp_out => Seg7_DP,
		clk => Clk
	);
	
	-- Instr (27 downto 20) is displayed on LED(7 downto 0)
	LED(7 downto 0) <= Instr(27 downto 20);	
	
end Behavioral;
