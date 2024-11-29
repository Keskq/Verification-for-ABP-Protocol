 class apb_env extends uvm_env;

  `uvm_component_utils(abp_env)
  
  // Declare agents, coverage, scoreboard
  apb_agent agent;
  mux_coverage coverage;
  mux_scoreboard scoreboard;

  // Constructor
  function new(string name = "apb_env", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  // Build phase to create agents
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    // Create agent
    agent = apb_agent::type_id::create("agent", this);
    coverage = apb_coverage::type_id::create("coverage",this);
    scoreboard = apb_scoreboard::type_id::create("scoreboard",this);
  endfunction
  
  // Connect phase to connect all agents
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    agent.monitor.ap_mon.connect(coverage.analysis_export);
    // connection to aport_drv and aport_mon in scoreboard
    agent.monitor.ap_mon.connect(scoreboard.aport_mon);
    agent.driver.drv2sb.connect(scoreboard.aport_drv);
  endfunction

 endclass:abp_env
