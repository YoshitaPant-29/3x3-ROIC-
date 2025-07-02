`timescale 1ns / 1ps

module tb_pixel_scanner_v11;

    reg clk;
    reg master_rst;
    wire fsync;
    wire intg;
    wire [2:0] row;
    wire [2:0] col;

    // Instantiate DUT
    pixel_scanner_v11 uut (
        .clk(clk),
        .master_rst(master_rst),
        .fsync(fsync),
        .intg(intg),
        .row(row),
        .col(col)
    );

    // Generate 10 MHz Clock (100 ns)
    always #50 clk = ~clk;

    initial begin
        $dumpfile("pixel_scanner_v11.vcd");
        $dumpvars(0, tb_pixel_scanner_v11);

        clk = 0;
        master_rst = 1;

        #200;
        master_rst = 0;

        #20000;
        $finish;
    end

endmodule
