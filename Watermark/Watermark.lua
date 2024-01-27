local Draggable = require("Draggables")
local xx, yy = render.get_screen_size()
local dragshit = Draggable(xx/8, yy-200, 300, 150)
local font = render.create_font('Como', 30, 700, 0)
local logo = render.load_file('mb1.png')
local logo2 = render.load_file('mb2.png')
local menuaccent = ui.get('Misc', 'Main', 'Other', 'Menu Accent Color')

local wateroptions = ui.add_multi_dropdown("Watermark Options", {"Logo", "Cheat Name"})
local colortint = ui.add_colorpicker("", color(225, 102, 102, 255))
local usetint = ui.add_checkbox("Logo Tint", false)
local usemenuaccent = ui.add_checkbox("Use GUI Color", false)
local resetcolor = ui.add_checkbox("Reset Colorpicker", true)

usetint:set_visible(false)
usemenuaccent:set_visible(false)

local function reset()
    if resetcolor:get() then 
        colortint:set(color(255, 102, 102, 255))
        resetcolor:set(false)
    end
end
callbacks.register("paint", reset)

local function watar(x, y, width, height)
    usetint:set_visible(wateroptions:get("Logo"))
    if wateroptions:get("Logo") then
        render.image(logo, {x - 20, y +2}, width - 150, height, color(255, 255, 255))
        if usetint:get() then
            render.image(logo2, {x - 20, y - 3}, width - 150, height, colortint:get())
        else 
            render.image(logo2, {x - 20, y - 3}, width - 150, height, color(255,255,255))
        end
    end

    usemenuaccent:set_visible(wateroptions:get("Cheat Name"))
    if wateroptions:get("Cheat Name") then
        local textBaseX, textBaseY = x + 150, y + 66
        local rectX, rectY = textBaseX - 5, textBaseY - 3
        local rectWidth, rectHeight = 153, 36

        render.rectangle_filled(rectX, rectY, rectWidth, rectHeight, color(0, 0, 0, 128))

        render.gradient({rectX + rectWidth - 18, rectY-3}, {21, 3}, menuaccent:get(), menuaccent:get(), true)
        render.gradient({rectX + rectWidth - 0, rectY-3}, {3, 21}, menuaccent:get(), menuaccent:get(), false)

        render.gradient({rectX, rectY + rectHeight - 0}, {21, 3}, menuaccent:get(), menuaccent:get(), true)
        render.gradient({rectX-3, rectY + rectHeight - 18}, {3, 21}, menuaccent:get(), menuaccent:get(), false)

        render.text(textBaseX, textBaseY, color(255, 255, 255, 255), font, "MONEY")
        if usemenuaccent:get() then
            render.text(textBaseX + 92, textBaseY, menuaccent:get(), font, "BOT")
        else
            render.text(textBaseX + 92, textBaseY, colortint:get(), font, "BOT")
        end
    end
end

dragshit:set_draw_function(watar)