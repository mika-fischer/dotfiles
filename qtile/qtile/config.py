#!/usr/bin/env python2
# -*- coding: utf-8 -*-

from libqtile.manager import Click, Drag, Key, Screen, Group
from libqtile.command import lazy
from libqtile import layout, bar, widget, hook

mod = "mod4"
terminal = "urxvt"

keys = [
    # QTile commands
    Key([mod, "control"], "r",
        lazy.restart()),
    Key([mod, "control"], "q",
        lazy.shutdown()),

    # Screen navigation
    Key([mod], "h",
        lazy.to_screen(1)),
    Key([mod], "l",
        lazy.to_screen(0)),

    # Window management
    Key([mod], "w",
        lazy.window.kill()),
    Key([mod], "f",
        lazy.window.toggle_floating()),

    # Layout management
    Key([mod], "Tab",
        lazy.nextlayout()),
    Key([mod], "k",
        lazy.layout.up()),
    Key([mod], "j",
        lazy.layout.down()),
    Key([mod, "shift"], "k",
        lazy.layout.shuffle_up()),
    Key([mod, "shift"], "j",
        lazy.layout.shuffle_down()),
    Key([mod], "i",
        lazy.layout.grow()),
    Key([mod], "m",
        lazy.layout.shrink()),
    Key([mod], "n",
        lazy.layout.normalize()),
    Key([mod], "o",
        lazy.layout.maximize()),
    Key([mod, "shift"], "space",
        lazy.layout.flip()),

    Key([mod], "space",
        lazy.layout.next()),
    #Key([mod, "shift"], "space",
        #lazy.layout.rotate()),
    Key([mod, "shift"], "Return",
        lazy.layout.toggle_split()),

    # Lauchers
    Key([mod], "Return",
        lazy.spawn(terminal)),
    Key([mod], 'r',
        lazy.spawncmd(prompt='% ')),

]

mouse = [
    Drag([mod], "Button1",
        lazy.window.set_position_floating(),
        start=lazy.window.get_position()),
    Drag([mod], "Button3",
        lazy.window.set_size_floating(),
        start=lazy.window.get_size()),
    Click([mod], "Button2",
        lazy.window.bring_to_front())
]

groups = [ Group(str(i)) for i in range(1, 10) ]
for group in groups:
    keys.append(Key([mod],          group.name, lazy.group[group.name].toscreen()))
    keys.append(Key([mod, "shift"], group.name, lazy.window.togroup(group.name)))

layouts = [
    layout.MonadTall(),
    layout.Max(),
]

sepcolor = "#B0B0B0"
bgcolor = "#D0D0D0"
fgcolor = "#000000"

widget_options = dict(
        font="Sans",
        fontsize=12,
        background=bgcolor,
        foreground=fgcolor)
sep_options = dict(
        background=bgcolor,
        foreground=sepcolor)
graph_options = dict(
        width=50,
        border_width=1,
        border_color=bgcolor,
        margin_x=0,
        margin_y=0,
        line_width=1)

screens = [
    Screen(
        bottom = bar.Bar(
                    [
                        widget.GroupBox(
                            active="#000000",
                            inactive="#808080",
                            this_screen_border="#D09050",
                            borderwidth=2,
                            padding=3,
                            margin_x=0,
                            margin_y=0,
                            **widget_options),
                        widget.Sep(**sep_options),
                        widget.CurrentLayout(**widget_options),
                        widget.Sep(**sep_options),
                        widget.Prompt(**widget_options),
                        widget.WindowName(**widget_options),
                        widget.Sep(**sep_options),
                        widget.Systray(**widget_options),
                        widget.Volume(
                            theme_path="/usr/share/icons/gnome/24x24/status",
                            **widget_options),
                        widget.CPUGraph(
                            graph_color="30F030",
                            fill_color="30F030",
                            **graph_options),
                        widget.MemoryGraph(
                            graph_color="F030F0",
                            fill_color="F030F0",
                            **graph_options),
                        widget.NetGraph(
                            graph_color="F0F030",
                            fill_color="F0F030",
                            **graph_options),
                        widget.YahooWeather(
                            woeid=664942,
                            format="{condition_temp} °{units_temperature}",
                            **widget_options),
                        widget.Sep(**sep_options),
                        widget.Clock(
                            "%a %b %d %H:%M",
                            **widget_options),
                    ],
                    20,
                    background=bgcolor,
                ),
    ),
]

@hook.subscribe.client_new
def floating_dialogs(window):
    dialog    = window.window.get_wm_type() == 'dialog'
    transient = window.window.get_wm_transient_for()
    if dialog or transient:
        window.floating = True

