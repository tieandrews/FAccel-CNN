-- Copyright (C) 2018  Intel Corporation. All rights reserved.
-- Your use of Intel Corporation's design tools, logic functions 
-- and other software and tools, and its AMPP partner logic 
-- functions, and any output files from any of the foregoing 
-- (including device programming or simulation files), and any 
-- associated documentation or information are expressly subject 
-- to the terms and conditions of the Intel Program License 
-- Subscription Agreement, the Intel Quartus Prime License Agreement,
-- the Intel FPGA IP License Agreement, or other applicable license
-- agreement, including, without limitation, that your use is for
-- the sole purpose of programming logic devices manufactured by
-- Intel and sold by Intel or its authorized distributors.  Please
-- refer to the applicable agreement for further details.

-- VENDOR "Altera"
-- PROGRAM "Quartus Prime"
-- VERSION "Version 18.1.0 Build 625 09/12/2018 SJ Standard Edition"

-- DATE "08/19/2020 09:49:40"

-- 
-- Device: Altera EP4CE22F17C6 Package FBGA256
-- 

-- 
-- This VHDL file should be used for ModelSim-Altera (VHDL) only
-- 

LIBRARY CYCLONEIVE;
LIBRARY IEEE;
USE CYCLONEIVE.CYCLONEIVE_COMPONENTS.ALL;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY 	hard_block IS
    PORT (
	devoe : IN std_logic;
	devclrn : IN std_logic;
	devpor : IN std_logic
	);
END hard_block;

-- Design Ports Information
-- ~ALTERA_ASDO_DATA1~	=>  Location: PIN_C1,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- ~ALTERA_FLASH_nCE_nCSO~	=>  Location: PIN_D2,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- ~ALTERA_DCLK~	=>  Location: PIN_H1,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- ~ALTERA_DATA0~	=>  Location: PIN_H2,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- ~ALTERA_nCEO~	=>  Location: PIN_F16,	 I/O Standard: 2.5 V,	 Current Strength: 8mA


ARCHITECTURE structure OF hard_block IS
SIGNAL gnd : std_logic := '0';
SIGNAL vcc : std_logic := '1';
SIGNAL unknown : std_logic := 'X';
SIGNAL ww_devoe : std_logic;
SIGNAL ww_devclrn : std_logic;
SIGNAL ww_devpor : std_logic;
SIGNAL \~ALTERA_ASDO_DATA1~~padout\ : std_logic;
SIGNAL \~ALTERA_FLASH_nCE_nCSO~~padout\ : std_logic;
SIGNAL \~ALTERA_DATA0~~padout\ : std_logic;
SIGNAL \~ALTERA_ASDO_DATA1~~ibuf_o\ : std_logic;
SIGNAL \~ALTERA_FLASH_nCE_nCSO~~ibuf_o\ : std_logic;
SIGNAL \~ALTERA_DATA0~~ibuf_o\ : std_logic;

BEGIN

ww_devoe <= devoe;
ww_devclrn <= devclrn;
ww_devpor <= devpor;
END structure;


LIBRARY ALTERA;
LIBRARY CYCLONEIVE;
LIBRARY IEEE;
USE ALTERA.ALTERA_PRIMITIVES_COMPONENTS.ALL;
USE CYCLONEIVE.CYCLONEIVE_COMPONENTS.ALL;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY 	fp_add IS
    PORT (
	clock : IN std_logic;
	clock_sreset : IN std_logic;
	data_valid : IN std_logic;
	dataa : IN std_logic_vector(15 DOWNTO 0);
	datab : IN std_logic_vector(15 DOWNTO 0);
	result_valid : OUT std_logic;
	result : OUT std_logic_vector(15 DOWNTO 0)
	);
END fp_add;

-- Design Ports Information
-- result_valid	=>  Location: PIN_R16,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- result[0]	=>  Location: PIN_M8,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- result[1]	=>  Location: PIN_B7,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- result[2]	=>  Location: PIN_E9,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- result[3]	=>  Location: PIN_E10,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- result[4]	=>  Location: PIN_B5,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- result[5]	=>  Location: PIN_D5,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- result[6]	=>  Location: PIN_A5,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- result[7]	=>  Location: PIN_B10,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- result[8]	=>  Location: PIN_D8,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- result[9]	=>  Location: PIN_D6,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- result[10]	=>  Location: PIN_A6,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- result[11]	=>  Location: PIN_A12,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- result[12]	=>  Location: PIN_D12,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- result[13]	=>  Location: PIN_D11,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- result[14]	=>  Location: PIN_A15,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- result[15]	=>  Location: PIN_B6,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- clock_sreset	=>  Location: PIN_N16,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- clock	=>  Location: PIN_E1,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- data_valid	=>  Location: PIN_P16,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- dataa[15]	=>  Location: PIN_F8,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- datab[15]	=>  Location: PIN_A4,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- datab[13]	=>  Location: PIN_A13,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- datab[14]	=>  Location: PIN_P8,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- dataa[14]	=>  Location: PIN_A7,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- dataa[13]	=>  Location: PIN_B13,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- datab[12]	=>  Location: PIN_E6,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- dataa[12]	=>  Location: PIN_A3,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- datab[11]	=>  Location: PIN_B11,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- dataa[11]	=>  Location: PIN_A11,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- datab[10]	=>  Location: PIN_C11,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- dataa[9]	=>  Location: PIN_A2,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- datab[9]	=>  Location: PIN_D9,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- dataa[8]	=>  Location: PIN_B14,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- datab[8]	=>  Location: PIN_A14,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- dataa[7]	=>  Location: PIN_E11,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- datab[7]	=>  Location: PIN_C6,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- dataa[6]	=>  Location: PIN_C16,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- datab[6]	=>  Location: PIN_E7,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- dataa[5]	=>  Location: PIN_A9,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- datab[5]	=>  Location: PIN_B9,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- dataa[4]	=>  Location: PIN_C8,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- datab[4]	=>  Location: PIN_E16,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- dataa[3]	=>  Location: PIN_E15,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- datab[3]	=>  Location: PIN_B4,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- dataa[2]	=>  Location: PIN_B3,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- datab[2]	=>  Location: PIN_E8,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- dataa[1]	=>  Location: PIN_B12,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- datab[1]	=>  Location: PIN_A10,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- dataa[0]	=>  Location: PIN_F9,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- datab[0]	=>  Location: PIN_C9,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- dataa[10]	=>  Location: PIN_C15,	 I/O Standard: 2.5 V,	 Current Strength: Default


ARCHITECTURE structure OF fp_add IS
SIGNAL gnd : std_logic := '0';
SIGNAL vcc : std_logic := '1';
SIGNAL unknown : std_logic := 'X';
SIGNAL devoe : std_logic := '1';
SIGNAL devclrn : std_logic := '1';
SIGNAL devpor : std_logic := '1';
SIGNAL ww_devoe : std_logic;
SIGNAL ww_devclrn : std_logic;
SIGNAL ww_devpor : std_logic;
SIGNAL ww_clock : std_logic;
SIGNAL ww_clock_sreset : std_logic;
SIGNAL ww_data_valid : std_logic;
SIGNAL ww_dataa : std_logic_vector(15 DOWNTO 0);
SIGNAL ww_datab : std_logic_vector(15 DOWNTO 0);
SIGNAL ww_result_valid : std_logic;
SIGNAL ww_result : std_logic_vector(15 DOWNTO 0);
SIGNAL \clock~inputclkctrl_INCLK_bus\ : std_logic_vector(3 DOWNTO 0);
SIGNAL \result_valid~output_o\ : std_logic;
SIGNAL \result[0]~output_o\ : std_logic;
SIGNAL \result[1]~output_o\ : std_logic;
SIGNAL \result[2]~output_o\ : std_logic;
SIGNAL \result[3]~output_o\ : std_logic;
SIGNAL \result[4]~output_o\ : std_logic;
SIGNAL \result[5]~output_o\ : std_logic;
SIGNAL \result[6]~output_o\ : std_logic;
SIGNAL \result[7]~output_o\ : std_logic;
SIGNAL \result[8]~output_o\ : std_logic;
SIGNAL \result[9]~output_o\ : std_logic;
SIGNAL \result[10]~output_o\ : std_logic;
SIGNAL \result[11]~output_o\ : std_logic;
SIGNAL \result[12]~output_o\ : std_logic;
SIGNAL \result[13]~output_o\ : std_logic;
SIGNAL \result[14]~output_o\ : std_logic;
SIGNAL \result[15]~output_o\ : std_logic;
SIGNAL \clock~input_o\ : std_logic;
SIGNAL \clock~inputclkctrl_outclk\ : std_logic;
SIGNAL \clock_sreset~input_o\ : std_logic;
SIGNAL \data_valid~input_o\ : std_logic;
SIGNAL \data_valid_pipe_reg~0_combout\ : std_logic;
SIGNAL \data_valid_pipe_reg~q\ : std_logic;
SIGNAL \data_valid_reg~0_combout\ : std_logic;
SIGNAL \data_valid_reg~q\ : std_logic;
SIGNAL \result_valid~0_combout\ : std_logic;
SIGNAL \result_valid~reg0_q\ : std_logic;
SIGNAL \datab[1]~input_o\ : std_logic;
SIGNAL \datab[2]~input_o\ : std_logic;
SIGNAL \datab[0]~input_o\ : std_logic;
SIGNAL \datab[3]~input_o\ : std_logic;
SIGNAL \WideNor1~0_combout\ : std_logic;
SIGNAL \datab[6]~input_o\ : std_logic;
SIGNAL \datab[5]~input_o\ : std_logic;
SIGNAL \datab[4]~input_o\ : std_logic;
SIGNAL \datab[7]~input_o\ : std_logic;
SIGNAL \WideNor1~1_combout\ : std_logic;
SIGNAL \datab[12]~input_o\ : std_logic;
SIGNAL \datab_reg[12]~feeder_combout\ : std_logic;
SIGNAL \datab[13]~input_o\ : std_logic;
SIGNAL \datab[14]~input_o\ : std_logic;
SIGNAL \WideNor1~3_combout\ : std_logic;
SIGNAL \datab[11]~input_o\ : std_logic;
SIGNAL \datab[8]~input_o\ : std_logic;
SIGNAL \datab[9]~input_o\ : std_logic;
SIGNAL \datab[10]~input_o\ : std_logic;
SIGNAL \WideNor1~2_combout\ : std_logic;
SIGNAL \WideNor1~4_combout\ : std_logic;
SIGNAL \dataa[6]~input_o\ : std_logic;
SIGNAL \dataa[7]~input_o\ : std_logic;
SIGNAL \dataa[5]~input_o\ : std_logic;
SIGNAL \dataa[4]~input_o\ : std_logic;
SIGNAL \WideNor0~1_combout\ : std_logic;
SIGNAL \dataa[1]~input_o\ : std_logic;
SIGNAL \dataa[2]~input_o\ : std_logic;
SIGNAL \dataa[3]~input_o\ : std_logic;
SIGNAL \dataa[0]~input_o\ : std_logic;
SIGNAL \WideNor0~0_combout\ : std_logic;
SIGNAL \dataa[9]~input_o\ : std_logic;
SIGNAL \dataa[8]~input_o\ : std_logic;
SIGNAL \dataa[11]~input_o\ : std_logic;
SIGNAL \dataa[10]~input_o\ : std_logic;
SIGNAL \WideNor0~2_combout\ : std_logic;
SIGNAL \dataa[14]~input_o\ : std_logic;
SIGNAL \dataa[12]~input_o\ : std_logic;
SIGNAL \dataa[13]~input_o\ : std_logic;
SIGNAL \WideNor0~3_combout\ : std_logic;
SIGNAL \WideNor0~4_combout\ : std_logic;
SIGNAL \LessThan0~0_combout\ : std_logic;
SIGNAL \Equal0~0_combout\ : std_logic;
SIGNAL \LessThan1~1_cout\ : std_logic;
SIGNAL \LessThan1~3_cout\ : std_logic;
SIGNAL \LessThan1~5_cout\ : std_logic;
SIGNAL \LessThan1~7_cout\ : std_logic;
SIGNAL \LessThan1~9_cout\ : std_logic;
SIGNAL \LessThan1~11_cout\ : std_logic;
SIGNAL \LessThan1~13_cout\ : std_logic;
SIGNAL \LessThan1~15_cout\ : std_logic;
SIGNAL \LessThan1~17_cout\ : std_logic;
SIGNAL \LessThan1~18_combout\ : std_logic;
SIGNAL \swap~0_combout\ : std_logic;
SIGNAL \swap~1_combout\ : std_logic;
SIGNAL \swap~2_combout\ : std_logic;
SIGNAL \swap~3_combout\ : std_logic;
SIGNAL \ma[10]~1_combout\ : std_logic;
SIGNAL \ea[2]~0_combout\ : std_logic;
SIGNAL \eb[2]~0_combout\ : std_logic;
SIGNAL \ea[1]~1_combout\ : std_logic;
SIGNAL \eb[1]~1_combout\ : std_logic;
SIGNAL \eb[0]~2_combout\ : std_logic;
SIGNAL \ea[0]~2_combout\ : std_logic;
SIGNAL \delta[0]~1\ : std_logic;
SIGNAL \delta[1]~3\ : std_logic;
SIGNAL \delta[2]~4_combout\ : std_logic;
SIGNAL \ea[4]~3_combout\ : std_logic;
SIGNAL \eb[4]~3_combout\ : std_logic;
SIGNAL \ea[3]~4_combout\ : std_logic;
SIGNAL \eb[3]~4_combout\ : std_logic;
SIGNAL \delta[2]~5\ : std_logic;
SIGNAL \delta[3]~7\ : std_logic;
SIGNAL \delta[4]~8_combout\ : std_logic;
SIGNAL \delta[3]~6_combout\ : std_logic;
SIGNAL \delta[0]~0_combout\ : std_logic;
SIGNAL \mb[10]~0_combout\ : std_logic;
SIGNAL \delta[1]~2_combout\ : std_logic;
SIGNAL \ShiftRight0~26_combout\ : std_logic;
SIGNAL \ShiftRight0~27_combout\ : std_logic;
SIGNAL \datab[15]~input_o\ : std_logic;
SIGNAL \dataa[15]~input_o\ : std_logic;
SIGNAL \dataa_reg[15]~feeder_combout\ : std_logic;
SIGNAL \sa~0_combout\ : std_logic;
SIGNAL \sa_reg~q\ : std_logic;
SIGNAL \sb~0_combout\ : std_logic;
SIGNAL \sb_reg~q\ : std_logic;
SIGNAL \Add1~5_combout\ : std_logic;
SIGNAL \ShiftRight0~7_combout\ : std_logic;
SIGNAL \ShiftRight0~28_combout\ : std_logic;
SIGNAL \ShiftRight0~29_combout\ : std_logic;
SIGNAL \Add1~6_combout\ : std_logic;
SIGNAL \ma[9]~2_combout\ : std_logic;
SIGNAL \ShiftRight0~8_combout\ : std_logic;
SIGNAL \ShiftRight0~9_combout\ : std_logic;
SIGNAL \ShiftRight0~10_combout\ : std_logic;
SIGNAL \ShiftRight0~43_combout\ : std_logic;
SIGNAL \Add1~7_combout\ : std_logic;
SIGNAL \ma[8]~3_combout\ : std_logic;
SIGNAL \ma[7]~4_combout\ : std_logic;
SIGNAL \ShiftRight0~30_combout\ : std_logic;
SIGNAL \ShiftRight0~22_combout\ : std_logic;
SIGNAL \ShiftRight0~31_combout\ : std_logic;
SIGNAL \ShiftRight0~32_combout\ : std_logic;
SIGNAL \ShiftRight0~44_combout\ : std_logic;
SIGNAL \Add1~8_combout\ : std_logic;
SIGNAL \ShiftRight0~23_combout\ : std_logic;
SIGNAL \ShiftRight0~24_combout\ : std_logic;
SIGNAL \mb_shift[6]~2_combout\ : std_logic;
SIGNAL \ShiftRight0~18_combout\ : std_logic;
SIGNAL \Add1~9_combout\ : std_logic;
SIGNAL \ma[6]~5_combout\ : std_logic;
SIGNAL \ma[5]~6_combout\ : std_logic;
SIGNAL \ShiftRight0~19_combout\ : std_logic;
SIGNAL \ShiftRight0~33_combout\ : std_logic;
SIGNAL \mb_shift[5]~1_combout\ : std_logic;
SIGNAL \Add1~10_combout\ : std_logic;
SIGNAL \ma[4]~7_combout\ : std_logic;
SIGNAL \ShiftRight0~20_combout\ : std_logic;
SIGNAL \ShiftRight0~21_combout\ : std_logic;
SIGNAL \mb_shift[4]~0_combout\ : std_logic;
SIGNAL \Add1~11_combout\ : std_logic;
SIGNAL \ma[3]~8_combout\ : std_logic;
SIGNAL \ShiftRight0~11_combout\ : std_logic;
SIGNAL \ShiftRight0~34_combout\ : std_logic;
SIGNAL \mb_shift[3]~3_combout\ : std_logic;
SIGNAL \Add1~12_combout\ : std_logic;
SIGNAL \ma[2]~9_combout\ : std_logic;
SIGNAL \ShiftRight0~12_combout\ : std_logic;
SIGNAL \ShiftRight0~13_combout\ : std_logic;
SIGNAL \ShiftRight0~35_combout\ : std_logic;
SIGNAL \ShiftRight0~6_combout\ : std_logic;
SIGNAL \ShiftRight0~36_combout\ : std_logic;
SIGNAL \ShiftRight0~37_combout\ : std_logic;
SIGNAL \Add1~13_combout\ : std_logic;
SIGNAL \ShiftRight0~15_combout\ : std_logic;
SIGNAL \ShiftRight0~38_combout\ : std_logic;
SIGNAL \ShiftRight0~39_combout\ : std_logic;
SIGNAL \ShiftRight0~40_combout\ : std_logic;
SIGNAL \ShiftRight0~41_combout\ : std_logic;
SIGNAL \Add1~14_combout\ : std_logic;
SIGNAL \ma[1]~10_combout\ : std_logic;
SIGNAL \ShiftRight0~42_combout\ : std_logic;
SIGNAL \ShiftRight0~14_combout\ : std_logic;
SIGNAL \ShiftRight0~16_combout\ : std_logic;
SIGNAL \ShiftRight0~17_combout\ : std_logic;
SIGNAL \ShiftRight0~25_combout\ : std_logic;
SIGNAL \Add1~0_combout\ : std_logic;
SIGNAL \ma[0]~0_combout\ : std_logic;
SIGNAL \Add1~2_cout\ : std_logic;
SIGNAL \Add1~4\ : std_logic;
SIGNAL \Add1~16\ : std_logic;
SIGNAL \Add1~18\ : std_logic;
SIGNAL \Add1~20\ : std_logic;
SIGNAL \Add1~22\ : std_logic;
SIGNAL \Add1~24\ : std_logic;
SIGNAL \Add1~26\ : std_logic;
SIGNAL \Add1~28\ : std_logic;
SIGNAL \Add1~30\ : std_logic;
SIGNAL \Add1~32\ : std_logic;
SIGNAL \Add1~33_combout\ : std_logic;
SIGNAL \Add1~29_combout\ : std_logic;
SIGNAL \Add1~17_combout\ : std_logic;
SIGNAL \Add1~25_combout\ : std_logic;
SIGNAL \Add1~31_combout\ : std_logic;
SIGNAL \Add1~21_combout\ : std_logic;
SIGNAL \Add1~23_combout\ : std_logic;
SIGNAL \Add1~27_combout\ : std_logic;
SIGNAL \zc|node[1][10]~2_combout\ : std_logic;
SIGNAL \zc|node[2][10]~3_combout\ : std_logic;
SIGNAL \Add1~34\ : std_logic;
SIGNAL \Add1~35_combout\ : std_logic;
SIGNAL \zc|node[2][10]~4_combout\ : std_logic;
SIGNAL \zc|node[2][11]~10_combout\ : std_logic;
SIGNAL \Add1~19_combout\ : std_logic;
SIGNAL \zc|node[1][11]~7_combout\ : std_logic;
SIGNAL \zc|node[1][11]~8_combout\ : std_logic;
SIGNAL \zc|last~0_combout\ : std_logic;
SIGNAL \zc|result[10]~0_combout\ : std_logic;
SIGNAL \Add1~15_combout\ : std_logic;
SIGNAL \zc|node[2][9]~12_combout\ : std_logic;
SIGNAL \zc|node[2][9]~13_combout\ : std_logic;
SIGNAL \Add1~3_combout\ : std_logic;
SIGNAL \zc|node[1][8]~5_combout\ : std_logic;
SIGNAL \zc|node[1][8]~6_combout\ : std_logic;
SIGNAL \zc|node[1][11]~9_combout\ : std_logic;
SIGNAL \zc|LessThan1~0_combout\ : std_logic;
SIGNAL \zc|LessThan1~1_combout\ : std_logic;
SIGNAL \zc|LessThan1~2_combout\ : std_logic;
SIGNAL \zc|result[10]~1_combout\ : std_logic;
SIGNAL \zc|last~1_combout\ : std_logic;
SIGNAL \zc|result[1]~3_combout\ : std_logic;
SIGNAL \zc|WideNor1~0_combout\ : std_logic;
SIGNAL \zc|node[2][0]~23_combout\ : std_logic;
SIGNAL \zc|result[1]~2_combout\ : std_logic;
SIGNAL \zc|result[1]~4_combout\ : std_logic;
SIGNAL \result[0]~reg0_q\ : std_logic;
SIGNAL \mr[2]~0_combout\ : std_logic;
SIGNAL \mr[2]~1_combout\ : std_logic;
SIGNAL \result[1]~reg0_q\ : std_logic;
SIGNAL \mr[3]~2_combout\ : std_logic;
SIGNAL \mr[3]~3_combout\ : std_logic;
SIGNAL \result[2]~reg0_q\ : std_logic;
SIGNAL \WideNor2~0_combout\ : std_logic;
SIGNAL \zc|node[2][2]~14_combout\ : std_logic;
SIGNAL \zc|node[2][4]~15_combout\ : std_logic;
SIGNAL \result[3]~4_combout\ : std_logic;
SIGNAL \zc|node[3][3]~16_combout\ : std_logic;
SIGNAL \result[3]~reg0_q\ : std_logic;
SIGNAL \zc|node[2][3]~17_combout\ : std_logic;
SIGNAL \zc|node[2][5]~18_combout\ : std_logic;
SIGNAL \result[4]~5_combout\ : std_logic;
SIGNAL \result[4]~reg0_q\ : std_logic;
SIGNAL \zc|node[2][6]~19_combout\ : std_logic;
SIGNAL \result[5]~6_combout\ : std_logic;
SIGNAL \result[5]~reg0_q\ : std_logic;
SIGNAL \zc|node[2][7]~20_combout\ : std_logic;
SIGNAL \result[6]~7_combout\ : std_logic;
SIGNAL \result[6]~reg0_q\ : std_logic;
SIGNAL \zc|node[2][8]~21_combout\ : std_logic;
SIGNAL \zc|node[2][8]~22_combout\ : std_logic;
SIGNAL \result[7]~8_combout\ : std_logic;
SIGNAL \result[7]~reg0_q\ : std_logic;
SIGNAL \result[8]~9_combout\ : std_logic;
SIGNAL \result[8]~reg0_q\ : std_logic;
SIGNAL \result[9]~10_combout\ : std_logic;
SIGNAL \result[9]~reg0_q\ : std_logic;
SIGNAL \WideNor2~1_combout\ : std_logic;
SIGNAL \Add3~0_combout\ : std_logic;
SIGNAL \er[0]~0_combout\ : std_logic;
SIGNAL \result[10]~reg0_q\ : std_logic;
SIGNAL \Add3~1\ : std_logic;
SIGNAL \Add3~2_combout\ : std_logic;
SIGNAL \result[11]~11_combout\ : std_logic;
SIGNAL \zc|node[1][9]~11_combout\ : std_logic;
SIGNAL \WideNor2~combout\ : std_logic;
SIGNAL \result[11]~reg0_q\ : std_logic;
SIGNAL \Add3~3\ : std_logic;
SIGNAL \Add3~4_combout\ : std_logic;
SIGNAL \result[11]~12\ : std_logic;
SIGNAL \result[12]~13_combout\ : std_logic;
SIGNAL \result[12]~reg0_q\ : std_logic;
SIGNAL \Add3~5\ : std_logic;
SIGNAL \Add3~6_combout\ : std_logic;
SIGNAL \result[12]~14\ : std_logic;
SIGNAL \result[13]~15_combout\ : std_logic;
SIGNAL \result[13]~reg0_q\ : std_logic;
SIGNAL \Add3~7\ : std_logic;
SIGNAL \Add3~8_combout\ : std_logic;
SIGNAL \result[13]~16\ : std_logic;
SIGNAL \result[14]~17_combout\ : std_logic;
SIGNAL \result[14]~reg0_q\ : std_logic;
SIGNAL \sr~0_combout\ : std_logic;
SIGNAL \result[15]~reg0_q\ : std_logic;
SIGNAL mb_shift : std_logic_vector(10 DOWNTO 0);
SIGNAL dataa_reg : std_logic_vector(15 DOWNTO 0);
SIGNAL ma_reg : std_logic_vector(10 DOWNTO 0);
SIGNAL ea_reg : std_logic_vector(4 DOWNTO 0);
SIGNAL datab_reg : std_logic_vector(15 DOWNTO 0);
SIGNAL \zc|ALT_INV_result[10]~1_combout\ : std_logic;

COMPONENT hard_block
    PORT (
	devoe : IN std_logic;
	devclrn : IN std_logic;
	devpor : IN std_logic);
END COMPONENT;

BEGIN

ww_clock <= clock;
ww_clock_sreset <= clock_sreset;
ww_data_valid <= data_valid;
ww_dataa <= dataa;
ww_datab <= datab;
result_valid <= ww_result_valid;
result <= ww_result;
ww_devoe <= devoe;
ww_devclrn <= devclrn;
ww_devpor <= devpor;

\clock~inputclkctrl_INCLK_bus\ <= (vcc & vcc & vcc & \clock~input_o\);
\zc|ALT_INV_result[10]~1_combout\ <= NOT \zc|result[10]~1_combout\;
auto_generated_inst : hard_block
PORT MAP (
	devoe => ww_devoe,
	devclrn => ww_devclrn,
	devpor => ww_devpor);

-- Location: IOOBUF_X53_Y8_N23
\result_valid~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \result_valid~reg0_q\,
	devoe => ww_devoe,
	o => \result_valid~output_o\);

-- Location: IOOBUF_X20_Y0_N9
\result[0]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \result[0]~reg0_q\,
	devoe => ww_devoe,
	o => \result[0]~output_o\);

-- Location: IOOBUF_X18_Y34_N2
\result[1]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \result[1]~reg0_q\,
	devoe => ww_devoe,
	o => \result[1]~output_o\);

-- Location: IOOBUF_X29_Y34_N16
\result[2]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \result[2]~reg0_q\,
	devoe => ww_devoe,
	o => \result[2]~output_o\);

-- Location: IOOBUF_X45_Y34_N16
\result[3]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \result[3]~reg0_q\,
	devoe => ww_devoe,
	o => \result[3]~output_o\);

-- Location: IOOBUF_X11_Y34_N2
\result[4]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \result[4]~reg0_q\,
	devoe => ww_devoe,
	o => \result[4]~output_o\);

-- Location: IOOBUF_X5_Y34_N16
\result[5]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \result[5]~reg0_q\,
	devoe => ww_devoe,
	o => \result[5]~output_o\);

-- Location: IOOBUF_X14_Y34_N23
\result[6]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \result[6]~reg0_q\,
	devoe => ww_devoe,
	o => \result[6]~output_o\);

-- Location: IOOBUF_X34_Y34_N16
\result[7]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \result[7]~reg0_q\,
	devoe => ww_devoe,
	o => \result[7]~output_o\);

-- Location: IOOBUF_X23_Y34_N23
\result[8]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \result[8]~reg0_q\,
	devoe => ww_devoe,
	o => \result[8]~output_o\);

-- Location: IOOBUF_X9_Y34_N9
\result[9]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \result[9]~reg0_q\,
	devoe => ww_devoe,
	o => \result[9]~output_o\);

-- Location: IOOBUF_X16_Y34_N2
\result[10]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \result[10]~reg0_q\,
	devoe => ww_devoe,
	o => \result[10]~output_o\);

-- Location: IOOBUF_X43_Y34_N16
\result[11]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \result[11]~reg0_q\,
	devoe => ww_devoe,
	o => \result[11]~output_o\);

-- Location: IOOBUF_X51_Y34_N23
\result[12]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \result[12]~reg0_q\,
	devoe => ww_devoe,
	o => \result[12]~output_o\);

-- Location: IOOBUF_X51_Y34_N16
\result[13]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \result[13]~reg0_q\,
	devoe => ww_devoe,
	o => \result[13]~output_o\);

-- Location: IOOBUF_X38_Y34_N16
\result[14]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \result[14]~reg0_q\,
	devoe => ww_devoe,
	o => \result[14]~output_o\);

-- Location: IOOBUF_X16_Y34_N9
\result[15]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \result[15]~reg0_q\,
	devoe => ww_devoe,
	o => \result[15]~output_o\);

-- Location: IOIBUF_X0_Y16_N8
\clock~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_clock,
	o => \clock~input_o\);

-- Location: CLKCTRL_G2
\clock~inputclkctrl\ : cycloneive_clkctrl
-- pragma translate_off
GENERIC MAP (
	clock_type => "global clock",
	ena_register_mode => "none")
-- pragma translate_on
PORT MAP (
	inclk => \clock~inputclkctrl_INCLK_bus\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	outclk => \clock~inputclkctrl_outclk\);

-- Location: IOIBUF_X53_Y9_N22
\clock_sreset~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_clock_sreset,
	o => \clock_sreset~input_o\);

-- Location: IOIBUF_X53_Y7_N8
\data_valid~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_data_valid,
	o => \data_valid~input_o\);

-- Location: LCCOMB_X52_Y8_N28
\data_valid_pipe_reg~0\ : cycloneive_lcell_comb
-- Equation(s):
-- \data_valid_pipe_reg~0_combout\ = (\data_valid~input_o\ & !\clock_sreset~input_o\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000011110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datac => \data_valid~input_o\,
	datad => \clock_sreset~input_o\,
	combout => \data_valid_pipe_reg~0_combout\);

-- Location: FF_X52_Y8_N29
data_valid_pipe_reg : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clock~inputclkctrl_outclk\,
	d => \data_valid_pipe_reg~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \data_valid_pipe_reg~q\);

-- Location: LCCOMB_X52_Y8_N18
\data_valid_reg~0\ : cycloneive_lcell_comb
-- Equation(s):
-- \data_valid_reg~0_combout\ = (!\clock_sreset~input_o\ & \data_valid_pipe_reg~q\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0011001100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => \clock_sreset~input_o\,
	datad => \data_valid_pipe_reg~q\,
	combout => \data_valid_reg~0_combout\);

-- Location: FF_X52_Y8_N19
data_valid_reg : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clock~inputclkctrl_outclk\,
	d => \data_valid_reg~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \data_valid_reg~q\);

-- Location: LCCOMB_X52_Y8_N4
\result_valid~0\ : cycloneive_lcell_comb
-- Equation(s):
-- \result_valid~0_combout\ = (!\clock_sreset~input_o\ & \data_valid_reg~q\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0011001100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => \clock_sreset~input_o\,
	datad => \data_valid_reg~q\,
	combout => \result_valid~0_combout\);

-- Location: FF_X52_Y8_N5
\result_valid~reg0\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clock~inputclkctrl_outclk\,
	d => \result_valid~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \result_valid~reg0_q\);

-- Location: IOIBUF_X34_Y34_N8
\datab[1]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_datab(1),
	o => \datab[1]~input_o\);

-- Location: FF_X26_Y30_N11
\datab_reg[1]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clock~inputclkctrl_outclk\,
	asdata => \datab[1]~input_o\,
	sload => VCC,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => datab_reg(1));

-- Location: IOIBUF_X20_Y34_N8
\datab[2]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_datab(2),
	o => \datab[2]~input_o\);

-- Location: FF_X25_Y30_N7
\datab_reg[2]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clock~inputclkctrl_outclk\,
	asdata => \datab[2]~input_o\,
	sload => VCC,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => datab_reg(2));

-- Location: IOIBUF_X31_Y34_N1
\datab[0]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_datab(0),
	o => \datab[0]~input_o\);

-- Location: FF_X27_Y30_N7
\datab_reg[0]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clock~inputclkctrl_outclk\,
	asdata => \datab[0]~input_o\,
	sload => VCC,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => datab_reg(0));

-- Location: IOIBUF_X7_Y34_N1
\datab[3]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_datab(3),
	o => \datab[3]~input_o\);

-- Location: FF_X26_Y30_N15
\datab_reg[3]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clock~inputclkctrl_outclk\,
	asdata => \datab[3]~input_o\,
	sload => VCC,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => datab_reg(3));

-- Location: LCCOMB_X27_Y30_N6
\WideNor1~0\ : cycloneive_lcell_comb
-- Equation(s):
-- \WideNor1~0_combout\ = (datab_reg(1)) # ((datab_reg(2)) # ((datab_reg(0)) # (datab_reg(3))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111111111110",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => datab_reg(1),
	datab => datab_reg(2),
	datac => datab_reg(0),
	datad => datab_reg(3),
	combout => \WideNor1~0_combout\);

-- Location: IOIBUF_X16_Y34_N15
\datab[6]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_datab(6),
	o => \datab[6]~input_o\);

-- Location: FF_X25_Y30_N25
\datab_reg[6]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clock~inputclkctrl_outclk\,
	asdata => \datab[6]~input_o\,
	sload => VCC,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => datab_reg(6));

-- Location: IOIBUF_X25_Y34_N8
\datab[5]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_datab(5),
	o => \datab[5]~input_o\);

-- Location: FF_X26_Y30_N19
\datab_reg[5]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clock~inputclkctrl_outclk\,
	asdata => \datab[5]~input_o\,
	sload => VCC,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => datab_reg(5));

-- Location: IOIBUF_X53_Y17_N8
\datab[4]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_datab(4),
	o => \datab[4]~input_o\);

-- Location: FF_X27_Y30_N3
\datab_reg[4]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clock~inputclkctrl_outclk\,
	asdata => \datab[4]~input_o\,
	sload => VCC,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => datab_reg(4));

-- Location: IOIBUF_X18_Y34_N22
\datab[7]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_datab(7),
	o => \datab[7]~input_o\);

-- Location: FF_X26_Y30_N25
\datab_reg[7]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clock~inputclkctrl_outclk\,
	asdata => \datab[7]~input_o\,
	sload => VCC,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => datab_reg(7));

-- Location: LCCOMB_X27_Y30_N2
\WideNor1~1\ : cycloneive_lcell_comb
-- Equation(s):
-- \WideNor1~1_combout\ = (datab_reg(6)) # ((datab_reg(5)) # ((datab_reg(4)) # (datab_reg(7))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111111111110",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => datab_reg(6),
	datab => datab_reg(5),
	datac => datab_reg(4),
	datad => datab_reg(7),
	combout => \WideNor1~1_combout\);

-- Location: IOIBUF_X14_Y34_N15
\datab[12]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_datab(12),
	o => \datab[12]~input_o\);

-- Location: LCCOMB_X25_Y30_N30
\datab_reg[12]~feeder\ : cycloneive_lcell_comb
-- Equation(s):
-- \datab_reg[12]~feeder_combout\ = \datab[12]~input_o\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => \datab[12]~input_o\,
	combout => \datab_reg[12]~feeder_combout\);

-- Location: FF_X25_Y30_N31
\datab_reg[12]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clock~inputclkctrl_outclk\,
	d => \datab_reg[12]~feeder_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => datab_reg(12));

-- Location: IOIBUF_X49_Y34_N1
\datab[13]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_datab(13),
	o => \datab[13]~input_o\);

-- Location: FF_X26_Y30_N29
\datab_reg[13]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clock~inputclkctrl_outclk\,
	asdata => \datab[13]~input_o\,
	sload => VCC,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => datab_reg(13));

-- Location: IOIBUF_X25_Y0_N15
\datab[14]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_datab(14),
	o => \datab[14]~input_o\);

-- Location: FF_X26_Y30_N7
\datab_reg[14]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clock~inputclkctrl_outclk\,
	asdata => \datab[14]~input_o\,
	sload => VCC,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => datab_reg(14));

-- Location: LCCOMB_X25_Y30_N24
\WideNor1~3\ : cycloneive_lcell_comb
-- Equation(s):
-- \WideNor1~3_combout\ = (datab_reg(12)) # ((datab_reg(13)) # (datab_reg(14)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111111101110",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => datab_reg(12),
	datab => datab_reg(13),
	datad => datab_reg(14),
	combout => \WideNor1~3_combout\);

-- Location: IOIBUF_X40_Y34_N8
\datab[11]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_datab(11),
	o => \datab[11]~input_o\);

-- Location: FF_X27_Y30_N13
\datab_reg[11]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clock~inputclkctrl_outclk\,
	asdata => \datab[11]~input_o\,
	sload => VCC,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => datab_reg(11));

-- Location: IOIBUF_X47_Y34_N22
\datab[8]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_datab(8),
	o => \datab[8]~input_o\);

-- Location: FF_X26_Y30_N5
\datab_reg[8]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clock~inputclkctrl_outclk\,
	asdata => \datab[8]~input_o\,
	sload => VCC,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => datab_reg(8));

-- Location: IOIBUF_X31_Y34_N8
\datab[9]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_datab(9),
	o => \datab[9]~input_o\);

-- Location: FF_X27_Y30_N25
\datab_reg[9]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clock~inputclkctrl_outclk\,
	asdata => \datab[9]~input_o\,
	sload => VCC,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => datab_reg(9));

-- Location: IOIBUF_X38_Y34_N1
\datab[10]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_datab(10),
	o => \datab[10]~input_o\);

-- Location: FF_X30_Y30_N11
\datab_reg[10]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clock~inputclkctrl_outclk\,
	asdata => \datab[10]~input_o\,
	sload => VCC,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => datab_reg(10));

-- Location: LCCOMB_X27_Y30_N24
\WideNor1~2\ : cycloneive_lcell_comb
-- Equation(s):
-- \WideNor1~2_combout\ = (datab_reg(11)) # ((datab_reg(8)) # ((datab_reg(9)) # (datab_reg(10))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111111111110",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => datab_reg(11),
	datab => datab_reg(8),
	datac => datab_reg(9),
	datad => datab_reg(10),
	combout => \WideNor1~2_combout\);

-- Location: LCCOMB_X27_Y30_N20
\WideNor1~4\ : cycloneive_lcell_comb
-- Equation(s):
-- \WideNor1~4_combout\ = (\WideNor1~0_combout\) # ((\WideNor1~1_combout\) # ((\WideNor1~3_combout\) # (\WideNor1~2_combout\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111111111110",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \WideNor1~0_combout\,
	datab => \WideNor1~1_combout\,
	datac => \WideNor1~3_combout\,
	datad => \WideNor1~2_combout\,
	combout => \WideNor1~4_combout\);

-- Location: IOIBUF_X53_Y30_N8
\dataa[6]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_dataa(6),
	o => \dataa[6]~input_o\);

-- Location: FF_X26_Y30_N21
\dataa_reg[6]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clock~inputclkctrl_outclk\,
	asdata => \dataa[6]~input_o\,
	sload => VCC,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => dataa_reg(6));

-- Location: IOIBUF_X45_Y34_N8
\dataa[7]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_dataa(7),
	o => \dataa[7]~input_o\);

-- Location: FF_X26_Y30_N23
\dataa_reg[7]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clock~inputclkctrl_outclk\,
	asdata => \dataa[7]~input_o\,
	sload => VCC,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => dataa_reg(7));

-- Location: IOIBUF_X25_Y34_N1
\dataa[5]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_dataa(5),
	o => \dataa[5]~input_o\);

-- Location: FF_X25_Y30_N3
\dataa_reg[5]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clock~inputclkctrl_outclk\,
	asdata => \dataa[5]~input_o\,
	sload => VCC,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => dataa_reg(5));

-- Location: IOIBUF_X23_Y34_N15
\dataa[4]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_dataa(4),
	o => \dataa[4]~input_o\);

-- Location: FF_X26_Y30_N17
\dataa_reg[4]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clock~inputclkctrl_outclk\,
	asdata => \dataa[4]~input_o\,
	sload => VCC,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => dataa_reg(4));

-- Location: LCCOMB_X25_Y30_N2
\WideNor0~1\ : cycloneive_lcell_comb
-- Equation(s):
-- \WideNor0~1_combout\ = (dataa_reg(6)) # ((dataa_reg(7)) # ((dataa_reg(5)) # (dataa_reg(4))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111111111110",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => dataa_reg(6),
	datab => dataa_reg(7),
	datac => dataa_reg(5),
	datad => dataa_reg(4),
	combout => \WideNor0~1_combout\);

-- Location: IOIBUF_X43_Y34_N22
\dataa[1]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_dataa(1),
	o => \dataa[1]~input_o\);

-- Location: FF_X27_Y30_N17
\dataa_reg[1]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clock~inputclkctrl_outclk\,
	asdata => \dataa[1]~input_o\,
	sload => VCC,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => dataa_reg(1));

-- Location: IOIBUF_X3_Y34_N1
\dataa[2]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_dataa(2),
	o => \dataa[2]~input_o\);

-- Location: FF_X26_Y30_N13
\dataa_reg[2]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clock~inputclkctrl_outclk\,
	asdata => \dataa[2]~input_o\,
	sload => VCC,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => dataa_reg(2));

-- Location: IOIBUF_X53_Y17_N1
\dataa[3]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_dataa(3),
	o => \dataa[3]~input_o\);

-- Location: FF_X25_Y30_N5
\dataa_reg[3]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clock~inputclkctrl_outclk\,
	asdata => \dataa[3]~input_o\,
	sload => VCC,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => dataa_reg(3));

-- Location: IOIBUF_X34_Y34_N1
\dataa[0]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_dataa(0),
	o => \dataa[0]~input_o\);

-- Location: FF_X26_Y30_N9
\dataa_reg[0]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clock~inputclkctrl_outclk\,
	asdata => \dataa[0]~input_o\,
	sload => VCC,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => dataa_reg(0));

-- Location: LCCOMB_X25_Y30_N4
\WideNor0~0\ : cycloneive_lcell_comb
-- Equation(s):
-- \WideNor0~0_combout\ = (dataa_reg(1)) # ((dataa_reg(2)) # ((dataa_reg(3)) # (dataa_reg(0))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111111111110",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => dataa_reg(1),
	datab => dataa_reg(2),
	datac => dataa_reg(3),
	datad => dataa_reg(0),
	combout => \WideNor0~0_combout\);

-- Location: IOIBUF_X7_Y34_N8
\dataa[9]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_dataa(9),
	o => \dataa[9]~input_o\);

-- Location: FF_X26_Y30_N27
\dataa_reg[9]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clock~inputclkctrl_outclk\,
	asdata => \dataa[9]~input_o\,
	sload => VCC,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => dataa_reg(9));

-- Location: IOIBUF_X45_Y34_N1
\dataa[8]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_dataa(8),
	o => \dataa[8]~input_o\);

-- Location: FF_X26_Y30_N31
\dataa_reg[8]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clock~inputclkctrl_outclk\,
	asdata => \dataa[8]~input_o\,
	sload => VCC,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => dataa_reg(8));

-- Location: IOIBUF_X40_Y34_N1
\dataa[11]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_dataa(11),
	o => \dataa[11]~input_o\);

-- Location: FF_X27_Y30_N11
\dataa_reg[11]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clock~inputclkctrl_outclk\,
	asdata => \dataa[11]~input_o\,
	sload => VCC,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => dataa_reg(11));

-- Location: IOIBUF_X53_Y30_N1
\dataa[10]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_dataa(10),
	o => \dataa[10]~input_o\);

-- Location: FF_X26_Y30_N3
\dataa_reg[10]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clock~inputclkctrl_outclk\,
	asdata => \dataa[10]~input_o\,
	sload => VCC,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => dataa_reg(10));

-- Location: LCCOMB_X27_Y30_N10
\WideNor0~2\ : cycloneive_lcell_comb
-- Equation(s):
-- \WideNor0~2_combout\ = (dataa_reg(9)) # ((dataa_reg(8)) # ((dataa_reg(11)) # (dataa_reg(10))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111111111110",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => dataa_reg(9),
	datab => dataa_reg(8),
	datac => dataa_reg(11),
	datad => dataa_reg(10),
	combout => \WideNor0~2_combout\);

-- Location: IOIBUF_X20_Y34_N22
\dataa[14]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_dataa(14),
	o => \dataa[14]~input_o\);

-- Location: FF_X25_Y30_N19
\dataa_reg[14]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clock~inputclkctrl_outclk\,
	asdata => \dataa[14]~input_o\,
	sload => VCC,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => dataa_reg(14));

-- Location: IOIBUF_X7_Y34_N15
\dataa[12]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_dataa(12),
	o => \dataa[12]~input_o\);

-- Location: FF_X26_Y30_N1
\dataa_reg[12]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clock~inputclkctrl_outclk\,
	asdata => \dataa[12]~input_o\,
	sload => VCC,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => dataa_reg(12));

-- Location: IOIBUF_X49_Y34_N8
\dataa[13]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_dataa(13),
	o => \dataa[13]~input_o\);

-- Location: FF_X25_Y30_N29
\dataa_reg[13]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clock~inputclkctrl_outclk\,
	asdata => \dataa[13]~input_o\,
	sload => VCC,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => dataa_reg(13));

-- Location: LCCOMB_X25_Y30_N6
\WideNor0~3\ : cycloneive_lcell_comb
-- Equation(s):
-- \WideNor0~3_combout\ = (dataa_reg(14)) # ((dataa_reg(12)) # (dataa_reg(13)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111111101110",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => dataa_reg(14),
	datab => dataa_reg(12),
	datad => dataa_reg(13),
	combout => \WideNor0~3_combout\);

-- Location: LCCOMB_X32_Y30_N30
\WideNor0~4\ : cycloneive_lcell_comb
-- Equation(s):
-- \WideNor0~4_combout\ = (\WideNor0~1_combout\) # ((\WideNor0~0_combout\) # ((\WideNor0~2_combout\) # (\WideNor0~3_combout\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111111111110",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \WideNor0~1_combout\,
	datab => \WideNor0~0_combout\,
	datac => \WideNor0~2_combout\,
	datad => \WideNor0~3_combout\,
	combout => \WideNor0~4_combout\);

-- Location: LCCOMB_X27_Y30_N4
\LessThan0~0\ : cycloneive_lcell_comb
-- Equation(s):
-- \LessThan0~0_combout\ = (!dataa_reg(11) & datab_reg(11))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0101010100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => dataa_reg(11),
	datad => datab_reg(11),
	combout => \LessThan0~0_combout\);

-- Location: LCCOMB_X27_Y30_N18
\Equal0~0\ : cycloneive_lcell_comb
-- Equation(s):
-- \Equal0~0_combout\ = dataa_reg(11) $ (datab_reg(11))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0101010110101010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => dataa_reg(11),
	datad => datab_reg(11),
	combout => \Equal0~0_combout\);

-- Location: LCCOMB_X26_Y30_N8
\LessThan1~1\ : cycloneive_lcell_comb
-- Equation(s):
-- \LessThan1~1_cout\ = CARRY((datab_reg(0) & !dataa_reg(0)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000000100010",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => datab_reg(0),
	datab => dataa_reg(0),
	datad => VCC,
	cout => \LessThan1~1_cout\);

-- Location: LCCOMB_X26_Y30_N10
\LessThan1~3\ : cycloneive_lcell_comb
-- Equation(s):
-- \LessThan1~3_cout\ = CARRY((datab_reg(1) & (dataa_reg(1) & !\LessThan1~1_cout\)) # (!datab_reg(1) & ((dataa_reg(1)) # (!\LessThan1~1_cout\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000001001101",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => datab_reg(1),
	datab => dataa_reg(1),
	datad => VCC,
	cin => \LessThan1~1_cout\,
	cout => \LessThan1~3_cout\);

-- Location: LCCOMB_X26_Y30_N12
\LessThan1~5\ : cycloneive_lcell_comb
-- Equation(s):
-- \LessThan1~5_cout\ = CARRY((dataa_reg(2) & (datab_reg(2) & !\LessThan1~3_cout\)) # (!dataa_reg(2) & ((datab_reg(2)) # (!\LessThan1~3_cout\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000001001101",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => dataa_reg(2),
	datab => datab_reg(2),
	datad => VCC,
	cin => \LessThan1~3_cout\,
	cout => \LessThan1~5_cout\);

-- Location: LCCOMB_X26_Y30_N14
\LessThan1~7\ : cycloneive_lcell_comb
-- Equation(s):
-- \LessThan1~7_cout\ = CARRY((dataa_reg(3) & ((!\LessThan1~5_cout\) # (!datab_reg(3)))) # (!dataa_reg(3) & (!datab_reg(3) & !\LessThan1~5_cout\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000000101011",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => dataa_reg(3),
	datab => datab_reg(3),
	datad => VCC,
	cin => \LessThan1~5_cout\,
	cout => \LessThan1~7_cout\);

-- Location: LCCOMB_X26_Y30_N16
\LessThan1~9\ : cycloneive_lcell_comb
-- Equation(s):
-- \LessThan1~9_cout\ = CARRY((datab_reg(4) & ((!\LessThan1~7_cout\) # (!dataa_reg(4)))) # (!datab_reg(4) & (!dataa_reg(4) & !\LessThan1~7_cout\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000000101011",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => datab_reg(4),
	datab => dataa_reg(4),
	datad => VCC,
	cin => \LessThan1~7_cout\,
	cout => \LessThan1~9_cout\);

-- Location: LCCOMB_X26_Y30_N18
\LessThan1~11\ : cycloneive_lcell_comb
-- Equation(s):
-- \LessThan1~11_cout\ = CARRY((dataa_reg(5) & ((!\LessThan1~9_cout\) # (!datab_reg(5)))) # (!dataa_reg(5) & (!datab_reg(5) & !\LessThan1~9_cout\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000000101011",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => dataa_reg(5),
	datab => datab_reg(5),
	datad => VCC,
	cin => \LessThan1~9_cout\,
	cout => \LessThan1~11_cout\);

-- Location: LCCOMB_X26_Y30_N20
\LessThan1~13\ : cycloneive_lcell_comb
-- Equation(s):
-- \LessThan1~13_cout\ = CARRY((dataa_reg(6) & (datab_reg(6) & !\LessThan1~11_cout\)) # (!dataa_reg(6) & ((datab_reg(6)) # (!\LessThan1~11_cout\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000001001101",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => dataa_reg(6),
	datab => datab_reg(6),
	datad => VCC,
	cin => \LessThan1~11_cout\,
	cout => \LessThan1~13_cout\);

-- Location: LCCOMB_X26_Y30_N22
\LessThan1~15\ : cycloneive_lcell_comb
-- Equation(s):
-- \LessThan1~15_cout\ = CARRY((dataa_reg(7) & ((!\LessThan1~13_cout\) # (!datab_reg(7)))) # (!dataa_reg(7) & (!datab_reg(7) & !\LessThan1~13_cout\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000000101011",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => dataa_reg(7),
	datab => datab_reg(7),
	datad => VCC,
	cin => \LessThan1~13_cout\,
	cout => \LessThan1~15_cout\);

-- Location: LCCOMB_X26_Y30_N24
\LessThan1~17\ : cycloneive_lcell_comb
-- Equation(s):
-- \LessThan1~17_cout\ = CARRY((dataa_reg(8) & (datab_reg(8) & !\LessThan1~15_cout\)) # (!dataa_reg(8) & ((datab_reg(8)) # (!\LessThan1~15_cout\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000001001101",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => dataa_reg(8),
	datab => datab_reg(8),
	datad => VCC,
	cin => \LessThan1~15_cout\,
	cout => \LessThan1~17_cout\);

-- Location: LCCOMB_X26_Y30_N26
\LessThan1~18\ : cycloneive_lcell_comb
-- Equation(s):
-- \LessThan1~18_combout\ = (dataa_reg(9) & (\LessThan1~17_cout\ & datab_reg(9))) # (!dataa_reg(9) & ((\LessThan1~17_cout\) # (datab_reg(9))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111010101010000",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => dataa_reg(9),
	datad => datab_reg(9),
	cin => \LessThan1~17_cout\,
	combout => \LessThan1~18_combout\);

-- Location: LCCOMB_X26_Y30_N2
\swap~0\ : cycloneive_lcell_comb
-- Equation(s):
-- \swap~0_combout\ = (!\Equal0~0_combout\ & ((datab_reg(10) & ((\LessThan1~18_combout\) # (!dataa_reg(10)))) # (!datab_reg(10) & (!dataa_reg(10) & \LessThan1~18_combout\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0010001100000010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => datab_reg(10),
	datab => \Equal0~0_combout\,
	datac => dataa_reg(10),
	datad => \LessThan1~18_combout\,
	combout => \swap~0_combout\);

-- Location: LCCOMB_X26_Y30_N0
\swap~1\ : cycloneive_lcell_comb
-- Equation(s):
-- \swap~1_combout\ = (datab_reg(12) & ((\LessThan0~0_combout\) # ((\swap~0_combout\) # (!dataa_reg(12))))) # (!datab_reg(12) & (!dataa_reg(12) & ((\LessThan0~0_combout\) # (\swap~0_combout\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100111110001110",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \LessThan0~0_combout\,
	datab => datab_reg(12),
	datac => dataa_reg(12),
	datad => \swap~0_combout\,
	combout => \swap~1_combout\);

-- Location: LCCOMB_X26_Y30_N28
\swap~2\ : cycloneive_lcell_comb
-- Equation(s):
-- \swap~2_combout\ = (dataa_reg(13) & (datab_reg(13) & \swap~1_combout\)) # (!dataa_reg(13) & ((datab_reg(13)) # (\swap~1_combout\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111001100110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => dataa_reg(13),
	datac => datab_reg(13),
	datad => \swap~1_combout\,
	combout => \swap~2_combout\);

-- Location: LCCOMB_X26_Y30_N6
\swap~3\ : cycloneive_lcell_comb
-- Equation(s):
-- \swap~3_combout\ = (dataa_reg(14) & (datab_reg(14) & \swap~2_combout\)) # (!dataa_reg(14) & ((datab_reg(14)) # (\swap~2_combout\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111001100110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => dataa_reg(14),
	datac => datab_reg(14),
	datad => \swap~2_combout\,
	combout => \swap~3_combout\);

-- Location: LCCOMB_X32_Y30_N6
\ma[10]~1\ : cycloneive_lcell_comb
-- Equation(s):
-- \ma[10]~1_combout\ = (\swap~3_combout\ & (\WideNor1~4_combout\)) # (!\swap~3_combout\ & ((\WideNor0~4_combout\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1010101011110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \WideNor1~4_combout\,
	datac => \WideNor0~4_combout\,
	datad => \swap~3_combout\,
	combout => \ma[10]~1_combout\);

-- Location: FF_X32_Y30_N7
\ma_reg[10]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clock~inputclkctrl_outclk\,
	d => \ma[10]~1_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => ma_reg(10));

-- Location: LCCOMB_X25_Y30_N12
\ea[2]~0\ : cycloneive_lcell_comb
-- Equation(s):
-- \ea[2]~0_combout\ = (\swap~3_combout\ & ((datab_reg(12)))) # (!\swap~3_combout\ & (dataa_reg(12)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111000011001100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => dataa_reg(12),
	datac => datab_reg(12),
	datad => \swap~3_combout\,
	combout => \ea[2]~0_combout\);

-- Location: LCCOMB_X25_Y30_N18
\eb[2]~0\ : cycloneive_lcell_comb
-- Equation(s):
-- \eb[2]~0_combout\ = (\swap~3_combout\ & ((dataa_reg(12)))) # (!\swap~3_combout\ & (datab_reg(12)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100110010101010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => datab_reg(12),
	datab => dataa_reg(12),
	datad => \swap~3_combout\,
	combout => \eb[2]~0_combout\);

-- Location: LCCOMB_X30_Y30_N28
\ea[1]~1\ : cycloneive_lcell_comb
-- Equation(s):
-- \ea[1]~1_combout\ = (\swap~3_combout\ & ((datab_reg(11)))) # (!\swap~3_combout\ & (dataa_reg(11)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111000010101010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => dataa_reg(11),
	datac => datab_reg(11),
	datad => \swap~3_combout\,
	combout => \ea[1]~1_combout\);

-- Location: LCCOMB_X30_Y30_N8
\eb[1]~1\ : cycloneive_lcell_comb
-- Equation(s):
-- \eb[1]~1_combout\ = (\swap~3_combout\ & (dataa_reg(11))) # (!\swap~3_combout\ & ((datab_reg(11))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1010101011110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => dataa_reg(11),
	datac => datab_reg(11),
	datad => \swap~3_combout\,
	combout => \eb[1]~1_combout\);

-- Location: LCCOMB_X30_Y30_N26
\eb[0]~2\ : cycloneive_lcell_comb
-- Equation(s):
-- \eb[0]~2_combout\ = (\swap~3_combout\ & ((dataa_reg(10)))) # (!\swap~3_combout\ & (datab_reg(10)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111000011001100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => datab_reg(10),
	datac => dataa_reg(10),
	datad => \swap~3_combout\,
	combout => \eb[0]~2_combout\);

-- Location: LCCOMB_X30_Y30_N22
\ea[0]~2\ : cycloneive_lcell_comb
-- Equation(s):
-- \ea[0]~2_combout\ = (\swap~3_combout\ & (datab_reg(10))) # (!\swap~3_combout\ & ((dataa_reg(10))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100110011110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => datab_reg(10),
	datac => dataa_reg(10),
	datad => \swap~3_combout\,
	combout => \ea[0]~2_combout\);

-- Location: LCCOMB_X30_Y30_N12
\delta[0]~0\ : cycloneive_lcell_comb
-- Equation(s):
-- \delta[0]~0_combout\ = (\eb[0]~2_combout\ & (\ea[0]~2_combout\ $ (VCC))) # (!\eb[0]~2_combout\ & ((\ea[0]~2_combout\) # (GND)))
-- \delta[0]~1\ = CARRY((\ea[0]~2_combout\) # (!\eb[0]~2_combout\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0110011011011101",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \eb[0]~2_combout\,
	datab => \ea[0]~2_combout\,
	datad => VCC,
	combout => \delta[0]~0_combout\,
	cout => \delta[0]~1\);

-- Location: LCCOMB_X30_Y30_N14
\delta[1]~2\ : cycloneive_lcell_comb
-- Equation(s):
-- \delta[1]~2_combout\ = (\ea[1]~1_combout\ & ((\eb[1]~1_combout\ & (!\delta[0]~1\)) # (!\eb[1]~1_combout\ & (\delta[0]~1\ & VCC)))) # (!\ea[1]~1_combout\ & ((\eb[1]~1_combout\ & ((\delta[0]~1\) # (GND))) # (!\eb[1]~1_combout\ & (!\delta[0]~1\))))
-- \delta[1]~3\ = CARRY((\ea[1]~1_combout\ & (\eb[1]~1_combout\ & !\delta[0]~1\)) # (!\ea[1]~1_combout\ & ((\eb[1]~1_combout\) # (!\delta[0]~1\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0110100101001101",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => \ea[1]~1_combout\,
	datab => \eb[1]~1_combout\,
	datad => VCC,
	cin => \delta[0]~1\,
	combout => \delta[1]~2_combout\,
	cout => \delta[1]~3\);

-- Location: LCCOMB_X30_Y30_N16
\delta[2]~4\ : cycloneive_lcell_comb
-- Equation(s):
-- \delta[2]~4_combout\ = ((\ea[2]~0_combout\ $ (\eb[2]~0_combout\ $ (\delta[1]~3\)))) # (GND)
-- \delta[2]~5\ = CARRY((\ea[2]~0_combout\ & ((!\delta[1]~3\) # (!\eb[2]~0_combout\))) # (!\ea[2]~0_combout\ & (!\eb[2]~0_combout\ & !\delta[1]~3\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1001011000101011",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => \ea[2]~0_combout\,
	datab => \eb[2]~0_combout\,
	datad => VCC,
	cin => \delta[1]~3\,
	combout => \delta[2]~4_combout\,
	cout => \delta[2]~5\);

-- Location: LCCOMB_X25_Y30_N20
\ea[4]~3\ : cycloneive_lcell_comb
-- Equation(s):
-- \ea[4]~3_combout\ = (\swap~3_combout\ & (datab_reg(14))) # (!\swap~3_combout\ & ((dataa_reg(14))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1010101011110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => datab_reg(14),
	datac => dataa_reg(14),
	datad => \swap~3_combout\,
	combout => \ea[4]~3_combout\);

-- Location: LCCOMB_X25_Y30_N16
\eb[4]~3\ : cycloneive_lcell_comb
-- Equation(s):
-- \eb[4]~3_combout\ = (\swap~3_combout\ & ((dataa_reg(14)))) # (!\swap~3_combout\ & (datab_reg(14)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111000010101010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => datab_reg(14),
	datac => dataa_reg(14),
	datad => \swap~3_combout\,
	combout => \eb[4]~3_combout\);

-- Location: LCCOMB_X25_Y30_N14
\ea[3]~4\ : cycloneive_lcell_comb
-- Equation(s):
-- \ea[3]~4_combout\ = (\swap~3_combout\ & ((datab_reg(13)))) # (!\swap~3_combout\ & (dataa_reg(13)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111000011001100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => dataa_reg(13),
	datac => datab_reg(13),
	datad => \swap~3_combout\,
	combout => \ea[3]~4_combout\);

-- Location: LCCOMB_X25_Y30_N10
\eb[3]~4\ : cycloneive_lcell_comb
-- Equation(s):
-- \eb[3]~4_combout\ = (\swap~3_combout\ & (dataa_reg(13))) # (!\swap~3_combout\ & ((datab_reg(13))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100110011110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => dataa_reg(13),
	datac => datab_reg(13),
	datad => \swap~3_combout\,
	combout => \eb[3]~4_combout\);

-- Location: LCCOMB_X30_Y30_N18
\delta[3]~6\ : cycloneive_lcell_comb
-- Equation(s):
-- \delta[3]~6_combout\ = (\ea[3]~4_combout\ & ((\eb[3]~4_combout\ & (!\delta[2]~5\)) # (!\eb[3]~4_combout\ & (\delta[2]~5\ & VCC)))) # (!\ea[3]~4_combout\ & ((\eb[3]~4_combout\ & ((\delta[2]~5\) # (GND))) # (!\eb[3]~4_combout\ & (!\delta[2]~5\))))
-- \delta[3]~7\ = CARRY((\ea[3]~4_combout\ & (\eb[3]~4_combout\ & !\delta[2]~5\)) # (!\ea[3]~4_combout\ & ((\eb[3]~4_combout\) # (!\delta[2]~5\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0110100101001101",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => \ea[3]~4_combout\,
	datab => \eb[3]~4_combout\,
	datad => VCC,
	cin => \delta[2]~5\,
	combout => \delta[3]~6_combout\,
	cout => \delta[3]~7\);

-- Location: LCCOMB_X30_Y30_N20
\delta[4]~8\ : cycloneive_lcell_comb
-- Equation(s):
-- \delta[4]~8_combout\ = \ea[4]~3_combout\ $ (\delta[3]~7\ $ (\eb[4]~3_combout\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1010010101011010",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => \ea[4]~3_combout\,
	datad => \eb[4]~3_combout\,
	cin => \delta[3]~7\,
	combout => \delta[4]~8_combout\);

-- Location: LCCOMB_X32_Y30_N12
\mb[10]~0\ : cycloneive_lcell_comb
-- Equation(s):
-- \mb[10]~0_combout\ = (\swap~3_combout\ & ((\WideNor0~4_combout\))) # (!\swap~3_combout\ & (\WideNor1~4_combout\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111000010101010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \WideNor1~4_combout\,
	datac => \WideNor0~4_combout\,
	datad => \swap~3_combout\,
	combout => \mb[10]~0_combout\);

-- Location: LCCOMB_X30_Y30_N10
\ShiftRight0~26\ : cycloneive_lcell_comb
-- Equation(s):
-- \ShiftRight0~26_combout\ = (!\delta[0]~0_combout\ & (\mb[10]~0_combout\ & !\delta[1]~2_combout\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000001000100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \delta[0]~0_combout\,
	datab => \mb[10]~0_combout\,
	datad => \delta[1]~2_combout\,
	combout => \ShiftRight0~26_combout\);

-- Location: LCCOMB_X32_Y30_N18
\ShiftRight0~27\ : cycloneive_lcell_comb
-- Equation(s):
-- \ShiftRight0~27_combout\ = (!\delta[2]~4_combout\ & (!\delta[4]~8_combout\ & (!\delta[3]~6_combout\ & \ShiftRight0~26_combout\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \delta[2]~4_combout\,
	datab => \delta[4]~8_combout\,
	datac => \delta[3]~6_combout\,
	datad => \ShiftRight0~26_combout\,
	combout => \ShiftRight0~27_combout\);

-- Location: FF_X32_Y30_N19
\mb_shift[10]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clock~inputclkctrl_outclk\,
	d => \ShiftRight0~27_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => mb_shift(10));

-- Location: IOIBUF_X9_Y34_N22
\datab[15]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_datab(15),
	o => \datab[15]~input_o\);

-- Location: FF_X21_Y30_N31
\datab_reg[15]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clock~inputclkctrl_outclk\,
	asdata => \datab[15]~input_o\,
	sload => VCC,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => datab_reg(15));

-- Location: IOIBUF_X20_Y34_N15
\dataa[15]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_dataa(15),
	o => \dataa[15]~input_o\);

-- Location: LCCOMB_X21_Y30_N16
\dataa_reg[15]~feeder\ : cycloneive_lcell_comb
-- Equation(s):
-- \dataa_reg[15]~feeder_combout\ = \dataa[15]~input_o\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => \dataa[15]~input_o\,
	combout => \dataa_reg[15]~feeder_combout\);

-- Location: FF_X21_Y30_N17
\dataa_reg[15]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clock~inputclkctrl_outclk\,
	d => \dataa_reg[15]~feeder_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => dataa_reg(15));

-- Location: LCCOMB_X29_Y30_N22
\sa~0\ : cycloneive_lcell_comb
-- Equation(s):
-- \sa~0_combout\ = (\swap~3_combout\ & (datab_reg(15))) # (!\swap~3_combout\ & ((dataa_reg(15))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1010111110100000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => datab_reg(15),
	datac => \swap~3_combout\,
	datad => dataa_reg(15),
	combout => \sa~0_combout\);

-- Location: FF_X29_Y30_N23
sa_reg : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clock~inputclkctrl_outclk\,
	d => \sa~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \sa_reg~q\);

-- Location: LCCOMB_X29_Y30_N4
\sb~0\ : cycloneive_lcell_comb
-- Equation(s):
-- \sb~0_combout\ = (\swap~3_combout\ & ((dataa_reg(15)))) # (!\swap~3_combout\ & (datab_reg(15)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111101000001010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => datab_reg(15),
	datac => \swap~3_combout\,
	datad => dataa_reg(15),
	combout => \sb~0_combout\);

-- Location: FF_X29_Y30_N5
sb_reg : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clock~inputclkctrl_outclk\,
	d => \sb~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \sb_reg~q\);

-- Location: LCCOMB_X32_Y30_N20
\Add1~5\ : cycloneive_lcell_comb
-- Equation(s):
-- \Add1~5_combout\ = mb_shift(10) $ (\sa_reg~q\ $ (\sb_reg~q\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100001100111100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => mb_shift(10),
	datac => \sa_reg~q\,
	datad => \sb_reg~q\,
	combout => \Add1~5_combout\);

-- Location: LCCOMB_X32_Y30_N4
\ShiftRight0~7\ : cycloneive_lcell_comb
-- Equation(s):
-- \ShiftRight0~7_combout\ = (\swap~3_combout\ & (dataa_reg(9))) # (!\swap~3_combout\ & ((datab_reg(9))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1010101011110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => dataa_reg(9),
	datac => datab_reg(9),
	datad => \swap~3_combout\,
	combout => \ShiftRight0~7_combout\);

-- Location: LCCOMB_X31_Y30_N22
\ShiftRight0~28\ : cycloneive_lcell_comb
-- Equation(s):
-- \ShiftRight0~28_combout\ = (!\delta[1]~2_combout\ & ((\delta[0]~0_combout\ & ((\mb[10]~0_combout\))) # (!\delta[0]~0_combout\ & (\ShiftRight0~7_combout\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000011100010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \ShiftRight0~7_combout\,
	datab => \delta[0]~0_combout\,
	datac => \mb[10]~0_combout\,
	datad => \delta[1]~2_combout\,
	combout => \ShiftRight0~28_combout\);

-- Location: LCCOMB_X32_Y30_N28
\ShiftRight0~29\ : cycloneive_lcell_comb
-- Equation(s):
-- \ShiftRight0~29_combout\ = (!\delta[2]~4_combout\ & (!\delta[4]~8_combout\ & (!\delta[3]~6_combout\ & \ShiftRight0~28_combout\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \delta[2]~4_combout\,
	datab => \delta[4]~8_combout\,
	datac => \delta[3]~6_combout\,
	datad => \ShiftRight0~28_combout\,
	combout => \ShiftRight0~29_combout\);

-- Location: FF_X32_Y30_N29
\mb_shift[9]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clock~inputclkctrl_outclk\,
	d => \ShiftRight0~29_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => mb_shift(9));

-- Location: LCCOMB_X32_Y30_N22
\Add1~6\ : cycloneive_lcell_comb
-- Equation(s):
-- \Add1~6_combout\ = mb_shift(9) $ (\sa_reg~q\ $ (\sb_reg~q\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100001100111100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => mb_shift(9),
	datac => \sa_reg~q\,
	datad => \sb_reg~q\,
	combout => \Add1~6_combout\);

-- Location: LCCOMB_X27_Y30_N0
\ma[9]~2\ : cycloneive_lcell_comb
-- Equation(s):
-- \ma[9]~2_combout\ = (\swap~3_combout\ & ((datab_reg(9)))) # (!\swap~3_combout\ & (dataa_reg(9)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111110000110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => \swap~3_combout\,
	datac => dataa_reg(9),
	datad => datab_reg(9),
	combout => \ma[9]~2_combout\);

-- Location: FF_X28_Y30_N3
\ma_reg[9]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clock~inputclkctrl_outclk\,
	asdata => \ma[9]~2_combout\,
	sload => VCC,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => ma_reg(9));

-- Location: LCCOMB_X26_Y30_N30
\ShiftRight0~8\ : cycloneive_lcell_comb
-- Equation(s):
-- \ShiftRight0~8_combout\ = (\swap~3_combout\ & ((dataa_reg(8)))) # (!\swap~3_combout\ & (datab_reg(8)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111000011001100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => datab_reg(8),
	datac => dataa_reg(8),
	datad => \swap~3_combout\,
	combout => \ShiftRight0~8_combout\);

-- Location: LCCOMB_X31_Y30_N4
\ShiftRight0~9\ : cycloneive_lcell_comb
-- Equation(s):
-- \ShiftRight0~9_combout\ = (\delta[0]~0_combout\ & (\ShiftRight0~7_combout\)) # (!\delta[0]~0_combout\ & ((\ShiftRight0~8_combout\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1010101011110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \ShiftRight0~7_combout\,
	datac => \ShiftRight0~8_combout\,
	datad => \delta[0]~0_combout\,
	combout => \ShiftRight0~9_combout\);

-- Location: LCCOMB_X31_Y30_N6
\ShiftRight0~10\ : cycloneive_lcell_comb
-- Equation(s):
-- \ShiftRight0~10_combout\ = (\delta[1]~2_combout\ & (!\delta[0]~0_combout\ & (\mb[10]~0_combout\))) # (!\delta[1]~2_combout\ & (((\ShiftRight0~9_combout\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0100010011110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \delta[0]~0_combout\,
	datab => \mb[10]~0_combout\,
	datac => \ShiftRight0~9_combout\,
	datad => \delta[1]~2_combout\,
	combout => \ShiftRight0~10_combout\);

-- Location: LCCOMB_X29_Y30_N8
\ShiftRight0~43\ : cycloneive_lcell_comb
-- Equation(s):
-- \ShiftRight0~43_combout\ = (!\delta[4]~8_combout\ & (!\delta[2]~4_combout\ & (\ShiftRight0~10_combout\ & !\delta[3]~6_combout\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000000010000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \delta[4]~8_combout\,
	datab => \delta[2]~4_combout\,
	datac => \ShiftRight0~10_combout\,
	datad => \delta[3]~6_combout\,
	combout => \ShiftRight0~43_combout\);

-- Location: FF_X29_Y30_N9
\mb_shift[8]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clock~inputclkctrl_outclk\,
	d => \ShiftRight0~43_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => mb_shift(8));

-- Location: LCCOMB_X29_Y30_N30
\Add1~7\ : cycloneive_lcell_comb
-- Equation(s):
-- \Add1~7_combout\ = \sb_reg~q\ $ (mb_shift(8) $ (\sa_reg~q\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100001100111100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => \sb_reg~q\,
	datac => mb_shift(8),
	datad => \sa_reg~q\,
	combout => \Add1~7_combout\);

-- Location: LCCOMB_X27_Y30_N12
\ma[8]~3\ : cycloneive_lcell_comb
-- Equation(s):
-- \ma[8]~3_combout\ = (\swap~3_combout\ & (datab_reg(8))) # (!\swap~3_combout\ & ((dataa_reg(8))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1011101110001000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => datab_reg(8),
	datab => \swap~3_combout\,
	datad => dataa_reg(8),
	combout => \ma[8]~3_combout\);

-- Location: FF_X28_Y30_N13
\ma_reg[8]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clock~inputclkctrl_outclk\,
	asdata => \ma[8]~3_combout\,
	sload => VCC,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => ma_reg(8));

-- Location: LCCOMB_X25_Y30_N22
\ma[7]~4\ : cycloneive_lcell_comb
-- Equation(s):
-- \ma[7]~4_combout\ = (\swap~3_combout\ & ((datab_reg(7)))) # (!\swap~3_combout\ & (dataa_reg(7)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111000011001100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => dataa_reg(7),
	datac => datab_reg(7),
	datad => \swap~3_combout\,
	combout => \ma[7]~4_combout\);

-- Location: FF_X28_Y30_N11
\ma_reg[7]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clock~inputclkctrl_outclk\,
	asdata => \ma[7]~4_combout\,
	sload => VCC,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => ma_reg(7));

-- Location: LCCOMB_X32_Y30_N26
\ShiftRight0~30\ : cycloneive_lcell_comb
-- Equation(s):
-- \ShiftRight0~30_combout\ = (\delta[0]~0_combout\ & (\mb[10]~0_combout\)) # (!\delta[0]~0_combout\ & ((\ShiftRight0~7_combout\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1010101011110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \mb[10]~0_combout\,
	datac => \ShiftRight0~7_combout\,
	datad => \delta[0]~0_combout\,
	combout => \ShiftRight0~30_combout\);

-- Location: LCCOMB_X26_Y30_N4
\ShiftRight0~22\ : cycloneive_lcell_comb
-- Equation(s):
-- \ShiftRight0~22_combout\ = (\swap~3_combout\ & (dataa_reg(7))) # (!\swap~3_combout\ & ((datab_reg(7))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1010101011001100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => dataa_reg(7),
	datab => datab_reg(7),
	datad => \swap~3_combout\,
	combout => \ShiftRight0~22_combout\);

-- Location: LCCOMB_X32_Y30_N24
\ShiftRight0~31\ : cycloneive_lcell_comb
-- Equation(s):
-- \ShiftRight0~31_combout\ = (\delta[0]~0_combout\ & (\ShiftRight0~8_combout\)) # (!\delta[0]~0_combout\ & ((\ShiftRight0~22_combout\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100110011110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => \ShiftRight0~8_combout\,
	datac => \ShiftRight0~22_combout\,
	datad => \delta[0]~0_combout\,
	combout => \ShiftRight0~31_combout\);

-- Location: LCCOMB_X32_Y30_N10
\ShiftRight0~32\ : cycloneive_lcell_comb
-- Equation(s):
-- \ShiftRight0~32_combout\ = (\delta[1]~2_combout\ & (\ShiftRight0~30_combout\)) # (!\delta[1]~2_combout\ & ((\ShiftRight0~31_combout\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1010111110100000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \ShiftRight0~30_combout\,
	datac => \delta[1]~2_combout\,
	datad => \ShiftRight0~31_combout\,
	combout => \ShiftRight0~32_combout\);

-- Location: LCCOMB_X32_Y30_N8
\ShiftRight0~44\ : cycloneive_lcell_comb
-- Equation(s):
-- \ShiftRight0~44_combout\ = (!\delta[2]~4_combout\ & (!\delta[4]~8_combout\ & (!\delta[3]~6_combout\ & \ShiftRight0~32_combout\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \delta[2]~4_combout\,
	datab => \delta[4]~8_combout\,
	datac => \delta[3]~6_combout\,
	datad => \ShiftRight0~32_combout\,
	combout => \ShiftRight0~44_combout\);

-- Location: FF_X32_Y30_N9
\mb_shift[7]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clock~inputclkctrl_outclk\,
	d => \ShiftRight0~44_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => mb_shift(7));

-- Location: LCCOMB_X29_Y30_N0
\Add1~8\ : cycloneive_lcell_comb
-- Equation(s):
-- \Add1~8_combout\ = \sa_reg~q\ $ (\sb_reg~q\ $ (mb_shift(7)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1010010101011010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \sa_reg~q\,
	datac => \sb_reg~q\,
	datad => mb_shift(7),
	combout => \Add1~8_combout\);

-- Location: LCCOMB_X27_Y30_N30
\ShiftRight0~23\ : cycloneive_lcell_comb
-- Equation(s):
-- \ShiftRight0~23_combout\ = (\swap~3_combout\ & ((dataa_reg(6)))) # (!\swap~3_combout\ & (datab_reg(6)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100101011001010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => datab_reg(6),
	datab => dataa_reg(6),
	datac => \swap~3_combout\,
	combout => \ShiftRight0~23_combout\);

-- Location: LCCOMB_X29_Y30_N10
\ShiftRight0~24\ : cycloneive_lcell_comb
-- Equation(s):
-- \ShiftRight0~24_combout\ = (\delta[0]~0_combout\ & (\ShiftRight0~22_combout\)) # (!\delta[0]~0_combout\ & ((\ShiftRight0~23_combout\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1010111110100000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \ShiftRight0~22_combout\,
	datac => \delta[0]~0_combout\,
	datad => \ShiftRight0~23_combout\,
	combout => \ShiftRight0~24_combout\);

-- Location: LCCOMB_X29_Y30_N12
\mb_shift[6]~2\ : cycloneive_lcell_comb
-- Equation(s):
-- \mb_shift[6]~2_combout\ = (\delta[1]~2_combout\ & (\ShiftRight0~9_combout\)) # (!\delta[1]~2_combout\ & ((\ShiftRight0~24_combout\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1011101110001000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \ShiftRight0~9_combout\,
	datab => \delta[1]~2_combout\,
	datad => \ShiftRight0~24_combout\,
	combout => \mb_shift[6]~2_combout\);

-- Location: LCCOMB_X30_Y30_N6
\ShiftRight0~18\ : cycloneive_lcell_comb
-- Equation(s):
-- \ShiftRight0~18_combout\ = (\delta[4]~8_combout\) # (\delta[3]~6_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111111001100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => \delta[4]~8_combout\,
	datad => \delta[3]~6_combout\,
	combout => \ShiftRight0~18_combout\);

-- Location: FF_X29_Y30_N13
\mb_shift[6]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clock~inputclkctrl_outclk\,
	d => \mb_shift[6]~2_combout\,
	asdata => \ShiftRight0~26_combout\,
	sclr => \ShiftRight0~18_combout\,
	sload => \delta[2]~4_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => mb_shift(6));

-- Location: LCCOMB_X29_Y30_N14
\Add1~9\ : cycloneive_lcell_comb
-- Equation(s):
-- \Add1~9_combout\ = \sa_reg~q\ $ (\sb_reg~q\ $ (mb_shift(6)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1010010101011010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \sa_reg~q\,
	datac => \sb_reg~q\,
	datad => mb_shift(6),
	combout => \Add1~9_combout\);

-- Location: LCCOMB_X27_Y30_N14
\ma[6]~5\ : cycloneive_lcell_comb
-- Equation(s):
-- \ma[6]~5_combout\ = (\swap~3_combout\ & (datab_reg(6))) # (!\swap~3_combout\ & ((dataa_reg(6))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1010110010101100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => datab_reg(6),
	datab => dataa_reg(6),
	datac => \swap~3_combout\,
	combout => \ma[6]~5_combout\);

-- Location: FF_X28_Y30_N25
\ma_reg[6]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clock~inputclkctrl_outclk\,
	asdata => \ma[6]~5_combout\,
	sload => VCC,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => ma_reg(6));

-- Location: LCCOMB_X27_Y30_N8
\ma[5]~6\ : cycloneive_lcell_comb
-- Equation(s):
-- \ma[5]~6_combout\ = (\swap~3_combout\ & ((datab_reg(5)))) # (!\swap~3_combout\ & (dataa_reg(5)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111101000001010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => dataa_reg(5),
	datac => \swap~3_combout\,
	datad => datab_reg(5),
	combout => \ma[5]~6_combout\);

-- Location: FF_X28_Y30_N17
\ma_reg[5]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clock~inputclkctrl_outclk\,
	asdata => \ma[5]~6_combout\,
	sload => VCC,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => ma_reg(5));

-- Location: LCCOMB_X27_Y30_N28
\ShiftRight0~19\ : cycloneive_lcell_comb
-- Equation(s):
-- \ShiftRight0~19_combout\ = (\swap~3_combout\ & (dataa_reg(5))) # (!\swap~3_combout\ & ((datab_reg(5))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1010111110100000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => dataa_reg(5),
	datac => \swap~3_combout\,
	datad => datab_reg(5),
	combout => \ShiftRight0~19_combout\);

-- Location: LCCOMB_X31_Y30_N28
\ShiftRight0~33\ : cycloneive_lcell_comb
-- Equation(s):
-- \ShiftRight0~33_combout\ = (\delta[0]~0_combout\ & (\ShiftRight0~23_combout\)) # (!\delta[0]~0_combout\ & ((\ShiftRight0~19_combout\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100110011110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => \ShiftRight0~23_combout\,
	datac => \ShiftRight0~19_combout\,
	datad => \delta[0]~0_combout\,
	combout => \ShiftRight0~33_combout\);

-- Location: LCCOMB_X31_Y30_N20
\mb_shift[5]~1\ : cycloneive_lcell_comb
-- Equation(s):
-- \mb_shift[5]~1_combout\ = (\delta[1]~2_combout\ & ((\ShiftRight0~31_combout\))) # (!\delta[1]~2_combout\ & (\ShiftRight0~33_combout\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1110111001000100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \delta[1]~2_combout\,
	datab => \ShiftRight0~33_combout\,
	datad => \ShiftRight0~31_combout\,
	combout => \mb_shift[5]~1_combout\);

-- Location: FF_X31_Y30_N21
\mb_shift[5]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clock~inputclkctrl_outclk\,
	d => \mb_shift[5]~1_combout\,
	asdata => \ShiftRight0~28_combout\,
	sclr => \ShiftRight0~18_combout\,
	sload => \delta[2]~4_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => mb_shift(5));

-- Location: LCCOMB_X32_Y30_N2
\Add1~10\ : cycloneive_lcell_comb
-- Equation(s):
-- \Add1~10_combout\ = mb_shift(5) $ (\sb_reg~q\ $ (\sa_reg~q\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100001100111100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => mb_shift(5),
	datac => \sb_reg~q\,
	datad => \sa_reg~q\,
	combout => \Add1~10_combout\);

-- Location: LCCOMB_X25_Y30_N0
\ma[4]~7\ : cycloneive_lcell_comb
-- Equation(s):
-- \ma[4]~7_combout\ = (\swap~3_combout\ & ((datab_reg(4)))) # (!\swap~3_combout\ & (dataa_reg(4)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111000011001100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => dataa_reg(4),
	datac => datab_reg(4),
	datad => \swap~3_combout\,
	combout => \ma[4]~7_combout\);

-- Location: FF_X28_Y30_N21
\ma_reg[4]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clock~inputclkctrl_outclk\,
	asdata => \ma[4]~7_combout\,
	sload => VCC,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => ma_reg(4));

-- Location: LCCOMB_X31_Y30_N2
\ShiftRight0~20\ : cycloneive_lcell_comb
-- Equation(s):
-- \ShiftRight0~20_combout\ = (\swap~3_combout\ & (dataa_reg(4))) # (!\swap~3_combout\ & ((datab_reg(4))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100110011110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => dataa_reg(4),
	datac => datab_reg(4),
	datad => \swap~3_combout\,
	combout => \ShiftRight0~20_combout\);

-- Location: LCCOMB_X31_Y30_N12
\ShiftRight0~21\ : cycloneive_lcell_comb
-- Equation(s):
-- \ShiftRight0~21_combout\ = (\delta[0]~0_combout\ & ((\ShiftRight0~19_combout\))) # (!\delta[0]~0_combout\ & (\ShiftRight0~20_combout\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111000011001100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => \ShiftRight0~20_combout\,
	datac => \ShiftRight0~19_combout\,
	datad => \delta[0]~0_combout\,
	combout => \ShiftRight0~21_combout\);

-- Location: LCCOMB_X29_Y30_N26
\mb_shift[4]~0\ : cycloneive_lcell_comb
-- Equation(s):
-- \mb_shift[4]~0_combout\ = (\delta[1]~2_combout\ & ((\ShiftRight0~24_combout\))) # (!\delta[1]~2_combout\ & (\ShiftRight0~21_combout\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1110111000100010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \ShiftRight0~21_combout\,
	datab => \delta[1]~2_combout\,
	datad => \ShiftRight0~24_combout\,
	combout => \mb_shift[4]~0_combout\);

-- Location: FF_X29_Y30_N27
\mb_shift[4]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clock~inputclkctrl_outclk\,
	d => \mb_shift[4]~0_combout\,
	asdata => \ShiftRight0~10_combout\,
	sclr => \ShiftRight0~18_combout\,
	sload => \delta[2]~4_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => mb_shift(4));

-- Location: LCCOMB_X29_Y30_N28
\Add1~11\ : cycloneive_lcell_comb
-- Equation(s):
-- \Add1~11_combout\ = \sb_reg~q\ $ (mb_shift(4) $ (\sa_reg~q\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100001100111100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => \sb_reg~q\,
	datac => mb_shift(4),
	datad => \sa_reg~q\,
	combout => \Add1~11_combout\);

-- Location: LCCOMB_X27_Y30_N26
\ma[3]~8\ : cycloneive_lcell_comb
-- Equation(s):
-- \ma[3]~8_combout\ = (\swap~3_combout\ & (datab_reg(3))) # (!\swap~3_combout\ & ((dataa_reg(3))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1010110010101100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => datab_reg(3),
	datab => dataa_reg(3),
	datac => \swap~3_combout\,
	combout => \ma[3]~8_combout\);

-- Location: FF_X28_Y30_N27
\ma_reg[3]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clock~inputclkctrl_outclk\,
	asdata => \ma[3]~8_combout\,
	sload => VCC,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => ma_reg(3));

-- Location: LCCOMB_X27_Y30_N22
\ShiftRight0~11\ : cycloneive_lcell_comb
-- Equation(s):
-- \ShiftRight0~11_combout\ = (\swap~3_combout\ & ((dataa_reg(3)))) # (!\swap~3_combout\ & (datab_reg(3)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111101000001010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => datab_reg(3),
	datac => \swap~3_combout\,
	datad => dataa_reg(3),
	combout => \ShiftRight0~11_combout\);

-- Location: LCCOMB_X31_Y30_N30
\ShiftRight0~34\ : cycloneive_lcell_comb
-- Equation(s):
-- \ShiftRight0~34_combout\ = (\delta[0]~0_combout\ & (\ShiftRight0~20_combout\)) # (!\delta[0]~0_combout\ & ((\ShiftRight0~11_combout\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100110011110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => \ShiftRight0~20_combout\,
	datac => \ShiftRight0~11_combout\,
	datad => \delta[0]~0_combout\,
	combout => \ShiftRight0~34_combout\);

-- Location: LCCOMB_X32_Y30_N16
\mb_shift[3]~3\ : cycloneive_lcell_comb
-- Equation(s):
-- \mb_shift[3]~3_combout\ = (\delta[1]~2_combout\ & ((\ShiftRight0~33_combout\))) # (!\delta[1]~2_combout\ & (\ShiftRight0~34_combout\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1110111001000100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \delta[1]~2_combout\,
	datab => \ShiftRight0~34_combout\,
	datad => \ShiftRight0~33_combout\,
	combout => \mb_shift[3]~3_combout\);

-- Location: FF_X32_Y30_N17
\mb_shift[3]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clock~inputclkctrl_outclk\,
	d => \mb_shift[3]~3_combout\,
	asdata => \ShiftRight0~32_combout\,
	sclr => \ShiftRight0~18_combout\,
	sload => \delta[2]~4_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => mb_shift(3));

-- Location: LCCOMB_X29_Y30_N18
\Add1~12\ : cycloneive_lcell_comb
-- Equation(s):
-- \Add1~12_combout\ = \sb_reg~q\ $ (\sa_reg~q\ $ (mb_shift(3)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100001100111100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => \sb_reg~q\,
	datac => \sa_reg~q\,
	datad => mb_shift(3),
	combout => \Add1~12_combout\);

-- Location: LCCOMB_X25_Y30_N28
\ma[2]~9\ : cycloneive_lcell_comb
-- Equation(s):
-- \ma[2]~9_combout\ = (\swap~3_combout\ & (datab_reg(2))) # (!\swap~3_combout\ & ((dataa_reg(2))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1010101011001100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => datab_reg(2),
	datab => dataa_reg(2),
	datad => \swap~3_combout\,
	combout => \ma[2]~9_combout\);

-- Location: FF_X28_Y30_N19
\ma_reg[2]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clock~inputclkctrl_outclk\,
	asdata => \ma[2]~9_combout\,
	sload => VCC,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => ma_reg(2));

-- Location: LCCOMB_X25_Y30_N8
\ShiftRight0~12\ : cycloneive_lcell_comb
-- Equation(s):
-- \ShiftRight0~12_combout\ = (\swap~3_combout\ & ((dataa_reg(2)))) # (!\swap~3_combout\ & (datab_reg(2)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111000010101010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => datab_reg(2),
	datac => dataa_reg(2),
	datad => \swap~3_combout\,
	combout => \ShiftRight0~12_combout\);

-- Location: LCCOMB_X30_Y30_N0
\ShiftRight0~13\ : cycloneive_lcell_comb
-- Equation(s):
-- \ShiftRight0~13_combout\ = (\delta[0]~0_combout\ & (\ShiftRight0~11_combout\)) # (!\delta[0]~0_combout\ & ((\ShiftRight0~12_combout\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1010101011110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \ShiftRight0~11_combout\,
	datac => \ShiftRight0~12_combout\,
	datad => \delta[0]~0_combout\,
	combout => \ShiftRight0~13_combout\);

-- Location: LCCOMB_X30_Y30_N4
\ShiftRight0~35\ : cycloneive_lcell_comb
-- Equation(s):
-- \ShiftRight0~35_combout\ = (!\delta[3]~6_combout\ & ((\delta[1]~2_combout\ & ((\ShiftRight0~21_combout\))) # (!\delta[1]~2_combout\ & (\ShiftRight0~13_combout\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000011100100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \delta[1]~2_combout\,
	datab => \ShiftRight0~13_combout\,
	datac => \ShiftRight0~21_combout\,
	datad => \delta[3]~6_combout\,
	combout => \ShiftRight0~35_combout\);

-- Location: LCCOMB_X30_Y30_N2
\ShiftRight0~6\ : cycloneive_lcell_comb
-- Equation(s):
-- \ShiftRight0~6_combout\ = (!\delta[2]~4_combout\ & !\delta[4]~8_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000000110011",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => \delta[2]~4_combout\,
	datad => \delta[4]~8_combout\,
	combout => \ShiftRight0~6_combout\);

-- Location: LCCOMB_X30_Y30_N30
\ShiftRight0~36\ : cycloneive_lcell_comb
-- Equation(s):
-- \ShiftRight0~36_combout\ = (\ShiftRight0~6_combout\ & ((\ShiftRight0~35_combout\) # ((\ShiftRight0~26_combout\ & \delta[3]~6_combout\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111100000000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \ShiftRight0~26_combout\,
	datab => \delta[3]~6_combout\,
	datac => \ShiftRight0~35_combout\,
	datad => \ShiftRight0~6_combout\,
	combout => \ShiftRight0~36_combout\);

-- Location: LCCOMB_X30_Y30_N24
\ShiftRight0~37\ : cycloneive_lcell_comb
-- Equation(s):
-- \ShiftRight0~37_combout\ = (\ShiftRight0~36_combout\) # ((!\ShiftRight0~18_combout\ & (\delta[2]~4_combout\ & \mb_shift[6]~2_combout\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111010011110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \ShiftRight0~18_combout\,
	datab => \delta[2]~4_combout\,
	datac => \ShiftRight0~36_combout\,
	datad => \mb_shift[6]~2_combout\,
	combout => \ShiftRight0~37_combout\);

-- Location: FF_X30_Y30_N25
\mb_shift[2]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clock~inputclkctrl_outclk\,
	d => \ShiftRight0~37_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => mb_shift(2));

-- Location: LCCOMB_X29_Y30_N24
\Add1~13\ : cycloneive_lcell_comb
-- Equation(s):
-- \Add1~13_combout\ = \sa_reg~q\ $ (\sb_reg~q\ $ (mb_shift(2)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1010010101011010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \sa_reg~q\,
	datac => \sb_reg~q\,
	datad => mb_shift(2),
	combout => \Add1~13_combout\);

-- Location: LCCOMB_X31_Y30_N26
\ShiftRight0~15\ : cycloneive_lcell_comb
-- Equation(s):
-- \ShiftRight0~15_combout\ = (\swap~3_combout\ & ((dataa_reg(1)))) # (!\swap~3_combout\ & (datab_reg(1)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100110010101010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => datab_reg(1),
	datab => dataa_reg(1),
	datad => \swap~3_combout\,
	combout => \ShiftRight0~15_combout\);

-- Location: LCCOMB_X31_Y30_N24
\ShiftRight0~38\ : cycloneive_lcell_comb
-- Equation(s):
-- \ShiftRight0~38_combout\ = (\delta[0]~0_combout\ & (\ShiftRight0~12_combout\)) # (!\delta[0]~0_combout\ & ((\ShiftRight0~15_combout\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1010101011110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \ShiftRight0~12_combout\,
	datac => \ShiftRight0~15_combout\,
	datad => \delta[0]~0_combout\,
	combout => \ShiftRight0~38_combout\);

-- Location: LCCOMB_X31_Y30_N14
\ShiftRight0~39\ : cycloneive_lcell_comb
-- Equation(s):
-- \ShiftRight0~39_combout\ = (!\delta[3]~6_combout\ & ((\delta[1]~2_combout\ & ((\ShiftRight0~34_combout\))) # (!\delta[1]~2_combout\ & (\ShiftRight0~38_combout\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000011100100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \delta[1]~2_combout\,
	datab => \ShiftRight0~38_combout\,
	datac => \ShiftRight0~34_combout\,
	datad => \delta[3]~6_combout\,
	combout => \ShiftRight0~39_combout\);

-- Location: LCCOMB_X31_Y30_N16
\ShiftRight0~40\ : cycloneive_lcell_comb
-- Equation(s):
-- \ShiftRight0~40_combout\ = (\ShiftRight0~6_combout\ & ((\ShiftRight0~39_combout\) # ((\ShiftRight0~28_combout\ & \delta[3]~6_combout\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111100000000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \ShiftRight0~28_combout\,
	datab => \delta[3]~6_combout\,
	datac => \ShiftRight0~39_combout\,
	datad => \ShiftRight0~6_combout\,
	combout => \ShiftRight0~40_combout\);

-- Location: LCCOMB_X31_Y30_N10
\ShiftRight0~41\ : cycloneive_lcell_comb
-- Equation(s):
-- \ShiftRight0~41_combout\ = (\ShiftRight0~40_combout\) # ((\delta[2]~4_combout\ & (\mb_shift[5]~1_combout\ & !\ShiftRight0~18_combout\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100001000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \delta[2]~4_combout\,
	datab => \mb_shift[5]~1_combout\,
	datac => \ShiftRight0~18_combout\,
	datad => \ShiftRight0~40_combout\,
	combout => \ShiftRight0~41_combout\);

-- Location: FF_X31_Y30_N11
\mb_shift[1]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clock~inputclkctrl_outclk\,
	d => \ShiftRight0~41_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => mb_shift(1));

-- Location: LCCOMB_X29_Y30_N6
\Add1~14\ : cycloneive_lcell_comb
-- Equation(s):
-- \Add1~14_combout\ = \sb_reg~q\ $ (\sa_reg~q\ $ (mb_shift(1)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100001100111100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => \sb_reg~q\,
	datac => \sa_reg~q\,
	datad => mb_shift(1),
	combout => \Add1~14_combout\);

-- Location: LCCOMB_X25_Y30_N26
\ma[1]~10\ : cycloneive_lcell_comb
-- Equation(s):
-- \ma[1]~10_combout\ = (\swap~3_combout\ & ((datab_reg(1)))) # (!\swap~3_combout\ & (dataa_reg(1)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111000010101010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => dataa_reg(1),
	datac => datab_reg(1),
	datad => \swap~3_combout\,
	combout => \ma[1]~10_combout\);

-- Location: FF_X28_Y30_N9
\ma_reg[1]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clock~inputclkctrl_outclk\,
	asdata => \ma[1]~10_combout\,
	sload => VCC,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => ma_reg(1));

-- Location: LCCOMB_X31_Y30_N18
\ShiftRight0~42\ : cycloneive_lcell_comb
-- Equation(s):
-- \ShiftRight0~42_combout\ = (\delta[0]~0_combout\ & ((\swap~3_combout\ & ((dataa_reg(1)))) # (!\swap~3_combout\ & (datab_reg(1)))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100101000000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => datab_reg(1),
	datab => dataa_reg(1),
	datac => \swap~3_combout\,
	datad => \delta[0]~0_combout\,
	combout => \ShiftRight0~42_combout\);

-- Location: LCCOMB_X31_Y30_N8
\ShiftRight0~14\ : cycloneive_lcell_comb
-- Equation(s):
-- \ShiftRight0~14_combout\ = (!\delta[0]~0_combout\ & ((\swap~3_combout\ & (dataa_reg(0))) # (!\swap~3_combout\ & ((datab_reg(0))))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000010101100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => dataa_reg(0),
	datab => datab_reg(0),
	datac => \swap~3_combout\,
	datad => \delta[0]~0_combout\,
	combout => \ShiftRight0~14_combout\);

-- Location: LCCOMB_X31_Y30_N0
\ShiftRight0~16\ : cycloneive_lcell_comb
-- Equation(s):
-- \ShiftRight0~16_combout\ = (\delta[1]~2_combout\ & (\ShiftRight0~13_combout\)) # (!\delta[1]~2_combout\ & (((\ShiftRight0~42_combout\) # (\ShiftRight0~14_combout\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1010101011111100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \ShiftRight0~13_combout\,
	datab => \ShiftRight0~42_combout\,
	datac => \ShiftRight0~14_combout\,
	datad => \delta[1]~2_combout\,
	combout => \ShiftRight0~16_combout\);

-- Location: LCCOMB_X29_Y30_N16
\ShiftRight0~17\ : cycloneive_lcell_comb
-- Equation(s):
-- \ShiftRight0~17_combout\ = (\ShiftRight0~6_combout\ & ((\delta[3]~6_combout\ & ((\ShiftRight0~10_combout\))) # (!\delta[3]~6_combout\ & (\ShiftRight0~16_combout\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1110010000000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \delta[3]~6_combout\,
	datab => \ShiftRight0~16_combout\,
	datac => \ShiftRight0~10_combout\,
	datad => \ShiftRight0~6_combout\,
	combout => \ShiftRight0~17_combout\);

-- Location: LCCOMB_X29_Y30_N20
\ShiftRight0~25\ : cycloneive_lcell_comb
-- Equation(s):
-- \ShiftRight0~25_combout\ = (\ShiftRight0~17_combout\) # ((!\ShiftRight0~18_combout\ & (\delta[2]~4_combout\ & \mb_shift[4]~0_combout\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111101000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \ShiftRight0~18_combout\,
	datab => \delta[2]~4_combout\,
	datac => \mb_shift[4]~0_combout\,
	datad => \ShiftRight0~17_combout\,
	combout => \ShiftRight0~25_combout\);

-- Location: FF_X29_Y30_N21
\mb_shift[0]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clock~inputclkctrl_outclk\,
	d => \ShiftRight0~25_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => mb_shift(0));

-- Location: LCCOMB_X29_Y30_N2
\Add1~0\ : cycloneive_lcell_comb
-- Equation(s):
-- \Add1~0_combout\ = \sb_reg~q\ $ (\sa_reg~q\ $ (mb_shift(0)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100001100111100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => \sb_reg~q\,
	datac => \sa_reg~q\,
	datad => mb_shift(0),
	combout => \Add1~0_combout\);

-- Location: LCCOMB_X27_Y30_N16
\ma[0]~0\ : cycloneive_lcell_comb
-- Equation(s):
-- \ma[0]~0_combout\ = (\swap~3_combout\ & (datab_reg(0))) # (!\swap~3_combout\ & ((dataa_reg(0))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1011101110001000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => datab_reg(0),
	datab => \swap~3_combout\,
	datad => dataa_reg(0),
	combout => \ma[0]~0_combout\);

-- Location: FF_X28_Y30_N29
\ma_reg[0]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clock~inputclkctrl_outclk\,
	asdata => \ma[0]~0_combout\,
	sload => VCC,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => ma_reg(0));

-- Location: LCCOMB_X28_Y30_N2
\Add1~2\ : cycloneive_lcell_comb
-- Equation(s):
-- \Add1~2_cout\ = CARRY(\sb_reg~q\ $ (\sa_reg~q\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000001100110",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \sb_reg~q\,
	datab => \sa_reg~q\,
	datad => VCC,
	cout => \Add1~2_cout\);

-- Location: LCCOMB_X28_Y30_N4
\Add1~3\ : cycloneive_lcell_comb
-- Equation(s):
-- \Add1~3_combout\ = (\Add1~0_combout\ & ((ma_reg(0) & (\Add1~2_cout\ & VCC)) # (!ma_reg(0) & (!\Add1~2_cout\)))) # (!\Add1~0_combout\ & ((ma_reg(0) & (!\Add1~2_cout\)) # (!ma_reg(0) & ((\Add1~2_cout\) # (GND)))))
-- \Add1~4\ = CARRY((\Add1~0_combout\ & (!ma_reg(0) & !\Add1~2_cout\)) # (!\Add1~0_combout\ & ((!\Add1~2_cout\) # (!ma_reg(0)))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1001011000010111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => \Add1~0_combout\,
	datab => ma_reg(0),
	datad => VCC,
	cin => \Add1~2_cout\,
	combout => \Add1~3_combout\,
	cout => \Add1~4\);

-- Location: LCCOMB_X28_Y30_N6
\Add1~15\ : cycloneive_lcell_comb
-- Equation(s):
-- \Add1~15_combout\ = ((\Add1~14_combout\ $ (ma_reg(1) $ (!\Add1~4\)))) # (GND)
-- \Add1~16\ = CARRY((\Add1~14_combout\ & ((ma_reg(1)) # (!\Add1~4\))) # (!\Add1~14_combout\ & (ma_reg(1) & !\Add1~4\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0110100110001110",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => \Add1~14_combout\,
	datab => ma_reg(1),
	datad => VCC,
	cin => \Add1~4\,
	combout => \Add1~15_combout\,
	cout => \Add1~16\);

-- Location: LCCOMB_X28_Y30_N8
\Add1~17\ : cycloneive_lcell_comb
-- Equation(s):
-- \Add1~17_combout\ = (ma_reg(2) & ((\Add1~13_combout\ & (\Add1~16\ & VCC)) # (!\Add1~13_combout\ & (!\Add1~16\)))) # (!ma_reg(2) & ((\Add1~13_combout\ & (!\Add1~16\)) # (!\Add1~13_combout\ & ((\Add1~16\) # (GND)))))
-- \Add1~18\ = CARRY((ma_reg(2) & (!\Add1~13_combout\ & !\Add1~16\)) # (!ma_reg(2) & ((!\Add1~16\) # (!\Add1~13_combout\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1001011000010111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => ma_reg(2),
	datab => \Add1~13_combout\,
	datad => VCC,
	cin => \Add1~16\,
	combout => \Add1~17_combout\,
	cout => \Add1~18\);

-- Location: LCCOMB_X28_Y30_N10
\Add1~19\ : cycloneive_lcell_comb
-- Equation(s):
-- \Add1~19_combout\ = ((ma_reg(3) $ (\Add1~12_combout\ $ (!\Add1~18\)))) # (GND)
-- \Add1~20\ = CARRY((ma_reg(3) & ((\Add1~12_combout\) # (!\Add1~18\))) # (!ma_reg(3) & (\Add1~12_combout\ & !\Add1~18\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0110100110001110",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => ma_reg(3),
	datab => \Add1~12_combout\,
	datad => VCC,
	cin => \Add1~18\,
	combout => \Add1~19_combout\,
	cout => \Add1~20\);

-- Location: LCCOMB_X28_Y30_N12
\Add1~21\ : cycloneive_lcell_comb
-- Equation(s):
-- \Add1~21_combout\ = (ma_reg(4) & ((\Add1~11_combout\ & (\Add1~20\ & VCC)) # (!\Add1~11_combout\ & (!\Add1~20\)))) # (!ma_reg(4) & ((\Add1~11_combout\ & (!\Add1~20\)) # (!\Add1~11_combout\ & ((\Add1~20\) # (GND)))))
-- \Add1~22\ = CARRY((ma_reg(4) & (!\Add1~11_combout\ & !\Add1~20\)) # (!ma_reg(4) & ((!\Add1~20\) # (!\Add1~11_combout\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1001011000010111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => ma_reg(4),
	datab => \Add1~11_combout\,
	datad => VCC,
	cin => \Add1~20\,
	combout => \Add1~21_combout\,
	cout => \Add1~22\);

-- Location: LCCOMB_X28_Y30_N14
\Add1~23\ : cycloneive_lcell_comb
-- Equation(s):
-- \Add1~23_combout\ = ((ma_reg(5) $ (\Add1~10_combout\ $ (!\Add1~22\)))) # (GND)
-- \Add1~24\ = CARRY((ma_reg(5) & ((\Add1~10_combout\) # (!\Add1~22\))) # (!ma_reg(5) & (\Add1~10_combout\ & !\Add1~22\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0110100110001110",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => ma_reg(5),
	datab => \Add1~10_combout\,
	datad => VCC,
	cin => \Add1~22\,
	combout => \Add1~23_combout\,
	cout => \Add1~24\);

-- Location: LCCOMB_X28_Y30_N16
\Add1~25\ : cycloneive_lcell_comb
-- Equation(s):
-- \Add1~25_combout\ = (\Add1~9_combout\ & ((ma_reg(6) & (\Add1~24\ & VCC)) # (!ma_reg(6) & (!\Add1~24\)))) # (!\Add1~9_combout\ & ((ma_reg(6) & (!\Add1~24\)) # (!ma_reg(6) & ((\Add1~24\) # (GND)))))
-- \Add1~26\ = CARRY((\Add1~9_combout\ & (!ma_reg(6) & !\Add1~24\)) # (!\Add1~9_combout\ & ((!\Add1~24\) # (!ma_reg(6)))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1001011000010111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => \Add1~9_combout\,
	datab => ma_reg(6),
	datad => VCC,
	cin => \Add1~24\,
	combout => \Add1~25_combout\,
	cout => \Add1~26\);

-- Location: LCCOMB_X28_Y30_N18
\Add1~27\ : cycloneive_lcell_comb
-- Equation(s):
-- \Add1~27_combout\ = ((ma_reg(7) $ (\Add1~8_combout\ $ (!\Add1~26\)))) # (GND)
-- \Add1~28\ = CARRY((ma_reg(7) & ((\Add1~8_combout\) # (!\Add1~26\))) # (!ma_reg(7) & (\Add1~8_combout\ & !\Add1~26\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0110100110001110",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => ma_reg(7),
	datab => \Add1~8_combout\,
	datad => VCC,
	cin => \Add1~26\,
	combout => \Add1~27_combout\,
	cout => \Add1~28\);

-- Location: LCCOMB_X28_Y30_N20
\Add1~29\ : cycloneive_lcell_comb
-- Equation(s):
-- \Add1~29_combout\ = (\Add1~7_combout\ & ((ma_reg(8) & (\Add1~28\ & VCC)) # (!ma_reg(8) & (!\Add1~28\)))) # (!\Add1~7_combout\ & ((ma_reg(8) & (!\Add1~28\)) # (!ma_reg(8) & ((\Add1~28\) # (GND)))))
-- \Add1~30\ = CARRY((\Add1~7_combout\ & (!ma_reg(8) & !\Add1~28\)) # (!\Add1~7_combout\ & ((!\Add1~28\) # (!ma_reg(8)))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1001011000010111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => \Add1~7_combout\,
	datab => ma_reg(8),
	datad => VCC,
	cin => \Add1~28\,
	combout => \Add1~29_combout\,
	cout => \Add1~30\);

-- Location: LCCOMB_X28_Y30_N22
\Add1~31\ : cycloneive_lcell_comb
-- Equation(s):
-- \Add1~31_combout\ = ((\Add1~6_combout\ $ (ma_reg(9) $ (!\Add1~30\)))) # (GND)
-- \Add1~32\ = CARRY((\Add1~6_combout\ & ((ma_reg(9)) # (!\Add1~30\))) # (!\Add1~6_combout\ & (ma_reg(9) & !\Add1~30\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0110100110001110",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => \Add1~6_combout\,
	datab => ma_reg(9),
	datad => VCC,
	cin => \Add1~30\,
	combout => \Add1~31_combout\,
	cout => \Add1~32\);

-- Location: LCCOMB_X28_Y30_N24
\Add1~33\ : cycloneive_lcell_comb
-- Equation(s):
-- \Add1~33_combout\ = (ma_reg(10) & ((\Add1~5_combout\ & (\Add1~32\ & VCC)) # (!\Add1~5_combout\ & (!\Add1~32\)))) # (!ma_reg(10) & ((\Add1~5_combout\ & (!\Add1~32\)) # (!\Add1~5_combout\ & ((\Add1~32\) # (GND)))))
-- \Add1~34\ = CARRY((ma_reg(10) & (!\Add1~5_combout\ & !\Add1~32\)) # (!ma_reg(10) & ((!\Add1~32\) # (!\Add1~5_combout\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1001011000010111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => ma_reg(10),
	datab => \Add1~5_combout\,
	datad => VCC,
	cin => \Add1~32\,
	combout => \Add1~33_combout\,
	cout => \Add1~34\);

-- Location: LCCOMB_X28_Y30_N0
\zc|node[1][10]~2\ : cycloneive_lcell_comb
-- Equation(s):
-- \zc|node[1][10]~2_combout\ = (!\Add1~21_combout\ & (!\Add1~25_combout\ & (!\Add1~23_combout\ & !\Add1~27_combout\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000000000001",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \Add1~21_combout\,
	datab => \Add1~25_combout\,
	datac => \Add1~23_combout\,
	datad => \Add1~27_combout\,
	combout => \zc|node[1][10]~2_combout\);

-- Location: LCCOMB_X27_Y31_N22
\zc|node[2][10]~3\ : cycloneive_lcell_comb
-- Equation(s):
-- \zc|node[2][10]~3_combout\ = (!\Add1~31_combout\ & ((\Add1~25_combout\) # ((\Add1~17_combout\ & \zc|node[1][10]~2_combout\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000111000001100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \Add1~17_combout\,
	datab => \Add1~25_combout\,
	datac => \Add1~31_combout\,
	datad => \zc|node[1][10]~2_combout\,
	combout => \zc|node[2][10]~3_combout\);

-- Location: LCCOMB_X28_Y30_N26
\Add1~35\ : cycloneive_lcell_comb
-- Equation(s):
-- \Add1~35_combout\ = \sb_reg~q\ $ (\Add1~34\ $ (!\sa_reg~q\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0101101010100101",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => \sb_reg~q\,
	datad => \sa_reg~q\,
	cin => \Add1~34\,
	combout => \Add1~35_combout\);

-- Location: LCCOMB_X27_Y31_N20
\zc|node[2][10]~4\ : cycloneive_lcell_comb
-- Equation(s):
-- \zc|node[2][10]~4_combout\ = (\Add1~33_combout\) # ((!\Add1~29_combout\ & (\zc|node[2][10]~3_combout\ & !\Add1~35_combout\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1010101010111010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \Add1~33_combout\,
	datab => \Add1~29_combout\,
	datac => \zc|node[2][10]~3_combout\,
	datad => \Add1~35_combout\,
	combout => \zc|node[2][10]~4_combout\);

-- Location: LCCOMB_X27_Y31_N26
\zc|node[2][11]~10\ : cycloneive_lcell_comb
-- Equation(s):
-- \zc|node[2][11]~10_combout\ = (!\Add1~31_combout\ & !\Add1~33_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000001100000011",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => \Add1~31_combout\,
	datac => \Add1~33_combout\,
	combout => \zc|node[2][11]~10_combout\);

-- Location: LCCOMB_X28_Y30_N28
\zc|node[1][11]~7\ : cycloneive_lcell_comb
-- Equation(s):
-- \zc|node[1][11]~7_combout\ = (\Add1~19_combout\ & !\Add1~29_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000010101010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \Add1~19_combout\,
	datad => \Add1~29_combout\,
	combout => \zc|node[1][11]~7_combout\);

-- Location: LCCOMB_X28_Y30_N30
\zc|node[1][11]~8\ : cycloneive_lcell_comb
-- Equation(s):
-- \zc|node[1][11]~8_combout\ = (!\Add1~31_combout\ & (\zc|node[1][11]~7_combout\ & (!\Add1~33_combout\ & \zc|node[1][10]~2_combout\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000010000000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \Add1~31_combout\,
	datab => \zc|node[1][11]~7_combout\,
	datac => \Add1~33_combout\,
	datad => \zc|node[1][10]~2_combout\,
	combout => \zc|node[1][11]~8_combout\);

-- Location: LCCOMB_X27_Y31_N24
\zc|last~0\ : cycloneive_lcell_comb
-- Equation(s):
-- \zc|last~0_combout\ = (!\zc|node[1][11]~8_combout\ & (((\Add1~29_combout\) # (!\zc|node[2][11]~10_combout\)) # (!\Add1~27_combout\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000011011111",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \Add1~27_combout\,
	datab => \Add1~29_combout\,
	datac => \zc|node[2][11]~10_combout\,
	datad => \zc|node[1][11]~8_combout\,
	combout => \zc|last~0_combout\);

-- Location: LCCOMB_X27_Y31_N28
\zc|result[10]~0\ : cycloneive_lcell_comb
-- Equation(s):
-- \zc|result[10]~0_combout\ = (\Add1~35_combout\) # (!\zc|last~0_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111000011111111",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datac => \Add1~35_combout\,
	datad => \zc|last~0_combout\,
	combout => \zc|result[10]~0_combout\);

-- Location: LCCOMB_X28_Y31_N2
\zc|node[2][9]~12\ : cycloneive_lcell_comb
-- Equation(s):
-- \zc|node[2][9]~12_combout\ = (!\Add1~33_combout\ & ((\Add1~23_combout\) # ((\Add1~15_combout\ & \zc|node[1][10]~2_combout\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000011111000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \Add1~15_combout\,
	datab => \zc|node[1][10]~2_combout\,
	datac => \Add1~23_combout\,
	datad => \Add1~33_combout\,
	combout => \zc|node[2][9]~12_combout\);

-- Location: LCCOMB_X28_Y31_N0
\zc|node[2][9]~13\ : cycloneive_lcell_comb
-- Equation(s):
-- \zc|node[2][9]~13_combout\ = (\Add1~31_combout\) # ((!\Add1~29_combout\ & (!\Add1~35_combout\ & \zc|node[2][9]~12_combout\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1010101110101010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \Add1~31_combout\,
	datab => \Add1~29_combout\,
	datac => \Add1~35_combout\,
	datad => \zc|node[2][9]~12_combout\,
	combout => \zc|node[2][9]~13_combout\);

-- Location: LCCOMB_X28_Y31_N24
\zc|node[1][8]~5\ : cycloneive_lcell_comb
-- Equation(s):
-- \zc|node[1][8]~5_combout\ = (\Add1~3_combout\ & \zc|node[1][10]~2_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111000000000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datac => \Add1~3_combout\,
	datad => \zc|node[1][10]~2_combout\,
	combout => \zc|node[1][8]~5_combout\);

-- Location: LCCOMB_X28_Y31_N22
\zc|node[1][8]~6\ : cycloneive_lcell_comb
-- Equation(s):
-- \zc|node[1][8]~6_combout\ = (!\Add1~31_combout\ & (!\Add1~35_combout\ & (!\Add1~33_combout\ & \zc|node[1][8]~5_combout\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \Add1~31_combout\,
	datab => \Add1~35_combout\,
	datac => \Add1~33_combout\,
	datad => \zc|node[1][8]~5_combout\,
	combout => \zc|node[1][8]~6_combout\);

-- Location: LCCOMB_X28_Y31_N8
\zc|node[1][11]~9\ : cycloneive_lcell_comb
-- Equation(s):
-- \zc|node[1][11]~9_combout\ = (!\Add1~31_combout\ & (!\Add1~33_combout\ & \zc|node[1][10]~2_combout\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000001100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => \Add1~31_combout\,
	datac => \Add1~33_combout\,
	datad => \zc|node[1][10]~2_combout\,
	combout => \zc|node[1][11]~9_combout\);

-- Location: LCCOMB_X28_Y31_N10
\zc|LessThan1~0\ : cycloneive_lcell_comb
-- Equation(s):
-- \zc|LessThan1~0_combout\ = (\Add1~17_combout\ & (\Add1~31_combout\ & ((\Add1~33_combout\) # (!\Add1~15_combout\)))) # (!\Add1~17_combout\ & (((\Add1~33_combout\)) # (!\Add1~15_combout\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111010100110001",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \Add1~17_combout\,
	datab => \Add1~15_combout\,
	datac => \Add1~31_combout\,
	datad => \Add1~33_combout\,
	combout => \zc|LessThan1~0_combout\);

-- Location: LCCOMB_X28_Y31_N28
\zc|LessThan1~1\ : cycloneive_lcell_comb
-- Equation(s):
-- \zc|LessThan1~1_combout\ = (!\Add1~29_combout\ & (!\Add1~35_combout\ & ((\zc|LessThan1~0_combout\) # (!\zc|node[1][10]~2_combout\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000010100000001",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \Add1~29_combout\,
	datab => \zc|node[1][10]~2_combout\,
	datac => \Add1~35_combout\,
	datad => \zc|LessThan1~0_combout\,
	combout => \zc|LessThan1~1_combout\);

-- Location: LCCOMB_X28_Y31_N26
\zc|LessThan1~2\ : cycloneive_lcell_comb
-- Equation(s):
-- \zc|LessThan1~2_combout\ = (\zc|node[1][8]~6_combout\) # ((\zc|node[1][11]~8_combout\) # ((!\zc|LessThan1~1_combout\) # (!\zc|node[1][11]~9_combout\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1110111111111111",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \zc|node[1][8]~6_combout\,
	datab => \zc|node[1][11]~8_combout\,
	datac => \zc|node[1][11]~9_combout\,
	datad => \zc|LessThan1~1_combout\,
	combout => \zc|LessThan1~2_combout\);

-- Location: LCCOMB_X27_Y31_N30
\zc|result[10]~1\ : cycloneive_lcell_comb
-- Equation(s):
-- \zc|result[10]~1_combout\ = (\zc|result[10]~0_combout\) # (((!\zc|node[2][10]~4_combout\ & \zc|node[2][9]~13_combout\)) # (!\zc|LessThan1~2_combout\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1101110011111111",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \zc|node[2][10]~4_combout\,
	datab => \zc|result[10]~0_combout\,
	datac => \zc|node[2][9]~13_combout\,
	datad => \zc|LessThan1~2_combout\,
	combout => \zc|result[10]~1_combout\);

-- Location: LCCOMB_X27_Y31_N18
\zc|last~1\ : cycloneive_lcell_comb
-- Equation(s):
-- \zc|last~1_combout\ = (\Add1~35_combout\) # ((\zc|node[2][10]~4_combout\) # ((!\zc|LessThan1~2_combout\) # (!\zc|last~0_combout\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1110111111111111",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \Add1~35_combout\,
	datab => \zc|node[2][10]~4_combout\,
	datac => \zc|last~0_combout\,
	datad => \zc|LessThan1~2_combout\,
	combout => \zc|last~1_combout\);

-- Location: LCCOMB_X26_Y31_N10
\zc|result[1]~3\ : cycloneive_lcell_comb
-- Equation(s):
-- \zc|result[1]~3_combout\ = (\zc|last~1_combout\ & \Add1~15_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100110000000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => \zc|last~1_combout\,
	datad => \Add1~15_combout\,
	combout => \zc|result[1]~3_combout\);

-- Location: LCCOMB_X28_Y31_N4
\zc|WideNor1~0\ : cycloneive_lcell_comb
-- Equation(s):
-- \zc|WideNor1~0_combout\ = (\zc|node[2][11]~10_combout\ & (!\zc|node[1][11]~8_combout\ & (!\zc|node[1][8]~6_combout\ & \zc|LessThan1~1_combout\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000001000000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \zc|node[2][11]~10_combout\,
	datab => \zc|node[1][11]~8_combout\,
	datac => \zc|node[1][8]~6_combout\,
	datad => \zc|LessThan1~1_combout\,
	combout => \zc|WideNor1~0_combout\);

-- Location: LCCOMB_X28_Y31_N18
\zc|node[2][0]~23\ : cycloneive_lcell_comb
-- Equation(s):
-- \zc|node[2][0]~23_combout\ = (!\zc|WideNor1~0_combout\ & ((\Add1~29_combout\) # ((\Add1~35_combout\) # (!\zc|node[1][11]~9_combout\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000011101111",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \Add1~29_combout\,
	datab => \Add1~35_combout\,
	datac => \zc|node[1][11]~9_combout\,
	datad => \zc|WideNor1~0_combout\,
	combout => \zc|node[2][0]~23_combout\);

-- Location: LCCOMB_X26_Y31_N12
\zc|result[1]~2\ : cycloneive_lcell_comb
-- Equation(s):
-- \zc|result[1]~2_combout\ = (!\zc|result[10]~1_combout\ & (\zc|last~1_combout\ & (\Add1~3_combout\ & \zc|node[2][0]~23_combout\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0100000000000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \zc|result[10]~1_combout\,
	datab => \zc|last~1_combout\,
	datac => \Add1~3_combout\,
	datad => \zc|node[2][0]~23_combout\,
	combout => \zc|result[1]~2_combout\);

-- Location: LCCOMB_X26_Y31_N18
\zc|result[1]~4\ : cycloneive_lcell_comb
-- Equation(s):
-- \zc|result[1]~4_combout\ = (\zc|result[1]~2_combout\) # ((\zc|result[10]~1_combout\ & (\zc|result[1]~3_combout\ & \zc|node[2][0]~23_combout\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111110000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \zc|result[10]~1_combout\,
	datab => \zc|result[1]~3_combout\,
	datac => \zc|node[2][0]~23_combout\,
	datad => \zc|result[1]~2_combout\,
	combout => \zc|result[1]~4_combout\);

-- Location: FF_X26_Y31_N19
\result[0]~reg0\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clock~inputclkctrl_outclk\,
	d => \zc|result[1]~4_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \result[0]~reg0_q\);

-- Location: LCCOMB_X26_Y31_N20
\mr[2]~0\ : cycloneive_lcell_comb
-- Equation(s):
-- \mr[2]~0_combout\ = (\zc|last~1_combout\ & ((\Add1~17_combout\))) # (!\zc|last~1_combout\ & (\Add1~3_combout\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1110111000100010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \Add1~3_combout\,
	datab => \zc|last~1_combout\,
	datad => \Add1~17_combout\,
	combout => \mr[2]~0_combout\);

-- Location: LCCOMB_X26_Y31_N16
\mr[2]~1\ : cycloneive_lcell_comb
-- Equation(s):
-- \mr[2]~1_combout\ = (\zc|node[2][0]~23_combout\ & ((\zc|result[10]~1_combout\ & ((\mr[2]~0_combout\))) # (!\zc|result[10]~1_combout\ & (\zc|result[1]~3_combout\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1110000001000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \zc|result[10]~1_combout\,
	datab => \zc|result[1]~3_combout\,
	datac => \zc|node[2][0]~23_combout\,
	datad => \mr[2]~0_combout\,
	combout => \mr[2]~1_combout\);

-- Location: FF_X26_Y31_N17
\result[1]~reg0\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clock~inputclkctrl_outclk\,
	d => \mr[2]~1_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \result[1]~reg0_q\);

-- Location: LCCOMB_X26_Y31_N6
\mr[3]~2\ : cycloneive_lcell_comb
-- Equation(s):
-- \mr[3]~2_combout\ = (\zc|last~1_combout\ & (\Add1~19_combout\)) # (!\zc|last~1_combout\ & ((\Add1~15_combout\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111001111000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => \zc|last~1_combout\,
	datac => \Add1~19_combout\,
	datad => \Add1~15_combout\,
	combout => \mr[3]~2_combout\);

-- Location: LCCOMB_X26_Y31_N2
\mr[3]~3\ : cycloneive_lcell_comb
-- Equation(s):
-- \mr[3]~3_combout\ = (\zc|node[2][0]~23_combout\ & ((\zc|result[10]~1_combout\ & (\mr[3]~2_combout\)) # (!\zc|result[10]~1_combout\ & ((\mr[2]~0_combout\)))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1000110010000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \mr[3]~2_combout\,
	datab => \zc|node[2][0]~23_combout\,
	datac => \zc|result[10]~1_combout\,
	datad => \mr[2]~0_combout\,
	combout => \mr[3]~3_combout\);

-- Location: FF_X26_Y31_N3
\result[2]~reg0\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clock~inputclkctrl_outclk\,
	d => \mr[3]~3_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \result[2]~reg0_q\);

-- Location: LCCOMB_X28_Y31_N30
\WideNor2~0\ : cycloneive_lcell_comb
-- Equation(s):
-- \WideNor2~0_combout\ = (\zc|node[2][11]~10_combout\ & (\zc|node[1][10]~2_combout\ & (!\Add1~29_combout\ & !\Add1~35_combout\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000000001000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \zc|node[2][11]~10_combout\,
	datab => \zc|node[1][10]~2_combout\,
	datac => \Add1~29_combout\,
	datad => \Add1~35_combout\,
	combout => \WideNor2~0_combout\);

-- Location: LCCOMB_X28_Y31_N12
\zc|node[2][2]~14\ : cycloneive_lcell_comb
-- Equation(s):
-- \zc|node[2][2]~14_combout\ = (\Add1~17_combout\ & (!\WideNor2~0_combout\ & !\zc|WideNor1~0_combout\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000000001010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \Add1~17_combout\,
	datac => \WideNor2~0_combout\,
	datad => \zc|WideNor1~0_combout\,
	combout => \zc|node[2][2]~14_combout\);

-- Location: LCCOMB_X26_Y31_N24
\zc|node[2][4]~15\ : cycloneive_lcell_comb
-- Equation(s):
-- \zc|node[2][4]~15_combout\ = (\zc|WideNor1~0_combout\ & (\Add1~3_combout\ & ((!\WideNor2~0_combout\)))) # (!\zc|WideNor1~0_combout\ & (((\Add1~21_combout\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000110010101100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \Add1~3_combout\,
	datab => \Add1~21_combout\,
	datac => \zc|WideNor1~0_combout\,
	datad => \WideNor2~0_combout\,
	combout => \zc|node[2][4]~15_combout\);

-- Location: LCCOMB_X26_Y31_N8
\result[3]~4\ : cycloneive_lcell_comb
-- Equation(s):
-- \result[3]~4_combout\ = (\zc|last~1_combout\ & ((\zc|node[2][4]~15_combout\))) # (!\zc|last~1_combout\ & (\zc|node[2][2]~14_combout\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100110010101010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \zc|node[2][2]~14_combout\,
	datab => \zc|node[2][4]~15_combout\,
	datad => \zc|last~1_combout\,
	combout => \result[3]~4_combout\);

-- Location: LCCOMB_X26_Y31_N22
\zc|node[3][3]~16\ : cycloneive_lcell_comb
-- Equation(s):
-- \zc|node[3][3]~16_combout\ = (\zc|node[2][0]~23_combout\ & ((\zc|last~1_combout\ & (\Add1~19_combout\)) # (!\zc|last~1_combout\ & ((\Add1~15_combout\)))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1011100000000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \Add1~19_combout\,
	datab => \zc|last~1_combout\,
	datac => \Add1~15_combout\,
	datad => \zc|node[2][0]~23_combout\,
	combout => \zc|node[3][3]~16_combout\);

-- Location: FF_X26_Y31_N9
\result[3]~reg0\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clock~inputclkctrl_outclk\,
	d => \result[3]~4_combout\,
	asdata => \zc|node[3][3]~16_combout\,
	sload => \zc|ALT_INV_result[10]~1_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \result[3]~reg0_q\);

-- Location: LCCOMB_X28_Y31_N14
\zc|node[2][3]~17\ : cycloneive_lcell_comb
-- Equation(s):
-- \zc|node[2][3]~17_combout\ = (\Add1~19_combout\ & (!\WideNor2~0_combout\ & !\zc|WideNor1~0_combout\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000000001100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => \Add1~19_combout\,
	datac => \WideNor2~0_combout\,
	datad => \zc|WideNor1~0_combout\,
	combout => \zc|node[2][3]~17_combout\);

-- Location: LCCOMB_X28_Y31_N16
\zc|node[2][5]~18\ : cycloneive_lcell_comb
-- Equation(s):
-- \zc|node[2][5]~18_combout\ = (\zc|WideNor1~0_combout\ & (!\WideNor2~0_combout\ & (\Add1~15_combout\))) # (!\zc|WideNor1~0_combout\ & (((\Add1~23_combout\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0100010011110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \WideNor2~0_combout\,
	datab => \Add1~15_combout\,
	datac => \Add1~23_combout\,
	datad => \zc|WideNor1~0_combout\,
	combout => \zc|node[2][5]~18_combout\);

-- Location: LCCOMB_X26_Y31_N14
\result[4]~5\ : cycloneive_lcell_comb
-- Equation(s):
-- \result[4]~5_combout\ = (\zc|last~1_combout\ & ((\zc|node[2][5]~18_combout\))) # (!\zc|last~1_combout\ & (\zc|node[2][3]~17_combout\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1110111000100010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \zc|node[2][3]~17_combout\,
	datab => \zc|last~1_combout\,
	datad => \zc|node[2][5]~18_combout\,
	combout => \result[4]~5_combout\);

-- Location: FF_X26_Y31_N15
\result[4]~reg0\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clock~inputclkctrl_outclk\,
	d => \result[4]~5_combout\,
	asdata => \result[3]~4_combout\,
	sload => \zc|ALT_INV_result[10]~1_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \result[4]~reg0_q\);

-- Location: LCCOMB_X28_Y31_N6
\zc|node[2][6]~19\ : cycloneive_lcell_comb
-- Equation(s):
-- \zc|node[2][6]~19_combout\ = (\zc|WideNor1~0_combout\ & (((!\WideNor2~0_combout\ & \Add1~17_combout\)))) # (!\zc|WideNor1~0_combout\ & (\Add1~25_combout\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0010111000100010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \Add1~25_combout\,
	datab => \zc|WideNor1~0_combout\,
	datac => \WideNor2~0_combout\,
	datad => \Add1~17_combout\,
	combout => \zc|node[2][6]~19_combout\);

-- Location: LCCOMB_X26_Y31_N0
\result[5]~6\ : cycloneive_lcell_comb
-- Equation(s):
-- \result[5]~6_combout\ = (\zc|last~1_combout\ & ((\zc|node[2][6]~19_combout\))) # (!\zc|last~1_combout\ & (\zc|node[2][4]~15_combout\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1110111001000100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \zc|last~1_combout\,
	datab => \zc|node[2][4]~15_combout\,
	datad => \zc|node[2][6]~19_combout\,
	combout => \result[5]~6_combout\);

-- Location: FF_X26_Y31_N1
\result[5]~reg0\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clock~inputclkctrl_outclk\,
	d => \result[5]~6_combout\,
	asdata => \result[4]~5_combout\,
	sload => \zc|ALT_INV_result[10]~1_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \result[5]~reg0_q\);

-- Location: LCCOMB_X28_Y31_N20
\zc|node[2][7]~20\ : cycloneive_lcell_comb
-- Equation(s):
-- \zc|node[2][7]~20_combout\ = (\zc|WideNor1~0_combout\ & (((\Add1~19_combout\ & !\WideNor2~0_combout\)))) # (!\zc|WideNor1~0_combout\ & (\Add1~27_combout\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000110010101010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \Add1~27_combout\,
	datab => \Add1~19_combout\,
	datac => \WideNor2~0_combout\,
	datad => \zc|WideNor1~0_combout\,
	combout => \zc|node[2][7]~20_combout\);

-- Location: LCCOMB_X26_Y31_N26
\result[6]~7\ : cycloneive_lcell_comb
-- Equation(s):
-- \result[6]~7_combout\ = (\zc|last~1_combout\ & (\zc|node[2][7]~20_combout\)) # (!\zc|last~1_combout\ & ((\zc|node[2][5]~18_combout\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1011101110001000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \zc|node[2][7]~20_combout\,
	datab => \zc|last~1_combout\,
	datad => \zc|node[2][5]~18_combout\,
	combout => \result[6]~7_combout\);

-- Location: FF_X26_Y31_N27
\result[6]~reg0\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clock~inputclkctrl_outclk\,
	d => \result[6]~7_combout\,
	asdata => \result[5]~6_combout\,
	sload => \zc|ALT_INV_result[10]~1_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \result[6]~reg0_q\);

-- Location: LCCOMB_X29_Y31_N28
\zc|node[2][8]~21\ : cycloneive_lcell_comb
-- Equation(s):
-- \zc|node[2][8]~21_combout\ = (\Add1~21_combout\ & (!\Add1~31_combout\ & (!\Add1~35_combout\ & !\Add1~33_combout\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000000000010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \Add1~21_combout\,
	datab => \Add1~31_combout\,
	datac => \Add1~35_combout\,
	datad => \Add1~33_combout\,
	combout => \zc|node[2][8]~21_combout\);

-- Location: LCCOMB_X29_Y31_N10
\zc|node[2][8]~22\ : cycloneive_lcell_comb
-- Equation(s):
-- \zc|node[2][8]~22_combout\ = (\zc|node[1][8]~6_combout\) # ((\Add1~29_combout\) # (\zc|node[2][8]~21_combout\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111111111100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => \zc|node[1][8]~6_combout\,
	datac => \Add1~29_combout\,
	datad => \zc|node[2][8]~21_combout\,
	combout => \zc|node[2][8]~22_combout\);

-- Location: LCCOMB_X26_Y31_N4
\result[7]~8\ : cycloneive_lcell_comb
-- Equation(s):
-- \result[7]~8_combout\ = (\zc|last~1_combout\ & ((\zc|node[2][8]~22_combout\))) # (!\zc|last~1_combout\ & (\zc|node[2][6]~19_combout\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100110010101010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \zc|node[2][6]~19_combout\,
	datab => \zc|node[2][8]~22_combout\,
	datad => \zc|last~1_combout\,
	combout => \result[7]~8_combout\);

-- Location: FF_X26_Y31_N5
\result[7]~reg0\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clock~inputclkctrl_outclk\,
	d => \result[7]~8_combout\,
	asdata => \result[6]~7_combout\,
	sload => \zc|ALT_INV_result[10]~1_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \result[7]~reg0_q\);

-- Location: LCCOMB_X26_Y31_N30
\result[8]~9\ : cycloneive_lcell_comb
-- Equation(s):
-- \result[8]~9_combout\ = (\zc|last~1_combout\ & ((\zc|node[2][9]~13_combout\))) # (!\zc|last~1_combout\ & (\zc|node[2][7]~20_combout\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100110010101010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \zc|node[2][7]~20_combout\,
	datab => \zc|node[2][9]~13_combout\,
	datad => \zc|last~1_combout\,
	combout => \result[8]~9_combout\);

-- Location: FF_X26_Y31_N31
\result[8]~reg0\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clock~inputclkctrl_outclk\,
	d => \result[8]~9_combout\,
	asdata => \result[7]~8_combout\,
	sload => \zc|ALT_INV_result[10]~1_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \result[8]~reg0_q\);

-- Location: LCCOMB_X26_Y31_N28
\result[9]~10\ : cycloneive_lcell_comb
-- Equation(s):
-- \result[9]~10_combout\ = (\zc|last~1_combout\ & (\zc|node[2][10]~4_combout\)) # (!\zc|last~1_combout\ & ((\zc|node[2][8]~22_combout\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1010101011001100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \zc|node[2][10]~4_combout\,
	datab => \zc|node[2][8]~22_combout\,
	datad => \zc|last~1_combout\,
	combout => \result[9]~10_combout\);

-- Location: FF_X26_Y31_N29
\result[9]~reg0\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clock~inputclkctrl_outclk\,
	d => \result[9]~10_combout\,
	asdata => \result[8]~9_combout\,
	sload => \zc|ALT_INV_result[10]~1_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \result[9]~reg0_q\);

-- Location: LCCOMB_X25_Y31_N18
\WideNor2~1\ : cycloneive_lcell_comb
-- Equation(s):
-- \WideNor2~1_combout\ = (\Add1~3_combout\) # ((\Add1~19_combout\) # ((\Add1~17_combout\) # (\Add1~15_combout\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111111111110",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \Add1~3_combout\,
	datab => \Add1~19_combout\,
	datac => \Add1~17_combout\,
	datad => \Add1~15_combout\,
	combout => \WideNor2~1_combout\);

-- Location: FF_X30_Y30_N23
\ea_reg[0]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clock~inputclkctrl_outclk\,
	d => \ea[0]~2_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => ea_reg(0));

-- Location: LCCOMB_X27_Y31_N8
\Add3~0\ : cycloneive_lcell_comb
-- Equation(s):
-- \Add3~0_combout\ = (\zc|result[10]~1_combout\ & (ea_reg(0) $ (VCC))) # (!\zc|result[10]~1_combout\ & (ea_reg(0) & VCC))
-- \Add3~1\ = CARRY((\zc|result[10]~1_combout\ & ea_reg(0)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0110011010001000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \zc|result[10]~1_combout\,
	datab => ea_reg(0),
	datad => VCC,
	combout => \Add3~0_combout\,
	cout => \Add3~1\);

-- Location: LCCOMB_X25_Y31_N8
\er[0]~0\ : cycloneive_lcell_comb
-- Equation(s):
-- \er[0]~0_combout\ = (\Add3~0_combout\ & ((\WideNor2~1_combout\) # (!\WideNor2~0_combout\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => \WideNor2~1_combout\,
	datac => \WideNor2~0_combout\,
	datad => \Add3~0_combout\,
	combout => \er[0]~0_combout\);

-- Location: FF_X25_Y31_N9
\result[10]~reg0\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clock~inputclkctrl_outclk\,
	d => \er[0]~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \result[10]~reg0_q\);

-- Location: FF_X30_Y30_N29
\ea_reg[1]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clock~inputclkctrl_outclk\,
	d => \ea[1]~1_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => ea_reg(1));

-- Location: LCCOMB_X27_Y31_N10
\Add3~2\ : cycloneive_lcell_comb
-- Equation(s):
-- \Add3~2_combout\ = (ea_reg(1) & ((\zc|last~1_combout\ & (\Add3~1\ & VCC)) # (!\zc|last~1_combout\ & (!\Add3~1\)))) # (!ea_reg(1) & ((\zc|last~1_combout\ & (!\Add3~1\)) # (!\zc|last~1_combout\ & ((\Add3~1\) # (GND)))))
-- \Add3~3\ = CARRY((ea_reg(1) & (!\zc|last~1_combout\ & !\Add3~1\)) # (!ea_reg(1) & ((!\Add3~1\) # (!\zc|last~1_combout\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1001011000010111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => ea_reg(1),
	datab => \zc|last~1_combout\,
	datad => VCC,
	cin => \Add3~1\,
	combout => \Add3~2_combout\,
	cout => \Add3~3\);

-- Location: LCCOMB_X27_Y31_N0
\result[11]~11\ : cycloneive_lcell_comb
-- Equation(s):
-- \result[11]~11_combout\ = \Add3~2_combout\ $ (VCC)
-- \result[11]~12\ = CARRY(\Add3~2_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0101010110101010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \Add3~2_combout\,
	datad => VCC,
	combout => \result[11]~11_combout\,
	cout => \result[11]~12\);

-- Location: LCCOMB_X25_Y31_N28
\zc|node[1][9]~11\ : cycloneive_lcell_comb
-- Equation(s):
-- \zc|node[1][9]~11_combout\ = (!\Add1~29_combout\ & !\Add1~35_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000001010101",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \Add1~29_combout\,
	datad => \Add1~35_combout\,
	combout => \zc|node[1][9]~11_combout\);

-- Location: LCCOMB_X25_Y31_N24
WideNor2 : cycloneive_lcell_comb
-- Equation(s):
-- \WideNor2~combout\ = (\zc|node[1][10]~2_combout\ & (!\WideNor2~1_combout\ & (\zc|node[2][11]~10_combout\ & \zc|node[1][9]~11_combout\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0010000000000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \zc|node[1][10]~2_combout\,
	datab => \WideNor2~1_combout\,
	datac => \zc|node[2][11]~10_combout\,
	datad => \zc|node[1][9]~11_combout\,
	combout => \WideNor2~combout\);

-- Location: FF_X27_Y31_N1
\result[11]~reg0\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clock~inputclkctrl_outclk\,
	d => \result[11]~11_combout\,
	sclr => \WideNor2~combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \result[11]~reg0_q\);

-- Location: FF_X25_Y30_N13
\ea_reg[2]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clock~inputclkctrl_outclk\,
	d => \ea[2]~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => ea_reg(2));

-- Location: LCCOMB_X27_Y31_N12
\Add3~4\ : cycloneive_lcell_comb
-- Equation(s):
-- \Add3~4_combout\ = ((\zc|WideNor1~0_combout\ $ (ea_reg(2) $ (\Add3~3\)))) # (GND)
-- \Add3~5\ = CARRY((\zc|WideNor1~0_combout\ & (ea_reg(2) & !\Add3~3\)) # (!\zc|WideNor1~0_combout\ & ((ea_reg(2)) # (!\Add3~3\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1001011001001101",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => \zc|WideNor1~0_combout\,
	datab => ea_reg(2),
	datad => VCC,
	cin => \Add3~3\,
	combout => \Add3~4_combout\,
	cout => \Add3~5\);

-- Location: LCCOMB_X27_Y31_N2
\result[12]~13\ : cycloneive_lcell_comb
-- Equation(s):
-- \result[12]~13_combout\ = (\Add3~4_combout\ & (!\result[11]~12\)) # (!\Add3~4_combout\ & ((\result[11]~12\) # (GND)))
-- \result[12]~14\ = CARRY((!\result[11]~12\) # (!\Add3~4_combout\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0101101001011111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => \Add3~4_combout\,
	datad => VCC,
	cin => \result[11]~12\,
	combout => \result[12]~13_combout\,
	cout => \result[12]~14\);

-- Location: FF_X27_Y31_N3
\result[12]~reg0\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clock~inputclkctrl_outclk\,
	d => \result[12]~13_combout\,
	sclr => \WideNor2~combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \result[12]~reg0_q\);

-- Location: FF_X25_Y30_N15
\ea_reg[3]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clock~inputclkctrl_outclk\,
	d => \ea[3]~4_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => ea_reg(3));

-- Location: LCCOMB_X27_Y31_N14
\Add3~6\ : cycloneive_lcell_comb
-- Equation(s):
-- \Add3~6_combout\ = (\WideNor2~0_combout\ & ((ea_reg(3) & (!\Add3~5\)) # (!ea_reg(3) & ((\Add3~5\) # (GND))))) # (!\WideNor2~0_combout\ & ((ea_reg(3) & (\Add3~5\ & VCC)) # (!ea_reg(3) & (!\Add3~5\))))
-- \Add3~7\ = CARRY((\WideNor2~0_combout\ & ((!\Add3~5\) # (!ea_reg(3)))) # (!\WideNor2~0_combout\ & (!ea_reg(3) & !\Add3~5\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0110100100101011",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => \WideNor2~0_combout\,
	datab => ea_reg(3),
	datad => VCC,
	cin => \Add3~5\,
	combout => \Add3~6_combout\,
	cout => \Add3~7\);

-- Location: LCCOMB_X27_Y31_N4
\result[13]~15\ : cycloneive_lcell_comb
-- Equation(s):
-- \result[13]~15_combout\ = (\Add3~6_combout\ & (\result[12]~14\ $ (GND))) # (!\Add3~6_combout\ & (!\result[12]~14\ & VCC))
-- \result[13]~16\ = CARRY((\Add3~6_combout\ & !\result[12]~14\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100001100001100",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datab => \Add3~6_combout\,
	datad => VCC,
	cin => \result[12]~14\,
	combout => \result[13]~15_combout\,
	cout => \result[13]~16\);

-- Location: FF_X27_Y31_N5
\result[13]~reg0\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clock~inputclkctrl_outclk\,
	d => \result[13]~15_combout\,
	sclr => \WideNor2~combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \result[13]~reg0_q\);

-- Location: FF_X25_Y30_N21
\ea_reg[4]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clock~inputclkctrl_outclk\,
	d => \ea[4]~3_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => ea_reg(4));

-- Location: LCCOMB_X27_Y31_N16
\Add3~8\ : cycloneive_lcell_comb
-- Equation(s):
-- \Add3~8_combout\ = \Add3~7\ $ (!ea_reg(4))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111000000001111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datad => ea_reg(4),
	cin => \Add3~7\,
	combout => \Add3~8_combout\);

-- Location: LCCOMB_X27_Y31_N6
\result[14]~17\ : cycloneive_lcell_comb
-- Equation(s):
-- \result[14]~17_combout\ = \result[13]~16\ $ (!\Add3~8_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111000000001111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datad => \Add3~8_combout\,
	cin => \result[13]~16\,
	combout => \result[14]~17_combout\);

-- Location: FF_X27_Y31_N7
\result[14]~reg0\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clock~inputclkctrl_outclk\,
	d => \result[14]~17_combout\,
	sclr => \WideNor2~combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \result[14]~reg0_q\);

-- Location: LCCOMB_X25_Y31_N10
\sr~0\ : cycloneive_lcell_comb
-- Equation(s):
-- \sr~0_combout\ = (\sa_reg~q\ & (((\WideNor2~1_combout\) # (!\zc|node[1][11]~9_combout\)) # (!\zc|node[1][9]~11_combout\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1010101000101010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \sa_reg~q\,
	datab => \zc|node[1][9]~11_combout\,
	datac => \zc|node[1][11]~9_combout\,
	datad => \WideNor2~1_combout\,
	combout => \sr~0_combout\);

-- Location: FF_X25_Y31_N11
\result[15]~reg0\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clock~inputclkctrl_outclk\,
	d => \sr~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \result[15]~reg0_q\);

ww_result_valid <= \result_valid~output_o\;

ww_result(0) <= \result[0]~output_o\;

ww_result(1) <= \result[1]~output_o\;

ww_result(2) <= \result[2]~output_o\;

ww_result(3) <= \result[3]~output_o\;

ww_result(4) <= \result[4]~output_o\;

ww_result(5) <= \result[5]~output_o\;

ww_result(6) <= \result[6]~output_o\;

ww_result(7) <= \result[7]~output_o\;

ww_result(8) <= \result[8]~output_o\;

ww_result(9) <= \result[9]~output_o\;

ww_result(10) <= \result[10]~output_o\;

ww_result(11) <= \result[11]~output_o\;

ww_result(12) <= \result[12]~output_o\;

ww_result(13) <= \result[13]~output_o\;

ww_result(14) <= \result[14]~output_o\;

ww_result(15) <= \result[15]~output_o\;
END structure;


