`timescale 1ns/1ps

module tb_relu_mux;
    localparam integer WIDTH = 16;

    reg  signed [WIDTH-1:0] in_data;
    wire signed [WIDTH-1:0] out_data;

    relu_mux #(
        .WIDTH(WIDTH)
    ) dut (
        .in_data(in_data),
        .out_data(out_data)
    );

    initial begin
        $display("Starting ReLU mux testbench");

        in_data = -16'sd2048; #1;
        if (out_data !== 0) begin
            $fatal(1, "ReLU failed for negative input");
        end

        in_data = 16'sd0; #1;
        if (out_data !== 0) begin
            $fatal(1, "ReLU failed for zero input");
        end

        in_data = 16'sd1536; #1;
        if (out_data !== 16'sd1536) begin
            $fatal(1, "ReLU failed for positive input");
        end

        $display("ReLU mux testbench passed");
        $finish;
    end

endmodule
