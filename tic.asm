; --------------------------
; TIC TAC TOE GAME
; by Talya Gross
; --------------------------

IDEAL
MODEL large
STACK 100h
DATASEG

; --------------------------
; the screen is 320x200 -> 140h X c8h
; variables:

	; colors
	white_color db 15 ; white color
	green_color db 10 ; green color
	red_color db 12 ; light red color	
	
	; time 
	time_change db 0h
	
	; line positions for the game board
	line_x_left_pos dw 79h ;start position for the x left line
	line_y_left_pos dw	28h ;start position for the y left line
	line_x_right_pos dw 168;start position for the x right line
	line_y_right_pos dw	28h ;start position for the y right line
	line_x_up_pos dw 55h ;start position for the x up line
	line_y_up_pos dw 50h ;start position for the y up line
	line_x_down_pos dw 55h ;start position for the x down line
	line_y_down_pos dw 7Dh ;start position for the y down line
	
	; circle positions (x,y)
	;  1: 64h, 4Ah / 2: 8Fh, 4Ah / 3: 189, 4Ah / 4: 64h, 75h / 5: 8Fh, 75h / 6: 189, 75h / 7: 64h, 162 / 8: 8Fh, 162 / 9: 189, 162
	
	; X position (x, y1, y2)
	; 1: 57h, 4Ch, 2Dh / 2: 82h, 4Ch, 2Dh / 3: 177, 4Ch, 2Dh / 4: 57h, 77h, 58h / 5: 82h, 77h, 58h / 6: 177, 77h, 58h 
	; / 7: 57h, 162, 84h / 8: 82h, 162, 84h / 9: 177 , 162, 84h
	
	; sqaure position
	sqaure_x_pos dw 54h ;start position for the x sqaure
	sqaure_y_pos dw 168 ;start position for the y sqaure
	
	; positions for the X and O
	position_X dw 0h
	position_Y dw 0h
	position_Y_1 dw 0h ; just for X
	
	; who has the turn: 0 = x , 1 = O
	player_turn dw 0h

	; counters for drawing
	count_x dw 0h ; counter for x width
	count_y dw 0h ; counter for y width
	
	; the status of the sqaures( if there is X \ O \ nothing ): 0 = nothing , 1 = X , 2 = O
	sqaure_pos_1 dw 0h 
	sqaure_pos_2 dw 0h 
	sqaure_pos_3 dw 0h 
	sqaure_pos_4 dw 0h 
	sqaure_pos_5 dw 0h 
	sqaure_pos_6 dw 0h 
	sqaure_pos_7 dw 0h 
	sqaure_pos_8 dw 0h 
	sqaure_pos_9 dw 0h 
	
	; the status of the game: 0 = opening screen, 1 = the game is running, 2 = end screen 
	game_status dw 0h 
	
	; text
	text_game_name db 'tic tac toe' , '$' ;text of the game's name
	text_start_game db 'Please press SPACE to start the game' ,'$' ;text of menu- opening screen 
	text_end_game_e db 'Please press E to exit the game' , '$' ;text of menu- end screen 
	text_end_game_r db 'or R to restart' , '$' ;text of menu- end screen 
	text_X_winner db 'player X has won!!' ,'$' ;text of X winner
	text_O_winner db 'player O has won!!' ,'$' ;text of O winner
	text_draw db 'there is a draw' , '$' ;text of draw

; -------------------------

CODESEG

; -------------------------
; procedure:

proc clearscreen ;clear the screen
	mov ax,13h
	int 10h	
	ret 	
endp clearscreen

; drawing the board- sqaure + lines 
; -------------
; |   |   |   |
; -------------
; |   |   |   |
; -------------
; |   |   |   |
; -------------

proc draw_sqaure
	mov cx,[sqaure_x_pos] ; the x position of the pixel
	mov dx,[sqaure_y_pos] ; the y position of the pixel
	sqaure: ; label start of writing x pixel
	mov ah,0Ch ; enter wirriing pixel mode
	mov al,[white_color] ; set color to white
	mov bh,0h ; page =0
	int 10h ; call int 10h execute the writting to the screen
	inc [count_x] ; count_x++
	inc cx ; increase the position of the x pixel
	cmp [count_x],81h ; cmp the width for the line to 81h
	jne sqaure ; jump if the width isnt 81h, if not countinue drawing more pixels
	
	mov [count_x],0h 
	sqaure_1:
	mov ah,0Ch ; enter wirriing pixel mode
	mov al,[white_color] ; set color to white
	mov bh,0h ; page =0
	int 10h ; call int 10h execute the writting to the screen
	inc [count_y] ; count_y++
	dec dx ; decrease the position of the y pixel
	cmp [count_y] ,81h ; cmp the width for the line to 81h
	jne sqaure_1 ;jump if the width isnt 81h, if not get new line
	
	mov [count_y],0h 
	sqaure_3:
	mov ah,0Ch ; enter wirriing pixel mode
	mov al,[white_color] ; set color to white
	mov bh,0h ; page =0
	int 10h ; call int 10h execute the writting to the screen
	inc [count_x] ; count_x++
	dec cx ; decrease the position of the x pixel
	cmp [count_x] ,81h ; cmp the width for the line to 81h
	jne sqaure_3 ;jump if the width isnt 81h, if not get new line
	
	mov [count_x],0h 
	sqaure_4:
	mov ah,0Ch ; enter wirriing pixel mode
	mov al,[white_color] ; set color to white
	mov bh,0h ; page =0
	int 10h ; call int 10h execute the writting to the screen
	inc [count_y] ; count_y++
	inc dx ; increase the position of the y pixel
	cmp [count_y] ,81h ; cmp the width for the line to 81h
	jne sqaure_4 ;jump if the width isnt 81h, if not get new line
	
	mov [count_y],0h 
	mov [count_x],0h
	
	ret ; return to the main function
endp draw_sqaure


 proc draw_line_x_left

	mov cx,[line_x_left_pos] ; the x position of the pixel
	mov dx,[line_y_left_pos] ; the y position of the pixel
	start_x_left: ; label start of writing x pixel
	mov ah,0Ch ; enter wirriing pixel mode
	mov al,[white_color] ; set color to white
	mov bh,0h ; page =0
	int 10h ; call int 10h execute the writting to the screen
	inc [count_x] ; count_x++
	inc cx ; increase the position of the x pixel
	cmp [count_x],3h ; cmp the width for the line to 3h
	jne start_x_left ; jump if the width isnt 3h, if not countinue drawwing more pixels
	
	mov [count_x],0h 
	inc dx ;increase y position of the pixel
	inc [count_y] ; count_y++
	mov cx,[line_x_left_pos] ; the x position of the pixel for a new line
	cmp [count_y] ,80h ; cmp the width for the line to 80h
	jne start_x_left ;jump if the width isnt 80h, if not get new line
	
	mov [count_y],0h 
	mov [count_x],0h
	
	ret ; return to the main function
 endp draw_line_x_left


 proc draw_line_x_right

	mov cx,[line_x_right_pos] ; the x position of the pixel
	mov dx,[line_y_right_pos] ; the y position of the pixel	
	start_x_right: ; label start of writing x pixel
	mov ah,0Ch ; enter wirriing pixel mode
	mov al,[white_color] ; set color to white
	mov bh,0h ; page =0
	int 10h ; call int 10h execute the writting to the screen
	inc [count_x] ; count_x++
	inc cx ; increase the position of the x pixel
	cmp [count_x],3h ; cmp the width for the line to 3h
	jne start_x_right ; jump if the width isnt 3h, if not countinue drawwing more pixels
	
	mov [count_x],0h 
	inc dx ;increase y position of the pixel
	inc [count_y] ; count_y++
	mov cx,[line_x_right_pos] ; the x position of the pixel for a new line
	cmp [count_y] ,80h ; cmp the width for the line to 80h
	jne start_x_right ;jump if the width isnt 80h, if not get new line
	 
	mov [count_y],0h 
	mov [count_x],0h
	
	ret ; return to the main function
 endp draw_line_x_right


 proc draw_line_x_up

	mov cx,[line_x_up_pos] ; the x position of the pixel
	mov dx,[line_y_up_pos] ; the y position of the pixel
	start_y_up: ; label start of writing x pixel
	mov ah,0Ch ; enter wirriing pixel mode
	mov al,[white_color] ; set color to white
	mov bh,0h ; page =0
	int 10h ; call int 10h execute the writting to the screen
	inc [count_y] ; count_y++
	inc dx ; increase the position of the y pixel
	cmp [count_y],3h ; cmp the width for the line to 3h
	jne start_y_up ; jump if the width isnt 3h, if not countinue drawwing more pixels
	
	mov [count_y],0h 
	inc cx ;increase x position of the pixel
	inc [count_x] ; count_x++
	mov dx,[line_y_up_pos] ;the y position of the pixel for a new line
	cmp [count_x] ,80h ; cmp the width for the line to 80h
	jne start_y_up ;jump if the width isnt 80h, if not get new line
	
	mov [count_y],0h 
	mov [count_x],0h
endp draw_line_x_up
	
	
proc draw_line_x_down

	mov cx,[line_x_down_pos] ; the x position of the pixel
	mov dx,[line_y_down_pos] ; the y position of the pixel
	start_y_down: ; label start of writing x pixel
	mov ah,0Ch ; enter wirriing pixel mode
	mov al,[white_color] ; set color to white
	mov bh,0h ; page =0
	int 10h ; call int 10h execute the writting to the screen
	inc [count_y] ; count_y++
	inc dx ; increase the position of the y pixel
	cmp [count_y],3h ; cmp the width for the line to 3h
	jne start_y_down ; jump if the width isnt 3h, if not countinue drawwing more pixels
	
	mov [count_y],0h 
	inc cx ;increase x position of the pixel
	inc [count_x] ; count_x++
	mov dx,[line_y_down_pos] ; the x position of the pixel for a new line
	cmp [count_x] ,80h ; cmp the width for the line to 80h
	jne start_y_down ;jump if the width isnt 80h, if not get new line
	
	mov [count_y],0h 
	mov [count_x],0h
	
	ret ; return to the main function
 endp draw_line_x_down


proc draw_X ; drawing X

	; draw /
	mov cx,[position_X] ; the x position of the pixel
	mov dx,[position_Y] ; the y position of the pixel
	start_draw_1: ; label start of drawing a /
	mov ah,0Ch ; enter wirriing pixel mode
	mov al,[green_color] ; set color to green
	mov bh,0h ; page =0
	int 10h ; call int 10h execute the writting to the screen
	dec dx ; decrease the position of the y pixel
	
	inc [count_x] ; count_x++
	inc cx ; increase x position of the pixel
	cmp [count_x] ,20h ; cmp the width for the line to 20h
	jne start_draw_1 ;jump if the width isnt 20h, if not get new line
	
	mov [count_y],0h 
	mov [count_x],0h
	
	; draw \ .
	mov cx,[position_X] ; the x position of the pixel
	mov dx,[position_Y_1] ; the y position of the pixel
	start_draw_2: ; label start of drawing a \ . 
	mov ah,0Ch ; enter wirriing pixel mode 
	mov al,[green_color] ; set color to green
	mov bh,0h ; page =0
	int 10h ; call int 10h execute the writting to the screen
	inc dx ; increase the position of the y pixel
	
	inc [count_x] ; count_x++
	inc cx ; increase x position of the pixel
	cmp [count_x] ,20h ; cmp the width for the line to 20h
	jne start_draw_2 ;jump if the width isnt 20h, if not get new line
	
	mov [count_y],0h 
	mov [count_x],0h
	
	ret ; return to the main function
 endp draw_X


proc draw_O ; drawing O

	mov cx,[position_X] ; the x position of the pixel
	mov dx,[position_Y] ; the y position of the pixel
	start_O:
	mov ah,0Ch ; enter wirriing pixel mode
	mov al,[red_color] ; set color to red
	mov bh,0h ; page =0
	int 10h ; call int 10h execute the writting to the screen
	inc [count_x] ; count_x++
	inc cx ; increase the position of the x pixel
	cmp [count_x],7h ; cmp the width for the line to 7h
	jne start_O ; jump if the width isnt 7h, if not countinue drawwing more pixels
	
	mov [count_x],0h
	dec dx ; decrease the position of the y pixel

	start_O_1: 
	mov ah,0Ch ; enter wirriing pixel mode
	mov al,[red_color] ; set color to red
	mov bh,0h ; page =0
	int 10h ; call int 10h execute the writting to the screen
	inc [count_x] ; count_x++
	inc cx ; increase the position of the x pixel
	cmp [count_x],3h ; cmp the width for the line to 3h
	jne start_O_1 ; jump if the width isnt 3h, if not countinue drawwing more pixels
	
	mov [count_x],0h
	dec dx ; decrease the position of the y pixel
	
	start_O_2: 
	mov ah,0Ch ; enter wirriing pixel mode
	mov al,[red_color] ; set color to red
	mov bh,0h ; page =0
	int 10h ; call int 10h execute the writting to the screen
	inc [count_x] ; count_x++
	inc cx ; increase the position of the x pixel
	cmp [count_x],2h ; cmp the width for the line to 2h
	jne start_O_2 ; jump if the width isnt 2h, if not countinue drawwing more pixels
	
	mov [count_x],0h
	dec dx ; decrease the position of the y pixel
	
	start_O_3: 
	mov ah,0Ch ; enter wirriing pixel mode
	mov al,[red_color] ; set color to red
	mov bh,0h ; page =0
	int 10h ; call int 10h execute the writting to the screen
	dec dx ; decrease the position of the y pixel
	inc [count_x] ; count_x++
	inc cx ; increase x position of the pixel
	cmp [count_x] ,4h ; cmp the width for the line to 4h
	jne start_O_3 ;jump if the width isnt 4h, if not get new line

	mov [count_x],0h

	start_O_4: 
	mov ah,0Ch ; enter wirriing pixel mode
	mov al,[red_color] ; set color to red
	mov bh,0h ; page =0
	int 10h ; call int 10h execute the writting to the screen
	inc [count_y] ; count_y++
	dec dx ; increase the position of the y pixel
	cmp [count_y],2h ; cmp the width for the line to 2h
	jne start_O_4 ; jump if the width isnt 2h, if not countinue drawwing more pixels
	
	mov [count_y],0h
	inc cx ; increase the position of the x pixel

	start_O_5:
	mov ah,0Ch ; enter wirriing pixel mode
	mov al,[red_color] ; set color to red
	mov bh,0h ; page =0
	int 10h ; call int 10h execute the writting to the screen
	inc [count_y] ; count_y++
	dec dx ; decrease the position of the y pixel
	cmp [count_y],3h ; cmp the width for the line to 3h
	jne start_O_5 ; jump if the width isnt 3h, if not countinue drawwing more pixels
	
	mov [count_y],0h
	inc cx ; decrease the position of the y pixel

	start_O_6:
	mov ah,0Ch ; enter wirriing pixel mode
	mov al,[red_color] ; set color to red
	mov bh,0h ; page =0
	int 10h ; call int 10h execute the writting to the screen
	inc [count_y] ; count_y++
	dec dx ; decrease the position of the y pixel
	cmp [count_y],7h ; cmp the width for the line to 7h
	jne start_O_6 ; jump if the width isnt 7h, if not countinue drawwing more pixels
	
	mov [count_y],0h
	dec cx ; decrease the position of the x pixel

	start_O_7: 
	mov ah,0Ch ; enter wirriing pixel mode
	mov al,[red_color] ; set color to red
	mov bh,0h ; page =0
	int 10h ; call int 10h execute the writting to the screen
	inc [count_y] ; count_y++
	dec dx ; deccrease the position of the y pixel
	cmp [count_y],3h ; cmp the width for the line to 3h
	jne start_O_7 ; jump if the width isnt 3h, if not countinue drawwing more pixels

	mov [count_y],0h
	dec cx ; decrease the position of the y pixel
	
	start_O_8: 
	mov ah,0Ch ; enter wirriing pixel mode
	mov al,[red_color] ; set color to red
	mov bh,0h ; page =0
	int 10h ; call int 10h execute the writting to the screen
	inc [count_y] ; count_y++
	dec dx ; decrease the position of the y pixel
	cmp [count_y],2h ; cmp the width for the line to 2h
	jne start_O_8 ; jump if the width isnt 2h, if not countinue drawwing more pixels

	mov [count_y],0h
	dec cx ; decrease the position of the y pixel
	
	start_O_9: 
	mov ah,0Ch ; enter wirriing pixel mode
	mov al,[red_color] ; set color to red
	mov bh,0h ; page =0
	int 10h ; call int 10h execute the writting to the screen
	dec dx ; decrease the position of the y pixel
	inc [count_x] ; count_x++
	dec cx ; increase x position of the pixel
	cmp [count_x] ,4h ; cmp the width for the line to 4h
	jne start_O_9 ;jump if the width isnt 4h, if not get new line
	
	mov [count_x],0h
	
	start_O_10: 
	mov ah,0Ch ; enter wirriing pixel mode
	mov al,[red_color] ; set color to red
	mov bh,0h ; page =0
	int 10h ; call int 10h execute the writting to the screen
	inc [count_x] ; count_x++
	dec cx ; decrease the position of the y pixel
	cmp [count_x],2h ; cmp the width for the line to 2h
	jne start_O_10 ; jump if the width isnt 2h, if not countinue drawwing more pixels

	mov [count_x],0h
	dec dx ; decrease the position of the y pixel
	
	start_O_11: 
	mov ah,0Ch ; enter wirriing pixel mode
	mov al,[red_color] ; set color to red
	mov bh,0h ; page =0
	int 10h ; call int 10h execute the writting to the screen
	inc [count_x] ; count_x++
	dec cx ; decrease the position of the x pixel
	cmp [count_x],3h ; cmp the width for the line to 3h
	jne start_O_11 ; jump if the width isnt 3h, if not countinue drawwing more pixels

	mov [count_x],0h
	dec dx ; decrease the position of the y pixel
	
	start_O_12: 
	mov ah,0Ch ; enter wirriing pixel mode
	mov al,[red_color] ; set color to red
	mov bh,0h ; page =0
	int 10h ; call int 10h execute the writting to the screen
	inc [count_x] ; count_x++
	dec cx ; decrease the position of the x pixel
	cmp [count_x],7h ; cmp the width for the line to 7h
	jne start_O_12 ; jump if the width isnt 7h, if not countinue drawwing more pixels

	mov [count_x],0h
	inc dx ; increase the position of the x pixel
	
	start_O_13: 
	mov ah,0Ch ; enter wirriing pixel mode
	mov al,[red_color] ; set color to red
	mov bh,0h ; page =0
	int 10h ; call int 10h execute the writting to the screen
	inc [count_x] ; count_x++
	dec cx ; decrease the position of the x pixel
	cmp [count_x],3h ; cmp the width for the line to 3h
	jne start_O_13 ; jump if the width isnt 3h, if not countinue drawwing more pixels

	mov [count_x],0h
	inc dx ; increase the position of the x pixel
	
	start_O_14: 
	mov ah,0Ch ; enter wirriing pixel mode
	mov al,[red_color] ; set color to red
	mov bh,0h ; page =0
	int 10h ; call int 10h execute the writting to the screen
	inc [count_x] ; count_x++
	dec cx ; decrease the position of the x pixel
	cmp [count_x],2h ; cmp the width for the line to 2h
	jne start_O_14 ; jump if the width isnt 2h, if not countinue drawwing more pixels

	mov [count_x],0h
	inc dx ; decrease the position of the x pixel
	
	start_O_15: 
	mov ah,0Ch ; enter wirriing pixel mode
	mov al,[red_color] ; set color to red
	mov bh,0h ; page =0
	int 10h ; call int 10h execute the writting to the screen
	inc dx ; increase the position of the y pixel
	inc [count_x] ; count_x++
	dec cx ; decrease x position of the pixel
	cmp [count_x] ,4h ; cmp the width for the line to 4h
	jne start_O_15 ;jump if the width isnt 4h, if not get new line
	
	mov [count_x],0h
	
	start_O_16: 
	mov ah,0Ch ; enter wirriing pixel mode
	mov al,[red_color] ; set color to red
	mov bh,0h ; page =0
	int 10h ; call int 10h execute the writting to the screen
	inc [count_y] ; count_y++
	inc dx ; increase the position of the y pixel
	cmp [count_y],2h ; cmp the width for the line to 2h
	jne start_O_16 ; jump if the width isnt 2h, if not countinue drawwing more pixels
	
	mov [count_y],0h
	dec cx ; decrease the position of the x pixel
	
	start_O_17: 
	mov ah,0Ch ; enter wirriing pixel mode
	mov al,[red_color] ; set color to red
	mov bh,0h ; page =0
	int 10h ; call int 10h execute the writting to the screen
	inc [count_y] ; count_y++
	inc dx ; increase the position of the y pixel
	cmp [count_y],3h ; cmp the width for the line to 3h
	jne start_O_17 ; jump if the width isnt 3h, if not countinue drawwing more pixels
	
	mov [count_y],0h
	dec cx ; decrease the position of the x pixel
	
	start_O_18: 
	mov ah,0Ch ; enter wirriing pixel mode
	mov al,[red_color] ; set color to red
	mov bh,0h ; page =0
	int 10h ; call int 10h execute the writting to the screen
	inc [count_y] ; count_y++
	inc dx ; increase the position of the y pixel
	cmp [count_y],7h ; cmp the width for the line to 7h
	jne start_O_18 ; jump if the width isnt 7h, if not countinue drawwing more pixels
	
	mov [count_y],0h
	inc cx ; increase the position of the x pixel
	
	start_O_19: 
	mov ah,0Ch ; enter wirriing pixel mode
	mov al,[red_color] ; set color to red
	mov bh,0h ; page =0
	int 10h ; call int 10h execute the writting to the screen
	inc [count_y] ; count_y++
	inc dx ; increase the position of the y pixel
	cmp [count_y],3h ; cmp the width for the line to 3h
	jne start_O_19 ; jump if the width isnt 3h, if not countinue drawwing more pixels
	
	mov [count_y],0h
	inc cx ; increase the position of the x pixel
	
	start_O_20: 
	mov ah,0Ch ; enter wirriing pixel mode
	mov al,[red_color] ; set color to red
	mov bh,0h ; page =0
	int 10h ; call int 10h execute the writting to the screen
	inc [count_y] ; count_y++
	inc dx ; increase the position of the y pixel
	cmp [count_y],2h ; cmp the width for the line to 2h
	jne start_O_20 ; jump if the width isnt 2h, if not countinue drawwing more pixels
	
	mov [count_y],0h
	inc cx ; increase the position of the x pixel
	
	start_O_21: 
	mov ah,0Ch ; enter wirriing pixel mode
	mov al,[red_color] ; set color to red
	mov bh,0h ; page =0
	int 10h ; call int 10h execute the writting to the screen
	inc dx ; increase the position of the y pixel
	inc [count_x] ; count_x++
	inc cx ; increase x position of the pixel
	cmp [count_x] ,4h ; cmp the width for the line to 4h
	jne start_O_21 ;jump if the width isnt 4h, if not get new line
	
	mov [count_x],0h
	
	start_O_22: 
	mov ah,0Ch ; enter wirriing pixel mode
	mov al,[red_color] ; set color to red
	mov bh,0h ; page =0
	int 10h ; call int 10h execute the writting to the screen
	inc [count_y] ; count_y++
	inc cx ; increase the position of the x pixel
	cmp [count_y],2h ; cmp the width for the line to 2h
	jne start_O_22 ; jump if the width isnt 2h, if not countinue drawwing more pixels
	
	mov [count_y],0h
	inc dx ; decrease the position of the x pixel
	
	start_O_23:
	mov ah,0Ch ; enter wirriing pixel mode
	mov al,[red_color] ; set color to red
	mov bh,0h ; page =0
	int 10h ; call int 10h execute the writting to the screen
	inc [count_y] ; count_y++
	inc cx ; increase the position of the x pixel
	cmp [count_y],3h ; cmp the width for the line to 3h
	jne start_O_23 ; jump if the width isnt 3h, if not countinue drawwing more pixels

	mov [count_y],0h 
	mov [count_x],0h
	
	ret ; return to the main function
endp draw_O


proc break
	ret ; return to the main function
endp


proc position_1

	cmp [sqaure_pos_1], 0h ; if the sqaure is empty --> returning to the main function
	jne break_mid7
	cmp [player_turn], 0h ; checking if player X has the turn
	je position_1_X  ; if he does --> draw X , else --> draw O
	mov [sqaure_pos_1], 02h ; updating that the sqaure is unavailable
	; updating the position for drawing a circle in sqaure 1
	mov [position_X], 64h 
	mov [position_Y], 4Ah
	jmp drawing_o
	
	position_1_X:
	mov [sqaure_pos_1], 01h ; updating that the sqaure is unavailable
	; updating the position for drawing a X in sqaure 1
	mov [position_X], 57h
	mov [position_Y], 4Ch
	mov [position_Y_1], 2Dh 
	jmp drawing_x
	ret ; return to the main function
	
	break_mid7:
	jmp break
endp


proc position_2

	cmp [sqaure_pos_2], 0h ; if the sqaure is empty --> returning to the main function
	jne break_mid8
	cmp [player_turn], 0h ; checking if player X has the turn
	je position_2_X ; if he does --> draw X , else --> draw O
	mov [sqaure_pos_2], 02h ; updating that the sqaure is unavailable
	; updating the position for drawing a circle in sqaure 2
	mov [position_X], 8Fh
	mov [position_Y], 4Ah
	jmp drawing_o
	
	position_2_X:
	; updating the position 
	mov [sqaure_pos_2], 01h ; updating that the sqaure is unavailable
	; updating the position for drawing a X in sqaure 2
	mov [position_X], 82h
	mov [position_Y], 4Ch
	mov [position_Y_1], 2Dh 
	jmp drawing_x
	ret ; return to the main function
	
	break_mid8:
	jmp break
endp


proc position_3

	cmp [sqaure_pos_3], 0h ; if the sqaure is empty --> returning to the main function
	jne break_mid
	cmp [player_turn], 0h ; checking if player X has the turn
	je position_3_X ; if he does --> draw X 
	; else --> draw O
	; updating the position for drawing a circle in sqaure 3
	mov [position_X], 189
	mov [position_Y], 4Ah
	mov [sqaure_pos_3], 02h ; updating that the sqaure is unavailable
	jmp drawing_o
	
	position_3_X:
	; updating the position for drawing a X in sqaure 3
	mov [position_X], 177
	mov [position_Y], 4Ch
	mov [position_Y_1], 2Dh 
	mov [sqaure_pos_3], 01h ; updating that the sqaure is unavailable
	jmp drawing_x	
	ret ; return to the main function
	
	break_mid:
	jmp break
endp


proc position_4

	cmp [sqaure_pos_4], 0h ; if the sqaure is empty --> returning to the main function
	jne break_mid1 
	cmp [player_turn], 0h ; checking if player X has the turn
	je position_4_X ; if he does --> draw X 
	; else --> draw O
	; updating the position for drawing a circle in sqaure 4
	mov [position_X], 64h
	mov [position_Y], 75h
	mov [sqaure_pos_4], 02h ; updating that the sqaure is unavailable
	jmp drawing_o
	
	position_4_X:
	; updating the position for drawing a X in sqaure 4
	mov [position_X], 57h
	mov [position_Y], 77h
	mov [position_Y_1], 58h 
	mov [sqaure_pos_4], 01h ; updating that the sqaure is unavailable
	jmp drawing_x
	ret ; return to the main function
	
	break_mid1:
	jmp break
endp


proc position_5

	cmp [sqaure_pos_5], 0h ; if the sqaure is empty --> returning to the main function
	jne break_mid2
	cmp [player_turn], 0h ; checking if player X has the turn
	je position_5_X ; if he does --> draw X 
	; else --> draw O
	; updating the position for drawing a circle in sqaure 5
	mov [position_X], 8Fh
	mov [position_Y], 75h
	mov [sqaure_pos_5], 02h ; updating that the sqaure is unavailable
	jmp drawing_o
	
	position_5_X:
	; updating the position for drawing a X in sqaure 5
	mov [position_X], 82h
	mov [position_Y], 77h
	mov [position_Y_1], 58h 
	mov [sqaure_pos_5], 01h ; updating that the sqaure is unavailable
	jmp drawing_x
	ret ; return to the main function
	
	break_mid2:
	jmp break
endp

proc position_6

	cmp [sqaure_pos_6], 0h ; if the sqaure is empty --> returning to the main function
	jne break_mid3
	cmp [player_turn], 0h ; checking if player X has the turn
	je position_6_X ; if he does --> draw X 
	; else --> draw O
	; updating the position for drawing a circle in sqaure 6
	mov [position_X], 189
	mov [position_Y], 75h
	mov [sqaure_pos_6], 02h ; updating that the sqaure is unavailable
	jmp drawing_o
	
	position_6_X:
	; updating the position for drawing a X in sqaure 6
	mov [position_X], 177
	mov [position_Y], 77h
	mov [position_Y_1], 58h 
	mov [sqaure_pos_6], 01h ; updating that the sqaure is unavailable
	jmp drawing_x
	ret ; return to the main function
	
	break_mid3:
	jmp break
endp


proc position_7

	cmp [sqaure_pos_7], 0h ; if the sqaure is empty --> returning to the main function
	jne break_mid4
	cmp [player_turn], 0h ; checking if player X has the turn
	je position_7_X ; if he does --> draw X 
	; else --> draw O
	; updating the position for drawing a circle in sqaure 7
	mov [position_X], 64h
	mov [position_Y], 162
	mov [sqaure_pos_7], 02h ; updating that the sqaure is unavailable
	jmp drawing_o
	
	position_7_X:
	; updating the position for drawing a X in sqaure 7
	mov [position_X], 57h
	mov [position_Y], 162
	mov [position_Y_1], 84h 
	mov [sqaure_pos_7], 01h ; updating that the sqaure is unavailable
	jmp drawing_x
	ret ; return to the main function
	
	break_mid4:
	jmp break
endp


proc position_8

	cmp [sqaure_pos_8], 0h ; if the sqaure is empty --> returning to the main function
	jne break_mid5 
	cmp [player_turn], 0h ; checking if player X has the turn
	je position_8_X ; if he does --> draw X 
	; else --> draw O
	; updating the position for drawing a circle in sqaure 8
	mov [position_X], 8Fh
	mov [position_Y], 162
	mov [sqaure_pos_8], 02h ; updating that the sqaure is unavailable
	jmp drawing_o
	
	position_8_X:
	; updating the position for drawing a X in sqaure 8
	mov [position_X], 82h
	mov [position_Y], 162
	mov [position_Y_1], 84h 
	mov [sqaure_pos_8], 01h ; updating that the sqaure is unavailable
	jmp drawing_x
	
	ret ; return to the main function
	
	break_mid5:
	jmp break
endp


proc position_9

	cmp [sqaure_pos_9], 0h ; if the sqaure is empty --> returning to the main function
	jne break_mid6
	cmp [player_turn], 0h ; checking if player X has the turn
	je position_9_X ; if he does --> draw X 
	; else --> draw O
	; updating the position for drawing a circle in sqaure 9
	mov [position_X], 189
	mov [position_Y], 162
	mov [sqaure_pos_9], 02h ; updating that the sqaure is unavailable
	jmp drawing_o
	
	position_9_X:
	; updating the position for drawing a X in sqaure 9
	mov [position_X], 177
	mov [position_Y], 162
	mov [position_Y_1], 84h 
	mov [sqaure_pos_9], 01h ; updating that the sqaure is unavailable
	jmp drawing_x
	ret ; return to the main function
	
	break_mid6:
	jmp break
endp


proc drawing_x

	call draw_x  ; drawing a X
	mov [player_turn], 01h ; switiching the turn to the O player
	ret
	
endp
	
	
proc drawing_o

	call draw_O ; drawing a circle
	mov [player_turn], 0h ; switiching the turn to the X player
	ret
	
endp
	
	
proc player_turnn
	
	; checking if any key is being pressed
	mov ah, 01h
	int 16h
	jz end_read

	; checking which key is being pressed from 1-9
	mov ah, 0h
	int 16h
	
	cmp al, 31h ; comparing the input to the number 1
	je position_1_mid
	
	cmp al, 32h ; comparing the input to the number 2
	je position_2_mid
	
	cmp al, 33h ; comparing the input to the number 3
	je position_3_mid

	cmp al, 34h ; comparing the input to the number 4
	je position_4_mid
	
	cmp al, 35h ; comparing the input to the number 5
	je position_5_mid
	
	cmp al, 36h ; comparing the input to the number 6
	je position_6_mid
	
	cmp al, 37h ; comparing the input to the number 7
	je position_7_mid
	
	cmp al, 38h ; comparing the input to the number 8
	je position_8_mid
	
	cmp al, 39h ; comparing the input to the number 9
	je position_9_mid
	
	; middle labels
	position_1_mid:
	jmp position_1
	
	position_2_mid:
	jmp position_2
	
	position_3_mid:
	jmp position_3
	
	position_4_mid:
	jmp position_4
	
	position_5_mid:
	jmp position_5
	
	position_6_mid:
	jmp position_6
	
	position_7_mid:
	jmp position_7
	
	position_8_mid:
	jmp position_8
	
	position_9_mid:
	jmp position_9
	
	end_read:
	
	ret ; return to the main function
endp player_turnn


proc draw 
	; the function checks if there is a draw in the game, if there is --> print on the screen that there is a draw
	cmp [sqaure_pos_1], 0h
	je endd
	
	cmp [sqaure_pos_2], 0h
	je endd
	
	cmp [sqaure_pos_3], 0h
	je endd
	
	cmp [sqaure_pos_4], 0h
	je endd
	
	cmp [sqaure_pos_5], 0h
	je endd
	
	cmp [sqaure_pos_6], 0h
	je endd
	
	cmp [sqaure_pos_7], 0h
	je endd
	
	cmp [sqaure_pos_8], 0h
	je endd
	
	cmp [sqaure_pos_9], 0h
	je endd
	
	cmp [game_status], 02h
	je endd
	
	mov [game_status], 02h ; updating the game status to the end screen
	
	; draw text
	mov ah,2h ; config to cursor 
	mov bh,0h ;set page 0 on screen
	mov dh,16h ;set row to 16h
	mov dl,2h ;set Column to 2h
	int 10h
		
	mov ah,9h ;Write character and attribute at cursor position
	lea dx,[text_draw] ;make dx as pointer to the text 
	int 21h
	
	endd:
	ret
endp draw

proc win_O

	mov [game_status], 02h ; updating the game status to the end screen
	
	; " O player has won!!" text
	
	mov ah,2h ; config to cursor 
	mov bh,0h ;set page 0 on screen
	mov dh,16h;set row to 16h
	mov dl,4h ;set Column to 4h
	int 10h
		
	mov ah,9h	;Write character and attribute at cursor position
	lea dx,[text_O_winner] ;make dx as pointer to the text 
	int 21h
	ret
	
endp win_O


proc check_win_O
	; 123 check --> O
	cmp [sqaure_pos_1], 02h
	jne continue8

	cmp [sqaure_pos_2], 02h
	jne continue8
	
	cmp [sqaure_pos_3], 02h
	je win_O
	
	continue8:
	; 456 check --> O
	cmp [sqaure_pos_4], 02h
	jne continue9

	cmp [sqaure_pos_5], 02h
	jne continue9
	
	cmp [sqaure_pos_6], 02h
	je win_O_mid
	
	continue9:
	; 789 check --> O
	cmp [sqaure_pos_7], 02h
	jne continue10

	cmp [sqaure_pos_8], 02h
	jne continue10
	
	cmp [sqaure_pos_9], 02h
	je win_O_mid
	
	continue10:
	; 147 check --> O
	cmp [sqaure_pos_1], 02h
	jne continue11

	cmp [sqaure_pos_4], 02h
	jne continue11
	
	cmp [sqaure_pos_7], 02h
	je win_O_mid
	
	continue11:
	; 258 check --> O
	cmp [sqaure_pos_2], 02h
	jne continue12

	cmp [sqaure_pos_5], 02h
	jne continue12
	
	cmp [sqaure_pos_8], 02h
	je win_O_mid
	
	continue12:
	; 369 check --> O
	cmp [sqaure_pos_3], 02h
	jne continue13

	cmp [sqaure_pos_6], 02h
	jne continue13
	
	cmp [sqaure_pos_9], 02h
	je win_O_mid
	
	continue13:
	; 159 check --> O
	cmp [sqaure_pos_1], 02h
	jne continue14

	cmp [sqaure_pos_5], 02h
	jne continue14
	
	cmp [sqaure_pos_9], 02h
	je win_O_mid
	
	continue14:
	; 357 check --> O
	cmp [sqaure_pos_3], 02h
	jne continue15

	cmp [sqaure_pos_5], 02h
	jne continue15
	
	cmp [sqaure_pos_7], 02h
	je win_O_mid
	
	continue15:
	ret
	
	win_O_mid:
	call win_O
	ret
	
endp check_win_O


proc win_X

	mov [game_status], 02h ; updating the game status to the end screen
	
	; " X player has won!!" text	
	mov ah,2h ; config to cursor 
	mov bh,0h ;set page 0 on screen
	mov dh,16h;set row to 16h
	mov dl,3h ;set Column to 3h
	int 10h
		
	mov ah,9h ;Write character and attribute at cursor position
	lea dx,[text_X_winner] ;make dx as pointer to the text
	int 21h
	ret
	
endp win_X


proc check_win_X

	; 123 check --> X
	cmp [sqaure_pos_1], 01h
	jne continue

	cmp [sqaure_pos_2], 01h
	jne continue
	
	cmp [sqaure_pos_3], 01h
	je win_X
	
	continue:
	; 456 check --> X
	cmp [sqaure_pos_4], 01h
	jne continue1

	cmp [sqaure_pos_5], 01h
	jne continue1
	
	cmp [sqaure_pos_6], 01h
	je win_mid
	
	continue1:
	; 789 check --> X
	cmp [sqaure_pos_7], 01h
	jne continue2

	cmp [sqaure_pos_8], 01h
	jne continue2
	
	cmp [sqaure_pos_9], 01h
	je win_mid
	
	continue2:
	; 147 check --> X
	cmp [sqaure_pos_1], 01h
	jne continue3

	cmp [sqaure_pos_4], 01h
	jne continue3
	
	cmp [sqaure_pos_7], 01h
	je win_mid
	
	continue3:
	; 258 check --> X
	cmp [sqaure_pos_2], 01h
	jne continue4

	cmp [sqaure_pos_5], 01h
	jne continue4
	
	cmp [sqaure_pos_8], 01h
	je win_mid
	
	continue4:
	; 369 check --> X
	cmp [sqaure_pos_3], 01h
	jne continue5

	cmp [sqaure_pos_6], 01h
	jne continue5
	
	cmp [sqaure_pos_9], 01h
	je win_mid
	
	continue5:
	; 159 check --> X
	cmp [sqaure_pos_1], 01h
	jne continue6

	cmp [sqaure_pos_5], 01h
	jne continue6
	
	cmp [sqaure_pos_9], 01h
	je win_mid
	
	continue6:
	; 357 check --> X
	cmp [sqaure_pos_3], 01h
	jne continue7

	cmp [sqaure_pos_5], 01h
	jne continue7
	
	cmp [sqaure_pos_7], 01h
	je win_mid
	
	continue7:
	ret
	
	win_mid:
	call win_X
	ret
	
	
endp check_win_X


proc end_screen
	
	; exit text
	mov ah,2h ; config to cursor 
	mov bh,0h ;set page 0 on screen
	mov dh,1h;set row to 1h
	mov dl,2h ;set Column to 2h
	int 10h
		
	mov ah,9h ;Write character and attribute at cursor position
	lea dx,[text_end_game_e] ;make dx as pointer to the text 
	int 21h
	
	; reset text
	mov ah,2h ; config to cursor 
	mov bh,0h ;set page 0 on screen
	mov dh,2h;set row to 2h
	mov dl,2h ;set Column to 2h
	int 10h
		
	mov ah,9h ;Write character and attribute at cursor position
	lea dx,[text_end_game_r] ;make dx as pointer to the text 
	int 21h
	
	; if e \ E are being pressed --> exit the game 
	; if r \ R are being pressed --> restart the game
	; checking if any key is being pressed
	mov ah, 01h
	int 16h
	jz end_readd1

	; checking which key is being pressed 
	mov ah, 0h
	int 16h
	
	cmp al, 65h ; comparing the input to 'e'
	je exitt

	
	cmp al, 45h ; comparing the input to 'E'
	je exitt
	
	
	cmp al, 72h ; comparing the input to 'r'
	je reset

	
	cmp al, 52h ; comparing the input to 'R'
	je reset
	
	ret
	
	reset:
	; rest variables
	mov [sqaure_pos_1], 0h 
	mov [sqaure_pos_2], 0h 
	mov [sqaure_pos_3], 0h 
	mov [sqaure_pos_4], 0h 
	mov [sqaure_pos_5], 0h 
	mov [sqaure_pos_6], 0h 
	mov [sqaure_pos_7], 0h 
	mov [sqaure_pos_8], 0h 
	mov [sqaure_pos_9], 0h 
	mov [player_turn], 0h
	
	call clearscreen ; clear screen
	mov [game_status], 0h ; update the game status to the start screen 
	
	ret
	
	exitt:
	jmp exit ; exit the game
	
	
	end_readd1:
	ret
endp end_screen 


proc start_screen

	; print the name of the game - tic tac toe
	mov ah,2h ; config to cursor 
	mov bh,0h ;set page 0 on screen
	mov dh,6h;set row to 6h
	mov dl,4h ;set Column to 4h
	int 10h
		
	mov ah,9h ;Write character and attribute at cursor position
	lea dx,[text_game_name] ;make dx as pointer to the text 
	int 21h
	
	; print the menue
	mov ah,2h ; config to cursor 
	mov bh,0h ;set page 0 on screen
	mov dh,10h;set row to 10
	mov dl,0h ;set Column to 0
	int 10h
		
	mov ah,9h ;Write character and attribute at cursor position
	lea dx,[text_start_game] ;make dx as pointer to the text 
	int 21h
	
	; checking if "Enter" is being pressed, if it does --> start the game
	; checking if any key is being pressed
	mov ah, 01h
	int 16h
	jz end_readd

	; checking which key is being pressed 
	mov ah, 0h
	int 16h
	
	cmp al, 20h ; comparing the input to "Enter"
	jne end_readd
	
	call clearscreen ; clear the screen
	mov [game_status], 01h ; update the game status to running the game 

	end_readd:
	ret
	
endp start_screen 

;main function
start:
	mov ax, @data
	mov ds, ax
	mov ax,13h
	int 10h
	; the time for the game
	time:
	mov ah, 2Ch
	int 21h
	cmp [time_change], dl
	je time
	
	mov [time_change], dl
	
	; check what's the status of the game
	cmp [game_status], 1h 
	je start_game
	
	cmp [game_status], 2h
	je end_game
	
	call start_screen
	jmp time
	
end_game: ; end the game
	call end_screen
	jmp time
	
start_game: ; start the game

	call draw_line_x_left
	call draw_line_x_right
	call draw_line_x_up
	call draw_line_x_down
	call draw_sqaure
	call player_turnn
	call check_win_O
	call check_win_X
	call draw

jmp time

; --------------------------
exit:
	mov ax, 4c00h
	int 21h
END start

