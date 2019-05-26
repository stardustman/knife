#!Makefile
#
# --------------------------------------------------------
#
#    hurlex 这个小内核的 Makefile
#    默认使用的C语言编译器是 GCC、汇编语言编译器是 nasm
#
# --------------------------------------------------------
# Make命令运行时没有指定目标，默认会执行Makefile文件的第一个目标。
# $@指代当前目标，就是Make命令当前构建的那个目标。比如，make foo的 $@ 就指代foo。 第46行的 $@ 代表的 target 是 all：


# 在执行时扩展，允许递归扩展。shell 函数执行 find 。 -name “×.c” 结果是 entry.c, 也就是C_SOURCE这个变量的值是 entry.c
C_SOURCES = $(shell find . -name "*.c") 
#patsubst 处理所有在 C_SOURCES 字列中的字（一列文件名），如果它的 结尾是 '.c'，就用 '.o' 把 '.c' 取代, makefile 内建函数
C_OBJECTS = $(patsubst %.c, %.o, $(C_SOURCES))
S_SOURCES = $(shell find . -name "*.s")
S_OBJECTS = $(patsubst %.s, %.o, $(S_SOURCES))

CC = gcc  # compiler collections
LD = ld   # linker
ASM = nasm

C_FLAGS = -c -Wall -m32 -ggdb -gstabs+ -nostdinc -fno-builtin -fno-stack-protector -I include
#-m32 是生成32位代码，这样的话我们的开发环境也可以使用64位的Linux系统。
#-ggdb 和-gstabs+ 是添加相关的调试信息，调试对后期的排错很重要。
#-nostdinc 是不包含C语言的标准库里的头文件。
#-fno-builtin 是要求gcc不主动使用自己的内建函数，除非显式声明。 
#-fno-stack-protector 是不使用栈保护等检测
LD_FLAGS = -T scripts/kernel.ld -m elf_i386 -nostdlib
# T scripts/kernel.ld 是使用我们自己的链接器脚本。
#-m elf_i386 是生成i386平台下的ELF格式的可执行文件，这是Linux下的可执行文件格式。
#-nostdlib 是不链接C语言的标准库，原因上文已经交代过了。
ASM_FLAGS = -f elf -g -F stabs


# target> : <prerequisites> 
# [tab]  <commands>

all: $(S_OBJECTS) $(C_OBJECTS) link update_image

# The automatic variable `$<' is just the first prerequisite
.c.o:
	# $< 指代第一个前置条件。比如，规则为 t: p1 p2，那么$< 就指代p1。
	@echo 编译代码文件 $< ...
	$(CC) $(C_FLAGS) $< -o $@

.s.o:
	@echo 编译汇编文件 $< ...
	$(ASM) $(ASM_FLAGS) $<

link:
	@echo 链接内核文件...
	$(LD) $(LD_FLAGS) $(S_OBJECTS) $(C_OBJECTS) -o hx_kernel

.PHONY:clean
clean:
	$(RM) $(S_OBJECTS) $(C_OBJECTS) hx_kernel

.PHONY:update_image
update_image:
	sudo mount floppy.img /mnt/kernel
	sudo cp hx_kernel /mnt/kernel/hx_kernel
	sleep 1
	sudo umount /mnt/kernel

.PHONY:mount_image
mount_image:
	sudo mount floppy.img /mnt/kernel

.PHONY:umount_image
umount_image:
	sudo umount /mnt/kernel

.PHONY:qemu
qemu:
	qemu -fda floppy.img -boot a

.PHONY:bochs
bochs:
	bochs -f scripts/bochsrc.txt

.PHONY:debug
debug:
	qemu -S -s -fda floppy.img -boot a &
	sleep 1
	cgdb -x scripts/gdbinit

