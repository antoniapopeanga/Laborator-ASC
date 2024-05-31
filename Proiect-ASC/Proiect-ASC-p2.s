.data
n: .space 4
v: .space 400
m1: .space 40000
m2: .space 40000
i: .space 4
j: .space 4
nr_cerinta: .space 4
ind: .space 4
len: .space 4
adr: .long 0
vecin: .space 4
index: .space 4
nrmuchii_nod: .space 4
lungime: .space 4
x: .long 0
formatS: .asciz "%ld"
formatP: .asciz "%ld"
format: .asciz "%ld\n"
nr_drumuri: .long 0
nod_s: .space 4
nod_d: .space 4
enter: .asciz "\n"
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
movl (%ebx,%eax,4),%edx
mov %edx,-28(%ebp)

movl -20(%ebp),%eax
movl $0,%edx
mull 20(%ebp)
addl -16(%ebp),%eax
movl (%edi,%eax,4),%edx
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
mov %edx,(%esi,%eax,4)
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

pushl $n#numarul de linii/col
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
je et_mmap
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



et_mmap:

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

movl n,%eax
movl $0,%edx
mull n
movl $4,x
mull x
movl %eax, len#calc spatiul ce trebuie alocat pt matrice de longuri n*n*4

mmap:
#syscall mmap
movl $192,%eax#codul apelului mmap
movl $0,%ebx#se plaseaza mapparea oriunde decide kernelul ca e mai potrivit
movl len,%ecx#spatiul de alocat pt matrice
movl $3 ,%edx#PROT_WRITE|PROT_READ
movl $0x22 ,%esi#MAP_ANONYMOUS|MAP_PRIVATE,mappingul nu e conectat la files
movl $-1, %edi#nu exista file d, map anonymous
movl $0, %ebp#offset, de aici porneste mapp-area
int $0x80

         
mov %eax,%esi#matrix address
mov n,%eax
movl $0,%edx
mull n
movl $0,%ecx

mov %esi, adr

movl $1,ind

putere_mat:
movl ind,%ecx
cmp %ecx,lungime
je afisare
mov %esi, adr
lea m1,%ebx
lea m2,%edi
push n
push adr
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
lea m2,%edi
movl (%esi,%ecx,4),%edx
mov %edx,(%edi,%ecx,4)
incl index
jmp for_copiere

continuare:
incl ind
jmp putere_mat

afisare:
movl nod_s,%eax
movl $0,%edx
mull n
addl nod_d,%eax
movl (%esi,%eax,4),%ecx
pushl %ecx
pushl $format
call printf
popl %ebx
popl %ebx

pushl $0
call fflush
popl %ebx

et_exit:
movl $91,%eax#codul apelului munmap
mov %esi,%ebx#adresa memoriei ce trebuie dealocata
movl len,%ecx#spatiul memoriei pt eliberare
int $0x80#eliberarea spatiului

movl $1, %eax
movl $0, %ebx
int $0x80
