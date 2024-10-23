class axi_agt_2 extends uvm_agent;
    `uvm_component_utils(axi_agt_2)

    //driver
    //axi_driver_1 drv_1;
    axi_driver_2 drv_2;
    //sequencer
    //axi_sequencer_1 seqr_1;
    axi_seqeuncer_2 seqr_2;
    //monitor    
    //axi_monitor mon_1;
    axi_monitor mon_2;
    function new(string name="axi_agt_1", uvm_component parent);   
        super.new(name,parent);
    endfunction 

    function build_phase(uvm_phase phase);
        super.build_phase(phase);
        //drv_1=axi_driver_1::type_id::create(drv_1,this);
        drv_2=axi_driver_2::type_id::create(drv_2,this);
        //seqr_1=axi_sequencer_1::type_id::create(seqr_1,this);
        seqr_2=axi_sequencer_2::type_id::create(seqr_2,this);
        //mon_2=axi_monitor_2::type_id::create(mon_2,this);
        mon_1=axi_monitor_1::type_id::create(mon_1,this);
    endfunction 
    function connect_phase(uvm_phase phase);
        super.connect_phase(phase)
        drv_2.sequence_item_port.connect(seqr_2.sequence_item_export);
    endfunction
endclass



