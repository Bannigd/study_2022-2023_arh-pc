---
## Front matter
title: Отчет по лабораторной работа №3
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

Целью работы является изучить идеологию и применение средств контроля версий. Приобрести практические навыки по работе с системой git.


# Основная часть

## Выполнение лабораторной работы

### Настройка github

Сделали предварительную конфигурацию git: указали имя и email владельца
репозитория и определили параметры (Рисунок [-@fig:fig1]).

![Конфигурация git.](/home/dastarikov/work/study/2022-2023/Архитектура компьютера/arch-pc/labs/lab03/report/image/image001.png){ #fig:fig1 width="6.496527777777778in" height="2.1603772965879267in"}

### Создание SSH ключа.

Сгенерировали shh ключ для идентификации при работе с сервером
репозитория с помощью команды ssh-keygen "Данила Стариков
1132226531@pfur.ru" (Рисунок [-@fig:fig2]).


![Генеривание ssh ключа.](/home/dastarikov/work/study/2022-2023/Архитектура компьютера/arch-pc/labs/lab03/report/image/image002.png){#fig:fig2}

Далее сгенерированный открытый ключ необходимо загрузить на сайт <https://github.com/> в настройках учетной записи. Для этого копируем содержимое файла с ключом в буфер обмена с помощью утилиты xclip ((Рисунок [-@fig:fig3]), и затем добавляем в параметр SSH keys внастройках (Рисунок [-@fig:fig4]).

![Установка утилиты xclip и копирование ssh ключа в буфер обмена.](/home/dastarikov/work/study/2022-2023/Архитектура компьютера/arch-pc/labs/lab03/report/image/image003.png){#fig:fig3}

![Привязка сгенерированного ssh ключа к учетной записи на github.](/home/dastarikov/work/study/2022-2023/Архитектура компьютера/arch-pc/labs/lab03/report/image/image004.png){#fig:fig4}

### Сознание рабочего пространства и репозитория курса на основе шаблона.

Оформляем рабочее пространство для выполнения лабораторных работ, для этого создаем отдельный каталог для предмета «Архитектура компьютера», где будут храниться все выполненные лабораторные работы (Рисунок [-@fig:fig5]).

![Создание каталога для предмета «Архитектура компьютеров».](/home/dastarikov/work/study/2022-2023/Архитектура компьютера/arch-pc/labs/lab03/report/image/image005.png){#fig:fig5}

### Сознание репозитория курса на основе шаблона.

Создадим репозиторий на основе шаблона, расположенного по адресу а <https://github.com/yamadharma/course-directory-student-template>. Для этого нажимаем кнопку «Use this template» (Рисунок [-@fig:fig6]), и в появившемся поле указываем имя репозитория (Рисунок [-@fig:fig7]).

![Репозиторий, использованный в качестве шаблона.](/home/dastarikov/work/study/2022-2023/Архитектура компьютера/arch-pc/labs/lab03/report/image/image006.png){#fig:fig6}

![Создание репозитория по шаблону.](/home/dastarikov/work/study/2022-2023/Архитектура компьютера/arch-pc/labs/lab03/report/image/image007.png){#fig:fig7}

Теперь необходимо клонировать созданный репозиторий в соответствующую папку, сначала добавим ssh ключ, чтобы возможность работать с репозиторием (Рисунок [-@fig:fig8]), затем клонируем наш репозиторий в папку предмета с помощью команды git clone --recursive git@github.com:Bannigd/study_2022-2023_arc_pc arch-pc (Рисунок [-@fig:fig9]).

![Добавление ssh ключа.](/home/dastarikov/work/study/2022-2023/Архитектура компьютера/arch-pc/labs/lab03/report/image/image008.png){#fig:fig8}

![Клонирование репозитория из github в каталог предмета.](/home/dastarikov/work/study/2022-2023/Архитектура компьютера/arch-pc/labs/lab03/report/image/image009.png){#fig:fig9}

### Настройка каталога курса.

Удаляем лишние файлы (Рисунок [-@fig:fig10]).

![Удаление файла package.json](/home/dastarikov/work/study/2022-2023/Архитектура компьютера/arch-pc/labs/lab03/report/image/image010.png){#fig:fig10}

Создаем необходимый каталог (Рисунок [-@fig:fig11]).

![Создание файла COURSE](/home/dastarikov/work/study/2022-2023/Архитектура компьютера/arch-pc/labs/lab03/report/image/image011.png){#fig:fig11}

Отправляем файлы на сервер (Рисунок [-@fig:fig12]).

![Отправка изменений на сервер.](/home/dastarikov/work/study/2022-2023/Архитектура компьютера/arch-pc/labs/lab03/report/image/image012.png){#fig:fig12}

## Выполнение заданий для самостоятельной работы.

Добавили отчеты по этой и предыдущим лабораторным работам в
соответствующие каталоги и загрузили файлы на github (Рисунок [-@fig:fig13]).

![Добавление отчетов в репозиторий github.](/home/dastarikov/work/study/2022-2023/Архитектура компьютера/arch-pc/labs/lab03/report/image/image013.png){#fig:fig13}

# Выводы

При выполнении лабораторной работы изучили идеологию и применение
средств контроля версий. Приобрести практические навыки по работе с
системой git.
