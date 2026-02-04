# Simulador NEANDER (baseado no wneander)
Este repositório contém todos os arquivos descritivos e arquivos de teste utilizados/criados durante o processo de implementação -em vhdl- do **Computador Teórico Neander**, desenvolvido na parte final da disciplina de **Sistemas Digitais**.

## Principais características
* Largura dos dados e endereçamento: 8 bits
* Dados são representados em **complemento de dois**
*  Acompanha um **Registrador Acumulador de 8 bits**
* Acompanha um **Contador de Programa de 8 bits**
* Acompanha um **Registrador de Flags com dois estados possíveis: negativo e zero**

## Instruções utilizadas
![Parte interna da UC]<img src="https://github.com/user-attachments/assets/237c7c66-03ee-4286-957c-12f374405a0b" alt="06-UnidadeControle02-underthehood" width="100%" />

| Código | Instrução | Operação |
|:-------|:----------|:---------|
|0000	   |NOP	       |Nenhuma operação|
|0001	   |STA end	   |Armazena acumulador no endereço da memória|
|0010	   |LDA end	   |Carrega o acumulador da memória|
|0011	   |ADD end	   |Soma o conteúdo do endereço da memória ao acumulador|
|0100	   |OR end	   |Efetua operação lógica “OU” do conteúdo do endereço da memória ao acumulador|
|0101	   |AND end	   |Efetua operação lógica “E” do conteúdo do endereço da memória ao acumulador|
|0110	   |NOT	       |Inverte todos os bits do acumulador|
|1000	   |JMP end	   |Desvio incondicional para o endereço da memória|
|1001	   |JN end	   |Desvio condicional, se “N=1”, para o endereço da memória|
|1010	   |JZ end	   |Desvio condicional, se “Z=1”, para o endereço da memória|
|1111	   |HLT	       |Finaliza o ciclo|

## Módulos (conteúdo)
### Módulo Unidade Lógica e Aritmética
#### Registrador AC (Acumulador) de 8 bits
#### Multiplexador 2x8 especial (com lógica when... else)
#### Registrador de Flags de 2 bits
#### ULA
##### Somador de 8 bits (ADD)
##### Portas lógicas AND, OR e NOT (ambos são bitwise)

### Módulo Memória
#### Dois multiplexadores 2x8 (sendo um especial)
#### Registrador de Endereço de Memória de 8 bits
#### Memória Ram Assíncrona de 8 bits
#### Registrador de Dados de Memória de 8 bits

### Módulo Program Counter
#### Somador de 8 bits
#### Multiplexador 2x8
#### Registrador de Apontador de Programa de 8 bits

### Módulo Unidade de Controle
#### Registrador de Instrução de 8 bits
#### Decodificador 8x11
#### Unidade de Controle
##### Contador de 3 bits
##### Multiplexador 11x11 (especial)

## Alunos
- Caroline Saito
- Iokio Hirai
- Julya Biazoto


