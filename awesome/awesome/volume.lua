volume_widget = awful.widget.progressbar()
volume_widget:set_width(8)
volume_widget:set_background_color("#000000")
volume_widget:set_color(beautiful.fg_normal)
volume_widget:set_vertical(true)
volume_widget:set_max_value(1)

function update_volume_widget(widget)
    local fd = io.popen("amixer sget Master")
    local status = fd:read("*all")
    fd:close()
    local volume = tonumber(string.match(status, "(%d?%d?%d)%%")) / 100
    local mute_state = string.match(status, "%[(o[^%]]*)%]")
    if string.find(mute_state, "on", 1, true) then
        widget:set_background_color("#000000")
        widget:set_value(volume)
    else
        widget:set_background_color('#A06060')
        widget:set_value(0)
    end
end

update_volume_widget(volume_widget)

volume_update_timer = timer({timeout=1})
volume_update_timer:add_signal("timeout", function () update_volume_widget(volume_widget) end)
volume_update_timer:start()
