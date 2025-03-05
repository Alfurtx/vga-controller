----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/25/2024 11:08:38 PM
-- Design Name: 
-- Module Name: VGAController - Behavioral
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

entity VGAController is
    generic ( COLOR_SIZE : positive;
              V_SYNC_PULSE : positive;
              V_DISPLAY_TIME : positive;
              V_PULSE_WIDTH : positive;
              V_FRONT_PORCH : positive;
              V_BACK_PORCH : positive;
              H_SYNC_PULSE : positive;
              H_DISPLAY_TIME : positive;
              H_PULSE_WIDTH : positive;
              H_FRONT_PORCH : positive;
              H_BACK_PORCH : positive );
    port ( rst_i : in STD_LOGIC;
           clk_i : in STD_LOGIC;
           en_i : in STD_LOGIC;
           R_i : in STD_LOGIC_VECTOR (COLOR_SIZE-1 downto 0);
           G_i : in STD_LOGIC_VECTOR (COLOR_SIZE-1 downto 0);
           B_i : in STD_LOGIC_VECTOR (COLOR_SIZE-1 downto 0);
           hs_o : out STD_LOGIC;
           vs_o : out STD_LOGIC;
           R_o : out STD_LOGIC_VECTOR (COLOR_SIZE-1 downto 0);
           G_o : out STD_LOGIC_VECTOR (COLOR_SIZE-1 downto 0);
           B_o : out STD_LOGIC_VECTOR (COLOR_SIZE-1 downto 0));
end VGAController;

architecture Behavioral of VGAController is
    signal h_counter : positive range 1 to H_SYNC_PULSE;
    signal v_counter : positive range 1 to V_SYNC_PULSE;
    signal black : std_logic_vector ( COLOR_SIZE-1 downto 0 );
    signal ven : std_logic;
    signal hdisp : std_logic;
    signal vdisp : std_logic;
begin
    
    hs_o <= '0' when h_counter >= 1 and h_counter <= H_PULSE_WIDTH else '1';
    vs_o <= '0' when v_counter >= 1 and v_counter <= V_PULSE_WIDTH else '1';
    
    hdisp <= '0' when (h_counter >= 1 and h_counter <= H_PULSE_WIDTH + H_BACK_PORCH) or (h_counter > H_DISPLAY_TIME + H_PULSE_WIDTH + H_BACK_PORCH) else '1';  
    vdisp <= '0' when (v_counter >= 1 and v_counter <= V_PULSE_WIDTH + V_BACK_PORCH) or (v_counter > V_DISPLAY_TIME + V_PULSE_WIDTH + V_BACK_PORCH) else '1';
    
    R_o <= R_i when hdisp = '1' and vdisp = '1' else (others => '0');
    G_o <= G_i when hdisp = '1' and vdisp = '1' else (others => '0');
    B_o <= B_i when hdisp = '1' and vdisp = '1' else (others => '0');
    
--    hcount : process(clk_i, rst_i, en_i)
--    begin
--        if rst_i = '1' then
--            h_counter <= 1;
--            ven <= '0';
--        else
--            if rising_edge(clk_i) and en_i = '1' then
--                if h_counter = H_SYNC_PULSE then
--                    h_counter <= 1;
--                    ven <= '1';
--                else
--                    h_counter <= h_counter + 1;
--                    ven <= '0';
--                end if;
--            end if;
--        end if;
--    end process;
    
--    vcount : process(clk_i, rst_i, en_i, ven)
--    begin
--        if rst_i = '1' then
--            v_counter <= 1;
--        else
--            if ven = '1' and rising_edge(clk_i) and en_i = '1' then
--                if v_counter = V_SYNC_PULSE then
--                    v_counter <= 1;
--                else
--                    v_counter <= v_counter + 1;
--                end if;
--            end if;
--        end if;
--    end process;
    
    count : process(clk_i, rst_i, en_i)
    begin
        if rst_i = '1' then
            h_counter <= 1;
            v_counter <= 1;
        else
            if rising_edge(clk_i) and en_i = '1' then
                if h_counter = H_SYNC_PULSE then
                    h_counter <= 1;
                    if v_counter = V_SYNC_PULSE then
                        v_counter <= 1;
                    else
                        v_counter <= v_counter + 1;
                    end if;
                else
                    h_counter <= h_counter + 1;
                end if;
            end if;
        end if;
    end process;

end Behavioral;
