class axi_scorboard extends uvm_scoreboard;
    `uvm_component_utils(axi_scoreboard)
    
     uvm_analysis_import#(axi_seq_item)ap_sb;
     axi_seq_item mon2sb, rm2sb;
     //virtual axi_if vif;
     int mem[int];
     
     function new(string name="axi_scoreboard", uvm_component parent);
        super.new(name,parent);
        ap_sb=new();
     endfunction
     function build_phase(uvm_phase phase);
        super.build_phase(phase);
        mon2sb=axi_seq_item::type_id::create("mon2sb",this);
        //rm2sb=axi_seq_item::type_id::create("rm2sb",this);
     endfunction
     task run_phase(uvm_phase phase);
        //@(vif.m_drv_cb)
        forever begin
            ap_sb.get(mon2sb);
            rm2sb=new mon2sb;
            ref_model_write(mon2sb);
            ref_model_read(rm2sb);
            compare(rm2sb);
        end
     endtask
     task ref_model_write(mon2sm rm_mon);
        if(mon2sb.write)
        mem[rm_mon.awaddr]=rm_mon.wdata;
        //if(mon2sb.write)
        //rm.rdata=mem[rm.araddr];
     endtask
     
     task ref_model_read(ref rm2sb rm);
        if(mon2sb.read)
        rm.rdata=mem[rm.awaddr];
     endtask

     task compare(rm2sb rm);
        rm2sb ref_tx;
        $cast(ref_tx,rm.clone());
        if(rm.compare(ref_tx))
            `uvm_info("DATA MATCHED");
        else
            `uvm_error("DATA MISMATCH");
     endtask
endclass

