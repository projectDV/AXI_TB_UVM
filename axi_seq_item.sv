class axi_seq_item extends uvm_sequence_item;

	'uvm_object_utils(axi_seq_item);
	
	//write_addr
	rand bit [31:0]awaddr;
	rand bit [3:0]awlen;
	rand bit [2:0]awsize;
	rand bit [1:0]awburst;
	rand bit [8:0]awid;
	bit awvalid, awready;
	
	//write
	bit wvalid,wready;
	rand bit [31:0]wdata;
	bit [8:0]wid;
	bit wlast;
	
	//write_resp
	bit bready, bvalid
	bit [8:0] bid;
	
	//read_addr
	bit [31:0]araddr;
	bit [3:0]awlen;
	bit [2:0]awsize;
	bit [1:0]awburst;
	bit [8:0]arid;
	bit arready, arvalid;
	
	//read
	bit [31:0]rdata;
	bit [8:0]rid;
	bit rready,rvalid;
	bit rlast;
	bit [1:0]rresp;
	
	function new(string name="axi_seq_item")
		super.new(name);
	endfunction
endclass
