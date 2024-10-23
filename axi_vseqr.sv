class axi_virtual_sequencer extends uvm_sequencer;
    `uvm_component_utils(axi_virtual_sequencer)

    axi_sequencer_1 seqr_1;
    axi_sequencer_2 seqr_2;

    function new(string name="axi_virtual_sequencer", uvm_component parent);
        super.new(name, parent);
    endfunction
    function build_phase(uvm_phase phase);
        super.build_phase(phase);
        seqr_1=new();
        seqr_2=new();
    endfunction
endclass

