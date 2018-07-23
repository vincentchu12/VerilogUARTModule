`define ENABLE 1'b1
`define NONE       0
`define EVEN       1
`define ODD        2

module uart_fpga (
        input  wire        clk100MHz,
        input  wire        rst,
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

    wire [7:0] data;

    wire [7:0] LED[1:0];
    
    wire write_button;
    reg  write_reg; 
    wire write_pulse = write_button & ~write_reg;
    
    assign data = (write_pulse) ? tx_data : 8'bz;

    always @ (posedge clk100MHz, posedge rst) begin
        if (rst) write_reg <= 1'b0;
        else     write_reg <= write_button;
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
            .cs                     (`ENABLE),
            .we                     (write_pulse),
            .data                   (data),
            .tx                     (tx),
            .rx                     (rx),
            .oe                     (1'b1),
            .tx_full                (tx_full),
            .tx_empty               (tx_empty),
            .rx_full                (rx_full),
            .rx_empty               (rx_empty)
        );

    button_debouncer WRITE (
            .clk                    (clk_5KHz),
            .button                 (write),
            .debounced_button       (write_button)
        );

    hex_to_7seg HEX1 (
            .HEX                    (data[7:4]),
            .s                      (LED[1])
        );

    hex_to_7seg HEX0 (
            .HEX                    (data[3:0]),
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