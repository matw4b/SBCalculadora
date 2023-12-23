;Módulo				mod.asm
;
;

section .text

%define	reg1	eax
%define	reg2	ebx
%define	reg3	ecx
%define	reg4	edx
%define	r_size	4 ; regs de 32 bits contém 4 bytes

%macro PrintSTR 2
	push %1 ; msg
	push %2 ; tamanho
	call print_msg
	add esp, 8 ; desempilha
%endmacro

extern operation_msg, operation_size, new_line, new_line_size, result_msg, result_size, overflow_msg, overflow_size
extern	print_msg, scanner, get_number, print_number, exit
extern b_msg, b_size, exp_msg, exp_size, div_msg, div_size

global mod

;n2 divisor, n1 dividendo
mod:	enter	r_size, 0 ; frame de pilha reservando um inteiro local
		
		PrintSTR operation_msg, operation_size ; pede o número que vai ser didido
		call	get_number ; 
		mov		reg2, reg1 ; usa reg2 como temporário
		PrintSTR div_msg, div_size ; pede o divisor
		call	get_number ;
		mov		[ebp-r_size], reg1 ; guarda o divisor
		mov		reg1, reg2 ; joga o número a ser dividido no reg1 (eax/ax dependendo da precisão)
		cdq		; extensao de sinal
		idiv	dword [ebp-r_size] ;divide
		PrintSTR result_msg, result_size
		push	reg4 ; empilha o módulo da divisão para fazer o print
		call	print_number
		
		leave
		ret