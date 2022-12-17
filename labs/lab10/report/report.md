---
## Front matter
title: Отчет по лабораторной работа №10
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

Приобретение навыков написания программ с использованием подпрограмм. Знакомство с методами отладки при помощи GDB и его основными возможностями.

# Основная часть

## Выполнение лабораторной работы

### Реализация подпрограмм в NASM

Для выполнения лабораторной работы создали каталог ~/work/study/arch-pc/lab10. В нем создали файл lab10-1.asm и ввели текст из Листинга [-@lst:lst01]. Также положили в каталог файл in_out.asm, использованный в лабораторной работе №6.

```{#lst:lst01 .nasm caption=". Пример программы с использованием вызова подпрограммы"}
%include 'in_out.asm'

SECTION .data
    msg: DB 'Введите x: ',0
    result: DB '2x+7=',0

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
; выражения "2x+7"
    _calcul:
	mov ebx,2
	mul ebx
	add eax,7
	mov [rez],eax
	ret ; выход из подпрограммы
```

Создали исполняемый файл и запустили его (Рис. [-@fig:fig01]). 

![Результат запуска файла lab10-1.](/home/dastarikov/work/study/2022-2023/Архитектура компьютера/arch-pc/labs/lab10/report/image/image01.png){#fig:fig01}

Затем изменили текст программы, добавив еще одну подпрограмму `_subcalcul`, которая вычисляет значение $g(x)=3*x-1$, а в результате вычисляется значение выражения $f(g(x))$ и выводится на экран (Листинг [-@lst:lst02]).

```{#lst:lst02 .nasm caption="Вычисление выражения f(g(x)) с использованием жвух подпрограмм."}
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
```
Создали исполняемый файл и запустили его (Рис. [-@fig:fig02]).

![Вычсиление f(g(x)).](/home/dastarikov/work/study/2022-2023/Архитектура компьютера/arch-pc/labs/lab10/report/image/image02.png){#fig:fig02}

### Отладка программ с помощью GDB

Создали файл lab10-2.asm и ввели текст из Листинга [-@lst:lst03].

```{#lst:lst03 .nasm caption="Программа вывода сообщения Hello world!"}
SECTION .data

    msg1:	db "Hello, ",0x0
    msg1Len:	equ $ - msg1
    msg2:	db "world!",0xa
    msg2Len:	equ $ - msg2

SECTION .text
    global _start

_start:
    mov eax, 4
    mov ebx, 1
    mov ecx, msg1
    mov edx, msg1Len
    int 0x80
    
    mov eax, 4
    mov ebx, 1
    mov ecx, msg2
    mov edx, msg2Len
    int 0x80
    
    mov eax, 1
    mov ebx, 0
    int 0x80
```

Для работы с отладчиком GDB при трансляции исполняемого файла добавили ключ `-g` (Рис. [-@fig:fig03]).

![Компиляция файла lab10-2.asm](/home/dastarikov/work/study/2022-2023/Архитектура компьютера/arch-pc/labs/lab10/report/image/image03.png){#fig:fig03}

Загрузили исполняемый файл в отладчик GDB и проверили работы по команде `run` (Рис. [-@fig:fig04]).

![Обычный запуск программы.](/home/dastarikov/work/study/2022-2023/Архитектура компьютера/arch-pc/labs/lab10/report/image/image04.png){#fig:fig04}

Далее установили брейкпоинт на метку `_start`, и еще раз запустили ее (Рис. [-@fig:fig05]).
 
![Установлен брейкпоинт.](/home/dastarikov/work/study/2022-2023/Архитектура компьютера/arch-pc/labs/lab10/report/image/image05.png){#fig:fig05}

Посмотрели дисассемблированный код программы в режиме AT&T и Intel (Рис. [-@fig:fig06] и [-@fig:fig07]). Основные различия синтаксисов: противоположное расположение операнда-источника и операнда-приемника (в Intel - приемник, источник, а в AT&T - источник, приемник); в AT&T регистры пишутся после '%', а непосредственные операнды после '$', в синтаксисе Intel операнды никак не помечаются. 

![Дисассемблированный код программы в режиме ATT](/home/dastarikov/work/study/2022-2023/Архитектура компьютера/arch-pc/labs/lab10/report/image/image06.png){#fig:fig06}

![Дисассемблированный код программы в режиме Intel](/home/dastarikov/work/study/2022-2023/Архитектура компьютера/arch-pc/labs/lab10/report/image/image07.png){#fig:fig07}

Включили режим псевдографики для более удобного анализа (Рис. [-@fig:fig08]).

![Режим псевдографики GDB.](/home/dastarikov/work/study/2022-2023/Архитектура компьютера/arch-pc/labs/lab10/report/image/image08.png){#fig:fig08}

Проверили установленные брейкпоинты по команде `info breakpoints` (Рис. [-@fig:fig09]).

![Список установленных брейкпоинтов.](/home/dastarikov/work/study/2022-2023/Архитектура компьютера/arch-pc/labs/lab10/report/image/image09.png){#fig:fig09}

Добавили еще одну точку остановки по адресу инструкции `mov ebx, 0x0` (Рис. [-@fig:fig10]).

![Добавление новой точки остановки.](/home/dastarikov/work/study/2022-2023/Архитектура компьютера/arch-pc/labs/lab10/report/image/image10.png){#fig:fig10}

С помощью инструкции `stepi` (сокращенно `si`) выполнили 5 последующих инструкций. В результате изменяются значения регистров eax, ebx, ecx, edx (Рис. [-@fig:fig11]). 

![Выполнение первых 5 инструкций.](/home/dastarikov/work/study/2022-2023/Архитектура компьютера/arch-pc/labs/lab10/report/image/image11.png){#fig:fig11}

Посмотрели значения переменных `msg1` и `msg2`, причем адрес памяти `msg1` задали по имени переменной, а адрес памяти `msg2` вписали вручную, взяв его из дисассемблированного кода программы (Рис. [-@fig:fig12]).

![Вывод значения переменных `msg1` и `msg2`.](/home/dastarikov/work/study/2022-2023/Архитектура компьютера/arch-pc/labs/lab10/report/image/image12.png){#fig:fig12}

С помощью команды `set` заменили в `msg1` первый символ, в переменной `msg2` - второй (Рис. [-@fig:fig13] и [-@fig:fig14]).

![Изменение значения переменной `msg1`.](/home/dastarikov/work/study/2022-2023/Архитектура компьютера/arch-pc/labs/lab10/report/image/image13.png){#fig:fig13}

![Изменение значения переменной `msg2`.](/home/dastarikov/work/study/2022-2023/Архитектура компьютера/arch-pc/labs/lab10/report/image/image14.png){#fig:fig14}

Вывели значения регистра `edx` в десятичном, шестнадцатиричном и двоичном формате, соответственно (Рис. [-@fig:fig15]). 

![Значение регистра `edx`.](/home/dastarikov/work/study/2022-2023/Архитектура компьютера/arch-pc/labs/lab10/report/image/image15.png){#fig:fig15}

Использовав команду `set` изменили значение регистра `ebx` сначала на символ '2', а затем на число 2, и сравнили вывод значения регистра в десятичном формате. В результате присвоения регистра значение символа '2', выводится число 50, что соответствует символу в '2' в таблице ASCII (Рис. [-@fig:fig16]).

![Изменение значнения регистра ebx.](/home/dastarikov/work/study/2022-2023/Архитектура компьютера/arch-pc/labs/lab10/report/image/image16.png){#fig:fig16}

Затем завершили выполнение программы командой `continue` (сокращенно `c`), и вышли из GDB по команде `exit`.

Для примера обработки аргментов командоной строки в GDB скопировали файл lab9-2.asm из Лабораторной работы №9 (программа выводит на экран аргументы командной строки) в файл lab10-3.asm, создали исполняемый файл и запустили в GDB с ключом `--args` (Рис. [-@fig:fig17]).

![Загразка в GDB программы lab10-3 с аргументами.](/home/dastarikov/work/study/2022-2023/Архитектура компьютера/arch-pc/labs/lab10/report/image/image17.png){#fig:fig17}

Установили брейкпоинт в начале программы, посмотрели значение регистра esp, равное количеству аргументов командной строки, включая имя программы, и остальные позиции стека (Рис. [-@fig:fig19]). Каждый элемент стека занимает 4 байта, поэтому для получения следующего элемента стека мы добавляем 4 к адресу вершины.

![Значения элементов стека.](/home/dastarikov/work/study/2022-2023/Архитектура компьютера/arch-pc/labs/lab10/report/image/image18.png){#fig:fig19}

## Выполнение заданий для самостоятельной работы.

### Задание 1. 

Написали программу lab10-4.asm (Листинг [-@lst:lst04]), являющуюся измененной версией программы lab09-var12.asm, но вычисление $f(x)=15*x-9$ реализовано как подпрограмма (Рис. [-@fig:fig20]). 

![Результат работы программы lab10-4.](/home/dastarikov/work/study/2022-2023/Архитектура компьютера/arch-pc/labs/lab10/report/image/image20.png){#fig:fig20}

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
    call _calcul ; вызываем подпрограмму для вычисления f(x)

    add esi,eax ; добавляем к промежуточной сумме
	    ; след. аргумент `esi=esi+eax`
    loop next ; переход к обработке следующего аргумента
_end:
    mov eax, msg2 ; вывод сообщения "Результат: "
    call sprint
    mov eax, esi ; записываем сумму в регистр `eax`
    call iprintLF ; печать результата
    call quit ; завершение программы

_calcul:  ; подпрограмма для вычисления f(x)=15*x-9
    mov ebx, 15
    mul ebx
    sub eax, 9
    ret
```

### Задание 2.

Создали программу lab10-5.asm по Листингу [-@lst:lst05], вычисляющую выражение $(3+2)*4+5$, но неверно (Рис. [-@fig:fig21]).

![Результат работы программы lab10-5 (неверный ответ).](/home/dastarikov/work/study/2022-2023/Архитектура компьютера/arch-pc/labs/lab10/report/image/image21.png){#fig:fig21}

```{#lst:lst05 .nasm caption="Программа вычисления выражения (3+2)*4+5 (неверная)."}
%include 'in_out.asm'

SECTION .data
div: DB 'Результат: ',0

SECTION .text
GLOBAL _start

_start:

    ; ---- Вычисление выражения (3+2)*4+5
    mov ebx,3
    mov eax,2
    add ebx,eax
    mov ecx,4
    mul ecx
    add ebx,5
    mov edi,ebx

    ; ---- Вывод результата на экран
    mov eax,div
    call sprint
    mov eax,edi
    call iprintLF
    
    call quit
```

Проанализировали с помощью отладичка GDB изменение значений регистров, чтобы найти ошибку. Установили брейкпоинт `b _start`, включили режим псевдографики и начали поочердно выполнять команды и следить за значениями регистров. Первая ошибка - результат $3+2=5$ записан в регистре ebx (команда `add ebx, eax`), но  команда `mul` всегда перемножает значение регистра eax с указанным сомножителем, поэтому `mul ecx` дает неверный результат: $(3+2)*4=5$. (Рис. [-@fig:fig22]). Затем на убеждении, что регистр ebx содержит корректный результат вычислений, к нему добавляется число 5, результат запоминается в регистре edi, а затем выводится (Рис. [-@fig:fig23]).

![Некорректное использование команды mul.](/home/dastarikov/work/study/2022-2023/Архитектура компьютера/arch-pc/labs/lab10/report/image/image22.png){#fig:fig22}

![В регистре ebx содержится неверный ответ.](/home/dastarikov/work/study/2022-2023/Архитектура компьютера/arch-pc/labs/lab10/report/image/image23.png){#fig:fig23}

Исправили текст программы (Листинг [-lst:lst06]) и убедились в верном вычислении резульата (Рис [-fig:fig24]).

```{#lst:lst06 .nasm caption="Программа вычисления выражения (3+2)*4+5 (неверная)."}
%include 'in_out.asm'

SECTION .data
div: DB 'Результат: ',0

SECTION .text
GLOBAL _start

_start:

    ; ---- Вычисление выражения (3+2)*4+5
    mov ebx,3
    mov eax,2
    add eax,ebx
    mov ecx,4
    mul ecx
    add eax,5
    mov edi,eax

    ; ---- Вывод результата на экран
    mov eax,div
    call sprint
    mov eax,edi
    call iprintLF
    
    call quit
```

![Правильный результат вычисления выражения.](/home/dastarikov/work/study/2022-2023/Архитектура компьютера/arch-pc/labs/lab10/report/image/image24.png){#fig:fig24}

Созданные файлы *.asm скопировали в каталог ~/work/study/2022-2023/"Архитектура компьютера"/archpc/labs/lab10/ и загрузили на Github. 

# Выводы

В рамках лабораторной работы получили практические навыки использования подпрограмм и познакомились с методами отладки для более глубокого анализа работы программы.
