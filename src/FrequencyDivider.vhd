----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/25/2024 10:38:51 PM
-- Design Name: 
-- Module Name: FrequencyDivider - Behavioral
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

entity FrequencyDivider is
    generic ( DIVFACTOR : positive );
    port ( clk_i : in STD_LOGIC;
           rst_i : in STD_LOGIC;
           en_i : in STD_LOGIC;
           freq_o : out STD_LOGIC);
end FrequencyDivider;

architecture Behavioral of FrequencyDivider is
    signal counter : positive range 1 to DIVFACTOR; 
begin

    process (rst_i, clk_i, en_i)
    begin
        if rst_i = '1' then
            counter <= 1;
            freq_o <= '0';
        elsif rising_edge(clk_i) and en_i = '1' then
            if counter = DIVFACTOR then
                counter <= 1;
                freq_o <= '1';
            else
                counter <= counter + 1;
                freq_o <= '0';
            end if;
        end if;
    end process;

end Behavioral;
