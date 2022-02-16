;# int processa(char *st, char val, int d)
;# { int j,cnt, p;
;# cnt=0;
;# for(j=0;j<d;j++)
;# if(st[j]<val)
;# cnt++;
;# return cnt;
;# }
;# main() {
;# char ST[16];
;# int i,pos,conta;
;# for(i=0;i<4;i++) {
;# printf("Inserisci una stringa \n");
;# scanf("%s",ST);
;# pos=strlen(ST)/2;
;# conta= processa(ST,ST[pos],strlen(ST));
;# printf(" Valore= %d \n",conta);
;# }
;# }

.data
ST: .space 16 ;# ST[16]
pos: .space 8 ;# INUTILE? int pos, conta la metto come arg di printf
stack: .space 32

msg1: .asciiz "Inserisci una stringa\n"
msg2: .asciiz "Valore : %d\n" ;# %d : conta 1° arg printf

p1sys5: .space 8
conta: .space 8 ;# 1° arg printf

p1sys3: .word 0 ;#fd null
ind: .space 8
dim: .word 16 ;#numbyte da leggere (<= ST)

.code
;# inizializzazione stack
daddi $sp,$0,stack
daddi $sp,$sp,32

daddi $s0,$0,0 ;# i per for
for_main:
    slti $t0,$s0,4 ;# $t0=0 quando $s0=i >= 4 
    beq $t0,$0,exit ;# quando i>=4 fine for

    ;# printf msg1
    daddi $t0,$0,msg1
    sd $t0,p1sys5($0)
    daddi r14,$0,p1sys5
    syscall 5
    ;# scanf(%s,ST)
    daddi $t0,$0,ST
    sd $t0,ind($0)
    daddi r14,$0,p1sys3
    syscall 3
    ;#passaggio parametri per processa
    move $a2,r1         ;# a2 = strlen
    daddi $a0,$0,ST     ;# a0 = ST
    ;# pos=strlen/2 = a2/2
    dsra $s1,$a2,1 ;# s1 =pos= $a2/2
    dadd $t0,$a0,$s1 ;# $t0 = ST[pos] = $a0+$s1
    lbu $a1,0($t0)      ;# $a1 = ST[pos]

    jal processa ;# ritorna un int cnt
    sd r1, conta($0)  :#move $s2,r1 ++++ sd $s2,conta($0)
     ;# conta= 1°arg msg2= return processa

    ;# printf msg2 con arg1 : conta 
    daddi $t0,$0,msg2
    sd $t0,p1sys5($0)
    daddi r14,$0,p1sys5
    syscall 5

    ;# fine del ciclo for, ora si incrementa e si risalta a for
    daddi $s0,$s0,1 ;# i viene usato per for, no multipli
    j for_main

processa: ;# $a0=ST, $a1= ST[pos] , $a2 = Strlen= d
    daddi $sp,$sp,-16 ;# 2x8
    sd $s2,0($sp)
    sd $s3,8($sp) ;# $s0 = i for main, $s1 = pos

    daddi $s2,$0,0 ;# cnt=0
    daddi $s3,$0,0 ;# j =0

    ;# for(j<d) ovvero scorro ST
for_f:
    slt $t0,$s3,$a2 ;# $t0 = 0 quando $s3 (j) >= $a2 (strlen,d)
    beq $t0,$0,fine_for ;# for end se j>=strlen
    ;#if(ST[j]<val) cioè se ST[j] < ST[pos} = $a1
    dadd $t0,$a0,$s3    ;# $t0 = ST+j = &ST[j]
    lbu $t1,0($t0)      ;# $t1 = ST[j]
    slt $t0,$t1,$a1     ;# $t0 = 0 quando $t1(ST[j]) >= $a1=strlen
    beq $t0,$0,falso ;# se $t0 = 0, va a falso (j++ e j for_f); se no cnt++ e poi va comunque a falso
    ;#cnt++
    daddi $s2,$s2,1 

falso:
    daddi $s3,$s3,1  ;# j++
    j for_f

fine_for:
    move r1,$s2 ;# r1 = $s2 = cnt

    ld $s2,0($sp)
    ld $s3,8($sp)
    daddi $sp,$sp,16
    jr $ra

exit: ;# quando i >= 4 ciclo for_main
    syscall 0

