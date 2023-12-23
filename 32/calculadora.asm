;Calculator			calculadora.asm
;	
;	
;	

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
						db "- 5: EXPONENCIACAO", 0ah, 0dh
                      	db "- 6: MOD", 0ah, 0dh,
                      	db "- 7: SAIR", 0ah, 0dh

	menu_message_size     equ $-menu_message
	
	option_message		db "SUA ESCOLHA: ", 0h
	option_size			equ $-option_message
	
	operation_msg		db "INSIRA UM NUMERO: ", 0h
	operation_size		equ $-operation_msg
	
	result_msg			db "RESULTADO: ", 0h
	result_size			equ $-result_msg
	
	enter_msg			db "PRESSIONE ENTER: ", 0h
	enter_size			equ $-enter_msg
	
	overflow_msg		db "OCORREU OVERFLOW!", 0ah, 0dh
	overflow_size		equ $-overflow_msg
	
	b_msg				db "BASE: ", 0h
	b_size				equ $-b_msg
	
	exp_msg				db "EXPOENTE: ", 0h
	exp_size			equ $-exp_msg
	
	div_msg				db "DIVISOR: ", 0h
	div_size			equ $-div_msg

section .bss
	name		resb 100
	choice		resb 3
	
section .text

extern soma, sub, mul, div, exp, mod
global exit, operation_msg, operation_size, new_line, new_line_size, result_msg, result_size, overflow_msg, overflow_size
global print_msg, scanner, get_number, print_number
global b_msg, b_size, exp_msg, exp_size, div_msg, div_size

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
			
			; testes de get e print.
			;PrintSTR operation_msg, operation_size
			;call	get_number
			;push	eax
			;call	print_number
			;add		esp, 4
			
			sub		byte [choice], 30h ; converte a escolha de char pra inteiro
			cmp		byte [choice], 1
			je		op1
			cmp		byte [choice], 2
			je		op2
			cmp		byte [choice], 3
			je		op3
			cmp		byte [choice], 4
			je		op4			
			cmp		byte [choice], 5
			je		op5
			cmp		byte [choice], 6
			je		op6 ;saltos para chamar as operações da calculadora
			
			
exit:		mov		eax, 1
			mov		ebx, 0
			int 	80h; avisa ao SO que o programa encerrou
			
			
			
			
			
op1:		call	soma
			PrintSTR new_line, new_line_size
			PrintSTR enter_msg, enter_size
			LeituraSTR choice, choice_size
			PrintSTR new_line, new_line_size
			jmp		menu
			
op2:		call	sub
			PrintSTR new_line, new_line_size
			PrintSTR enter_msg, enter_size
			LeituraSTR choice, choice_size
			PrintSTR new_line, new_line_size
			jmp		menu
			
			
op3:		call	mul
			PrintSTR new_line, new_line_size
			PrintSTR enter_msg, enter_size
			LeituraSTR choice, choice_size
			PrintSTR new_line, new_line_size
			jmp		menu
			
op4:		call	div
			PrintSTR new_line, new_line_size
			PrintSTR enter_msg, enter_size
			LeituraSTR choice, choice_size
			PrintSTR new_line, new_line_size
			jmp		menu
			
op5:		call	exp
			PrintSTR new_line, new_line_size
			PrintSTR enter_msg, enter_size
			LeituraSTR choice, choice_size
			PrintSTR new_line, new_line_size
			jmp		menu
			
op6:		call	mod
			PrintSTR new_line, new_line_size
			PrintSTR enter_msg, enter_size
			LeituraSTR choice, choice_size
			PrintSTR new_line, new_line_size
			jmp		menu
			
			
			
;parametros da print_msg: ponteiro da string, tamanho da string	
print_msg:	enter 	0,0	; frame da pilha

			push	eax
			push	ebx
			push	ecx
			push	edx ; salva os regs
			
			mov		eax, 4 ; syscall de escrita
			mov		ebx, 1 ; saida padrao (tela)
			mov		ecx, [ebp+12] ;	ponteiro da string (primeiro parametro passado)
			mov		edx, [ebp+8] ; tamanho da string (segundo parametro)
			int 	80h		; exibe a mensagem
			
			pop		edx
			pop		ecx
			pop		ebx
			pop		eax ; devolve os valores dos regs
			
			leave	; apaga o frame de pilha
			ret	; retorna
			
;funcao de leitura, parametros: ponteiro da string, tamanho da string
scanner:	enter 	0,0	; frame da pilha

			push	esi
			push	eax
			push	ebx
			push	ecx
			push	edx ; salva os regs
			
			mov		eax, 3 ; syscall de leitura
			mov		ebx, 0 ; entrada padrao (teclado)
			mov		ecx, [ebp+12] ;	ponteiro da string (primeiro parametro passado)
			mov		edx, [ebp+8] ; tamanho da string (segundo parametro)
			int 	80h		; faz a leitura
			
			sub		esi, esi; zera o ESI para utilizar ele como indice da string
			
	percorre:
			mov		ebx, [ebp+12]; ebx vira ponteiro da string
			mov		ebx, [ebx+esi]; ebx aponta para a letra atual da string
			
			cmp		esi, [ebp+8]; verifica se chegou ao final da string. é a checagem inicial do for
			je		done
			
			cmp		ebx, 0ah; compara se o caractere atual é o lf
			je		apaga_nl
			inc		esi
			jne		percorre
			
	apaga_nl:
			mov		ebx, [ebp+12]; ebx vira ponteiro da string
			mov 	byte [ebx+esi], 0h
			mov 	byte [ebx+esi+1], 0h; substitui o cr lf por null
			
	done:				
			pop		edx
			pop		ecx
			pop		ebx
			pop		eax ; devolve os valores dos regs
			pop		esi
			
			leave	; apaga o frame de pilha
			ret	; retorna			

; funcao que retorna um inteiro de 32 bits em EAX			
get_number:
			enter	0,0; frame da pilha
			
			push	esi ;[ebp-4]
			push	ebx ;[ebp-8]
			push	ecx ;[ebp-12]
			push	edx ;[ebp-16]
			; salva os regs

			sub		esp, 12; aloca espaço na pilha para a variável local, que é a string do número a ser lido
			; a string do numero pode conter 10 digitos mais um sinal e um enter, portanto a string dele pode ter no maximo 12 bytes quando em 32 bits
			
			mov		eax, 3 ; syscall de leitura
			mov		ebx, 0 ; entrada padrao (teclado)
			mov		ecx, esp ;	ponteiro do número
			mov		edx, 12 ; são os 12 possíveis caracteres da string (10 dígitos + sinal + fim de string)
			int 	80h	; faz a leitura
			
			xor		esi, esi ; usado como indice da string
			xor		ecx, ecx
			xor		eax, eax ; zera os registradores
			mov		edx, 10 ; a constante 10 que multiplica para formar o numero
			mov		ebx, esp ; ponteiro de onde está a string do numero em ebx

	conversao:; converte uma string de dígitos em um número
			mov		cl, 0ah
			cmp		cl, [ebx+esi]; verifica se acabou a string do numero
			je		negativo
			
			push	eax
			shl		eax, 3
			add		eax, [esp]
			add		eax, [esp] ; multiplica eax por 10 (primeiro multiplica por 8 e depois soma duas vezes, daí é o mesmo que multiplicar por 10)
			add		esp, 4 ; retira o eax da pilha (push decrementa esp em 4)
			
			mov		cl, 0x2d
			cmp		cl, [ebx + esi]; verifica se o caractere atual é "-", se for, ignora e avança a string
			je		avanca

			xor		ecx, ecx
			mov		cl, [ebx + esi]
			sub		ecx, 30h; converte o caractere a um número
			add		eax, ecx; junta os dígitos percorridos

		avanca:
			inc		esi
			jmp		conversao

		negativo:	
			mov		cl, 0x2d
			cmp		byte cl, [ebx]; verifica se é necessário negativar o valor calculado checando o primeiro byte da string
			jne		fim
			neg		eax ; faz o complemento de 2 do número, negativando o seu valor absoluto
			
		fim:
			add		esp, 12 ; desaloca os 12 bytes de digito do numero
			
			pop		edx
			pop		ecx
			pop		ebx
			pop		esi ; devolve o valor original dos regs
			
			leave
			ret

;exibe um valor de 32 bits com sinal. exige um parametro na pilha e retorna a string em EAX
;possui o número a ser convertido em string como parametro na pilha
print_number:
			enter	0,0 ;frame da pilha
			
			push	eax
			push	ebx
			push	ecx
			push	edx; salva os regs utilizados
			push	esi
			
			mov		reg2, 0
			push	reg2 ; empilha o indicador de fim da string
			mov		esi, r_size ; indica a quantidade de caracteres que a string do número tem (o tamanho da string!)
			
			mov		reg1, [ebp+8] ; coloca o número de 32 bits a ser convertido em eax
			mov		reg3, 10 ; constante 10 para dividir e ir separando os digitos
			
			;ignore as instruções comentadas
			;cmp		reg1, 0
			;jge		convert_loop ; se for positivo, vai para o loop de conversão
			
			;neg		reg1 ; faz o complemento de 2 e torna positivo
			
		convert_loop:
			add		esi, r_size
			cdq ; trocar para cwd na versao de 16/ extende o sinal de eax para edx
			idiv	reg3 ; divide eax por ecx e joga o resto em edx
			cmp		reg4, 0 ;testa se o resto da divisão é negativo
			jge		ready
			neg		reg4 ; se o resto é negativo, pegamos o seu valor absoluto
			
			ready:
				add		reg4, 30h ; converte o dígito em string
				push	reg4 ; empilha o digito
				cmp		reg1, 0
				jne		convert_loop ; faz isso até eax ser 0, ou seja, não ter mais dígitos
			
			cmp		dword [ebp+8], 0
			jge		print_string ; verifica se o número é negativo, caso não seja, já está pronto para fazer o print
			
			push	0x2d ; adiciona o sinal caso o número seja negativo
			add		esi, r_size ; adiciona o espaço do sinal
			
		print_string:
			PrintSTR esp, esi ; chama a função de print entregando o ponteiro da váriavel local que armazena os dígitos.
			
		pop_local_stack: ; desempilha todos os dígitos do número e o 0 de final de string
			sub		esi, r_size
			pop		reg4 ; desempilha os dígitos
			cmp		esi, 0
			jne		pop_local_stack
			
			pop		esi
			pop		edx
			pop		ecx
			pop		ebx
			pop		eax
			
			leave ; desfaz o frame da pilha
			ret
			
			
			
			
			
			
			
			