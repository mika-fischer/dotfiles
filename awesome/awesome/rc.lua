-- {{{ Libraries
-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup").widget
local vicious = require("vicious")
local lain = require("lain")
-- }}}

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = tostring(err) })
        in_error = false
    end)
end
-- }}}

-- {{{ Important variables
local home     = os.getenv("HOME")
local altkey   = "Mod1"
local modkey   = "Mod4"
local shiftkey = "Shift"
local ctrlkey  = "Control"
local terminal = "urxvt"
local editor   = "vim"
local exec          = awful.util.spawn
local sexec         = awful.util.spawn_with_shell
local editor_cmd    = terminal .. " -e " .. editor
local lock_cmd      = "i3lock"
-- }}}

menubar.cache_entries = true
menubar.app_folders = { "/usr/share/applications/" }
beautiful.init(awful.util.getdir("config") .. "/themes/zoop/theme.lua")

-- {{{ Layouts
-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
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
    awful.layout.suit.magnifier,
    awful.layout.suit.corner.nw,
    -- awful.layout.suit.corner.ne,
    -- awful.layout.suit.corner.sw,
    -- awful.layout.suit.corner.se,
}
-- }}}

-- {{{ Helper functions
local function client_menu_toggle_fn()
    local instance = nil

    return function ()
        if instance and instance.wibox.visible then
            instance:hide()
            instance = nil
        else
            instance = awful.menu.clients({ theme = { width = 250 } })
        end
    end
end
-- }}}

-- {{{ Menu
-- Create a launcher widget and a main menu
myawesomemenu = {
   { "hotkeys", function() return false, hotkeys_popup.show_help end},
   { "manual", terminal .. " -e man awesome" },
   { "edit config", editor_cmd .. " " .. awesome.conffile },
   { "restart", awesome.restart },
   { "quit", function() awesome.quit() end}
}

mymainmenu = awful.menu({ items = { { "awesome", myawesomemenu, beautiful.awesome_icon },
                                    { "open terminal", terminal }
                                  }
                        })

mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
                                     menu = mymainmenu })

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}
-- {{{ Wibox

spacer = wibox.widget.textbox()
spacer.fit = function(widget, w, h) return 2, h end

mytextclock = awful.widget.textclock()

local graph_width = 50
local graph_bg    = "#000000"

cpuwidget = awful.widget.graph()
cpuwidget:set_width(graph_width)
cpuwidget:set_background_color(graph_bg)
cpuwidget:set_color({ type = "linear", from = { 0, 0 }, to = { 0, 20 }, stops = { { 0, "#ff4040" }, { 0.5, "#FFFF40" }, { 1, "#40FF40" } } })
vicious.register(cpuwidget, vicious.widgets.cpu, "$1", 1)

cpulayout = wibox.layout.mirror()
cpulayout:set_reflection({ vertical = true })
cpulayout:set_widget(cpuwidget)

memwidget = awful.widget.graph()
memwidget:set_width(graph_width)
memwidget:set_background_color(graph_bg)
memwidget:set_color("#4040FF")
vicious.register(memwidget, vicious.widgets.mem, "$1", 1)

memlayout = wibox.layout.mirror()
memlayout:set_reflection({ vertical = true })
memlayout:set_widget(memwidget)

weatherwidget = lain.widgets.weather({
    city_id = 2892794,
    settings = function()
        descr = weather_now["weather"][1]["description"]:lower()
        units = math.floor(weather_now["main"]["temp"])
        widget:set_markup(" " .. units .. "°C ")
    end
})

if awful.util.file_readable("/sys/class/power_supply/BAT1/capacity") then
    batwidget = lain.widgets.bat({
        battery = "BAT1",
        settings = function()
            perc = bat_now["perc"]
            widget:set_markup(" " .. perc .. "% ")
        end
    })
end

-- Keyboard map indicator and changer
kbdcfg = {}
kbdcfg.cmd = "setxkbmap"
kbdcfg.options = "-option caps:backspace -option compose:menu"
kbdcfg.layout = { { "us", "us", "altgr-intl" }, { "cm", "us", "colemak" }, { "de", "de", "nodeadkeys" } }
kbdcfg.current = 3
kbdcfg.widget = wibox.widget.textbox()
kbdcfg.widget:set_text(" " .. kbdcfg.layout[kbdcfg.current][1] .. " ")
kbdcfg.switch = function ()
    kbdcfg.current = kbdcfg.current % #(kbdcfg.layout) + 1
    local t = kbdcfg.layout[kbdcfg.current]
    kbdcfg.widget:set_text(" " .. t[1] .. " ")
    os.execute(kbdcfg.cmd .. " -layout " .. t[2] .. " -variant " .. t[3] .. " " .. kbdcfg.options )
end
kbdcfg.widget:buttons(
    awful.util.table.join(awful.button({ }, 1, function () kbdcfg.switch() end))
)
kbdcfg.switch()

-- Create a wibox for each screen and add it
local taglist_buttons = awful.util.table.join(
                    awful.button({ }, 1, function(t) t:view_only() end),
                    awful.button({ modkey }, 1, function(t)
                                              if client.focus then
                                                  client.focus:move_to_tag(t)
                                              end
                                          end),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, function(t)
                                              if client.focus then
                                                  client.focus:toggle_tag(t)
                                              end
                                          end),
                    awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
                    awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end)
                )

local tasklist_buttons = awful.util.table.join(
                     awful.button({ }, 1, function (c)
                                              if c == client.focus then
                                                  c.minimized = true
                                              else
                                                  -- Without this, the following
                                                  -- :isvisible() makes no sense
                                                  c.minimized = false
                                                  if not c:isvisible() and c.first_tag then
                                                      c.first_tag:view_only()
                                                  end
                                                  -- This will also un-minimize
                                                  -- the client, if needed
                                                  client.focus = c
                                                  c:raise()
                                              end
                                          end),
                     awful.button({ }, 3, client_menu_toggle_fn()),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(1)
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(-1)
                                          end))

local function set_wallpaper(s)
    -- Wallpaper
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        -- If wallpaper is a function, call it with the screen
        if type(wallpaper) == "function" then
            wallpaper = wallpaper(s)
        end
        gears.wallpaper.maximized(wallpaper, s, true)
    end
end

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)

awful.screen.connect_for_each_screen(function(s)
    -- Wallpaper
    set_wallpaper(s)

    -- Each screen has its own tag table.
    awful.tag({ "1", "2", "3", "4", "5", "6", "7", "8", "9" }, s, awful.layout.layouts[2])

    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(awful.util.table.join(
                           awful.button({ }, 1, function () awful.layout.inc( 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(-1) end),
                           awful.button({ }, 4, function () awful.layout.inc( 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(-1) end)))
    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist(s, awful.widget.taglist.filter.all, taglist_buttons)

    -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, tasklist_buttons)

    -- Create the wibox
    s.mywibox = awful.wibar({ position = "bottom", screen = s })

    -- Add widgets to the wibox
    s.mywibox:setup {
        layout = wibox.layout.align.horizontal,
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            mylauncher,
            s.mytaglist,
            s.mypromptbox,
            spacer,
        },
        s.mytasklist, -- Middle widget
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            spacer,
            wibox.widget.systray(),
            spacer,
            kbdcfg.widget,
            spacer,
            cpulayout,
            spacer,
            memlayout,
            spacer,
            weatherwidget,
            --batwidget,
            spacer,
            mytextclock,
            s.mylayoutbox,
        },
    }
end)
-- }}}

-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
globalkeys = awful.util.table.join(
    awful.key({ modkey,           }, "s",      hotkeys_popup.show_help,
              {description="show help", group="awesome"}),
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev,
              {description = "view previous", group = "tag"}),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext,
              {description = "view next", group = "tag"}),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore,
              {description = "go back", group = "tag"}),

    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx( 1)
        end,
        {description = "focus next by index", group = "client"}
    ),
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
        end,
        {description = "focus previous by index", group = "client"}
    ),
    awful.key({ modkey,           }, "w", function () mymainmenu:show() end,
              {description = "show main menu", group = "awesome"}),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end,
              {description = "swap with next client by index", group = "client"}),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end,
              {description = "swap with previous client by index", group = "client"}),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end,
              {description = "focus the next screen", group = "screen"}),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end,
              {description = "focus the previous screen", group = "screen"}),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto,
              {description = "jump to urgent client", group = "client"}),
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end,
        {description = "go back", group = "client"}),

    -- Standard program
    awful.key({ modkey, "Shift" }, "Return", function () awful.spawn(terminal) end,
              {description = "open a terminal", group = "launcher"}),
    awful.key({ modkey, "Control" }, "r", awesome.restart,
              {description = "reload awesome", group = "awesome"}),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit,
              {description = "quit awesome", group = "awesome"}),

    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)          end,
              {description = "increase master width factor", group = "layout"}),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)          end,
              {description = "decrease master width factor", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1, nil, true) end,
              {description = "increase the number of master clients", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1, nil, true) end,
              {description = "decrease the number of master clients", group = "layout"}),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1, nil, true)    end,
              {description = "increase the number of columns", group = "layout"}),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1, nil, true)    end,
              {description = "decrease the number of columns", group = "layout"}),
    awful.key({ modkey,           }, "space", function () awful.layout.inc( 1)                end,
              {description = "select next", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(-1)                end,
              {description = "select previous", group = "layout"}),

    awful.key({ modkey, "Control" }, "n",
              function ()
                  local c = awful.client.restore()
                  -- Focus restored client
                  if c then
                      client.focus = c
                      c:raise()
                  end
              end,
              {description = "restore minimized", group = "client"}),

    -- Prompt
    awful.key({ modkey },            "p",     function () awful.screen.focused().mypromptbox:run() end,
              {description = "run prompt", group = "launcher"}),

    awful.key({ modkey }, "x",
              function ()
                  awful.prompt.run {
                    prompt       = "Run Lua code: ",
                    textbox      = awful.screen.focused().mypromptbox.widget,
                    exe_callback = awful.util.eval,
                    history_path = awful.util.get_cache_dir() .. "/history_eval"
                  }
              end,
              {description = "lua execute prompt", group = "awesome"}),
    -- Menubar
    awful.key({ modkey }, "r", function() menubar.show() end,
              {description = "show the menubar", group = "launcher"}),

    -- Power control
    awful.key({ altkey, ctrlkey, shiftkey }, "l", function () exec(lock_cmd) end),
    awful.key({ }, "XF86ScreenSaver",             function () exec(lock_cmd) end),
    awful.key({ altkey, ctrlkey, shiftkey }, "h", function () exec("systemctl poweroff")     end),
    awful.key({ altkey, ctrlkey, shiftkey }, "r", function () exec("systemctl reboot")       end),
    awful.key({ altkey, ctrlkey, shiftkey }, "s", function () exec("systemctl hybrid-sleep") end),
    awful.key({ }, "XF86Sleep",                   function () exec("systemctl hybrid-sleep") end),
    awful.key({ altkey, ctrlkey, shiftkey }, "d", function () exec("systemctl hibernate")    end),
    awful.key({ }, "XF86Suspend",                 function () exec("systemctl hibernate")    end),

    -- Screen backlight
    awful.key({ }, "XF86MonBrightnessUp",   function () exec("xbacklight +10") end),
    awful.key({ }, "XF86MonBrightnessDown", function () exec("xbacklight -10") end),

    -- Multimedia
    awful.key({ modkey }, "=",                    function () exec(home .. "/bin/volume.sh up")   end),
    awful.key({        }, "XF86AudioRaiseVolume", function () exec(home .. "/bin/volume.sh up")   end),
    awful.key({ modkey }, "-",                    function () exec(home .. "/bin/volume.sh down") end),
    awful.key({        }, "XF86AudioLowerVolume", function () exec(home .. "/bin/volume.sh down") end),
    awful.key({ modkey }, "0",                    function () exec(home .. "/bin/volume.sh mute") end),
    awful.key({        }, "XF86AudioMute",        function () exec(home .. "/bin/volume.sh mute") end),

    -- Media players (Squeezebox, Spotify)
    awful.key({ modkey }, "F7",                   function () exec(home .. "/bin/media.sh prev")        end),
    awful.key({ modkey }, "XF86AudioPrev",        function () exec(home .. "/bin/media.sh prev")        end),
    awful.key({ modkey }, "F8",                   function () exec(home .. "/bin/media.sh next")        end),
    awful.key({ modkey }, "XF86AudioNext",        function () exec(home .. "/bin/media.sh next")        end),
    awful.key({ modkey }, "F9",                   function () exec(home .. "/bin/media.sh toggle_play") end),
    awful.key({ modkey }, "XF86AudioPlay",        function () exec(home .. "/bin/media.sh toggle_play") end),
    awful.key({ modkey }, "F10",                  function () exec(home .. "/bin/media.sh toggle")      end),
    awful.key({ modkey }, "XF86AudioMute",        function () exec(home .. "/bin/media.sh toggle")      end),
    awful.key({ modkey }, "F11",                  function () exec(home .. "/bin/media.sh volume_down") end),
    awful.key({ modkey }, "XF86AudioLowerVolume", function () exec(home .. "/bin/media.sh volume_down") end),
    awful.key({ modkey }, "F12",                  function () exec(home .. "/bin/media.sh volume_up")   end),
    awful.key({ modkey }, "XF86AudioRaiseVolume", function () exec(home .. "/bin/media.sh volume_up")   end)

)

clientkeys = awful.util.table.join(
    awful.key({ modkey,           }, "f",
        function (c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end,
        {description = "toggle fullscreen", group = "client"}),
    awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end,
              {description = "close", group = "client"}),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ,
              {description = "toggle floating", group = "client"}),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end,
              {description = "move to master", group = "client"}),
    awful.key({ modkey,           }, "o",      function (c) c:move_to_screen()               end,
              {description = "move to screen", group = "client"}),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end,
              {description = "toggle keep on top", group = "client"}),
    awful.key({ modkey,           }, "n",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end ,
        {description = "minimize", group = "client"}),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized = not c.maximized
            c:raise()
        end ,
        {description = "maximize", group = "client"})
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    globalkeys = awful.util.table.join(globalkeys,
        -- View tag only.
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = awful.screen.focused()
                        local tag = screen.tags[i]
                        if tag then
                           tag:view_only()
                        end
                  end,
                  {description = "view tag #"..i, group = "tag"}),
        -- Toggle tag display.
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = awful.screen.focused()
                      local tag = screen.tags[i]
                      if tag then
                         awful.tag.viewtoggle(tag)
                      end
                  end,
                  {description = "toggle tag #" .. i, group = "tag"}),
        -- Move client to tag.
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:move_to_tag(tag)
                          end
                     end
                  end,
                  {description = "move focused client to tag #"..i, group = "tag"}),
        -- Toggle tag on focused client.
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:toggle_tag(tag)
                          end
                      end
                  end,
                  {description = "toggle focused client on tag #" .. i, group = "tag"})
    )
end

clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     raise = true,
                     keys = clientkeys,
                     buttons = clientbuttons,
                     screen = awful.screen.preferred,
                     placement = awful.placement.no_overlap+awful.placement.no_offscreen
                 } },
    { rule = { class = "URxvt" },
      properties = { size_hints_honor = false } },
    { rule = { class = "MPlayer" },
      properties = { floating = true } },
    { rule = { class = "pinentry" },
      properties = { floating = true } },
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

    -- Add titlebars to dialogs
    { rule_any = {type = { "dialog" }
      }, properties = { titlebars_enabled = true }
    },

}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- if not awesome.startup then awful.client.setslave(c) end

    if awesome.startup and
      not c.size_hints.user_position
      and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
end)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
    -- buttons for the titlebar
    local buttons = awful.util.table.join(
        awful.button({ }, 1, function()
            client.focus = c
            c:raise()
            awful.mouse.client.move(c)
        end),
        awful.button({ }, 3, function()
            client.focus = c
            c:raise()
            awful.mouse.client.resize(c)
        end)
    )

    awful.titlebar(c) : setup {
        { -- Left
            awful.titlebar.widget.iconwidget(c),
            buttons = buttons,
            layout  = wibox.layout.fixed.horizontal
        },
        { -- Middle
            { -- Title
                align  = "center",
                widget = awful.titlebar.widget.titlewidget(c)
            },
            buttons = buttons,
            layout  = wibox.layout.flex.horizontal
        },
        { -- Right
            awful.titlebar.widget.floatingbutton (c),
            awful.titlebar.widget.maximizedbutton(c),
            awful.titlebar.widget.stickybutton   (c),
            awful.titlebar.widget.ontopbutton    (c),
            awful.titlebar.widget.closebutton    (c),
            layout = wibox.layout.fixed.horizontal()
        },
        layout = wibox.layout.align.horizontal
    }
end)

-- Enable sloppy focus, so that focus follows mouse.
--client.connect_signal("mouse::enter", function(c)
    --if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
        --and awful.client.focus.filter(c) then
        --client.focus = c
    --end

awful.screen.connect_for_each_screen(function(s)
    screen[s]:connect_signal("arrange", function ()
        local clients = awful.client.visible(s)
        local tiled   = awful.client.tiled(s)
        local layout  = awful.layout.getname(awful.layout.get(s))

        if #clients > 0 then
            for _, c in pairs(clients) do
                -- Maximized windows never have a border
                if c.maximized_horizontal and c.maximized_vertical then
                    c.border_width = 0
                -- Floating windows always have a border
                elseif awful.client.floating.get(c) or layout == "floating" then
                    c.border_width = beautiful.border_width
                -- No borders with only one visible tiled client or max layout
                elseif #tiled == 1 or layout == "max" then
                    c.border_width = 0
                -- Otherwise (more than one tiled client), draw borders
                else
                    c.border_width = beautiful.border_width
                end
            end
        end
    end)
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}
