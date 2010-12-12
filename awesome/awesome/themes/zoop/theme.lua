--------------------------
-- Zoop's awesome theme --
--------------------------

theme = {}

-- Path
local os = os
theme.base_path     = os.getenv("HOME") .. "/.config/awesome/themes/zoop"

-- Fonts
theme.font          = "sans 8"

-- Colors
theme.fg_normal     = "#000000"
theme.bg_normal     = "#ffffff"
theme.fg_focus      = "#000000"
theme.bg_focus      = "#e0e0e0"
theme.fg_urgent     = "#ffffff"
theme.bg_urgent     = "#ff0000"
theme.fg_minimize   = "#a0a0a0"
theme.bg_minimize   = "#ffffff"
theme.border_width  = "2"
theme.border_normal = "#ffffff"
theme.border_focus  = "#606060"
theme.border_marked = "#91231c"

-- Taglist
theme.taglist_squares_sel   = theme.base_path .. "/taglist/squaref.png"
theme.taglist_squares_unsel = theme.base_path .. "/taglist/squaref.png"

-- Tasklist
theme.tasklist_floating_icon = theme.base_path .. "/tasklist/floating.png"

-- Menu
theme.menu_height = "15"
theme.menu_width  = "100"
theme.menu_submenu_icon = theme.base_path .. "/submenu.png"

-- Titlebar
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

-- Wallpaper
theme.wallpaper_cmd = { "awsetbg " .. theme.base_path .. "/background_white.png" }

-- Layout icons
theme.layout_dwindle    = theme.base_path .. "/layouts/dwindle.png"
theme.layout_fairh      = theme.base_path .. "/layouts/fairh.png"
theme.layout_fairv      = theme.base_path .. "/layouts/fairv.png"
theme.layout_floating   = theme.base_path .. "/layouts/floating.png"
theme.layout_fullscreen = theme.base_path .. "/layouts/fullscreen.png"
theme.layout_magnifier  = theme.base_path .. "/layouts/magnifier.png"
theme.layout_max        = theme.base_path .. "/layouts/max.png"
theme.layout_tile       = theme.base_path .. "/layouts/tile.png"
theme.layout_tilebottom = theme.base_path .. "/layouts/tilebottom.png"
theme.layout_tileleft   = theme.base_path .. "/layouts/tileleft.png"
theme.layout_tiletop    = theme.base_path .. "/layouts/tiletop.png"
theme.layout_spiral     = theme.base_path .. "/layouts/spiral.png"

-- Menu icon
theme.awesome_icon      = "~/.config/awesome/icons/awesome16.png"

return theme
