// Module Name: apb_ram
// Description: APB slave module implementing a 32-location RAM with FSM-based control.
// Supports read and write operations according to the APB protocol.

module apb_ram (
  input presetn,                   // Active-low reset signal
  input pclk,                      // Clock signal
  input psel,                      // Slave select signal
  input penable,                   // Enable signal for read/write operation
  input pwrite,                    // Write (1) or Read (0) operation selector
  input [31:0] paddr, pwdata,      // Memory address and write data
  output logic [31:0] prdata,      // Data read from memory
  output logic pready, pslverr     // Ready and error signals
);

  reg [31:0] mem [32];             // Internal memory: 32 locations, 32 bits each

  // FSM states
  typedef enum {idle = 0, setup = 1, access = 2, transfer = 3} state_type;
  state_type state = idle;         // Current state
  state_type nextstate;            // Next state

  // Synchronous block: Handles reset and state transitions
  always_ff @(posedge pclk) begin
    if (presetn == 1'b0) begin
      // Reset: Initialize state, outputs, and memory
      state <= idle;
      prdata <= 32'h00000000;
      pready <= 1'b0;
      pslverr <= 1'b0;
      for (int i = 0; i < 32; i++) begin
        mem[i] <= 0;               // Initialize all memory locations to 0
      end
    end
    else begin
      state <= nextstate;          // Update state based on nextstate
    end  
  end 

  // Combinational block: FSM logic
  always_comb begin    
    case (state)
      idle: begin
        // Idle state: Reset outputs and check for slave selection
        prdata = 32'h00000000;
        pready = 1'b0;
        pslverr = 1'b0;
        if ((psel == 1'b0) && (penable == 1'b0)) begin
          nextstate = setup;
        end
        else begin
          nextstate = idle;
        end
      end
      
      setup: begin
        // Setup state: Prepare for access if conditions are met
        if ((psel == 1'b1) && (penable == 1'b0)) begin
          if (paddr < 32) begin 
            nextstate = access;
            pready = 1'b1;         // Ready for access
          end
          else begin
            nextstate = access;
            pready = 1'b0;         // Invalid address, not ready
          end
        end
        else begin
          nextstate = setup;
        end
      end
      
      access: begin 
        // Access state: Perform read or write operation
        if (psel && pwrite && penable) begin
          if (paddr < 32) begin
            mem[paddr] = pwdata;   // Write data to memory
            nextstate = transfer;
            pslverr = 1'b0;       // No error
          end
          else begin
            nextstate = transfer;
            pready = 1'b1;
            pslverr = 1'b1;       // Address out of range
          end
        end
        else if (psel && !pwrite && penable) begin
          if (paddr < 32) begin
            prdata = mem[paddr];  // Read data from memory
            nextstate = transfer;
            pready = 1'b1;
            pslverr = 1'b0;       // No error
          end
          else begin
            nextstate = transfer;
            pready = 1'b1;
            pslverr = 1'b1;       // Address out of range
            prdata = 32'hxxxxxxxx; // Undefined data
          end
        end
      end      

      transfer: begin
        // Transfer state: Reset outputs and return to setup state
        nextstate = setup;
        pready = 1'b0;
        pslverr = 1'b0;
      end      

      default: nextstate = idle;   // Default state
    endcase
  end  

endmodule
