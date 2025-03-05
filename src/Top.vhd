----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/26/2024 03:47:06 PM
-- Design Name: 
-- Module Name: Top - Behavioral
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

entity Top is
    port ( rst_i : in STD_LOGIC;
           clk_i : in STD_LOGIC;
           en_i : in STD_LOGIC;
           r_i : in STD_LOGIC_VECTOR (3 downto 0);
           g_i : in STD_LOGIC_VECTOR (3 downto 0);
           b_i : in STD_LOGIC_VECTOR (3 downto 0);
           hs_o : out STD_LOGIC;
           vs_o : out STD_LOGIC;
           r_o : out STD_LOGIC_VECTOR (3 downto 0);
           g_o : out STD_LOGIC_VECTOR (3 downto 0);
           b_o : out STD_LOGIC_VECTOR (3 downto 0));
end Top;

architecture Behavioral of Top is
    component VGAController is
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
    end component;
    component FrequencyDivider is
        generic ( DIVFACTOR : positive );
        port ( clk_i : in STD_LOGIC;
               rst_i : in STD_LOGIC;
               en_i : in STD_LOGIC;
               freq_o : out STD_LOGIC);
    end component;
    
    constant CS : positive := 4;
    constant VSP : positive := 521;
    constant VDT : positive := 480;
    constant VPW : positive := 2;
    constant VFP : positive := 10;
    constant VBP : positive := 29;
    constant HSP : positive := 800;
    constant HDT : positive := 640;
    constant HPW : positive := 96;
    constant HFP : positive := 16;
    constant HBP : positive := 48;
    
    signal vga_en : std_logic;
begin

    fq : FrequencyDivider
    generic map ( DIVFACTOR => 4 )
    port map ( clk_i => clk_i, rst_i => rst_i, en_i => en_i, freq_o => vga_en );
    vga : VGAController
    generic map ( COLOR_SIZE     => CS,
                  V_SYNC_PULSE   => VSP,
                  V_DISPLAY_TIME => VDT,
                  V_PULSE_WIDTH  => VPW,
                  V_FRONT_PORCH  => VFP,
                  V_BACK_PORCH   => VBP,
                  H_SYNC_PULSE   => HSP,
                  H_DISPLAY_TIME => HDT,
                  H_PULSE_WIDTH  => HPW,
                  H_FRONT_PORCH  => HFP,
                  H_BACK_PORCH   => HBP )
    port map ( rst_i => rst_i,
               clk_i => clk_i,
               en_i  => vga_en,
               R_i   => r_i,
               G_i   => g_i,
               B_i   => b_i,
               hs_o  => hs_o,
               vs_o  => vs_o,
               R_o   => r_o,
               G_o   => g_o,
               B_o   => b_o );

end Behavioral;
