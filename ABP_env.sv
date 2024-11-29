 class apb_env extends uvm_env;

  // Declare agents
  apb_agent agent;

  // Constructor
  function new(string name = "apb_env", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  // Build phase to create agents
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    // Create agent
    agent = apb_agent::type_id::create("agent", this);
  endfunction
  
  // Connect phase to connect all agents
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    
    // Connect agents if necessary (if agents connect to each other)
  endfunction

 endclass
