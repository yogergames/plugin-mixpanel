--
-- Mixpanel Example project
--
-- Sample code is MIT licensed
-- Copyright (C) 2017 Yoger Games AB. All Rights Reserved.
--
------------------------------------------------------------

-- Require plugin
local mixpanel = require "plugin.mixpanel"
local idMap = {}
local t = os.date( '*t' )

-------------------------------------------------------------------------------
-- Callback
-------------------------------------------------------------------------------
local function callback(event)
    print("Callback received for event id " .. tostring(event.responseId) .. " (" .. tostring(idMap[event.responseId]) .. ")")
    print("responseType: " .. tostring(event.responseType))
    print("isError: " .. tostring(event.isError))
    print("responseMsg: " .. tostring(event.responseMsg))
end

-------------------------------------------------------------------------------
-- Create button
-------------------------------------------------------------------------------
local widget = require( "widget" )

local function createButton(label, buttonCallback)
    local button = widget.newButton(
        {
            label = label,
            onEvent = function(event)
                if event.phase == "began" then
                    buttonCallback()
                end
            end,
            shape = "roundedRect",
            width = display.actualContentWidth / 3.2,
            height = display.actualContentWidth / 8,
            cornerRadius = 2,
            fillColor = { default={1,1,1,1}, over={1,0.8,0.11,1} },
            strokeColor = { default={1,0.8,0.3,1}, over={1,0.8,0.3,1} },
            strokeWidth = 2
        }
    )
    button.anchorX, button.anchorY = 0.5, 0.5
    return button
end

local columns = 2
local rows = 8
-------------------------------------------------------------------------------
-- Initialization
-------------------------------------------------------------------------------
local options = {
    token = "<REPLACE WITH A PROJECT TOKEN>",
    name = "test"
}
local test_project = mixpanel.init(options)

local options = {
    token = "<REPLACE WITH A PROJECT TOKEN>",
    name = "second_project"
}
mixpanel.init(options)
local second_project = mixpanel.getInstance("second_project")

-------------------------------------------------------------------------------
-- Set user identify for each project
-------------------------------------------------------------------------------
test_project:identify(system.getInfo("deviceID"))
second_project:identify(system.getInfo("deviceID"))

-------------------------------------------------------------------------------
-- Simple tracking event
-------------------------------------------------------------------------------
local function onExample1()
    local id = test_project:track("New session", nil, nil, callback)
    if (id) then
        print("onExample1 (track) sent successfully. id: " .. tostring(id))
    else
        print("onExample1 (track) couldn't be sent")
    end
    idMap[id] = "onExample1"
end
local exampleButton1 = createButton("onExample1", onExample1)
exampleButton1.x = display.actualContentWidth / (columns+1)
exampleButton1.y = display.actualContentHeight / (rows+1)

-------------------------------------------------------------------------------
-- Tracking event with properties
-------------------------------------------------------------------------------
local function onExample2()
    local mp_properties = mixpanel.properties.new()
    mp_properties:insert(
        {
            Source = "Example app"
        }
    )
    local id = test_project:track("Another event", mp_properties, nil, callback )
    if (id) then
        print("onExample2 (track) sent successfully. id: " .. tostring(id))
    else
        print("onExample2 (track) couldn't be sent")
    end

    idMap[id] = "onExample2"
end
local exampleButton2 = createButton("onExample2", onExample2)
exampleButton2.x = display.actualContentWidth * 2 / (columns+1)
exampleButton2.y = display.actualContentHeight / (rows+1)

-------------------------------------------------------------------------------
-- Setting default properties for tracking events
-------------------------------------------------------------------------------
local function onExample3()
    test_project:register_track_properties(
        {
            Platform = system.getInfo("platform"),
            ["App name"] = system.getInfo("appName"),
            ["App version"] = system.getInfo("appVersionString"),
            ["Corona version"] = system.getInfo("build")
        }
    )
    local id = test_project:track("Online", nil, nil, callback)
    if (id) then
        print("onExample3 (track) sent successfully. id: " .. tostring(id))
    else
        print("onExample3 (track) couldn't be sent")
    end

    idMap[id] = "onExample3"
end
local exampleButton3 = createButton("onExample3", onExample3)
exampleButton3.x = display.actualContentWidth * 1 / (columns+1)
exampleButton3.y = display.actualContentHeight * 2 / (rows+1)

-------------------------------------------------------------------------------
-- User profile update using set operation
-------------------------------------------------------------------------------
local function onExample4()
    local mp_properties = mixpanel.properties.new()
    mp_properties:set({["All levels completed"] = true})
    local id = test_project:engage(mp_properties, nil, callback)
    if (id) then
        print("onExample4 (engage) sent successfully. id: " .. tostring(id))
    else
        print("onExample4 (engage) couldn't be sent")
    end

    idMap[id] = "onExample4"
end

local exampleButton4 = createButton("onExample4", onExample4)
exampleButton4.x = display.actualContentWidth * 2 / (columns+1)
exampleButton4.y = display.actualContentHeight * 2 / (rows+1)

-------------------------------------------------------------------------------
-- Setting default set-properties for profile updates
-------------------------------------------------------------------------------
local function onExample5()
    local mp_properties = mixpanel.properties.new()
    mp_properties:set({ ["Has rated game"] = true})

    test_project:register_super_properties({version = 10, category = "puzzle", platform = "Android"})
    local id = test_project:engage(mp_properties, nil, callback)
    if (id) then
        print("onExample5 (engage) sent successfully. id: " .. tostring(id))
    else
        print("onExample5 (engage) couldn't be sent")
    end

    idMap[id] = "onExample5"
end

local exampleButton5 = createButton("onExample5", onExample5)
exampleButton5.x = display.actualContentWidth * 1 / (columns+1)
exampleButton5.y = display.actualContentHeight * 3 / (rows+1)

-------------------------------------------------------------------------------
-- Setting default set-once-properties for profile updates
-------------------------------------------------------------------------------
local function onExample6()
    local mp_properties = mixpanel.properties.new()
    mp_properties:set({ ["Has signed up"] = true })

    test_project:register_super_properties_once({["Signup platform"] = "Android"})
    local id = test_project:engage(mp_properties, nil, callback)
    if (id) then
        print("onExample6 (engage) sent successfully. id: " .. tostring(id))
    else
        print("onExample6 (engage) couldn't be sent")
    end

    idMap[id] = "onExample6"
end

local exampleButton6 = createButton("onExample6", onExample6)
exampleButton6.x = display.actualContentWidth * 2 / (columns+1)
exampleButton6.y = display.actualContentHeight * 3 / (rows+1)

-------------------------------------------------------------------------------
-- Setting Mixpanel special user properties
-------------------------------------------------------------------------------
local function onExample7()
    local mp_properties = mixpanel.properties.new()
    mp_properties:set_first_name("John")
    mp_properties:set_last_name("Doe")
    mp_properties:set_name("John Doe")
    mp_properties:set_created(t)
    mp_properties:set_email("hello@example.com")
    mp_properties:set_phone("+4423842399")
    local id = test_project:engage(mp_properties, nil, callback)
    if (id) then
        print("onExample7 (engage) sent successfully. id: " .. tostring(id))
    else
        print("onExample7 (engage) couldn't be sent")
    end

    idMap[id] = "onExample7"
end

local exampleButton7 = createButton("onExample7", onExample7)
exampleButton7.x = display.actualContentWidth * 1 / (columns+1)
exampleButton7.y = display.actualContentHeight * 4 / (rows+1)

-------------------------------------------------------------------------------
-- User profile update using set_once operation
-------------------------------------------------------------------------------
local function onExample8()
    local mp_properties = mixpanel.properties.new()

    local set_once_properties = {
        ["First login time"] = mixpanel.properties.convert_to_mixpanel_time(t)
    }
    mp_properties:set_once(set_once_properties)

    local id = test_project:engage(mp_properties, nil, callback)
    if (id) then
        print("onExample8 (engage) sent successfully. id: " .. tostring(id))
    else
        print("onExample8 (engage) couldn't be sent")
    end

    idMap[id] = "onExample8"
end
local exampleButton8 = createButton("onExample8", onExample8)
exampleButton8.x = display.actualContentWidth * 2 / (columns+1)
exampleButton8.y = display.actualContentHeight * 4 / (rows+1)

-------------------------------------------------------------------------------
-- User profile update using add operation
-------------------------------------------------------------------------------
local function onExample9()
    local mp_properties = mixpanel.properties.new()

    local add_properties = {
        ["Money spent"] = 1.23,
        ["Number of sessions"] = 1
    }
    mp_properties:add(add_properties)

    local id = test_project:engage(mp_properties, nil, callback)
    if (id) then
        print("onExample9 (engage) sent successfully. id: " .. tostring(id))
    else
        print("onExample9 (engage) couldn't be sent")
    end

    idMap[id] = "onExample9"
end

local exampleButton9 = createButton("onExample9", onExample9)
exampleButton9.x = display.actualContentWidth * 1 / (columns+1)
exampleButton9.y = display.actualContentHeight * 5 / (rows+1)

-------------------------------------------------------------------------------
-- User profile update using append operation
-------------------------------------------------------------------------------
local function onExample10()
    local mp_properties = mixpanel.properties.new()

    local append_properties = {
        Achievements = "Early adopter"
    }
    mp_properties:append(append_properties)

    local id = test_project:engage(mp_properties, nil, callback)
    if (id) then
        print("onExample10 (engage) sent successfully. id: " .. tostring(id))
    else
        print("onExample10 (engage) couldn't be sent")
    end

    idMap[id] = "onExample10"
end
local exampleButton10 = createButton("onExample10", onExample10)
exampleButton10.x = display.actualContentWidth * 2 / (columns+1)
exampleButton10.y = display.actualContentHeight * 5 / (rows+1)

-------------------------------------------------------------------------------
-- User profile update using union operation
-------------------------------------------------------------------------------
local function onExample11()
    local mp_properties = mixpanel.properties.new()

    local union_properties = {}
    union_properties[1] = "item 0"
    union_properties[2] = "item 2"
    union_properties[3] = "item 3"

    mp_properties:union( {["Purchased items"] = union_properties})

    local id = test_project:engage(mp_properties, nil, callback)
    if (id) then
        print("onExample11 (engage) sent successfully. id: " .. tostring(id))
    else
        print("onExample11 (engage) couldn't be sent")
    end

    idMap[id] = "onExample11"
end
local exampleButton11 = createButton("onExample11", onExample11)
exampleButton11.x = display.actualContentWidth * 1 / (columns+1)
exampleButton11.y = display.actualContentHeight * 6 / (rows+1)

-------------------------------------------------------------------------------
-- User profile update using remove operation
-------------------------------------------------------------------------------
local function onExample12()
    local mp_properties = mixpanel.properties.new()
    mp_properties:remove( {["Purchased items"] = "item 1"})
    local id = test_project:engage(mp_properties, nil, callback)
    if (id) then
        print("onExample12 (engage) sent successfully. id: " .. tostring(id))
    else
        print("onExample12 (engage) couldn't be sent")
    end

    idMap[id] = "onExample12"
end
local exampleButton12 = createButton("onExample12", onExample12)
exampleButton12.x = display.actualContentWidth * 2 / (columns+1)
exampleButton12.y = display.actualContentHeight * 6 / (rows+1)

-------------------------------------------------------------------------------
-- User profile update using unset operation
-------------------------------------------------------------------------------
local function onExample13()
    local mp_properties = mixpanel.properties.new()

    local unset_properties = {}
    table.insert(unset_properties, "Achievements")

    mp_properties:unset(unset_properties)
    local id = test_project:engage(mp_properties, nil, callback)
    if (id) then
        print("onExample13 (engage) sent successfully. id: " .. tostring(id))
    else
        print("onExample13 (engage) couldn't be sent")
    end

    idMap[id] = "onExample13"
end
local exampleButton13 = createButton("onExample13", onExample13)
exampleButton13.x = display.actualContentWidth * 1 / (columns+1)
exampleButton13.y = display.actualContentHeight * 7 / (rows+1)

-------------------------------------------------------------------------------
-- User profile update using delete operation
-------------------------------------------------------------------------------
local function onExample14()
    local mp_properties = mixpanel.properties.new()
    mp_properties:delete()
    local id = second_project:engage(mp_properties, nil, callback)
    if (id) then
        print("onExample14 (engage) sent successfully. id: " .. tostring(id))
    else
        print("onExample14 (engage) couldn't be sent")
    end

    idMap[id] = "onExample14"
end
local exampleButton14 = createButton("onExample14", onExample14)
exampleButton14.x = display.actualContentWidth * 2 / (columns+1)
exampleButton14.y = display.actualContentHeight * 7 / (rows+1)
