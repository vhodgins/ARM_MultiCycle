----------------------------------------------------------------------------------
-- Company: 	   Binghamton University
-- Engineer: 	   Carl Betcher
-- 
-- Create Date:    22:20:32 11/16/2016 
-- Design Name:	   ARM Processor Decoder 
-- Module Name:    Decoder - Behavioral 
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
--use IEEE.NUMERIC_STD.ALL;

entity Decoder is
    Port ( --inputs
    	   clk : in STD_LOGIC; --clock(duh)
    	   Op : in  STD_LOGIC_VECTOR (1 downto 0); --instr(27 downto 26)
           Funct : in  STD_LOGIC_VECTOR (5 downto 0); --instr(25 downto 20)
           Rd : in  STD_LOGIC_VECTOR (3 downto 0); --Rd
           en_arm : in STD_Logic; 
           
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
           decode_state : out std_logic; 
           --not from FSM
           ImmSrc : out  STD_LOGIC_VECTOR (1 downto 0);
           RegSrc : out  STD_LOGIC_VECTOR (1 downto 0);
           ALUControl : out  STD_LOGIC_VECTOR (3 downto 0));
end Decoder;

architecture Behavioral of Decoder is

	alias cmd : std_logic_vector(3 downto 0) 
								   is Funct(4 downto 1); -- Instruction Command
														 -- ADD: cmd="0100"
														 -- SUB: cmd="0010"
	alias I   : std_logic is Funct(5); -- I-bit = '0' --> Src2 is a register
									   --       = '1' --> Src2 is an immediate
	alias S   : std_logic is Funct(0); -- S-bit = '1' --> set condition flags
	
	signal MainDecOp : std_logic_vector(3 downto 0);
	signal Controls  : std_logic_vector(9 downto 0);
	
	signal ALUDecOp : std_logic_vector(5 downto 0);

	signal RegWsig : std_logic;
	signal Branch : std_logic;
	signal ALUOp : std_logic;
	signal RegW_block : std_logic;	
	
	--FSM init
	type state_type is (FetchState, DecodeState, MemAdrState, MemReadState, MemWBState, MemWriteState, ExecuteRState, ExecuteIState, ALUWBState, BranchState);
    signal state : state_type := FetchState;
    signal next_state : state_type;
    

begin

	-- PC LOGIC
	-- PCS = 1 if PC is written by an instruction or branch (B)
	PCS <= '1' when (Rd = x"F" and RegWsig = '1') or Branch = '1' else '0';
	
	-- MAIN DECODER
	MainDecOp <= Op & Funct(5) & Funct(0);
	
	with MainDecOp select
	Controls <= "0000001001" when "0000" | "0001",  -- DP Reg
				"0001001001" when "0010" | "0011",  -- DP Imm
				"0011010100" when "0100" | "0110",  -- STR
				"0101011000" when "0101" | "0111",  -- LDR
				"1001100010" when others;			-- B
	
	--Branch <= Controls(9);				-- Branch Instruction
	--MemtoReg <= Controls(8);			-- LDR, Data Mem to RF
	--MemW <= Controls(7);				-- STR, Data Mem WE
	--ALUSrc <= Controls(6);				-- ExtImm to ALU SrcB
	ImmSrc <= Controls(5 downto 4);     -- Extend control
	--RegWsig <= Controls(3);				-- To Condition Logic
	RegSrc <= Controls(2 downto 1);     -- RegSrc(0): RA1 Source
										-- RegSrc(1): RA2 Source
	--ALUOp <= Controls(0);				-- DP Instruction
	
	RegW <= RegWsig and RegW_block ; -- RegW output
    
    

	-- ALU DECODER
	ALUDecOp <= ALUOp & Funct(4 downto 1) & Funct(0);
	
	-- ALUControl sets the operation to be performed by ALU
	with ALUDecOp select
	ALUControl <=   "0000" when "101000" | "101001",  -- ADD
					"0001" when "100100" | "100101",  -- SUB
					"0010" when "100000" | "100001",  -- AND
					"0011" when "111000" | "111001",  -- ORR
					"0100" when "100010" | "100011",  -- EOR  - Done 
					"0101" when "110101" | "110100",  -- CMP  - Done
					"0110" when "111101" | "111100",  -- BIC  - Done
					"0111" when "111011" | "111010",  -- MOV  - Done I think, imm8 idk about 
					"1000" when "111111" | "111110",  -- MVN  - Done ^^ 
					"0000" when others;               -- Not DP

	-- FlagW: Flag Write Signal
	-- Asserted when ALUFlags should be saved
	-- FlagW(0) = '1' --> save NZ flags (ALUFlags(3:2))
	-- FlagW(1) = '1' --> save CV flags (ALUFlags(1:0))
	with ALUDecOp select								
	FlagW <=  "00" when "101000",  -- ADD     
			  "11" when "101001",  -- ADD     
			  "00" when "100100",  -- SUB     
			  "11" when "100101",  -- SUB
			  "00" when "100000",  -- AND
			  "10" when "100001",  -- AND
			  "00" when "111000",  -- ORR
			  "10" when "111001",  -- ORR
			  "00" when "100010",  -- EOR
			  "10" when "100011",  -- EOR 
			  "11" when "110101",  -- CMP 
			  "11" when "110100",  -- CMP 
			  "00" when "111101",  -- BIC 
			  "10" when "111100",  -- BIC
			  "00" when "111011",  -- MOV 
			  "11" when "111010",  -- MOV 
			  "00" when "111111",  -- MVN 
			  "11" when "111110",  -- MVN 
			  "00" when others;    -- Not DP
			  
	--FSM (not in the controller)
	process (clk)
	begin
		if rising_edge(clk) then
			state <= next_state;
		end if;
	end process;
	
	process (clk)
	begin
		AdrSrc <= '0';
		AluSrcA <= '0';
		ALUSrcB <= "00";
		ALUOp <= '0';
		ResultSrc <= "00";
		next_state <= state;
		IRWrite <= '0';
		NextPC <= '0';
		RegWsig <= '0';
		MemW <= '0';
		Branch <= '0';
		RegW_block <= '1';
		decode_state <= '0';
		
		case state is			
			when fetchState =>
				IRWrite <= '1';
				NextPC <= '1';
				AdrSrc <= '0';
				AluSrcA <= '1';
				ALUSrcB <= "10";
				ALUOp <= '0';
				ResultSrc <= "10";
				
				next_state <= DecodeState;				
			when DecodeState =>
			 decode_state <= '1'; 
				ALUSrcA <= '1';
				ALUSrcB <= "10";
				ALUOp <= '0';
				ResultSrc <= "10";
				NextPC <= '0';
				if en_arm='0' then next_state<=Decodestate ;
				elsif Op = "01" then
					next_state <= MemAdrState;
				elsif Op = "10" then
					next_state <= BranchState;
				elsif Op = "00" then
					if funct(5) = '0' then
						next_state <= ExecuteRState;
					else
						next_state <= ExecuteIState;
					end if;					
				end if;
			when MemAdrState =>
				ALUSrcA <= '0';
				ALUSrcB <= "01";
				ALUOp <= '0';
			
				if funct(0) = '1' then
					next_state <= MemReadState;
				else
					next_state <= MemWriteState;
				end if;
			when MemReadState =>
				ResultSrc <= "00";
				AdrSrc <= '1';
				
				next_state <= MemWBState;
			when MemWBState =>
				ResultSrc <= "01";
				RegWsig <= '1';
				
				next_state <= FetchState;
			when MemWriteState =>
				ResultSrc <= "00";
				AdrSrc <= '1';
				MemW <= '1';
				
				next_state <= FetchState;
			when ExecuteRState =>
				ALUSrcA <= '0';
				ALUSrcB <= "00";
				ALUOp <= '1';
				
				next_state <= ALUWBState;
			when ExecuteIState =>
				ALUSrcA <= '0';
				ALUSrcB <= "01";
				ALUOp <= '1';
				
				next_state <= ALUWBState;
			when ALUWBState =>
				ResultSrc <= "00";
				if (ALUDecOp="110101" or ALUDecOp="110100") then 
				    RegW_block <='0'; 
				else 
				    RegW_block <= '1';
				end if; 
				RegWsig <= '1';
			
				next_state <= FetchState;
			when BranchState =>
				ALUSrcA <= '0';
				ALUSrcB <= "01";
				ALUOp <= '0';
				ResultSrc <= "10";
				Branch <= '1';
				
				next_state <= FetchState;
		end case;
	end process;

end Behavioral;

