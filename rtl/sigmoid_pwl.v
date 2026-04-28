module sigmoid_pwl #(
    parameter integer WIDTH      = 16,
    parameter integer FRAC_BITS  = 12
) (
    input  wire signed [WIDTH-1:0] in_data,
    output reg  signed [WIDTH-1:0] out_data
);
    localparam signed [WIDTH-1:0] X_POS_1 = 16'sd4096;   //  1.0 in Q4.12
    localparam signed [WIDTH-1:0] X_POS_2 = 16'sd8192;   //  2.0
    localparam signed [WIDTH-1:0] X_POS_3 = 16'sd12288;  //  3.0
    localparam signed [WIDTH-1:0] X_POS_4 = 16'sd18432;  //  4.5
    localparam signed [WIDTH-1:0] X_POS_5 = 16'sd24576;  //  6.0
    localparam signed [WIDTH-1:0] ONE_Q    = 16'sd4096;  //  1.0

    localparam signed [WIDTH-1:0] M_0 = 16'sd953;
    localparam signed [WIDTH-1:0] C_0 = 16'sd2064;
    localparam signed [WIDTH-1:0] M_1 = 16'sd612;
    localparam signed [WIDTH-1:0] C_1 = 16'sd2414;
    localparam signed [WIDTH-1:0] M_2 = 16'sd291;
    localparam signed [WIDTH-1:0] C_2 = 16'sd3047;
    localparam signed [WIDTH-1:0] M_3 = 16'sd96;
    localparam signed [WIDTH-1:0] C_3 = 16'sd3632;
    localparam signed [WIDTH-1:0] M_4 = 16'sd22;
    localparam signed [WIDTH-1:0] C_4 = 16'sd3955;

    reg                      input_negative;
    reg signed [WIDTH-1:0]   abs_input;
    reg signed [2*WIDTH-1:0] mult_result;
    reg signed [WIDTH-1:0]   pos_sigmoid;

    always @(*) begin
        input_negative = in_data[WIDTH-1];
        abs_input      = input_negative ? -in_data : in_data;
        mult_result    = {2*WIDTH{1'b0}};
        pos_sigmoid    = {WIDTH{1'b0}};

        if (abs_input >= X_POS_5) begin
            pos_sigmoid = ONE_Q;
        end else if (abs_input >= X_POS_4) begin
            mult_result = M_4 * abs_input;
            pos_sigmoid = (mult_result >>> FRAC_BITS) + C_4;
        end else if (abs_input >= X_POS_3) begin
            mult_result = M_3 * abs_input;
            pos_sigmoid = (mult_result >>> FRAC_BITS) + C_3;
        end else if (abs_input >= X_POS_2) begin
            mult_result = M_2 * abs_input;
            pos_sigmoid = (mult_result >>> FRAC_BITS) + C_2;
        end else if (abs_input >= X_POS_1) begin
            mult_result = M_1 * abs_input;
            pos_sigmoid = (mult_result >>> FRAC_BITS) + C_1;
        end else begin
            mult_result = M_0 * abs_input;
            pos_sigmoid = (mult_result >>> FRAC_BITS) + C_0;
        end

        if (pos_sigmoid < 0) begin
            pos_sigmoid = 0;
        end else if (pos_sigmoid > ONE_Q) begin
            pos_sigmoid = ONE_Q;
        end

        if (input_negative) begin
            out_data = ONE_Q - pos_sigmoid;
        end else begin
            out_data = pos_sigmoid;
        end
    end

endmodule
