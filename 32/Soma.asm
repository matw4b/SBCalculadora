;Soma				Soma.asm
;
;

section .text

%define	reg1	eax
%define	reg2	ebx
%define	reg3	ecx
%define	reg4	edx
%define	r_size	4 ; regs de 32 bits contem 4 bytes

%macro PrintSTR 2
	push %1 ; msg
	push %2 ; tamanho
	call print_msg
	add esp, 8 ; desempilha
%endmacro

extern operation_msg, operation_size, new_line, new_line_size, result_msg, result_size
extern	print_msg, scanner, get_number, print_number

global soma

soma:	
		enter r_size, 0 ; frame de pilha e reserva um inteiro local
		
		PrintSTR operation_msg, operation_size ; exibe a mensagem para digitar o primeiro operando
		call	get_number ; pega o número digitado e coloca em reg1
		mov		[ebp-r_size], reg1 ; guarda o valor lido na variável local
		PrintSTR operation_msg, operation_size ; exibe a mensagem para digitar o segundo operando
		call	get_number
		add		[ebp-r_size], reg1 ; faz a soma
		PrintSTR result_msg, result_size
		call	print_number ; como o resultado já está no topo da pilha, bastou chamar a função
		
		leave
		ret