	.file	"Primes.c"
	.comm	nthreads,4,4
	.comm	n,4,4
	.comm	prime,400000004,32
	.comm	nextbase,4,4
	.globl	nextbaselock
	.bss
	.align 4
	.type	nextbaselock, @object
	.size	nextbaselock, 24
nextbaselock:
	.zero	24
	.comm	id,100,32
	.text
	.globl	crossout
	.type	crossout, @function
crossout:
.LFB0:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$16, %esp
	movl	$3, -4(%ebp)
	jmp	.L2
.L3:
	movl	-4(%ebp), %eax
	imull	8(%ebp), %eax
	movl	$0, prime(,%eax,4)
	addl	$2, -4(%ebp)
.L2:
	movl	-4(%ebp), %eax
	movl	%eax, %edx
	imull	8(%ebp), %edx
	movl	n, %eax
	cmpl	%eax, %edx
	jle	.L3
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE0:
	.size	crossout, .-crossout
	.globl	worker
	.type	worker, @function
worker:
.LFB1:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$56, %esp
	movl	$0, -20(%ebp)
	movl	n, %eax
	movl	%eax, -28(%ebp)
	fildl	-28(%ebp)
	fstpl	(%esp)
	call	sqrt
	fnstcw	-30(%ebp)
	movzwl	-30(%ebp), %eax
	movb	$12, %ah
	movw	%ax, -32(%ebp)
	fldcw	-32(%ebp)
	fistpl	-16(%ebp)
	fldcw	-30(%ebp)
	jmp	.L8
.L9:
	nop
.L8:
	movl	$nextbaselock, (%esp)
	call	pthread_mutex_lock
	movl	nextbase, %eax
	movl	%eax, -12(%ebp)
	movl	nextbase, %eax
	addl	$2, %eax
	movl	%eax, nextbase
	movl	$nextbaselock, (%esp)
	call	pthread_mutex_unlock
	movl	-12(%ebp), %eax
	cmpl	-16(%ebp), %eax
	jg	.L5
	movl	-12(%ebp), %eax
	movl	prime(,%eax,4), %eax
	testl	%eax, %eax
	je	.L9
	movl	-12(%ebp), %eax
	movl	%eax, (%esp)
	call	crossout
	addl	$1, -20(%ebp)
	jmp	.L9
.L5:
	movl	-20(%ebp), %eax
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE1:
	.size	worker, .-worker
	.section	.rodata
.LC1:
	.string	"%d values of base done\n"
	.align 4
.LC2:
	.string	"the number of primes found was %d\n"
	.text
	.globl	main
	.type	main, @function
main:
.LFB2:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	andl	$-16, %esp
	subl	$32, %esp
	movl	12(%ebp), %eax

	addl	$4, %eax
	movl	(%eax), %eax

	movl	%eax, (%esp)
	call	atoi
	movl	%eax, n
	movl	12(%ebp), %eax

	addl	$8, %eax
	movl	(%eax), %eax

	movl	%eax, (%esp)
	call	atoi
	movl	%eax, nthreads
	movl	$3, 28(%esp)
	jmp	.L11
.L14:
	movl	28(%esp), %eax
	andl	$1, %eax
	testl	%eax, %eax
	jne	.L12
	movl	28(%esp), %eax
	movl	$0, prime(,%eax,4)
	jmp	.L13
.L12:
	movl	28(%esp), %eax
	movl	$1, prime(,%eax,4)
.L13:
	addl	$1, 28(%esp)
.L11:
	movl	n, %eax
	cmpl	%eax, 28(%esp)
	jle	.L14
	movl	$3, nextbase
	movl	$0, 28(%esp)
	jmp	.L15
.L16:
	movl	28(%esp), %eax
	movl	28(%esp), %edx
	sall	$2, %edx
	addl	$id, %edx
	movl	%eax, 12(%esp)
	movl	$worker, 8(%esp)
	movl	$0, 4(%esp)
	movl	%edx, (%esp)
	call	pthread_create
	addl	$1, 28(%esp)
.L15:
	movl	nthreads, %eax
	cmpl	%eax, 28(%esp)
	jl	.L16
	movl	$0, 28(%esp)
	jmp	.L17
.L18:
	movl	28(%esp), %eax
	movl	id(,%eax,4), %eax
	leal	20(%esp), %edx
	movl	%edx, 4(%esp)
	movl	%eax, (%esp)
	call	pthread_join
	movl	20(%esp), %eax
	movl	%eax, 4(%esp)
	movl	$.LC1, (%esp)
	call	printf
	addl	$1, 28(%esp)
.L17:
	movl	nthreads, %eax
	cmpl	%eax, 28(%esp)
	jl	.L18
	movl	$1, 24(%esp)
	movl	$3, 28(%esp)
	jmp	.L19
.L21:
	movl	28(%esp), %eax
	movl	prime(,%eax,4), %eax
	testl	%eax, %eax
	je	.L20
	addl	$1, 24(%esp)
.L20:
	addl	$1, 28(%esp)
.L19:
	movl	n, %eax
	cmpl	%eax, 28(%esp)
	jle	.L21
	movl	24(%esp), %eax
	movl	%eax, 4(%esp)
	movl	$.LC2, (%esp)
	call	printf
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE2:
	.size	main, .-main
	.ident	"GCC: (Ubuntu/Linaro 4.7.2-2ubuntu1) 4.7.2"
	.section	.note.GNU-stack,"",@progbits
