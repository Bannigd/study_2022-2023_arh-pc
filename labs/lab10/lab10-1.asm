%include 'in_out.asm'

SECTION .data
    msg: DB 'Введите x: ',0
    result: DB 'f(x)=2x+7, g(x)= 3x-1, f(g(x)) = ',0

SECTION .bss
    x: RESB 80
    rez: RESB 80

SECTION .text

GLOBAL _start
	_start:

;------------------------------------------
; Основная программа
;------------------------------------------
    mov eax, msg
    call sprint
    
    mov ecx, x
    mov edx, 80
    call sread
    
    mov eax,x
    call atoi
    
    call _calcul ; Вызов подпрограммы _calcul
    
    mov eax,result
    call sprint
    mov eax,[rez]
    call iprintLF
    call quit
;------------------------------------------
; Подпрограмма вычисления
; выражения "f(g(x))"
    _calcul:
	call _subcalcul ; сначала вычисляем g(x)
	mov ebx,2
	mul ebx
	add eax,7
	mov [rez],eax
	ret ; выход из подпрограммы
	
;------------------------------------------
; Подпрограмма вычисления
; выражения "g(x)=3x-1"
    _subcalcul:
	mov ebx, 3
	mul ebx
	dec eax
	ret 