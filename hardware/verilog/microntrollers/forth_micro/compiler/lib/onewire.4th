( -------------------------------------------------------------------------- )
: onewire_wait_busy ( base -- ) swap begin dup @ $2 and 0= until drop ;
( -------------------------------------------------------------------------- )
: onewire_drive_high ( base -- ) swap dup onewire_wait_busy $1 swap 1+ ! ;
: onewire_drive_low ( base -- ) swap dup onewire_wait_busy $0 swap 1+ ! ;
: onewire_drive_z ( base -- ) swap dup onewire_wait_busy $2 swap 1+ ! ;
( -------------------------------------------------------------------------- )
: onewire_reset ( base -- t/f ) swap dup onewire_drive_high
   dup onewire_drive_z dup $0 swap ! dup onewire_wait_busy
   @ $4 and 0<> swap ;
( -------------------------------------------------------------------------- )
: onewire_write_bit ( base n -- ) >r $1 and 0= if $1 else $2 then
   over over swap ! drop onewire_wait_busy r> ;
( -------------------------------------------------------------------------- )
: onewire_read_bit ( base -- n ) swap dup $3 swap ! dup onewire_wait_busy
   1+ @ swap ;
( -------------------------------------------------------------------------- )
: onewire_send_bits ( base n b -- ) >r 0 do over over onewire_write_bit
   2/ loop drop drop r> ;
( -------------------------------------------------------------------------- )
: onewire_send_byte ( base n -- ) >r 8 0 do over over onewire_write_bit
   2/ loop drop drop r> ;
( -------------------------------------------------------------------------- )
: onewire_read_byte ( base -- n ) swap $0 8 0 do 2/ over onewire_read_bit
   0<> if $80 else $0 then or loop swap drop swap ;
( -------------------------------------------------------------------------- )
: onewire_skip_rom ( base -- ) swap $cc onewire_send_byte ;
( -------------------------------------------------------------------------- )
: onewire_read_rom ( base -- ) swap $33 onewire_send_byte ;
( -------------------------------------------------------------------------- )
: onewire_convert_temp ( base tickvar -- ) >r swap dup $44 onewire_send_byte
   dup onewire_drive_high swap 750 swap wait_var ( wait 750ms )
   onewire_drive_z r> ;
( -------------------------------------------------------------------------- )
: onewire_read_scratch ( base -- ) swap $be onewire_send_byte ;
( -------------------------------------------------------------------------- )
: onewire_match_rom ( base -- ) swap $55 onewire_send_byte ;
( -------------------------------------------------------------------------- )
: onewire_read_word16 ( base -- n ) swap dup onewire_read_byte swap
   onewire_read_byte 8 lshift or swap ;
( -------------------------------------------------------------------------- )
: onewire_get_id ( base -- n ) swap dup onewire_read_rom onewire_read_byte swap ;
( -------------------------------------------------------------------------- )
: onewire_start_temp ( base -- ) swap dup onewire_reset drop dup
   onewire_skip_rom onewire_convert_temp ;
( -------------------------------------------------------------------------- )
: onewire_read_temp ( base -- t ) swap dup onewire_reset drop dup
   onewire_skip_rom dup onewire_read_scratch dup onewire_read_word16 swap
   dup onewire_reset drop onewire_get_id \ read device ID
   $28 = if ( DS18B20 ) 2/ 2/ 2/ then
   swap ;
( -------------------------------------------------------------------------- )
: onewire_crc8_calc ( crc n -- crc ) >r xor 8 0 do dup $1 and 0<>
   if 2/ $8c xor else 2/ then loop r> ;
