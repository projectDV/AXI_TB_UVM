interface axi_if(input bit clk, bit rstn);

	//write_addr
	logic [8:0]awid;
	logic awvalid,awready;
	logic [3:0]awlen;
	logic [2:0]awsize;
	logic [1:0]awburst;
	logic [31:0]awaddr;

	//write_data
	logic [8:0]wid;
	logic [31:0]wdata;
	logic wvalid, wready, wlast;
	logic [1:0] wstrb;

	//write_resp
	logic [8:0]bid;
	logic [1:0]bresp;
	logic bvalid, bready;

	//read_addr
	logic [8:0]arid;
	logic arvalid, arready;
	logic [3:0]arlen;
	logic [2:0]arsize;
	logic [1:0]arburst;
	logic [31:0]araddr;

	//read_data;
	logic rvalid, rready,rlast;
	logic [8:0]rid;
	logic [31:0]rdata;
	logic [1:0]rresp;
	
	//m_drv_cb
	//mon_cb
	//s_mon_cb

	clocking m_drv_cb@(posedge clk)
		output 	awid, awvalid, awlen,awsize,awburst,awaddr,
			wid, wdata,wvalid,wlast,wstrb,
			arid,arvalid,arlen,arsize,arburst,araddr,
			rready,bready;
		input 	awready,wready,bid,bresp,bvalid,arready,rid,rlast,rdata,rresp,rvalid;
	endclocking

	clocking mon_cb@(posedge clk)
		  input awid, awvalid, awlen,awsize,awburst,awaddr,
			wid, wdata,wvalid,wlast,wstrb,
			arid,arvalid,arlen,arsize,arburst,araddr,
			rready,bready;
		output awready,wready,bid,bresp,bvalid,arready,rid,rlast,rdata,rresp,rvalid;
	endclocking

	clocking s_drv_cb@(posedge clk)
		input 	awid, awvalid, awlen,awsize,awburst,awaddr,
			wid, wdata,wvalid,wlast,wstrb,
			arid,arvalid,arlen,arsize,arburst,araddr,
			rready,bready;
		output 	awready,wready,bid,bresp,bvalid,arready,rid,rlast,rdata,rresp,rvalid;
	endclocking

	modport mdrv(clocking m_drv_cb);
	modport mmon(clocking mon_cb);
	modport sdrv(clocking s_drv_cb);
	modport smon(clocking mon_cb);
endinterface
