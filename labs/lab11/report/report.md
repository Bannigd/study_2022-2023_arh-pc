---
## Front matter
title: Отчет по лабораторной работе №11
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

Приобретение навыков написания программ для работы с файлами.

# Основная часть

## Выполнение лабораторной работы

Для выполнения лабораторной работы создали каталог ~/work/study/arch-pc/lab11. В нем создали файл lab11-1.asm и ввели текст из [Листинга 1](#list01). Также создали пустой файл readme.txt и положили в каталог файл in_out.asm, использованный в лабораторной работе №6.

[**Листинг 1. Программа записи в файл сообщения.**]{#list01} 

```nasm
%include 'in_out.asm'
SECTION .data
    filename db 'readme.txt', 0h ; Имя файла
    msg db 'Введите строку для записи в файл: ', 0h ; Сообщение
SECTION .bss
    contents resb 255 ; переменная для вводимой строки
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
; --- Открытие существующего файла (`sys_open`)
    mov ecx, 2 ; открываем для записи (2)
    mov ebx, filename
    mov eax, 5
    int 80h
; --- Запись дескриптора файла в `esi`
    mov esi, eax
; --- Расчет длины введенной строки
    mov eax, contents ; в `eax` запишется количество
    call slen ; введенных байтов
; --- Записываем в файл `contents` (`sys_write`)
    mov edx, eax
    mov ecx, contents
    mov ebx, esi
    mov eax, 4
    int 80h
; --- Закрываем файл (`sys_close`)
    mov ebx, esi
    mov eax, 6
    int 80h
    call quit
```

Создали исполняемый файл и запустили его (Рис. [-@fig:fig01]).

![Результат запуска файла lab11-1.](/home/dastarikov/work/study/2022-2023/Архитектура компьютера/arch-pc/labs/lab11/report/image/image01.png){#fig:fig01}

С помощью команды `chmod` изменили права доступа к исполняемому файлу `lab11-1`, запретив его выполнение. В результате, при попытке выполнить файл, появляется ошибка, так как отсутствует доступ к его выполнению (Рис. [-@fig:fig02]). 

![Изменение параметров доступа к файлу lab11-1.](/home/dastarikov/work/study/2022-2023/Архитектура компьютера/arch-pc/labs/lab11/report/image/image02.png){#fig:fig02}

Теперь добавили права на исполнение к файлу lab11-1.asm, хранящий исходный текст программы. При попытке его выполнить, получаем ошибку, так как система ожидает набор машинных кодов, который может прочитать процессор, но не получает его (Рис. [-@fig:fig03]). 

![Попытка запустить файл  lab11-1.asm](/home/dastarikov/work/study/2022-2023/Архитектура компьютера/arch-pc/labs/lab11/report/image/image03.png){#fig:fig03}

Затем изменили права доступа к файлу `readme.txt` в соответствии с Вариантом 12: `--x -wx r-x `, что соответствует набору `135`. С помощью команды `ls -l` проверили корректность предоставленных прав (Рис. [-@fig:fig04]). 

![Изменение прав доступа к файлу readme.txt](/home/dastarikov/work/study/2022-2023/Архитектура компьютера/arch-pc/labs/lab11/report/image/image04.png){#fig:fig04}

## Выполнение заданий для самостоятельной работы.

Создали файл lab11-2.asm ([Листинг 2](#list02)), работающий по следующему алгоритму:

*	Вывести приглашение “Как Вас зовут?”
*	Ввести с клавиатуры свои фамилию и имя
*	Создать файл с именем name.txt
*	Записать в файл сообщение “Меня зовут”
*	Дописать в файл строку, введенную с клавиатуры
*	Закрыть файл	

[**Листинг 2. Программа записи имени и фамилии в файл.**]{#list02}

```nasm
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
    cld ; обнуляет флаг направления DF, 
    			;чтобы адреса увеличивались (слева направо)
    rep movsb ; побайтовое копирование из esi в edi, кол-во раз записано в ecx.
    mov eax, contents 
    call slen
    mov ecx, eax ; eax содержит длину строки contents
    mov esi, contents
    mov edi, outLine+msg2Len ; сдвигаем начало копирования на длину msg2
    cld
    rep movsb
; --- Создание нового файла (`sys_creat`)
    mov ecx, 0666o ; установка прав доступа 
    			;(110 110 110, т.е. без права исполнения)
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
```

Запустили программу, ввели имя и фамилию и затем проверили содержимое файла `name.txt` и права доступа к нему (Рис. [-@fig:fig05]).

![Результат работы программы lab11-2.](/home/dastarikov/work/study/2022-2023/Архитектура компьютера/arch-pc/labs/lab11/report/image/image05.png){#fig:fig05}

# Выводы

В рамках лабораторной работы получили практические навыки работы с файлами средствами Nasm и изучили особенности прав доступа к файлам.
