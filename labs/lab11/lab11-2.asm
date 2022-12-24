%include 'in_out.asm'
SECTION .data
    filename db 'name.txt', 0h ; Имя файла
    msg db 'Введите фамилию и имя : ', 0h ; Сообщение
    msg2 db 'Меня зовут '
    msg2Len EQU $-msg2
SECTION .bss
    contents resb 255 ; переменная для вводимой строки
    outLine times 255+msg2Len resb 1; строка out имеет длину msg2Len+255
SECTION .text
    global _start
_start:
; --- Печать сообщения `msg`
    mov eax,msg
    call sprint
; ---- Запись введеной с клавиатуры строки в `contents`
    mov ecx, contents
    mov edx, 255
    call sread
; --- Объединение двух строк msg2 и contents
    mov ecx, msg2Len
    mov esi, msg2
    mov edi, outLine
    cld ; обнуляет флаг направления DF, чтобы адреса увеличивались (слева направо)
    rep movsb ; побайтовое копирование из esi в edi, кол-во раз записано в ecx.
    mov eax, contents 
    call slen
    mov ecx, eax ; eax содержит длину строки contents
    mov esi, contents
    mov edi, outLine+msg2Len ; сдвигаем начало копирования на длину msg2
    cld
    rep movsb
; --- Создание нового файла (`sys_creat`)
    mov ecx, 0666o ; установка прав доступа (110 110 110, т.е. без права исполнения)
    mov ebx, filename ; имя файла
    mov eax, 8 ; номер системного вызова `sys_creat`
    int 80h
; --- Открытие существующего файла (`sys_open`)
    mov ecx, 2 ; открываем для записи (2)
    mov ebx, filename
    mov eax, 5
    int 80h
; --- Запись дескриптора файла в `esi`
    mov esi, eax
; --- Записываем в файл `outLine` (`sys_write`)
    mov eax, outLine
    call slen
    mov edx, eax
    mov ecx, outLine
    mov ebx, esi
    mov eax, 4
    int 80h
; --- Закрываем файл (`sys_close`)
    mov ebx, esi
    mov eax, 6
    int 80h
    call quit
