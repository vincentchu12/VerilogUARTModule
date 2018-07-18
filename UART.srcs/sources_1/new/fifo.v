module FIFO #(
        parameter LENGTH = 16,
        parameter WIDTH = 32
    )    (
        input  wire             clk,
        input  wire             rst,
        input  wire             wr_cs,
        input  wire             wr_en,
        input  wire             rd_cs,
        input  wire             rd_en,
        output reg              full,
        output reg              empty,
        output reg  [WIDTH-1:0] out,
        input  wire [WIDTH-1:0] in
    );
    // ==================================
    //// Internal Parameter Field
    // ==================================
    parameter ADDRESS_WIDTH = $clog2(LENGTH);
    // ==================================
    //// Registers
    // ==================================
    reg [ADDRESS_WIDTH-1:0] write_position;
    reg [ADDRESS_WIDTH-1:0] read_position;
    reg [ADDRESS_WIDTH:0] status_count;
    reg [WIDTH-1:0] mem [0:LENGTH];
    // ==================================
    //// Wires
    // ==================================
    // ==================================
    //// Wire Assignments
    // ==================================
    // assign full  = (status_count == (LENGTH));
    // assign empty = (status_count == 0);
    // ==================================
    //// Modules
    // ==================================
    // ==================================
    //// Behavioral Block
    // ==================================
    always @(posedge clk or posedge rst)
    begin
        if(rst)
        begin
            write_position = 0;
            read_position = 0;
            status_count = 0;
            mem[write_position] = 0;
            write_position = 0;
            out = 0;
            full = 0;
            empty = 1;
        end
        else
        begin
            if(status_count == 0)
            begin
                empty = 1;
            end
            if(status_count == LENGTH)
            begin
                full = 1;
            end
            //// Enqueue data
            if (wr_cs && wr_en && !full)
            begin
                mem[write_position] = in;
                if(write_position == LENGTH-1)
                begin
                    write_position = 0;
                end
                else
                begin
                    write_position = write_position + 1;
                end
                status_count = status_count + 1;
                empty = 0;
            end
            //// Dequeue data
            if (rd_cs && rd_en && !empty)
            begin
                out = mem[read_position];
                if(read_position == LENGTH-1)
                begin
                    read_position = 0;
                end
                else
                begin
                    read_position = read_position + 1;
                end
                status_count = status_count - 1;
                full = 0;
            end
        end
    end

endmodule