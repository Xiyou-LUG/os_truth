BUILD_DIR = ./build
ENTRY_POINT = 0xc0001500
AS = nasm
CC = gcc
LD = ld
LIB = -I lib/ -I lib/kernel/ -I lib/user -I kernel/ -I device/ -I thread/ -I userprog/ -I lib/user -I fs/ -I shell/
ASFLAGS = -f elf
CFLAGS = -m32 -Wall $(LIB) -c -D NDEBUG -fno-builtin -fno-stack-protector -W -Wstrict-prototypes \
		 -Wmissing-prototypes
LDFLAGS = -m elf_i386 -Ttext $(ENTRY_POINT) -e main -Map $(BUILD_DIR)/kernel.map
# OBJS = $(BUILD_DIR)/main.o $(BUILD_DIR)/init.o $(BUILD_DIR)/interrupt.o \
		$(BUILD_DIR)/timer.o $(BUILD_DIR)/kernel.o $(BUILD_DIR)/print.o \
		$(BUILD_DIR)/debug.o $(BUILD_DIR)/memory.o $(BUILD_DIR)/bitmap.o \
		$(BUILD_DIR)/string.o $(BUILD_DIR)/thread.o $(BUILD_DIR)/list.o \
		$(BUILD_DIR)/switch.o $(BUILD_DIR)/console.o $(BUILD_DIR)/sync.o \
		$(BUILD_DIR)/keyboard.o $(BUILD_DIR)/ioqueue.o $(BUILD_DIR)/tss.o \
		$(BUILD_DIR)/process.o $(BUILD_DIR)/syscall.o $(BUILD_DIR)/stdio.o \
		$(BUILD_DIR)/syscall-init.o $(BUILD_DIR)/stdio-kernel.o $(BUILD_DIR)/ide.o \
		$(BUILD_DIR)/fs.o $(BUILD_DIR)/inode.o $(BUILD_DIR)/file.o $(BUILD_DIR)/dir.o
OBJS = $(BUILD_DIR)/main.o $(BUILD_DIR)/init.o $(BUILD_DIR)/interrupt.o \
	   $(BUILD_DIR)/timer.o $(BUILD_DIR)/kernel.o $(BUILD_DIR)/print.o \
	   $(BUILD_DIR)/debug.o $(BUILD_DIR)/memory.o $(BUILD_DIR)/bitmap.o \
	   $(BUILD_DIR)/string.o $(BUILD_DIR)/thread.o $(BUILD_DIR)/list.o \
	   $(BUILD_DIR)/switch.o  $(BUILD_DIR)/console.o $(BUILD_DIR)/sync.o \
	   $(BUILD_DIR)/keyboard.o  $(BUILD_DIR)/ioqueue.o $(BUILD_DIR)/tss.o \
	   $(BUILD_DIR)/process.o  $(BUILD_DIR)/syscall.o $(BUILD_DIR)/syscall-init.o \
	   $(BUILD_DIR)/stdio.o $(BUILD_DIR)/ide.o $(BUILD_DIR)/stdio-kernel.o $(BUILD_DIR)/fs.o \
	   $(BUILD_DIR)/inode.o $(BUILD_DIR)/file.o $(BUILD_DIR)/dir.o \
	   $(BUILD_DIR)/fork.o $(BUILD_DIR)/assert.o $(BUILD_DIR)/shell.o \
	   $(BUILD_DIR)/buildin_cmd.o $(BUILD_DIR)/exec.o $(BUILD_DIR)/wait_exit.o \
	   $(BUILD_DIR)/pipe.o

###### c代码编译 ######
$(BUILD_DIR)/main.o: kernel/main.c lib/kernel/print.h \
					lib/stdint.h kernel/init.h thread/thread.h device/console.h\
					kernel/interrupt.h
	$(CC) $(CFLAGS) $< -o $@

$(BUILD_DIR)/init.o: kernel/init.c kernel/init.h lib/kernel/print.h \
					lib/stdint.h kernel/interrupt.h device/timer.h thread/thread.h \
					device/keyboard.h
	$(CC) $(CFLAGS) $< -o $@

$(BUILD_DIR)/interrupt.o: kernel/interrupt.c kernel/interrupt.h \
					lib/stdint.h kernel/global.h lib/kernel/io.h lib/kernel/print.h
	$(CC) $(CFLAGS) $< -o $@

$(BUILD_DIR)/timer.o: device/timer.c device/timer.h lib/stdint.h \
					lib/kernel/io.h lib/kernel/print.h
	$(CC) $(CFLAGS) $< -o $@

$(BUILD_DIR)/debug.o: kernel/debug.c kernel/debug.h \
					lib/kernel/print.h lib/stdint.h kernel/interrupt.h
	$(CC) $(CFLAGS) $< -o $@

$(BUILD_DIR)/string.o: lib/string.c lib/string.h \
        			lib/stdint.h  kernel/debug.h lib/string.h kernel/global.h
	$(CC) $(CFLAGS) $< -o $@

$(BUILD_DIR)/bitmap.o: lib/kernel/bitmap.c lib/kernel/bitmap.h \
        			lib/kernel/print.h lib/stdint.h kernel/interrupt.h \
					kernel/debug.h lib/string.h kernel/global.h
	$(CC) $(CFLAGS) $< -o $@

$(BUILD_DIR)/memory.o: kernel/memory.c kernel/memory.h lib/stdint.h  lib/kernel/bitmap.h \
        			kernel/global.h kernel/debug.h lib/kernel/print.h kernel/debug.h \
					lib/kernel/io.h kernel/interrupt.h lib/string.h thread/sync.h \
					kernel/memory.h
	$(CC) $(CFLAGS) $< -o $@

$(BUILD_DIR)/thread.o: thread/thread.c thread/thread.h \
					lib/stdint.h lib/string.h kernel/global.h lib/kernel/bitmap.h \
					kernel/memory.h lib/kernel/print.h kernel/interrupt.h kernel/debug.h lib/kernel/list.h lib/kernel/print.h \
					lib/kernel/bitmap.h
	$(CC) $(CFLAGS) $< -o $@

$(BUILD_DIR)/list.o: lib/kernel/list.c lib/kernel/list.h \
					kernel/global.h lib/stdint.h kernel/interrupt.h
	$(CC) $(CFLAGS) $< -o $@

$(BUILD_DIR)/sync.o: thread/sync.c thread/sync.h \
					lib/stdint.h lib/kernel/list.h kernel/global.h \
					kernel/interrupt.h kernel/debug.h
	$(CC) $(CFLAGS) $< -o $@

$(BUILD_DIR)/console.o: device/console.c device/console.h \
					lib/kernel/print.h lib/stdint.h thread/sync.h \
					thread/thread.h lib/kernel/list.h kernel/global.h
	$(CC) $(CFLAGS) $< -o $@

$(BUILD_DIR)/keyboard.o: device/keyboard.c device/keyboard.h \
					lib/kernel/print.h kernel/interrupt.h lib/kernel/io.h \
					kernel/global.h
	$(CC) $(CFLAGS) $< -o $@

$(BUILD_DIR)/ioqueue.o: device/ioqueue.c device/ioqueue.h \
					kernel/interrupt.h kernel/global.h kernel/debug.h
	$(CC) $(CFLAGS) $< -o $@

$(BUILD_DIR)/tss.o: userprog/tss.c userprog/tss.h \
					lib/stdint.h kernel/global.h thread/thread.h lib/kernel/print.h \
					kernel/memory.h lib/string.h
	$(CC) $(CFLAGS) $< -o $@

$(BUILD_DIR)/process.o: userprog/process.c userprog/process.h \
					lib/stdint.h thread/thread.h kernel/memory.h \
					kernel/debug.h userprog/tss.h lib/string.h \
					device/console.h kernel/interrupt.h lib/kernel/list.h \
					kernel/memory.h
	$(CC) $(CFLAGS) $< -o $@

$(BUILD_DIR)/syscall.o: lib/user/syscall.c lib/user/syscall.h thread/thread.h
	$(CC) $(CFLAGS) $< -o $@

$(BUILD_DIR)/syscall-init.o: userprog/syscall-init.c userprog/syscall-init.h \
					lib/stdint.h thread/thread.h lib/user/syscall.h lib/kernel/print.h \
					kernel/memory.h userprog/wait_exit.h
	$(CC) $(CFLAGS) $< -o $@

$(BUILD_DIR)/stdio.o: lib/stdio.c lib/stdio.h \
					lib/stdint.h kernel/global.h lib/user/syscall.h \
					lib/string.h kernel/interrupt.h
	$(CC) $(CFLAGS) $< -o $@

$(BUILD_DIR)/stdio-kernel.o: lib/kernel/stdio-kernel.c lib/kernel/stdio-kernel.h \
					lib/stdio.h lib/stdint.h lib/kernel/print.h device/console.h \
					kernel/global.h
	$(CC) $(CFLAGS) $< -o $@

$(BUILD_DIR)/ide.o: device/ide.c device/ide.h \
					lib/stdint.h kernel/global.h lib/stdio.h lib/kernel/stdio-kernel.h \
					kernel/debug.h lib/kernel/io.h kernel/interrupt.h lib/string.h
	$(CC) $(CFLAGS) $< -o $@

$(BUILD_DIR)/fs.o: fs/fs.c fs/fs.h \
					fs/super_block.h fs/inode.h fs/dir.h device/ide.h lib/stdint.h \
					kernel/global.h lib/kernel/stdio-kernel.h lib/string.h \
					kernel/debug.h kernel/memory.h lib/kernel/list.h \
					device/ioqueue.h device/keyboard.h
	$(CC) $(CFLAGS) $< -o $@

$(BUILD_DIR)/inode.o: fs/inode.c fs/inode.h lib/stdint.h lib/kernel/list.h \
					kernel/global.h fs/fs.h device/ide.h thread/sync.h thread/thread.h \
					lib/kernel/bitmap.h kernel/memory.h fs/file.h kernel/debug.h \
					kernel/interrupt.h lib/kernel/stdio-kernel.h
	$(CC) $(CFLAGS) $< -o $@

$(BUILD_DIR)/file.o: fs/file.c fs/file.h lib/stdint.h device/ide.h thread/sync.h \
					lib/kernel/list.h kernel/global.h thread/thread.h lib/kernel/bitmap.h \
					kernel/memory.h fs/fs.h fs/inode.h fs/dir.h lib/kernel/stdio-kernel.h \
					kernel/debug.h kernel/interrupt.h
	$(CC) $(CFLAGS) $< -o $@

$(BUILD_DIR)/dir.o: fs/dir.c fs/dir.h lib/stdint.h fs/inode.h lib/kernel/list.h \
					kernel/global.h device/ide.h thread/sync.h thread/thread.h \
					lib/kernel/bitmap.h kernel/memory.h fs/fs.h fs/file.h \
					lib/kernel/stdio-kernel.h kernel/debug.h kernel/interrupt.h
	$(CC) $(CFLAGS) $< -o $@

$(BUILD_DIR)/fork.o: userprog/fork.c userprog/fork.h \
					lib/stdint.h thread/thread.h lib/string.h \
					kernel/global.h kernel/memory.h userprog/process.h \
					kernel/debug.h fs/file.h kernel/interrupt.h \
					lib/kernel/list.h shell/pipe.h
	$(CC) $(CFLAGS) $< -o $@

$(BUILD_DIR)/assert.o: lib/user/assert.c lib/user/assert.h lib/stdio.h
	$(CC) $(CFLAGS) $< -o $@

$(BUILD_DIR)/shell.o: shell/shell.c shell/shell.h \
					lib/stdint.h device/ioqueue.h lib/kernel/print.h \
					lib/string.h lib/user/syscall.h lib/user/assert.h \
					fs/file.h lib/stdio.h
	$(CC) $(CFLAGS) $< -o $@

$(BUILD_DIR)/buildin_cmd.o: shell/buildin_cmd.c shell/buildin_cmd.h \
					lib/stdint.h lib/user/assert.h fs/fs.h \
					fs/file.h lib/string.h lib/user/syscall.h
	$(CC) $(CFLAGS) $< -o $@

$(BUILD_DIR)/exec.o: userprog/exec.c userprog/exec.h \
					lib/stdint.h kernel/global.h kernel/memory.h \
					fs/fs.h lib/string.h thread/thread.h kernel/interrupt.h
	$(CC) $(CFLAGS) $< -o $@

$(BUILD_DIR)/pipe.o: shell/pipe.c shell/pipe.h \
					lib/stdint.h fs/fs.h kernel/global.h \
					fs/file.h kernel/memory.h device/ioqueue.h
	$(CC) $(CFLAGS) $< -o $@


$(BUILD_DIR)/wait_exit.o: userprog/wait_exit.c userprog/wait_exit.h \
					lib/stdint.h thread/thread.h fs/fs.h \
					lib/kernel/list.h kernel/debug.h \
					fs/file.h shell/pipe.h
	$(CC) $(CFLAGS) $< -o $@

###### 汇编代码编译 ######
$(BUILD_DIR)/kernel.o: kernel/kernel.s
	$(AS) $(ASFLAGS) $< -o $@

$(BUILD_DIR)/print.o: lib/kernel/print.s
	$(AS) $(ASFLAGS) $< -o $@

$(BUILD_DIR)/switch.o: thread/switch.s
	$(AS) $(ASFLAGS) $< -o $@

###### 链接所有文件 ######
$(BUILD_DIR)/kernel.bin: $(OBJS)
	$(LD) $(LDFLAGS) $^ -o $@

.PHONY : mk_dir hd clean all

mk_dir:
	if [[ ! -d $(BUILD_DIR) ]]; then mkdir $(BUILD_DIR);fi

hd:
	dd if=$(BUILD_DIR)/kernel.bin \
		of=./bochs-2.6.11/hd60M.img \
		bs=512 count=200 seek=9 conv=notrunc

clean:
	cd $(BUILD_DIR) && rm -f ./*

build: $(BUILD_DIR)/kernel.bin

all:mk_dir build hd
