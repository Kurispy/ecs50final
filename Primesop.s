	.file	"Primes.c"
	.text
	.globl	crossout
	.type	crossout, @function
crossout:
.LFB48:
	.cfi_startproc
	pushl	%edi
	.cfi_def_cfa_offset 8
	.cfi_offset 7, -8
	pushl	%esi
	.cfi_def_cfa_offset 12
	.cfi_offset 6, -12
	pushl	%ebx
	.cfi_def_cfa_offset 16
	.cfi_offset 3, -16
	movl	16(%esp), %esi
	leal	(%esi,%esi,2), %eax
	movl	n, %ebx
	cmpl	%ebx, %eax
	jg	.L1
	movl	%eax, %edx
	leal	(%esi,%esi), %edi
	leal	(%esi,%esi,4), %eax
	negl	%esi
	addl	%esi, %esi
.L3:
	movl	$0, prime(,%edx,4)
	movl	%eax, %edx
	addl	%edi, %eax
	leal	(%eax,%esi), %ecx
	cmpl	%ecx, %ebx
	jge	.L3
.L1:
	popl	%ebx
	.cfi_restore 3
	.cfi_def_cfa_offset 12
	popl	%esi
	.cfi_restore 6
	.cfi_def_cfa_offset 8
	popl	%edi
	.cfi_restore 7
	.cfi_def_cfa_offset 4
	ret
	.cfi_endproc
.LFE48:
	.size	crossout, .-crossout
	.globl	worker
	.type	worker, @function
worker:
.LFB49:
	.cfi_startproc
	pushl	%edi
	.cfi_def_cfa_offset 8
	.cfi_offset 7, -8
	pushl	%esi
	.cfi_def_cfa_offset 12
	.cfi_offset 6, -12
	pushl	%ebx
	.cfi_def_cfa_offset 16
	.cfi_offset 3, -16
	subl	$32, %esp
	.cfi_def_cfa_offset 48
	fildl	n
	fsqrt
	fucomi	%st(0), %st
	jnp	.L7
	fstp	%st(0)
	fildl	n
	fstpl	(%esp)
	call	sqrt
.L7:
	fnstcw	30(%esp)
	movzwl	30(%esp), %eax
	movb	$12, %ah
	movw	%ax, 28(%esp)
	fldcw	28(%esp)
	fistpl	24(%esp)
	fldcw	30(%esp)
	movl	24(%esp), %esi
	movl	$0, %edi
.L14:
	movl	$nextbaselock, (%esp)
	call	pthread_mutex_lock
	movl	nextbase, %ebx
	leal	2(%ebx), %edx
	movl	%edx, nextbase
	movl	$nextbaselock, (%esp)
	call	pthread_mutex_unlock
	cmpl	%ebx, %esi
	jl	.L9
	cmpl	$0, prime(,%ebx,4)
	je	.L14
	movl	%ebx, (%esp)
	call	crossout
	addl	$1, %edi
	jmp	.L14
.L9:
	movl	%edi, %eax
	addl	$32, %esp
	.cfi_def_cfa_offset 16
	popl	%ebx
	.cfi_restore 3
	.cfi_def_cfa_offset 12
	popl	%esi
	.cfi_restore 6
	.cfi_def_cfa_offset 8
	popl	%edi
	.cfi_restore 7
	.cfi_def_cfa_offset 4
	ret
	.cfi_endproc
.LFE49:
	.size	worker, .-worker
	.section	.rodata.str1.1,"aMS",@progbits,1
.LC1:
	.string	"%d values of base done\n"
	.section	.rodata.str1.4,"aMS",@progbits,1
	.align 4
.LC2:
	.string	"the number of primes found was %d\n"
	.text
	.globl	main
	.type	main, @function
main:
.LFB50:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	pushl	%esi
	pushl	%ebx
	andl	$-16, %esp
	subl	$32, %esp
	.cfi_offset 6, -12
	.cfi_offset 3, -16
	movl	12(%ebp), %ebx
	movl	4(%ebx), %eax
	movl	%eax, (%esp)
	call	atoi
	movl	%eax, n
	movl	8(%ebx), %eax
	movl	%eax, (%esp)
	call	atoi
	movl	%eax, nthreads
	movl	n, %ecx
	cmpl	$2, %ecx
	jle	.L17
	movl	$3, %eax
.L20:
	testb	$1, %al
	setne	%dl
	movzbl	%dl, %edx
	movl	%edx, prime(,%eax,4)
	addl	$1, %eax
	cmpl	%ecx, %eax
	jle	.L20
.L17:
	movl	$3, nextbase
	cmpl	$0, nthreads
	jle	.L21
	movl	$0, %ebx
.L22:
	movl	%ebx, 12(%esp)
	movl	$worker, 8(%esp)
	movl	$0, 4(%esp)
	leal	id(,%ebx,4), %eax
	movl	%eax, (%esp)
	call	pthread_create
	addl	$1, %ebx
	movl	nthreads, %eax
	cmpl	%ebx, %eax
	jg	.L22
	testl	%eax, %eax
	jle	.L21
	movl	$0, %ebx
	leal	28(%esp), %esi
.L23:
	movl	%esi, 4(%esp)
	movl	id(,%ebx,4), %eax
	movl	%eax, (%esp)
	call	pthread_join
	movl	28(%esp), %eax
	movl	%eax, 8(%esp)
	movl	$.LC1, 4(%esp)
	movl	$1, (%esp)
	call	__printf_chk
	addl	$1, %ebx
	cmpl	%ebx, nthreads
	jg	.L23
.L21:
	movl	n, %ecx
	cmpl	$2, %ecx
	jle	.L27
	movl	$3, %eax
	movl	$1, %edx
.L26:
	cmpl	$1, prime(,%eax,4)
	sbbl	$-1, %edx
	addl	$1, %eax
	cmpl	%ecx, %eax
	jle	.L26
	jmp	.L24
.L27:
	movl	$1, %edx
.L24:
	movl	%edx, 8(%esp)
	movl	$.LC2, 4(%esp)
	movl	$1, (%esp)
	call	__printf_chk
	leal	-8(%ebp), %esp
	popl	%ebx
	.cfi_restore 3
	popl	%esi
	.cfi_restore 6
	popl	%ebp
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE50:
	.size	main, .-main
	.comm	id,100,32
	.globl	nextbaselock
	.bss
	.align 4
	.type	nextbaselock, @object
	.size	nextbaselock, 24
nextbaselock:
	.zero	24
	.comm	nextbase,4,4
	.comm	prime,400000004,32
	.comm	n,4,4
	.comm	nthreads,4,4
	.ident	"GCC: (Ubuntu/Linaro 4.7.2-2ubuntu1) 4.7.2"
	.section	.note.GNU-stack,"",@progbits
