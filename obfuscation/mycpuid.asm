%define SYS_WRITE	0x01
%define STD_OUT		0x01
%define SYS_EXIT	0x3C

section .rodata
	yes db "Yes", 0x0A, 0x00
	ly equ $ - yes

	no db "No", 0x0A, 0x00
	ln equ $ - no

section .text
global _start

_start:
	mov eax, 0x07
	mov ecx, 0x00
	cpuid

	test ebx, 1 << 5
	jz yes_b

no_b:
	;write(fd, buffer, count)
        mov rax, 0x01
        mov rdi, 0x01
        mov rsi, no
        mov rdx, ln
        syscall
	jmp exit

yes_b:
	;write(fd, buffer, count)
	mov rax, 0x01
	mov rdi, 0x01
	mov rsi, yes
	mov rdx, ly
	syscall

exit:
	;exit(status)
	mov rax, 0x3C
	mov rdi, 0x00
	syscall
