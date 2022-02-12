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
