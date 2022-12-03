%include 'in_out.asm'

section .data
    msgf db 'f(x) = a*x, x<5',10, 9, 'x-5, ','x>=5',0h
    msgx db 'Введите x: ',0h
    msga db 'Введите a: ',0h
    msg2 db 'f(x) = ',0h

section .bss
    res resb 10
    x resb 10
    a resb 10

section .text
    global _start

_start:
; ---------- Вывод функции
    mov eax, msgf
    call sprintLF

; ---------- Получение переменной x
    mov eax, msgx
    call sprint

    mov ecx,x
    mov edx,10
    call sread

    mov eax,x
    call atoi ; Вызов подпрограммы перевода символа в число
    mov [x],eax ; запись преобразованного числа в 'x'

; ---------- Получение переменной a
    mov eax, msga
    call sprint

    mov ecx,a
    mov edx,10
    call sread

    mov eax,a
    call atoi ; Вызов подпрограммы перевода символа в число
    mov [a],eax ; запись преобразованного числа в 'a'

; ---------- Проверка значения x (x<5 или part_2: x>=5)
    mov ecx,[x] ; 'ecx = x'
    
    cmp ecx,5 ; Сравниваем 'x' и '5'
    jge part_2 ; если 'x>=5', то переход на метку 'part_2',
    mov eax,[x] ; иначе вычисляем выражение a*x
    mov ebx,[a]
    mul ebx ; eax=eax*ebx
    mov [res], eax
    jmp end
part_2: ; вычисляем выражение x-5
    mov eax, [x]
    sub eax, 5
    mov [res], eax
; ---------- Вывод результата вычислений
end:
    mov eax, msg2
    call sprint ; Вывод сообщения 'f(x) = '
    mov eax,[res]
    call iprintLF ; Вывод результата
    call quit ; Выход