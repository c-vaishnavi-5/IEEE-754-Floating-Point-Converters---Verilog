module fp_to_decimal(
    input clk,
    input rst_n,
    input [31:0] fp_in,
    output reg signed [31:0] decimal_out
);
    // Input register
    reg [31:0] fp_in_reg;
    
    // Unpacked fields
    wire sign;
    wire [7:0] exponent;
    wire [22:0] mantissa;
    wire [23:0] full_mantissa;
    
    // Intermediate signals
    wire signed [8:0] actual_exponent;
    reg [31:0] abs_result;
    wire signed [31:0] signed_result;
    
    // Unpack IEEE 754 format
    assign sign = fp_in_reg[31];
    assign exponent = fp_in_reg[30:23];
    assign mantissa = fp_in_reg[22:0];
    assign full_mantissa = {1'b1, mantissa};
    assign actual_exponent = {1'b0, exponent} - 9'd127;
    
    // Conversion logic to Q16.16 fixed-point
    always @(*) begin
        if (exponent == 8'h00) begin
            // Zero or denormalized number
            abs_result = 32'h00000000;
        end else if (exponent >= 8'hFF) begin
            // Infinity or NaN
            abs_result = 32'h7FFFFFFF;
        end else begin
            if (actual_exponent > 9'sd14) begin
                // Overflow
                abs_result = 32'h7FFFFFFF;
            end else if (actual_exponent < -9'sd16) begin
                // Underflow
                abs_result = 32'h00000000;
            end else begin              
                if (actual_exponent >= 9'sd7) begin
                    // Shift left
                    abs_result = full_mantissa << (actual_exponent - 9'sd7);
                end else begin
                    // Shift right
                    abs_result = full_mantissa >> (9'sd7 - actual_exponent);
                end
            end
        end
    end
    
    // Apply sign
    assign signed_result = sign ? (~abs_result + 32'b1) : abs_result;
    
    // Sequential logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            fp_in_reg <= 32'b0;
            decimal_out <= 32'b0;
        end else begin
            fp_in_reg <= fp_in;
            decimal_out <= signed_result;
        end
    end
endmodule