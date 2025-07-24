package float_types_pkg;
typedef struct packed {
  logic        sign;
  logic [7:0]  exp;
  logic [23:0] mant;
} float_point_num;

typedef enum logic{
  OK_state         = 1'b0,
  NAN_or_INF = 1'b1
} num_status;
endpackage
