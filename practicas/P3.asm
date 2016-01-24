dosseg
.model small
.stack 100h
.data
	Texto0 DB "This program compares two strings and display the number of different characters only",13,10,'$'
	Texto1 DB "Write the first string of characters (max 120) to compared",13,10,'$'
	Texto2 DB "Write the second string of characters (max 120) to compared",13,10,'$'
	Cadena1 DB 121,?,121 DUP(?)
	Cadena2 DB 121,?,121 DUP(?)
	Resul DW 0

.code


print PROC FAR
	mov ah, 9h
	int 21h
	ret
print ENDP


compare PROC FAR
	cmp al,bl	
	je exit
	jmp increment

increment:
	inc Resul
	ret
exit:
	ret
compare ENDP


cadmax PROC FAR
	mov al, Cadena1[SI+1]
	mov bl, Cadena2[SI+1]
	cmp al, bl
	ja more
	jmp diferent
more:
	mov cl, Cadena1[SI+1]
	ret

diferent:
	mov cl, Cadena2[SI+1]
	ret
cadmax ENDP


Inicio:
	mov ax, @data
	mov ds, ax

	lea dx, Texto0
	call print

	lea dx, Texto1
	call print

	mov ah, 0Ah
	lea dx, Cadena1
	int 21h

	lea dx, Texto2
	call print

	mov ah, 0Ah
	lea dx, Cadena2
	int 21h
	
	xor SI, SI
	call cadmax  ;Comprobacion cadena mas grande
	bucle:
		mov al, Cadena1[SI+2]
		mov bl, Cadena2[SI+2]	
		call compare
		inc SI
	loop bucle

	mov ah, 4Ch
	int 21h

END Inicio