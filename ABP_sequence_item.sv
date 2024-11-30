class apb_sequence_item extends uvm_sequence_item;

  //------------ APB transaction field declaration -----------------
  rand logic        psel;      // APB select signal
  rand logic        penable;   // APB enable signal
  rand logic        pwrite;    // APB write signal
  rand logic [31:0] paddr;     // APB address
  rand logic [31:0] pwdata;    // APB write data
  logic [31:0]      prdata;    // APB read data
  rand logic        pslverr;   // APB slave error signal
  
  //---------------- register apb_sequence_item class with factory --------
  `uvm_object_utils_begin(apb_sequence_item)
    `uvm_field_int(psel,     UVM_ALL_ON)
    `uvm_field_int(penable,  UVM_ALL_ON)
    `uvm_field_int(pwrite,   UVM_ALL_ON)
    `uvm_field_int(paddr,    UVM_ALL_ON)
    `uvm_field_int(pwdata,   UVM_ALL_ON)
    `uvm_field_int(prdata,   UVM_ALL_ON)
    `uvm_field_int(pslverr,  UVM_ALL_ON)
  `uvm_object_utils_end
  //----------------------------------------------------------------------------

  //---------------------------------------------------------------------------- 
  // Constructor
  function new(string name = "apb_sequence_item");
    super.new(name);
  endfunction
  //----------------------------------------------------------------------------

  //---------------------------------------------------------------------------- 
  // Write DUT inputs here for printing
  function string input2string();
    return($sformatf("psel=%b penable=%b pwrite=%b paddr=0x%8h pwdata=0x%8h", 
                     psel, penable, pwrite, paddr, pwdata));
  endfunction
  
  // Write DUT outputs here for printing
  function string output2string();
    return($sformatf("prdata=0x%8h pslverr=%b", prdata, pslverr));
  endfunction
  
  // Combine input and output for complete transaction logging
  function string convert2string();
    return($sformatf({input2string(), "  ", output2string()}));
  endfunction
  //----------------------------------------------------------------------------

endclass:apb_sequence_item
