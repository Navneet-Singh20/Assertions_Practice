//-----------------------------------Assertion Solutions-----------------------------



//Question 1:Write an assertion check to make sure that a signal is high for a minimum of 2 cycles and a maximum of 6 cycles??

module as1;
  
  logic addr;
  
  bit clk;
  
  //generation of clk
  initial begin
    forever #5 clk=~clk;
  end
  /*
  always@(posedge clk) begin
    assert property(@(posedge clk) addr[*2:6]);
      //it will work fine without @(posedge clk) also because that event is taking care by posedge clk
  end
      
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0);
    addr=0;
    #5;
    addr=1;
    #20;
    addr=0;
  end
      
  initial begin
    repeat(10) begin
      @(posedge clk);
    end
    $finish;
  end
  */
      
endmodule
      
      
 //Question 2:  Are following assertions equivalent:
      //@(posedge clk) req |=> ##2 $rose(ack); -> It is using Non-overlapping Implication Operator
      //@(posedge clk) req |-> ##3 $rose(ack); -> It is using overlapping Implication Operator
      
 //Ans :   //But overall accr to above example both are equivalent
      
      
 //Question 3: For a synchronous FIFO of depth = 16, write an assertion for the following 
			// scenarios. Assume a clock signal(clk), write and read enable signals, full flag 
			// and a word counter signal. 
			//	a. If the word count is >15, FIFO full flag set.
			//	b. If the word count is 15 and a new write operation happens without a 
			//	   simultaneous read, then the FIFO full flag is set
      
 /*     
 //Ans a: 
      property p1;
        @(posedge clk)
        (count > 15) |-> full_flag;
      endproperty
      
 //Ans b:
      property p2;
        @(posedge clk)
        (count == 15) |-> write ##0 !read ##1 full_flag;
      endproperty
      */

      

      
//Question 4: Write an assertion checker to make sure that an output signal never goes X?
      
module tba_4;
  
  logic addr;
  bit clk;
  
  property p1;
    @(posedge clk)
    //addr ##1 (addr!=1'bx);
    $isunknown(addr);
    //assert property @(posedge clk) $isunknown(opcode);
  endproperty
  
  initial begin
    forever begin
      #5 clk=~clk;
    end
  end
  /*
  always@(posedge clk) begin
    assert property(p1) begin
      $error($time,"Don't Care detected");
    end else begin
      $display("");
    end
  end
      
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0);
    #10;
    addr=0;
    #10;
    addr=1'bx;
    #10;
    addr=1;
    #10;
    addr=1'bz;
    #10;
    $finish;
  end
  */
      
endmodule


//Question 5: Write an assertion to make sure that a 5-bit grant signal only has one bit set 
//			  at any time? 

module tb5_a;
  
  bit [4:0] grant;
  
  bit clk;
  
  always #5 clk=~clk;
  
  /*
  
  assert property(@(posedge clk) $countones(grant)==1);
    //OR : assert property(@(posedge clk) $onehot(grant));
  
  initial begin
    $dumpfile("dump4.vcd");
    $dumpvars(0);
    #6;
    grant=5'b00001;
    #10;
    grant=5'b00011;
    #10;
    $finish;
  end
  */
  
endmodule


//Question 6: Write an assertion which checks that once a valid request is asserted by the 
//			  master, the arbiter provides a grant within 2 to 5 clock cycles??

//Ans :
/*
		property p1;
          @(posedge clk)
          disable iff(!rst);
          valid |-> ##[2:5] grant;
        endproperty
*/


//Question 7:  How can you disable an assertion during active reset time?

//Ans :
/*
		property p1;
          @(posedge clk)
          disable iff(rst);
          //here you can write your assertions
        endproperty
*/


//Question 8:How can all assertion be turned off during simulation (with active assertions)?

//Ans : with using => $assertkill


//Question 9:As long as signal_a is up, signal_b should not be asserted. Write an assertion?

//Ans :
/*
		property p1;
          @(posedge clk)
          disable iff(!rst);
          signal_a |-> !signal_b;
        endproperty
*/


//Question 10:The signal_a is a pulse; it can only be asserted for one cycle, and must be
//			  deasserted in the next cycle?

//Ans :
/*
		property p1;
          @(posedge clk)
          disable iff(!rst);
          signal_a ##1 !signal_a;
          //or $rose(signal_a) ##1 $fell(signal_b);
        endproperty
*/


//Question 11: Signal_a and signal_b can only be asserted together for one cycle; in the 
//			   next cycle, at least one of them must be deasserted?

//Ans :
/*
		property p2;
          @(posedge clk)
          disable iff(!rst);
          (signal_a && signal_b) |=> (!signal_a || !signal_b);
          //or $rose(signal_a && signal_b) ##1 !(signal_a or signal_b)
        endproperty
*/


//Question 12: When signal_a is asserted, signal_b must be asserted, and must remain up 
//			   until one of the signals signal_c or signal_d is asserted?

//Ans :
/*
		property p1;
          @(posedge clk)
          disable iff(!rst);
          signal_a ##0 (signal_b until (signal_c or signal_d));
        endproperty
 */


//Question 13: After signal_a is asserted, signal_b must be deasserted, and must stay 
//			   down until the next signal_a?

//Ans :
/*
		property p1;
          @(posedge clk)
          signal_a |=> (!signal_b until ($rose(signal_a)));
          //or $rose(signal_a) |-> (!signal_b until signal_a);
        endproperty
*/

//Question 14: If signal_a is received while signal_b is inactive, then on the next cycle 
//			   signal_c must be inactive, and signal_b must be asserted?

//Ans :
/*
		property p1;
          @(posedge clk)
          (!signal_b and signal_a) ##1 (!signal_c and signal_b);
        endproperty
*/


//Question 15: signal_a must not be asserted together with signal_b or with signal_c?

//Ans	:
/*
		property p1;
          @(posedge clk)
          ((signal_a && !signal_b) || (signal_a && !signal_c));
          //or (!(signal_a) within (signal_b or signal_c));
        endproperty
*/


//Question 16: In a RESP operation, request must be true immediately, grant must be true 
//			   3 clock cycles later, followed by request being false, and then grant being 
//			   false.

//Ans	:
/*
		property p1;
          @(posedge clk)
          disable iff(!rst)
          (operation==RESP) |-> req ##3 grant ##1 !req ##1 !grant;
        endproperty
*/


//Question 17: Request must true at the current cycle; grant must become true sometime 
//			   between 1 cycle after request and the end of time?

//Ans	:
/*
		property p1;
          @(posedge clk)
          disable iff(!rst)
          req ##[1:$] grant;
        endproperty
*/


//Question 18:Req must eventually be followed by ack, which must be followed 1 cycle 
//			  later by done?

//Ans	:
/*
		property p1;
          @(posedge clk)
          req ##1 ack;
          //or $rose(req) ##[1:$] ack;
        endproperty
*/


//Question 19: The active-low reset must be low for at least 6 clock cycles?

//Ans	:
/*
		property p1;
          @(posedge clk)
          !rst[*6:$];
          //or !rst[*6];
        endproperty
*/


//Question 20: Enable must remain true throughout the entire ack to done sequence?

//Ans	:
/*
		property p1;
          @(posedge clk)
          disable iff(!rst);
          enable throughout (ack ##[1:$] done);
        endproperty
*/


//Question 21: Write an assertion for glitch detection?

//Ans	:
/*
		property p1;
          @(posedge clk)
          clk throughout ($fell(a) && $rise(a));
          //or $fell(en) |=> $stable(data);
        endproperty
*/


//Question 22: If signal_a is active, then signal_b was active 3 cycles ago?

//Ans	:
/*
		property p1;
          @(posedge clk)
          signal_a |-> $past(signal_b,3);
          //or signal_a && $past(signal_b,3);
        endproperty
*/


//Question 23: If the state machine reaches active1 state, it will eventually reach active2 state?

//Ans	:
/*
		property p1;
          @(posedge clk)
          (state == active1) |=> (state == active2);
          //or (state == active1) |=> ##[*] (state == active2)
        endproperty
*/


//Question 24: A high for 5 cycles and B high after 4 continuous highs 
//			   of A and finally both A and B are high?
/*
		property p1;
          @(posedge clk)
          a[*4] ##1 a ##0 b;
          //or a[*4] ##1 (a && b);
          //or ##4 $rose(b) within $rose(a)[*5];
        endproperty
*/


//Question 25: On rose of a, wait for rose of b or c. If b comes first, 
//			   then d should be 1. If c comes first d should be zero?

//Ans:
/*
		property p1;
          @(posedge clk)
          $rose(a) ##[1:$] ($rose(b) or $rose(c)) ->
          if(b)
            d;
          else
            !d;
        endproperty
*/



//Question 26: When signal "d" changes to 1 , on next cycle , if signal "b" is true , then signal "c" should be high continuosly or intermittently for 2 clock cycles, followed by high on signal "a" in the next cycle else the signal "a" should be high continuosly or intermittently for 2 clock cycles, followed by high on signal "c" in the next cycle

//It is like :
//	When signal “d” changes to 1, on next cycle, if signal “b” is true, then signal “c” should be high continuously or intermittently for 2 clock cycles, followed by high on signal “d“ in the next cycle.
//	When signal “d” changes to 1, on next cycle, if signal “b” is low, then signal “a” should be high continuously or intermittently for 2 clock cycles, followed by high on signal “c“ in the next cycle.

//Ans :
/*
		property p1;
          @(posedge clk)
          disable iff(!rst);
          $rose(d) |-> if(b)
            c[->2] ##1 a;
          else
            a[->2] ##1 c;
        endproperty
          
          
*/


//Question 27: If you will get consesutive 2 clk cycles high of a but you have used non-consecutive opperator([=2]) so what will happen? => It will work fine no-proplem

module tb27;
  
  bit a;
  bit clk;
  
  property p1;
    //@(posedge clk) a[*2];  consecutive 2 clock cycles
    @(posedge clk) a[=2];   //non-consecutive 2 clk cycles
  endproperty
  
  assert property(p1);
    
  initial begin
    $monitor($time,"a=%0b",a);
    a=0;
    @(posedge clk);
    a=1;
    @(posedge clk);
    a=1;
    @(posedge clk);
    a=0;
    @(posedge clk);
    #10;
    $finish;
  end
    
  initial begin
    $dumpfile("dump27.vcd");
    $dumpvars(0);
  end
    
  always #5 clk=~clk;
    
endmodule
