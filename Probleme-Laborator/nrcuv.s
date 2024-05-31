.data
str: .space 101
str11: .asciz "Dati un sir de carectere: "
str2: .asciz "Propozitia data are %ld cuvinte\n"
nr: .long 0
.text
.global main
main:
mov $4, %eax
mov $1,%ebx
mov $str11, %ecx
mov $26, %edx
int $0x80

pushl $str
call gets
popl %ebx

movl $str,%edi
movl $0,%ecx
movl $1,%edx

etfor:
movb (%edi,%ecx,1),%ah
cmp $0,%ah
je etafisare
cmp $' ',%ah
je etnr
inc %ecx
jmp etfor

etnr:
inc %edx
inc %ecx
jmp etfor

etafisare:
mov %edx,nr
pushl nr
pushl $str2
call printf
popl %ebx
popl %ebx

pushl $0
call fflush
popl %ebx

mov $1, %eax
mov $0, %ebx
int $0x80
