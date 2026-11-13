# ayder

Персональный установщик AyOS на Calamares 3.4.3: тёмная тема, только KDE
(Plasma), минимум анимаций. Конфиг вырезан из [ayosiso](https://github.com/AyOS-Linux/ayosiso)
и живёт отдельным репозиторием.

## Что внутри

```
calamares/
├── settings.conf               # последовательность шагов (Editions убраны)
├── ayder-netinstall.yaml       # опциональный софт (страница Packages)
├── modules/
│   ├── ayospacstrap/           # установка pacstrap'ом (базис + набор KDE)
│   ├── shellprocess_ayos_osrelease.conf   # /etc/os-release (everyday)
│   ├── shellprocess_ayos_edition.conf     # пакеты KDE + ядро в chroot
│   └── …                       # partition, users, mount, bootloader, …
└── branding/ayder/
    ├── branding.desc           # строки, картинки, цвета сайдбара
    ├── stylesheet.qss          # ВСЯ тёмная тема (Calamares подхватывает сам)
    ├── show.qml                # слайдшоу: fade-in 400 мс на exec-фазе
    └── *.png / *.svg           # логотипы, слайд, стрелки и галочка для QSS
```

## Отличия от ayosiso

- **Только KDE.** `packagechooser` и `contextualprocess` удалены: редакция
  зашита как `everyday` в `settings.conf`, `shellprocess_ayos_osrelease.conf`
  и `ayospacstrap.conf`. Страница Packages (netinstall) осталась — это
  опциональный софт, а не выбор редакции.
- **Тёмная тема.** Целиком в `branding/ayder/stylesheet.qss` (Calamares
  читает его из каталога брендинга и вешает на окно). Цвета сайдбара —
  в `branding.desc`, секция `style:`; акцент `#e88b2a`.
- **Минимум анимаций.** Единственная — fade-in слайда на странице установки
  (`show.qml`, 400 мс, по `activatedInCalamares`).

## Установка конфига

```sh
sudo cp -r calamares/* /etc/calamares/
```

Путь `/etc/calamares/` фиксированный: `groupsUrl` в `netinstall@packages.conf`
и пути к svg в `stylesheet.qss` указывают на него явно.

## Зависимости

- Calamares 3.4.3 (Qt6, собран с `qt6-svg` — нужны для картинок в QSS).
- Скрипты `ayos-edition` и `ayos-osrelease` в `/usr/local/bin/` целевой
  системы — они приходят из ayosiso (`releng/airootfs/usr/local/bin/`);
  без них `shellprocess@ayos_*` завершит установку ошибкой.
