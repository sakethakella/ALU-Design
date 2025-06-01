//adder subractor
module Adder_subractor (input[15:0]a, input[15:0]b, input op_add_sub, output reg [15:0] sum, output reg cout, output reg overflow,output reg zero,output reg negative);
    always@(*)begin
        {cout,sum}=(op_add_sub)?a+b:a-b;
        overflow= (op_add_sub)?((~a[15] & ~b[15] & sum[15]) | (a[15] & b[15] & ~sum[15])):((~a[15] & b[15] & sum[15]) | (a[15] & ~b[15] & ~sum[15]));
        zero=((sum==16'd0)&&(cout==1'b0))?1'b1:1'b0;
        negative=(sum[15])?1'b1:1'b0;
    end
endmodule

//bitwise unit
module bitwiseunit(
    input [15:0]a,
    input[15:0]b,
    input[1:0] select_bit,
    output reg [15:0] c,
    output reg zero,
    output reg negative,
    output reg cout,
    output reg overflow
);
always @(*)begin 
    case(select_bit)
        2'b00:c=a&b;
        2'b01:c=a|b;
        2'b10:c=a^b;
        default:c=16'd0;
    endcase
    cout=1'b0;
    overflow=1'b0;
    zero=(c==16'd0)?1'b1:1'b0;
    negative=(c[15]==1'b1)?1'b1:1'b0;
end
endmodule

//shifter unit
module shifter (
    input [15:0]a,
    input[15:0]b,
    input [1:0] shift_op,
    output reg [15:0]c,
    output reg zero,
    output reg negative,
    output reg overflow,
    output reg cout
);
 always @(*)begin
    case(shift_op)
        2'b00:c=a<<1;
        2'b01:c=a>>1;
        2'b10:c=a<<<1;
    endcase
    zero=(c==16'd0)?1'b1:1'b0;
    overflow=1'b0;
    cout=1'b0;
    negative=(c[15]==1'b1)?1'b1:1'b0;
 end
endmodule

//demultiplexer
module demultiplexer (
    input [15:0] a,
    input [1:0] sel,
    output reg [15:0]b,
    output reg [15:0]c,
    output reg [15:0]d
);
    always @(*)begin
        case(sel)
          2'b00:begin
            b=a;
            c=16'd0;
            d=16'd0;
          end
          2'b01:begin
            c=a;
            b=16'd0;
            d=16'd0;
          end
          2'b10:begin
            d=a;
            c=16'd0;
            b=16'd0;
          end
          default:begin
            b=16'd0;
            c=16'd0;
            d=16'd0;
          end
        endcase
    end
endmodule
//multiplexer
module multiplexer (
    input [15:0] a1,
    input [15:0] a2,
    input [15:0] a3,
    input [1:0]sel,
    output reg [15:0] y
);
    always@(*)begin
        case(sel)
            2'b00:y=a1;
            2'b01:y=a2;
            2'b10:y=a3;
            default:y=16'd0;
        endcase
    end
endmodule

//datapath module
module datapath (
    input [15:0]a,
    input [15:0]b,
    input [1:0]sel1,
    input [1:0]sel2,
    input op_add_sub,
    input [1:0]select_bit,
    input[1:0] shift_op,
    output [15:0]c,
    output [2:0] cout,
    output [2:0] overflow,
    output [2:0] negative,
    output [2:0] zero
);
    wire[15:0]a1;
    wire[15:0]a2;
    wire[15:0]a3;
    wire [15:0]b1;
    wire [15:0]b2;
    wire [15:0]b3;
    wire [15:0]c1;
    wire [15:0]c2;
    wire [15:0]c3;
    demultiplexer a11(a,sel1,a1,a2,a3);
    demultiplexer a21(b,sel1,b1,b2,b3);
    Adder_subractor a31(a1,b1,op_add_sub,c1,cout[0],overflow[0],zero[0],negative[0]);
    bitwiseunit a41(a2,b2,select_bit,c2,zero[1],negative[1],cout[1],overflow[1]);
    shifter a51(a3,b3,shift_op,c3,zero[2],negative[2],overflow[2],cout[2]);
    multiplexer a61(c1,c2,c3,sel2,c);
endmodule

module controlpath(
    input clk,
    input [2:0] op,
    input [15:0] c,
    input [2:0] cout,
    input [2:0] overflow,
    input [2:0] negative,
    input [2:0] zero,
    output reg [1:0] sel1,
    output reg [1:0] sel2,
    output reg op_add_sub,
    output reg [1:0] select_bit,
    output reg [1:0] shift_op,
    output reg [15:0] kk
);
    always @(posedge clk) begin
        // Default values
        sel1 = 2'b00;
        sel2 = 2'b00;
        op_add_sub = 1'b0;
        select_bit = 2'b00;
        shift_op = 2'b00;

        case (op)
            3'd0: begin // Addition
                sel1 = 2'b00;
                sel2 = 2'b00;
                op_add_sub = 1'b1;
            end 
            3'd1: begin // Subtraction
                sel1 = 2'b00;
                sel2 = 2'b00;
                op_add_sub = 1'b0;
            end
            3'd2: begin // AND
                sel1 = 2'b01;
                sel2 = 2'b01;
                select_bit = 2'b00;
            end
            3'd3: begin // OR
                sel1 = 2'b01;
                sel2 = 2'b01;
                select_bit = 2'b01;
            end
            3'd4: begin // XOR
                sel1 = 2'b01;
                sel2 = 2'b01;
                select_bit = 2'b10;
            end
            3'd5: begin // Left shift
                sel1 = 2'b10;
                sel2 = 2'b10;
                shift_op = 2'b00;
            end
            3'd6: begin // Right shift
                sel1 = 2'b10;
                sel2 = 2'b10;
                shift_op = 2'b01;
            end
            3'd7: begin // Arithmetic right shift
                sel1 = 2'b10;
                sel2 = 2'b10;
                shift_op = 2'b10;
            end
            default: begin
                sel1 = 2'b00;
                sel2 = 2'b00;
            end
        endcase
    end

    // Example: store final result in register `kk`
    always @(*) begin
        kk = c; // this just mirrors c; add logic if needed
    end
endmodule

//test bench
`timescale 1ns / 1ps

module alu_tb;

    // Inputs
    reg clk;
    reg [15:0] a, b;
    reg [2:0] op;

    // Outputs
    wire [15:0] c;
    wire [2:0] cout, overflow, zero, negative;
    wire [1:0] sel1, sel2;
    wire op_add_sub;
    wire [1:0] select_bit, shift_op;
    wire [15:0] kk;

    // Instantiate datapath and controlpath
    datapath dp (
        .a(a),
        .b(b),
        .sel1(sel1),
        .sel2(sel2),
        .op_add_sub(op_add_sub),
        .select_bit(select_bit),
        .shift_op(shift_op),
        .c(c),
        .cout(cout),
        .overflow(overflow),
        .negative(negative),
        .zero(zero)
    );

    controlpath cp (
        .clk(clk),
        .op(op),
        .c(c),
        .cout(cout),
        .overflow(overflow),
        .negative(negative),
        .zero(zero),
        .sel1(sel1),
        .sel2(sel2),
        .op_add_sub(op_add_sub),
        .select_bit(select_bit),
        .shift_op(shift_op),
        .kk(kk)
    );

    // Clock generation
    always #5 clk = ~clk;

    // Stimulus
    initial begin
        $display("Time\tOP\tA\t\tB\t\tC\t\tZero Neg Oflow Cout");

        clk = 0;

        // Test Addition
        a = 16'd25;
        b = 16'd15;
        op = 3'd0; // ADD
        #10 print_status;

        // Test Subtraction
        a = 16'd25;
        b = 16'd15;
        op = 3'd1; // SUB
        #10 print_status;

        // Test AND
        a = 16'hFF00;
        b = 16'h0F0F;
        op = 3'd2;
        #10 print_status;

        // Test OR
        a = 16'hFF00;
        b = 16'h0F0F;
        op = 3'd3;
        #10 print_status;

        // Test XOR
        a = 16'hAAAA;
        b = 16'h5555;
        op = 3'd4;
        #10 print_status;

        // Test Shift Left
        a = 16'h0001;
        b = 16'd0; // unused
        op = 3'd5;
        #10 print_status;

        // Test Logical Shift Right
        a = 16'h8000;
        b = 16'd0; // unused
        op = 3'd6;
        #10 print_status;

        // Test Arithmetic Shift Right
        a = 16'hF000;
        b = 16'd0;
        op = 3'd7;
        #10 print_status;

        $finish;
    end

    task print_status;
        #1 $display("%0t\t%d\t%h\t%h\t%h\t%b   %b    %b     %b", 
            $time, op, a, b, c, zero[op_sel(op)], negative[op_sel(op)], overflow[op_sel(op)], cout[op_sel(op)]);
    endtask

    function [1:0] op_sel(input [2:0] opval);
        begin
            if (opval == 3'd0 || opval == 3'd1) // add/sub
                op_sel = 2'd0;
            else if (opval >= 3'd2 && opval <= 3'd4) // bitwise
                op_sel = 2'd1;
            else // shift
                op_sel = 2'd2;
        end
    endfunction

endmodule
