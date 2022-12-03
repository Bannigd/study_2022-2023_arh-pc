%include 'in_out.asm'

section .data
    msgA db 'Введите A: ',0h
    msgB db 'Введите B: ',0h
    msgC db 'Введите C: ',0h

    msg2 db "Наибольшее число: ",0h

section .bss
    max resb 10    
    A resb 10
    B resb 10
    C resb 10

section .text
    global _start

_start:
; ---------- Получение переменной A
    mov eax, msgA
    call sprint

    mov ecx,A
    mov edx,10
    call sread

    mov eax,A
    call atoi ; Вызов подпрограммы перевода символа в число
    mov [A],eax ; запись преобразованного числа в 'A'

; ---------- Получение переменной B
    mov eax, msgB
    call sprint

    mov ecx,B
    mov edx,10
    call sread

    mov eax,B
    call atoi ; Вызов подпрограммы перевода символа в число
    mov [B],eax ; запись преобразованного числа в 'B'

; ---------- Получение переменной C
    mov eax, msgC
    call sprint

    mov ecx,C
    mov edx,10
    call sread

    mov eax,C
    call atoi ; Вызов подпрограммы перевода символа в число
    mov [C],eax ; запись преобразованного числа в 'C'

; ---------- Сравнение переменных

    mov ecx,[A] ; 'ecx = A'
    
    cmp ecx,[B] ; Сравниваем 'A' и 'B'
    jg check_2 ; если 'A>B', то переход на метку 'check_2',
    mov ecx,[B] ; иначе 'ecx = B'
    mov [max],ecx ; 'max = B'

check_2:
    mov [max], ecx 

; ---------- Сравниваем 'max(A,B)' и 'C'
    mov ecx,[max]
    cmp ecx,[C] ; Сравниваем 'max(A,B)' и 'C'
    jg fin ; если 'max(A,B)>C', то переход на 'fin',
    mov ecx,[C] ; иначе 'ecx = C'
    mov [max],ecx
; ---------- Вывод результата
fin:
    mov eax, msg2
    call sprint ; Вывод сообщения 'Наибольшее число: '
    mov eax,[max]
    call iprintLF ; Вывод 'max(A,B,C)'
    call quit ; Выход