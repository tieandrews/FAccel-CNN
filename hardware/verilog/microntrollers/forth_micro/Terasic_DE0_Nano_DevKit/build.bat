call forth.bat %1 ..\code.mif
call update_mif.bat
C:\intelFPGA\18.1\quartus\bin64\quartus_pgm -m JTAG -o "p;output_files\micro_10m50_top.sof"
