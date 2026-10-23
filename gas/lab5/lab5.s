.section .data
    prompt: .asciz "Введите строку: "
    fmt_in: .asciz "%255[^\n]"  
    fmt_out: .asciz "Результат: %s\nКоличество замен: %d\n"

# prompt - имя области памяти
# .asciz - создает строку и добавляет в конец нуль сепаратор
# max 255 symbols 


.section .bss
    .lcomm str, 256
# используется для выделения неинициализированной области памяти 
# имя размер

.section .text
    .global main
    .extern printf
    .extern scanf


main:
    push %rbp
    mov %rsp, %rbp

    
    lea prompt(%rip), %rdi
    xor %eax, %eax
    call printf

    # остановиться поподробнее 

    lea fmt_in(%rip), %rdi
    lea str(%rip), %rsi
    xor %eax, %eax
    call scanf

    
    lea str(%rip), %rsi     
    xor %ecx, %ecx          


loop:
    movb (%rsi), %al       
    cmpb $0, %al            
    je done

    cmpb $'0', %al
    jl next_char
    cmpb $'9', %al
    jg next_char

    movb $'!', (%rsi)  
    # в rsi - долгосрок      
    incl %ecx               
    # типо int 

next_char:
    inc %rsi
    jmp loop


done:
    lea fmt_out(%rip), %rdi
    lea str(%rip), %rsi
    mov %ecx, %edx  # edx т.к ecx не является регистром 3го аргумента нужен rdx 
    xor %eax, %eax
    call printf

    mov $0, %eax
    leave
    ret # извлекает и возвращает обратно 

    # leave в данном контексте полезная вещь
    # т.к она заменяет сразу 2 команды 
    # возвращение указателья стека в изначальное положение
    # и восстанавление старого значения регистра rbp 