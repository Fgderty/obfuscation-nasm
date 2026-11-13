%define SYS_WRITE	0x01
%define SYS_EXIT	0x3C
%define SYS_PTRACE	0x65

%define PTRACE_TRACEME	0x00

%define STD_OUT		0x01

default ABS

section .rodata
	msg_clean db "Clean", 0x0A
	len_clean equ $ - msg_clean
 
	msg_debug db "Debugger detected!", 0x0A
	len_debug equ $ - msg_debug

section .text
global _start

_start:
	;ptrace(request, pid, addr, data)
	mov rax, SYS_PTRACE
	mov rdi, PTRACE_TRACEME
	xor esi, esi
	xor edx, edx
	xor r10d, r10d
	syscall

	test rax, rax
	js .debug_found

.clean:
	;write(fd, buffer, count)
	mov rax, SYS_WRITE
	mov rdi, STD_OUT
	lea rsi, [msg_clean]
	mov rdx, len_clean
	syscall

	;exit(status)
	mov rax, SYS_EXIT
	xor edi, edi
	syscall

.debug_found:
	;write(fd, buffer, count)
	mov rax, SYS_WRITE
	mov rdi, STD_OUT
	lea rsi, [msg_debug]
	mov rdx, len_debug
	syscall

	;exit(status)
	mov rax, SYS_EXIT
	mov edi, 0x01
	syscall
