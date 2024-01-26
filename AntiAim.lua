-- local shit
local YAW_ANGLES = {-135, -90, -45, 0, 45, 90, 135}
local lastSecond = user.get_local_time()
local additional_yaw_angle = 0
local previous_yawdropdown = 0
local previous_customyawdropdown = 0
local wascycled = false
-- local shit

-- add ui shit
local yawdropdown = ui.add_dropdown('Anti Aim Preset', {"Legit Anti Aim", "HvH", "Custom"})
local custompitchdropdown = ui.add_dropdown('Custom Pitch', {"None", "Up", "Down", "Jitter"})
local customyawdropdown = ui.add_dropdown('Custom Yaw', {"Backwards", "Left", "Right", "Forward", "Freestand"})
local yawcycle = ui.add_hotkey('Cycle Yaw')
local customfakeyawdropdown = ui.add_dropdown('Custom Fake Yaw', {'Static', "Spin", "Dynamic", "Set Angle"})
local spinspeed = ui.add_slider('Spin Speed', 1, 1, 25)
local customstaticfake = ui.add_slider('Fake Yaw Angle', 0, -180, 180)
-- add ui shit

-- get ui shit
local antiaimEnabled = ui.get('Misc', 'Rage', 'Pay2Win Angles', 'Enable')
local yawOffsetSetting = ui.get('Misc', 'Rage', 'Pay2Win Angles', 'Fake', 'Yaw Offset')
local realoffset = ui.get('Misc', 'Rage', 'Pay2Win Angles', 'Real', 'Yaw Offset')
local pitchSetting = ui.get('Misc', 'Rage', 'Pay2Win Angles', 'Pitch')
local realyaw = ui.get('Misc', 'Rage', 'Pay2Win Angles', 'Real')
local fakeyaw = ui.get('Misc', 'Rage', 'Pay2Win Angles', 'Fake')
local freestandcheck = ui.get('Misc', 'Rage', 'Pay2Win Angles', 'Real', 'Auto Direction')
local freestandkey = ui.get('Misc', 'Rage', 'Pay2Win Angles', 'Real', 'Edge Hotkey')
local fakespinspeed = ui.get('Misc', 'Rage', 'Pay2Win Angles', 'Fake', 'Spin Speed')
local avoidoverlapcheck = ui.get('Misc', 'Rage', 'Pay2Win Angles', 'Avoid Overlap')
local avoidoverlapdrop = ui.get('Misc', 'Rage', 'Pay2Win Angles', 'Style')
-- get ui shit

-- hide that shit
local function setvisibility(visible)
    custompitchdropdown:set_visible(visible)
    customyawdropdown:set_visible(visible)
    customfakeyawdropdown:set_visible(visible)
    spinspeed:set_visible(visible and customfakeyawdropdown:get() == 1)
    customstaticfake:set_visible(visible and customfakeyawdropdown:get() == 0)
end
setvisibility(false)
-- hide that shit

local function actualCycle()
    local iscycled = yawcycle:resolve()
    if client.is_alive() and antiaimEnabled:get() then
        if iscycled and not wascycled then
            console.log('Cycled Yaw')
            additional_yaw_angle = additional_yaw_angle + 90
        end
    end
    wascycled = iscycled
end

local function adjustYawOffset(offset)
    offset = offset % 360
    if offset > 180 then
        offset = offset - 360
    elseif offset < -180 then
        offset = offset + 360
    end
    return offset
end

local function sethvhpitch()
    local lp = entity_list.get_local_player()
    
    if not lp then
        return
    end

    local ent_index = lp:get_index()
    local class = pr.get_class(ent_index)
    local PITCH_ANGLES = {4, 5}

    if class == 6 or class == 2 then
        PITCH_ANGLES = {3, 5}
    end

    pitchSetting:set(PITCH_ANGLES[math.random(#PITCH_ANGLES)])
end

local function sethvhyaw()
    realoffset:set(adjustYawOffset(0 + additional_yaw_angle))
    local currentTime = user.get_local_time()
    if currentTime ~= lastSecond then
        yawOffsetSetting:set(YAW_ANGLES[math.random(#YAW_ANGLES)])
        lastSecond = currentTime
    end
end

local function setlegitaa()
    pitchSetting:set(0)
    yawOffsetSetting:set(0)
    realyaw:set(6)
    realoffset:set(adjustYawOffset(90 + additional_yaw_angle))
    fakeyaw:set(2)
    freestandcheck:set(false)
    avoidoverlapcheck:set(true)
    avoidoverlapdrop:set(1)
end

local function setotheraa()
    local pitch = custompitchdropdown:get()
    local realyawdrop = customyawdropdown:get()
    local fakeyawdrop = customfakeyawdropdown:get()

    if pitch == 0 then
        pitchSetting:set(0)
    elseif pitch == 1 then
        pitchSetting:set(2)
    elseif pitch == 2 then
        pitchSetting:set(1)
    elseif pitch == 3 then
        sethvhpitch()
    end

    if realyawdrop == 0 then
        realyaw:set(6)
        realoffset:set(adjustYawOffset(180 + additional_yaw_angle))
        freestandcheck:set(false)
    elseif realyawdrop == 1 then
        realyaw:set(6)
        realoffset:set(adjustYawOffset(90 + additional_yaw_angle))
        freestandcheck:set(false)
    elseif realyawdrop == 2 then
        realyaw:set(6)
        realoffset:set(adjustYawOffset(-90 + additional_yaw_angle))
        freestandcheck:set(false)
    elseif realyawdrop == 3 then
        realyaw:set(6)
        realoffset:set(adjustYawOffset(0 + additional_yaw_angle))
        freestandcheck:set(false)
    elseif realyawdrop == 4 then
        realyaw:set(6)
        realoffset:set(adjustYawOffset(180 + additional_yaw_angle))
        freestandcheck:set(true)
        freestandkey:set(true)
    end

    if fakeyawdrop == 0 then
        fakeyaw:set(6)
        yawOffsetSetting:set(customstaticfake:get())
    elseif fakeyawdrop == 1 then
        fakeyaw:set(5)
        fakespinspeed:set(spinspeed:get())
    elseif fakeyawdrop == 2 then
        fakeyaw:set(7)
    elseif fakeyawdrop == 3 then
        fakeyaw:set(6)
        sethvhyaw()
    end
end

local function main()
    local current_yawdropdown = yawdropdown:get()
    local current_customyawdropdown = customyawdropdown:get()
    local dropdown = yawdropdown:get()

    actualCycle() 
    setvisibility(dropdown == 2)

    if current_yawdropdown ~= previous_yawdropdown or current_customyawdropdown ~= previous_customyawdropdown then
        additional_yaw_angle = 0
        previous_yawdropdown = current_yawdropdown
        previous_customyawdropdown = current_customyawdropdown
    end

    if client.is_alive() and antiaimEnabled:get() then
        if dropdown == 0 then
            setlegitaa()
        elseif dropdown == 1 then
            sethvhpitch()
            sethvhyaw()
        elseif dropdown == 2 then
            setotheraa()
        end
    end
end

callbacks.register("paint", main)