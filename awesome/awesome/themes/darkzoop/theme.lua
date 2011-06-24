-------------------------------
-- Zoop's dark awesome theme --
-------------------------------

theme = {}

-- Path
local os = os
theme.base_path     = os.getenv("HOME") .. "/.config/awesome/themes/zoop"

-- Fonts
theme.font          = "sans 8"

-- Colors
theme.fg_normal     = "#aaaaaa"
theme.bg_normal     = "#222222"
theme.fg_focus      = "#000000"
theme.bg_focus      = "#f0b050"
theme.fg_urgent     = "#000000"
theme.bg_urgent     = "#ff4040"
theme.fg_minimize   = "#ffffff"
theme.bg_minimize   = "#444444"
theme.border_width  = "2"
theme.border_normal = "#222222"
theme.border_focus  = "#f0b050"
theme.border_marked = "#91231c"

-- Taglist
theme.taglist_squares_sel   = theme.base_path .. "/taglist/squarefw.png"
theme.taglist_squares_unsel = theme.base_path .. "/taglist/squarew.png"

-- Tasklist
theme.tasklist_floating_icon = theme.base_path .. "/tasklist/floatingw.png"

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
theme.wallpaper_cmd = { "awsetbg " .. theme.base_path .. "/background.png" }

-- Layout icons
theme.layout_dwindle    = theme.base_path .. "/layouts/dwindlew.png"
theme.layout_fairh      = theme.base_path .. "/layouts/fairhw.png"
theme.layout_fairv      = theme.base_path .. "/layouts/fairvw.png"
theme.layout_floating   = theme.base_path .. "/layouts/floatingw.png"
theme.layout_fullscreen = theme.base_path .. "/layouts/fullscreenw.png"
theme.layout_magnifier  = theme.base_path .. "/layouts/magnifierw.png"
theme.layout_max        = theme.base_path .. "/layouts/maxw.png"
theme.layout_tile       = theme.base_path .. "/layouts/tilew.png"
theme.layout_tilebottom = theme.base_path .. "/layouts/tilebottomw.png"
theme.layout_tileleft   = theme.base_path .. "/layouts/tileleftw.png"
theme.layout_tiletop    = theme.base_path .. "/layouts/tiletopw.png"
theme.layout_spiral     = theme.base_path .. "/layouts/spiralw.png"

-- Menu icon
theme.awesome_icon      = "~/.config/awesome/icons/awesome16.png"

return theme
