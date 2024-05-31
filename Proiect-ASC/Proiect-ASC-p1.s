.data
m1: .space 40000
m2: .space 40000
mres: .space 40000
n: .space 4
v: .space 400
i: .space 4
j: .space 4
nr_cerinta: .space 4
vecin: .space 4
index: .space 4
ind: .space 4
nrmuchii_nod: .space 4
lungime: .space 4
formatS: .asciz "%d"
formatP: .asciz "%d "
format: .asciz "%ld\n"
nr_drumuri: .long 0
nod_s: .space 4
nod_d: .space 4
endline: .asciz "\n"
.text
.global main

matrix_mult:
push %ebp
mov %esp,%ebp
push %ebx
push %esi
subl $24,%esp
movl $0,-12(%ebp)#indicele i
movl $0,-16(%ebp)#indicele j
movl $0, -20(%ebp)#indicele k
movl $0, -24(%ebp)#suma inmultirilor linie-coloana
movl $0, -28(%ebp)#val1 de pe linie
movl $0, -32(%ebp)#val2 de pe coloana
push %edi


pentru_i:
movl $0,-16(%ebp)#coloana
movl -12(%ebp),%ecx
cmp %ecx,20(%ebp)
je ret


pentru_j:
movl -16(%ebp),%ecx
cmp %ecx,20(%ebp)
je cont2
movl $0,-20(%ebp)
movl $0,-24(%ebp)


pentru_k:
movl -20(%ebp),%ecx
cmp %ecx,20(%ebp)
je cont1

movl -12(%ebp),%eax
movl $0,%edx
mull 20(%ebp)
addl -20(%ebp),%eax
movl (%edi,%eax,4),%edx
mov %edx,-28(%ebp)

movl -20(%ebp),%eax
movl $0,%edx
mull 20(%ebp)
addl -16(%ebp),%eax
movl (%esi,%eax,4),%edx
mov %edx,-32(%ebp)


movl -28(%ebp),%eax
movl $0,%edx
mull -32(%ebp)
addl %eax,-24(%ebp)


incl -20(%ebp)
jmp pentru_k

cont1:
movl -12(%ebp),%eax
movl $0,%edx
mull 20(%ebp)
addl -16(%ebp),%eax
movl -24(%ebp),%edx
mov %edx,(%ebx,%eax,4)
incl -16(%ebp)
jmp pentru_j

cont2:
incl -12(%ebp)
jmp pentru_i

ret:
pop %edi
addl $24,%esp
pop %esi
pop %ebx
pop %ebp
ret


main:

pushl $nr_cerinta
pushl $formatS
call scanf
pop %ebx
pop %ebx

pushl $n
pushl $formatS
call scanf
popl %ebx
popl %ebx

movl $0,index

for_muchii:
movl index, %ecx
cmp %ecx, n
je citire_matrice
pushl $nrmuchii_nod#citim nr muchii pt fiecare nod
pushl $formatS
call scanf
popl %ebx
popl %ebx
movl nrmuchii_nod,%eax
movl index, %ecx
lea v,%edi
mov %eax, (%edi,%ecx,4)#facem un vector v[nod]=nr muchii


incl index
jmp for_muchii

movl $0,i

citire_matrice:
movl i,%ecx#i este nodul curent si repr linia matricei
incl i
movl $0,j#j repr coloana si nr de muchii curent al nodului i
cmp %ecx, n
je et_cerinta
muchiile_nodului_i:
movl j,%ebx
movl i,%ecx
subl $1,%ecx
cmp (%edi,%ecx,4),%ebx#comp nr muchii din v[nod] cu indicele j
je citire_matrice

pushl $vecin#citim cu cine isi face legatura nodul i
pushl $formatS
call scanf
addl $4,%esp
addl $4,%esp

movl i,%ecx
subl $1,%ecx
movl %ecx, %eax#mutam linia in eax pt inmultire
movl $0, %edx
mull n
addl vecin, %eax
lea m1, %esi
movl $1, (%esi, %eax, 4)
lea m2,%esi
movl $1, (%esi, %eax, 4)
incl j
jmp muchiile_nodului_i

et_cerinta:

movl $1,%ecx
cmp %ecx, nr_cerinta
je cerinta_1

movl $2,%ecx
cmp %ecx, nr_cerinta
je cerinta_2


cerinta_1:
movl $0, i

for_i:
movl i, %ecx
cmp %ecx, n
je et_exit
movl $0, j

for_j:
movl j, %ecx
cmp %ecx, n
je endl

movl i, %eax
movl $0, %edx
mull n
addl j,%eax


lea m1, %esi
movl (%esi, %eax, 4), %ebx
pushl %ebx
pushl $formatP
call printf
popl %ebx
popl %ebx


pushl $0
call fflush
popl %ebx

incl j
jmp for_j

endl:
push $endline
call printf
pop %ebx

pushl $0
call fflush
popl %ebx
incl i
jmp for_i


cerinta_2:
pushl $lungime
pushl $formatS
call scanf
addl $4,%esp
addl $4,%esp

pushl $nod_s
pushl $formatS
call scanf
addl $4,%esp
addl $4,%esp

pushl $nod_d
pushl $formatS
call scanf
addl $4,%esp
addl $4,%esp

movl $1,ind
putere_mat:
movl ind,%ecx
cmp %ecx,lungime
je et_afisare
lea m1,%edi
lea m2,%esi
lea mres,%ebx
push n
push $mres
push $m2
push $m1
call matrix_mult
addl $16,%esp

movl $0,index

movl n,%eax
movl $0,%edx
mull n
for_copiere:
movl index,%ecx
cmp %ecx,%eax
je continuare
lea mres,%ebx
lea m2,%esi
movl (%ebx,%ecx,4),%edx
mov %edx,(%esi,%ecx,4)
incl index
jmp for_copiere

continuare:
incl ind
jmp putere_mat


et_afisare:
lea mres,%ebx
movl nod_s,%eax
movl $0,%edx
mull n
addl nod_d,%eax
movl (%ebx,%eax,4),%ecx
pushl %ecx
pushl $format
call printf
popl %ebx
popl %ebx

pushl $0
call fflush
popl %ebx
jmp et_exit


et_exit:
movl $1, %eax
movl $0, %ebx
int $0x80





