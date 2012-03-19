from libqtile.manager import Click, Drag, Key, Screen, Group
from libqtile.command import lazy
from libqtile import layout, bar, widget

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
        lazy.spawncmd(prompt=':')),

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

groups = [
    Group("1"),
    Group("2"),
    Group("3"),
    Group("4"),
    Group("5"),
    Group("6"),
    Group("7"),
    Group("8"),
    Group("9"),
]
for group in groups:
    keys.append(
        Key([mod], group.name,
            lazy.group[group.name].toscreen()))
    keys.append(
        Key([mod, "shift"], group.name,
            lazy.window.togroup(group.name)))

layouts = [
    layout.MonadTall(),
    layout.Max(),
    layout.Stack(stacks=2),
    layout.Floating(auto_float_types=set([
        'dialog',
        'utility',
        'notification',
        'toolbar',
        'splash',
        ])
    ),
]

sepcolor = "#B0B0B0"
bgcolor = "#D0D0D0"
fgcolor = "#000000"

screens = [
    Screen(
        bottom = bar.Bar(
                    [
                        widget.GroupBox(
                            active="#000000",
                            inactive="#808080",
                            borderwidth=1,
                            padding=2,
                            margin_x=1,
                            margin_y=1,
                            font="Sans",
                            fontsize=12,
                            background=bgcolor,
                            foreground=fgcolor),
                        widget.Sep(
                            background=bgcolor,
                            foreground=sepcolor),
                        widget.Prompt(
                            font="Sans",
                            fontsize=12,
                            background=bgcolor,
                            foreground=fgcolor),
                        widget.WindowName(
                            font="Sans",
                            fontsize=12,
                            background=bgcolor,
                            foreground=fgcolor),
                        widget.Sep(
                            background=bgcolor,
                            foreground=sepcolor),
                        widget.Systray(
                            font="Sans",
                            fontsize=12,
                            background=bgcolor,
                            foreground=fgcolor),
                        widget.CPUGraph(
                            width=50,
                            graph_color="30F030",
                            border_width=2,
                            border_color=bgcolor,
                            margin_x=0,
                            margin_y=0,
                            line_width=1),
                        widget.MemoryGraph(
                            width=50,
                            graph_color="F030F0",
                            border_width=2,
                            border_color=bgcolor,
                            margin_x=0,
                            margin_y=0,
                            line_width=1),
                        widget.NetGraph(
                            width=50,
                            graph_color="F0F030",
                            border_width=2,
                            border_color=bgcolor,
                            margin_x=0,
                            margin_y=0,
                            line_width=1),
                        widget.Clock(
                            "%a %b %d %H:%M",
                            font="Sans",
                            fontsize=12,
                            background=bgcolor,
                            foreground=fgcolor),
                    ],
                    20,
                    background="#D0D0D0",
                ),
    ),
]
