module tb_uart_tx;

    reg        clk   = 1'b0;
    reg        start = 1'b0;
    reg  [7:0] data  = 8'b0;
    wire       tx;
    wire       ready;
    wire [7:0] rx_data;
    wire       done;
    wire       error;

    reg  [7:0] tb_rx_data;
    
    integer I;
    
    uart_tx #(
            .PARITY     (1)
        ) DUT (
            .clk        (clk),
            .start      (start),
            .data       (data),
            .tx         (tx),
            .ready      (ready)
        );

    uart_rx # (
            .PARITY     (1)
        ) DUT1 (
            .clk        (clk),
            .data       (rx_data),
            .rx         (tx),
            .done       (done),
            .error      (error)
        );

    // Free Running Clock
    initial begin
        clk = 1'b0;
        forever begin
            #5 clk = !clk;
        end
    end

    initial begin
        #10;
        for(I = 0; I < 2 ** 8; I = I + 1) begin
            data = I;            
            start = 1'b1; #10 start = 1'b0;
            if(done) tb_rx_data = rx_data;
            while(ready == 1'b0) #5;
            if(tb_rx_data != data) begin
                $display("Error! Data does not match");
            end
            else begin
                $display("%d", data);
            end
        end
        $finish;
    end
    
endmodule