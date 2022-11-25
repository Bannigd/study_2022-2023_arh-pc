%include "in_out.asm"

SECTION .data

    msg: DB "Выражение f(x)= (8*x-6)/2", 10, "Введите значение x:", 0
    div: DB 'Результат: ', 0

SECTION .bss

    x:  RESB 80 ; буфер размером 80 байт

SECTION .text
    GLOBAL _start

    _start:
;Вывод строки с выражением f(x)
    mov eax, msg
    call sprint

;Ввод значения x
    mov ecx, x
    mov edx, 80
    call sread

;Преобразование ввода в числовой вид
    mov eax, x
    call atoi; EAX=x как число

;Вычисление выражения
    mov ebx, 8
    mul ebx; EAX=EAX*EBX
    sub eax, 6; EAX= EAX-6
    
    xor edx,edx; обнуляем значение регистра EDX для корректной работы команды div
    mov ebx, 2
    div ebx; EAX=EAX/EBX - частное, EDX= EAX % EBX - остаток от деления
    mov [x], eax; Сохраняю результат вычислений в адрес x

;Вывод результата вычислений
    mov eax, div
    call sprint
    mov eax, [x]
    call iprintLF
    
    call quit
