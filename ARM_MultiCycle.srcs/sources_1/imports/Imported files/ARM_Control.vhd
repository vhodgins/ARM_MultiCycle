----------------------------------------------------------------------------------
-- Company: 	   Binghamton University
-- Engineer: 	   Carl Betcher
-- 
-- Create Date:    20:03:53 11/23/2019 
-- Design Name: 
-- Module Name:    ARM_Control - Behavioral 
-- Project Name:   ARM_SingleCycle Processor
-- Target Devices: 
-- Tool versions: 
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

entity ARM_Control is
	 generic ( DELAY : integer := 640000 -- DELAY = 20 mS / clk_period
				   );								 -- for Simulation, DELAY = 3
    Port ( clk : in  STD_LOGIC;
           stop_reset : in  STD_LOGIC;
           run : in  STD_LOGIC;
           step : in  STD_LOGIC;
           stop_at_BP : in  STD_LOGIC;
           Switch, PC : in STD_LOGIC_VECTOR(7 downto 0);
           reset_out : out  STD_LOGIC;
           en_ARM : out  STD_LOGIC);
end ARM_Control;

architecture Behavioral of ARM_Control is

	COMPONENT debounce
	Generic ( DELAY : integer := 640000 -- DELAY = 20 mS / clk_period
				  );
	PORT(
		clk : IN std_logic;
		sig_in : IN std_logic;          
		sig_out : OUT std_logic
		);
	END COMPONENT;

	-- Signals needed to implement reset, run, stop, stop at breakpoint, 
	-- and single-step functions
	signal run_ARM, stop, bp_stop, bp_mode, reset : std_logic := '0';
	signal run_sync, stop_reset_sync, step_sync, stop_at_bp_sync : std_logic;
	signal stretch_reset : std_logic_vector(3 downto 0) := (others => '0'); 
	signal PC_eq_SWITCH : std_logic;
	
begin

	-- Debounce the "run" signal and synchronize it to the clock
	-- and generate the "run_sync" signal for exactly one clock cycle
	debounce_run: debounce 
	GENERIC MAP(DELAY => DELAY)
	PORT MAP(
		clk => Clk ,
		sig_in => run,
		sig_out => run_sync 
	);

	-- Debounce the "stop_reset" signal and synchronize it to the clock
	-- and generate the "stop_reset_sync" signal for exactly one clock cycle
	debounce_rst: debounce 
	GENERIC MAP(DELAY => DELAY)
	PORT MAP(
		clk => Clk ,
		sig_in => stop_reset,
		sig_out => stop_reset_sync 
	);

	-- Debounce the "step" signal and synchronize it to the clock
	-- and generate the "step_sync" signal for exactly one clock cycle
	debounce_step: debounce 
	GENERIC MAP(DELAY => DELAY)
	PORT MAP(
		clk => Clk ,
		sig_in => step,
		sig_out => step_sync 
	);

	-- Debounce the "stop_at_bp" signal and synchronize it to the clock
	-- and generate the "stop_at_bp_sync" signal for exactly one clock cycle
	debounce_bp: debounce 
	GENERIC MAP(DELAY => DELAY)
	PORT MAP(
		clk => Clk ,
		sig_in => stop_at_bp,
		sig_out => stop_at_bp_sync 
	);

	-- One push button is used to generate both a "stop" signal and a "reset" signal
	--
	-- Generate "stop" signal
	-- Generate the "stop" signal when the ARM processor is running (run_ARM = '1')
	-- and the Stop/Reset button is pressed (stop_reset_sync = '1')
	-- Sync this signal with the clock
	process(Clk)
	begin
		if rising_edge(Clk) then
			if run_ARM = '1' and stop_reset_sync = '1' then
				stop <= '1';
			else
				stop <= '0';
			end if;	
		end if;
	end process;
	--
	-- Generate "reset" signal
	-- Generate the "reset" signal when the ARM processor is not running
	-- (run_ARM = '0') and the Stop/Reset button is pressed (stop_reset_sync = '1')
	-- Sync this signal with the clock
	process(Clk)
	begin
		if rising_edge(Clk) then
			if run_ARM = '0' and stop_reset_sync = '1' then
				stretch_reset <= (others => '1');
			else
				stretch_reset <= '0' & stretch_reset(3 downto 1);
			end if;	
		end if;
	end process;
	
	reset <= stretch_reset(0);
	reset_out <= reset;

	-- The "run_ARM" signal is '1' when we want the ARM processor to be running
	-- When "run_sync" or "stop_at_bp_sync" becomes a '1', "run_ARM" is set to '1' 
	-- and is held at a '1' until a "reset" signal or a "stop" signal or
	-- a "bp_stop" is received
	process(Clk)
	begin
		if rising_edge(Clk) then
			if reset = '1' or stop = '1' or bp_stop = '1' then
				run_ARM <= '0';
			elsif run_sync = '1' or stop_at_bp_sync = '1' then
				run_ARM <= '1';
			end if;	
		end if;
	end process;
	
	-- Breakpoint mode
	-- "bp_mode" is set to '1' when Stop at Breakpoint button is pressed
	-- (stop_at_bp_sync = '1')
	-- and is held at a '1' until a "reset" signal or a "stop" signal or
	-- a "bp_stop" is received
	process(Clk)
	begin
		if rising_edge(Clk) then
			if reset = '1' or stop = '1' or bp_stop = '1' then
				bp_mode <= '0';
			elsif stop_at_bp_sync = '1' then
				bp_mode <= '1';
			end if;	
		end if;
	end process;

	-- Comparator to determine if PC equals value on Switches
	PC_eq_SWITCH <= '1' when PC = SWITCH else '0';

	-- Stop at Breakpoint
	-- "bp_stop" is set to '1' when the value set by the switches matches the PC
	-- It is cleared with reset, or immediately after it is set (run_ARM AND bp_stop)	
	process(Clk)
	begin
		if rising_edge(Clk) then
			if reset = '1' or (run_ARM = '1' AND bp_stop = '1') then
				bp_stop <= '0';
			elsif bp_mode = '1' AND PC_eq_SWITCH = '1' then
				bp_stop <= '1';
			end if;	
		end if;
	end process;	
	
	-- The en_ARM signal enables the ARM Processor to change its architecture state
	-- When en_ARM = '1', the decoder FSM is allowed to leave its decode state and
	--    complete the current instruction
	-- This signal is synchronized to the system clock
	-- When run_ARM is '1', en_ARM is '1'
	-- If run_ARM is '0' and step_sync is '1' for one clock cycle, 
	--    en_ARM will be '1' for one clock cycle, allowing the controller to 
	--    complete the execution of the current instruction.
	process(Clk)
	begin
		if rising_edge(Clk) then
			if run_ARM = '1' or step_sync = '1' then
				en_ARM <= '1';
			else
				en_ARM <= '0';
			end if;	
		end if;
	end process;
		


end Behavioral;

