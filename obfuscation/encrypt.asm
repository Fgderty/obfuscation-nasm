default ABS

section .rodata
	encrypted_msg db 0x0A, 0x27, 0x2E, 0x2E, 0x2D, 0x48, 0x00
	key equ 0x42

section .bss
	buffer resb 0x07

section .text
global _start

_start:
	lea rsi, [encrypted_msg]
	lea rdi, [buffer]
	mov rcx, 0x06

.decrypted_loop:
	lodsb
	xor al, key
	stosb
	dec rcx
	jnz .decrypted_loop

;write()
	mov rax, 0x01
	mov rdi, 0x01
	lea rsi, [buffer]
	mov rdx, 0x06
	syscall

;exit()
	mov rax, 0x3C
	xor rdi, rdi
	syscall
