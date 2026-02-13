#!/bin/bash

# asegurar PATH completo
export PATH=/usr/local/bin:/usr/bin:/bin

# cerrar todas las ventanas excepto lotion
LOTION_WINDOWS=$(wmctrl -lx | grep -i lotion | awk '{print $1}')

wmctrl -lx | while read -r wid desktop host class title; do
    if ! echo "$LOTION_WINDOWS" | grep -q "$wid"; then
        wmctrl -ic "$wid"
    fi
done

# pequeño respiro para el WM
sleep 1

# abrir lotion (forma segura)
nohup lotion >/dev/null 2>&1 &
