-- =========================================================
--  CARGA DE LUAROCKS
-- =========================================================
-- Si LuaRocks está instalado, esto permite que Awesome
-- encuentre librerías instaladas por ese medio (por ejemplo lgi).
-- Si LuaRocks NO está instalado, pcall evita que Awesome falle.
pcall(require, "luarocks.loader")

-- =========================================================
--  LIBRERÍAS PRINCIPALES DE AWESOME
-- =========================================================

-- Librería estándar con utilidades (tablas, temporizadores, wallpaper, etc.)
local gears = require("gears")

-- Librería central para manejo de ventanas, teclas, layouts, reglas
local awful = require("awful")

-- Enfoca automáticamente una ventana cuando otra se cierra
require("awful.autofocus")

-- Librería para widgets y barras (wibox)
local wibox = require("wibox")

-- Manejo de temas: colores, fuentes, bordes, iconos, wallpapers
local beautiful = require("beautiful")

-- Sistema de notificaciones de Awesome
local naughty = require("naughty")

-- Menú clásico de aplicaciones (poco usado hoy en día)
local menubar = require("menubar")

-- Popup de ayuda para atajos de teclado
local hotkeys_popup = require("awful.hotkeys_popup")

-- Habilita el popup de atajos para aplicaciones tipo VIM
-- (se activa cuando una app con nombre compatible está enfocada)
require("awful.hotkeys_popup.keys")

-- =========================================================
--  MANEJO DE ERRORES
-- =========================================================

-- ---------------------------------------------------------
--  Errores durante el arranque de Awesome
-- ---------------------------------------------------------
-- Esto se ejecuta si Awesome intenta iniciar y falla,
-- por ejemplo por un error de sintaxis en rc.lua
if awesome.startup_errors then
    naughty.notify({
        preset = naughty.config.presets.critical,
        title = "Oops, hubo errores durante el inicio",
        text = awesome.startup_errors
    })
end

-- ---------------------------------------------------------
--  Errores en tiempo de ejecución (después de iniciar)
-- ---------------------------------------------------------
do
    -- Evita bucles infinitos de errores
    local in_error = false

    -- Señal que se dispara cuando ocurre un error en runtime
    awesome.connect_signal("debug::error", function (err)
        if in_error then return end
        in_error = true

        naughty.notify({
            preset = naughty.config.presets.critical,
            title = "Oops, ocurrió un error",
            text = tostring(err)
        })

        in_error = false
    end)
end
-- =========================================================
--  DEFINICIÓN DE VARIABLES BÁSICAS
-- =========================================================

-- ---------------------------------------------------------
--  TEMA
-- ---------------------------------------------------------
-- Aquí se carga el tema visual de Awesome.
-- El tema define colores, fuentes, iconos, bordes y wallpaper.
-- Por ahora se usa el tema por defecto de Awesome.
-- Más adelante puedes cambiar esta línea por tu theme personalizado.
-----linea original
---beautiful.init(gears.filesystem.get_themes_dir() .. "zenburn/theme.lua")
----
beautiful.init(gears.filesystem.get_configuration_dir() .. "theme/theme.lua")

---wallpaper
beautiful.wallpaper= "/home/justin/.config/awesome/theme/wallpapers/2b wallpaper.jpg"
gears.wallpaper.maximized(beautiful.wallpaper , s,true)
-- ---------------------------------------------------------
--  TERMINAL Y EDITOR
-- ---------------------------------------------------------

-- Terminal por defecto que usará Awesome
-- Se usa para atajos, menús y comandos internos
terminal = "kitty"

-- Editor de texto por defecto
-- Primero intenta usar la variable de entorno EDITOR
-- Si no existe, usa "nano" como respaldo
editor = os.getenv("EDITOR") or "micro"

-- Comando completo para abrir el editor dentro del terminal
editor_cmd = terminal .. " -e micro " .. editor

-- ---------------------------------------------------------
--  TECLA MODIFICADORA
-- ---------------------------------------------------------
-- Mod4 suele ser la tecla Super / Windows
-- Es la base de casi todos los atajos de Awesome
modkey = "Mod4"

-- ---------------------------------------------------------
--  LAYOUTS DISPONIBLES
-- ---------------------------------------------------------
-- Esta tabla define los layouts que podrás usar.
-- El orden es importante: se recorre con Mod + Space.
-- Tener pocos layouts hace el flujo más predecible.
awful.layout.layouts = {

    awful.layout.suit.tile,        -- Layout en mosaico (tiling clásico)
    awful.layout.suit.max,         -- Una ventana ocupa toda la pantalla
    awful.layout.suit.floating,    -- Ventanas flotantes

    -- Los siguientes layouts vienen por defecto en Awesome,
    -- pero están comentados porque no los necesitas ahora.
    -- Puedes activarlos quitando el "--".

    -- awful.layout.suit.tile.left,
    -- awful.layout.suit.tile.bottom,
    -- awful.layout.suit.tile.top,
    -- awful.layout.suit.fair,
    -- awful.layout.suit.fair.horizontal,
    -- awful.layout.suit.spiral,
    -- awful.layout.suit.spiral.dwindle,
    -- awful.layout.suit.max.fullscreen,
    -- awful.layout.suit.magnifier,
    -- awful.layout.suit.corner.nw,
    -- awful.layout.suit.corner.ne,
    -- awful.layout.suit.corner.sw,
    -- awful.layout.suit.corner.se,
}
-- =========================================================
--  MENÚ CLÁSICO DE AWESOME
-- =========================================================
-- Este es el menú interno de Awesome.
-- Hoy en día suele usarse poco porque la mayoría lanza apps con rofi,
-- pero se mantiene por compatibilidad y como referencia.
myawesomemenu = {
   { "atajos", function() hotkeys_popup.show_help(nil, awful.screen.focused()) end },
   { "manual", terminal .. " -e man awesome" },
   { "editar configuración", editor_cmd .. " " .. awesome.conffile },
   { "reiniciar awesome", awesome.restart },
   { "salir", function() awesome.quit() end },
}

-- Menú principal que agrupa el menú de Awesome y el terminal
mymainmenu = awful.menu({
    items = {
        { "awesome", myawesomemenu, beautiful.awesome_icon },
        { "abrir terminal", terminal }
    }
})

-- Launcher gráfico (icono de Awesome)
-- Al hacer clic abre el menú principal
-- En setups minimal suele comentarse más adelante
mylauncher = awful.widget.launcher({
    image = beautiful.awesome_icon,
    menu = mymainmenu
})

-- ---------------------------------------------------------
--  MENUBAR
-- ---------------------------------------------------------
-- Menubar es un lanzador clásico tipo aplicaciones
-- Muchas personas no lo usan si ya tienen rofi
menubar.utils.terminal = terminal

-- =========================================================
--  WIDGETS BÁSICOS
-- =========================================================

-- Indicador de distribución de teclado
-- Útil si cambias entre layouts (ej: us / es)
mykeyboardlayout = awful.widget.keyboardlayout()

-- Reloj simple
mytextclock = wibox.widget.textclock()

-- =========================================================
--  BOTONES DE TAGLIST (ESCRITORIOS)
-- =========================================================
-- Define qué pasa cuando haces clic o scroll sobre los tags
local taglist_buttons = gears.table.join(

    -- Click izquierdo: cambiar al tag
    awful.button({}, 1, function(t)
        t:view_only()
    end),

    -- Mod + click izquierdo: mover ventana al tag
    awful.button({ modkey }, 1, function(t)
        if client.focus then
            client.focus:move_to_tag(t)
        end
    end),

    -- Click derecho: mostrar / ocultar el tag
    awful.button({}, 3, awful.tag.viewtoggle),

    -- Mod + click derecho: alternar ventana en el tag
    awful.button({ modkey }, 3, function(t)
        if client.focus then
            client.focus:toggle_tag(t)
        end
    end),

    -- Scroll: cambiar de tag
    awful.button({}, 4, function(t)
        awful.tag.viewnext(t.screen)
    end),
    awful.button({}, 5, function(t)
        awful.tag.viewprev(t.screen)
    end)
)

-- =========================================================
--  BOTONES DE TASKLIST (VENTANAS)
-- =========================================================
-- Define el comportamiento de la lista de ventanas
local tasklist_buttons = gears.table.join(

    -- Click izquierdo:
    -- si la ventana está enfocada, se minimiza
    -- si no, se enfoca y se eleva
    awful.button({}, 1, function(c)
        if c == client.focus then
            c.minimized = true
        else
            c:emit_signal(
                "request::activate",
                "tasklist",
                { raise = true }
            )
        end
    end),

    -- Click derecho: muestra un menú con ventanas abiertas
    awful.button({}, 3, function()
        awful.menu.client_list({ theme = { width = 250 } })
    end),

    -- Scroll: cambiar foco entre ventanas
    awful.button({}, 4, function()
        awful.client.focus.byidx(1)
    end),
    awful.button({}, 5, function()
        awful.client.focus.byidx(-1)
    end)
)

-- =========================================================
--  WALLPAPER
-- =========================================================
-- Función para establecer el fondo de pantalla
local function set_wallpaper(s)
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper

        -- Si el wallpaper es una función, se ejecuta
        if type(wallpaper) == "function" then
            wallpaper = wallpaper(s)
        end

        -- Ajusta el wallpaper a la pantalla
        gears.wallpaper.maximized(wallpaper, s, true)
    end
end

-- Reaplica el wallpaper cuando cambia la resolución
screen.connect_signal("property::geometry", set_wallpaper)

-- =========================================================
--  CONFIGURACIÓN POR PANTALLA
-- =========================================================
awful.screen.connect_for_each_screen(function(s)

    -- Aplica wallpaper
    set_wallpaper(s)

    -- Crea los tags (escritorios) del 1 al 9 para cada pantalla
    awful.tag(
        { "1", "2", "3", "4", "5", "6", "7", "8", "9" },
        s,
        awful.layout.layouts[1]
    )

    -- Promptbox (usado por Mod + r)
    s.mypromptbox = awful.widget.prompt()

    -- Layoutbox: muestra el layout actual
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(gears.table.join(
        awful.button({}, 1, function () awful.layout.inc(1) end),
        awful.button({}, 4, function () awful.layout.inc(1) end),
        awful.button({}, 5, function () awful.layout.inc(-1) end)
    ))

    -- Taglist: muestra los tags disponibles
    s.mytaglist = awful.widget.taglist {
        screen  = s,
        filter  = awful.widget.taglist.filter.all,
        buttons = taglist_buttons
    }

    -- Tasklist: muestra ventanas abiertas en los tags activos
    s.mytasklist = awful.widget.tasklist {
        screen  = s,
        filter  = awful.widget.tasklist.filter.currenttags,
        buttons = tasklist_buttons
    }

    -- Wibar (barra superior)
    s.mywibox = awful.wibar({
        position = "top",
        screen   = s
    })

    -- Organización de widgets dentro de la barra
    s.mywibox:setup {
        layout = wibox.layout.align.horizontal,

        -- Lado izquierdo
        {
            layout = wibox.layout.fixed.horizontal,
            mylauncher,      -- launcher clásico (opcional)
            s.mytaglist,
            s.mypromptbox,
        },

        -- Centro
        s.mytasklist,

        -- Lado derecho
        {
            layout = wibox.layout.fixed.horizontal,
            mykeyboardlayout,
            wibox.widget.systray(),
            mytextclock,
            s.mylayoutbox,
        },
    }
end)
-- =========================================================
--  BINDEOS DE RATÓN (ROOT)
-- =========================================================
-- Define acciones globales del ratón cuando haces clic
-- en el fondo del escritorio (no sobre ventanas).

root.buttons(gears.table.join(

    -- Click derecho en el escritorio:
    -- abre o cierra el menú principal de Awesome
    awful.button({}, 3, function ()
        mymainmenu:toggle()
    end),

    -- Scroll del ratón:
    -- cambia entre tags (escritorios)
    awful.button({}, 4, awful.tag.viewnext),
    awful.button({}, 5, awful.tag.viewprev)
))
-- =========================================================
--  ATAJOS DE TECLADO (GLOBALKEYS)
-- =========================================================
-- Aquí se definen TODOS los atajos globales de Awesome.
-- Funcionan independientemente de qué ventana esté enfocada.

globalkeys = gears.table.join(

    -- -----------------------------------------------------
    -- Ayuda y navegación básica
    -- -----------------------------------------------------

    -- Mod + s → muestra la ayuda de atajos
    awful.key({ modkey }, "s",
        hotkeys_popup.show_help,
        { description = "mostrar ayuda de atajos", group = "awesome" }
    ),

    -- Cambiar entre tags
    awful.key({ modkey }, "Left", awful.tag.viewprev,
        { description = "tag anterior", group = "tag" }
    ),
    awful.key({ modkey }, "Right", awful.tag.viewnext,
        { description = "tag siguiente", group = "tag" }
    ),

    -- Volver al tag anterior
    awful.key({ modkey }, "Escape", awful.tag.history.restore,
        { description = "volver al tag previo", group = "tag" }
    ),

    -- -----------------------------------------------------
    -- Enfoque de ventanas
    -- -----------------------------------------------------

    -- Mod + j / k → mover foco entre ventanas
    awful.key({ modkey }, "j",
        function () awful.client.focus.byidx(1) end,
        { description = "siguiente ventana", group = "client" }
    ),
    awful.key({ modkey }, "k",
        function () awful.client.focus.byidx(-1) end,
        { description = "ventana anterior", group = "client" }
    ),

    -- Mod + Tab → alternar entre ventanas recientes
    awful.key({ modkey }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end,
        { description = "ventana anterior (historial)", group = "client" }
    ),

    -- -----------------------------------------------------
    -- Lanzadores
    -- -----------------------------------------------------

    -- Mod + Enter → abrir terminal
    awful.key({ modkey }, "Return",
        function () awful.spawn(terminal) end,
        { description = "abrir terminal", group = "launcher" }
    ),

    -- Mod + d → lanzar rofi
    awful.key({ modkey }, "d",
        function () awful.spawn("rofi -show drun") end,
        { description = "abrir rofi", group = "launcher" }
    ),

    -- Mod + r → prompt interno de Awesome
    awful.key({ modkey }, "r",
        function () awful.screen.focused().mypromptbox:run() end,
        { description = "prompt de comandos", group = "launcher" }
    ),

    -- -----------------------------------------------------
    -- Layouts
    -- -----------------------------------------------------

    -- Cambiar layout
    awful.key({ modkey }, "space",
        function () awful.layout.inc(1) end,
        { description = "siguiente layout", group = "layout" }
    ),
    awful.key({ modkey, "Shift" }, "space",
        function () awful.layout.inc(-1) end,
        { description = "layout anterior", group = "layout" }
    ),

    -- Ajustar tamaño del área master
    awful.key({ modkey }, "h",
        function () awful.tag.incmwfact(-0.05) end,
        { description = "reducir área master", group = "layout" }
    ),
    awful.key({ modkey }, "l",
        function () awful.tag.incmwfact(0.05) end,
        { description = "aumentar área master", group = "layout" }
    ),

    -- -----------------------------------------------------
    -- Control de Awesome
    -- -----------------------------------------------------

    -- Reiniciar Awesome
    awful.key({ modkey, "Control" }, "r",
        awesome.restart,
        { description = "reiniciar awesome", group = "awesome" }
    ),

    -- Salir de Awesome
    awful.key({ modkey, "Shift" }, "q",
        awesome.quit,
        { description = "salir de awesome", group = "awesome" }
    )
)
-- =========================================================
--  ATAJOS POR CLIENTE (VENTANA ACTIVA)
-- =========================================================
-- Estos atajos SOLO afectan a la ventana enfocada.

clientkeys = gears.table.join(

    -- Pantalla completa
    awful.key({ modkey }, "f",
        function (c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end,
        { description = "pantalla completa", group = "client" }
    ),

    -- Cerrar ventana
    awful.key({ modkey, "Shift" }, "c",
        function (c) c:kill() end,
        { description = "cerrar ventana", group = "client" }
    ),

    -- Flotante / tiling
    awful.key({ modkey, "Control" }, "space",
        awful.client.floating.toggle,
        { description = "alternar flotante", group = "client" }
    ),

    -- Maximizar
    awful.key({ modkey }, "m",
        function (c)
            c.maximized = not c.maximized
            c:raise()
        end,
        { description = "maximizar", group = "client" }
    ),

    -- Minimizar
    awful.key({ modkey }, "n",
        function (c) c.minimized = true end,
        { description = "minimizar", group = "client" }
    )
)
-- =========================================================
--  TAGS NUMÉRICOS (Mod + 1..9)
-- =========================================================
-- Permite cambiar de escritorio usando Mod + número
-- Se usan keycodes para que funcione con cualquier layout de teclado

for i = 1, 9 do
    globalkeys = gears.table.join(globalkeys,

        -- Mod + número → ir al tag
        awful.key({ modkey }, "#" .. i + 9, function ()
            local screen = awful.screen.focused()
            local tag = screen.tags[i]
            if tag then
                tag:view_only()
            end
        end,
        { description = "ir al tag #" .. i, group = "tag" })

    )
end

-- =========================================================
--  ASIGNAR TECLAS
-- =========================================================
root.keys(globalkeys)
-- =========================================================
--  REGLAS DE VENTANAS
-- =========================================================
-- Aquí se define cómo se comportan las ventanas al abrirse.

awful.rules.rules = {

    -- Regla general para todas las ventanas
    {
        rule = {},
        properties = {
            border_width = beautiful.border_width,
            border_color = beautiful.border_normal,
            focus        = awful.client.focus.filter,
            raise        = true,
            keys         = clientkeys,
            screen       = awful.screen.preferred,
            placement    = awful.placement.no_overlap
                           + awful.placement.no_offscreen
        }
    },

    -- Ventanas que deben ser flotantes
    {
        rule_any = {
            class = {
                "Arandr",
                "Blueman-manager",
                "Gpick",
                "Sxiv",
            }
        },
        properties = { floating = true }
    },

    -- Activar titlebars en ventanas normales y diálogos
    {
        rule_any = { type = { "normal", "dialog" } },
        properties = { titlebars_enabled = true }
    },
}
-- =========================================================
--  SEÑALES (EVENTOS)
-- =========================================================

-- Al abrir una nueva ventana
client.connect_signal("manage", function (c)

    -- Evita que ventanas queden fuera de la pantalla
    if awesome.startup
        and not c.size_hints.user_position
        and not c.size_hints.program_position
    then
        awful.placement.no_offscreen(c)
    end
end)

-- Enfoque al pasar el mouse (sloppy focus)
client.connect_signal("mouse::enter", function (c)
    c:emit_signal("request::activate", "mouse_enter", { raise = false })
end)

-- Cambiar color del borde al enfocar
client.connect_signal("focus", function (c)
    c.border_color = beautiful.border_focus
end)

client.connect_signal("unfocus", function (c)
    c.border_color = beautiful.border_normal
end)

