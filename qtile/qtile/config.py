#!/usr/bin/env python2
# -*- coding: utf-8 -*-

import os
from libqtile.manager import Click, Drag, Key, Screen, Group
from libqtile.command import lazy
from libqtile import layout, bar, widget, hook

terminal   = "urxvt"
screenlock = "xscreensaver-command -lock"
home       = os.environ['HOME']

# Key bindings
ctrl  = "control"
shift = "shift"
sup   = "mod4"
alt   = "mod1"

keys = [
    # QTile commands
    Key([sup, shift], "r",
        lazy.restart()),
    Key([sup, shift], "q",
        lazy.shutdown()),

    # Session management
    Key([ctrl, alt], "l",
        lazy.spawn(screenlock)),
    Key([ctrl, shift, alt], "l",
        lazy.spawn(screenlock)),
    Key([ctrl, shift, alt], "h",
        lazy.spawn("systemctl poweroff")),
    Key([ctrl, shift, alt], "r",
        lazy.spawn("systemctl reboot")),
    Key([ctrl, shift, alt], "s",
        lazy.spawn(screenlock + " & systemctl suspend")),
    Key([ctrl, shift, alt], "d",
        lazy.spawn(screenlock + " & systemctl hibernate")),
    Key([], "XF86Sleep",
        lazy.spawn(screenlock + " & systemctl suspend")),
    Key([], "XF86Suspend",
        lazy.spawn(screenlock + " & systemctl hibernate")),

    # Screen navigation
    #Key([sup], "h",
        #lazy.to_screen(1)),
    #Key([sup], "l",
        #lazy.to_screen(0)),

    # Window management
    Key([sup, shift], "c",
        lazy.window.kill()),
    Key([sup], "t",
        lazy.window.toggle_floating()),
    Key([sup], "f",
        lazy.window.toggle_fullscreen()),
    #("M-u",                       focusUrgent)
    #("M-S-u",                     clearUrgents)

    # Layout management
    Key([sup], "space",
        lazy.nextlayout()),
    Key([sup], "k",
        lazy.layout.up()),
    Key([sup], "j",
        lazy.layout.down()),
    Key([sup, shift], "k",
        lazy.layout.shuffle_up()),
    Key([sup, shift], "j",
        lazy.layout.shuffle_down()),
    Key([sup], "l",
        lazy.layout.grow()),
    Key([sup], "h",
        lazy.layout.shrink()),
    Key([sup], "n",
        lazy.layout.normalize()),
    Key([sup], "o",
        lazy.layout.maximize()),
    Key([sup, shift], "space",
        lazy.layout.flip()),

    #Key([sup], "space",
        #lazy.layout.next()),
    #Key([sup, shift], "space",
        #lazy.layout.rotate()),
    #Key([sup, shift], "Return",
        #lazy.layout.toggle_split()),

    # Lauchers
    Key([sup, shift], "Return",
        lazy.spawn(terminal)),
    Key([sup], 'p',
        lazy.spawncmd(prompt='% ')),

    # Multimedia
    Key([sup], 'equal',
        lazy.spawn(home + "/bin/volume.sh up")),
    Key([sup], 'minus',
        lazy.spawn(home + "/bin/volume.sh down")),
    Key([sup], '0',
        lazy.spawn(home + "/bin/volume.sh mute")),
    Key([], 'XF86AudioRaiseVolume',
        lazy.spawn(home + "/bin/volume.sh up")),
    Key([], 'XF86AudioLowerVolume',
        lazy.spawn(home + "/bin/volume.sh down")),
    Key([], 'XF86AudioMute',
        lazy.spawn(home + "/bin/volume.sh mute")),
    Key([sup], "F7",
        lazy.spawn(home + "/bin/media.sh prev")),
    Key([sup], "F8",
        lazy.spawn(home + "/bin/media.sh next")),
    Key([sup], "F9",
        lazy.spawn(home + "/bin/media.sh toggle_play")),
    Key([sup], "F10",
        lazy.spawn(home + "/bin/media.sh toggle")),
    Key([sup], "F11",
        lazy.spawn(home + "/bin/media.sh volume_down")),
    Key([sup], "F12",
        lazy.spawn(home + "/bin/media.sh volume_up")),
    Key([], "XF86AudioPrev",
        lazy.spawn(home + "/bin/media.sh prev")),
    Key([], "XF86AudioNext",
        lazy.spawn(home + "/bin/media.sh next")),
    Key([], "XF86AudioPlay",
        lazy.spawn(home + "/bin/media.sh toggle_play")),
    Key([sup], "XF86AudioMute",
        lazy.spawn(home + "/bin/media.sh toggle")),
    Key([sup], "XF86AudioLowerVolume",
        lazy.spawn(home + "/bin/media.sh volume_down")),
    Key([sup], "XF86AudioRaiseVolume",
        lazy.spawn(home + "/bin/media.sh volume_up")),
]

mouse = [
    Drag([sup], "Button1",
        lazy.window.set_position_floating(),
        start=lazy.window.get_position()),
    Drag([sup], "Button3",
        lazy.window.set_size_floating(),
        start=lazy.window.get_size()),
    Click([sup], "Button2",
        lazy.window.bring_to_front())
]

groups = [ Group(str(i)) for i in range(1, 10) ]
for group in groups:
    keys.append(Key([sup],        group.name, lazy.group[group.name].toscreen()))
    keys.append(Key([sup, shift], group.name, lazy.window.togroup(group.name)))

layouts = [
    layout.MonadTall(),
    layout.Max(),
]

floating_layout = layout.Floating(
        border_width            = 0,
        max_border_width        = 0,
        fullscreen_border_width = 0)

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
                            this_current_screen_border="#F0B050",
                            borderwidth=0,
                            padding=3,
                            margin_x=0,
                            margin_y=0,
                            highlight_method="block",
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

float_windows = set([
    "x11-ssh-askpass"
    ])

def should_be_floating(w):
    if w.get_wm_type() == 'dialog':
        return True
    if bool(w.get_wm_transient_for()):
        return True
    wm_class = w.get_wm_class()
    if not isinstance(wm_class, tuple):
        wm_class = (wm_class, )
    for cls in wm_class:
        if cls.lower() in float_windows:
            return True

@hook.subscribe.client_new
def dialogs(window):
    if should_be_floating(window.window):
        window.floating = True
