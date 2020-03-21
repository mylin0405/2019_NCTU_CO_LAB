module Simple_Single_CPU( clk_i, rst_n );

//I/O port
input         clk_i;
input         rst_n;

//Internal Signals
wire [32-1:0] pc_now , pc_plus_4 , pc_after_Branch , pc_after, program_x_jump , program_simply_Jump , Memory_o , write_back_reg ,instr ; 
wire [5-1:0]  write_Reg_address ;
wire [32-1:0] rd_Data1, rd_Data2;
wire [3-1:0]  ALU_op ;
wire [4-1:0]  ALU_oper ;
wire [32-1:0] Sign_Extended, Zero_Filling , Addr_or_ALUresult;
wire [5-1:0] shamt ;
wire [32-1:0] ALU_input, ALU_result, Shifter_result;
wire [2-1:0] RegDst_o , MemtoReg_o, FURslt_o , Branch_type;  
wire RegWrite, ALUSrc,  Branch_o, Jump_o, MemRead_o, MemWrite_o, ALU_zero_Branch_o, ALU_zero, Bgez_or_Beq , BGEZ_BEQ;
wire jump_reg ;
assign jump_reg = (instr[31:26] == 6'b111111 && instr[20:0] == 21'd8) ? 1 : 0;
assign PCSrc = ((Branch_o) & (ALU_zero_Branch_o)) ;
assign Bgez_or_Beq = (instr[31:26] == 6'b111011)? 1 : 0 ;
//modules

Program_Counter PC(
        .clk_i(clk_i),      
	    .rst_n(rst_n),     
	    .pc_in_i(pc_after) ,   
	    .pc_out_o(pc_now) 
	    );                                  
	
Adder Adder_Add_4(
        .src1_i(pc_now),     
	    .src2_i(32'd4),
	    .sum_o(pc_plus_4)    
	    );	                                

Adder Adder_Add_Branch_Address(
        .src1_i(pc_plus_4),     
	    .src2_i({Sign_Extended[29:0],2'b00}),
	    .sum_o(pc_after_Branch)    
	    );                                  

Mux2to1 #(.size(1)) BGEZ_or_BEQ(
        .data0_i(~rd_Data1[31]),
        .data1_i(ALU_zero),
        .select_i(Bgez_or_Beq),
        .data_o(BGEZ_BEQ)
        ); 


Mux3to1 #(.size(1)) Branch_type_seletion(
        .data0_i(BGEZ_BEQ),
        .data1_i(~ALU_zero),
		.data2_i(ALU_result[31]),
        .select_i(Branch_type),
        .data_o(ALU_zero_Branch_o)
        );                                  //for bonus part,change Mux2to1 to Mux3to1

Mux2to1 #(.size(32)) Branch_or_not(
        .data0_i(pc_plus_4),
        .data1_i(pc_after_Branch),
        .select_i(PCSrc),
        .data_o(program_x_jump)
        );                                  

Mux2to1 #(.size(32)) Jump_or_not(
        .data0_i(program_x_jump),
        .data1_i({pc_plus_4[31:28], instr[25:0], 2'b00}),
        .select_i(Jump_o),
        .data_o(program_simply_Jump)     
        );                                  

Mux2to1 #(.size(32)) Jump_reg(
        .data0_i(program_simply_Jump),
        .data1_i(rd_Data1),
        .select_i(jump_reg),
        .data_o(pc_after)     
        );                                  //for bonus part, add a bonus Mux2to1 for choosing "simply jump" or "jump reg",
                                            //OK
		
Decoder Decoder(
        .instr_op_i(instr[31:26]), 
	    .RegWrite_o(RegWrite), 
	    .ALUOp_o(ALU_op),   
	    .ALUSrc_o(ALUSrc),   
	    .RegDst_o(RegDst_o),
        .Branch_type(Branch_type),
        .Branch_o(Branch_o),
        .Jump_o(Jump_o),
        .MemRead_o(MemRead_o),
        .MemWrite_o(MemWrite_o),
        .MemtoReg_o(MemtoReg_o)		
		);	                                
		
Instr_Memory IM(
        .pc_addr_i(pc_now),  
	    .instr_o(instr)    
	    );                                  

Mux3to1 #(.size(5)) Mux_Write_Reg(
        .data0_i(instr[20:16]),
        .data1_i(instr[15:11]),
        .data2_i(5'd31),
		.select_i(RegDst_o),
        .data_o(write_Reg_address)
        );	                                //Change Mux2to1 to Mux3to1 for "RegDst"
		

Reg_File RF(
        .clk_i(clk_i),      
	    .rst_n(rst_n) ,     
        .RSaddr_i(instr[25:21]) ,  
        .RTaddr_i(instr[20:16]) ,  
        .RDaddr_i(write_Reg_address) ,  
        .RDdata_i(write_back_reg)  , 
        .RegWrite_i(RegWrite& (~jump_reg)),          //If "jump_reg" occurs,we need to disable "RegWrite"
        .RSdata_o(rd_Data1) ,  
        .RTdata_o(rd_Data2)   
        );                                  
	
ALU_Ctrl AC(
        .funct_i(instr[5:0]),   
        .ALUOp_i(ALU_op),   
        .ALU_operation_o(ALU_oper),
		.FURslt_o(FURslt_o)
        );
	
Sign_Extend SE(
        .data_i(instr[15:0]),
        .data_o(Sign_Extended)
        );

Zero_Filled ZF(
        .data_i(instr[15:0]),
        .data_o(Zero_Filling)
        );
		
Mux2to1 #(.size(32)) ALU_src2Src(
        .data0_i(rd_Data2),
        .data1_i(Sign_Extended),
        .select_i(ALUSrc),
        .data_o(ALU_input)
        );	
		
alu alu(
		.rst_n(rst_n) ,
		.src1(rd_Data1),
	    .src2(ALU_input),
	    .ALU_control(ALU_oper),
		.result(ALU_result),
		.zero(ALU_zero),
		.overflow()
	    );

Mux2to1 #(.size(5)) Mux_For_SRLV_SLLV(
        .data0_i(instr[10:6]),
        .data1_i(rd_Data1),
        .select_i(ALU_oper[1]),
        .data_o(shamt)
        );                                         //bonus part from Lab2
		
Shifter shifter( 
		.result(Shifter_result), 
		.leftRight(ALU_oper[0]),
		.shamt(shamt),
		.sftSrc(ALU_input) 
		);
		
Mux3to1 #(.size(32)) RDdata_Source(
        .data0_i(ALU_result),
        .data1_i(Shifter_result),
		.data2_i(Zero_Filling),
        .select_i(FURslt_o),
        .data_o(Addr_or_ALUresult)
        );			                                 
                           
Data_Memory DM(
         .clk_i(clk_i),
		 .addr_i(Addr_or_ALUresult),
		 .data_i(rd_Data2),
		 .MemRead_i(MemRead_o),
		 .MemWrite_i(MemWrite_o),
         .data_o(Memory_o)
		 );                                          

Mux3to1 #(.size(32)) MemtoReg(
        .data0_i(Addr_or_ALUresult),
        .data1_i(Memory_o),
		.data2_i(pc_plus_4),
        .select_i(MemtoReg_o),
        .data_o(write_back_reg)     
        );                                           //for bonus part, change Mux2to1 to Mux3to1 
		                
endmodule



