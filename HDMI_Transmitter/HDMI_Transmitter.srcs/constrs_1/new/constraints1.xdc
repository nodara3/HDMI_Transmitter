set_property IOSTANDARD LVCMOS33 [get_ports switch1]
set_property PACKAGE_PIN E11 [get_ports switch1]

set_property IOSTANDARD LVCMOS33 [get_ports switch2]
set_property PACKAGE_PIN E12 [get_ports switch2]

set_property IOSTANDARD LVCMOS33 [get_ports out1]
set_property PACKAGE_PIN E16 [get_ports out1]

set_property IOSTANDARD LVCMOS33 [get_ports out2]
set_property PACKAGE_PIN E17 [get_ports out2]


set_property IOSTANDARD LVCMOS33 [get_ports CLK100MHz]
set_property PACKAGE_PIN E11 [get_ports CLK100MHz]

set_property -dict { PACKAGE_PIN A23   IOSTANDARD TMDS_33  } [get_ports { hdmi_tx0_p }];
set_property -dict { PACKAGE_PIN A24   IOSTANDARD TMDS_33  } [get_ports { hdmi_tx0_n }];
set_property -dict { PACKAGE_PIN C21   IOSTANDARD TMDS_33  } [get_ports { hdmi_tx1_p }];
set_property -dict { PACKAGE_PIN B21   IOSTANDARD TMDS_33  } [get_ports { hdmi_tx1_n }];
set_property -dict { PACKAGE_PIN B20   IOSTANDARD TMDS_33  } [get_ports { hdmi_tx2_p }];
set_property -dict { PACKAGE_PIN A20   IOSTANDARD TMDS_33  } [get_ports { hdmi_tx2_n }];
set_property -dict { PACKAGE_PIN D21   IOSTANDARD TMDS_33  } [get_ports { hdmi_tx_clk_p }];
set_property -dict { PACKAGE_PIN C22   IOSTANDARD TMDS_33  } [get_ports { hdmi_tx_clk_n }];


