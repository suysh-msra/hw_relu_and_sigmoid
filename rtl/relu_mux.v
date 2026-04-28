module relu_mux #(
    parameter integer WIDTH = 16
) (
    input  wire signed [WIDTH-1:0] in_data,
    output wire signed [WIDTH-1:0] out_data
);
    wire sign_bit;

    assign sign_bit = in_data[WIDTH-1];

    // 2x1 mux: select zero for negative inputs, otherwise pass input through.
    assign out_data = sign_bit ? {WIDTH{1'b0}} : in_data;

endmodule
