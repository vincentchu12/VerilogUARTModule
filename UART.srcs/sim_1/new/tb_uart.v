module tb_uart;

    reg        clk = 1'b0;
    reg        rst = 1'b0;

    reg        cs = 1'b0;
    reg        we = 1'b0;
    reg        oe = 1'b0;

    wire [7:0] data;
    wire       tx;
    wire       tx_full;
    wire       tx_empty;
    wire       rx_full;
    wire       rx_empty;

    integer I = 0;
    
    uart DUT (
            .clk            (clk),
            .rst            (rst),
            .cs             (cs),
            .we             (we),
            .oe             (oe),
            .data           (data),
            .rx             (tx),
            .tx             (tx),
            .tx_full        (tx_full),
            .tx_empty       (tx_empty),
            .rx_full        (rx_full),
            .rx_empty       (rx_empty)
        );

    // Free Running Clock
    initial begin
        forever begin
            #5 clk = !clk;
        end
    end

    assign data = (cs && oe && !we) ? 8'bz : I * I;

    initial begin
        #1 rst = 1'b1; 
        #1 rst = 1'b0;
        
        #8;
        for(I = 1; I < 8; I = I + 1) begin
            cs = 1'b1;
            we = 1'b1;
            #10;
        end
        cs = 1'b0;
        we = 1'b0;
        
        while(!tx_empty) #5;
        #1000;
        cs = 1'b1;
        we = 1'b0;
        oe = 1'b1;
        while(!rx_empty) #5;
        #100;
        $finish;
    end
    
endmodule