module dmem(
    input  logic        clk,
    input  logic        we,
    input  logic [31:0] a,
    input  logic [31:0] wd,
    output logic [31:0] rd
);

    logic [31:0] ram [0:63];

    always_ff @(posedge clk) begin
        if (we)
            ram[a[7:2]] <= wd;
    end

    assign rd = ram[a[7:2]];

endmodule
