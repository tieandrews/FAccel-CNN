: lshift ( n d -- n<<d ) >r begin dup 0<> while 1- swap 2* swap repeat drop r> ;
: rshift ( n d -- n>>d ) >r begin dup 0<> while 1- swap 2/ swap repeat drop r> ;
: within ( a b c -- t/f ) >r rot dup -rot swap < -rot swap >= and r> ;
: within? ( a b c -- t/f ) >r rot dup -rot swap <= -rot swap >= and r> ;
