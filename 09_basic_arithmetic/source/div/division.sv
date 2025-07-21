module division#(
  parameter width = 4;
)(
  input logic [width-1:0] A, B;

  output logic [width-1:0] Q ,R;
);


   logic [width-1:0] R_out [width-1:0];
   logic [width-1:0] B_out [width-1:0];
   logic [width-1:0] C_out [width-1:0];
   logic [width-1:0] D                ;
   logic             junk             ;

   generate
       genvar i,j; // i - столбец, j - строка

       for(i; i < width; i++) begin
         for(j; j < width; j++) begin

           if((i == *width-1) && (j == 0)) begin// угловой случай
             division_i_j(
               R(A[width-1]),
               B(!B[0]),
               C_in('b1),
               N(D[0]),

               C_out('b1),
               D(),
               B_out(B_out[i][j]),
               R_out(R_out[i][j])
             );
           end else if (i == (width - 1) && (j != 0)) begin// правая граница, исключая угловой случай

             division_i_j(
               R(A[with -1 - J]),
               B(B_out[i][j-1]),
               C_in('b1),
               N(D[j]),

               C_out(C_out[i][j]),
               D(),
               B_out(B_out[i][j]),
               R_out(R_out[i][j])
             );
           end else if ((j == 0) && (i != (width - 1))) begin // верхняя граница, исключая угловой случай

             division_i_j(
               R('b0),
               B(!B[(with - 1) - i]),
               C_in(C_out[i+1][j]),
               N(D[j]),

               C_out(C_out[i][j]),
               D((i == 0)? D[j] : junk),
               B_out(B_out[i][j]),
               R_out(R_out[i][j])
             );
           end else if ((j > 0 ) && (i < (width - 1))) begin //  серединка

             division_i_j(
               R(R_out[i+1][j]),
               B(B_out[i][j-1]),
               C_in(C_out[i+1][j]),
               N(D[j]),

               C_out(C_out[i][j]),
               D((i == 0)? D[j] : junk),
               B_out(B_out[i][j]),
               R_out(R_out[i][j])
             );
           end
         end
       end
   endgenerate

  always_comb begin
    for (int i = 0; i < (width - 1); i++)begin
      Q[i] = !(D[(width - 1) -i])
    end
    for (int i = 0; i < (width - 1); i++)begin
      R[i] = R_out[(width - 1) - i][width-1]
    end
  end

endmodule
