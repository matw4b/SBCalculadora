;Calculator			calculadora.asm
;	
;	
;	

%macro PrintSTR 2
	push %1 ; msg
	push %2 ; tamanho
	call print_msg
	add esp, 8 ; desempilha
%endmacro

%macro LeituraSTR 2
	push %1 ; ponteiro do var global
	push %2 ; tamanho
	call scanner
	add esp, 8 ; desempilha
%endmacro

section .data
	welcome1			db "Bem-vindo. Digite seu nome:", 0dh, 0ah
	welcome1_size		equ $-welcome1 ; tamanho da mensagem 1
	
	welcome2			db "Hola, ", 0h
	welcome2_size		equ $-welcome2 ; tamanho da mensagem 2
	
	welcome3			db ", bem vindo ao programa de CALC IA-32", 0dh, 0ah
	welcome3_size		equ $-welcome3 ; tamanho da mensagem 3
	
	new_line			db 0dh, 0ah, 0h ; caractere de quebra de linha
	new_line_size		equ $-new_line
	
	name_size			equ 100
	choice_size			equ 3 ; 3 bytes, 1 para o digito, os outros 2 para o cr+lf
	
	menu_message        db "ESCOLHA UMA OPÇÃO:", 0ah, 0dh,
                      	db "- 1: SOMA", 0ah, 0dh,
                      	db "- 2: SUBSTRAÇÃO", 0ah, 0dh,
                      	db "- 3: MULTIPLICAÇÃO", 0ah, 0dh,
                      	db "- 4: DIVISÂO", 0ah, 0dh,
						db "- 5: EXPONENCIACAO"
                      	db "- 6: MOD", 0ah, 0dh,
                      	db "- 7: SAIR", 0ah, 0dh

	menu_message_size     equ $-menu_message
	
	option_message		db "SUA ESCOLHA: "
	option_size			equ $-option_message
	
	operation_msg		db "INSIRA UM NUMERO: "
	operation_size		equ $-operation_msg

section .bss
	name		resb 100
	choice		resb 3
	
section .text

extern	print_msg, scanner, get_number, print_number
global operation_msg, operation_size, new_line, new_line_size

global _start

_start:		PrintSTR welcome1, welcome1_size
			LeituraSTR name, name_size
			PrintSTR welcome2, welcome2_size
			PrintSTR name, name_size
			PrintSTR welcome3, welcome3_size
			PrintSTR new_line, new_line_size
			
			
menu:		PrintSTR menu_message, menu_message_size
			PrintSTR option_message, option_size
			LeituraSTR choice, choice_size
			PrintSTR operation_msg, operation_size
			call	get_number
			push	ax
			call	print_number
			add		esp, 2
			
			
exit:		mov		eax, 1
			mov		ebx, 0
			int 	80h; avisa ao SO que o programa encerrou
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			