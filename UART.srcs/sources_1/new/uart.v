`define NONE       0
`define EVEN       1
`define ODD        2

module uart #(
        parameter BAUD_RATE = 9600,             // 9600 Baud Rate
        parameter CLOCK_HZ  = 100 * (10 ** 6),  // Assume 100MHz Clock,
        parameter DATA_SIZE = 8,                // 5-8 Data Size
        parameter PARITY    = `NONE,            // No Parity, Even Parity, Odd Parity
        parameter STOP_SIZE = 1,                // Stop Size 1-2 Bits
        parameter TX_DEPTH  = 8,                // Tx Fifo Depth
        parameter RX_DEPTH  = 8                 // Rx Fifo Depth
    ) (
        input  wire                 clk,        // Input Clock
        input  wire                 rst,        // Reset
        input  wire                 cs,         // Chip Select
        input  wire                 we,         // Write Enable
        input  wire                 oe,         // Output Enable
        inout  wire [DATA_SIZE-1:0] data,       // 5-8 bit Data (Parallel)
        input  wire                 rx,         // Receive Bit (Serial)
        output wire                 tx,         // Transmit Bit (Serial)        
        output wire                 tx_full,    // Tx Fifo Full Flag
        output wire                 tx_empty,   // Tx Fifo Empty Flag
        output wire                 rx_full,    // Rx Fifo Full Flag
        output wire                 rx_empty    // Rx Fifo Empty Flag
    );


    wire [DATA_SIZE-1:0] tx_data;
    wire [DATA_SIZE-1:0] rx_data;

    wire [DATA_SIZE-1:0] tx_out;
    wire [DATA_SIZE-1:0] rx_in;
    wire                 tx_ready;  // Ready Flag

    wire                 rx_done;   // Done Flag
    wire                 rx_error;  // Error Flag

    assign data = (cs && oe && !we) ? rx_data : {(DATA_SIZE){1'bz}};
    assign tx_data = data;

    FIFO # (
            .LENGTH     (TX_DEPTH),
            .WIDTH      (DATA_SIZE)
        ) TX_FIFO (
            .clk        (~clk),
            .rst        (rst),
            .wr_cs      (cs),
            .wr_en      (we),
            .rd_cs      (tx_ready),
            .rd_en      (tx_ready),
            .in         (tx_data),
            .full       (tx_full),
            .empty      (tx_empty),
            .out        (tx_out)
        );

    uart_tx #(
            .BAUD_RATE  (BAUD_RATE),
            .CLOCK_HZ   (CLOCK_HZ),
            .DATA_SIZE  (DATA_SIZE),
            .PARITY     (PARITY),
            .STOP_SIZE  (STOP_SIZE)
        ) TX (
            .clk        (clk),
            .start      (~tx_empty),
            .data       (tx_out),
            .tx         (tx),
            .ready      (tx_ready)
        );

    uart_rx #(
            .BAUD_RATE  (BAUD_RATE),
            .CLOCK_HZ   (CLOCK_HZ),
            .DATA_SIZE  (DATA_SIZE),
            .PARITY     (PARITY),
            .STOP_SIZE  (STOP_SIZE)
        ) RX (
            .clk        (clk),
            .rx         (rx),
            .data       (rx_in),
            .done       (rx_done),
            .error      (rx_error)
        );

    FIFO # (
            .LENGTH     (RX_DEPTH),
            .WIDTH      (DATA_SIZE)
        ) RX_FIFO (
            .clk        (~clk),
            .rst        (rst),
            .wr_cs      (rx_done),
            .wr_en      (rx_done),
            .rd_cs      (cs),
            .rd_en      (!we),
            .in         (rx_in),
            .full       (rx_full),
            .empty      (rx_empty),
            .out        (rx_data)
        );

endmodule
