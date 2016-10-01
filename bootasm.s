.code16
.globl start
start:

	movw $hellomsg,%ax
	movw $12,%bx
	pushw %bx
	pushw %ax
	call printmsg
	
	xorw %ax,%ax
	movw %ax,%ds
	movw %ax,%es
	movw %ax,%ss



seta20_1:
	inb $0x64, %al
	testb $0x2, %al
	jnz seta20_1

	movb $0xd1,%al
	outb %al,$0x64
seta20_2:
	inb $0x64,%al
	testb $0x2,%al
	jnz seta20_2

	movb $0xdf,%al
	outb %al,$0x60


lgdt gdtptr

movl %cr0,%eax
orl $0x2,%eax
movl %eax,%cr0

ljmp $0x08,$start32

start32:
	movw $0x10,%ax
	movw %ax,%ds
	movw %ax,%ss
	movw %ax,%es
	movw $0,%ax
	movw %ax,%gs
	movw %ax,%fs

	movl $start,%esp

spin: jmp spin

printmsg:
	pushw %bp
	movw %sp,%bp
	movw 4(%bp),%ax
	movw 6(%bp),%bx
	movw %ax,%bp
	movw %bx,%cx
	movw $0x01301,%ax
	movw $0x000c,%bx
	movb $0,%dl
	int $0x10
	popw %bp
	ret
	
hellomsg:
	.ascii "hello world!"
.p2align 2
gdt:
        .word 0,0,0,0
        .word 0xffff
        .word 0
        .word 0x9a00
        .word 0x00cf
        .word 0xffff
        .word 0
        .word 0x9200
        .word 0x00cf
gdtptr:
        .word (gdtptr-gdt-1)
        .long gdt
	
