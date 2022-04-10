	; Entry point	
	global main
	
	; Imports
	extern printf

	section .text

main:
	push rbp
	mov  rbp, rsp

	mov  rdi, narrow_string
	mov  rsi, 0
	call my_strlen

	; output
	mov  rdi, format
	mov  rsi, narrow
	mov  rdx, rax
	call printf
	
	mov  rdi, wide_string
	mov  rsi, 1
	call my_strlen

	; output
	mov  rdi, format
	mov  rsi, wide
	mov  rdx, rax
	call printf
	
	xor  rax, rax

	mov  rsp, rbp
	pop  rbp
	ret

my_strlen:
	;
	; Use cdecl calling convention:
	;  rdi - first parameter (string pointer)
	;  rsi - second parameter (is_wide flag)
	;  rax - return value
	;

	; function prologue
	push rbp
	mov  rbp, rsp

	; zero rax
	xor  rax, rax
	
	; check if we got a wide or narrow string
	test rsi, rsi
	jnz  wide_processing

narrow_processing:
	cmp  byte [rdi], 0
	je   exit
	inc  rdi
	inc  rax
	jmp  narrow_processing
	
wide_processing:
	cmp  word [rdi], 0
	je   exit
	add  rdi, 2
	inc  rax
	jmp  wide_processing

exit:
	; function epilogue
	mov  rsp, rbp
	pop  rbp
	ret


	section .data

format:        db "%s string length is %zu", 0x0d, 0x0a, 0
wide:          db "Wide", 0
narrow:        db "Narrow", 0
narrow_string: db "Hello", 0
wide_string:   dw "w", "o", "r", "l", "d", 0
