# TCL File Generated by Component Editor 18.1
# Thu Sep 17 09:44:43 NZST 2020
# DO NOT MODIFY


# 
# convolution_burst "convolution_burst" v1.0
#  2020.09.17.09:44:43
# 
# 

# 
# request TCL package from ACDS 16.1
# 
package require -exact qsys 16.1


# 
# module convolution_burst
# 
set_module_property DESCRIPTION ""
set_module_property NAME convolution_burst
set_module_property VERSION 1.0
set_module_property INTERNAL false
set_module_property OPAQUE_ADDRESS_MAP true
set_module_property GROUP CustomIP
set_module_property AUTHOR ""
set_module_property DISPLAY_NAME convolution_burst
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE true
set_module_property REPORT_TO_TALKBACK false
set_module_property ALLOW_GREYBOX_GENERATION false
set_module_property REPORT_HIERARCHY false


# 
# file sets
# 
add_fileset QUARTUS_SYNTH QUARTUS_SYNTH "" ""
set_fileset_property QUARTUS_SYNTH TOP_LEVEL convolution_burst
set_fileset_property QUARTUS_SYNTH ENABLE_RELATIVE_INCLUDE_PATHS false
set_fileset_property QUARTUS_SYNTH ENABLE_FILE_OVERWRITE_MODE false
add_fileset_file convolution_burst.sv SYSTEM_VERILOG PATH convolution_burst.sv TOP_LEVEL_FILE


# 
# parameters
# 
add_parameter MAX_XRES INTEGER 256
set_parameter_property MAX_XRES DEFAULT_VALUE 256
set_parameter_property MAX_XRES DISPLAY_NAME MAX_XRES
set_parameter_property MAX_XRES TYPE INTEGER
set_parameter_property MAX_XRES UNITS None
set_parameter_property MAX_XRES ALLOWED_RANGES -2147483648:2147483647
set_parameter_property MAX_XRES HDL_PARAMETER true
add_parameter XRES1 INTEGER 16
set_parameter_property XRES1 DEFAULT_VALUE 16
set_parameter_property XRES1 DISPLAY_NAME XRES1
set_parameter_property XRES1 TYPE INTEGER
set_parameter_property XRES1 UNITS None
set_parameter_property XRES1 ALLOWED_RANGES -2147483648:2147483647
set_parameter_property XRES1 HDL_PARAMETER true
add_parameter XRES2 INTEGER 32
set_parameter_property XRES2 DEFAULT_VALUE 32
set_parameter_property XRES2 DISPLAY_NAME XRES2
set_parameter_property XRES2 TYPE INTEGER
set_parameter_property XRES2 UNITS None
set_parameter_property XRES2 ALLOWED_RANGES -2147483648:2147483647
set_parameter_property XRES2 HDL_PARAMETER true
add_parameter XRES3 INTEGER 64
set_parameter_property XRES3 DEFAULT_VALUE 64
set_parameter_property XRES3 DISPLAY_NAME XRES3
set_parameter_property XRES3 TYPE INTEGER
set_parameter_property XRES3 UNITS None
set_parameter_property XRES3 ALLOWED_RANGES -2147483648:2147483647
set_parameter_property XRES3 HDL_PARAMETER true
add_parameter XRES4 INTEGER 128
set_parameter_property XRES4 DEFAULT_VALUE 128
set_parameter_property XRES4 DISPLAY_NAME XRES4
set_parameter_property XRES4 TYPE INTEGER
set_parameter_property XRES4 UNITS None
set_parameter_property XRES4 ALLOWED_RANGES -2147483648:2147483647
set_parameter_property XRES4 HDL_PARAMETER true
add_parameter XRES5 INTEGER 256
set_parameter_property XRES5 DEFAULT_VALUE 256
set_parameter_property XRES5 DISPLAY_NAME XRES5
set_parameter_property XRES5 TYPE INTEGER
set_parameter_property XRES5 UNITS None
set_parameter_property XRES5 ALLOWED_RANGES -2147483648:2147483647
set_parameter_property XRES5 HDL_PARAMETER true
add_parameter YRES1 INTEGER 16
set_parameter_property YRES1 DEFAULT_VALUE 16
set_parameter_property YRES1 DISPLAY_NAME YRES1
set_parameter_property YRES1 TYPE INTEGER
set_parameter_property YRES1 UNITS None
set_parameter_property YRES1 ALLOWED_RANGES -2147483648:2147483647
set_parameter_property YRES1 HDL_PARAMETER true
add_parameter YRES2 INTEGER 32
set_parameter_property YRES2 DEFAULT_VALUE 32
set_parameter_property YRES2 DISPLAY_NAME YRES2
set_parameter_property YRES2 TYPE INTEGER
set_parameter_property YRES2 UNITS None
set_parameter_property YRES2 ALLOWED_RANGES -2147483648:2147483647
set_parameter_property YRES2 HDL_PARAMETER true
add_parameter YRES3 INTEGER 64
set_parameter_property YRES3 DEFAULT_VALUE 64
set_parameter_property YRES3 DISPLAY_NAME YRES3
set_parameter_property YRES3 TYPE INTEGER
set_parameter_property YRES3 UNITS None
set_parameter_property YRES3 ALLOWED_RANGES -2147483648:2147483647
set_parameter_property YRES3 HDL_PARAMETER true
add_parameter YRES4 INTEGER 128
set_parameter_property YRES4 DEFAULT_VALUE 128
set_parameter_property YRES4 DISPLAY_NAME YRES4
set_parameter_property YRES4 TYPE INTEGER
set_parameter_property YRES4 UNITS None
set_parameter_property YRES4 ALLOWED_RANGES -2147483648:2147483647
set_parameter_property YRES4 HDL_PARAMETER true
add_parameter YRES5 INTEGER 256
set_parameter_property YRES5 DEFAULT_VALUE 256
set_parameter_property YRES5 DISPLAY_NAME YRES5
set_parameter_property YRES5 TYPE INTEGER
set_parameter_property YRES5 UNITS None
set_parameter_property YRES5 ALLOWED_RANGES -2147483648:2147483647
set_parameter_property YRES5 HDL_PARAMETER true
add_parameter RESOLUTIONS INTEGER 5
set_parameter_property RESOLUTIONS DEFAULT_VALUE 5
set_parameter_property RESOLUTIONS DISPLAY_NAME RESOLUTIONS
set_parameter_property RESOLUTIONS TYPE INTEGER
set_parameter_property RESOLUTIONS UNITS None
set_parameter_property RESOLUTIONS ALLOWED_RANGES -2147483648:2147483647
set_parameter_property RESOLUTIONS HDL_PARAMETER true
add_parameter KX INTEGER 3
set_parameter_property KX DEFAULT_VALUE 3
set_parameter_property KX DISPLAY_NAME KX
set_parameter_property KX TYPE INTEGER
set_parameter_property KX UNITS None
set_parameter_property KX ALLOWED_RANGES -2147483648:2147483647
set_parameter_property KX HDL_PARAMETER true
add_parameter KY INTEGER 3
set_parameter_property KY DEFAULT_VALUE 3
set_parameter_property KY DISPLAY_NAME KY
set_parameter_property KY TYPE INTEGER
set_parameter_property KY UNITS None
set_parameter_property KY ALLOWED_RANGES -2147483648:2147483647
set_parameter_property KY HDL_PARAMETER true
add_parameter EXP INTEGER 8
set_parameter_property EXP DEFAULT_VALUE 8
set_parameter_property EXP DISPLAY_NAME EXP
set_parameter_property EXP TYPE INTEGER
set_parameter_property EXP UNITS None
set_parameter_property EXP ALLOWED_RANGES -2147483648:2147483647
set_parameter_property EXP HDL_PARAMETER true
add_parameter MANT INTEGER 7
set_parameter_property MANT DEFAULT_VALUE 7
set_parameter_property MANT DISPLAY_NAME MANT
set_parameter_property MANT TYPE INTEGER
set_parameter_property MANT UNITS None
set_parameter_property MANT ALLOWED_RANGES -2147483648:2147483647
set_parameter_property MANT HDL_PARAMETER true
add_parameter WIDTHF INTEGER 16
set_parameter_property WIDTHF DEFAULT_VALUE 16
set_parameter_property WIDTHF DISPLAY_NAME WIDTHF
set_parameter_property WIDTHF TYPE INTEGER
set_parameter_property WIDTHF UNITS None
set_parameter_property WIDTHF ALLOWED_RANGES -2147483648:2147483647
set_parameter_property WIDTHF HDL_PARAMETER true
add_parameter FIFO_DEPTH INTEGER 512
set_parameter_property FIFO_DEPTH DEFAULT_VALUE 512
set_parameter_property FIFO_DEPTH DISPLAY_NAME FIFO_DEPTH
set_parameter_property FIFO_DEPTH TYPE INTEGER
set_parameter_property FIFO_DEPTH UNITS None
set_parameter_property FIFO_DEPTH ALLOWED_RANGES -2147483648:2147483647
set_parameter_property FIFO_DEPTH HDL_PARAMETER true
add_parameter WIDTH INTEGER 16
set_parameter_property WIDTH DEFAULT_VALUE 16
set_parameter_property WIDTH DISPLAY_NAME WIDTH
set_parameter_property WIDTH TYPE INTEGER
set_parameter_property WIDTH UNITS None
set_parameter_property WIDTH ALLOWED_RANGES -2147483648:2147483647
set_parameter_property WIDTH HDL_PARAMETER true
add_parameter WIDTHBE INTEGER 2
set_parameter_property WIDTHBE DEFAULT_VALUE 2
set_parameter_property WIDTHBE DISPLAY_NAME WIDTHBE
set_parameter_property WIDTHBE TYPE INTEGER
set_parameter_property WIDTHBE UNITS None
set_parameter_property WIDTHBE ALLOWED_RANGES -2147483648:2147483647
set_parameter_property WIDTHBE HDL_PARAMETER true
add_parameter WIDTHBC INTEGER 9
set_parameter_property WIDTHBC DEFAULT_VALUE 9
set_parameter_property WIDTHBC DISPLAY_NAME WIDTHBC
set_parameter_property WIDTHBC TYPE INTEGER
set_parameter_property WIDTHBC UNITS None
set_parameter_property WIDTHBC ALLOWED_RANGES -2147483648:2147483647
set_parameter_property WIDTHBC HDL_PARAMETER true


# 
# display items
# 


# 
# connection point clock
# 
add_interface clock clock end
set_interface_property clock clockRate 0
set_interface_property clock ENABLED true
set_interface_property clock EXPORT_OF ""
set_interface_property clock PORT_NAME_MAP ""
set_interface_property clock CMSIS_SVD_VARIABLES ""
set_interface_property clock SVD_ADDRESS_GROUP ""

add_interface_port clock clock clk Input 1


# 
# connection point clock_sreset
# 
add_interface clock_sreset reset end
set_interface_property clock_sreset associatedClock clock
set_interface_property clock_sreset synchronousEdges BOTH
set_interface_property clock_sreset ENABLED true
set_interface_property clock_sreset EXPORT_OF ""
set_interface_property clock_sreset PORT_NAME_MAP ""
set_interface_property clock_sreset CMSIS_SVD_VARIABLES ""
set_interface_property clock_sreset SVD_ADDRESS_GROUP ""

add_interface_port clock_sreset clock_sreset reset Input 1


# 
# connection point slave
# 
add_interface slave avalon end
set_interface_property slave addressUnits WORDS
set_interface_property slave associatedClock clock
set_interface_property slave associatedReset clock_sreset
set_interface_property slave bitsPerSymbol 8
set_interface_property slave burstOnBurstBoundariesOnly false
set_interface_property slave burstcountUnits WORDS
set_interface_property slave explicitAddressSpan 0
set_interface_property slave holdTime 0
set_interface_property slave linewrapBursts false
set_interface_property slave maximumPendingReadTransactions 0
set_interface_property slave maximumPendingWriteTransactions 0
set_interface_property slave readLatency 0
set_interface_property slave readWaitTime 1
set_interface_property slave setupTime 0
set_interface_property slave timingUnits Cycles
set_interface_property slave writeWaitTime 0
set_interface_property slave ENABLED true
set_interface_property slave EXPORT_OF ""
set_interface_property slave PORT_NAME_MAP ""
set_interface_property slave CMSIS_SVD_VARIABLES ""
set_interface_property slave SVD_ADDRESS_GROUP ""

add_interface_port slave s_address address Input 4
add_interface_port slave s_writedata writedata Input 32
add_interface_port slave s_readdata readdata Output 32
add_interface_port slave s_read read Input 1
add_interface_port slave s_write write Input 1
add_interface_port slave s_waitrequest waitrequest Output 1
set_interface_assignment slave embeddedsw.configuration.isFlash 0
set_interface_assignment slave embeddedsw.configuration.isMemoryDevice 0
set_interface_assignment slave embeddedsw.configuration.isNonVolatileStorage 0
set_interface_assignment slave embeddedsw.configuration.isPrintableDevice 0


# 
# connection point avalon_master
# 
add_interface avalon_master avalon start
set_interface_property avalon_master addressUnits SYMBOLS
set_interface_property avalon_master associatedClock clock
set_interface_property avalon_master associatedReset clock_sreset
set_interface_property avalon_master bitsPerSymbol 8
set_interface_property avalon_master burstOnBurstBoundariesOnly false
set_interface_property avalon_master burstcountUnits WORDS
set_interface_property avalon_master doStreamReads false
set_interface_property avalon_master doStreamWrites false
set_interface_property avalon_master holdTime 0
set_interface_property avalon_master linewrapBursts false
set_interface_property avalon_master maximumPendingReadTransactions 0
set_interface_property avalon_master maximumPendingWriteTransactions 0
set_interface_property avalon_master readLatency 0
set_interface_property avalon_master readWaitTime 1
set_interface_property avalon_master setupTime 0
set_interface_property avalon_master timingUnits Cycles
set_interface_property avalon_master writeWaitTime 0
set_interface_property avalon_master ENABLED true
set_interface_property avalon_master EXPORT_OF ""
set_interface_property avalon_master PORT_NAME_MAP ""
set_interface_property avalon_master CMSIS_SVD_VARIABLES ""
set_interface_property avalon_master SVD_ADDRESS_GROUP ""

add_interface_port avalon_master m_address address Output 32
add_interface_port avalon_master m_readdata readdata Input WIDTH
add_interface_port avalon_master m_writedata writedata Output WIDTH
add_interface_port avalon_master m_byteenable byteenable Output WIDTHBE
add_interface_port avalon_master m_burstcount burstcount Output WIDTHBC
add_interface_port avalon_master m_read read Output 1
add_interface_port avalon_master m_write write Output 1
add_interface_port avalon_master m_readdatavalid readdatavalid Input 1
add_interface_port avalon_master m_waitrequest waitrequest Input 1


# 
# connection point interrupt_sender
# 
add_interface interrupt_sender interrupt end
set_interface_property interrupt_sender associatedAddressablePoint ""
set_interface_property interrupt_sender associatedClock clock
set_interface_property interrupt_sender associatedReset clock_sreset
set_interface_property interrupt_sender bridgedReceiverOffset ""
set_interface_property interrupt_sender bridgesToReceiver ""
set_interface_property interrupt_sender ENABLED true
set_interface_property interrupt_sender EXPORT_OF ""
set_interface_property interrupt_sender PORT_NAME_MAP ""
set_interface_property interrupt_sender CMSIS_SVD_VARIABLES ""
set_interface_property interrupt_sender SVD_ADDRESS_GROUP ""

add_interface_port interrupt_sender s_irq irq Output 1

