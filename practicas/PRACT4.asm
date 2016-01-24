DOSSEG
.MODEL SMALL
.STACK 100h
.DATA
	Usuarios DB "ANTONIO GOMEZ GOMEZ%A23$"
		DB "LUISA ALONSO LOPEZ%A1SA3$"
		DB "FERNANDO PEREZ MINGUEZ%2W45$"
		DB "JOSEFA RUIZ SANCHEZ%ASQ12$"
		DB "MIGUEL GARCIA GARCIA%S1A$"
	LonUsua EQU $-Usuarios
	LonParc DB 5 DUP() 
	Mensaje1 DB "Nombre de usuari@: $"
	Mensaje2 DB "Por favor, introduzca su clave de acceso: $"
	Mensaje3 DB "Bienvenid@ al sistema.$"
	Mensaje4 DB "Nombre de usuari@ o palabra clave incorrectos.$"
	Mensaje5 DB "Ha sobrepasado el numero de intentos de entrada.$"
	DB "El sistema se bloquea.",10,13,"$"
	BufUsu DB 31 ;Buffer para guardar el usuario
	LonUsu DB 0
	Usuari DB 31 DUP (?)
	LonCla DW 0 ;Buffer to store password
	Clave DB 5 DUP (?)
	NumInt DB 0 ;Number of failed atempts
.CODE

	;Macro to change video mode
	ModoVideo MACRO modo
		mov ah,0
		mov al,modo
		int 10h
	ENDM


	PonCursor PROC
		push bp		;guardamos en pila el actual
		mov bp,sp	;sacamos la pila con los parametros anteriores
		mov ah,2
		mov dh,BYTE PTR [bp+4];sacamos la fila
		mov dl,BYTE PTR [bp+8];sacamos la columna
		mov bh,0	
		int 10h		;interupcion
		pop bp		;bajamos la pila
		RET		;salimos
	PonCursor ENDP


	SacaMens MACRO mensaje;
		lea dx, mensaje		;sacamos el mensaje
		mov ah,9		;seleccionamos interupcion
		int 21h			;interupcion
	ENDM				;fin marco


	Inicio: 
		mov ax,@DATA
		mov ds,ax

		otrave: 
			ModoVideo 3

			mov ax, 000Ah	;insertamos 10
			push ax		;almacenamos 10 en la pila
			mov ax, 000Fh	;insertamos 15
			push ax		;almacenamos 15 en la pila
			call PonCursor	;llamada a poncursor

			SacaMens Mensaje1;llamada a sacamens con M1
			lea dx, BufUsu	;preparamos para leer usuario
			mov ah,0Ah	;preparamos la int
			int 21h		;interupcion

			mov ax, 000Ch 	;ponemos 12
			push ax		;almacenamos 12 en pila
			mov ax, 000Fh	;ponemos 15
			push ax		;almacenamos 15 en pila
			call PonCursor	;llamada para poncursor con los parametros en la pila
			SacaMens Mensaje2;enviamos el mensaje

			lea bx, Clave	;preparamos para leer la clave
			xor si,si

		lazo1: 
			mov ah,8
			int 21h
			mov [bx+si],al
			cmp al,13

			je salir
			mov ah,0Eh
			mov al,'*'
			int 10h
			inc si
			cmp si,5
			jbe lazo1

		salir: 
			mov LonCla,si
			xor si,si
			xor di,di
			mov dl,1 
			lea bx, Usuarios
			mov cx,LonUsua
			mov al,'$'

		lazo2: 
			cmp al,[bx+si]
			jne seguir
			mov LonParc[di],dl
			xor dl,dl
			inc di

		seguir: 
			inc si
			inc dl
			loop lazo2
			;Check username with allowed stored names
			lea bx, Usuarios
			xor di,di
			xor si,si
			xor cx,cx
			mov cl,LonParc 

		otrous: 
			xor si,si

		lazo3: 
			mov al,Usuari[si]
			cmp al,20h 
			je saltar
			and al,11011111b 
		
		saltar: 
			cmp al,[bx+si]
			jne salfin
			inc si
			loop lazo3

		salfin: 
			cmp BYTE PTR[bx+si],'%'

			je nomcorr

			mov cl,LonParc[di]
			add bx,cx
			inc di
			cmp bx,LonUsua
			jb otrous
			jmp nominc
			
		nomcorr:
			xor cx,cx
			mov cl,LonParc[di]
			sub cx,si ;(LonParc[di]-si)-2
			dec cx
			dec cx
			cmp cx,LonCla
			jb nominc
			inc si
			xor di,di

		lazo4: 
			mov al,Clave[di]
			cmp al,[bx+si]
			jne nominc
			inc si
			inc di
			loop lazo4

			mov ax, 000Eh 
			push ax
			mov ax, 000Fh
			push ax
			call PonCursor

			SacaMens Mensaje3

			jmp final
		
		nominc: 
			mov ax, 000Eh
			push ax
			mov ax, 000Fh
			push ax
			call PonCursor

			SacaMens Mensaje4

			mov al,NumInt
			inc al
			cmp al,3
			jae bloquea
			mov NumInt,al
			jmp otrave

		bloquea:
			mov ax, 0010h
			push ax
			mov ax, 0004h
			push ax
			call PonCursor

			SacaMens Mensaje5

			jmp bloquea

		final: 
			mov ah,4Ch
			int 21h

	END Inicio
