library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity CU is
    Port (clk, reset, go, cz, msb: in std_logic;
          init, ld, ic, np, sh, k, fin: out std_logic);
end CU;

architecture Behavioral of CU is
Type etat is (idle, it, cnt, shift);
signal E: etat;
begin
process(clk)
begin
if rising_edge(clk) then
    if (reset = '0') then E <= idle;
    else 
        case E is 
            when idle => if go = '1' then E <= it;
                         else E <= idle;
                         end if;
            when it => E <= cnt;
            when cnt => if cz = '0' then E <= shift;
                        else E <= idle;
                        end if;
            when shift => E <= it;
        end case;
    end if;
end if;
end process;

init <= '1' when E = idle and go ='1' else '0';
ld <= '1' when E = it else '0';
sh <= '1' when E = it else '0';
np <= '0' when E = it and msb = '0' else '1';
ic <= '1' when E = cnt else '0';
k <= '1' when E = shift else '0';
fin <= '1' when E = cnt and cz = '1' else '0'; 

end Behavioral;
