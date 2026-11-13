section .text
global _start

_start:
	rdtsc
	mov r9, rax

	mov rcx, 0x10000000

.loop:
	dec rcx
	jnz .loop

	lfence
	rdtsc

	sub eax, r9d

	cmp eax, 300000000
	ja .debugger_found

	;exit(status)
	mov rax, 0x3C
	syscall

.debugger_found:
	;exit(status)
    mov rax, 0x3C
    syscall

