`timescale 1ns/1ps

module tb_sigmoid_pwl;
    localparam integer WIDTH = 16;
    localparam integer ONE_Q = 4096;

    reg  signed [WIDTH-1:0] in_data;
    wire signed [WIDTH-1:0] out_data;

    sigmoid_pwl dut (
        .in_data(in_data),
        .out_data(out_data)
    );

    task automatic check_value;
        input signed [WIDTH-1:0] stimulus;
        input signed [WIDTH-1:0] expected;
        input signed [WIDTH-1:0] tolerance;
        begin
            in_data = stimulus;
            #1;
            if ((out_data > (expected + tolerance)) || (out_data < (expected - tolerance))) begin
                $fatal(
                    1,
                    "Sigmoid mismatch: input=%0d output=%0d expected=%0d tolerance=%0d",
                    stimulus,
                    out_data,
                    expected,
                    tolerance
                );
            end
        end
    endtask

    initial begin
        $display("Starting sigmoid PWL testbench");

        check_value(-16'sd24576, 16'sd0,   16'sd8);
        check_value(-16'sd12288, 16'sd176, 16'sd32);
        check_value(-16'sd4096,  16'sd1101, 16'sd40);
        check_value(16'sd0,      16'sd2064, 16'sd8);
        check_value(16'sd4096,   16'sd2990, 16'sd40);
        check_value(16'sd12288,  16'sd3920, 16'sd32);
        check_value(16'sd24576,  ONE_Q,      16'sd8);

        $display("Sigmoid PWL testbench passed");
        $finish;
    end

endmodule
