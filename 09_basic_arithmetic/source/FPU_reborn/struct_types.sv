package struct_types;
  typedef struct {
    logic        sign;
    logic [7:0]  exp;
    logic [23:0] mant;
  } float_point_num;

  typedef enum logic[1:0]{
    INF  = 00,
    NAN  = 01,
    GOOD = 11
  } num_status;
endpackage
