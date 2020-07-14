# TCL File Generated by Component Editor 18.1
# Wed May 13 10:32:24 NZST 2020
# DO NOT MODIFY


# 
# dma_engine "dma_engine" v1.0
#  2020.05.13.10:32:24
# 
# 

# 
# request TCL package from ACDS 16.1
# 
package require -exact qsys 16.1


# 
# module dma_engine
# 
set_module_property DESCRIPTION ""
set_module_property NAME dma_engine
set_module_property VERSION 1.0
set_module_property INTERNAL false
set_module_property OPAQUE_ADDRESS_MAP true
set_module_property GROUP CustomIP
set_module_property AUTHOR ""
set_module_property DISPLAY_NAME dma_engine
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE true
set_module_property REPORT_TO_TALKBACK false
set_module_property ALLOW_GREYBOX_GENERATION false
set_module_property REPORT_HIERARCHY false


# 
# file sets
# 
add_fileset QUARTUS_SYNTH QUARTUS_SYNTH "" ""
set_fileset_property QUARTUS_SYNTH TOP_LEVEL dma_engine
set_fileset_property QUARTUS_SYNTH ENABLE_RELATIVE_INCLUDE_PATHS false
set_fileset_property QUARTUS_SYNTH ENABLE_FILE_OVERWRITE_MODE false
add_fileset_file dma_engine.sv SYSTEM_VERILOG PATH dma_engine.sv TOP_LEVEL_FILE


# 
# parameters
# 


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
# connection point irq
# 
add_interface irq interrupt end
set_interface_property irq associatedAddressablePoint ""
set_interface_property irq associatedClock clock
set_interface_property irq associatedReset clock_sreset
set_interface_property irq bridgedReceiverOffset ""
set_interface_property irq bridgesToReceiver ""
set_interface_property irq ENABLED true
set_interface_property irq EXPORT_OF ""
set_interface_property irq PORT_NAME_MAP ""
set_interface_property irq CMSIS_SVD_VARIABLES ""
set_interface_property irq SVD_ADDRESS_GROUP ""

add_interface_port irq s_irq irq Output 1


# 
# connection point read_master
# 
add_interface read_master avalon start
set_interface_property read_master addressUnits SYMBOLS
set_interface_property read_master associatedClock clock
set_interface_property read_master associatedReset clock_sreset
set_interface_property read_master bitsPerSymbol 8
set_interface_property read_master burstOnBurstBoundariesOnly false
set_interface_property read_master burstcountUnits WORDS
set_interface_property read_master doStreamReads false
set_interface_property read_master doStreamWrites false
set_interface_property read_master holdTime 0
set_interface_property read_master linewrapBursts false
set_interface_property read_master maximumPendingReadTransactions 0
set_interface_property read_master maximumPendingWriteTransactions 0
set_interface_property read_master readLatency 0
set_interface_property read_master readWaitTime 1
set_interface_property read_master setupTime 0
set_interface_property read_master timingUnits Cycles
set_interface_property read_master writeWaitTime 0
set_interface_property read_master ENABLED true
set_interface_property read_master EXPORT_OF ""
set_interface_property read_master PORT_NAME_MAP ""
set_interface_property read_master CMSIS_SVD_VARIABLES ""
set_interface_property read_master SVD_ADDRESS_GROUP ""

add_interface_port read_master mr_address address Output 32
add_interface_port read_master mr_byteenable byteenable Output 2
add_interface_port read_master mr_readdata readdata Input 16
add_interface_port read_master mr_waitrequest waitrequest Input 1
add_interface_port read_master mr_read read Output 1


# 
# connection point write_master
# 
add_interface write_master avalon start
set_interface_property write_master addressUnits SYMBOLS
set_interface_property write_master associatedClock clock
set_interface_property write_master associatedReset clock_sreset
set_interface_property write_master bitsPerSymbol 8
set_interface_property write_master burstOnBurstBoundariesOnly false
set_interface_property write_master burstcountUnits WORDS
set_interface_property write_master doStreamReads false
set_interface_property write_master doStreamWrites false
set_interface_property write_master holdTime 0
set_interface_property write_master linewrapBursts false
set_interface_property write_master maximumPendingReadTransactions 0
set_interface_property write_master maximumPendingWriteTransactions 0
set_interface_property write_master readLatency 0
set_interface_property write_master readWaitTime 1
set_interface_property write_master setupTime 0
set_interface_property write_master timingUnits Cycles
set_interface_property write_master writeWaitTime 0
set_interface_property write_master ENABLED true
set_interface_property write_master EXPORT_OF ""
set_interface_property write_master PORT_NAME_MAP ""
set_interface_property write_master CMSIS_SVD_VARIABLES ""
set_interface_property write_master SVD_ADDRESS_GROUP ""

add_interface_port write_master mw_address address Output 32
add_interface_port write_master mw_byteenable byteenable Output 2
add_interface_port write_master mw_write write Output 1
add_interface_port write_master mw_writedata writedata Output 16
add_interface_port write_master mw_waitrequest waitrequest Input 1

