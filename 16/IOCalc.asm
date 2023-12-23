; Input and output		IOCalc.asm
;
;
;

%define	reg1	ax
%define	reg2	bx
%define	reg3	cx
%define	reg4	dx
%define	r_size	2 ; regs de 32 bits contem 4 bytes

%macro PrintSTR 2
	push %1 ; msg
	push %2 ; tamanho
	call print_msg
	add esp, 8 ; desempilha
%endmacro

section .text

global print_msg, scanner, get_number, print_number


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

			sub		esp, 7; aloca espaço na pilha para a variável local, que é a string do número a ser lido
			; a string do número pode conter 5 digitos mais um sinal e um enter, portanto a string dele pode ter no maximo 7 bytes quando em 16 bits
			
			mov		eax, 3 ; syscall de leitura
			mov		ebx, 0 ; entrada padrao (teclado)
			mov		ecx, esp ;	ponteiro do número
			mov		edx, 7 ; são os 7 possíveis caracteres da string (5 dígitos + sinal + fim de string)
			int 	80h	; faz a leitura
			
			xor		esi, esi ; usado como indice da string
			xor		reg3, reg3
			xor		reg1, reg1 ; zera os registradores
			mov		reg4, 10 ; a constante 10 que multiplica para formar o numero
			mov		ebx, esp ; ponteiro de onde está a string do numero em ebx

	conversao:; converte uma string de dígitos em um número
			mov		cl, 0ah
			cmp		cl, [ebx+esi]; verifica se acabou a string do numero
			je		negativo
			
			push	reg1
			shl		reg1, 3
			add		reg1, [esp]
			add		reg1, [esp] ; multiplica eax por 10 (primeiro multiplica por 8 e depois soma duas vezes, daí é o mesmo que multiplicar por 10)
			add		esp, r_size ; retira o ax da pilha (push decrementa esp em 2 quando usando ax)
			
			mov		cl, 0x2d
			cmp		cl, [ebx + esi]; verifica se o caractere atual é "-", se for, ignora e avança a string
			je		avanca

			xor		reg3, reg3
			mov		cl, [ebx + esi]
			sub		reg3, 30h; converte o caractere a um número
			add		reg1, reg3; junta os dígitos percorridos

		avanca:
			inc		esi
			jmp		conversao

		negativo:	
			mov		cl, 0x2d
			cmp		byte cl, [ebx]; verifica se é necessário negativar o valor calculado checando o primeiro byte da string
			jne		fim
			neg		reg1 ; faz o complemento de 2 do número, negativando o seu valor absoluto
			
		fim:
			add		esp, 7 ; desaloca os 7 bytes de digito do numero
			
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
			
			;ignore essas instruções comentadas. são ideias descartadas
			;cmp		reg1, 0
			;jge		convert_loop ; se for positivo, vai para o loop de conversão
			
			;neg reg1 ; faz o complemento de 2 e torna positivo
			
		convert_loop:
			add		esi, r_size
			cwd ; trocar para cwd na versao de 16/ extende o sinal de eax para edx
			idiv	reg3 ; divide eax por ecx e joga o resto em edx
			cmp		reg4, 0 ;testa se o resto da divisão é negativo
			jge		ready
			neg		reg4 ; se o resto é negativo, pegamos o seu valor absoluto
			
			ready:
				add		reg4, 30h ; converte o dígito em string
				push	reg4 ; empilha o digito
				cmp		reg1, 0
				jne		convert_loop ; faz isso até eax ser 0, ou seja, não ter mais dígitos
			
			cmp		word [ebp+8], 0
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





















