class apb_driver extends uvm_driver#(apb_sequence_item);
  `uvm_component_utils(apb_driver)

  // Virtual interface handle for the APB signals
  virtual apb_if vif;

  // Constructor
  function new(string name = "apb_driver", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  // Build phase
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(virtual apb_if)::get(this, "", "vif", vif)) begin
      `uvm_fatal("DRV", "Could not get virtual interface")
    end
  endfunction

  // Run phase: this task will be executed for each sequence item received
  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);

    apb_sequence_item trans;

    // Forever loop to process incoming transactions
    forever begin
      // Get the next transaction from the sequencer
      seq_item_port.get_next_item(trans);

      // Wait for the next positive edge of the clock
      @(posedge vif.pclk);

      // Set the APB signals according to the transaction fields
      vif.psel = trans.psel;
      vif.penable = trans.penable;
      vif.pwrite = trans.pwrite;
      vif.paddr = trans.paddr;
      vif.pwdata = trans.pwdata;

      // Handle the transaction (write or read)
      if (trans.pwrite) begin
        // Write operation
        vif.pwdata = trans.pwdata;
        `uvm_info("APB_DRV", $sformatf("WRITE: Addr=0x%0h, Data=0x%0h", trans.paddr, trans.pwdata), UVM_HIGH);
      end else begin
        // Read operation
        vif.prdata = trans.prdata;
        `uvm_info("APB_DRV", $sformatf("READ: Addr=0x%0h, Data=0x%0h", trans.paddr, trans.prdata), UVM_HIGH);
      end

      // Indicate that the driver has finished processing this transaction
      seq_item_port.item_done();
      
      // Wait for the next clock cycle
      @(posedge vif.pclk);
    end
  endtask

endclass
