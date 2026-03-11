#!/bin/bash

# asegurar PATH completo
export PATH=/usr/local/bin:/usr/bin:/bin

# cerrar todas las ventanas excepto cohetion
COH_WINDOWS=$(wmctrl -lx | grep -i cohetion | awk '{print $1}')

wmctrl -lx | while read -r wid desktop host class title; do
    if ! echo "$COH_WINDOWS" | grep -q "$wid"; then
        wmctrl -ic "$wid"
    fi
done

# pequeño respiro para el WM
sleep 1

# abrir cohetion (forma segura)
cohetion >/dev/null 2>&1 &