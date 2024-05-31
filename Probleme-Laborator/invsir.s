.data
s: .space 101
t: .space 101
str1: .asciz "%s"
str2: .asciz "Sirul inversat este %s\n"
.text
.global main
main:
pushl $s
pushl $str1
call scanf
popl %ebx
popl %ebx
movl $s,%edi
movl $0, %ecx

etloop:
movb (%edi,%ecx,1),%ah
cmp $0,%ah
je etcnt
addl $1,%ecx
jmp etloop

etcnt:
mov %ecx,%ebp
mov $0,%ecx
subl $1,%ebp
movl $t,%esi

etfor:
movb (%edi,%ecx,1),%ah
cmp $0,%ah
je etafisare
movb %ah, (%esi,%ebp,1)
addl $1,%ecx
subl $1,%ebp
jmp etfor

etafisare:
pushl $t
pushl $str2
call printf
popl %ebx
popl %ebx

pushl $0
call fflush
popl %ebx

movl $1,%eax
mov $0,%ebx
int $0x80


