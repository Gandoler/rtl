package float_types_pkg;
typedef struct packed {
  logic        sign;
  logic [7:0]  exp;
  logic [23:0] mant;
} float_point_num;

typedef enum logic{
  OK_state    = 2'b00,
  INF_OR_NAN  = 1'b01,
  ZERO_res    = 2'b10
} num_status;
endpackage
