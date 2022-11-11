---
## Front matter
title: Отчет по лабораторной работа №5
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

Освоение процедуры компиляции и сборки программ, написанных на ассемблере NASM.

# Основная часть

## Выполнение лабораторной работы

Для изучения работы с программами на языке ассемблера NASM в качестве примера взяли программу, выводящую сообщение "Hello, world!" на экран. 
В каталоге курса создали подкаталог для работы с программами, в нем -- файл hello.asm, содержащий текст программы (Рис. [-@fig:fig01], [-@fig:fig011]).

![Создание файла hello.asm.](/home/dastarikov/work/study/2022-2023/Архитектура компьютера/arch-pc/labs/lab05/report/image/image01.png){#fig:fig01}

![Текст программы hello.asm.](/home/dastarikov/work/study/2022-2023/Архитектура компьютера/arch-pc/labs/lab05/report/image/image011.png){#fig:fig011}

После создания файла с кодом программы транслируем его в объектный файл hello.o (Рисунок [-@fig:fig02]). Команду nasm можно запустить с дополнительными параметрами: исходный файл hello.asm скомпилируется в obj.o (опция -o позволяет задать имя объектного файла, в данном случае obj.o), при этом формат выходного файла будет elf, и в него будут включены символы для отладки (опция -g), кроме того, будет создан файл листинга list.lst (опция -l) (Рисунок [-@fig:fig03]).

![Трансляция файла hello.asm.](/home/dastarikov/work/study/2022-2023/Архитектура компьютера/arch-pc/labs/lab05/report/image/image02.png){#fig:fig02}

![Трансляция файла hello.asm. с дополнительными параметрами.](/home/dastarikov/work/study/2022-2023/Архитектура компьютера/arch-pc/labs/lab05/report/image/image03.png){#fig:fig03}

На последнем этапе объектный файл компонуем с помощью компоновщика ld (Рисунок [-@fig:fig04]). Ключ -o дает возможность переимновать получаемый исполняемый файл (Рисунок [-@fig:fig05]).

![Компоновка объектного файла hello.o.](/home/dastarikov/work/study/2022-2023/Архитектура компьютера/arch-pc/labs/lab05/report/image/image04.png){#fig:fig04}

![Компоновка объектного файла obj.o и его переимнование в main](/home/dastarikov/work/study/2022-2023/Архитектура компьютера/arch-pc/labs/lab05/report/image/image05.png){#fig:fig05}

В результате компоновки получили исполняемый файл hello без расширения, при запуске получаем сообщение "Hello, world!" (Рисунок [-@fig:fig051]).

![Демонстрация работы программы lab05.](/home/dastarikov/work/study/2022-2023/Архитектура компьютера/arch-pc/labs/lab05/report/image/image051.png){#fig:fig051}

## Выполнение заданий для самостоятельной работы.

В том же каталоге создали копию файла hello.asm с именем lab05.asm и изменили текст программы, чтобы выводилось сообщение "Стариков Данила" (Рис. [-@fig:fig06], [-@fig:fig07]). 

![Создание исполняемой программы lab05 и деионстрация ее работы.](/home/dastarikov/work/study/2022-2023/Архитектура компьютера/arch-pc/labs/lab05/report/image/image06.png){#fig:fig06}

![Код программы lab05.asm.](/home/dastarikov/work/study/2022-2023/Архитектура компьютера/arch-pc/labs/lab05/report/image/image07.png){#fig:fig07}

Созданные файлы hello.asm и lab05.asm скопировали в каталог ~/work/study/2022-2023/"Архитектура компьютера"/archpc/labs/lab05/ и загрузили на Github.

# Выводы

В рамках лабораторной работы на примере программы, печатающей "Hello, world!" в консоль, освоили процедуры компиляции и сборки программ, написанных на ассемблере NASM на примере программы.
