global start

section .text
bits 32
start:
  mov word [0xb8000], 0x0248 ; H
  hlt
