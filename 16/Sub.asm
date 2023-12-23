;Subtração				Sub.asm
;
;

section .text

%define	reg1	ax
%define	reg2	bx
%define	reg3	cx
%define	reg4	dx
%define	r_size	2 ; regs de 16 bits contém 2 bytes

%macro PrintSTR 2
	push %1 ; msg
	push %2 ; tamanho
	call print_msg
	add esp, 8 ; desempilha
%endmacro

extern operation_msg, operation_size, new_line, new_line_size, result_msg, result_size
extern	print_msg, scanner, get_number, print_number

global sub

;faz a operação de subtração, operando1 - operando2
sub:	enter	r_size, 0 ; frame de pilha reservando um inteiro local
		
		PrintSTR operation_msg, operation_size ; exibe a mensagem para digitar o primeiro operando
		call	get_number ; pega o número digitado e coloca em reg1
		mov		[ebp-r_size], reg1 ; guarda o valor lido na variável local
		PrintSTR operation_msg, operation_size ; exibe a mensagem para digitar o segundo operando
		call	get_number
		sub		[ebp-r_size], reg1 ; faz a subtração
		PrintSTR result_msg, result_size
		call	print_number ; como o resultado já está no topo da pilha, bastou chamar a função
		
		leave
		ret