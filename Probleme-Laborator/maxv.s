.data
v: .long 31,2,7,10,31,31,19,31
n: .long 8
max: .space 4
nrap: .space 4
formatStr:.asciz "Maximul este %ld si apare de %ld ori"
.text
.global main
main:
mov $v,%edi
mov $0, %ecx
movl $0,nrap
movl (%edi,%ecx,4),%edx
add $1,%ecx
mov %edx,max

etloop:
cmp n, %ecx
je et_afisare
movl (%edi,%ecx,4),%edx
add $1,%ecx
cmp max,%edx
je etap
jl etloop
mov %edx,max
movl $0,nrap
jmp etloop
etap:
movl $1,nrap
loop etloop

et_afisare:
pushl nrap
pushl max
pushl $formatStr
call printf
popl %ebx
popl %ebx
popl %ebx

pushl $0
call fflush
popl %ebx


mov $1, %eax
mov $0, %ebx
int $0x80
