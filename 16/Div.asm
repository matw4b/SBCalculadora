;Divisão				Div.asm
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

extern operation_msg, operation_size, new_line, new_line_size, result_msg, result_size, overflow_msg, overflow_size
extern	print_msg, scanner, get_number, print_number, exit
extern b_msg, b_size, exp_msg, exp_size, div_msg, div_size

global div

;n2 divisor, n1 dividendo
div:	enter	r_size, 0 ; frame de pilha reservando um inteiro local
		
		PrintSTR operation_msg, operation_size ; pede pelo número a ser dividido
		call	get_number ;
		mov		reg2, reg1 ; usa reg2 como temporário
		PrintSTR div_msg, div_size ; exibe a mensagem para digitar o divisor
		call	get_number ;
		mov		[ebp-r_size], reg1 ; guarda o divisor
		mov		reg1, reg2 ; joga o número a ser dividido no reg1 (eax/ax)
		cwd		;extensao de sinal
		idiv	word [ebp-r_size] ;divide
		PrintSTR result_msg, result_size
		push	reg1 ; empilha o resultado da divisão para fazer o print
		call	print_number
		
		leave
		ret