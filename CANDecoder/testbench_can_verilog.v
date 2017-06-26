`timescale 1ns / 1ps


module testbench;

	reg sample;
	reg can_data;
	wire data_frame;
	wire getframe;
	wire [10:0] bit_id_11;
	wire [28:0] bit_id_29;
	wire [1:0] srr_rtr_ide;
	wire [64:0] data_field;
	wire ext_frame;
	wire std_frame;
	wire rtr_ext;
	wire remote_frame;
	wire [3:0] data_size;
	wire [14:0] crc_field;
	wire [1:0] ack_field;
	wire [6:0] end_of_frame;
	wire crc_delimiter;
	wire [5:0] error_flag  = 6'bzzzzzz;
	wire [1:0] previous_frame = 2'bzz;
	wire is_error_frame;
	wire [13:0] error_frame;
	wire error_type;
	wire [13:0] overload_frame;
	wire crc_error;
	wire frame_error;
	wire ack_error;
	wire stuffing_error;
	wire output_error;
	
	

	reg [9:0] contador=1;
	//frame de dados 11 bits 4 bytes de dados
	//reg [24:0] mensagem = {5'b11111, 1'b0, 11'b000001011111, 4'b0000, 4'b0100};
	//frame remote reqest 11 bits/
	//reg [18:0] mensagem = {5'b11111, 1'b0, 11'h551, 2'b10};
	//data frame extended frame
	//reg [40:0] mensagem = {2'b11, 1'b0, 11'h552, 2'b11, 18'h8320, 3'b000, 4'b1000};
	
   
	//remote request extended frame
	//reg [35:0] mensagem = {2'b11, 1'b0, 11'h552, 2'b11, 18'h8320, 2'b10};
//reg [113:0] mensagem = {2'b11, 1'b0, 11'h552, 2'b11, 18'h8320, 2'b10, 4'b0100 ,  32'hABCD1234 , 15'd30322, 3'b101 , 7'b1111111 ,2'b11, 1'b1, 2'b11, 1'b0, 11'h1AF};
	//frame_builder f(.*);
	//logic A, clk;
	//logic [127:0]buffer;
	//reg [71:0] mensagem = 72'b100000100101000001000100000100101000011000001001011111111110000000001111; // frame de dados normal
	//reg [62:0] mensagem = 63'b100000100101001000001101000011000001001011111111110000000001111; // frame de dados normal


	//reg [78:0] mensagem = 79'b1000001001010011101010101010101010000010010000010010100001100000100101111111111; // frame de dados estendido
	//reg [69:0] mensagem = 70'b1000001001010011101010101010101010100000110100001100000100101111111111; // frame de rtr estendido
	//reg [78:0] mensagem = 79'b1000001001010011101010101010101010000010010000010010100001100000100101111111111;
	//reg [70:0] mensagem = 71'b100000100101001110101010101010101010010010100001100000100101111111111; // frame rtr estendido
//reg [85:0] mensagem = {5'b11111, 1'b0, 11'h551, 3'b000, 4'b0100 ,  32'hABCD1234 , 15'd30322, 3'b101 , 7'b1111111 ,5'b11111}; 
	//frame de dados (receiver) + interframe +frame de dados + erro + remote frame
	//reg [232:0] mensagem = {2'b11, 1'b0, 11'h551, 3'b000, 4'b0100 ,  32'hABCD1234 , 15'd30322, 3'b101 , 7'b1111111 ,2'b11, 1'b1, 2'b11, 1'b0, 11'h1AF, 3'b000, 4'b0100, 32'hABCD1234, 15'd09908, 3'b101, 7'b1111111, 3'b111, 2'b11, 1'b0, 6'b000000, 5'b00000, 8'hFF, 3'b111, 1'b0, 11'h0A1, 3'b100, 4'b0011 , 15'h1eed, 3'b101 , 7'b1111111 ,3'b111};	
//remote request + frame de dados + erro + remote request 500ns
	//reg [200:0] mensagem = {2'b11, 1'b0, 11'h0A1, 3'b100, 4'b0100  , 15'd30322, 3'b101 , 7'b1111111 ,2'b11, 1'b1, 2'b11, 1'b0, 11'h1AF, 3'b000, 4'b0100, 32'hABCD1234, 15'd09908, 3'b101, 7'b1111111, 3'b111, 2'b11, 1'b0, 6'b000000, 5'b00000, 8'hFF, 3'b111, 1'b0, 11'h0A1, 3'b100, 4'b0011 , 15'h1eed, 3'b101 , 7'b1111111 ,3'b111};	
	
	reg [246:0] mensagem = {2'b11, 1'b0, 11'h551, 3'b000, 4'b0100 ,  32'hABCD1234 , 15'd30322, 3'b101 , 7'b1111111 ,2'b11, 1'b1, 2'b11, 1'b0, 11'h1AF, 3'b000, 4'b0100, 32'hABCD1234, 15'd09908, 3'b101, 7'b1111111, 3'b111, 2'b11, 1'b0, 6'b000000, 5'b00000, 8'hFF, 6'b000000, 8'hFF, 3'b111, 1'b0, 11'h0A1, 3'b100, 4'b0011 , 15'h1eed, 3'b101 , 7'b1111111 ,3'b111};

//frame de dado + frame remoto + frame de dados
//reg [126:0] mensagem = {2'b11, 1'b0, 11'h551, 3'b000, 4'b0100 ,  32'hABCD1234 , 15'd30322, 3'b101 , 7'b1111111, 2'b11, 1'b0, 11'h0A1, 3'b100, 4'b0100  , 15'd30322, 3'b101 , 7'b1111111, 3'b111};	


wire [10:0] frame_id_a;
	
	teste2 t(
	.can_data(can_data), 
	.sample(sample),
	.bit_id_11(bit_id_11),
	.bit_id_29(bit_id_29),
	.srr_rtr_ide(srr_rtr_ide),
	.data_field(data_field),
	.data_frame(data_frame),
	.getframe(getframe),
	.ext_frame(ext_frame),
	.std_frame(std_frame),
	.rtr_ext(rtr_ext),
	.remote_frame(remote_frame),
	.data_size(data_size),
	.crc_field(crc_field),
	.ack_field(ack_field),
	.end_of_frame(end_of_frame),
	.crc_delimiter(crc_delimiter),
	.error_flag(error_flag),
	.previous_frame(previous_frame),
	.is_error_frame(is_error_frame),
	.error_frame(error_frame),
	.error_type(error_type),
	.overload_frame(overload_frame),
	.crc_error(crc_error),
	.frame_error(frame_error),
	.ack_error(ack_error),
	.stuffing_error(stuffing_error),
	.overload_error(overload_error)

	);
	
	always begin
		sample = 1;
		can_data = mensagem[247-contador];
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
				$display("tamanho do dado: %d", data_size);
			end
			else if(remote_frame)
			begin
				$display("                                            ");
				$display("frame remote request ID [11-bits] da mensagem: %h" , bit_id_11);
			end
			else if (is_error_frame)
			begin
				$display("                                            ");
				$display("error frame ");
				if(error_type)
				begin
					$display("erro ativo");
				end
				else
					$display("erro passivo");
				begin
				end
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
			else if (is_error_frame)
			begin
				$display("                                            ");
				$display("error frame ");
				if(error_type)
				begin
					$display("                                            ");
					$display("erro ativo");
				end
				else
					$display("                                            ");
					$display("erro passivo");
				begin
				end
			end
			else
			begin
				$display("                                            ");
				$display("overload frame");
			end
		end
	end


	initial begin
	
	end

		
endmodule
