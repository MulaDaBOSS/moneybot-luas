local offsetcheck = ui.get('Visuals', 'Other', 'Misc', 'Custom Offset')
local offset = ui.get('Visuals', 'Other', 'Misc', 'Right')
local checkbox = ui.add_checkbox('Enable', false)
local key = ui.add_hotkey('enable')
local test = false

local function switch()
    if key:resolve() and checkbox:get() and offsetcheck:get() then
        if not test then
            offset:set(-offset:get())
            test = true
        end
    else
        test = false
    end
end

callbacks.register("paint", switch)
