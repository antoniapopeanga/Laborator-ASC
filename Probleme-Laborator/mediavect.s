.data
v: .long 2,3,5,3
n: .long 4
nr: .long 0
format1: .asciz "Numarul de numere egale cu catul mediei aritmetice din vector este %ld \n"
.text
.global main
main:
movl $0, %ecx
movl $0,%eax
mov $v, %edi

etfor:
movl (%edi,%ecx,4),%ebp
cmp n, %ecx
je etmedie
add %ebp,%eax
inc %ecx
jmp etfor

etmedie:
mov $0,%edx
divl n

movl $0, %ecx
movl $0, %esi

etfor1:
movl (%edi,%ecx,4),%ebp
cmp n, %ecx
je etafisare
cmp %ebp,%eax
je etnr
inc %ecx
jmp etfor1


etnr:
addl $1,%esi
inc %ecx
jmp etfor1

etafisare:
mov %esi,nr
push nr
push $format1
call printf
popl %ebx
popl %ebx

pushl $0
call fflush
popl %ebx

mov $1,%eax
mov $0,%ebx
int $0x80

