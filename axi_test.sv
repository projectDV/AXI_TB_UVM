class axi_test extends uvm_test;
    `uvm_component_utils(axi_test)
    
    //axi_virtual_sequence v_seq;
    axi_env env;

    function new(string name="axi_test", uvm_component parent);
        super.new(name,parent);
    endfunction
    virtual function build_phase(uvm_phase phase);
        super.build_phase(phase);
        //v_seq=axi_virtual_sequence::type_id::create("v_seq",this);
        env=axi_env::type_id::create("env",this);
    endfunction
endclass

class test_1 extends axi_test;
    `uvm_component_utils(test_1)

    axi_seq1 seq1;
    function new(string name="test_1", uvm_component parent);
        super.new(name,parent);
    endfunction

    task run_phase(uvm_phase phase);
        
        seq1=axi_seq1::type_id::create(seq1);
        phase.raise_objection(this);
        seq1.start(env.v_seqr);
        phase.drope_objection(this);
    endtask
endclass

class test_2 extends axi_test;
    `uvm_component_utils(test_2)
    function new(string name="test_2", uvm_component parent);
        super.new(name,parent);
    endfunction

    task run_phase(uvm_phase phase);
        axi_seq2 seq2;
        seq2=axi_seq2::type_id::create("seq2");
        phase.raise_objection(this);
        seq2.start(env.v_seqr);
        phase.drop_objection(this);
    endtask
endclass




