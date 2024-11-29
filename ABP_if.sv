interface apb_if();
  
  input logic pclk;             // Clock signal
  input logic presetn;            // Reset signal
  logic psel;                    // Slave select signal
  logic penable;                 // Enable signal for transaction
  logic pwrite;                  // Write (1) or Read (0) operation selector
  logic [31:0] paddr;            // Address for memory operation
  logic [31:0] pwdata;           // Data for write operation
  logic [31:0] prdata;           // Data for read operation
  logic pready;                  // Ready signal
  logic pslverr;                 // Error signal
  
endinterface
