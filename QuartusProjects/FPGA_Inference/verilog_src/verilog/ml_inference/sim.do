vsim -gui work.convolution_calc_tb -Lf altera_mf_ver -Lf lpm_ver

add wave -position end  sim:/convolution_calc_tb/clock
add wave -position end  sim:/convolution_calc_tb/clock_sreset
add wave -position end  sim:/convolution_calc_tb/state
add wave -position end  sim:/convolution_calc_tb/kernel_valid
add wave -position end  sim:/convolution_calc_tb/kernel_data
add wave -position end  sim:/convolution_calc_tb/enable_calc
add wave -position end  sim:/convolution_calc_tb/data_shift
add wave -position end  sim:/convolution_calc_tb/data
add wave -position end  sim:/convolution_calc_tb/result_valid
add wave -position end  sim:/convolution_calc_tb/result

add wave -position end  sim:/convolution_calc_tb/dut/x
add wave -position end  sim:/convolution_calc_tb/dut/y
add wave -position end  sim:/convolution_calc_tb/dut/t
add wave -position end  sim:/convolution_calc_tb/dut/yy
add wave -position end  sim:/convolution_calc_tb/dut/kernel
add wave -position end  sim:/convolution_calc_tb/dut/buffer
add wave -position end  sim:/convolution_calc_tb/dut/add_items
add wave -position end  sim:/convolution_calc_tb/dut/buffer_taps
add wave -position end  sim:/convolution_calc_tb/dut/mlt_valid

restart

run
