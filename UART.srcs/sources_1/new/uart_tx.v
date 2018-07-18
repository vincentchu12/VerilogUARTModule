`define NONE       0
`define EVEN       1
`define ODD        2
`define START_SIZE 1
`define START_BIT  1'b0
`define STOP_BIT   1'b1

module uart_tx #(
        parameter BAUD_RATE = 9600,             // 9600 Baud Rate
        parameter CLOCK_HZ  = 100 * (10 ** 6),  // Assume 100MHz Clock,
        parameter DATA_SIZE = 8,                // Data Size 5-8 Bits
        parameter PARITY    = `NONE,            // Parity: None/Even/Odd
        parameter STOP_SIZE = 1                 // Stop Size: 1-2
    ) (
        input  wire                 clk,       // Input Clock
        input  wire                 start,     // Start Control Signal
        input  wire [DATA_SIZE-1:0] data,      // 5-8 bit Data (Parallel)
        output wire                 tx,        // Transmit Bit (Serial)
        output wire                 ready      // Ready Flag
    );

    parameter IDLE     = 2'd0,
              TX_CNT   = 2'd1,
              TRANSMIT = 2'd2;

    parameter MAX_COUNT   = CLOCK_HZ / BAUD_RATE; // Clock Divider
    parameter COUNT_WIDTH = $clog2(MAX_COUNT);    // Width

    parameter PARITY_SIZE = (PARITY == `NONE) ? 1'b0 : 1'b1;
    parameter TX_SIZE     = `START_SIZE + DATA_SIZE + PARITY_SIZE + STOP_SIZE;
    parameter TX_WIDTH    = $clog2(TX_SIZE);

    reg [1:0] NS = IDLE;
    reg [1:0] CS = IDLE;

    reg [COUNT_WIDTH-1:0] count     = {COUNT_WIDTH{1'b0}};  // Internal Clock Frequency
    reg [TX_WIDTH-1:0]    tx_count  = {TX_WIDTH{1'b0}};     // Number of Bits Sent
    reg [TX_SIZE-1:0]     tx_bus    = {TX_SIZE{1'b0}};      // 1 Start Bit, 5-8 Stop Bits, None/Even/Odd Parity Bit, 1-2 Stop Bits

    wire PARITY_BIT = (PARITY == `EVEN) ? (^data) : ~(^data);
    
    always @(posedge clk) begin
        CS <= NS;
    end

    always @ (CS, start, count, tx_count) begin
        case (CS)
            IDLE:     NS = (start == 1'b1) ? TX_CNT : IDLE;
            TX_CNT:   NS = (count == MAX_COUNT-1) ? TRANSMIT : TX_CNT;
            TRANSMIT: NS = (tx_count == TX_SIZE-1) ? IDLE : TX_CNT;
        endcase
    end

    always @ (posedge clk) begin
        case (CS)
            IDLE: begin
                tx_bus    <= (PARITY == `NONE) ? {{STOP_SIZE{`STOP_BIT}}, data, `START_BIT} 
                                               : {{STOP_SIZE{`STOP_BIT}}, PARITY_BIT, data, `START_BIT};
                count     <= {COUNT_WIDTH{1'b0}};
                tx_count  <= {TX_WIDTH{1'b0}};
            end
            TX_CNT: begin
                count <= count + 1;
            end
            TRANSMIT: begin
                tx_bus   <= tx_bus >> 1;
                tx_count <= tx_count + 1;
                count    <= {COUNT_WIDTH{1'b0}};
            end
        endcase
    end

    assign tx    = (CS != IDLE) ? tx_bus[0] : 1'b1;
    assign ready = (CS == IDLE) ? 1'b1 : 1'b0;

endmodule