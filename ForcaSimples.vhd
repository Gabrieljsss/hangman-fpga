LIBRARY ieee;
USE ieee. std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY ForcaSimples IS
PORT(
    CLOCK_50: IN std_logic;
    SW: IN std_logic_vector(3 DOWNTO 0);
    LEDR: OUT std_logic_vector(7 DOWNTO 0)
);
END ForcaSimples;

ARCHITECTURE behavioral OF Forca IS

-- Estados
SIGNAL perdeu, ganhou: std_logic;

-- Vidas perdidas
SIGNAL vidas: std_logic_vector(1 DOWNTO 0) := "11";

-- Digitos da senha em BCD
SIGNAL digito5,
       digito4,
       digito3,
       digito2,
       digito1,
       digito0: std_logic_vector(3 DOWNTO 0);

-- Estados dos digitos
SIGNAL estadoDigito5: std_logic := '0';
SIGNAL estadoDigito4: std_logic := '0';
SIGNAL estadoDigito3: std_logic := '0';
SIGNAL estadoDigito2: std_logic := '0';
SIGNAL estadoDigito1: std_logic := '0';
SIGNAL estadoDigito0: std_logic := '0';

SIGNAL submit: std_logic := '0';
BEGIN
    submit <= SW(3);

    -- Definir a senha: 711650
    digito5 <= "0111";
    digito4 <= "0001";
    digito3 <= "0001";
    digito2 <= "0110";
    digito1 <= "0101";
    digito0 <= "0000";

    PROCESS(CLOCK_50, submit)
        VARIABLE acertouAlgum: std_logic := '0';
    BEGIN
        IF (submit = '1' AND rising_edge(submit)) THEN
            IF (SW(2) = '0' AND SW(1) = '0' AND SW(0) = '0') THEN
                estadoDigito0 <= '1';
                acertouAlgum := '1';
            END IF;
            IF (SW(2) = '1' AND SW(1) = '0' AND SW(0) = '1') THEN
                estadoDigito1 <= '1';
                acertouAlgum := '1';
            END IF;
            IF (SW(2) = '1' AND SW(1) = '1' AND SW(0) = '0') THEN
                estadoDigito2 <= '1';
                acertouAlgum := '1';
            END IF;
            IF (SW(2) = '0' AND SW(1) = '0' AND SW(0) = '1') THEN
                estadoDigito3 <= '1';
                acertouAlgum := '1';
            END IF;
            IF (SW(2) = '0' AND SW(1) = '0' AND SW(0) = '1') THEN
                estadoDigito4 <= '1';
                acertouAlgum := '1';
            END IF;
            IF (SW(2) = '1' AND SW(1) = '1' AND SW(0) = '1') THEN
                estadoDigito5 <= '1';
                acertouAlgum := '1';
            END IF;
            IF(acertouAlgum = '0') THEN
                IF (vidas = "11") THEN
                    vidas <= "10";
                END IF;
                IF (vidas = "10") THEN
                    vidas <= "01";
                END IF;
                IF (vidas = "01") THEN
                    vidas <= "00";
                END IF;
            END IF;
            acertouAlgum := '0';
            perdeu <= NOT(vidas(0)) AND NOT(vidas(1));
            ganhou <= estadoDigito5 AND estadoDigito4 AND estadoDigito3 AND estadoDigito2 AND estadoDigito1 AND estadoDigito0;
        END IF ;
    END PROCESS;

    LEDR(7 DOWNTO 6) <= vidas;
    LEDR(5 DOWNTO 0) <= estadoDigito5 & estadoDigito4 & estadoDigito3 & estadoDigito2 & estadoDigito1 & estadoDigito0;

END behavioral;
