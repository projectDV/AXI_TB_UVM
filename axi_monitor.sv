class axi_monitor extends uvm_monitor;
    `uvm_component_utils(axi_monitor)

    seq_item txn;
    virtual interface vif;
    uvm_analysis_port#(txn) mon2sb;
    tb_cfg cfg;

    function new(string name="axi_monitor", uvm_component parent);
        super.new(name,parent);
    endfunction
    function build_phase(uvm_phase phase)
        super.build_phase(phase);
        if(!(uvm_config_db#(virtual interface)::get(this,"","vif",cfg.vif)))
            `uvm_fatal("Not Properly Set At TOP");
    endfunction
    function connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        this.vif=cfg.vif;
    endfunction 
    task run_phase(uvm_phase phase);
            forever begin
                @(vif.mon_cb)
                wait(vif.rvalid);
                monitor();
                mon2sb.write(txn);
            end
    endtask
    task monitor();
        fork
            int len =vif.arlen+1;
            for(int i=0; i<len;i++)
            txn.rdata[i]=vif.rdata[i];
            txn.rid=vif.rid;
            txn.rresp=vif.rresp;
            if(vif.rlast)
            break
            vif.rready<=1;
            @(vif.mon_cb)
            vif.rready<=0;
        join_none
    endtask
endclass
