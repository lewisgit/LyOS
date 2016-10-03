.code16
.globl start
start:


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
orl $1,%eax
movl %eax,%cr0

ljmp $8,$start32


.code32
start32:
	cli
	movw $0x10,%ax
	movw %ax,%ds
	movw %ax,%ss
	movw %ax,%es
	movw $0,%ax
	movw %ax,%gs
	movw %ax,%fs

	movl $start,%esp
        movl $intopmsuc,%eax
        movl $(80*20),%ebx
        pushl %ebx
        pushl %eax
        call printmsg32
	popl %eax
	popl %ebx

	call bootmain

spin: jmp spin

printmsg32:
        pushl %ebp
        movl %esp,%ebp
        movl 8(%ebp),%eax
        movl 12(%ebp),%ebx
	movl %eax,%esi
	movl %ebx,%edi
	movb $0xc,%ah
	cld
startprint:
	lodsb
	testb %al,%al
	jz finishprint
	movl videoselector,%ebx
	movw %ax,(%ebx,%edi,1)
	addl $2,%edi
	jmp startprint

finishprint:
	popl %ebp
	ret

intopmsuc:
	.ascii "protection mode"
	.byte 0
.p2align 2
gdt:
        .word 0,0,0,0
        .word 0xffff
        .word 0
        .word 0x9b00
        .word 0x00cf
        .word 0xffff
        .word 0
        .word 0x9200
        .word 0x00cf
gdtptr:
        .word (gdtptr-gdt-1)
       .long gdt

videoselector:
	.long 0xb8000
