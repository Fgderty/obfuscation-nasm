section .text
global _start

_start:
	;execve(pathname, args, envp)
	push 0x3B
	pop rax

	call rdis
	db "/bin/sh", 0x00

rdis:
	pop rdi
	xor esi, esi
	xor edx, edx
	syscall

	;exit(status)
	push 0x3C
	pop rax

	xor edi, edi
	syscall
