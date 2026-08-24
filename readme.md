Estructura de los dotfiles:

sistema-de-incio
.
├── .directory
├── .gitignore
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

> investiga los oh-my-zsh de los plugins
