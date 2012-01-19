-- {{{ Important variables
local home          = os.getenv("HOME")
local altkey        = "Mod1"
local modkey        = "Mod4"
local shiftkey      = "Shift"
local ctrlkey       = "Control"
local terminal      = "urxvt"
local editor        = "vim"
-- }}}

-- {{{ Libraries
require("awful")
require("awful.autofocus")
require("awful.rules")
require("beautiful")
beautiful.init(home .. "/.config/awesome/themes/zoop/theme.lua")
require("naughty")
require("vicious")
require("menubar")
--- }}}

menubar.cache_entries = true
menubar.app_folders = { "/usr/share/applications/" }

-- {{{ Shortcuts
local exec          = awful.util.spawn
local sexec         = awful.util.spawn_with_shell
local editor_cmd    = terminal .. " -e " .. editor
local lock_cmd      = "slimlock"
local consolekit    = "dbus-send --system --print-reply --dest=\"org.freedesktop.ConsoleKit\" "
                      .. "/org/freedesktop/ConsoleKit/Manager org.freedesktop.ConsoleKit.Manager."
local upower        = "dbus-send --system --print-reply --dest=\"org.freedesktop.UPower\" "
                      .. "/org/freedesktop/UPower org.freedesktop.UPower."

-- {{{ Layouts
layouts =
{
    awful.layout.suit.floating,
    awful.layout.suit.tile,
    awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.top,
    awful.layout.suit.fair,
    awful.layout.suit.fair.horizontal,
    awful.layout.suit.spiral,
    awful.layout.suit.spiral.dwindle,
    awful.layout.suit.max,
    awful.layout.suit.max.fullscreen,
    awful.layout.suit.magnifier
}
-- }}}

-- {{{ Tags
-- Define a tag table which hold all screen tags.
tags = {}
for s = 1, screen.count() do
    -- Each screen has its own tag table.
    tags[s] = awful.tag({ 1, 2, 3, 4, 5, 6, 7, 8, 9 }, s, layouts[2])
end
-- }}}

-- {{{ Wibox

spacer       = widget({ type = "textbox"})
spacer.width = 2

mytextclock = awful.widget.textclock()
mysystray = widget({ type = "systray" })

require("volume")

graph_width = 50
graph_bg    = "#000000"

cpuwidget = awful.widget.graph()
cpuwidget:set_width(graph_width)
cpuwidget:set_background_color(graph_bg)
cpuwidget:set_color("#FF4040")
cpuwidget:set_gradient_colors({ "#FF4040", "#FFFF40", "#40FF40" })
cpuwidget:set_gradient_angle(0)
vicious.register(cpuwidget, vicious.widgets.cpu, "$1", 1)

memwidget = awful.widget.graph()
memwidget:set_width(graph_width)
memwidget:set_background_color(graph_bg)
memwidget:set_color("#4040FF")
vicious.register(memwidget, vicious.widgets.mem, "$1", 1)

-- Create a wibox for each screen and add it
mywibox     = {}
mypromptbox = {}
mylayoutbox = {}
mytaglist   = {}
mytasklist  = {}

for s = 1, screen.count() do
    mypromptbox[s] = awful.widget.prompt({ layout = awful.widget.layout.horizontal.leftright })
    mylayoutbox[s] = awful.widget.layoutbox(s)
    mytaglist[s]   = awful.widget.taglist(s, awful.widget.taglist.label.all)
    mytasklist[s]  = awful.widget.tasklist(function(c) return awful.widget.tasklist.label.currenttags(c, s) end)

    mywibox[s] = awful.wibox({ position = "bottom", screen = s })
    mywibox[s].widgets = {
        {
            mytaglist[s],
            mypromptbox[s],
            layout = awful.widget.layout.horizontal.leftright
        },
        mylayoutbox[s],
        s == 1 and mytextclock or nil,
        s == 1 and spacer or nil,
        s == 1 and volume_widget.widget or nil,
        s == 1 and spacer or nil,
        s == 1 and memwidget.widget or nil,
        s == 1 and spacer or nil,
        s == 1 and cpuwidget.widget or nil,
        s == 1 and spacer or nil,
        s == 1 and mysystray or nil,
        mytasklist[s],
        layout = awful.widget.layout.horizontal.rightleft
    }
end
-- }}}

-- {{{ Key bindings
globalkeys = awful.util.table.join(
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore),
    awful.key({ modkey,           }, "n", awful.tag.viewnext),
    awful.key({ modkey,           }, "p", awful.tag.viewprev),

    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx( 1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "s", function () menubar.show() end),

    -- Layout manipulation
    awful.key({ modkey,           }, "space", function () awful.layout.inc(layouts,  1) end),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(layouts, -1) end),
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto),
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end),
    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)    end),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)    end),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1)      end),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1)      end),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1)         end),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1)         end),

    -- unminimize all
    awful.key({ modkey, "Shift"   }, "n",
        function ()
            local allclients = client.get(mouse.screen)
            for _,c in ipairs(allclients) do
                if c.minimized and c:tags()[mouse.screen] == awful.tag.selected(mouse.screen) then
                    c.minimized = false
                    client.focus = c
                    c:raise()
                    return
                end
            end
        end),

    -- Standard programs
    awful.key({ modkey }, "Return",                 function () exec(terminal) end),

    -- Session control
    awful.key({ modkey,          shiftkey }, "r",   awesome.restart),
    awful.key({ modkey, ctrlkey, shiftkey }, "q",   awesome.quit),
    awful.key({ modkey, ctrlkey, shiftkey }, "l",   function () exec(lock_cmd) end),
    awful.key({ }, "XF86ScreenSaver",               function () exec(lock_cmd) end),

    -- Power control
    awful.key({ modkey, ctrlkey, shiftkey }, "h",   function () exec(consolekit .. "Stop") end),
    awful.key({ modkey, ctrlkey, shiftkey }, "r",   function () exec(consolekit .. "Restart") end),
    awful.key({ modkey, ctrlkey, shiftkey }, "s",   function () sexec(upower .. "Suspend"   .. "&" .. lock_cmd) end),
    awful.key({ modkey, ctrlkey, shiftkey }, "d",   function () sexec(upower .. "Hibernate" .. "&" .. lock_cmd) end),
    awful.key({ }, "XF86Sleep",                     function () sexec(upower .. "Suspend"   .. "&" .. lock_cmd) end),
    awful.key({ }, "XF86Suspend",                   function () sexec(upower .. "Hibernate" .. "&" .. lock_cmd) end),

    -- Multimedia
    awful.key({ modkey,                   }, "=",   function () exec(home .. "/bin/volume.sh up") end),
    awful.key({ modkey,                   }, "-",   function () exec(home .. "/bin/volume.sh down") end),
    awful.key({ modkey,                   }, "0",   function () exec(home .. "/bin/volume.sh mute") end),
    awful.key({ }, "XF86AudioRaiseVolume",          function () exec(home .. "/bin/volume.sh up") end),
    awful.key({ }, "XF86AudioLowerVolume",          function () exec(home .. "/bin/volume.sh down") end),
    awful.key({ }, "XF86AudioMute",                 function () exec(home .. "/bin/volume.sh mute") end),

    -- Squeezebox
    awful.key({ modkey,                   }, "F7",  function () exec(home .. "/bin/squeezebox.sh prev") end),
    awful.key({ modkey,                   }, "F8",  function () exec(home .. "/bin/squeezebox.sh next") end),
    awful.key({ modkey,                   }, "F9",  function () exec(home .. "/bin/squeezebox.sh toggle_play") end),
    awful.key({ modkey,                   }, "F10", function () exec(home .. "/bin/squeezebox.sh toggle") end),
    awful.key({ modkey,                   }, "F11", function () exec(home .. "/bin/squeezebox.sh volume_down") end),
    awful.key({ modkey,                   }, "F12", function () exec(home .. "/bin/squeezebox.sh volume_up") end),
    awful.key({ modkey }, "XF86AudioPrev",          function () exec(home .. "/bin/squeezebox.sh prev") end),
    awful.key({ modkey }, "XF86AudioNext",          function () exec(home .. "/bin/squeezebox.sh next") end),
    awful.key({ modkey }, "XF86AudioPlay",          function () exec(home .. "/bin/squeezebox.sh toggle_play") end),
    awful.key({ modkey }, "XF86AudioRaiseVolume",   function () exec(home .. "/bin/volume.sh up") end),
    awful.key({ modkey }, "XF86AudioLowerVolume",   function () exec(home .. "/bin/volume.sh down") end),
    awful.key({ modkey }, "XF86AudioMute",          function () exec(home .. "/bin/volume.sh mute") end),

    -- Prompt
    awful.key({ modkey }, "r",                      function () mypromptbox[mouse.screen]:run() end),
    awful.key({ modkey }, "x",
              function ()
                  awful.prompt.run({ prompt = "Run Lua code: " },
                  mypromptbox[mouse.screen].widget,
                  awful.util.eval, nil,
                  awful.util.getdir("cache") .. "/history_eval")
              end)
)

-- Default client window keybindings
clientkeys = awful.util.table.join(
    awful.key({ modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
    awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
    awful.key({ modkey,           }, "o",      awful.client.movetoscreen                        ),
    awful.key({ modkey, "Shift"   }, "r",      function (c) c:redraw()                       end),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end),
    --awful.key({ modkey,           }, "n",      function (c) c.minimized = not c.minimized    end),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c.maximized_vertical   = not c.maximized_vertical
        end)
)

-- Compute the maximum number of digit we need, limited to 9
keynumber = 0
for s = 1, screen.count() do
   keynumber = math.min(9, math.max(#tags[s], keynumber));
end

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, keynumber do
    globalkeys = awful.util.table.join(globalkeys,
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = mouse.screen
                        if tags[screen][i] then
                            awful.tag.viewonly(tags[screen][i])
                        end
                  end),
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = mouse.screen
                      if tags[screen][i] then
                          awful.tag.viewtoggle(tags[screen][i])
                      end
                  end),
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus and tags[client.focus.screen][i] then
                          awful.client.movetotag(tags[client.focus.screen][i])
                      end
                  end),
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus and tags[client.focus.screen][i] then
                          awful.client.toggletag(tags[client.focus.screen][i])
                      end
                  end))
end

clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = true,
                     keys = clientkeys,
                     buttons = clientbuttons } },
    { rule = { class = "urxvt" },
      properties = { size_hints_honot = false } },
    { rule = { class = "MPlayer" },
      properties = { floating = true } },
    { rule = { class = "pinentry" },
      properties = { floating = true } },
    { rule = { class = "gimp" },
      properties = { floating = true } },
    -- Set Firefox to always map on tags number 2 of screen 1.
    -- { rule = { class = "Firefox" },
    --   properties = { tag = tags[1][2] } },
    { rule = { class = "Skype" },
      properties = { floating = true } },
    { rule = { class = "Git-gui" },
      properties = { maximized_horizontal = true,
                     maximized_vertical   = true } },
    { rule = { class = "Git-citool" },
      properties = { maximized_horizontal = true,
                     maximized_vertical   = true } },
    { rule = { class = "Gitk" },
      properties = { maximized_horizontal = true,
                     maximized_vertical   = true } },
    { rule = { class = "Pidgin" },
      properties = { floating = true } },
    { rule = { instance = "plugin-container" },
      properties = { floating = true } },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.add_signal("manage", function (c, startup)
    -- Add a titlebar
    -- awful.titlebar.add(c, { modkey = modkey })

    if not startup then
        -- Set the windows at the slave,
        -- i.e. put it at the end of others instead of setting it master.
        -- awful.client.setslave(c)

        -- Put windows in a smart way, only if they does not set an initial position.
        if not c.size_hints.user_position and not c.size_hints.program_position then
            awful.placement.no_overlap(c)
            awful.placement.no_offscreen(c)
        end
    end
end)

client.add_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.add_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}
