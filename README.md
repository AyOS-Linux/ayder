# ayder

Персональный установщик AyOS на Calamares 3.4.3: тёмная тема, только KDE
(Plasma), минимум шагов. Конфиг вырезан из [ayosiso](https://github.com/AyOS-Linux/ayosiso)
и живёт отдельным репозиторием.

## Шаги установки

**Локаль → Диск → Пользователь → Установка.** Всё. Приветствие, клавиатура
и страница выбора пакетов убраны — на summary сразу Install, дальше ставится
база + KDE.

Первый шаг «Локаль» — это язык/регион **и часовой пояс**: карта TimeZoneWidget
плюс выпадающие Region/Zone. Отдельного модуля `timezone` в Calamares 3.4.3
нет, выбор пояса встроен в шаг `locale`. Стартует с пояса живой системы
(`useSystemTimezone: true` в `modules/locale.conf`), а в фазе exec модуль
`locale` пишет в цель `/etc/localtime` и `/etc/timezone`.

## Структура

```
calamares/
├── settings.conf               # последовательность: locale, partition, users, summary
├── modules/
│   ├── locale.conf             # язык, регион и ЧАСОВОЙ ПОЯС (пояс из live)
│   ├── shellprocess_pacstrap.conf  # установка: обычный pacstrap (базис + KDE)
│   ├── shellprocess_ayos_osrelease.conf   # /etc/os-release (everyday)
│   ├── shellprocess_ayos_edition.conf     # пакеты KDE + ядро в chroot
│   └── …                       # partition, users, mount, bootloader, …
└── branding/ayder/
    ├── branding.desc           # строки, картинки, цвета сайдбара, окно без рамки
    ├── stylesheet.qss          # ВСЯ тёмная тема (Calamares подхватывает сам)
    ├── show.qml                # слайдшоу: плавное появление на установке
    └── *.png / *.svg           # логотипы, слайд, стрелки и галочка для QSS
```

## Отличия от ayosiso

- **Только 4 шага**: локаль, диск, пользователь, установка — без welcome,
  клавиатуры и выбора пакетов (packagechooser, netinstall и packages удалены).
- **Только KDE**: редакция зашита как `everyday` в `settings.conf`,
  `shellprocess_ayos_osrelease.conf` и `shellprocess_pacstrap.conf`.
- **Обычный pacstrap**: установка — штатный модуль `shellprocess`
  (`shellprocess_pacstrap.conf`, `dontChroot: true`), без своего Python-модуля
  `ayospacstrap`. Скрипт делает то же самое: pacman-key → быстрый mirror →
  `pacstrap ${ROOT} …` → sudoers для wheel → хелперы `ayos-*` и ассеты в цель →
  патчи `pacman.conf`/`makepkg.conf`. Цена отказа от своего модуля: у
  `shellprocess` нет прогресса, полоса установки во время pacstrap не двигается.
- **Окно без рамки**: `windowExpanding: fullscreen` в `branding.desc` —
  Calamares 3.4.3 сам включает `Qt::FramelessWindowHint` и разворачивает
  окно (CalamaresApplication::initViewSteps): сверху только установщик,
  без панели приложения и обводки.
- **Тёмная тема**: целиком в `branding/ayder/stylesheet.qss`; цвета сайдбара —
  в `branding.desc`, секция `style:`; акцент `#e88b2a`.
- **Анимация**: плавное появление слайда на странице установки (`show.qml`,
  fade + лёгкий zoom, 650 мс). Переключение страниц в Calamares — обычный
  `QStackedWidget` в C++, из конфига не анимируется.

## Установка конфига

```sh
sudo cp -r calamares/* /etc/calamares/
```

Путь `/etc/calamares/` фиксированный: пути к svg в `stylesheet.qss`
указывают на него явно.

## Зависимости

- Calamares 3.4.3 (Qt6, собран с `qt6-svg` — нужны для картинок в QSS).
- Скрипты `ayos-edition` и `ayos-osrelease` в `/usr/local/bin/` **живого
  корня**: их же `shellprocess@pacstrap` копирует в `/usr/local/bin/` цели,
  а дальше `shellprocess@ayos_*` исполняет уже там. Приходят они из ayosiso
  (`releng/airootfs/usr/local/bin/`); без них `shellprocess@ayos_*`
  завершит установку ошибкой.
- Часовой пояс в цели: `tzdata` приходит зависимостью `base → glibc → tzdata`,
  поэтому `SetTimezoneJob` (модуль `locale`) находит `/usr/share/zoneinfo`.
