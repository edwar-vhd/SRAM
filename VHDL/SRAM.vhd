-------------------------------------------------------------------
-- University: Universidad Pedagógica y Tecnológica de Colombia
-- Author: Edwar Javier Patiño Núñez
-- Modified by: Juan David Guerrero
-- Create Date: 25/05/2020
-- Project Name: SRAM
-- Description:
-------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity SRAM is
	generic(
		word_bits	:natural := 4;
		add_bits		:natural := 2
	);
	port(
		CE				:in std_logic;
		WE				:in std_logic;
		OE				:in std_logic;
		LB				:in std_logic;
		UB				:in std_logic;
		addr 			:in std_logic_vector(add_bits-1 downto 0);		
		data			:inout std_logic_vector(word_bits-1 downto 0)
	);
end entity;

architecture behav of SRAM is
	type matrix is array (2**add_bits-1 downto 0) of std_logic_vector(word_bits/2-1 downto 0);
	signal cell_LB		:matrix := (others=>(others=>'1'));
	signal cell_UB		:matrix := (others=>(others=>'1'));
	signal WR_LB		:std_logic;
	signal WR_UB		:std_logic;
begin
	-- Lower bits
	WR_LB <= (not WE) and (not CE) and (not LB);
				
	latch_LB: process(data, addr, WR_LB)
	begin
		if (WR_LB = '1') then
			for i in 0 to word_bits/2-1 loop
				if data(i) = 'Z' then
					cell_LB(to_integer(unsigned(addr)))(i) <= '1';
				else
					cell_LB(to_integer(unsigned(addr)))(i) <= data(i);
				end if;			
			end loop;
		end if;
	end process;
	
	data(word_bits/2-1 downto 0) <= cell_LB(to_integer(unsigned(addr))) when ((not CE) and (not OE) and WE and (not LB)) = '1' else (others=>'Z');
	
	-- Upper bits
	WR_UB <= (not WE) and (not CE) and (not UB);
					
	latch_UB: process(data, addr, WR_UB)
	begin
		if (WR_UB = '1') then
			for i in word_bits/2 to word_bits-1 loop
				if data(i) = 'Z' then
					cell_UB(to_integer(unsigned(addr)))(i-word_bits/2) <= '1';
				else
					cell_UB(to_integer(unsigned(addr)))(i-word_bits/2) <= data(i);
				end if;			
			end loop;
		end if;
	end process;
		
	data(word_bits-1 downto word_bits/2) <= cell_UB(to_integer(unsigned(addr))) when ((not CE) and (not OE) and WE and (not UB)) = '1' else (others=>'Z');
end architecture;