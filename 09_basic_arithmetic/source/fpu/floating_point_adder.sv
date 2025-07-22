module floating_point_adder (
    input               clk,
    input               rst,

    input  logic [31:0] a,
    input  logic [31:0] b,
    input  logic        arg_vld,

    output logic [31:0] result,
    output logic [1:0]  state,
    output logic        res_vld
);
  enum logic[1:0]{
    OK  = 2'b00,
    NAN = 2'b01,
    INF = 2'b10,
    NUL = 2'b11
  } states;

  typedef struct {
    logic        sign;
    logic [7:0]  exp;
    logic [23:0] mant
  } float_point_num;

  //сдвиговые регистры
  float_point_num [5:0] a, b;
  logic           [5:0] a_vld;


   always_ff @( posedge clk ) begin // fetch
    if (rst) begin
      a.sign <= 'b0;
      a.exp  <= 'b0;
      a.mant <= 'b0

      b.sign <= 'b0;
      b.exp  <= 'b0;
      b.mant <= 'b0;
    end else if(arg_vld) begin
      a.sign = a[31];
      a.exp  = a[30:23];
      a.mant = a[22:0]

      b.sign = b[31];
      b.exp  = b[30:23];
      b.mant = b[22:0];
    end

  end



  always_comb begin

    if()

  end




endmodule
