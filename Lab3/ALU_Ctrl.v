module ALU_Ctrl( funct_i, ALUOp_i, ALU_operation_o, FURslt_o );

//I/O ports 
input      [6-1:0] funct_i;
input      [3-1:0] ALUOp_i;

output     [4-1:0] ALU_operation_o;  
output     [2-1:0] FURslt_o;
     
//Internal Signals
reg		[4-1:0] ALU_operation_o;
reg	    [2-1:0] FURslt_o;


//Main function
/*your code here*/
			  
always@(*)begin
    case(ALUOp_i)
    
	3'b010: 
	    	if(funct_i==6'b010010)begin // ADD 
			ALU_operation_o <= 4'b0010 ;
			FURslt_o <= 0 ;
		end

		else if(funct_i==6'b010000)begin //SUB
			ALU_operation_o <= 4'b0110 ;
			FURslt_o <= 0 ;
		end

		else if(funct_i==6'b010100)begin // AND
			ALU_operation_o <= 4'b0000 ;
			FURslt_o <= 0 ;
		end

		else if(funct_i==6'b010110)begin // OR
			ALU_operation_o <= 4'b0001 ;
			FURslt_o <= 0 ;
		end

		else if(funct_i==6'b010101)begin // NOR
            	ALU_operation_o <= 4'b1100 ;
            	FURslt_o <= 0 ;
		end
	
        else if(funct_i==6'b100000)begin // SLT
           		ALU_operation_o <= 4'b0111 ;
            	FURslt_o <= 0 ;
 		end

        else if(funct_i==6'b000000)begin // SLL
            	ALU_operation_o <= 4'b0001 ;
            	FURslt_o <= 1 ;
		end

	 	else if(funct_i==6'b000010)begin // SRL
		        ALU_operation_o <= 4'b0000 ;
		        FURslt_o <= 1 ;
		end
		
		else if(funct_i==6'b000110)begin // SLLV
		    	ALU_operation_o <= 4'b0011 ;
			    FURslt_o <= 1 ;
	    	end

		else if(funct_i==6'b000100)begin // SRLV
            		ALU_operation_o <= 4'b0010 ;
            		FURslt_o <= 1 ;						
		end
 
    3'b100 :begin  // ADDI
        ALU_operation_o <= 4'b0010 ;
 		FURslt_o <= 0 ;
      end
	
	3'b101 :begin // LUI
		FURslt_o <= 2 ;
	  end
	 
    3'b001 :begin // BEQ
	    ALU_operation_o <=  4'b0110 ; 
      end
	
	3'b110 :begin //BNE,......
	    ALU_operation_o <=  4'b0110 ; 
      end
	
	3'b000 :begin // LW,SW
	    ALU_operation_o <=  4'b0010 ;
		FURslt_o <= 0 ;
	  end	
	endcase	    
end

			
endmodule     
