module axi_top;
    //clock
    bit aclk=0;
    bit arstn;
    
    always begin
    //#10 aclk=0;
    #10 aclk=~aclk;
    end
    //interface
    intf if(aclk);
    //DUT Instantiation
    axi DUT(.intf_h(if))
    //reset
    @(posedge aclk) begin
    arstn=0;
    #10;
    arstn=1;
    end
    //test
    initial begin
        uvm_config_db(virtual intf if)::set(null,"*","vif",if)
    end

    initial begin
        run_test("axi_test")
    end