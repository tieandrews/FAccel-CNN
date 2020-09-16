
#define jp n { prefix n; jnz; }
#define jpz n { zeq; prefix n; and; jnz; }
#define jpnz n { zeq; zeq; prefix n; and; jnz; }
#define js n { prefix n; jsr; }
#define ret { jnz; }

#define if { jpz if_else[if_else]; }
#define else { jp if_exit[if_exit]; lbl if_else[if_else]; }
#define then { lbl if_exit[if_exit]; lbl if_else[if_else]; }
#define begin { lbl begin_loop[begin_loop]; }
#define until { zeq; jpz begin_loop[begin_loop]; }
#define again { jp begin_loop[begin_loop]; }
