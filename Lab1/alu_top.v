`timescale 1ns/1ps

//////////////////////////////////////////////////////////////////////////////////
// 0616058_0617052
// Company: 
// Engineer: 
// 
// Create Date:    15:15:11 03/21/2019
// Design Name: 
// Module Name:    alu_top 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////

module alu_top(
               src1,       //1 bit source 1 (input)
               src2,       //1 bit source 2 (input)
               less,       //1 bit less     (input)
               A_invert,   //1 bit A_invert (input)
               B_invert,   //1 bit B_invert (input)
               cin,        //1 bit carry in (input)
               operation,  //operation      (input)
               result,     //1 bit result   (output)
               cout,       //1 bit carry out(output)
               );

input         src1;
input         src2;
input         less;
input         A_invert;
input         B_invert;
input         cin;
input [2-1:0] operation;

output        result;
output        cout;

reg           result;
reg	      cout;			  
reg 	      sr1;
reg	      sr2;	

always@( * )
begin

sr1 = src1 ^ A_invert;  
sr2 = src2 ^ B_invert;
		
	case(operation)
		2'b00:  begin           //and    
			result = sr1 & sr2;				 
			cout = 0 ; end
			
		2'b01:	begin			//or					
			result = sr1 | sr2;				
			cout = 0; end
			
		2'b10: 	begin			//fulladder
			result = sr1 ^ sr2 ^ cin;		
			cout = (sr1 & sr2) | (sr1 & cin) | (sr2 & cin); end
			
		2'b11:	begin			//set less to result
			result = less ;                  
			cout = (sr1 & sr2) | (sr1 & cin) | (sr2 & cin); end
		
		endcase
	
end
		  
endmodule
