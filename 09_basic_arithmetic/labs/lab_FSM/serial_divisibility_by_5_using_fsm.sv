module serial_divisibility_by_5_using_fsm
(
  input  clk,
  input  rst,
  input  new_bit,
  output div_by_5
);

  // Implement a module that performs a serial test if input number is divisible by 5.
  //
  // On each clock cycle, module receives the next 1 bit of the input number.
  // The module should set output to 1 if the currently known number is divisible by 5.
  //
  // Hint: new bit is coming to the right side of the long binary number `X`.
  // It is similar to the multiplication of the number by 2*X or by 2*X + 1.
  //
  // Hint 2: As we are interested only in the remainder, all operations are performed under the modulo 5 (% 5).
  // Check manually how the remainder changes under such modulo.
  enum logic[2:0]
  {
     mod_0 = 3'b000,
     mod_1 = 3'b001,
     mod_2 = 3'b010,
     mod_3 = 3'b011,
     mod_4 = 3'b100,
     mod_5 = 3'b101
  }
  state, new_state;

  // State transition logic
  always_comb
  begin
    new_state = state;

    // This lint warning is bogus because we assign the default value above
    // verilator lint_off CASEINCOMPLETE

    case (state)
      mod_0 : if(new_bit) new_state = mod_1; //1
              else        new_state = mod_0;

      mod_1 : if(new_bit) new_state = mod_3; //3
              else        new_state = mod_2; //2

      mod_2 : if(new_bit) new_state = mod_0; //5
              else        new_state = mod_4; //4

      mod_3 : if(new_bit) new_state = mod_2; //7
              else        new_state = mod_1; //6

      mod_4 : if(new_bit) new_state = mod_4; //9
              else        new_state = mod_3; //8

    endcase

    // verilator lint_on CASEINCOMPLETE

  end

  // Output logic
  assign div_by_5 = (state == mod_0);

  // State update
  always_ff @ (posedge clk)
    if (rst)
      state <= mod_0;
    else
      state <= new_state;

endmodule
