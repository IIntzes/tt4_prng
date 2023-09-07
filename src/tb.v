module top_tb;

    // Inputs
    reg EN = 0;
    reg CLK = 0;

    // Outputs
    wire [6:0] HEX0;
    wire [6:0] HEX1;


    // Instantiate the top module
    top dut (
        .EN(EN),
        .CLK(CLK),
        .HEX0(HEX0),
        .HEX1(HEX1)
    );

    // Clock generation
    always begin
        #5 CLK = ~CLK;  // Assuming a 10ns clock period
    end

    // Simulation control
    initial begin
        $display("Starting simulation...");
        EN = 1;  // Enable the design
        CLK = 0; // Initialize CLK

        // Run the simulation for a while
        #100; // Adjust this delay as needed

        // Disable the design
        EN = 0;
        
        $display("Simulation complete.");
        $finish;
    end

    // Display output values during simulation
    always @(posedge CLK) begin
        $display("HEX0 = %h", HEX0);
        $display("HEX1 = %h", HEX1);
        $display("clk1hz = %b", clk1hz);
    end

endmodule

// Run the simulation
initial begin
    $dumpfile("sim_dump.vcd");
    $dumpvars(0, top_tb);
    $display("Starting simulation...");
    top_tb tb();
    #1000; // Simulate for some time
    $display("Simulation complete.");
    $finish;
end

`default_nettype none
`timescale 1ns/1ps

/*
this testbench just instantiates the module and makes some convenient wires
that can be driven / tested by the cocotb test.py
*/

// testbench is controlled by test.py
module tb ();

    // this part dumps the trace to a vcd file that can be viewed with GTKWave
    initial begin
        $dumpfile ("tb.vcd");
        $dumpvars (0, tb);
        #1;
    end

    // wire up the inputs and outputs
    reg  CLK = clk;
    reg  reset = rst_n;
    reg  EN = ena;
    reg  [7:0] ui_in;
    reg  [7:0] uio_in;

    wire [7:0] {HEX0, 1'b0} = uo_out;
    wire [7:0] {HEX1, 1'b0} = uio_out;
    wire [7:0] uio_oe;

    tt_um_top (
    // include power ports for the Gate Level test
    `ifdef GL_TEST
        .VPWR( 1'b1),
        .VGND( 1'b0),
    `endif
        .ui_in      (ui_in),    // Dedicated inputs
        .uo_out     (uo_out),   // Dedicated outputs
        .uio_in     (uio_in),   // IOs: Input path
        .uio_out    (uio_out),  // IOs: Output path
        .uio_oe     (uio_oe),   // IOs: Enable path (active high: 0=input, 1=output)
        .ena        (ena),      // enable - goes high when design is selected
        .clk        (clk),      // clock
        .rst_n      (rst_n)     // not reset
        );

endmodule
