----------------------------------------------------------------------------------
-- Company: 	   Binghamton University
-- Engineer(s):    Vincent Hodgins & Harold Karpen
-- 
-- Create Date:    23:13:36 11/13/2016 
-- Design Name: 
-- Module Name:    ARM - Behavioral 
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
use IEEE.NUMERIC_STD.ALL;

entity ARM is -- single cycle processor
  generic(IM_addr_width : positive := 9;
          DM_addr_width : positive := 9);
  port(clk, reset, en_ARM : in  STD_LOGIC;
                 Switch   : in STD_LOGIC_VECTOR(7 downto 0);
                 PC       : out STD_LOGIC_VECTOR(7 downto 0);
                 Instr    : out STD_LOGIC_VECTOR(31 downto 0);
                 ReadData : out STD_LOGIC_VECTOR(7 downto 0));
                 --decode_state : out std_logic);
  end ARM;

architecture Behavioral of ARM is

	COMPONENT controller
	PORT(
	       decode_state : out std_logic;
	    en_arm : IN STD_Logic;
		clk : IN std_logic;
		reset : IN std_logic;
		Instr : IN std_logic_vector(31 downto 12);
		ALUFlags : IN std_logic_vector(3 downto 0);          
		RegSrc : OUT std_logic_vector(1 downto 0);
		RegWrite : OUT std_logic;
		ImmSrc : OUT std_logic_vector(1 downto 0);
		--ALUSrc : OUT std_logic;
		ALUControl : OUT std_logic_vector(3 downto 0);
		MemWrite : OUT std_logic;
		--MemtoReg : OUT std_logic;
		--PCSrc : OUT std_logic;
		AdrSrc       : OUT  STD_LOGIC;
		IRWrite    : OUT  STD_LOGIC;
		ALUSrcA, PCWrite : out STD_LOGIC;
        ResultSrc, ALUSrcB : out STD_LOGIC_VECTOR (1 downto 0));
	END COMPONENT;

	COMPONENT datapath is  
  	generic(addr_width : positive := 9; data_width: positive := 32);
  	port(clk, reset, en_ARM : in  STD_LOGIC;
        
        -- Register Enables
        PCWrite     : in STD_LOGIC;
        IRWrite     : in STD_LOGIC;
        RegWrite    : in STD_LOGIC;
        MemWrite    : in STD_LOGIC;
        decode_state : in STD_LOGIC;
        switch : in STD_LOGIC_VECTOR(7 downto 0);
        
        -- Source Selection
        ADRSrc      : in STD_LOGIC;
        ALUSrcA     : in STD_LOGIC; 
        RegSrc      : in STD_LOGIC_VECTOR(1 downto 0);
        ALUSrcB     : in STD_LOGIC_VECTOR(1 downto 0); 
        ResultSrc   : in STD_LOGIC_VECTOR(1 downto 0); 
        ImmSrc      : in STD_LOGIC_VECTOR(1 downto 0);
        
        -- ALU 
        ALUControl  : in STD_LOGIC_VECTOR(3 downto 0); 
        
       -- OutPuts
       
       ALUFlags     : out STD_LOGIC_VECTOR(3 downto 0);
       PC           : out STD_LOGIC_VECTOR(31 downto 0);
       Instr        : out STD_LOGIC_VECTOR(31 downto 0);
       ALUResult    : out STD_LOGIC_VECTOR(31 downto 0); 
       ReadData     : out STD_LOGIC_VECTOR(7 downto 0)
       
         
       -- Single Cycle Signals  
       --RegSrc       : in  STD_LOGIC_VECTOR(1 downto 0);
       --RegWrite     : in  STD_LOGIC;
       --ImmSrc       : in  STD_LOGIC_VECTOR(1 downto 0);
       --ALUSrc       : in  STD_LOGIC;
       --MemtoReg     : in  STD_LOGIC;
       --PCSrc        : in  STD_LOGIC;
       --DM_WE        : in  STD_LOGIC;
       --DM_Addr      : in  STD_LOGIC_VECTOR(DM_addr_width-1 downto 0);
      
       );
	end COMPONENT;

	-- Signals needed to make connections between the datapath and controller
	signal ALUFlags : std_logic_vector(3 downto 0);
	signal RegSrc : std_logic_vector(1 downto 0);
	signal RegWrite : std_logic; 
	signal ImmSrc : std_logic_vector(1 downto 0);
	signal ALUSrc : std_logic;
	signal ALUControl : std_logic_vector(3 downto 0);
	signal MemWrite  : std_logic;
	signal MemtoReg  : std_logic;
	--signal PCSrc : std_logic;
	signal InstrSig : std_logic_vector(31 downto 0);
	signal DM_WE : std_logic;
	signal DM_Addr : std_logic_vector(DM_addr_width-1 downto 0);
	signal DataAddr : std_logic_vector(31 downto 0);
	signal PCsig : std_logic_vector(31 downto 0);
	signal AdrSrc, IRWrite, ALUSrcA, PCWrite : std_logic;
	signal ResultSrc, ALUSrcB : std_logic_vector(1 downto 0);
    signal Decodestatesig : std_logic;

begin

	-- Instantiate the Controller for the ARM Processor
	i_controller: controller PORT MAP(
	   en_arm => en_arm,
		clk => clk,
		decode_state => Decodestatesig ,
		reset => reset,
		Instr => InstrSig(31 downto 12),
		ALUFlags => ALUFlags,
		RegSrc => RegSrc,
		RegWrite => RegWrite,
		ImmSrc => ImmSrc,
		--ALUSrc => ALUSrc,
		ALUControl => ALUControl,
		MemWrite => MemWrite,
		--MemtoReg => MemtoReg,
		AdrSrc => AdrSrc,
		IRWrite => IRWrite,
		ALUSrcA => ALUSrcA,
		ResultSrc => ResultSrc,
		ALUSrcB => ALUSrcB,
		PCWrite => PCWrite
	);

	-- Instantiate the Datapath for the ARM Processor
	i_datapath: datapath PORT MAP(
		clk => clk,
		reset => reset,
		en_ARM => en_ARM,
		decode_state => Decodestatesig,
		switch => switch,
		
		PCWrite => PCWrite,
		MemWrite => MemWrite,
		RegWrite => RegWrite,
		IRWrite => IRWrite,
		
		RegSrc => RegSrc,
		ImmSrc => ImmSrc,
		AdrSrc => AdrSrc,
		ALUSrcA => ALUSrcA,
		ResultSrc => ResultSrc,
		ALUSrcB => ALUSrcB,
		
		ALUControl => ALUControl,
		
		ALUFlags => ALUFlags,
		PC => PCsig,
		Instr => InstrSig,
		ALUResult => DataAddr,
		ReadData => ReadData
	);

    -- Outputs to top level module
    Instr <= InstrSig;
    PC <= PCsig(7 downto 0);

	-- When the ARM is stopped, Switch input is used to address data memory
	-- Data Memory Address
	DM_Addr <= DataAddr(DM_addr_width+1 downto 2) when en_ARM = '1' 
						else std_logic_vector(resize(unsigned(Switch),DM_Addr'length));
	-- Data Memory Write Enable					
	DM_WE <= en_ARM and MemWrite;					

end Behavioral;

