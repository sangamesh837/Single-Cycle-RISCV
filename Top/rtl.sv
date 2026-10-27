module top(
    input  logic        clk,
    input  logic        reset,
    output logic [31:0] WriteData,
    output logic [31:0] DataAdr,
    output logic        MemWrite
);

    logic [31:0] Instr;
    logic [31:0] ReadData;
    logic [31:0] PC;
    logic [31:0] ALUResult;

    imem u_imem (
        .a  (PC),
        .rd (Instr)
    );

    riscvsingle u_riscvsingle (
        .clk       (clk),
        .reset     (reset),
        .PC        (PC),
        .Instr     (Instr),
        .MemWrite  (MemWrite),
        .ALUResult (ALUResult),
        .WriteData (WriteData),
        .ReadData  (ReadData)
    );

    assign DataAdr = ALUResult;

    dmem u_dmem (
        .clk (clk),
        .we  (MemWrite),
        .a   (DataAdr),
        .wd  (WriteData),
        .rd  (ReadData)
    );

endmodule
