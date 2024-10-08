class axi_driver extends uvm_driver#(txn);
    `uvm_component_utils(axi_driver)

    //vif
    virtual intf vif;
    //txn
    seq_item txn;
    //cfg
    tb_cfg cfg;
    //tlm
    uvm_tlm_port#(txn)gen2drv;
    extern drive();
    extern wr_addr();
    extern wr_data();
    extern wr_resp();
    extern rd_addr();
    //extern rd_data_resp();//will execute in monitor

    function new(string name="axi_driver", uvm_component parent);
        super.new(name,parent);
    endfunction

    function build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(!(uvm_config_db(tb_cfg cfg)::get(this, "", "vif", cfg.vif)))
            `uvm_error(get_type_name(), "Not Set Properly At Top");
    endfunction

    function connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        this.vif=cfg.vif;
    endfunction

    task run_phase(uvm_phase phase);
        forever begin
            @(posedge vif.aclk)
            //vif.bready  <=  1; both are used individually inside wr_resp() and rd_resp()
            //vif.rready  <=  1;
            vif.awready   <=  1;
            vif.wready    <=  1;
            vif.arready   <=  1;
            vif.rvalid    <=  1;
            vif.bvalid    <=  1;

            sequence_item_port.get_next_item(txn);
                drive();
            sequence_item_port.item_done(txn);

        end
    endtask
endclass
    
    task axi_driver::drive();//1. write addr phase 2. write data phase 3. wr_resp phase 4. rd_addr phase 5. rd_data/resp phase
        fork
        if(!vif.arstn)
            vif.awvalid<=1 ;
            wr_addr();
            @(vif.aclk);
            wait(vif.awready);
            #100;
            vif.awvalid<=0;
            @(vif.aclk);
            vif.wvalid<=1;
            wr_data();
            @(vif.aclk);
            wr_resp();
            @(vif.aclk);
            vif.bready<=0;
            #100;
            @(vif.aclk);
            rd_addr();
        join_none
    endtask
    task axi_driver::wr_addr();
        fork
            @(vif.aclk);
                vif.awid<=txn.awid;
                vif.awaddr<=txn.awaddr;
                vif.awlen<=txn.awlen;
                vif.awsize<=txn.awsize;
                vif.awburst<=txn.awburst;
        join_none
    endtask
    task axi_driver::wr_data();
       
        fork
            @(vif.aclk);
            if((vif.awvalid || vif.wvalid) && (vif.awready || vif.wready) )
                int len;
                len=(txn.wlen+1);
                for(int i=0; i<len; i++)
                    vif.wid<=   txn.wid;
                    vif.wdata<= txn.wdata[i];
                    vif.strb<=  txn.wstrb;
                    vif.wlast<= (i=len-1)?1:0;
                    //wait(vif.wready)
                    @(vif.aclk);
                    vif.wvalid<=0;
        join_none
    endtask
    task axi_driver::wr_resp();
      fork
        @(vif.aclk)
        wait(vif.bvalid)
        txn.bid<=vif.bid;
        txn.bresp<=vif.bresp;
        vif.bready<=1; 
      join_none
    endtask
    task axi_driver::rd_addr();
      fork
        @(vif.aclk);
        vif.arid<=txn.arid;
        vif.araddr<=txn.araddr;
        vif.arlen<=txn.arlen;
        vif.arbust<=txn.arburst;
        vif.arsize<=txn.arsize;

        vif.arvalid<=1;
        wait(vif.arready);
        @(vif.aclk);
        vif.valid<=0;
      join_none
    endtask
/*task axi_driver::rd_data_resp();//depricating this in driver and writing it in monitor 
      fork
        int len=vif.arlen+1;
        for(int i=0; i<len; i++)begin
          wait(vif.rvalid);
          txn.rid<=vif.rid;
          txn.rdata[i]<=vif.rdata;
          txn.rresp<=vif.rresp;
          if(vif.rlast)
            break;
          vif.rready<=1;
          @(vif.aclk);
          vif.rready<=0;
        end
    join_none
    endtask*/
