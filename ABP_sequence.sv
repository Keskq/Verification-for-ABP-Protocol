/***************************************************
** class name  : apb_sequence 
** description : generate random values for APB signals
***************************************************/
class apb_sequence extends uvm_sequence#(apb_sequence_item);
  //----------------------------------------------------------------------------
  `uvm_object_utils(apb_sequence)            
  //----------------------------------------------------------------------------

  apb_sequence_item txn;
  int N = 10; // Number of transactions to generate
  //----------------------------------------------------------------------------
  function new(string name="apb_sequence");  
    super.new(name);
  endfunction
  //----------------------------------------------------------------------------

  //----------------------------------------------------------------------------
  virtual task body();
    for (int i = 0; i < N; i++) begin 
      txn = apb_sequence_item::type_id::create("txn");
      start_item(txn);
      txn.randomize();
      finish_item(txn);
    end
  endtask:body
  //----------------------------------------------------------------------------
endclass:apb_sequence

/***************************************************
** class name  : addr_range_1
** description : restrict address to range 0x1000-0x1FFF
***************************************************/
class addr_range_1 extends apb_sequence;
  //----------------------------------------------------------------------------
  `uvm_object_utils(addr_range_1)      
  //----------------------------------------------------------------------------
  
  apb_sequence_item txn;
  int N = 10;
  //----------------------------------------------------------------------------
  function new(string name="addr_range_1");
      super.new(name);
  endfunction
  //----------------------------------------------------------------------------
  
  //----------------------------------------------------------------------------
  task body();
    for (int i = 0; i < N; i++) begin 
      txn = apb_sequence_item::type_id::create("txn");
      start_item(txn);
      txn.randomize() with {
        txn.paddr inside {32'h1000:32'h1FFF};
      };
      finish_item(txn);
    end
  endtask:body
  //----------------------------------------------------------------------------
endclass:addr_range_1

/***************************************************
** class name  : write_only
** description : force pwrite signal to 1
***************************************************/
class write_only extends apb_sequence;
  //----------------------------------------------------------------------------
  `uvm_object_utils(write_only)      
  //----------------------------------------------------------------------------
  
  apb_sequence_item txn;
  int N = 10;
  //----------------------------------------------------------------------------
  function new(string name="write_only");
      super.new(name);
  endfunction
  //----------------------------------------------------------------------------
  
  //----------------------------------------------------------------------------
  task body();
    for (int i = 0; i < N; i++) begin 
      txn = apb_sequence_item::type_id::create("txn");
      start_item(txn);
      txn.randomize() with {
        txn.pwrite == 1;
      };
      finish_item(txn);
    end
  endtask:body
  //----------------------------------------------------------------------------
endclass:write_only

/***************************************************
** class name  : read_only
** description : force pwrite signal to 0
***************************************************/
class read_only extends apb_sequence;
  //----------------------------------------------------------------------------
  `uvm_object_utils(read_only)      
  //----------------------------------------------------------------------------
  
  apb_sequence_item txn;
  int N = 10;
  //----------------------------------------------------------------------------
  function new(string name="read_only");
      super.new(name);
  endfunction
  //----------------------------------------------------------------------------
  
  //----------------------------------------------------------------------------
  task body();
    for (int i = 0; i < N; i++) begin 
      txn = apb_sequence_item::type_id::create("txn");
      start_item(txn);
      txn.randomize() with {
        txn.pwrite == 0;
      };
      finish_item(txn);
    end
  endtask:body
  //----------------------------------------------------------------------------
endclass:read_only

/***************************************************
** class name  : addr_edge_cases
** description : test edge cases for address values
***************************************************/
class addr_edge_cases extends apb_sequence;
  //----------------------------------------------------------------------------
  `uvm_object_utils(addr_edge_cases)      
  //----------------------------------------------------------------------------
  
  apb_sequence_item txn;
  int N = 10;
  //----------------------------------------------------------------------------
  function new(string name="addr_edge_cases");
      super.new(name);
  endfunction
  //----------------------------------------------------------------------------
  
  //----------------------------------------------------------------------------
  task body();
    for (int i = 0; i < N; i++) begin 
      txn = apb_sequence_item::type_id::create("txn");
      start_item(txn);
      txn.randomize() with {
        txn.paddr inside {32'h0000_0000, 32'hFFFF_FFFF, 32'h1000, 32'h1FFF};
      };
      finish_item(txn);
    end
  endtask:body
  //----------------------------------------------------------------------------
endclass:addr_edge_cases

/***************************************************
** class name  : burst_length_test
** description : check transactions with burst lengths
**               of varying sizes
***************************************************/
class burst_length_test extends apb_sequence;
  //----------------------------------------------------------------------------
  `uvm_object_utils(burst_length_test)      
  //----------------------------------------------------------------------------
  
  apb_sequence_item txn;
  int N = 10;
  //----------------------------------------------------------------------------
  function new(string name="burst_length_test");
      super.new(name);
  endfunction
  //----------------------------------------------------------------------------
  
  //----------------------------------------------------------------------------
  task body();
    for (int i = 0; i < N; i++) begin 
      txn = apb_sequence_item::type_id::create("txn");
      start_item(txn);
      txn.randomize() with {
        txn.psize inside {3'b000, 3'b001, 3'b010, 3'b011};
      };
      finish_item(txn);
    end
  endtask:body
  //----------------------------------------------------------------------------
endclass:burst_length_test

/***************************************************
** class name  : data_edge_cases
** description : test edge cases for data values
***************************************************/
class data_edge_cases extends apb_sequence;
  //----------------------------------------------------------------------------
  `uvm_object_utils(data_edge_cases)      
  //----------------------------------------------------------------------------
  
  apb_sequence_item txn;
  int N = 10;
  //----------------------------------------------------------------------------
  function new(string name="data_edge_cases");
      super.new(name);
  endfunction
  //----------------------------------------------------------------------------
  
  //----------------------------------------------------------------------------
  task body();
    for (int i = 0; i < N; i++) begin 
      txn = apb_sequence_item::type_id::create("txn");
      start_item(txn);
      txn.randomize() with {
        txn.pwdata inside {32'h0000_0000, 32'hFFFF_FFFF, 32'hAAAA_AAAA, 32'h5555_5555};
      };
      finish_item(txn);
    end
  endtask:body
  //----------------------------------------------------------------------------
endclass:data_edge_cases
