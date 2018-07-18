`define NONE       0
`define EVEN       1
`define ODD        2

module uart #(
        parameter BAUD_RATE = 9600,             // 9600 Baud Rate
        parameter CLOCK_HZ  = 100 * (10 ** 6),  // Assume 100MHz Clock,
        parameter DATA_SIZE = 8,
        parameter PARITY    = `NONE,
        parameter STOP_SIZE = 1,
        parameter TX_DEPTH  = 8,
        parameter RX_DEPTH  = 8
    ) (
        input  wire                 clk,       // Input Clock
        input  wire                 rst,

        input  wire                 tx_wr_cs,
        input  wire                 tx_wr_en,
        input  wire [DATA_SIZE-1:0] tx_data,   // 5-8 bit Data (Parallel)
        output wire                 tx,        // Transmit Bit (Serial)        
        output wire                 tx_full,
        output wire                 tx_empty,

        input  wire                 rx,        // Receive Bit (Serial)
        input  wire                 rx_rd_cs,
        input  wire                 rx_rd_en,
        output wire [DATA_SIZE-1:0] rx_data,   // 5-8 bit Data (Parallel)
        output wire                 rx_full,
        output wire                 rx_empty
    );

    wire [DATA_SIZE-1:0] tx_out;
    wire [DATA_SIZE-1:0] rx_in;
    wire                 tx_ready;  // Ready Flag

    wire                 rx_done;   // Done Flag
    wire                 rx_error;   // Error Flag

    FIFO # (
            .LENGTH(TX_DEPTH),
            .WIDTH(DATA_SIZE)
        ) TX_FIFO (
            .clk        (~clk),
            .rst        (rst),
            .wr_cs      (tx_wr_cs),
            .wr_en      (tx_wr_en),
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
            .LENGTH(RX_DEPTH),
            .WIDTH(DATA_SIZE)
        ) RX_FIFO (
            .clk        (~clk),
            .rst        (rst),
            .wr_cs      (rx_done),
            .wr_en      (rx_done),
            .rd_cs      (rx_rd_cs),
            .rd_en      (rx_rd_en),
            .in         (rx_in),
            .full       (rx_full),
            .empty      (rx_empty),
            .out        (rx_data)
        );

endmodule
