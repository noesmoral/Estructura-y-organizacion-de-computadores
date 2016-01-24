dosseg
.model small
.stack 100h
.data
numeros DB 1,2,3,4,5,6;

.CODE
Inicio:
mov ax, @DATA
mov ds, ax

lea bx, numeros

mov cx, 6

Bucle:
	mov dl,[bx]
	add dl, 4
	mov [bx], dl
	inc bx
LOOP Bucle

mov cx, 6

Bucle1:
	mov dl,[bx]
	add dl, 4
	mov [bx], dl
	inc bx
LOOP Bucle1

	mov ah, 4ch
	int 21h
END Inicio