Estructura de los dotfiles:

sistema-de-incio
├── readme.md
├── setup.sh
└── todo
    ├── .config
    │   ├── fastfetch
    │   │   └── config.jsonc
    │   ├── kitty
    │   │   ├── color.ini
    │   │   └── kitty.conf
    │   ├── micro
    │   │   ├── backups
    │   │   ├── bindings.json
    │   │   ├── buffers
    │   │   │   └── history
    │   │   ├── colorschemes
    │   │   │   └── cold-mono-red.micro
    │   │   └── settings.json
    │   ├── spicetify
    │   │   ├── .gitignore
    │   │   ├── config-xpui.ini
    │   │   ├── CustomApps
    │   │   │   └── marketplace
    │   │   │       ├── extension.js
    │   │   │       ├── index.js
    │   │   │       ├── manifest.json
    │   │   │       ├── README.md
    │   │   │       └── style.css
    │   │   ├── Extensions
    │   │   └── Themes
    │   │       └── marketplace
    │   │           └── color.ini
    │   └── systemd
    │       └── user
    │           ├── apagar.service
    │           ├── apagar.timer
    │           ├── ejercicio.service
    │           ├── ejercicio.timer
    │           └── timers.target.wants
    │               ├── apagar.timer -> /home/justin/.config/systemd/user/apagar.timer
    │               └── ejercicio.timer -> /home/justin/.config/systemd/user/ejercicio.timer
    ├── Imágenes
    │   ├── 2b wallpaper.jpg
    │   ├── 2B.jpg
    │   └── GARDEVOIR IMAGE.png
    ├── .p10k.zsh
    ├── scripts
    │   ├── apagar.sh
    │   └── ejercicio.sh
    └── .zshrc

> Pon tus cosas en github-cli
