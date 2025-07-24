package float_types_pkg;
typedef struct packed {
  logic        sign;
  logic [7:0]  exp;
  logic [23:0] mant;
} float_point_num;

typedef enum logic{
  INF_OR_NAN  = 1'b0,
  GOOD = 1'b1
} num_status;
endpackage
