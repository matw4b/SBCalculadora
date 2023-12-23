;Exponenciação				Exp.asm
;
;

section .text

%define	reg1	ax
%define	reg2	bx
%define	reg3	cx
%define	reg4	dx
%define	r_size	4 ; regs de 16 bits contém 2 bytes

%macro PrintSTR 2
	push %1 ; msg
	push %2 ; tamanho
	call print_msg
	add esp, 8 ; desempilha
%endmacro

extern operation_msg, operation_size, new_line, new_line_size, result_msg, result_size, overflow_msg, overflow_size
extern	print_msg, scanner, get_number, print_number, exit
extern b_msg, b_size, exp_msg, exp_size, div_msg, div_size

global exp

;o expoente TEM que ser maior ou igual a zero!
exp:	enter	r_size, 0 ; frame de pilha reservando um inteiro local
		
		PrintSTR b_msg, b_size ; exibe a mensagem para digitar o primeiro operando
		call	get_number ; pega a base e coloca em reg1
		mov		reg2, reg1 ; usa reg2 como um temporario
		PrintSTR exp_msg, exp_size
		call	get_number ; pega o expoente
		mov		[ebp-r_size], reg1; coloca o expoente como variavel local
		mov		reg1, 1 ; coloca o reg1 = 1 como se fosse a base elevada a 0
		mov		reg3, 0 ; o contador deve ter o mesmo valor do expoente ao final do loop
		
		loop:
			cmp		reg3, [ebp-r_size]
			jge		result
			imul	reg2
			jo		of
			inc		reg3
			jmp		loop
			
		result:
			PrintSTR result_msg, result_size
			push	reg1 ; empilha o resultado para fazer o print
			call	print_number
			leave
			ret
			
of:		PrintSTR overflow_msg, overflow_size
		jmp		exit