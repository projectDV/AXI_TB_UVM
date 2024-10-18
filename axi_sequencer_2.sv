class axi_seqeuncer_2 extends uvm_sequencer;
    `uvm_component_utils(axi_seqeuncer_1)

    function new(string name="axi_sequencer_2", uvm_component parent);
        super.new(name, parent);
    endfunction
    function build_phase(uvm_phase phase);
        super.build_phase(phase);
    endfunction
endclass
