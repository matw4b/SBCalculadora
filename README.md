# Trabalho 2
Calculadoras com operações em ponto fixo em IA-32 de precisões de 16 e 32 bits

# Aluno:
Matheus Guaraci Lima Bouças Alves 180046951

# Compilar 32bits e 16 bits
nasm -f elf -o calculadora.o calculadora.asm
nasm -f elf -o IOCalc.o IOCalc.asm
ld -m elf_i386 -o calculadora calculadora.o IOCalc.o

## Aviso importante:
Os programas possuem os mesmos nomes para manter os mesmos comandos na compilação, portanto o que diferenciam eles são as pastas onde estão localizados 
e os %define que alteram os registradores utilizados. Os comentários da versão de 32 bits foram mantidos na de 16.
