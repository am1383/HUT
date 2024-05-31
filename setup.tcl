vcom *.vhd		

eval vsim work.main

add wave -r /* 			

force -freeze sim:/main/CLK 1 0, 0 {5000 ps} -r 10ns