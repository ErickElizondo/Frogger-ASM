FILE = test#name of your asm file
BOOT_FILE = BOOTX64

.PHONY: build
build:
	#Creates efi file and renames it "BOOTX64.efi"
	fasm $(FILE).asm
	mv $(FILE).efi $(BOOT_FILE).efi 

	#Creates FAT image for proper boot
	dd if=/dev/zero of=fat.img bs=1k count=1440
	mformat -i fat.img -f 1440 ::
	mmd -i fat.img ::/EFI
	mmd -i fat.img ::/EFI/BOOT
	mcopy -i fat.img BOOTX64.efi ::/EFI/BOOT

	#Creates an HD image (which will be used in qemu)
	mkgpt -o hdimage.bin --image-size 4096 --part fat.img --type system

#Command to run this program
#qemu-system-x86_64 -pflash OVMF_CODE.fd -hda hdimage.bin