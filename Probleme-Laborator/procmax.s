.data
n: .space 4
v: .space 400
element: .space 4
index: .space 4
formatS: .asciz "%ld"
formatP: .asciz "%ld\n"
format: .asciz "Maximul din vector este %ld si numarul de aparitii este de %ld\n"
.text
.global main

proc:
push %ebp
mov %esp,%ebp
push 12(%ebp)
push 8(%ebp)
call max
addl $8,%esp
push %edi
lea v,%edi
subl $4,%esp
movl $0,-8(%ebp)#adresa pt nr aparitii
movl $0,%ecx

for:
cmp %ecx, 12(%ebp) #12(%ebp) este adresa de mem pt n
je return
movl (%edi,%ecx,4),%edx
cmp %edx,%eax#in eax avem maximul
je et_nraparitii
incl %ecx
jmp for

et_nraparitii:
incl %ecx
incl -8(%ebp)
jmp for

return:
movl -8(%ebp),%esi#punem in un reg care nu se restaureaza pt a pastra val
addl $4,%esp
pop %edi
pop %ebp
ret

max:
push %ebp
mov %esp,%ebp
push %edi
lea v,%edi
subl $4,%esp
movl $0, %ecx
movl $0,-8(%ebp)#adresa pt max

movl (%edi,%ecx,4), %edx
mov %edx,-8(%ebp)#punem primul elem in max
movl $1,%ecx
for_parcurgere:
cmp %ecx, 12(%ebp) #12(%ebp) este adresa de mem pt n
je etret
movl (%edi,%ecx,4),%eax
cmp -8(%ebp),%eax
jg et_atribuire
incl %ecx
jmp for_parcurgere

et_atribuire:
mov %eax,-8(%ebp)
incl %ecx
jmp for_parcurgere

etret:
movl -8(%ebp),%eax

addl $4,%esp
pop %edi
pop %ebp
ret

main:
pushl $n
pushl $formatS
call scanf
popl %ebx
popl %ebx

movl $0, index

for_citire:
movl index, %ecx
cmp %ecx, n
je et
pushl $element
pushl $formatS
call scanf
popl %ebx
popl %ebx
movl element,%eax
movl index, %ecx
lea v,%edi
mov %eax, (%edi,%ecx,4)

incl index
jmp for_citire

et:
push n
push $v
call proc
pop %ebx
pop %ebx
push %esi
push %eax
pushl $format
call printf
popl %ebx
popl %ebx
popl %ebx

pushl $0
call fflush
addl $4,%esp

et_exit:
movl $1, %eax
movl $0, %ebx
int $0x80
