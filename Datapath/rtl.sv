module datapath(
    input  logic        clk,
    input  logic        reset,
    input  logic [1:0]  ResultSrc,
    input  logic        PCSrc,
    input  logic        ALUSrc,
    input  logic        RegWrite,
    input  logic [1:0]  ImmSrc,
    input  logic [2:0]  ALUControl,
    output logic        Zero,
    output logic [31:0] PC,
    input  logic [31:0] Instr,
    output logic [31:0] ALUResult,
    output logic [31:0] WriteData,
    input  logic [31:0] ReadData
);

    logic [31:0] PCPlus4;
    logic [31:0] PCBranch;
    logic [31:0] PCNext;
    logic [31:0] ImmExt;
    logic [31:0] SrcA;
    logic [31:0] SrcB;
    logic [31:0] WriteBack;
    logic [31:0] ReadData1;
    logic [31:0] ReadData2;

    assign PCPlus4 = PC + 32'd4;

    extend u_extend (
        .instr  (Instr[31:7]),
        .immsrc (ImmSrc),
        .immext (ImmExt)
    );

    assign PCBranch = PC + (ImmExt << 1);

    mux2 #(32) u_pc_mux (
        .d0 (PCPlus4),
        .d1 (PCBranch),
        .s  (PCSrc),
        .y  (PCNext)
    );

    flopr #(32) u_pc (
        .clk   (clk),
        .reset (reset),
        .d     (PCNext),
        .q     (PC)
    );

    regfile u_regfile (
        .clk  (clk),
        .we3  (RegWrite),
        .a1   (Instr[19:15]),
        .a2   (Instr[24:20]),
        .a3   (Instr[11:7]),
        .wd3  (WriteBack),
        .rd1  (ReadData1),
        .rd2  (ReadData2)
    );

    assign SrcA = ReadData1;
    assign SrcB = ALUSrc ? ImmExt : ReadData2;

    alu u_alu (
        .a         (SrcA),
        .b         (SrcB),
        .alucontrol(ALUControl),
        .result    (ALUResult)
    );

    assign Zero = (ALUResult == 32'd0);
    assign WriteData = ReadData2;

    mux3 #(32) u_wb_mux (
        .d0 (ALUResult),
        .d1 (ReadData),
        .d2 (PCPlus4),
        .s  (ResultSrc),
        .y  (WriteBack)
    );

endmodule
