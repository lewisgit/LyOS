#include "types.h"
#include "x86.h"
#include "elf.h"
#include "memlayout.h"

#define SECT_SIZE 512

void readseg(uchar*,uint,uint);

void bootmain(void){
	struct elfhdr *elf;
	struct proghdr *ph,*eph;
	void (*entryk)(void);
	uchar *pa;
	elf=(struct elfhdr*)0x10000;

	//read the first sector
	readseg((uchar*)elf,4096,0);

	if(elf->magic!=ELF_MAGIC)
		return;
		// Load each program segment (ignores ph flags).
	ph=(struct proghdr*)((uchar*)elf+elf->phoff);
	eph=ph+elf->phnum;
	for(;ph<eph;ph++){
		pa=(uchar*)(ph->paddr);
		readseg(pa,ph->filesz,ph->off);
		if(ph->memsz>ph->filesz){
			stosb(pa+ph->filesz,0,ph->memsz-ph->filesz);
		}
	}
	entryk=(void(*)(void))((uchar*)elf->entry);
	//entryk=(void(*)(void))(0x1100c);
	entryk();
}
void waitdisk(){
	while((inb(0x1f7)&0xc0)!=0x40);
}
void readsect(void *dst,uint offset){
        //using LBA mode
        waitdisk();
        outb(0x1f2,1); //count of sectors to read
        outb(0x1f3,offset);//the first sector to read
        outb(0x1f4,offset>>8);
        outb(0x1f5,offset>>16);
        outb(0x1f6,(offset>>24)|0xe0);
        outb(0x1f7,0x20);
        waitdisk();
        insl(0x1f0,dst,SECT_SIZE/4);
}
void readseg(uchar* dst, uint count, uint offset_byte){
        uchar* dst_end;
        uint offset;
        dst_end=dst+count;
        dst-=offset_byte%SECT_SIZE;
        offset=(offset_byte/SECT_SIZE)+1;
        for(;dst<dst_end;dst+=SECT_SIZE,offset++)
                readsect(dst,offset);
}
