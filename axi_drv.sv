class axi_drv extends uvm_driver#(axi_seq_item);
	`uvm_component_utils(axi_drv)
	virtual axi_if.mdrv vif;                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     vif;
	axi_seq_item w_txn;
	axi_seq_item r_txn;//not yet made logic for it. Only did for write txn
	axi_cfg cfg;
	logic awvalid, wvalid;
	function new(name=axi_drv, uvm_compnent parent)
			super.new(name,parent);
			vif=new();
			w_txn=new();
			r_txn=new();
	endfunction
	
	function void build_phase(uvn_phase build_phase);
		super.build_phase(phase);
		if(!uvm_config_db#(virtual axi_if.mdrv )::get(this, "","vif",cfg))
			`uvm_error(get_type_name(),"Not set at top level")//get_type_name shows the class name to which this is associated.
			//`uvm_error(get_full_name(),"Not set at top level")[get_full_name is also used to print the whole hierarchy.]
	endfunction
	
	function void connect_phase(uvm_phase phase)'
		super.connect_phase(phase);
		this.vif=cfg.vif
	endfunction 
	
	task run_phase(uvm_phase phase);
		super.run_phase(phase);
		`uvm_info(get_type_name(),"Run_Phase is starting", UVM_LOW)
		vsif.m_drv_cb.bready<=1;
		forever begin
			drive();
		end
	endtask
	
	task drive();
		if(!vif.rstn)begin//reset is low [Active State]
			vsif.m_drv_cb.awvalid<=0;
			vsif.m_drv_cb.wvalid<=0;
			vsif.m_drv_cb.arvalid<=0;
		end
		else begin
			fork begin
				seq_item_port.get_next_item(w_txn);
				`uvm_info(get_name(),"Packet Received In DRV",UVM_LOW)
				@(vsif.m_drv_cb);
					vsif.m_drv_cb.awaddr<=w_txn.awaddr;//driving addr
					vsif.m_drv_cb.awlen<=w_txn.awlen;
					vsif.m_drv_cb.awsize<=w_txn.awsize;
					vsif.m_drv_cb.awbusrt<=w_txn.awbusrt;
					//assert awvalid->wait 1 cycle-> de-assert awvalid
					@(vsif.m_drv_cb);
					awvalid=1;
					vsif.m_drv_cb.awvalid<=awvalid;
					
					wait(vsif.m_drv_cb.awready);
					awvalid=0;
					vsif.m_drv_cb.awvalid<=awvalid;
					
					wait(vsif.m_drv_cb.bvalid);
					
					vsif.m_drv_cb.wdata<=w_txn.wdata;// Driving data
					`uvm_info("DRV", "Data Driven", UVM_HIGH)
					//assert wvalid->wait 1 cycle-> de-assert wvalid->wait for bvalid
					@(vsif.m_drv_cb);
						wvalid=1;
						vsif.m_drv_cb.wvalid<=wvalid;
						
						wait(vsif.m_drv_cb.wready)
						wvalid=0;
						vsif.m_drv_cb.wvalid=wvalid;
						
						wait(vsif.m_drv_cb.bvalid)
				seq_item_port.item_done();
				end
			join_none
		end
	endtask
endclass  
	
					
				
					
				
					
					
			
			
			
