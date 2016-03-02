magic_number equ 0xe85250d6
protected_mode equ 0
checksum_zero equ 0x100000000
header_size equ (header_end - header_start)

architecture_mode equ protected_mode
checksum equ (checksum_zero - (magic_number + architecture_mode + header_size))

section .multiboot_header
header_start:
  dd magic_number
  dd protected_mode
  dd header_size
  dd checksum

required_end_tag:
  dw 0 ; type
  dw 0 ; flags
  dd 8 ; size
header_end:
