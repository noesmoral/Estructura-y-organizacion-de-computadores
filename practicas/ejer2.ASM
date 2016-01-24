dosseg
.model small
.stack 100h
.data
Texto DB "Please enter number with 16bits: ",13,10,'$'
Texto1 DB "Read chain: ",13,10,'$'
Texto2 DB "Complent A2: Valor almacenado en variable varc2",13,10,'$'
Texto3 DB "Complent x: Valor almacenado en variable varcx",13,10,'$'
MaximoMas1 DB 17
CaracteresLeidos DB 0
Cadena DB 17 DUP (0)
CadenaNeg DB 17 DUP (0)
Contador DB 10h
Otralinea DB 13,10,'$'
varcO DW 0000h
varc2 DW 0000h
varcx DW 0000h
numero DW 0000h
multi DW 8000h
ddos db 02h


.code
Inicio:
mov ax, @data
mov ds, ax

mov ah, 9
lea dx, Texto
int 21h

mov ah, 0Ah
lea dx, MaximoMas1
int 21h

mov ah, 9
lea dx, Otralinea
int 21h

mov cl, Contador
xor SI, SI
mov ah, 2

bucle:
mov dl, Cadena[SI]
int 21h
inc SI
loop bucle

mov cl, Contador
xor SI, SI

bucle1:
xor ax,ax
mov al,Cadena[si] ;convierte cadena a número
xor al,30h
mov bx,multi
mul bx
add numero,ax
xor ax,ax
xor bx, bx
mov ax,multi
shr ax, 1
mov multi,ax
xor bx, bx
xor ax,ax
inc si
loop bucle1

mov ax, numero
mov varcO, ax
neg ax
mov varc2, ax

mov ax, varcO
add ax, 8000h
mov varcx, ax

mov ah, 4Ch
int 21h
END Inicio