class apb_monitor extends uvm_monitor;
  `uvm_component_utils(apb_monitor)

  // Analysis port to send sequence items to scoreboard or coverage
  uvm_analysis_port#(apb_sequence_item) ap_mon;

  // Virtual interface handle
  virtual apb_if vif;

  // Constructor
  function new(string name = "apb_monitor", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  // Build phase
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(virtual apb_if)::get(this, "", "vif", vif)) begin
      `uvm_fatal("MON", "Could not get virtual interface")
    end
    ap_mon = new("ap_mon", this);
  endfunction

  // Run phase
  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);

    apb_sequence_item trans;
    forever begin
      // Wait for a valid APB transaction
      @(posedge vif.pclk);
      if (vif.psel && vif.penable) begin
        trans = apb_sequence_item::type_id::create("trans");

        // Capture sequence item data
        trans.psel = vif.psel;
        trans.penable = vif.penable;
        trans.pwrite = vif.pwrite;
        trans.paddr = vif.paddr;
        trans.pwdata = vif.pwdata;

        if (vif.pwrite) begin
          // Write transaction
          `uvm_info("APB_MON", $sformatf("WRITE: Addr=0x%0h, Data=0x%0h", trans.paddr, trans.pwdata), UVM_HIGH);
          trans.pslverr = vif.pslverr;
        end else begin
          // Read transaction
          trans.prdata = vif.prdata;
          trans.pslverr = vif.pslverr;
          `uvm_info("APB_MON", $sformatf("READ: Addr=0x%0h, Data=0x%0h", trans.paddr, trans.prdata), UVM_HIGH);
        end

        // Validate the transaction
        if (trans.paddr >= 32'h1000 && trans.paddr < 32'h2000) begin
          `uvm_error("APB_MON", "Invalid address range detected!")
          trans.pslverr = 1'b1;
        end

        // Send the sequence item via analysis port
        ap_mon.write(trans);
      end

      // Handle reset
      if (!vif.presetn) begin
        `uvm_info("APB_MON", "Reset detected, waiting for release", UVM_LOW);
        @(posedge vif.presetn);
        `uvm_info("APB_MON", "Reset released, resuming monitoring", UVM_LOW);
      end
    end
  endtask
endclass
