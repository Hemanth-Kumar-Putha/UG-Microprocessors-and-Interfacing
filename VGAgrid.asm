.model tiny
.data

max1 db 3
num1 db ?
inp1 db 4 dup('$')

max2 db 3
num2 db ?
inp2 db 4 dup('$')

rowstart db 100
columnstart dw 260

twenty dw 20

paintrowstart dw ?
paintcolumnstart dw ?

paintrowend dw ?
paintcolumnend dw ?

numberofinputs dw ?

message1 db 'Enter the row and column in the format RowColumn: $'

message2 db 'How many boxes do you want to fill? $'

message3 db 'Next box (RowColumn format): $'

.code
.startup

lea dx, message2
mov ah, 09h
int 21h

mov ah, 01h
int 21h

mov ah, 00
sub al, 30h
mov numberofinputs, ax

mov dl, 0ah
mov ah, 02h
int 21h

lea dx, message1
mov ah, 09h
int 21h

lea dx, max1
mov ah, 0ah
int 21h

call asciiinteger

call updaterowcolumn

call grid

.exit

asciiinteger:

	 mov cl, num1
	 mov ch, 0
	 
	 lea di, inp1
	 
	 asciiinteger1:
	 
		 mov al, [di]
		 
		 sub al, 30h
		 
		 mov [di], al
		 
		 inc di
		 
		 loop asciiinteger1
		 
	 ret

grid: 

	 mov ah, 00h
	 mov al, 12h
	 int 10h

	 mov cx, 260
	 mov dx, 100
	 
	 grid1:
		 
		 mov ah, 0ch
		 mov al, 1110b
		 mov dx, dx
		 mov cx, cx
		 int 10h
		 
		 cmp dx, 300
		 je nextcx
		 
		 inc dx
		 jmp grid1
		 
		 nextcx:
		 
			 cmp cx, 460
			 je horzlines
		 
			 add cx, 20
			 
			 mov dx, 100
			 
			 jmp grid1
			 
			 horzlines:
				 
				 mov cx, 260
				 mov dx, 100
				 
				 horzlines1:
				 
		 		 mov ah, 0ch
				 mov al, 1110b
				 mov dx, dx
				 mov cx, cx
				 int 10h
				 
				 cmp cx, 460
				 je nextdx
				 
				 inc cx
				 jmp horzlines1
				 
				 nextdx:
				 
					 cmp dx, 300
					 je griddone
					 
					 add dx, 20
					 
					 mov cx, 260
					 
					 jmp horzlines1
			 
					 griddone:
						 
						 call paintbox 
						 
						 mov cx, numberofinputs							 
						 
						 cmp cx, 1
						 je paintboxdone
						 
						 dec cx
						 
						 paintbox1:
							 
							 push cx
							 
							 lea dx, message3
							 mov ah, 09h
							 int 21h
							 
							 lea dx, max2
							 mov ah, 0ah
							 int 21h
							 
							 mov dl, 0ah
							 mov ah, 02h
							 int 21h
							 
							 call asciiinteger20
							 
							 call updaterowcolumn2
							 
							 call paintbox2
							 
							 pop cx
							 
							 loop paintbox1 
							 
							 paintboxdone:
								 
								 mov ah, 07h
								 x1: int 21h
								 cmp al, '%'
								 jnz x1
							 
								 ret
			 
paintbox2:

	 mov cx, paintcolumnstart
	 mov dx, paintrowstart
	 
	 mov bx, paintrowend
	 mov ax, paintcolumnend
	 
	 push ax
	 
	 grid210:
		 
		 mov ah, 0ch
		 mov al, 1110b
		 mov dx, dx
		 mov cx, cx
		 int 10h
		 
		 cmp dx, bx
		 je nextcx20
		 
		 inc dx
		 jmp grid210
		 
		 nextcx20:
		 
			 pop ax
		 
			 cmp cx, ax
			 je paintdone2
			 
			 push ax
			 
			 inc cx
			 
			 mov dx, paintrowstart
			 
			 jmp grid210
			 
			 paintdone2:
			 
				 ret

paintbox:

	 mov cx, paintcolumnstart
	 mov dx, paintrowstart
	 
	 mov bx, paintrowend
	 mov ax, paintcolumnend
	 
	 push ax
	 
	 grid10:
		 
		 mov ah, 0ch
		 mov al, 1110b
		 mov dx, dx
		 mov cx, cx
		 int 10h
		 
		 cmp dx, bx
		 je nextcx0
		 
		 inc dx
		 jmp grid10
		 
		 nextcx0:
		 
			 pop ax
		 
			 cmp cx, ax
			 je paintdone
			 
			 push ax
			 
			 inc cx
			 
			 mov dx, paintrowstart
			 
			 jmp grid10
			 
			 paintdone:
			 
				 ret

updaterowcolumn:

	 lea di, inp1
	 
	 mov bh, 0
	 mov bl, [di]
	 
	 cmp bl, 7
	 jb keepgoing
	 ja eightornine
	 
	 mov ax, 240
	 mov paintrowstart, ax
	 
	 inc di 
	 
	 jmp updatecolumn
	 
	 eightornine:
	 
	 cmp bl, 8
	 jb updaterowcolumndone
	 ja nine
	 
	 mov ax, 260
	 mov paintrowstart, ax
	 
	 inc di
	 
	 jmp updatecolumn
	 
	 nine:
	 
	 cmp bl, 9
	 jb updaterowcolumndone
	 ja updaterowcolumndone
	 
	 mov ax, 280
	 mov paintrowstart, ax
	 
	 jmp updatecolumn
	 
	 keepgoing:
	 
	 mov ax, 20
	 
	 mul bx
	 
	 add ax, 100
	 
	 mov paintrowstart, ax
	 
	 updatecolumn:
	 
	 inc di
	 
	 mov bh, 0
	 mov bl, [di]
	 
	 mov ax, 20
	 
	 mul bx
	 
	 add ax, 260
	 
	 mov paintcolumnstart, ax
	 
	 updaterowcolumndone:
		 
		 mov ax, paintrowstart
		 
		 add ax, 20
	 
		 mov paintrowend, ax
		 
		 mov ax, paintcolumnstart
		 
		 add ax, 20
		 
		 mov paintcolumnend, ax

		 ret

updaterowcolumn2:

	 lea di, inp2
	 
	 mov bh, 0
	 mov bl, [di]
	 
	 mov dx, 100
	 
	 mov ax, 20
	 
	 mul bl
	 
	 add ax, dx
	 
	 mov paintrowstart, ax
	 
	 add ax, 20
	 
	 mov paintrowend, ax
	 
	 inc di
	 
	 mov bh, 0
	 mov bl, [di]
	 
	 mov dx, 260
	 
	 mov ax, 20
	 
	 mul bl
	 
	 add ax, dx
	 
	 mov paintcolumnstart, ax
	 
	 add ax, 20
	 
	 mov paintcolumnend, ax
	 
	 ret

asciiinteger20:

	 mov cl, num2
	 mov ch, 0
	 
	 lea di, inp2
	 
	 asciiinteger2:
	 
		 mov al, [di]
		 
		 sub al, 30h
		 
		 mov [di], al
		 
		 inc di
		 
		 loop asciiinteger2
		 
	 ret

end
