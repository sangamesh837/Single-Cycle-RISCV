module imem(
    input  logic [31:0] a,
    output logic [31:0] rd
);

    logic [31:0] rom [0:63];

    assign rd = rom[a[7:2]];

endmodule
