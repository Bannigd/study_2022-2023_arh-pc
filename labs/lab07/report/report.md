---
## Front matter
title: Отчет по лабораторной работа №7
author: Стариков Данила Андреевич
subtitle: Группа НПИбд-02-22

## Generic otions
lang: ru-RU
toc-title: "Содержание"

## Bibliography
bibliography: bib/cite.bib
csl: pandoc/csl/gost-r-7-0-5-2008-numeric.csl

## Pdf output format
toc: true # Table of contents
toc-depth: 2
lof: false # List of figures
lot: false # List of tables
fontsize: 12pt
linestretch: 1.5
papersize: a4
documentclass: scrreprt
## I18n polyglossia
polyglossia-lang:
  name: russian
  options:
	- spelling=modern
	- babelshorthands=true
polyglossia-otherlangs:
  name: english
## I18n babel
babel-lang: russian
babel-otherlangs: english
## Fonts
mainfont: PT Serif
romanfont: PT Serif
sansfont: PT Sans
monofont: PT Mono
mainfontoptions: Ligatures=TeX
romanfontoptions: Ligatures=TeX
sansfontoptions: Ligatures=TeX,Scale=MatchLowercase
monofontoptions: Scale=MatchLowercase,Scale=0.9
## Biblatex
biblatex: true
biblio-style: "gost-numeric"
biblatexoptions:
  - parentracker=true
  - backend=biber
  - hyperref=auto
  - language=auto
  - autolang=other*
  - citestyle=gost-numeric
## Pandoc-crossref LaTeX customization
figureTitle: "Рис."
tableTitle: "Таблица"
listingTitle: "Листинг"
lofTitle: "Список иллюстраций"
lotTitle: "Список таблиц"
lolTitle: "Листинги"
## Misc options
indent: true
header-includes:
  - \usepackage{indentfirst}
  - \usepackage{float} # keep figures where there are in the text
  - \floatplacement{figure}{H} # keep figures where there are in the text
---

# Цель работы

Освоение арифметических инструкций языка ассемблера NASM.

# Основная часть

## Выполнение лабораторной работы

Для выполнения лабораторной работы создали каталог ~/work/study/arch-pc/lab07. В нем создали файл lab7-1.asm и ввели текст из Листинга [-@lst:lst01]. Также положили в каталог файл in_out.asm, использованный в лабораторной работе №6.

```{#lst:lst01 .nasm caption="Программа для вывода значения регистра eax"}
%include 'in_out.asm'

SECTION .bss
    buf1: RESB 80

SECTION .text
GLOBAL _start
    _start:
    
    mov eax,'6'
    mov ebx,'4'
    add eax,ebx
    mov [buf1],eax
    mov eax,buf1
    call sprintLF
    
    call quit
```

Создали исполняемый файл и запустили его (Рис. [-@fig:fig01]). На выводе получили символ 'j', так как в двоичном представлении код символа '6' - 00110110 (54 в десятичном), а код символа '4' - 00110100 (52). Команда add eax, ebx записала в регистр eax сумму кодов - 01101010 (106), что соответствует символу 'j' в ASCII.

![Результат запуска файла lab7-1.](/home/dastarikov/work/study/2022-2023/Архитектура компьютера/arch-pc/labs/lab07/report/image/image01.png){#fig:fig01}

Заменили текст программы и вместо символов записали в регистры числа:
```nasm
mov eax, '6'
mov ebx, '4'
```
на строки

```nasm
mov eax, 6
mov ebx, 4
```

Создали исполняемый файл и запустили (Рис. [-@fig:fig02]). В результате выполнения на экран выводится число с кодом 10, что соответствует символу переноса строки.

![Результат запуска файла lab7-1 после изменения текста программы.](/home/dastarikov/work/study/2022-2023/Архитектура компьютера/arch-pc/labs/lab07/report/image/image02.png){#fig:fig02}

Чтобы напечатать числа вместо ASCII символов изменили текст программы, создали файл lab7-2.asm, воспользовавшись подпрограммамми из файла in_out.asm (Листинг [-@lst:lst02]).

```{#lst:lst02 .nasm caption="Программа вывода значения регистра eax"}
%include 'in_out.asm'

SECTION .bss
    buf1: RESB 80

SECTION .text
GLOBAL _start
    _start:
    
    mov eax,'6'
    mov ebx,'4'
    add eax,ebx
    call iprintLF
    
    call quit
```

Создали исполняемый файл и запустили (Рис. [-@fig:fig03]). В результате выполнения на экран выводится число 106, так как в регистры были записаны символы '6' и '4'. Подпрограмма iprintLF позволила вывести число, а не символ, кодом которого является это число.

 ![Результат запуска файла lab7-2](/home/dastarikov/work/study/2022-2023/Архитектура компьютера/arch-pc/labs/lab07/report/image/image03.png){#fig:fig03}

Заменили текст программы и вместо символов записали в регистры числа:
```nasm
mov eax, '6'
mov ebx, '4'
```
на строки

```nasm
mov eax, 6
mov ebx, 4
```

Создали исполняемый файл и запустили (Рис. [-@fig:fig04]). В результате выполнения на экран выводится число 10. 

![Результат запуска файла lab7-2 после изменения текста программы.](/home/dastarikov/work/study/2022-2023/Архитектура компьютера/arch-pc/labs/lab07/report/image/image04.png){#fig:fig04}

Функция iprint, в отличии от iprintLF, не печатает символ переноса строки (Рис. [-@fig:fig05]).

![Результат запуска файла lab7-2 с функцией iprint](/home/dastarikov/work/study/2022-2023/Архитектура компьютера/arch-pc/labs/lab07/report/image/image05.png){#fig:fig05}

Для примера выполнения арифметических операций в NASM создали программу вычисления арифметического выражения $f(x) = (5*2+3)/3$.
Создали файл lab7-3.asm и ввели текст из Листинга [-@lst:lst03].

```{#lst:lst03 .nasm caption="Программа вычисления выражения f(x) = (5*2+3)/3"}
;--------------------------------
; Программа вычисления выражения
;--------------------------------
%include 'in_out.asm' ; подключение внешнего файла

SECTION .data

div: DB 'Результат: ', 0
rem: DB 'Остаток от деления: ', 0

SECTION .text
GLOBAL _start

_start:
; ---- Вычисление выражения
mov eax,5 ; EAX=5
mov ebx,2 ; EBX=2
mul ebx ; EAX=EAX*EBX
add eax,3 ; EAX=EAX+3
xor edx,edx ; обнуляем EDX для корректной работы div
mov ebx,3 ; EBX=3
div ebx ; EAX=EAX/3, EDX=остаток от деления
mov edi,eax ; запись результата вычисления в 'edi'

; ---- Вывод результата на экран
mov eax,div ; вызов подпрограммы печати
call sprint ; сообщения 'Результат: '
mov eax,edi ; вызов подпрограммы печати значения
call iprintLF ; из 'edi' в виде символов
mov eax,rem ; вызов подпрограммы печати
call sprint ; сообщения 'Остаток от деления: '
mov eax,edx ; вызов подпрограммы печати значения
call iprintLF ; из 'edx' (остаток) в виде символов

call quit ; вызов подпрограммы завершения
```

Cоздали исполняемый файл и запустили (Рис. [-@fig:fig06]). Заметим изменили программу в соответствии с Листингом [-@lst:lst04], чтобы она вычисляла выражение $f(x) = (4*6+2)/5$ (Рис. [-@fig:fig09]). 

![Результат запуска файла lab7-2 после изменения текста программы.](/home/dastarikov/work/study/2022-2023/Архитектура компьютера/arch-pc/labs/lab07/report/image/image06.png){#fig:fig06}

![Результат запуска файла lab7-2 после изменения текста программы.](/home/dastarikov/work/study/2022-2023/Архитектура компьютера/arch-pc/labs/lab07/report/image/image09.png){#fig:fig09}

```{#lst:lst04 .nasm caption="Программа вычисления выражения f(x) = (4*6+2)/5"}
;--------------------------------
; Программа вычисления выражения
;--------------------------------
%include 'in_out.asm' ; подключение внешнего файла

SECTION .data
div: DB 'Результат: ', 0
rem: DB 'Остаток от деления: ', 0
SECTION .text
GLOBAL _start

_start:
; ---- Вычисление выражения
mov eax,4 ; EAX=4
mov ebx,6 ; EBX=6
mul ebx ; EAX=EAX*EBX
add eax,2 ; EAX=EAX+2
xor edx,edx ; обнуляем EDX для корректной работы div
mov ebx,5 ; EBX=5
div ebx ; EAX=EAX/5, EDX=остаток от деления
mov edi,eax ; запись результата вычисления в 'edi'

; ---- Вывод результата на экран
mov eax,div ; вызов подпрограммы печати
call sprint ; сообщения 'Результат: '
mov eax,edi ; вызов подпрограммы печати значения
call iprintLF ; из 'edi' в виде символов
mov eax,rem ; вызов подпрограммы печати
call sprint ; сообщения 'Остаток от деления: '
mov eax,edx ; вызов подпрограммы печати значения
call iprintLF ; из 'edx' (остаток) в виде символов

call quit ; вызов подпрограммы завершения
```

В качестве другого примера рассмотрели задачу вычисления варианта задания по номеру студенческого билета, работающую по следующему алгоритму:

*	вывести запрос на введение № студенческого билета
*	вычислить номер варианта по формуле: $(S_n mod 20) + 1$, где $S_n$ – номер студенческого билета (В данном случае $a$ mod $b$ – это остаток от деления $a$ на $b$).
*	вывести на экран номер варианта.

Номер студенческого билета, т. е. число, надо которым будут проводиться арифметические вычисления, вводится с клавиатуры, необходимо преобразовать введенные символы в число, так как ввод с клавиатуры осуществляется в символьном виде. В файле in_out.asm для этого есть функция atoi.

Создали файл variant.asm и ввели текст из Листинга [-@lst:lst05]. При выполнении программы ввели номер студенческого билета (1132226531) и получили Вариант 12 (Рис. [-@fig:fig08]), что соответуствует подсчетам в уме.

```{#lst:lst05 .nasm caption="Программа вычисления варианта задания по номеру студенческого билета"}
;--------------------------------
; Программа вычисления варианта
;--------------------------------
%include 'in_out.asm'

SECTION .data
    msg: DB 'Введите № студенческого билета: ',0
    rem: DB 'Ваш вариант: ',0

SECTION .bss
    x: RESB 80
SECTION .text
    GLOBAL _start

    _start:
    mov eax, msg
    call sprintLF
    mov ecx, x
    mov edx, 80
    call sread

    mov eax,x ; вызов подпрограммы преобразования
    call atoi ; ASCII кода в число, `eax=x`
    xor edx,edx
    mov ebx,20
    div ebx
    inc edx

    mov eax,rem
    call sprint
    mov eax,edx
    call iprintLF

    call quit
```

![Результат запуска файла lab7-2 после изменения текста программы.](/home/dastarikov/work/study/2022-2023/Архитектура компьютера/arch-pc/labs/lab07/report/image/image08.png){#fig:fig08}

Ответы на вопросы:

1.	За вывод сообщения "Ваш вариант:" отвечают строки:
```nasm
mov eax,rem
call sprint
```
2.	Эти строки используются для чтения ввода с клавиатуры. В регистр ECX передает адрес буфера x, а в EDX - длина вводимой строки.
3.	Инструкция "call atoi" используется для вызова подпрограммы atoi, преобразующей символы в числа.
4.	За вычисление варианты отвечают строки:

```nasm
xor edx,edx
mov ebx,20
div ebx
inc edx
```
5. Остаток от деления записывается в регистр EDX.
6. Инструкция увеличивает значение регистра EDX на 1.
7. За вывод на экран результата вычислений отвечают строки:

```nasm
mov eax,edx
call iprintLF
```

## Выполнение заданий для самостоятельной работы.

Варианту 12 соответствует выражение $f(x) = (8x-6)/2$. Для проверки корректности работы программы ввели 2 числа $x_1 = 1, x_2 = 5$. Программа lav7-var12 принимает ввод с клавиатура в качестве значения x и выводит резульата вычисления выражения $f(x) = (8x-6)/2$, под делением принимается целочисленное деление с отбрасываем остатка (Рис. [-@fig:fig10]). Текст файла lab7-var12.asm соответствует Листингу [-@lst:lst06].

![Результат работы программы (Вариант 12)](/home/dastarikov/work/study/2022-2023/Архитектура компьютера/arch-pc/labs/lab07/report/image/image10.png){#fig:fig10}

```{#lst:lst06 .nasm caption="Программа вычисления выражения f(x) = (8x-6)/2"}
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
```

Созданные файлы *.asm скопировали в каталог ~/work/study/2022-2023/"Архитектура компьютера"/archpc/labs/lab07/ и загрузили на Github. 

# Выводы

В рамках лабораторной работы получили практические навыки использования арифметических инструкций языка ассемблера NASM. 
