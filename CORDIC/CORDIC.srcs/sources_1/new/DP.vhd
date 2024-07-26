library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_SIGNED.ALL ;

entity DP is
    Port (clk, reset, go, init, ld, ic, np, sh, k, fin: in std_logic;
          teta: in std_logic_vector (15 downto 0);
          cz, msb: out std_logic;
          cos, sin:out std_logic_vector (15 downto 0));
end DP;

architecture Behavioral of DP is

signal tmpx, tmpy, tmpz, tx, ty, tz, sx, sy: std_logic_vector (15 downto 0);
signal Qs: natural range 0 to 9 := 0;
type my_array is array (0 to 9) of std_logic_vector(15 downto 0);
signal Dteta: my_array;

begin

Dteta(0) <= "0011001000111101";
Dteta(1) <= "0001110110101011";
Dteta(2) <= "0000111110101100";
Dteta(3) <= "0000011111110100";
Dteta(4) <= "0000001111111110";
Dteta(5) <= "0000001000001101";
Dteta(6) <= "0000000011111111";
Dteta(7) <= "0000000001111111";
Dteta(8) <= "0000000000111111";
Dteta(9) <= "0000000000100000";


--regitre x
process(clk)
variable x: std_logic_vector (15 downto 0);
begin
if rising_edge(clk) then
    if reset = '0' then x := (others => '0');
    elsif init = '1' then x := "0010011011011001";
    elsif ld = '1' then
        if np = '0' then
        x := tx - sy ;
        else    
        x := tx + sy;
        end if;
    else 
    x := x;
    if fin = '1' then cos <= x; end if;
end if;
end if;
tx <= x; 
end process;

--regitre y
process(clk)
variable y: std_logic_vector (15 downto 0);
begin
if rising_edge(clk) then
    if reset = '0' then y := (others => '0');
    elsif init = '1' then y := (others => '0');
    elsif ld = '1' then
        if np = '0' then
        y := ty + sx ;
        else    
        y := ty - sx ;
        end if;
    else 
    y := y;
    if fin = '1' then sin <= y; end if;
    end if ;
end if;
ty <= y;
end process;


--regitre teta
process(clk)
variable z: std_logic_vector (15 downto 0);
begin
if rising_edge(clk) then
    if reset = '0' then z := (others => '0');
    elsif init = '1' then z := teta;
    elsif ld = '1' then
        if np = '0' then
        z := tz - Dteta(Qs);
        else    
        z := tz + Dteta(Qs);
        end if;
    else 
    z := z;
    end if ;
end if;
tz <= z;
msb <= z(15);
end process;


--counter
process(clk)
variable Q: natural range 0 to 9 :=0;
variable vcz: std_logic;
begin
if rising_edge(clk) then
    if reset = '0' then Q := 0;
    elsif init = '1' then Q := 0; vcz := '0';
    elsif ld = '1' then
        if Q = 9 then vcz := '1';
        else vcz := '0';
        end if;
    elsif ic = '1' then
        if Q = 9 then Q := 0;    --if problem:Q = 9
        else Q := Q+1;
        end if;
    else Q := Q;
    end if;
end if;
Qs <= Q;
cz <= vcz;
end process;


--shift x
process(clk)
variable s1:std_logic_vector(3 downto 0);
variable Wx:std_logic_vector(15 downto 0);
begin
if rising_edge (clk)then
if reset = '0' then Wx := (others => '0');
elsif init = '1' then Wx := "0010011011011001";
elsif k = '1' then
s1 := std_logic_vector(to_unsigned(Qs,4));
Wx := shr(tx, s1);
else Wx := Wx;
end if;
end if;
sx <= Wx;
end process;

--shift y
process(clk)
variable s2:std_logic_vector(3 downto 0);
variable Wy:std_logic_vector(15 downto 0);
begin
if rising_edge(clk) then
if reset = '0' then Wy := (others => '0');
elsif init = '1' then Wy := (others => '0');
elsif k = '1' then
s2 := std_logic_vector(to_unsigned(Qs,4));
Wy := shr(ty, s2);
else Wy := Wy;
end if;
end if;
sy <= Wy;
end process;

end Behavioral;