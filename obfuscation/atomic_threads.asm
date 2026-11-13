default rel

%define SYS_CLONE	0x38
%define THREAD_FLAGS	0x10F00
%define SYS_WRITE	0x01
%define SYS_EXIT	0x3C
%define SYS_NANOSLEEP	0x23

%define STD_OUT		0x01

%define ITERATIONS	0x0F4240

section .rodata

	timespec:
		dq 0x00
		dq 200000000

section .bss
	counter resq 0x00
	thread_stack resb 0x1000
	out_buffer resb 0x20

section .text
global _start

_start:
	;clone(ptr_func, stack, flags, arg, pid, tls)
	mov rax, SYS_CLONE
	lea rsi, [thread_stack + 0x1000]
	mov rdi, THREAD_FLAGS
	xor edx, edx
	xor r8d, r8d
	xor r9d, r9d
	syscall

	test eax, eax
	js .exit_error
	jz thread_func

	mov rcx, ITERATIONS
.main_loop:
	lock inc qword [counter]
	dec rcx
	jnz .main_loop

	;nanosleep(req, rem)
	mov rax, SYS_NANOSLEEP
	lea rdi, [timespec]
	xor esi, esi
	syscall

	mov rax, [counter]
	call print_unit

	;exit(0)
	mov rax, SYS_EXIT
	xor edi, edi
	syscall

.exit_error:
	;exit(1)
	mov rax, SYS_EXIT
	xor edi, edi
	inc edi
	syscall

thread_func:
	mov rcx, ITERATIONS
.thread_loop:
	lock inc qword [counter]
	dec rcx
	jnz .thread_loop

	;exit(0)
	mov rax, SYS_EXIT
	xor edi, edi
	syscall

print_unit:
	lea rdi, [out_buffer + 0x19]
	mov byte [rdi], 0x0A
	dec rdi
	mov rbx, 0x0A
	xor ecx, ecx

.convert_loop:
	xor edx, edx
	div rbx
	add dl, 0x30
	mov [rdi], dl
	dec rdi
	inc rcx
	test rax, rax
	jnz .convert_loop

	;write(fd, buf, count)
	lea rsi, [rdi + 0x01]
	lea rdx, [rcx + 0x01]
	mov rax, SYS_WRITE
	mov edi, STD_OUT
	syscall
	ret


