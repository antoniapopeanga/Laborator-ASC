.data
s: .space 101
nr: .long 0
format1: .asciz "Dati un sir de caractere: \n"
format2: .asciz "Sirul are %ld consoane. \n"
.text
.global main
main:
pushl $s
call gets
popl %ebx
movl $0, %ecx
mov $s, %edi
movl $0,%esi
movl $0 ,%ebp

etloop:
movb (%edi,%ecx,1),%ah
cmp $0,%ah
je reset
inc %esi
inc %ecx
jmp etloop


reset:
movl $0, %ecx

etfor:
movb (%edi,%ecx,1),%ah
cmp $0,%ah
je etafisare
cmp $'a',%ah
je etnr
cmp $'e',%ah
je etnr
cmp $'i',%ah
je etnr
cmp $'o',%ah
je etnr
cmp $'u',%ah
je etnr
addl $1, %ecx
jmp etfor

etnr:
addl $1,%ebp
inc %ecx
jmp etfor

etafisare:
sub %ebp,%esi
mov %esi,nr
pushl nr
push $format2
call printf
popl %ebx
popl %ebx

pushl $0
call fflush
popl %ebx

mov $1,%eax
mov $0,%ebx
int $0x80







