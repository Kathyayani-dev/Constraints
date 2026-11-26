# code for Constraints
  ...
  class example_constraint;
        rand bit [3:0]AWLEN;
        rand bit [2:0]AWSIZE;
        rand bit [1023:0]WDATA[][];

        constraint c1{
                WDATA.size()==AWLEN+1;
        }

        constraint c2{
                foreach(WDATA[i]){
                        WDATA[i].size() == (2 ** AWSIZE);

                foreach(WDATA[i][j])
                        WDATA[i][j] >> (8 * (2 ** AWSIZE)) == 0;
                }
        }

        constraint c3{
                AWSIZE inside{[0:2]};
        }
endclass

module tb;

    example_constraint ex;

    initial begin

        ex = new();

        // Give specific values
       /* ex.AWLEN  = 0;
        ex.AWSIZE = 5;*/

repeat(20)
begin
        if(ex.randomize())
            $display("Randomization successful");
        else
            $display("Randomization failed");

        $display("AWLEN  = %0d", ex.AWLEN);
        $display("AWSIZE = %0d", ex.AWSIZE);
        $display("Number of WDATA beats = %0d", ex.WDATA.size());
        $display("Bytes per WDATA beat  = %0d", ex.WDATA[0].size());


        foreach (ex.WDATA[i]) begin

            $display("WDATA[%0d] size = %0d",
                     i, ex.WDATA[i].size());

            foreach (ex.WDATA[i][j])
                $display("WDATA[%0d][%0d] = %0h",
                         i, j, ex.WDATA[i][j]);

        end

end

    end

endmodule
...
