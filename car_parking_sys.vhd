--library declaration:
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--entity:
entity car_parking_sys is
port(
clk,reset:in std_logic;
outside_sensor,inside_sensor:in std_logic;
password:in std_logic_vector(3 downto 0);
red_light,green_light:out std_logic);
end entity;
--the architecture:
architecture logic of car_parking_sys is
type state is (idle,waitting,correct_password,wrong_password,stop);
--counter for the waiting 
signal counter :unsigned( 32 downto 0);
signal current_state,next_state:state ;
begin
process(clk,reset) is 
begin
if reset='0' then
current_state<= idle;
elsif clk'event and clk='1' then
current_state<=next_state;
end if;
end process; 

process(reset,clk) is 
begin
if reset='1' then counter<=(others=>'0');
elsif clk'event and clk='1' then
counter<=counter+1;
end if;
end process;

--the state transitions :
process(clk,reset,password,outside_sensor,inside_sensor,current_state,next_state,counter) is
begin
case (current_state) is 
when idle =>
	if outside_sensor='1' then next_state<=waitting;
	else next_state<=idle;
	end if;
when waitting =>  
	if counter < x"FFFFF" then 
		if password="0111" then next_state<= correct_password;
		else next_state<=wrong_password;
		end if;
	else next_state<= stop;
	end if;
when wrong_password =>
	if counter < x"11111" then  
		if password="0111" then next_state<= correct_password;
		else next_state<=wrong_password;
		end if;
	else next_state<= stop;
	end if;
when correct_password =>
	if inside_sensor='1' then next_state<=stop;
	end if;
when stop =>
	next_state<=idle;
end case;
end process;
--the outputs:
process (next_state) is
begin 
case next_state is
when idle=>
	green_light<='0';
	red_light<='0';
when waitting=>
	green_light<='0';
	red_light<='0';
when correct_password=>
	green_light<='1';
	red_light<='0';
when wrong_password=>
	green_light<='0';
	red_light<='1';
when stop=>
	green_light<='0';
	red_light<='0';
end case;
end process;
end logic;

