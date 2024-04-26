### Nexys N4 to Nexys A7 XDC conversion script: 
### Author : Sharath Krishnan - sharath@usc.edu 

set_property PACKAGE_PIN E3 [get_ports ClkPort]							
	set_property IOSTANDARD LVCMOS33 [get_ports ClkPort]
	create_clock -add -name ClkPort -period 10.00 [get_ports ClkPort]

# Switches
#Bank = 34, Pin name = IO_L21P_T3_DQS_34,					Sch name = Sw0
set_property PACKAGE_PIN J15 [get_ports {Sw0}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {Sw0}]
#Bank = 34, Pin name = IO_25_34,							Sch name = Sw1
set_property PACKAGE_PIN L16 [get_ports {Sw1}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {Sw1}]
#Bank = 34, Pin name = IO_L23P_T3_34,						Sch name = Sw2
set_property PACKAGE_PIN M13 [get_ports {Sw2}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {Sw2}]
#Bank = 34, Pin name = IO_L19P_T3_34,						Sch name = Sw3
set_property PACKAGE_PIN R15 [get_ports {Sw3}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {Sw3}]
#Bank = 34, Pin name = IO_L19N_T3_VREF_34,					Sch name = Sw4
set_property PACKAGE_PIN R17 [get_ports {Sw4}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {Sw4}]
#Bank = 34, Pin name = IO_L20P_T3_34,						Sch name = Sw5
set_property PACKAGE_PIN T18 [get_ports {Sw5}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {Sw5}]
#Bank = 34, Pin name = IO_L20N_T3_34,						Sch name = Sw6
set_property PACKAGE_PIN U18 [get_ports {Sw6}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {Sw6}]
#Bank = 34, Pin name = IO_L10P_T1_34,						Sch name = Sw7
set_property PACKAGE_PIN R13 [get_ports {Sw7}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {Sw7}]
#Bank = 34, Pin name = IO_L8P_T1-34,						Sch name = Sw8
set_property PACKAGE_PIN T8 [get_ports {Sw8}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {Sw8}]
#Bank = 34, Pin name = IO_L9N_T1_DQS_34,					Sch name = Sw9
set_property PACKAGE_PIN U8 [get_ports {Sw9}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {Sw9}]
#Bank = 34, Pin name = IO_L9P_T1_DQS_34,					Sch name = Sw10
set_property PACKAGE_PIN R16 [get_ports {Sw10}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {Sw10}]
#Bank = 34, Pin name = IO_L11N_T1_MRCC_34,					Sch name = Sw11
set_property PACKAGE_PIN T13 [get_ports {Sw11}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {Sw11}]
#Bank = 34, Pin name = IO_L17N_T2_34,						Sch name = Sw12
set_property PACKAGE_PIN H6 [get_ports {Sw12}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {Sw12}]
#Bank = 34, Pin name = IO_L11P_T1_SRCC_34,					Sch name = Sw13
set_property PACKAGE_PIN U12 [get_ports {Sw13}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {Sw13}]
#Bank = 34, Pin name = IO_L14N_T2_SRCC_34,					Sch name = Sw14
set_property PACKAGE_PIN U11 [get_ports {Sw14}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {Sw14}]
#Bank = 34, Pin name = IO_L14P_T2_SRCC_34,					Sch name = Sw15
set_property PACKAGE_PIN V10 [get_ports {Sw15}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {Sw15}]
	
set_false_path -through [get_nets {Sw0}]
set_false_path -through [get_nets {Sw1}]
set_false_path -through [get_nets {Sw2}]
set_false_path -through [get_nets {Sw3}]
set_false_path -through [get_nets {Sw4}]
set_false_path -through [get_nets {Sw5}]
set_false_path -through [get_nets {Sw6}]
set_false_path -through [get_nets {Sw7}]
set_false_path -through [get_nets {Sw8}]
set_false_path -through [get_nets {Sw9}]
set_false_path -through [get_nets {Sw10}]
set_false_path -through [get_nets {Sw11}]
set_false_path -through [get_nets {Sw12}]
set_false_path -through [get_nets {Sw13}]
set_false_path -through [get_nets {Sw14}]
set_false_path -through [get_nets {Sw15}]


set_property PACKAGE_PIN T10 [get_ports {Ca}] 
	set_property IOSTANDARD LVCMOS33 [get_ports {Ca}]

set_property PACKAGE_PIN R10 [get_ports {Cb}] 
	set_property IOSTANDARD LVCMOS33 [get_ports {Cb}]

set_property PACKAGE_PIN K16 [get_ports {Cc}] 
	set_property IOSTANDARD LVCMOS33 [get_ports {Cc}]

set_property PACKAGE_PIN K13 [get_ports {Cd}] 
	set_property IOSTANDARD LVCMOS33 [get_ports {Cd}]

set_property PACKAGE_PIN P15 [get_ports {Ce}] 
	set_property IOSTANDARD LVCMOS33 [get_ports {Ce}]

set_property PACKAGE_PIN T11 [get_ports {Cf}] 
	set_property IOSTANDARD LVCMOS33 [get_ports {Cf}]

set_property PACKAGE_PIN L18 [get_ports {Cg}] 
	set_property IOSTANDARD LVCMOS33 [get_ports {Cg}]

set_property PACKAGE_PIN H15 [get_ports Dp] 
	set_property IOSTANDARD LVCMOS33 [get_ports Dp]

set_property PACKAGE_PIN J17 [get_ports {An0}] 
	set_property IOSTANDARD LVCMOS33 [get_ports {An0}]

set_property PACKAGE_PIN J18 [get_ports {An1}] 
	set_property IOSTANDARD LVCMOS33 [get_ports {An1}]

set_property PACKAGE_PIN T9 [get_ports {An2}] 
	set_property IOSTANDARD LVCMOS33 [get_ports {An2}]

set_property PACKAGE_PIN J14 [get_ports {An3}] 
	set_property IOSTANDARD LVCMOS33 [get_ports {An3}]

set_property PACKAGE_PIN P14 [get_ports {An4}] 
	set_property IOSTANDARD LVCMOS33 [get_ports {An4}]

set_property PACKAGE_PIN T14 [get_ports {An5}] 
	set_property IOSTANDARD LVCMOS33 [get_ports {An5}]

set_property PACKAGE_PIN K2 [get_ports {An6}] 
	set_property IOSTANDARD LVCMOS33 [get_ports {An6}]

set_property PACKAGE_PIN U13 [get_ports {An7}] 
	set_property IOSTANDARD LVCMOS33 [get_ports {An7}]

set_property PACKAGE_PIN N17 [get_ports BtnC] 
	set_property IOSTANDARD LVCMOS33 [get_ports BtnC]

set_property PACKAGE_PIN M18 [get_ports BtnU] 
	set_property IOSTANDARD LVCMOS33 [get_ports BtnU]

set_property PACKAGE_PIN P17 [get_ports BtnL] 
	set_property IOSTANDARD LVCMOS33 [get_ports BtnL]

set_property PACKAGE_PIN M17 [get_ports BtnR] 
	set_property IOSTANDARD LVCMOS33 [get_ports BtnR]

set_property PACKAGE_PIN P18 [get_ports BtnD] 
	set_property IOSTANDARD LVCMOS33 [get_ports BtnD]

set_property PACKAGE_PIN A3 [get_ports {vgaR[0]}]				
	set_property IOSTANDARD LVCMOS33 [get_ports {vgaR[0]}]

set_property PACKAGE_PIN B4 [get_ports {vgaR[1]}]				
	set_property IOSTANDARD LVCMOS33 [get_ports {vgaR[1]}]

set_property PACKAGE_PIN C5 [get_ports {vgaR[2]}]				
	set_property IOSTANDARD LVCMOS33 [get_ports {vgaR[2]}]

set_property PACKAGE_PIN A4 [get_ports {vgaR[3]}]				
	set_property IOSTANDARD LVCMOS33 [get_ports {vgaR[3]}]

set_property PACKAGE_PIN B7 [get_ports {vgaB[0]}]				
	set_property IOSTANDARD LVCMOS33 [get_ports {vgaB[0]}]

set_property PACKAGE_PIN C7 [get_ports {vgaB[1]}]				
	set_property IOSTANDARD LVCMOS33 [get_ports {vgaB[1]}]

set_property PACKAGE_PIN D7 [get_ports {vgaB[2]}]				
	set_property IOSTANDARD LVCMOS33 [get_ports {vgaB[2]}]

set_property PACKAGE_PIN D8 [get_ports {vgaB[3]}]				
	set_property IOSTANDARD LVCMOS33 [get_ports {vgaB[3]}]

set_property PACKAGE_PIN C6 [get_ports {vgaG[0]}]				
	set_property IOSTANDARD LVCMOS33 [get_ports {vgaG[0]}]

set_property PACKAGE_PIN A5 [get_ports {vgaG[1]}]				
	set_property IOSTANDARD LVCMOS33 [get_ports {vgaG[1]}]

set_property PACKAGE_PIN B6 [get_ports {vgaG[2]}]				
	set_property IOSTANDARD LVCMOS33 [get_ports {vgaG[2]}]

set_property PACKAGE_PIN A6 [get_ports {vgaG[3]}]				
	set_property IOSTANDARD LVCMOS33 [get_ports {vgaG[3]}]

set_property PACKAGE_PIN B11 [get_ports hSync]						
	set_property IOSTANDARD LVCMOS33 [get_ports hSync]

set_property PACKAGE_PIN B12 [get_ports vSync]						
	set_property IOSTANDARD LVCMOS33 [get_ports vSync]

set_property PACKAGE_PIN L13 [get_ports QuadSpiFlashCS]					
	set_property IOSTANDARD LVCMOS33 [get_ports QuadSpiFlashCS]

set_property PACKAGE_PIN L18 [get_ports RamCS]					
	set_property IOSTANDARD LVCMOS33 [get_ports RamCS]

set_property PACKAGE_PIN H14 [get_ports MemOE]					
	set_property IOSTANDARD LVCMOS33 [get_ports MemOE]

set_property PACKAGE_PIN R11 [get_ports MemWR]					
	set_property IOSTANDARD LVCMOS33 [get_ports MemWR]

