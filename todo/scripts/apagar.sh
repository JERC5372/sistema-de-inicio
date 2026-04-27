#!/bin/bash

/usr/bin/notify-send \
  -u critical \
  -t 10000 \
  "Hora de dormir" \
  "El PC se apagará en 5 minutos"

sleep 300

/usr/bin/systemctl poweroff -i
