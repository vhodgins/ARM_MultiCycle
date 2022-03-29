----------------------------------------------------------------------------------
-- Company: 	   Binghamton University
-- Engineer(s):    Carl Betcher
-- 
-- Create Date:    23:13:36 11/13/2016 
-- Design Name: 
-- Module Name:    Controller - Behavioral 
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

entity controller is -- single cycle control decoder
  port(clk, reset:        in  STD_LOGIC;
        en_arm :            in STD_LOGIC;
       Instr:             in  STD_LOGIC_VECTOR(31 downto 12);
       ALUFlags:          in  STD_LOGIC_VECTOR(3 downto 0);
       RegSrc:            out STD_LOGIC_VECTOR(1 downto 0);
       RegWrite:          out STD_LOGIC;
       ImmSrc:            out STD_LOGIC_VECTOR(1 downto 0);
       --ALUSrc:            out STD_LOGIC;
       ALUControl:        out STD_LOGIC_VECTOR(3 downto 0);
       MemWrite:          out STD_LOGIC;
       --MemtoReg:          out STD_LOGIC;
       --PCSrc:             out STD_LOGIC;
       AdrSrc:            out STD_LOGIC;
       ALUSrcA, PCWrite, IRWrite : out STD_LOGIC;
       ResultSrc, ALUSrcB : out STD_LOGIC_VECTOR (1 downto 0);
       decode_state : out STD_LOGIC);
end;
architecture Behavioral of Controller is

	COMPONENT Decoder is
    Port ( --inputs
    	   clk : in STD_LOGIC; --clock(duh)
    	   Op : in  STD_LOGIC_VECTOR (1 downto 0); --instr(27 downto 26)
           Funct : in  STD_LOGIC_VECTOR (5 downto 0); --instr(25 downto 20)
           Rd : in  STD_LOGIC_VECTOR (3 downto 0); --Rd
           en_arm : in STD_LOGIC;
           
           --to Cond Logic
           --from FSM
           NextPC : out STD_LOGIC;
           RegW : out  STD_LOGIC;
           MemW : out  STD_LOGIC;
           --not from fsm
           FlagW : out  STD_LOGIC_VECTOR (1 downto 0);
           PCS : out  STD_LOGIC;
           
           --to DP
           --from FSM
           ALUSrcA : out  STD_LOGIC;
           ALUSrcB : out STD_LOGIC_VECTOR (1 downto 0);
           IRWrite : out STD_LOGIC;
           ADRSrc  : out STD_LOGIC;
           ResultSrc : out STD_LOGIC_VECTOR (1 downto 0);
           decode_state : out STD_LOGIC;
           --not from FSM
           ImmSrc : out  STD_LOGIC_VECTOR (1 downto 0);
           RegSrc : out  STD_LOGIC_VECTOR (1 downto 0);
           ALUControl : out  STD_LOGIC_VECTOR (3 downto 0));
	end COMPONENT;

	COMPONENT Cond_Logic
	PORT(
		clk : std_logic;
		reset : std_logic;
		Cond : IN std_logic_vector(3 downto 0);
		ALUFlags : IN std_logic_vector(3 downto 0);
		FlagW : IN std_logic_vector(1 downto 0);
		PCS : IN std_logic;
		NextPC : IN std_logic;
		RegW : IN std_logic;
		MemW : IN std_logic;          
		PCWrite : OUT std_logic;
		RegWrite : OUT std_logic;
		MemWrite : OUT std_logic
		);
	END COMPONENT;
	
	signal FlagW : std_logic_vector(1 downto 0);
	signal PCS  : std_logic;
	signal RegW : std_logic;
	signal MemW : std_logic;
	signal NextPC : std_logic;
	--signal IRWrite : std_logic;
	
--	type state_type is (Fetch, Decode, MemAdr, MemRead, MemWB, MemWriteState, ExecuteR, ExecuteI, ALUWB, Branch);
--    signal state : state_type := Fetch;
--    signal next_state : state_type;

begin

	-- Instantiate the Decoder Function of the Controller
	i_Decoder: Decoder PORT MAP(
	    en_arm => en_arm,
	    decode_state => decode_state,
		clk => clk,
		Op => Instr(27 downto 26),
		Funct => Instr(25 downto 20),
		Rd => Instr(15 downto 12),
		FlagW => FlagW,
		PCS => PCS,
		NextPC => NextPC,
		IRWrite => IRWrite,
		AdrSrc => AdrSrc,
		ResultSrc => ResultSrc,
		ALUSrcA => ALUSrcA,
		ALUSrcB => ALUSrcB,
		RegW => RegW,
		MemW => MemW,
		ImmSrc => ImmSrc,
		RegSrc => RegSrc,
		ALUControl => ALUControl 
	);

	-- Instantiate the Conditional Logic Function of the Controller
	i_Cond_Logic: Cond_Logic PORT MAP(
		clk => clk,
		reset => reset,
		Cond => Instr(31 downto 28),
		ALUFlags => ALUFlags,
		FlagW => FlagW,
		PCS => PCS,
		RegW => RegW,
		MemW => MemW,
		PCWrite => PCWrite,
		RegWrite => RegWrite,
		MemWrite => MemWrite,
		NextPC => NextPC 
	);

end Behavioral;

