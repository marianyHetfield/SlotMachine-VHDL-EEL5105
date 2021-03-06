library ieee; 
use ieee.std_logic_1164.all; 

entity SLOTMACHINE is

 port(-- Entradas  declaradas
		
		KEY: in std_logic_vector (3 downto 0);									-- ENTRADA GERAL
		
		
		SW: in std_logic_vector (9 downto 0); 									-- ENTRADA PRO SELETOR DE NIVEIS
		
		CLOCK_50: in std_logic;								-- ENTRADA PRO CLOCK

		-- Saidas declaradas
		
		LEDR: out std_logic_vector (9 downto 0);		-- CREDITO_NOVO
		
		HEX5: out std_logic_vector (6 downto 0);		-- 0000110 "E"
		HEX4: out std_logic_vector (6 downto 0);		-- ESTADO FSM_CONTROL
		HEX3: out std_logic_vector (6 downto 0);   	-- RODADAS
		
		HEX0: out std_logic_vector (6 downto 0);		-- SEQ C1
		HEX1: out std_logic_vector (6 downto 0);		-- SEQ C2
		HEX2: out std_logic_vector (6 downto 0)   	-- SEQ C3		
);

  
end SLOTMACHINE;

architecture ARCH of SLOTMACHINE is

---------------------------------------------------------------------------------

component SeletorNiveis_Topo

 port(-- Entradas 
		CLOCKin: in  std_logic;
		SW9: in std_logic;
		
		-- Saidas
		CLOCK: out std_logic
);  
end component; 

---------------------------------------------

component Controlador_Topo

 port(-- Entradas  declaradas
		MSB: in std_logic;									-- ENTRADA PRA FSM_CONTROL
		KEY3: in std_logic;									-- ENTRADA PRA FSM_CONTROL
		KEY0: in std_logic;									-- ENTRADA GERAL
		
		CLOCK: in std_logic;								-- ENTRADA PRO CLOCK

		-- Saidas declaradas
		
		C1: out std_logic;									-- SAIDA PRO SEQUENCIADOR
		C2: out std_logic;									-- SAIDA PRO SEQUENCIADOR
		C3: out std_logic;									-- SAIDA PRO SEQUENCIADOR
		
		CREDITO_23: out std_logic;							-- SAIDA PRO CONTADOR DE CREDITO
		HABILITA_CREDITO: out std_logic;					-- SAIDA PRO COMPARADOR	
		RESET_CONTADOR: out std_logic;					-- SAIDA PRO CONTADOR DE CREDITO			
	--	RODADAS:  out std_logic_vector (3 downto 0); -- SAIDA PRO DECOD
		
		HEX5: out std_logic_vector (6 downto 0);		-- 0000110 "E"
		HEX4: out std_logic_vector (6 downto 0);		-- ESTADO FSM_CONTROL
		HEX3: out std_logic_vector (6 downto 0)   	-- RODADAS
		
		-- Saidas Adicionais
		
);  
end component;

--------------------------------------------
	
component Sequenciadores_Topo
port (

		C1 : IN std_logic;
		C2 : IN std_logic;
		C3 : IN std_logic;
		
	--	RODADAS: in std_logic;
		KEY0 : IN std_logic;
		-------- OUTRAS
		CLOCK: in std_logic;
		
		--------
		HEXC1: out std_logic_vector(6 downto 0);
		
		SEQC1: out std_logic_vector(3 downto 0);
		

		--------
		HEXC2: out std_logic_vector(6 downto 0);
		
		SEQC2: out std_logic_vector(3 downto 0);
		

		--------
		HEXC3: out std_logic_vector(6 downto 0);
		
		SEQC3: out std_logic_vector(3 downto 0)
);
end component;

---------------------------------------------

component Comparador_Topo
port (
		SW9: in STD_LOGIC;
		SEQC1: in STD_LOGIC_VECTOR (3 DOWNTO 0);
		SEQC2: in STD_LOGIC_VECTOR (3 DOWNTO 0);
		SEQC3: in STD_LOGIC_VECTOR (3 DOWNTO 0);
	
      HABILITA_PREMIO: in STD_LOGIC;
		
		
		CREDITO: OUT STD_LOGIC_VECTOR (10 DOWNTO 0)			
);
end component;

---------------------------------------------

component ContadorCredito_Topo
	port (
	
		CREDITO: in std_logic_vector (10 downto 0);
		CREDITO_23: in std_logic;
		KEY0: in std_logic;
		RESET_CONTADOR: in std_logic;
		
		CLOCK: in std_logic;
		
		CREDITO_NOVO: out std_logic_vector (9 downto 0);
		
		MSB: out std_logic
		);
end component;

---------------------------------------------

	SIGNAL CLOCK: std_logic;
		
	SIGNAL MSB, C1, C2, C3, CREDITO_23, HABILITA_CREDITO, RESET_CONTADOR: std_logic;
	
	SIGNAL SEQ0, SEQ1, SEQ2: std_logic_vector (3 downto 0);
	
	SIGNAL CREDITO: STD_LOGIC_VECTOR (10 DOWNTO 0);
	
begin
	
	SELETOR_DE_NIVEIS: SeletorNiveis_Topo port map (CLOCK_50, SW(9), CLOCK);

	CONTROLADOR: Controlador_Topo port map (MSB, KEY(3), KEY(0), CLOCK, C1, C2, C3, CREDITO_23, HABILITA_CREDITO, RESET_CONTADOR, HEX5, HEX4, HEX3);

	SEQUENCIADORES: Sequenciadores_Topo port map (C1, C2, C3, KEY(0), CLOCK, HEX0, SEQ0, HEX1, SEQ1, HEX2, SEQ2);

	COMPARADOR: Comparador_Topo port map (SW(9), SEQ0, SEQ1, SEQ2, HABILITA_CREDITO, CREDITO);
	
	CONTADOR_DE_CREDITO: ContadorCredito_Topo port map (CREDITO, CREDITO_23, KEY(0), RESET_CONTADOR, CLOCK, LEDR, MSB);

end ARCH;