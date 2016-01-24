dosseg
.model small
.stack 100h
.data
Texto1 DB "This program calculates powers", 13,10,'$'
Texto2 DB "Please, enterBase < 255: ", 13,10,'$'
Texto3 DB "Please, introduce Exponent< 255: ", 13,10,'$'
Base DB ?
Exp DB ?
Resul DW ?
.code
convierte proc
sub al,30h
ret
convierte endp

potencia macro LaBase, Exponente
mov cx, Exponente

mov ax, 1
jcxz cero
otro:
mul LaBase
loop otro
 cero:
endm

Inicio:
mov ax, @data
mov ds, ax

mov ah,9
lea dx,Texto1
int 21h

lea dx,Texto2
int 21h

mov ah,1
int 21h
call convierte
mov Base, al

mov ah,9
lea dx,Texto3
int 21h
mov ah,1
int 21h
call convierte
mov Exp, al

potencia Base, Exp
mov Resul, ax

mov ah, 4Ch
int 21h
END Inicio