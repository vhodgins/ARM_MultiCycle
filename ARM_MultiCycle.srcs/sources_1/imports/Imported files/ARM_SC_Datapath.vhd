----------------------------------------------------------------------------------
-- Company: 	   Binghamton University
-- Engineer(s):    Carl Betcher
-- 
-- Create Date:    23:13:36 11/13/2016 
-- Design Name:    ARM Processor Datapath
-- Module Name:    Datapath - Behavioral 
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

entity datapath is  
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
       );
end datapath;

architecture Behavioral of Datapath is

    COMPONENT Memory 
    GENERIC ( data_width : positive := 32; addr_width : positive := 9);
    PORT( 
         clk : in STD_LOGIC;
         WE  : in STD_LOGIC;
         A   : in  STD_LOGIC_VECTOR (addr_width-1 downto 0);
         WD  : in std_logic_vector (data_width-1 downto 0);
         RD  : out  STD_LOGIC_VECTOR (data_width-1 downto 0));
    END COMPONENT;
 
 	
	COMPONENT Register_File
	GENERIC (data_size : natural := 32;
			 addr_size : natural := 4 );
	PORT(
		clk : IN std_logic;
		WE3 : IN std_logic;
		A1  : IN std_logic_vector(3 downto 0);
		A2  : IN std_logic_vector(3 downto 0);
		A3  : IN std_logic_vector(3 downto 0);
		WD3 : IN std_logic_vector(31 downto 0);
		R15 : IN std_logic_vector(31 downto 0);          
		RD1 : OUT std_logic_vector(31 downto 0);
		RD2 : OUT std_logic_vector(31 downto 0)
		);
	END COMPONENT;
	
	COMPONENT Shifter 
	PORT( 
	DI : in STD_LOGIC_VECTOR (31 downto 0);
    Shamt : in STD_LOGIC_VECTOR (4 downto 0);
    Shtyp : in STD_LOGIC_VECTOR (1 downto 0);
    DO : out STD_LOGIC_VECTOR (31 downto 0);
    CO : out STD_LOGIC);
    END component ;
	
	

	COMPONENT ALU
	PORT(
		A : IN std_logic_vector(31 downto 0);
		B : IN std_logic_vector(31 downto 0);
		sh_CO : IN std_logic;
		ALUControl : IN std_logic_vector(3 downto 0);          
		Result : OUT std_logic_vector(31 downto 0);
		ALUFlags : OUT std_logic_vector(3 downto 0)
		);
	END COMPONENT;

	signal InstrSig        : std_logic_vector(31 downto 0);
	--signal PCmux           : std_logic_vector(31 downto 0);
	signal PCsig           : std_logic_vector(31 downto 0):= (others => '0');
	--signal PCplus4         : unsigned(31 downto 0);
	--signal PCplus8         : std_logic_vector(31 downto 0);
	signal ExtImm          : std_logic_vector(31 downto 0);
	signal sh_DO           : std_logic_vector(31 downto 0):= (others=>'0');
	signal ShiftedImm24    : signed(31 downto 0);
	signal RA1mux          : std_logic_vector(3 downto 0);
	signal RA2mux          : std_logic_vector(3 downto 0);
	signal SrcA            : std_logic_vector(31 downto 0):= (others=>'0');
	signal SrcB            : std_logic_vector(31 downto 0):= (others=>'0');
	signal ALUResultSig    : std_logic_vector(31 downto 0):= (others=>'0');
	signal ReadDataSig     : std_logic_vector(31 downto 0):= (others=>'0');
	signal WriteDataSig    : std_logic_vector(31 downto 0):= (others=>'0');
	signal Result          : std_logic_vector(31 downto 0):= (others=>'0');	
	
	signal RF_WE3          : std_logic;
	
	signal AdrSig          : std_logic_vector(addr_width-1 downto 0):= (others=>'0');
	signal A               : std_logic_vector(data_width-1 downto 0):= (others=>'0');
	signal Data            : std_logic_vector(data_width-1 downto 0):= (others=>'0'); 
	signal ALUOut          : std_logic_vector(data_width-1 downto 0):= (others=>'0');
	signal RD1             : std_logic_vector(data_width-1 downto 0):= (others=>'0'); 
	signal RD2             : std_logic_vector(data_width-1 downto 0):= (others=>'0'); 
	signal sh_CO           : std_logic := '0';
	signal sh_shtyp        : std_logic_vector(1 downto 0):= (others=>'0');
	signal sh_shamt5       : std_logic_vector(4 downto 0) := (others=>'0');
	signal sh_DI           :std_logic_vector (31 downto 0) := (others=>'0');

begin

-- Write enable for Register File is gated by en_ARM
	RF_WE3 <= RegWrite and en_ARM;
	
-- Output Signals			 
	ReadData <= ReadDataSig(7 downto 0); 		 									      
	PC <= PCsig;
	ALUResult <= ALUResultSig;
	Instr <= InstrSig; 
	-- Last Output Comes out of ALU 
    

 -- Muxs
            -- Mux 1
            AdrSig <= std_logic_vector(resize(unsigned(SWITCH), Adrsig'length))
                 when en_ARM='0' and reset='0' and decode_state ='1' else 
            PCsig(addr_width+1 downto 2) when ADRSrc='0' else Result(addr_width-1 downto 0); 
            -- Mux 2 
            RA1mux <= InstrSig(19 downto 16) when RegSrc(0) = '0' else x"F";
            -- Mux 3
            RA2mux <= InstrSig(3 downto 0) when RegSrc(1) = '0' else InstrSig(15 downto 12);
            -- Mux 4 
            SrcA <= PCsig when ALUSrcA='1' else A; 
            -- Mux 5 
            SrcB <= sh_DO when ALUSrcB="00" or ALUSrcB = "01" else x"00000004"; 
            -- Mux 6 
            Result <= ALUOut when ResultSrc="00" else Data when ResultSrc="01" else ALUResultSig; 
            -- Mux 9 
            sh_shtyp <= InstrSig(6 downto 5) when ALUSrcB="00" else "11";
            -- Mux 10 
            sh_shamt5 <= "00000" when Instrsig(27 downto 26)="01" or Instrsig(27 downto 26)="10" 
             else InstrSig(11 downto 8) &'0' when ALUSrcB="00" else Instrsig(11 downto 7) when ALUSrcB = "01" else "00000"; 
            --Mux 11
            sh_DI <= ExtImm when ALUSrcB ="01" else WriteDataSig;

            
 -- End Muxs 
 
 
  
  
 -- Registers  
            -- Register Writes 1-5
            process(clk)
            begin
            if rising_edge(clk) then 
                -- Register 1
                if reset='1' then  -- PC reset 
                    PCSig <= ( others => '0' );  
                elsif PCWrite='1' and en_ARM='1' then 
                    PCsig <= Result;
                end if; 
                
                -- Register 2 
                if IRWrite='1' then
                    InstrSig <= ReadDataSig; 
                end if; 
                
                -- Register 3 
                Data <= ReadDataSig; 
                
                -- Register 4 
                A <= RD1; 
                WriteDataSig <= RD2;  
                
                -- Register 5 
                ALUOut <= ALUResultSig; 
            end if;
            end process;    
        
            -- Register 6  / Register File Instantiation
            i_Register_File: Register_File PORT MAP(
                clk => clk,
                WE3 => RF_WE3,
                A1 => RA1mux,
                A2 => RA2mux,
                A3 => InstrSig(15 downto 12),
                WD3 => Result,
                R15 => Result,
                RD1 => RD1,
                RD2 => RD2 
            );
        
            -- Register 7 / Instantiate the Instruction / Data Memory 
            i_idmem : Memory
            GENERIC MAP ( data_width => 32, addr_width => 9)
            PORT MAP (
                clk => Clk, 
                WE  => MemWrite, 
                A   => AdrSig, 
                WD  => WriteDataSig,
                RD  => ReadDataSig); 
			 
 -- End Registers	
 
 -- ALU Instantiation
            i_ALU: ALU PORT MAP(
                A => SrcA,
                B => SrcB,
                sh_CO => sh_CO,
                ALUControl => ALUControl,
                Result => ALUResultSig,
                ALUFlags => ALUFlags
            );
 -- END ALU 
 
 
 -- Barrel Shifter 
            i_shifter: Shifter PORT MAP( 
            DI => sh_DI, 
            Shamt => sh_shamt5 , 
            Shtyp =>  sh_shtyp,
            DO => sh_DO ,
            CO => sh_CO           
            );

 -- Immediate Select	
		
	-- 24-bit Immediate Field sign extended and shifted left twice
	ShiftedImm24 <= resize(signed(InstrSig(23 downto 0)),30) & "00";
	
	-- Extend function for Immediate data
	with ImmSrc select
	ExtImm <= std_logic_vector(resize(unsigned(InstrSig(7 downto 0)),ExtImm'length))  when "00",
			  std_logic_vector(resize(unsigned(InstrSig(11 downto 0)),ExtImm'length)) when "01",
			  std_logic_vector(ShiftedImm24) when others;
	
 -- End Immediate Select
	
end Behavioral;

