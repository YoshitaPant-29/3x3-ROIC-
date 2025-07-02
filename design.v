`timescale 1ns / 1ps

module pixel_scanner_v11 (
    input clk,
    input master_rst,
    output reg fsync,
    output reg intg,
    output reg [2:0] row,
    output reg [2:0] col
);

    // FSM States
    parameter IDLE         = 4'd0;
    parameter FSYNC        = 4'd1;
    parameter INTG_ON      = 4'd2;
    parameter ROW_START    = 4'd3;
    parameter COL_0        = 4'd4;
    parameter COL_1_WAIT   = 4'd5;
    parameter COL_1        = 4'd6;
    parameter COL_2_WAIT   = 4'd7;
    parameter COL_2        = 4'd8;
    parameter NEXT_ROW     = 4'd9;
    parameter INTG_OFF     = 4'd10;
    parameter DELAY        = 4'd11;

    reg [3:0] state;
    reg [3:0] intg_count;
    reg [2:0] delay_count;
    reg [1:0] row_index;

    always @(posedge clk or posedge master_rst) begin
        if (master_rst) begin
            state <= IDLE;
            fsync <= 0;
            intg <= 0;
            row <= 0;
            col <= 0;
            intg_count <= 0;
            delay_count <= 0;
            row_index <= 0;
        end else begin
            case (state)

                IDLE: begin
                    fsync <= 1;
                    state <= FSYNC;
                end

                FSYNC: begin
                    fsync <= 0;
                    intg <= 1;
                    intg_count <= 0;
                    row_index <= 0;
                    state <= ROW_START;
                end

                ROW_START: begin
                    row <= (3'b001 << row_index);
                    delay_count <= 0;
                    col <= 3'b001; // col[0]
                    state <= COL_0;
                end

                COL_0: begin
                    col <= 3'b000;
                    delay_count <= 0;
                    state <= COL_1_WAIT;
                end

                COL_1_WAIT: begin
                    if (delay_count < 5)
                        delay_count <= delay_count + 1;
                    else begin
                        col <= 3'b010; // col[1]
                        delay_count <= 0;
                        state <= COL_1;
                    end
                end

                COL_1: begin
                    col <= 3'b000;
                    delay_count <= 0;
                    state <= COL_2_WAIT;
                end

                COL_2_WAIT: begin
                    if (delay_count < 5)
                        delay_count <= delay_count + 1;
                    else begin
                        col <= 3'b100; // col[2]
                        delay_count <= 0;
                        state <= COL_2;
                    end
                end

                COL_2: begin
                    col <= 3'b000;
                    row <= 3'b000;
                    intg_count <= intg_count + 1;
                    if (row_index < 2) begin
                        row_index <= row_index + 1;
                        state <= ROW_START;
                    end else begin
                        state <= INTG_OFF;
                    end
                end

                INTG_OFF: begin
                    if (intg_count >= 10) begin
                        intg <= 0;
                        delay_count <= 0;
                        state <= DELAY;
                    end else begin
                        intg_count <= intg_count + 1;
                    end
                end

                DELAY: begin
                    if (delay_count < 1)
                        delay_count <= delay_count + 1;
                    else
                        state <= IDLE;
                end

                default: state <= IDLE;

            endcase
        end
    end

endmodule
