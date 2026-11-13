default rel

%define SYS_WRITE	0x01
%define STD_OUT		0x01

%define SYS_EXIT	0x3C
%define STATUS		0x00 

section .text
global _start

_start:
	call back
	db "Hi!", 0x0A

back:
	;write(fd, buffer, count)
	pop rsi

	xor eax, eax
	inc eax

	xor edi, edi
	inc edi

	push 0x04
	pop rdx

	syscall

	;exit(status)
	push 0x3C
	pop rax

	xor edi, edi

	syscall
