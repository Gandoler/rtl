package struct_types;
  typedef struct {
    logic        sign;
    logic [7:0]  exp;
    logic [23:0] mant;
  } float_point_num;
endpackage
