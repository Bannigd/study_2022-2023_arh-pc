---
## Front matter
title: Отчет по лабораторной работа №6
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

Приобретение практических навыков работы в Midnight Commander. Освоение инструкций языка ассемблера mov и int.

# Основная часть

## Выполнение лабораторной работы

С помощью Midnight Commander открыли каталог ~/work/arch-pc и создали папку lab06 (клавиша F7) для текущей работы (Рис. [-@fig:fig01]).

![Окно Midnight Commander. На левой стороне открыт каталог lab06.](/home/dastarikov/work/study/2022-2023/Архитектура компьютера/arch-pc/labs/lab06/report/image/image01.png){#fig:fig01}

Создали новый файл lab6.asm с помощью команды touch, открыли через редактор mcedit по клавише **F4** и скопировали текст программы из Листинга [-@lst:lst01]. 

```{#lst:lst01 .nasm caption="Программа вывода сообщения на экран и ввода строки с клавиатуры."}
;------------------------------------------------------------------
; Программа вывода сообщения на экран и ввода строки с клавиатуры
;------------------------------------------------------------------
;------------------- Объявление переменных ----------------
SECTION .data ; Секция инициированных данных
msg: DB 'Введите строку:',10 ; сообщение плюс
; символ перевода строки
msgLen: EQU $-msg ; Длина переменной 'msg'
SECTION .bss ; Секция не инициированных данных
buf1: RESB 80 ; Буфер размером 80 байт
;------------------- Текст программы -----------------
SECTION .text ; Код программы
GLOBAL _start ; Начало программы
_start: ; Точка входа в программу
;------------ Cистемный вызов `write`
; После вызова инструкции 'int 80h' на экран будет
; выведено сообщение из переменной 'msg' длиной 'msgLen'
mov eax,4 ; Системный вызов для записи (sys_write)
mov ebx,1 ; Описатель файла 1 - стандартный вывод
mov ecx,msg ; Адрес строки 'msg' в 'ecx'
mov edx,msgLen ; Размер строки 'msg' в 'edx'
int 80h ; Вызов ядра
;------------ системный вызов `read` ----------------------
; После вызова инструкции 'int 80h' программа будет ожидать ввода
; строки, которая будет записана в переменную 'buf1' размером 80 байт
mov eax, 3 ; Системный вызов для чтения (sys_read)
mov ebx, 0 ; Дескриптор файла 0 - стандартный ввод
mov ecx, buf1 ; Адрес буфера под вводимую строку
mov edx, 80 ; Длина вводимой строки
int 80h ; Вызов ядра
;------------ Системный вызов `exit` ----------------------
; После вызова инструкции 'int 80h' программа завершит работу
mov eax,1 ; Системный вызов для выхода (sys_exit)
mov ebx,0 ; Выход с кодом возврата 0 (без ошибок)
int 80h ; Вызов ядра
```

Сохранили файл и проверили, что текст сохранился, открыв файл в режиме чтения (Рис. [-@fig:fig04]).

![Просмотр текста программы lab6-1.asm в режиме чтения.](/home/dastarikov/work/study/2022-2023/Архитектура компьютера/arch-pc/labs/lab06/report/image/image04.png){#fig:fig04}

Выполнили трансляцию текста программы, компановку полученного объектного файла и запустили программу (Рис. [-@fig:fig05]).

![Результат работы программы lab6-1.](/home/dastarikov/work/study/2022-2023/Архитектура компьютера/arch-pc/labs/lab06/report/image/image05.png){#fig:fig05}

### Подключение внешнего файла in_out.asm

Скачали файл in\_out.asm со страницы курса в ТУИС и положили в рабочий каталог.

С помощью клавиши **F5** создали копию файла lab6-1.asm с именем lab6-2.asm и в соответствии с Листингом [-@lst:lst03] исправили текст программы (Рис. [-@fig:fig07]). Создали и запустили исполняемый файл (Рис. [-@fig:fig09]). Если в тексте программы заменить подпрограмму sprintLF на sprint, то после вывода строки не будет печаться пустая строка (Рис. [-@fig:fig10]).
 
![Каталог lab06 после создания файла lab6-2.asm](/home/dastarikov/work/study/2022-2023/Архитектура компьютера/arch-pc/labs/lab06/report/image/image07.png){#fig:fig07}

![Результат выполения программы lab6-1 с подпрогаммой sprintLF](/home/dastarikov/work/study/2022-2023/Архитектура компьютера/arch-pc/labs/lab06/report/image/image09.png){#fig:fig09}

![Результат выполения программы lab6-1 с подпрогаммой sprint](/home/dastarikov/work/study/2022-2023/Архитектура компьютера/arch-pc/labs/lab06/report/image/image10.png){#fig:fig10}

```{#lst:lst03 .nasm caption="Текст программы lab6-2.asm"}
;------------------------------------------------------------------
; Программа вывода сообщения на экран и ввода строки с клавиатуры
;------------------------------------------------------------------
%include 'in_out.asm'

SECTION  .data ; Секция инициированных данных
msg: DB 'Введите строку:',10 ; сообщение плюс
; символ перевода строки

SECTION .bss ; Секция не инициированных данных
buf1: RESB 80 ; Буфер размером 80 байт

;------------------- Текст программы -----------------
SECTION .text ; Код программы
    GLOBAL _start ; Начало программы
    _start: ; Точка входа в программы
    mov eax, msg ; запись адреса выводимого сообщения в `EAX`
    call sprintLF ; вызов подпрограммы печати сообщения
    
    mov ecx, buf1 ; запись адреса переменной в `EAX`
    mov edx, 80 ; запись длины вводимого сообщения в `EBX`
    call sread ; вызов подпрограммы ввода сообщения
    
    call quit ; вызов подпрограммы завершения
```

## Выполнение заданий для самостоятельной работы.

Создали копию lab6-1-new.asm файла lab6-1.asm, в котором написали блок вывода строки, полученной вводом с клавиатуры (Листинг [-@lst:lst04]). Результат работы программы на Рисунке [-@fig:fig12] 

![Результат выполения программы lab6-1-new.](/home/dastarikov/work/study/2022-2023/Архитектура компьютера/arch-pc/labs/lab06/report/image/image12.png){#fig:fig12}

```{#lst:lst04 .nasm caption="Текст программы lab6-1-new.asm"}
SECTION .data ; Секция инициированных данных
msg: DB 'Введите строку:',10 ; сообщение плюс
; символ перевода строки
msgLen: EQU $-msg ; Длина переменной 'msg'
SECTION .bss ; Секция не инициированных данных
buf1: RESB 80 ; Буфер размером 80 байт

;------------------- Текст программы -----------------
SECTION .text ; Код программы
GLOBAL _start ; Начало программы
_start: ; Точка входа в программу

;------------ Cистемный вызов `write`
; После вызова инструкции 'int 80h' на экран будет
; выведено сообщение из переменной 'msg' длиной 'msgLen'
mov eax,4 ; Системный вызов для записи (sys_write)
mov ebx,1 ; Описатель файла 1 - стандартный вывод
mov ecx,msg ; Адрес строки 'msg' в 'ecx'
mov edx,msgLen ; Размер строки 'msg' в 'edx'
int 80h ; Вызов ядра

;------------ системный вызов `read` ----------------------
; После вызова инструкции 'int 80h' программа будет ожидать ввода
; строки, которая будет записана в переменную 'buf1' размером 80 байт
mov eax, 3 ; Системный вызов для чтения (sys_read)
mov ebx, 0 ; Дескриптор файла 0 - стандартный ввод
mov ecx, buf1 ; Адрес буфера под вводимую строку
mov edx, 80 ; Длина вводимой строки
int 80h ; Вызов ядра

;------------ Cистемный вызов `write`
; После вызова инструкции 'int 80h' на экран будет
; выведено сообщение из переменной 'buf1' длиной 80
mov eax,4 ; Системный вызов для записи (sys_write)
mov ebx,1 ; Описатель файла 1 - стандартный вывод
mov ecx,buf1 ; Адрес строки 'buf1' в 'ecx'
mov edx,80 ; Размер строки 'buf1' в 'edx'
int 80h ; Вызов ядра

;------------ Системный вызов `exit` ----------------------
; После вызова инструкции 'int 80h' программа завершит работу
mov eax,1 ; Системный вызов для выхода (sys_exit)
mov ebx,0 ; Выход с кодом возврата 0 (без ошибок)
int 80h ; Вызов ядра
```

Cоздали копию lab6-2-new.asm файла lab6-2.asm, в котором, воспользовавшись подпрограммами из файла in\_out.asm, также написали блок вывода строки, полученной вводом строки с клавиатуры (Листинг [-@lst:lst05]). Результат работы программы на Рисунке [-@fig:fig14].

![Результат выполения программы lab6-2-new.](/home/dastarikov/work/study/2022-2023/Архитектура компьютера/arch-pc/labs/lab06/report/image/image14.png){#fig:fig14}

```{#lst:lst05 .nasm caption="Текст программы lab6-2-new.asm"}
%include 'in_out.asm'

SECTION  .data ; Секция инициированных данных
msg: DB 'Введите строку:',10 ; сообщение плюс
; символ перевода строки

SECTION .bss ; Секция не инициированных данных
buf1: RESB 80 ; Буфер размером 80 байт

;------------------- Текст программы -----------------
SECTION .text ; Код программы
    GLOBAL _start ; Начало программы
    _start: ; Точка входа в программы
    mov eax, msg ; запись адреса выводимого сообщения в `EAX`
	    call sprint ; вызов подпрограммы печати сообщения
    
    mov ecx, buf1 ; запись адреса переменной в `EAX`
    mov edx, 80 ; запись длины вводимого сообщения в `EBX`
    call sread ; вызов подпрограммы ввода сообщения
    ати сообщения
    
    mov eax, buf1 ; запись адреса выводимого сообщения в 'EAX'
    call sprint ; вызов подпрограммы печ
    call quit ; вызов подпрограммы завершения
```

Созданные файлы *.asm скопировали в каталог ~/work/study/2022-2023/"Архитектура компьютера"/archpc/labs/lab06/ и загрузили на Github. 

# Выводы

В рамках лабораторной работы получили практические навыки работы в Midnight Commander, освоили иструкции языка ассемблера и использование внешних файлов. 
