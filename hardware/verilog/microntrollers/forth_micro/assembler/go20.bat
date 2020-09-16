asm %1.asm > raw.raw
type raw.raw
makehex20 raw.raw
makemif20 raw.raw
copy raw.hex %2.hex
copy raw.mif %2.mif

