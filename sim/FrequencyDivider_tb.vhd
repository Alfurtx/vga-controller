----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/25/2024 10:44:32 PM
-- Design Name: 
-- Module Name: FrequencyDivider_tb - Behavioral
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

entity FrequencyDivider_tb is
end FrequencyDivider_tb;

architecture Behavioral of FrequencyDivider_tb is
    signal clk : std_logic := '0';
    signal rst : std_logic;
    signal en : std_logic;
    signal freq : std_logic;
    
    constant PERIOD : time := 10 ns;
    
    component FrequencyDivider is
        generic ( DIVFACTOR : positive );
        port ( clk_i : in STD_LOGIC;
               rst_i : in STD_LOGIC;
               en_i : in STD_LOGIC;
               freq_o : out STD_LOGIC);
    end component;
begin
    clk <= not clk after PERIOD / 2;
    
    fq : FrequencyDivider
    generic map ( DIVFACTOR => 2)
    port map ( clk_i => clk, rst_i => rst, en_i => en, freq_o => freq);
    
    process
    begin
        rst <= '1';
        wait for PERIOD * 3;
        rst <= '0';
        en <= '0';
        wait for PERIOD * 3;
        en <= '1';
        wait;
    end process;

end Behavioral;
