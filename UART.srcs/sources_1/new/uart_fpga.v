`define ENABLE 1'b1
`define NONE       0
`define EVEN       1
`define ODD        2

module uart_fpga (
        input  wire        clk100MHz,
        input  wire        rst,
        input  wire        read,
        input  wire        write,
        input  wire [7:0]  tx_data,
        input  wire        rx,
        output wire        tx,
        output wire [7:0]  rx_data,
        output wire        tx_full,
        output wire        tx_empty,
        output wire        rx_full,
        output wire        rx_empty,
        output wire [7:0]  LEDSEL,
        output wire [7:0]  LEDOUT
    );
    
    supply1 [7:0] vcc;

    wire clk_4sec;
    wire clk_5KHz;

    wire tx_wr_en;
    wire rx_rd_en;

    wire [7:0] LED[1:0];
    
    reg write_reg;
    reg read_reg;
    
    wire write_pulse = tx_wr_en & ~write_reg;
    wire read_pulse  = rx_rd_en & ~read_reg;
    
    always @ (posedge clk100MHz, posedge rst) begin
        if (rst) write_reg <= 1'b0;
        else     write_reg <= tx_wr_en;
        
        if (rst) read_reg <= 1'b0;
        else     read_reg <= rx_rd_en;
    end

    clk_gen CLK_GEN (
            .clk100MHz              (clk100MHz),
            .rst                    (rst),
            .clk_4sec               (clk_4sec),
            .clk_5KHz               (clk_5KHz)
        );

    uart #(
            .BAUD_RATE              (115200),            // 115200 Baud Rate
            .CLOCK_HZ               (100 * (10 ** 6)),   // 100MHz Clock,
            .DATA_SIZE              (8),
            .PARITY                 (`NONE),
            .STOP_SIZE              (1),
            .TX_DEPTH               (8),
            .RX_DEPTH               (8)
        ) UART (
            .clk                    (clk100MHz),
            .rst                    (rst),
            .tx_wr_cs               (`ENABLE),
            .tx_wr_en               (write_pulse),
            .tx_data                (tx_data),
            .tx                     (tx),
            .tx_full                (tx_full),
            .tx_empty               (tx_empty),
            .rx                     (rx),
            .rx_rd_cs               (`ENABLE),
            .rx_rd_en               (read_pulse),
            .rx_data                (rx_data),
            .rx_full                (rx_full),
            .rx_empty               (rx_empty)
        );

    button_debouncer WRITE (
            .clk                    (clk_5KHz),
            .button                 (write),
            .debounced_button       (tx_wr_en)
        );

    button_debouncer READ (
            .clk                    (clk_5KHz),
            .button                 (read),
            .debounced_button       (rx_rd_en)
        );

    hex_to_7seg HEX1 (
            .HEX                    (rx_data[7:4]),
            .s                      (LED[1])
        );

    hex_to_7seg HEX0 (
            .HEX                    (rx_data[3:0]),
            .s                      (LED[0])
        );

    led_mux LED_MUX (
        .clk                        (clk_5KHz),
        .rst                        (rst),
        .LED7                       (vcc),
        .LED6                       (vcc),
        .LED5                       (vcc),
        .LED4                       (vcc),
        .LED3                       (vcc),
        .LED2                       (vcc),
        .LED1                       (LED[1]),
        .LED0                       (LED[0]),
        .LEDSEL                     (LEDSEL),
        .LEDOUT                     (LEDOUT)
    );

endmodule