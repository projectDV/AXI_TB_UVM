class axi_env extends uvm_enivronment;
    `uvm_component_utils(axi_env)

    axi_virtual_sequencer v_seqr;
    axi_agt_1 agt_1;
    axi_agt_2 agt_2;
    sco sb;

    function new(string name="axi_env", uvm_component parent);
        super.new(name,parent);
    endfunction
    function build_phase(uvm_phase phase);
        super.build_phase(phase);

        v_seqr=axi_virtual_sequencer::type_id::create("v_seqr");
        agt_1=axi_agt_1::type_id::create("agt_1");
        agt_2=axi_agt_2::type_id::create("agt_2");
        sb=sco::type_id::create("sb");
    endfunction

    function connect_phase(uvm_phase phase);
        super.connect_phase(phase);

        agt_1.mon_1.item_collected_port.connect(sb.imp);
    endfunction
endclass


