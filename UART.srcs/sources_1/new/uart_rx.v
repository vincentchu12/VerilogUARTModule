`define NONE       0
`define EVEN       1
`define ODD        2
`define START_SIZE 1
`define START_BIT  1'b0
`define STOP_BIT   1'b1

module uart_rx #(
        parameter BAUD_RATE = 9600,             // 9600 Baud Rate
        parameter CLOCK_HZ  = 100 * (10 ** 6),  // Assume 100MHz Clock,
        parameter DATA_SIZE = 8,                // Data Size 5-8 Bits
        parameter PARITY    = `NONE,            // Parity: NONE/EVEN/ODD
        parameter STOP_SIZE = 1                 // Stop Bit: 1-2
    ) (
        input  wire                 clk,        // Input Clock
        input  wire                 rx,         // Receive Bit (Serial)
        output wire [DATA_SIZE-1:0] data,       // 5-8 bit Data (Parallel)
        output reg                  done,       // Done Flag
        output reg                  error       // Error Flag
    );

    parameter IDLE     = 3'd0,
              START    = 3'd1,
              RX_CNT   = 3'd2,
              RECEIVE  = 3'd3,
              DONE     = 3'd4;

    parameter MAX_COUNT   = CLOCK_HZ / BAUD_RATE; // Clock Divider
    parameter COUNT_WIDTH = $clog2(MAX_COUNT);    // Width

    parameter PARITY_SIZE = (PARITY == `NONE) ? 1'b0 : 1'b1;
    parameter RX_SIZE     = `START_SIZE + DATA_SIZE + PARITY_SIZE + STOP_SIZE;
    parameter RX_WIDTH    = $clog2(RX_SIZE);

    reg [2:0] NS = IDLE;
    reg [2:0] CS = IDLE;

    reg [COUNT_WIDTH-1:0] count     = {COUNT_WIDTH{1'b0}};  // Internal Clock Frequency
    reg [RX_WIDTH-1:0]    rx_count  = {RX_WIDTH{1'b0}};     // Number of Bits Sent
    reg [RX_SIZE-1:0]     rx_bus    = {RX_SIZE{1'b0}};      // 1 Start Bit, 5-8 Stop Bits, None/Even/Odd Parity Bit, 1-2 Stop Bits

    wire PARITY_BIT = (PARITY == `EVEN) ? (^data) : ~(^data);   // Parity of Data
    wire rx_parity  = rx_bus[RX_SIZE-STOP_SIZE-1];              // Received Parity Bit
    
    always @(posedge clk) begin
        CS <= NS;
    end

    always @ (CS, rx, count, rx_count) begin
        case (CS)
            IDLE:    NS = (rx == 1'b0) ? START : IDLE;
            START:   NS = (count == (MAX_COUNT/2)-1) ? (rx == 1'b0) ? RECEIVE : IDLE : START;
            RX_CNT:  NS = (count == MAX_COUNT-1) ? RECEIVE : RX_CNT;
            RECEIVE: NS = (rx_count == RX_SIZE-1) ? DONE : RX_CNT;
            DONE:    NS = IDLE;
        endcase
    end

    always @ (posedge clk) begin
        case (CS)
            IDLE: begin
                rx_bus    <= {RX_SIZE{1'b0}};
                count     <= {COUNT_WIDTH{1'b0}};
                rx_count  <= {RX_WIDTH{1'b0}};
                done      <= 1'b0;
                error     <= 1'b0;
            end
            START: begin
                count <= count + 1;
            end
            RX_CNT: begin
                count <= count + 1;
            end
            RECEIVE: begin
                rx_bus    <= {rx, rx_bus[RX_SIZE-1:1]};
                rx_count  <= rx_count + 1;
                count     <= {COUNT_WIDTH{1'b0}};
            end
            DONE: begin
                if (PARITY == `NONE) done <= 1'b1;
                else begin
                    error <= (PARITY_BIT != rx_parity) ? 1'b1 : 1'b0;
                    done  <= (PARITY_BIT == rx_parity) ? 1'b1 : 1'b0;
                end                
            end
        endcase
    end

    assign data  = rx_bus[DATA_SIZE:1];

endmodule