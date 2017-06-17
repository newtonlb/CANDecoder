`timescale 1ns / 1ps


module testbench;

	reg sample;
	reg can_data;
	wire data_frame;
	wire getframe;
	wire [10:0] bit_id_11;
	wire [28:0] bit_id_29;
	wire [1:0] srr_rtr_ide;
	wire ext_frame;
	wire std_frame;
	wire rtr_ext;
	wire remote_frame;
	wire [3:0] data_size;
	

	reg [9:0] contador=1;
	//frame de dados 11 bits 4 bytes de dados
	//reg [23:0] mensagem = {5'b11111, 1'b0, 11'h551, 3'b000, 4'b0100};
	//frame remote reqest 11 bits/
	//reg [18:0] mensagem = {5'b11111, 1'b0, 11'h551, 2'b10};
	//data frame extended frame
	reg [40:0] mensagem = {2'b11, 1'b0, 11'h552, 2'b11, 18'h8320, 3'b000, 4'b1000};
	
   
	//remote request extended frame
	//reg [35:0] mensagem = {2'b11, 1'b0, 11'h552, 2'b11, 18'h8320, 2'b10};
	//frame_builder f(.*);
	//logic A, clk;
	//logic [127:0]buffer;
	//logic [0:71]frame = 72'b100000100101000001000100000100101000011000001001011111111110000000001111; // frame de dados normal
	//logic [0:78] frame = 79'b1000001001010011101010101010101010000010010000010010100001100000100101111111111; // frame de dados extendido
	
	wire [10:0] frame_id_a;
	
	teste2 t(
	.can_data(can_data), 
	.sample(sample),
	.bit_id_11(bit_id_11),
	.bit_id_29(bit_id_29),
	.srr_rtr_ide(srr_rtr_ide),
	.data_frame(data_frame),
	.getframe(getframe),
	.ext_frame(ext_frame),
	.std_frame(std_frame),
	.rtr_ext(rtr_ext),
	.remote_frame(remote_frame),
	.data_size(data_size)
	);
	
	always begin
		sample = 1;
		can_data = mensagem[41-contador];
		$display(" enviando bit: %h", can_data);
		#1 //10nsec
		sample = 0;
		contador = contador + 1;
		#1;
	end
	always@(posedge getframe)
	begin
		if(std_frame)
		begin
			$display("frame de can normal");
			if (data_frame)
			begin
				$display("                                            ");
				$display("frame de dados ID [11-bits] da mensagem: %h" , bit_id_11);
				$display("tamanho do dado: %d", 8*data_size);
			end
			if(remote_frame)
			begin
				$display("                                            ");
				$display("frame remote request ID [11-bits] da mensagem: %h" , bit_id_11);
			end
		end

		else if (ext_frame)
		begin
			$display("can frame estendido");
			if (data_frame)
			begin
				$display("                                            ");
				$display("frame de dados ID [11-bits] da mensagem: %h" , bit_id_29);
				$display("tamanho do dado: %d", data_size);
			end
			if(remote_frame)
			begin
				$display("                                            ");
				$display("frame remote request ID [11-bits] da mensagem: %h" , bit_id_29);
			end
		end
	end


	initial begin
	
	end

		
endmodule
