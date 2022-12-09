---
## Front matter
title: Отчет по лабораторной работа №9
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

Приобретение навыков написания программ с использованием циклов и обработкой аргументов командной строки.

# Основная часть

## Выполнение лабораторной работы

### Реализация циклов в NASM

Для выполнения лабораторной работы создали каталог ~/work/study/arch-pc/lab09. В нем создали файл lab9-1.asm и ввели текст из Листинга [-@lst:lst01]. Также положили в каталог файл in_out.asm, использованный в лабораторной работе №6.

```{#lst:lst01 .nasm caption="Программа вывода значений регистра ecx"}
;-----------------------------------------------------------------
; Программа вывода значений регистра 'ecx'
;-----------------------------------------------------------------
%include 'in_out.asm'

SECTION .data
    msg1 db 'Введите N: ',0h

SECTION .bss
    N: resb 10

SECTION .text
    global _start
_start:

; ----- Вывод сообщения 'Введите N: '
    mov eax,msg1
    call sprint

; ----- Ввод 'N'
    mov ecx, N
    mov edx, 10
    call sread

; ----- Преобразование 'N' из символа в число
    mov eax,N
    call atoi
    mov [N],eax

; ------ Организация цикла
    mov ecx,[N] ; Счетчик цикла, `ecx=N`
label:
    mov [N],ecx
    mov eax,[N]
    call iprintLF ; Вывод значения `N`
    
    loop label ; `ecx=ecx-1` и если `ecx` не '0'
				; переход на `label`
    call quit
```

Создали исполняемый файл и запустили его (Рис. [-@fig:fig01]). 

![Результат запуска файла lab9-1.](/home/dastarikov/work/study/2022-2023/Архитектура компьютера/arch-pc/labs/lab09/report/image/image01.png){#fig:fig01}

Так как регистр ecx используется для задания количества итераций цикла, его использование в теле цикла может привести к некорректной работе программы. Продемонстрировали это, добавив изменение регистра ecx в теле цикла:

```nasm
label:
    sub ecx,1   ; `ecx=ecx-1`
    mov [N],ecx
    mov eax,[N]
    call iprintLF
    
    loop label
```

В результате в ходе выполнения одной итерации цикла регистр уменьшается на 2, и общее количество итерации становится меньше, при этом в зависимости от ввода N, проверка ecx = 0 может не наступить, что приведет к бесконечному выполнению программы (Рис. [-@fig:fig02] и [-@fig:fig03]).

![Программа завершила работу, но число циклов меньше N.](/home/dastarikov/work/study/2022-2023/Архитектура компьютера/arch-pc/labs/lab09/report/image/image02.png){#fig:fig02}

![Бесконечный ход программы.](/home/dastarikov/work/study/2022-2023/Архитектура компьютера/arch-pc/labs/lab09/report/image/image03.png){#fig:fig03}

Для использования значения регистра в цикле и сохранения работы в программе воспользовались стеком. Изменили текст программы, добавив команды push и pop:

```nasm
label:
    push ecx       ; добавление значения ecx в стек
    sub ecx,1
    mov [N],ecx
    mov eax,[N]
    call iprintLF
    pop ecx        ; извлечение значения ecx из стека

    loop label
```

Создали исполняемый файл и запустили его (Рис. [-@fig:fig04]). Количество итерации цикла совпадает со значением N.

![Использование стека.](/home/dastarikov/work/study/2022-2023/Архитектура компьютера/arch-pc/labs/lab09/report/image/image04.png){#fig:fig04}

### Обработка аргументов командной строки

В соотвествии с Листингом [-@lst:lst02] написали программу lab9-2.asm, выводящую аргументы командной строки. Создали исполняемый файл и запустили его с аргументами (Рис. [-@fig:fig05]). Программа обработала 4 аргумента, разделенных проблемами.

```{#lst:lst02 .nasm caption="Программа выводящая на экран аргументы командной строки"}
%include 'in_out.asm'

SECTION .text

global _start

_start:
    pop ecx ; Извлекаем из стека в `ecx` количество
	    ; аргументов (первое значение в стеке)
    pop edx ; Извлекаем из стека в `edx` имя программы
	    ; (второе значение в стеке)
    sub ecx, 1 ; Уменьшаем `ecx` на 1 (количество
		; аргументов без названия программы)
next:
    cmp ecx, 0 ; проверяем, есть ли еще аргументы
    jz _end ; если аргументов нет выходим из цикла
	    ; (переход на метку `_end`)
    pop eax ; иначе извлекаем аргумент из стека
    call sprintLF ; вызываем функцию печати
    loop next ; переход к обработке следующего
	    ; аргумента (переход на метку `next`)

_end:
    call quit
```

![Сообщения выводятся в обратном порядке.](/home/dastarikov/work/study/2022-2023/Архитектура компьютера/arch-pc/labs/lab09/report/image/image05.png){#fig:fig05}

В качестве другого примера работы с аргументами командной строки написали программу lab9-3.asm, выводящую сумму чисел, переданных как аргументы (Листинг [-@lst:lst03]). Создали исполняемый файл и запустили его (Рис. [-@fig:fig06]).

```{#lst:lst03 .nasm caption="Программа вычисления суммы аргументов командной строки"}
%include 'in_out.asm'

SECTION .data
    msg db "Результат: ",0

SECTION .text
    global _start

_start:
    pop ecx ; Извлекаем из стека в `ecx` количество
	    ; аргументов (первое значение в стеке)
    pop edx ; Извлекаем из стека в `edx` имя программы
	    ; (второе значение в стеке)
    sub ecx,1 ; Уменьшаем `ecx` на 1 (количество
		; аргументов без названия программы)
    mov esi, 0 ; Используем `esi` для хранения
		; промежуточных сумм
next:
    cmp ecx,0h ; проверяем, есть ли еще аргументы
    jz _end ; если аргументов нет выходим из цикла
	    ; (переход на метку `_end`)
    pop eax ; иначе извлекаем следующий аргумент из стека
    call atoi ; преобразуем символ в число
    add esi,eax ; добавляем к промежуточной сумме
	    ; след. аргумент `esi=esi+eax`
    loop next ; переход к обработке следующего аргумента
_end:
    mov eax, msg ; вывод сообщения "Результат: "
    call sprint
    mov eax, esi ; записываем сумму в регистр `eax`
    call iprintLF ; печать результата
    call quit ; завершение программы
```

![Результат работы программы lab9-3.](/home/dastarikov/work/study/2022-2023/Архитектура компьютера/arch-pc/labs/lab09/report/image/image06.png){#fig:fig06}

Заменили текст программы, чтобы выводилось произведение чисел:

```nasm
    pop eax ; иначе извлекаем следующий аргумент из стека
    call atoi ; преобразуем символ в число
    mov ebx, eax ; сохраняем значений аргумент в ebx для умножения
    mov eax, esi ; сохраняем esi в eax, чтобы домножить на аргумент
    mul ebx ; умножаем eax*ebx == промежуточное произвдение на аргумент
    mov esi, eax ; сохраняем значение получившейся суммы обратно в esi
```

Создали исполняемый файл и запустили его (Рис. [-@fig:fig08]).

![Вывод произведения аргументов](/home/dastarikov/work/study/2022-2023/Архитектура компьютера/arch-pc/labs/lab09/report/image/image08.png){#fig:fig08}

## Выполнение заданий для самостоятельной работы.

Для выполнения заданий выбран вариант 12, полученный при выполнении лабораторной работы №7.

Написали программу lab9-var12.asm (Листинг [-@lst:lst04]), находящую сумму значений функции $f(x)=15*x-9$ для $x=x_1, x_2, ..., x_n$, причем числа вводят как аргументы командной строки (Рис. [-@fig:fig07]). 

![Результат работы программы lab9-var12.](/home/dastarikov/work/study/2022-2023/Архитектура компьютера/arch-pc/labs/lab09/report/image/image07.png){#fig:fig07}

```{#lst:lst04 .nasm caption="Программа находит сумму значений функции"}
%include 'in_out.asm'

SECTION .data
    msg1 db "Функция: f(x)=15*x-9 ",0
    msg2 db "Результат: ",0
SECTION .text
    global _start

_start:

    mov eax, msg1
    call sprintLF
    
    mov ebx, 15 ; регистр ebx используем для умножения
    
    pop ecx ; Извлекаем из стека в `ecx` количество
	    ; аргументов (первое значение в стеке)
    pop edx ; Извлекаем из стека в `edx` имя программы
	    ; (второе значение в стеке)
    sub ecx,1 ; Уменьшаем `ecx` на 1 (количество
		; аргументов без названия программы)
    mov esi, 0 ; Используем `esi` для хранения
		; промежуточных сумм
next:
    cmp ecx,0h ; проверяем, есть ли еще аргументы
    jz _end ; если аргументов нет выходим из цикла
	    ; (переход на метку `_end`)
    pop eax ; иначе извлекаем следующий аргумент из стека
    call atoi ; преобразуем символ в число
    mul ebx ; eax=eax*ebx
    sub eax,9 ; eax=eax-9
    add esi,eax ; добавляем к промежуточной сумме
	    ; след. аргумент `esi=esi+eax`
    loop next ; переход к обработке следующего аргумента
_end:
    mov eax, msg2 ; вывод сообщения "Результат: "
    call sprint
    mov eax, esi ; записываем сумму в регистр `eax`
    call iprintLF ; печать результата
    call quit ; завершение программы
```

Созданные файлы *.asm скопировали в каталог ~/work/study/2022-2023/"Архитектура компьютера"/archpc/labs/lab09/ и загрузили на Github. 

# Выводы

В рамках лабораторной работы получили практические навыки построения циклов и обработки аргументов командной строки при написании программ.
