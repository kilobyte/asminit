.globl _start
.data
nopid1:	.ascii "No pid 1, no fun.\n"
command: .ascii "/etc/init.d/rcS\0"
norc: .ascii "Starting /etc/init.d/rcS failed!\n"
.text
_start:
	mov	$39, %rax	# getpid
	syscall
	cmp	$1, %rax
	je	pid1
	mov	$1, %rax	# write
	mov	$1, %rdi
	mov	$nopid1, %rsi
	mov	$18, %rdx
	syscall
	mov	$60, %rax	# _exit
	mov	$1, %rdi
	syscall
pid1:
	mov	$57, %rax	# fork
	syscall
	cmp	$0, %rax
	jne	child
parent:
	mov	$61, %rax	# wait4
	mov	$-1, %rdi
	xor	%rsi, %rsi
	xor	%rdx, %rdx
	syscall
	jmp	parent
child:
	mov	$59, %rax	# execve
	mov	$command, %rdi
	xor	%rsi, %rsi
	xor	%rdx, %rdx
	syscall
	mov	$1, %rax	# write
	mov	$1, %rdi
	mov	$norc, %rsi
	mov	$34, %rdx
	syscall
	mov	$60, %rax	# _exit
	mov	$1, %rdi
	syscall
