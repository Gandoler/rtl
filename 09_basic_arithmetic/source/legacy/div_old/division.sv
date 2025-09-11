module division#(
  parameter width = 4
)(
  input logic [width-1:0] A, B,

  output logic [width-1:0] Q ,R
);


   logic [width-1:0] R_out [width-1:0];
   logic [width-1:0] B_out [width-1:0];
   logic [width-1:0] C_out [width-1:0];
   logic [width-1:0] D     [width-1:0];
   logic             junk             ;

   generate
       genvar i,j; // i - столбец, j - строка

       for(i = 0; i < width; i++) begin
         for(j = 0; j < width; j++) begin

           if((i == width-1) && (j == 0)) begin// угловой случай
             div_block div_block_i_j(
               .R(A[width-1]),
               .B(!B[0]),
               .C_in('b1),
               .D(D[i][j]),

               .C_out(C_out[i][j]),
               .N(D[0][j]),
               .B_out(B_out[i][j]),
               .R_out(R_out[i][j])
             );
           end else if (i == (width - 1) && (j != 0)) begin// правая граница, исключая угловой случай

             div_block div_block_i_j(
               .R(A[width -1 - j]),
               .B(B_out[i][j-1]),
               .C_in('b1),
               .D(D[i][j]),

               .C_out(C_out[i][j]),
               .N(D[0][j]),
               .B_out(B_out[i][j]),
               .R_out(R_out[i][j])
             );
           end else if ((j == 0) && (i != (width - 1))) begin // верхняя граница, исключая угловой случай

             div_block div_block_i_j(
               .R('b0),
               .B(!B[(width - 1) - i]),
               .C_in(C_out[i+1][j]),
               .D(D[i][j]),

               .C_out(C_out[i][j]),
               .N(D[0][j]),
               .B_out(B_out[i][j]),
               .R_out(R_out[i][j])
             );
           end else if ((j > 0 ) && (i < (width - 1))) begin //  серединка

             div_block div_block_i_j(
               .R(R_out[i+1][j]),
               .B(B_out[i][j-1]),
               .C_in(C_out[i+1][j]),
               .D(D[i][j]),

               .C_out(C_out[i][j]),
               .N(D[0][j]),
               .B_out(B_out[i][j]),
               .R_out(R_out[i][j])
             );
           end
         end
       end
   endgenerate

  always_comb begin
    for (int i = 0; i < width; i++)begin
      Q[i] = !(D[(width - 1) -i]);
    end
    for (int i = 0; i < width; i++)begin
      R[i] = R_out[(width - 1) - i][width-1];
    end
  end

endmodule
