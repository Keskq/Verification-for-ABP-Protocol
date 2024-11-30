class apb_agent extends uvm_agent;
  `uvm_component_utils(apb_agent)

  // Driver, Sequencer, and Monitor
  apb_driver drv;
  apb_sequencer seq;
  apb_monitor mon;

  // Virtual interface handle
  virtual apb_if vif;

  // Constructor
  function new(string name = "apb_agent", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  // Build phase
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    // Get virtual interface
    if (!uvm_config_db#(virtual apb_if)::get(this, "", "vif", vif)) begin
      `uvm_fatal("AGENT", "Could not get virtual interface")
    end

    // Create driver, sequencer, and monitor
    drv = apb_driver::type_id::create("drv", this);
    seq = apb_sequencer::type_id::create("seq", this);
    mon = apb_monitor::type_id::create("mon", this);
  endfunction

  // Connect phase
  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);

    // Connect driver to sequencer
    drv.seq_item_port.connect(seq.seq_item_export);

    // Connect monitor to scoreboard or coverage
    mon.ap_mon.connect(scoreboard_h.ap_mon);
  endfunction

  // Start phase
  virtual function void start_phase(uvm_phase phase);
    super.start_phase(phase);
    // Start the sequencer and driver
    seq.start();
    drv.start();
  endfunction

endclass
