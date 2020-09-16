( -------------------------------------------------------------------------- )
\ macro timer_set_counter ( n -- ) [ TIMER0_BASE 1 + ] ! endmacro
macro timer_set_counter ( base n -- ) swap 1+ ! endmacro
\ macro timer_set_reload ( n -- ) [ TIMER0_BASE 2 + ] ! endmacro
macro timer_set_reload ( base n -- ) swap 2 + ! endmacro
\ macro timer_irq_ack ( -- ) 1 [ TIMER0_BASE 3 + ] ! endmacro
macro timer_irq_ack ( base -- ) 1 swap 3 + ! endmacro
\ : timer_reload_enable ( -- ) TIMER0_BASE dup @ 4 set_bits swap ! ;
: timer_reload_enable ( base -- ) swap dup @ 4 set_bits swap ! ;
\ : timer_reload_disable ( -- ) TIMER0_BASE dup @ 4 clear_bits swap ! ;
: timer_reload_disable ( base -- ) swap dup @ 4 clear_bits swap ! ;
\ : timer_enable ( -- ) TIMER0_BASE dup @ 1 set_bits swap ! ;
: timer_enable ( base -- ) swap dup @ 1 set_bits swap ! ;
\ : timer_disable ( -- ) TIMER0_BASE dup @ 1 clear_bits swap ! ;
: timer_disable ( base -- ) swap dup @ 1 clear_bits swap ! ;
\ : timer_irq_enable ( -- ) TIMER0_BASE dup @ 2 set_bits swap ! ;
: timer_irq_enable ( base -- ) swap dup @ 2 set_bits swap ! ;
\ : timer_irq_disable ( -- ) TIMER0_BASE dup @ 2 clear_bits swap ! ;
: timer_irq_disable ( base -- ) swap dup @ 2 clear_bits swap ! ;
\ macro timer_init ( -- ) timer_reload_disable timer_irq_disable
\    timer_disable endmacro
macro timer_init ( base -- ) dup dup timer_reload_disable timer_irq_disable
   timer_disable endmacro
: timer_set_rate ( base n -- ) >r over over timer_set_counter timer_set_reload r> ;
