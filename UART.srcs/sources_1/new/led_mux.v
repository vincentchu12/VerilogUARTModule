module led_mux (
        input  wire       clk,
        input  wire       rst,
        input  wire [7:0] LED7,
        input  wire [7:0] LED6,
        input  wire [7:0] LED5,
        input  wire [7:0] LED4,
        input  wire [7:0] LED3,
        input  wire [7:0] LED2,
        input  wire [7:0] LED1,
        input  wire [7:0] LED0,
        output wire [7:0] LEDSEL,
        output wire [7:0] LEDOUT
    );

    reg [2:0] index;
    reg [15:0] led_ctrl;

    assign {LEDSEL, LEDOUT} = led_ctrl;
    
    always @ (posedge clk) index <= (rst) ? 3'b0 : (index + 3'd1);
    
    always @ (index, LED0, LED1, LED2, LED3, LED4, LED5, LED6, LED7) begin
        case (index)
               3'd0: led_ctrl <= {8'b11111110, LED0};
               3'd1: led_ctrl <= {8'b11111101, LED1};
               3'd2: led_ctrl <= {8'b11111011, LED2};
               3'd3: led_ctrl <= {8'b11110111, LED3};
               3'd4: led_ctrl <= {8'b11101111, LED4};
               3'd5: led_ctrl <= {8'b11011111, LED5};
               3'd6: led_ctrl <= {8'b10111111, LED6};
               3'd7: led_ctrl <= {8'b01111111, LED7};
            default: led_ctrl <= {8'b11111111, 8'hFF};
        endcase
    end
    
endmodule