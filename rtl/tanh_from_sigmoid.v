module tanh_from_sigmoid #(
    parameter integer WIDTH      = 16,
    parameter integer FRAC_BITS  = 12
) (
    input  wire signed [WIDTH-1:0] in_data,
    output wire signed [WIDTH-1:0] out_data
);
    localparam signed [WIDTH-1:0] ONE_Q         = 16'sd4096;   // 1.0 in Q4.12
    localparam signed [WIDTH-1:0] TANH_POS_LIM  = 16'sd12288;  // 3.0
    localparam signed [WIDTH-1:0] TANH_NEG_LIM  = -16'sd12288; // -3.0
    localparam signed [WIDTH-1:0] SIG_POS_LIM   = 16'sd24576;  // 6.0
    localparam signed [WIDTH-1:0] SIG_NEG_LIM   = -16'sd24576; // -6.0

    wire signed [WIDTH-1:0] sigmoid_in;
    wire signed [WIDTH-1:0] sigmoid_out;
    wire signed [WIDTH-1:0] scaled_sigmoid;

    // tanh(x) = 2*sigmoid(2x) - 1
    // The tanh wrapper itself uses only shifts and an offset subtraction.
    assign sigmoid_in = (in_data >= TANH_POS_LIM) ? SIG_POS_LIM :
                        (in_data <= TANH_NEG_LIM) ? SIG_NEG_LIM :
                        (in_data <<< 1);

    sigmoid_pwl #(
        .WIDTH(WIDTH),
        .FRAC_BITS(FRAC_BITS)
    ) sigmoid_core (
        .in_data(sigmoid_in),
        .out_data(sigmoid_out)
    );

    assign scaled_sigmoid = sigmoid_out <<< 1;
    assign out_data       = scaled_sigmoid - ONE_Q;

endmodule
