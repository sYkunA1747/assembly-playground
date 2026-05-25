#include <stdio.h>
#include <stdlib.h>

int testFunction(int a, int b, int testResult);

int main(void) {
    int a, b;
    int result = 0;
    int testResult = 0;

    printf("Enter a Number(A) and (B): ");
    scanf("%d %d", &a, &b);

    
    asm volatile (
        "movl %%eax, %%esi\n\t"
        "cmpl %%ebx, %%eax\n\t"
        
        /*
        * Флаг нуля ZF устанавливается, если RAX = RBX
        * Флаг переполнения OF устанавливается, если при вычитании произойдет переполнение (изменение) знакового бита.
        * Флаг переноса CF устанавливается, если при вычитании RAX - RBX потребуется заимствование
        */
        
        "je equal\n\t"
        "jg greater\n\t"

        "less:\n\t"
            "imull $8, %%eax, %%eax\n\t"
            "movl %%eax, %%ecx\n\t"   
            
            "movl %%esi, %%eax\n\t"
            "subl %%ebx, %%eax\n\t"

            "movl %%eax, %%esi\n\t"
            "movl %%ecx, %%eax\n\t"
            "cltd\n\t"

            "idivl  %%esi\n\t"   


            "movl %%eax, %0 \n\t"
            "jmp end\n\t"
        

        "equal:\n\t"
        /*
        * |a/3| 
        */
            "movl %1, %%eax\n\t"
            "cltd\n\t"
            "movl $3, %%ecx\n\t"
            "idivl %%ecx\n\t"

            "test %%eax, %%eax\n\t"
            "jns abs_done\n\t"
            "neg %%eax\n\t"
            "abs_done:\n\t"
                

            "movl %%eax, %%ecx\n\t"
            "test %%ecx, %%ecx\n\t"
            "movl $0, %0\n\t"
            "jz end\n\t"

            "xorl %%eax, %%eax\n\t"
            "movl $1, %%edx\n\t"
            "mainloop:\n\t"
                "addl %%edx, %%eax\n\t"
                "incl %%edx\n\t"
                "loop mainloop\n\t"
            
            "movl %%eax, %0\n\t"
            "jmp end\n\t"


        "greater:\n\t"
            "movl %%ebx, %%eax\n\t"      // Т.к b лежит в ebx и компиль может заруинить
            "imull %%eax, %%eax\n\t"
            "cltd\n\t"
            "movl $8, %%ecx\n\t"
            "idivl %%ecx\n\t"

            "movl %%eax, %0\n\t"
            "jmp end\n\t"


        "end:\n\t"
        
        /*
        * Модификаторы ограничений
        */
        :"=r"(result)
        : "a"(a), "b"(b)             
        :"%ecx", "%edx", "%esi", "cc"
    );
    printf("result: %d\n", result);
    printf("testResult: %d\n", testFunction(a,b,testResult));

    return 0;
}

int testFunction(int a, int b, int testResult){
    if (a < b) {
        testResult = (8 * a) / (a - b);
    } else if (a > b) {
        testResult = (b * b) / 8;
    } else {
        testResult = 0;
        int limit = abs(a / 3);
        for (int i = 1; i <= limit; i++) {
            testResult += i;
        }
    }

    return testResult;
}
