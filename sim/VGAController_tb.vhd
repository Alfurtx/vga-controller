----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/26/2024 01:46:30 PM
-- Design Name: 
-- Module Name: VGAController_tb - Behavioral
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

entity VGAController_tb is
end VGAController_tb;

architecture Behavioral of VGAController_tb is
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
    
    constant PERIOD : time := 10 ns;
    
    signal clk : std_logic := '0';
    signal rst, en, vga_en, hs, vs : std_logic;
    signal ri,gi,bi,ro,go,bo : std_logic_vector (CS-1 downto 0);
begin
    fq : FrequencyDivider
    generic map ( DIVFACTOR => 4 )
    port map ( clk_i => clk, rst_i => rst, en_i => en, freq_o => vga_en );
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
    port map ( rst_i => rst,
               clk_i => clk,
               en_i  => vga_en,
               R_i   => ri,
               G_i   => gi,
               B_i   => bi,
               hs_o  => hs,
               vs_o  => vs,
               R_o   => ro,
               G_o   => go,
               B_o   => bo );

    ri <= (others => '0');
    gi <= (others => '1');
    bi <= (others => '0');
    clk <= not clk after PERIOD / 2;
    
    process
    begin
        rst <= '1';
        en <= '0';
        wait for PERIOD * 4;
        rst <= '0';
        en <= '1';
        wait;
    end process;
end Behavioral;
