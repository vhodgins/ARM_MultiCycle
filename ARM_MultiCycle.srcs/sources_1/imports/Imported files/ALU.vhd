----------------------------------------------------------------------------------
-- Company: 	   Binghamton University
-- Engineer: 	   
-- 
-- Create Date:     
-- Design Name:	   ARM Processor ALU 
-- Module Name:    ALU - Behavioral 
-- Project Name:   ARM_Processor
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ALU is
	Generic ( data_size : positive := 32 );
    Port ( A, B : in  STD_LOGIC_VECTOR (data_size-1 downto 0);
           sh_CO : in STD_LOGIC; 
		   ALUControl : in STD_LOGIC_VECTOR (3 downto 0);
           Result : out  STD_LOGIC_VECTOR (data_size-1 downto 0);
           ALUFlags : out  STD_LOGIC_VECTOR (3 downto 0));
end ALU;

architecture Behavioral of ALU is

	signal sum_unsigned : unsigned (data_size downto 0);
	signal ALUControl0 : unsigned (data_size downto 0);
	signal sum, ABand, ABor, B_inv, ABXor, ABinvand, Result1 : STD_LOGIC_VECTOR(data_size-1 downto 0);
	signal c_out, N, Z, C, V : STD_LOGIC := '0';
	signal summing : std_logic;
	
begin
	
	B_inv <= not B when ((ALUControl="0001") or (ALUControl="0101") or (ALUControl="0110") or (ALUControl="1000")) else B;
	ALUControl0 <= to_unsigned(0, data_size+1) when (ALUControl(0) = '0') else to_unsigned(1, data_size+1);
	
	ABand <= A and B;
	ABinvand <= A and B_inv;
	ABor <= A or B;
	sum_unsigned <= unsigned('0' & A) + unsigned('0' & B_inv) + ALUControl0;
	c_out <= sum_unsigned(data_size);
	ABxor <= A xor B; 
	sum <= std_logic_vector(sum_unsigned(data_size-1 downto 0));
	
	
	summing <= '1' when ((ALUControl="0000") or (ALUControl = "0001") or (ALUControl="0101")) else '0';
	
	-- Summing replaced ALUControl(1);
	
	Result1 <= 
	    sum when ((ALUControl ="0000") or (ALUControl = "0001") or (ALUControl="0101")) else
		ABand when (ALUControl = "0010") else
		ABinvand when (ALUControl = "0110") else
		ABor when (ALUControl ="0011") else
		ABxor when (ALUControl = "0100") else 
		B when (ALUControl = "0111") else
		B_inv when (ALUControl = "1000")
		;
		
		
	N <= Result1(data_size-1);
	Z <= '1' when (unsigned(Result1) = 0) else '0';
	C <= (not summing and c_out) or sh_CO;
	V <= not summing and (sum(data_size-1) xor A(data_size-1)) and (ALUControl(0) xnor (A(data_size-1) xor (B(data_size-1))));
	
	ALUFlags <= (N,Z,C,V);
	Result <= Result1;
	
end Behavioral;