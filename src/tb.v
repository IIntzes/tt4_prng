`default_nettype none
`timescale 1ns/1ps

module tb;
    reg [7:0] ui_in;
    wire [7:0] uo_out;
    reg [7:0] uio_in;
    wire [7:0] uio_out;
    reg [7:0] uio_oe;
    reg ena;
    reg clk;
    reg rst_n;


    // Instantiate the design under test (DUT)
    tt_um_top #(10_000_000) dut (
        .ui_in(ui_in),
        .uo_out(uo_out),
        .uio_in(uio_in),
        .uio_out(uio_out),
        .uio_oe(uio_oe),
        .ena(ena),
        .clk(clk),
        .rst_n(rst_n)
    );

    // Clock generation
    always begin
        #5 clk = ~clk; // Toggle the clock every 5 time units
    end

    // Test vector generation
    initial begin
        $dumpfile ("tb.vcd");
        $dumpvars (0, tb);
        #1;
        // Initialize inputs
        ui_in = 8'b0;
        uio_in = 8'b0;
        ena = 0;
        clk = 0;
        rst_n = 0;

        // Apply reset
        rst_n = 1;
        #10 rst_n = 0;
        #10 rst_n = 1;

        // Enable the design
        ena = 1;

        // Apply test vectors and observe outputs
        // You can write your test cases here

        // Simulate for some time
        #1000;

        // Finish simulation
        $finish;
    end
endmodule

// Instantiate the testbench module
tb_tt_um_top tb;
