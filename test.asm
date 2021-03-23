;Code found in https://wiki.osdev.org/Uefi.inc
format pe64 dll efi
entry main
 
section '.text' code executable readable
 
include 'uefi.inc'
 
main:
    ; initialize UEFI library
    InitializeLib
    jc @f
 
    ; call uefi function to print to screen
    uefi_call_wrapper ConOut, OutputString, ConOut, _hello
 
@@: 
    uefi_call_wrapper	ConIn, ReadKeyStroke, ConIn, key
    cmp			dword [key.scancode], 0
    jz			@b
    mov eax, EFI_SUCCESS
    retn
 
section '.data' data readable writeable
 
_hello                                  du 'Hello World',13,10,0
key:
key.scancode:	dw 			0
key.unicode:	du			0
 
section '.reloc' fixups data discardable