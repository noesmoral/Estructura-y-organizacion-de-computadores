Dosseg
.model small
.stack 100h
.data
Operando1 DB 10h
Operando2 DB 20h
ResSuma DW 0000h
ResResta DW 0000h
ResMul DW 0000h
ResDiv DW 0000h

.code
Inicio:
mov ax, @data
mov ds, ax
sub ax, ax
mov al, Operando1
add al, Operando2
mov ResSuma, ax

sub ax, ax
mov al, Operando2
sub al, Operando1
mov ResResta, ax

sub ax, ax
sub bx, bx
mov al, Operando1
mov bl, Operando2
mul bl
mov ResMul, ax

sub ax, ax
sub bx, bx
mov al, Operando2
mov bl, Operando1
div bl
mov ResDiv, ax

mov ah, 4Ch
int 21h
end Inicio