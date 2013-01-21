--------------------------
-- Zoop's awesome theme --
--------------------------

theme = {}

local os = os
theme.base_path     = os.getenv("HOME") .. "/.config/awesome/themes/zoop"

theme.font          = "sans 8"

theme.bg_normal     = "#e0e0e0"
theme.bg_focus      = "#f0b050"
theme.bg_urgent     = "#ff4040"
theme.bg_minimize   = "#ffffff"
theme.bg_systray    = theme.bg_normal

theme.fg_normal     = "#000000"
theme.fg_focus      = "#000000"
theme.fg_urgent     = "#000000"
theme.fg_minimize   = "#a0a0a0"

theme.border_width  = 3
theme.border_normal = "#e0e0e0"
theme.border_focus  = "#f0b050"
theme.border_marked = "#91231c"

-- There are other variable sets
-- overriding the default one when
-- defined, the sets are:
-- [taglist|tasklist]_[bg|fg]_[focus|urgent]
-- titlebar_[bg|fg]_[normal|focus]
-- tooltip_[font|opacity|fg_color|bg_color|border_width|border_color]
-- mouse_finder_[color|timeout|animate_timeout|radius|factor]
-- Example:
--theme.taglist_bg_focus = "#ff0000"

-- Display the taglist squares
theme.taglist_squares_sel   = theme.base_path .. "/taglist/triangle.png"
theme.taglist_squares_unsel = theme.base_path .. "/taglist/triangle.png"

-- Variables set for theming the menu:
-- menu_[bg|fg]_[normal|focus]
-- menu_[border_color|border_width]
theme.menu_submenu_icon = theme.base_path .. "/submenu.png"
theme.menu_height = 15
theme.menu_width  = 100

-- You can add as many variables as
-- you wish and access them by using
-- beautiful.variable in your rc.lua
--theme.bg_widget = "#cc0000"

-- Define the image to load
theme.titlebar_close_button_normal              = theme.base_path .. "/titlebar/close_normal.png"
theme.titlebar_close_button_focus               = theme.base_path .. "/titlebar/close_focus.png"

theme.titlebar_ontop_button_normal_inactive     = theme.base_path .. "/titlebar/ontop_normal_inactive.png"
theme.titlebar_ontop_button_focus_inactive      = theme.base_path .. "/titlebar/ontop_focus_inactive.png"
theme.titlebar_ontop_button_normal_active       = theme.base_path .. "/titlebar/ontop_normal_active.png"
theme.titlebar_ontop_button_focus_active        = theme.base_path .. "/titlebar/ontop_focus_active.png"

theme.titlebar_sticky_button_normal_inactive    = theme.base_path .. "/titlebar/sticky_normal_inactive.png"
theme.titlebar_sticky_button_focus_inactive     = theme.base_path .. "/titlebar/sticky_focus_inactive.png"
theme.titlebar_sticky_button_normal_active      = theme.base_path .. "/titlebar/sticky_normal_active.png"
theme.titlebar_sticky_button_focus_active       = theme.base_path .. "/titlebar/sticky_focus_active.png"

theme.titlebar_floating_button_normal_inactive  = theme.base_path .. "/titlebar/floating_normal_inactive.png"
theme.titlebar_floating_button_focus_inactive   = theme.base_path .. "/titlebar/floating_focus_inactive.png"
theme.titlebar_floating_button_normal_active    = theme.base_path .. "/titlebar/floating_normal_active.png"
theme.titlebar_floating_button_focus_active     = theme.base_path .. "/titlebar/floating_focus_active.png"

theme.titlebar_maximized_button_normal_inactive = theme.base_path .. "/titlebar/maximized_normal_inactive.png"
theme.titlebar_maximized_button_focus_inactive  = theme.base_path .. "/titlebar/maximized_focus_inactive.png"
theme.titlebar_maximized_button_normal_active   = theme.base_path .. "/titlebar/maximized_normal_active.png"
theme.titlebar_maximized_button_focus_active    = theme.base_path .. "/titlebar/maximized_focus_active.png"

theme.wallpaper = theme.base_path .. "/background_white.png"

-- You can use your own layout icons like this:
theme.layout_fairh      = theme.base_path .. "/layouts/fairh.png"
theme.layout_fairv      = theme.base_path .. "/layouts/fairv.png"
theme.layout_floating   = theme.base_path .. "/layouts/floating.png"
theme.layout_magnifier  = theme.base_path .. "/layouts/magnifier.png"
theme.layout_max        = theme.base_path .. "/layouts/max.png"
theme.layout_fullscreen = theme.base_path .. "/layouts/fullscreen.png"
theme.layout_tilebottom = theme.base_path .. "/layouts/tilebottom.png"
theme.layout_tileleft   = theme.base_path .. "/layouts/tileleft.png"
theme.layout_tile       = theme.base_path .. "/layouts/tile.png"
theme.layout_tiletop    = theme.base_path .. "/layouts/tiletop.png"
theme.layout_spiral     = theme.base_path .. "/layouts/spiral.png"
theme.layout_dwindle    = theme.base_path .. "/layouts/dwindle.png"

theme.awesome_icon      = "~/.config/awesome/icons/awesome16.png"

-- Define the icon theme for application icons. If not set then the icons 
-- from /usr/share/icons and /usr/share/icons/hicolor will be used.
theme.icon_theme = nil

return theme
