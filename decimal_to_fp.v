module decimal_to_fp(
    input clk,
    input rst_n,
    input signed [31:0] decimal_in,
    output reg [31:0] fp_out
);
    // Input register
    reg signed [31:0] decimal_in_reg;
    
    // Intermediate signals
    wire sign;
    wire [31:0] abs_value;
    reg [7:0] exponent;
    reg [22:0] mantissa;
    reg [5:0] msb_position;
    wire [31:0] normalized_mantissa;
    wire [31:0] fp_result;
    
    integer i;
    
    // Extract sign and absolute value
    assign sign = decimal_in_reg[31];
    assign abs_value = sign ? (~decimal_in_reg + 32'b1) : decimal_in_reg;
    
    // Find MSB position (leading one detector)
    always @(*) begin
        msb_position = 6'd0;
        if (abs_value != 32'd0) begin
            for (i = 31; i >= 0; i = i - 1) begin
                if (abs_value[i] && (msb_position == 6'd0)) begin
                    msb_position = i[5:0];
                end
            end
        end
    end
    
    // Normalize mantissa - shift to get 24-bit mantissa with leading 1
    assign normalized_mantissa = (msb_position >= 6'd23) ?
                                 (abs_value >> (msb_position - 6'd23)) :
                                 (abs_value << (6'd23 - msb_position));
    
    // Calculate exponent and mantissa
    always @(*) begin
        if (abs_value == 32'd0) begin
            exponent = 8'h00;
            mantissa = 23'h000000;
        end else begin

            if (msb_position >= 6'd16) begin
                // Positive exponent
                if ((msb_position - 6'd16) > 6'd127) begin
                    // Overflow
                    exponent = 8'hFF;
                    mantissa = 23'h000000;
                end else begin
                    exponent = 8'd127 + (msb_position - 6'd16);
                    mantissa = normalized_mantissa[22:0];
                end
            end else begin
                // Negative exponent
                if ((6'd16 - msb_position) > 6'd126) begin
                    // Underflow
                    exponent = 8'h00;
                    mantissa = 23'h000000;
                end else begin
                    exponent = 8'd127 - (6'd16 - msb_position);
                    mantissa = normalized_mantissa[22:0];
                end
            end
        end
    end
    
    // Combine to form IEEE 754 float
    assign fp_result = {sign, exponent, mantissa};
    
    // Sequential logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            decimal_in_reg <= 32'd0;
            fp_out <= 32'h00000000;
        end else begin
            decimal_in_reg <= decimal_in;
            fp_out <= fp_result;
        end
    end
endmodule