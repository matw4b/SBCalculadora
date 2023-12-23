;Multiplicação				Mul.asm
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

global mul

mul:	enter	r_size, 0 ; frame de pilha reservando um inteiro local
		
		PrintSTR operation_msg, operation_size ; exibe a mensagem para digitar o primeiro operando
		call	get_number ; pega o número digitado e coloca em reg1
		mov		[ebp-r_size], reg1 ; guarda o valor lido na variável local
		PrintSTR operation_msg, operation_size ; exibe a mensagem para digitar o segundo operando
		call	get_number
		imul	word [ebp-r_size]
		jo		of
		PrintSTR result_msg, result_size
		push	reg1
		call	print_number
		
		leave
		ret
		
of:		PrintSTR overflow_msg, overflow_size
		jmp		exit