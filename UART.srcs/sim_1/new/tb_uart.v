module tb_uart;

    reg        clk = 1'b0;
    reg        rst = 1'b0;

    reg        tx_wr_cs = 1'b0;
    reg        tx_wr_en = 1'b0;
    reg  [7:0] tx_data  = 8'b0;
    wire       tx;
    wire       tx_full;
    wire       tx_empty;


    reg        rx = 1'b0;
    reg        rx_rd_cs = 1'b0;
    reg        rx_rd_en = 1'b0;
    wire [7:0] rx_data;
    wire       rx_full;
    wire       rx_empty;

    integer I = 0;
    
    uart DUT (
            .clk            (clk),
            .rst            (rst),
            .tx_wr_cs       (tx_wr_cs),
            .tx_wr_en       (tx_wr_en),
            .tx_data        (tx_data),
            .tx             (tx),
            .tx_full        (tx_full),
            .tx_empty       (tx_empty),
            .rx             (tx),
            .rx_rd_cs       (rx_rd_cs),
            .rx_rd_en       (rx_rd_en),
            .rx_data        (rx_data),
            .rx_full        (rx_full),
            .rx_empty       (rx_empty)
        );


    // Free Running Clock
    initial begin
        forever begin
            #5 clk = !clk;
        end
    end

    initial begin
        #1 rst = 1'b1; 
        #1 rst = 1'b0;
        
        #8;
        for(I = 0; I < 2 ** 8; I = I + 2**5) begin
            tx_wr_cs = 1'b1;
            tx_wr_en = 1'b1;
            tx_data = I;
            #10;
        end
        tx_wr_cs = 1'b0;
        tx_wr_en = 1'b0;
        
        while(!tx_full) #5;
        while(!tx_empty) #5;
        $finish;
    end
    
endmodule