
bootblock.o:     file format elf32-i386


Disassembly of section .text:

00007c00 <start>:
.code16
.globl start
start:

	movw $hellomsg,%ax
    7c00:	b8 6c 7c bb 0c       	mov    $0xcbb7c6c,%eax
	movw $12,%bx
    7c05:	00 53 50             	add    %dl,0x50(%ebx)
	pushw %bx
	pushw %ax
	call printmsg
    7c08:	e8 48 00 31 c0       	call   c0317c55 <_end+0xc030ffbd>
	
	xorw %ax,%ax
	movw %ax,%ds
    7c0d:	8e d8                	mov    %eax,%ds
	movw %ax,%es
    7c0f:	8e c0                	mov    %eax,%es
	movw %ax,%ss
    7c11:	8e d0                	mov    %eax,%ss

00007c13 <seta20_1>:



seta20_1:
	inb $0x64, %al
    7c13:	e4 64                	in     $0x64,%al
	testb $0x2, %al
    7c15:	a8 02                	test   $0x2,%al
	jnz seta20_1
    7c17:	75 fa                	jne    7c13 <seta20_1>

	movb $0xd1,%al
    7c19:	b0 d1                	mov    $0xd1,%al
	outb %al,$0x64
    7c1b:	e6 64                	out    %al,$0x64

00007c1d <seta20_2>:
seta20_2:
	inb $0x64,%al
    7c1d:	e4 64                	in     $0x64,%al
	testb $0x2,%al
    7c1f:	a8 02                	test   $0x2,%al
	jnz seta20_2
    7c21:	75 fa                	jne    7c1d <seta20_2>

	movb $0xdf,%al
    7c23:	b0 df                	mov    $0xdf,%al
	outb %al,$0x60
    7c25:	e6 60                	out    %al,$0x60


lgdt gdtptr
    7c27:	0f 01 16             	lgdtl  (%esi)
    7c2a:	90                   	nop
    7c2b:	7c 0f                	jl     7c3c <start32+0x1>

movl %cr0,%eax
    7c2d:	20 c0                	and    %al,%al
orl $0x2,%eax
    7c2f:	66 83 c8 02          	or     $0x2,%ax
movl %eax,%cr0
    7c33:	0f 22 c0             	mov    %eax,%cr0

ljmp $0x08,$start32
    7c36:	ea                   	.byte 0xea
    7c37:	3b 7c 08 00          	cmp    0x0(%eax,%ecx,1),%edi

00007c3b <start32>:

start32:
	movw $0x10,%ax
    7c3b:	b8 10 00 8e d8       	mov    $0xd88e0010,%eax
	movw %ax,%ds
	movw %ax,%ss
    7c40:	8e d0                	mov    %eax,%ss
	movw %ax,%es
    7c42:	8e c0                	mov    %eax,%es
	movw $0,%ax
    7c44:	b8 00 00 8e e8       	mov    $0xe88e0000,%eax
	movw %ax,%gs
	movw %ax,%fs
    7c49:	8e e0                	mov    %eax,%fs

	movl $start,%esp
    7c4b:	66 bc 00 7c          	mov    $0x7c00,%sp
	...

00007c51 <spin>:

spin: jmp spin
    7c51:	eb fe                	jmp    7c51 <spin>

00007c53 <printmsg>:

printmsg:
	pushw %bp
    7c53:	55                   	push   %ebp
	movw %sp,%bp
    7c54:	89 e5                	mov    %esp,%ebp
	movw 4(%bp),%ax
    7c56:	8b 46 04             	mov    0x4(%esi),%eax
	movw 6(%bp),%bx
    7c59:	8b 5e 06             	mov    0x6(%esi),%ebx
	movw %ax,%bp
    7c5c:	89 c5                	mov    %eax,%ebp
	movw %bx,%cx
    7c5e:	89 d9                	mov    %ebx,%ecx
	movw $0x01301,%ax
    7c60:	b8 01 13 bb 0c       	mov    $0xcbb1301,%eax
	movw $0x000c,%bx
    7c65:	00 b2 00 cd 10 5d    	add    %dh,0x5d10cd00(%edx)
	movb $0,%dl
	int $0x10
	popw %bp
	ret
    7c6b:	c3                   	ret    

00007c6c <hellomsg>:
    7c6c:	68 65 6c 6c 6f       	push   $0x6f6c6c65
    7c71:	20 77 6f             	and    %dh,0x6f(%edi)
    7c74:	72 6c                	jb     7ce2 <_end+0x4a>
    7c76:	64                   	fs
    7c77:	21                   	.byte 0x21

00007c78 <gdt>:
	...
    7c80:	ff                   	(bad)  
    7c81:	ff 00                	incl   (%eax)
    7c83:	00 00                	add    %al,(%eax)
    7c85:	9a cf 00 ff ff 00 00 	lcall  $0x0,$0xffff00cf
    7c8c:	00                   	.byte 0x0
    7c8d:	92                   	xchg   %eax,%edx
    7c8e:	cf                   	iret   
	...

00007c90 <gdtptr>:
    7c90:	17                   	pop    %ss
    7c91:	00 78 7c             	add    %bh,0x7c(%eax)
	...
