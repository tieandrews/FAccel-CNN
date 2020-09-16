asm %1.asm > raw.raw
type raw.raw
makehex16 raw.raw
makemif16 raw.raw
copy raw.hex %2.hex
copy raw.mif %2.mif

