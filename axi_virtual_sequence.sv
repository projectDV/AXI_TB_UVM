class virtual_sequence extends uvm_sequence#(uvm_sequence_item);
    `uvm_object_utils(virtual_sequence)
    `uvm_declare_p_sequencer(axi_virtual_sequencer);

    axi_sequencer_1 seqr_1;
    axi_sequencer_2 seqr_2;
    axi_virtual_sequencer v_seqr;


    function new(string name="virtual_sequencer");
        super.new(name,this);
    endfunction

    task body();
        seqr_1=p_sequencer.seqr_1;
        seqr_2=p_sequencer.seqr_2;
    endtask
endclass
class sequence_1 extends virtual_sequence;
    `uvm_object_utils(sequence_1)

    axi_seq1 seq_1;
    
    function new(string name="sequence_1");
        super.new();
    endfunction 

    task body();
        super.body();   
        seq_1=axi_seq1::type_id::create("seq_1");
        seq_1.start(p_sequencer.seqr_1);//`uvm_do_on(seq_1,seqr_1)
    endtask
endclass
class sequence_2 extends virtual_sequence;
    `uvm_object_utils(sequence_2)

    axi_seq2 seq_2;
    function new(string name="sequence_2");
        super.new(name);
    endfunction
    task body();
        super.body();
        seq_2=axi_seq2::type_id::create("seq_2");
        seq_2.start(p_sequencer.seqr_2);//`uvm_do_on(seq_2,seqr_2);
    endtask
endclass