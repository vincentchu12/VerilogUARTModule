# Clock Signal
set_property -dict {PACKAGE_PIN E3 IOSTANDARD LVCMOS33}           [get_ports {clk100MHz}];
create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports {clk100MHz}];

# Buttons
set_property -dict {PACKAGE_PIN N17 IOSTANDARD LVCMOS33} [get_ports {rst}]; # Center Button
set_property -dict {PACKAGE_PIN M17 IOSTANDARD LVCMOS33} [get_ports {write}]; # Right Button


# Switches
set_property -dict {PACKAGE_PIN J15 IOSTANDARD LVCMOS33} [get_ports {tx_data[0]}];  # Switch 0
set_property -dict {PACKAGE_PIN L16 IOSTANDARD LVCMOS33} [get_ports {tx_data[1]}];  # Switch 1
set_property -dict {PACKAGE_PIN M13 IOSTANDARD LVCMOS33} [get_ports {tx_data[2]}];  # Switch 2
set_property -dict {PACKAGE_PIN R15 IOSTANDARD LVCMOS33} [get_ports {tx_data[3]}];  # Switch 3
set_property -dict {PACKAGE_PIN R17 IOSTANDARD LVCMOS33} [get_ports {tx_data[4]}];  # Switch 4
set_property -dict {PACKAGE_PIN T18 IOSTANDARD LVCMOS33} [get_ports {tx_data[5]}];  # Switch 5
set_property -dict {PACKAGE_PIN U18 IOSTANDARD LVCMOS33} [get_ports {tx_data[6]}];  # Switch 6
set_property -dict {PACKAGE_PIN R13 IOSTANDARD LVCMOS33} [get_ports {tx_data[7]}];  # Switch 7

# LEDs
set_property -dict {PACKAGE_PIN H17 IOSTANDARD LVCMOS33} [get_ports {rx_data[0]}];  # LED 0
set_property -dict {PACKAGE_PIN K15 IOSTANDARD LVCMOS33} [get_ports {rx_data[1]}];  # LED 1
set_property -dict {PACKAGE_PIN J13 IOSTANDARD LVCMOS33} [get_ports {rx_data[2]}];  # LED 2
set_property -dict {PACKAGE_PIN N14 IOSTANDARD LVCMOS33} [get_ports {rx_data[3]}];  # LED 3
set_property -dict {PACKAGE_PIN R18 IOSTANDARD LVCMOS33} [get_ports {rx_data[4]}];  # LED 4
set_property -dict {PACKAGE_PIN V17 IOSTANDARD LVCMOS33} [get_ports {rx_data[5]}];  # LED 5
set_property -dict {PACKAGE_PIN U17 IOSTANDARD LVCMOS33} [get_ports {rx_data[6]}];  # LED 6
set_property -dict {PACKAGE_PIN U16 IOSTANDARD LVCMOS33} [get_ports {rx_data[7]}];  # LED 7

set_property -dict {PACKAGE_PIN V15 IOSTANDARD LVCMOS33} [get_ports {tx_full}]; # LED 12
set_property -dict {PACKAGE_PIN V14 IOSTANDARD LVCMOS33} [get_ports {tx_empty}]; # LED 13
set_property -dict {PACKAGE_PIN V12 IOSTANDARD LVCMOS33} [get_ports {rx_full}]; # LED 14
set_property -dict {PACKAGE_PIN V11 IOSTANDARD LVCMOS33} [get_ports {rx_empty}]; # LED 15

# 7 Segment Display
set_property -dict {PACKAGE_PIN T10 IOSTANDARD LVCMOS33} [get_ports {LEDOUT[0]}]; # CA
set_property -dict {PACKAGE_PIN R10 IOSTANDARD LVCMOS33} [get_ports {LEDOUT[1]}]; # CB
set_property -dict {PACKAGE_PIN K16 IOSTANDARD LVCMOS33} [get_ports {LEDOUT[2]}]; # CC
set_property -dict {PACKAGE_PIN K13 IOSTANDARD LVCMOS33} [get_ports {LEDOUT[3]}]; # CD
set_property -dict {PACKAGE_PIN P15 IOSTANDARD LVCMOS33} [get_ports {LEDOUT[4]}]; # CE
set_property -dict {PACKAGE_PIN T11 IOSTANDARD LVCMOS33} [get_ports {LEDOUT[5]}]; # CF
set_property -dict {PACKAGE_PIN L18 IOSTANDARD LVCMOS33} [get_ports {LEDOUT[6]}]; # CG
set_property -dict {PACKAGE_PIN H15 IOSTANDARD LVCMOS33} [get_ports {LEDOUT[7]}]; # DP

set_property -dict {PACKAGE_PIN J17 IOSTANDARD LVCMOS33} [get_ports {LEDSEL[0]}]; # AN0
set_property -dict {PACKAGE_PIN J18 IOSTANDARD LVCMOS33} [get_ports {LEDSEL[1]}]; # AN1
set_property -dict {PACKAGE_PIN T9  IOSTANDARD LVCMOS33} [get_ports {LEDSEL[2]}]; # AN2
set_property -dict {PACKAGE_PIN J14 IOSTANDARD LVCMOS33} [get_ports {LEDSEL[3]}]; # AN3
set_property -dict {PACKAGE_PIN P14 IOSTANDARD LVCMOS33} [get_ports {LEDSEL[4]}]; # AN4
set_property -dict {PACKAGE_PIN T14 IOSTANDARD LVCMOS33} [get_ports {LEDSEL[5]}]; # AN5
set_property -dict {PACKAGE_PIN K2  IOSTANDARD LVCMOS33} [get_ports {LEDSEL[6]}]; # AN6
set_property -dict {PACKAGE_PIN U13 IOSTANDARD LVCMOS33} [get_ports {LEDSEL[7]}]; # AN7

#USB-RS232 Interface
set_property -dict { PACKAGE_PIN C4    IOSTANDARD LVCMOS33 } [get_ports { rx }];
set_property -dict { PACKAGE_PIN D4    IOSTANDARD LVCMOS33 } [get_ports { tx }];