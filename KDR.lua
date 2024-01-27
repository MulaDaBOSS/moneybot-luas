local Draggable = require("Draggables")
local xx, yy = render.get_screen_size()
local critbox = Draggable(xx - xx+20, yy/2, 150, 50)
local font = render.create_font('Arial', 20, 800, FONTFLAG_OUTLINE)

local function drawkd(x, y, width, height)
    local lp = entity_list.get_local_player()
    
    if not lp then
        return
    end

    local ent_index = lp:get_index()
    local kills = pr.get_kills(ent_index)
    local deaths = pr.get_deaths(ent_index)
    local kdr = 0
    
    if deaths == 0 then
        kdr = "∞"
    else
        kdr = kills / deaths
        
        if math.floor(kdr) == kdr then
            kdr = string.format("%.0f", kdr)
        else
            kdr = string.format("%.1f", kdr)
        end
    end

    if user.is_in_game() then
        render.text({x,y}, color(255, 255, 255), font, 0, "KDR: " .. kdr)
        render.text({x,y+20}, color(255, 255, 255), font, 0, "Kills: " .. kills)
        render.text({x,y+40}, color(255, 255, 255), font, 0, "Deaths: " .. deaths)
    end
end

critbox:set_draw_function(drawkd)
