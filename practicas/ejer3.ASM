.model small

.stack 300h
;------------------------------------------------------
.data
CR equ 0dh
LF equ 0ah
salto db CR,LF,'$'
mens db 'Inserta numero de 8 bits',CR,LF,'$'
numero db 0h
numero2 db 0h
dos db 02h
multi db 128d

binarios label byte
string dW 17
max dW 17
cadena dW 17 dup(' ')

uno db -01h
c2 db 01h

bcd1 db 0
bcd2 db 0
bcd3 db 0
aux db 0
nbcd db 0

h1 db 0
h2 db 0
hex db 16d
;-------------------------------------------------------
.code
inicio:

mov ax,@data
mov ds,ax
push ds
pop es
;-------------------------------------------------------
mov ah,09h ;rutina que obtiene cadena de 8 bits
lea dx,mens ;desde teclado
int 21h

mov ah,0ah
lea dx,binarios
int 21h

mov ah,09h
lea dx,salto
int 21h
;--------------------------------------------------------
xor si,si
lea si,cadena
mov cx,0008h
;--------------------------------------------------------
conver:
mov al,[si] ;convierte cadena a número
xor al,30h
mov bl,multi
mul bl
add al,numero
mov numero,al
mov numero2,al
mov nbcd,al
xor ax,ax
mov al,multi
div dos
mov multi,al
xor ax,ax
inc si
loop conver
call limpieza
;--------------------------------------------------------
; COMIENZAN LAS RUTINAS DE CONVERSION
;--------------------------------------------------------
;call imprimir ; muestra la cadena tal cual se tecleó
;mov ah,09h
;lea dx,salto
;int 21h
;call limpieza
;**************************************
mov al,numero
mov bl,-1
imul bl
mov numero,al ;rutina a numero negativo
call limpieza
call imprimir
mov ah,09h
lea dx,salto
int 21h
call limpieza
;**************************************
mov dl,numero2
mov numero,dl
not numero ;rutina complemento a 1
call limpieza
call imprimir
mov ah,09h
lea dx,salto
int 21h
call limpieza

;**************************************
mov al,numero2
not al
add al,01 ;rutina complemento a 2
mov numero,al
call imprimir
mov ah,09h
lea dx,salto
int 21h
call limpieza

;****************************************
mov al,nbcd ;rutina a BCD
mov bl,10
div bl
mov bcd1,ah
mov bcd2,al
call limpieza
mov al,bcd2
mov bl,10
div bl
mov bcd2,ah
mov bcd3,al
call limpieza

mov bl,bcd3
mov aux,bl
call print_bcd
call limpieza
mov dl,' '
call print
call limpieza

mov bl,bcd2
mov aux,bl
call print_bcd
call limpieza
mov dl,' '
call print
call limpieza

mov bl,bcd1
mov aux,bl
call print_bcd
call limpieza
mov dl,' '
call print
call limpieza
mov ah,09h
lea dx,salto
int 21h
call limpieza
nop
nop
nop

;**************************************
mov al,numero2 ;rutina en hexadecimal
div hex
mov h1,al
mov h2,ah
xor ax,ax

mov al,h1
cmp al,0ah
jae @diez
mov dl,al
or dl,30h
call print
jmp sigue
@diez:
add al,55
mov dl,al
call print
sigue:
mov al,h2
cmp al,0ah
jae @vein
mov dl,al
or dl,30h
call print
jmp fin
@vein:
add al,55
mov dl,al
call print
mov ah,09h
lea dx,salto
int 21h
call limpieza
nop
nop
nop



fin:
mov ax,4c00h
int 21h

;--------------------------------------------------------
imprimir proc near
mov cx,0008h ;ciclo para obtener el numero binario
mov al,numero
mov bl,dos
ciclo_bin:
div bl
push ax
mov numero,al
xor ax,ax
mov al,numero
loop ciclo_bin
;-------------------------------------------------------
mov cx,0008h ;ciclo para imprimir el número binario
ciclo_print:
pop dx
xchg dh,dl
or dx,3030h
mov ah,02h
int 21h
xor dx,dx
loop ciclo_print
ret
imprimir endp

;--------------------------------------------------------
limpieza proc near
xor ax,ax ;limpiamos los registros para que no exista
xor bx,bx ;un desbordamiento al hacer las operaciones
xor dx,dx
xor cx,cx
ret
limpieza endp
;--------------------------------------------------------
print proc near
mov ah,02h
int 21h
ret
print endp
;--------------------------------------------------------
print_bcd proc near
mov cx,0008h ;ciclo para obtener el numero bcd
mov al,aux
mov bl,dos
ciclo_bcd:
div bl
push ax
mov aux,al
xor ax,ax
mov al,aux
loop ciclo_bcd

mov cx,0008h ;ciclo para imprimir el número binario
ciclo_print2:
pop dx
xchg dh,dl
or dx,3030h
mov ah,02h
int 21h
xor dx,dx
loop ciclo_print2
ret
print_bcd endp
;-------------------
end inicio