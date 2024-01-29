local manualindicator = render.create_font('Arial', 65, 0, 0)
local x, y = render.get_screen_size()
local menuaccent = ui.get('Misc', 'Main', 'Other', 'Menu Accent Color')
local slider = ui.add_slider('Arrow Gap', 25, 0, 50)
local n = ui.get('Misc', 'Rage', 'Pay2Win Angles', 'Manual Direction')

local function render_arrow(position, clr)
    local offset = position == 'left' and -55 - slider:get() or 25 + slider:get()
    local symbol = position == 'left' and "⮜" or "⮞"
    render.text({x/2 + offset, y/2 - 40}, clr, manualindicator, 0, symbol)
end

local function drawmanual()
    if not (engine.in_game() and client.is_alive() and not user.is_game_ui_visible() and n:get()) then
        return
    end

    local side = antiaim.get_manual_side()

    if side == 1 then
        render_arrow('left', side == 1 and menuaccent:get())
        render_arrow('right', color(0, 0, 0, 120))
    elseif side == 2 then
        render_arrow('left', color(0, 0, 0, 120))
        render_arrow('right', side == 2 and menuaccent:get())
    else
        render_arrow('left', color(0, 0, 0, 120))
        render_arrow('right', color(0, 0, 0, 120))
    end
end

callbacks.register("paint", drawmanual)
