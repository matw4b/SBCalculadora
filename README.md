# Trabalho 2
Calculadoras com operações em ponto fixo em IA-32 de precisões de 16 e 32 bits

## Aluno:
Matheus Guaraci Lima Bouças Alves 180046951

## Compilar e ligar os programas de 32bits e 16 bits
> $ nasm -f elf -o calculadora.o calculadora.asm

> $ nasm -f elf -o Soma.o Soma.asm

> $ nasm -f elf -o Sub.o Sub.asm

> $ nasm -f elf -o Mul.o Mul.asm

> $ nasm -f elf -o Div.o Div.asm

> $ nasm -f elf -o Exp.o Exp.asm

> $ nasm -f elf -o Mod.o Mod.asm

> $ ld -m elf_i386 -o calculadora calculadora.o Soma.o Sub.o Mul.o Div.o Exp.o Mod.o

## Aviso:
Os programas possuem os mesmos nomes nos arquivos para manter os mesmos comandos na compilação, portanto o que diferenciam eles são as pastas onde estão localizados, 
os %define que alteram os registradores utilizados, e algummas constantes. Os comentários da versão de 32 bits foram mantidos na de 16 na maior parte do código.

## Aviso2:
A especificação do trabalho diz que a função principal NÃO deve fazer operações de entrada e saída diretamente, mas que as funções de entrada e saída
devem estar no mesmo arquivo da função principal. Isso me deixou meio confuso, pois na minha cabeça eu já tinha organizado as operações do programa
pelos arquivos (então a função principal faria o menu e finalizava o programa, teria um arquivo para operações de I/O, e os outros com as operações da
calculadora). Mas para seguir a especificação, as funções que estão no arquivo IOCalc.asm foram jogadas no calculadora.asm, apenas ignore a existência dele e compile os
programas com os comandos acima (caso eu esqueça de tirar o arquivo da pasta).

A especificação também mandava fazer um programa que alternava de precisão, mas fiz o que a sua mensagem de 22 de novembro ordenava, que é fazer 2 programas, um pra cada precisão.

Conforme especificado, somente as funções de multiplicação e exponenciação possuem mensagem de overflow.

TODAS as funcionalidades exigidas foram feitas em AMBAS as precisões.
