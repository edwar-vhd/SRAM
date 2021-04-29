-------------------------------------------------------------------
-- University: Universidad Pedagógica y Tecnológica de Colombia
-- Author: Edwar Javier Patiño Núñez
-- Modified by: Juan David Guerrero B
-- Create Date: 25/05/2020
-- Project Name: SRAM_tb
-- Description:
-------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
use std.textio.all;

entity SRAM_tb is 
end entity;

architecture behavior of SRAM_tb is
	-- Testbench internal signals
	type mode is(Writing, Reading);
	
	constant word_bits	:natural := 16;
	constant add_bits		:natural := 18;
	
	signal CE				:std_logic := '0';
	signal WE				:std_logic := '0';
	signal OE				:std_logic := '1';
	signal LB				:std_logic := '0';
	signal UB				:std_logic := '1';
	signal addr 			:std_logic_vector(add_bits - 1 downto 0) := (others => '0');
			
	signal data				:std_logic_vector(word_bits - 1 downto 0) := (others => '0');
	signal in_data			:std_logic_vector(word_bits - 1 downto 0) := (others => '0');
	signal count			:std_logic_vector(word_bits - 1 downto 0) := (others => '0');
	signal s_mode 			:mode := Writing;
begin
	---------------------------------------------------------
	-- Instantiate and map the design under test 256Kx16
	---------------------------------------------------------	
	DUT: entity work.SRAM
		generic map(
			word_bits	=> word_bits,
			add_bits		=> add_bits
		)
		port map(
			CE				=> CE,
			WE				=> WE,
			OE				=> OE,
			LB				=> LB,
			UB				=> UB,
			addr 			=> addr,
			data			=> data
		);

	-- WR signal generation
	WE_OE_gen: process
	begin
		WE <= '0';
		OE <= '1';
		wait for 2 us;
		WE <= '1';
		OE <= '1';
		wait for 1 us;
		WE <= '1';
		OE <= '0';
		wait for 1 us;
	end process;
	
	-- Address
	add_gen: process
	begin
		wait for 4 us;
		addr <= std_logic_vector(unsigned(addr) + 1);
	end process;
		
	-- Input data
	input: process
	begin
		count <= std_logic_vector(unsigned(count) + 32);
		in_data <= count;
		wait for 2 us;
		in_data <= (others=>'Z');
		wait for 2 us;
	end process;
	
	data <= in_data;
			
	-- Lower bits
	LB <= '0', '1' after 4 us, '0' after 8 us, '1' after 12 us, '0' after 16 us;
	
	-- Upper bits
	UB <= '0', '0' after 4 us, '1' after 8 us, '1' after 12 us, '0' after 16 us;
	
	-- Write state mem access
	s_mode <= Writing when WE = '0' else Reading;
end architecture;