#125mhz
set_property IOSTANDARD LVDS [get_ports CLK_P]
create_clock -period 8.000 [get_ports CLK_P]


set_property PACKAGE_PIN G10 [get_ports CLK_P]
set_property PACKAGE_PIN F10 [get_ports CLK_N]
set_property IOSTANDARD LVDS [get_ports CLK_N]


set_property PACKAGE_PIN G25 [get_ports UART_RX]
set_property IOSTANDARD LVCMOS18 [get_ports UART_RX]
set_property PACKAGE_PIN K26 [get_ports UART_TX]
set_property IOSTANDARD LVCMOS18 [get_ports UART_TX]

set_property PACKAGE_PIN AD10 [get_ports sw_n_10]
set_property IOSTANDARD LVCMOS18 [get_ports sw_n_10]
set_property PACKAGE_PIN AF8 [get_ports sw_s_8]
set_property IOSTANDARD LVCMOS18 [get_ports sw_s_8]
set_property PACKAGE_PIN AE10 [get_ports sw_c_7]
set_property IOSTANDARD LVCMOS18 [get_ports sw_c_7]

set_property PACKAGE_PIN AP8 [get_ports {led[0]}]
set_property IOSTANDARD LVCMOS18 [get_ports {led[0]}]
set_property PACKAGE_PIN H23 [get_ports {led[1]}]
set_property IOSTANDARD LVCMOS18 [get_ports {led[1]}]
set_property PACKAGE_PIN P20 [get_ports {led[2]}]
set_property IOSTANDARD LVCMOS18 [get_ports {led[2]}]
set_property PACKAGE_PIN P21 [get_ports {led[3]}]
set_property IOSTANDARD LVCMOS18 [get_ports {led[3]}]
set_property PACKAGE_PIN N22 [get_ports {led[4]}]
set_property IOSTANDARD LVCMOS18 [get_ports {led[4]}]
set_property PACKAGE_PIN M22 [get_ports {led[5]}]
set_property IOSTANDARD LVCMOS18 [get_ports {led[5]}]
set_property PACKAGE_PIN R23 [get_ports {led[6]}]
set_property IOSTANDARD LVCMOS18 [get_ports {led[6]}]
set_property PACKAGE_PIN P23 [get_ports {led[7]}]
set_property IOSTANDARD LVCMOS18 [get_ports {led[7]}]




