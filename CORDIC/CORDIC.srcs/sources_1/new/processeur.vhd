library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity processeur is
    port(clk, reset, go: in std_logic;
         teta: in std_logic_vector (15 downto 0);
         cos: out std_logic_vector (15 downto 0));
end entity;

architecture behavioral of processeur is

component CU
    Port (clk, reset, go, cz, msb: in std_logic;
          init, ld, ic, np, sh, k, fin: out std_logic);
end component;

component DP
    Port (clk, reset, go, init, ld, ic, np, sh, k, fin: in std_logic;
          teta: in std_logic_vector (15 downto 0);
          cz, msb: out std_logic;
          cos, sin:out std_logic_vector (15 downto 0));
end component;

signal cz, msb, init, ld, ic, np, sh, k, fin: std_logic;
signal sin: std_logic_vector(15 downto 0);

begin

command_unit: CU port map(clk, reset, go ,cz, msb, init, ld, ic, np, sh, k, fin);
data_path: DP port map(clk, reset, go, init, ld, ic, np, sh, k, fin, teta, cz, msb, cos, sin);

end architecture;
