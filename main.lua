-- Sample code is MIT licensed, see http://www.coronalabs.com/links/code/license
-- Copyright (C) 2017 Yoger Games AB. All Rights Reserved.

------------------------------------------------------------

-- Require plugin
local mixpanel = require "plugin.mixpanel"
local mp_properties

local t = os.date( '*t' )

-------------------------------------------------------------------------------
-- Callback
-------------------------------------------------------------------------------
local function callback(event)
    print("Callback received for event id " .. tostring(event.responseId))
    print("responseType: " .. tostring(event.responseType))
    print("isError: " .. tostring(event.isError))
    print("responseMsg: " .. tostring(event.responseMsg))
end

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
test_project:track("New session")

-------------------------------------------------------------------------------
-- Tracking event with properties
-------------------------------------------------------------------------------
mp_properties = mixpanel.properties.new()
mp_properties:insert(
    {
        Source = "Example app"
    }
)
test_project:track("Another event", mp_properties )

-------------------------------------------------------------------------------
-- Setting default properties for tracking events
-------------------------------------------------------------------------------
test_project:register_track_properties(
    {
        Platform = system.getInfo("platform"),
        ["App name"] = system.getInfo("appName"),
        ["App version"] = system.getInfo("appVersionString"),
        ["Corona version"] = system.getInfo("build")
    }
)
test_project:track("Online")

-------------------------------------------------------------------------------
-- User profile update using set operation
-------------------------------------------------------------------------------
mp_properties = mixpanel.properties.new()
mp_properties:set({["All levels completed"] = true})
test_project:engage(mp_properties)

-------------------------------------------------------------------------------
-- Setting default set-properties for profile updates
-------------------------------------------------------------------------------
mp_properties = mixpanel.properties.new()
mp_properties:set({ ["Has rated game"] = true})

test_project:register_super_properties({version = 10, category = "puzzle", platform = "Android"})
test_project:engage(mp_properties)

-------------------------------------------------------------------------------
-- Setting default set-once-properties for profile updates
-------------------------------------------------------------------------------
mp_properties = mixpanel.properties.new()
mp_properties:set({ ["Has signed up"] = true, ["Purchased items"] = {"item 0", "item 1"}})

test_project:register_super_properties_once({["Signup platform"] = "Android"})
test_project:engage(mp_properties)

-------------------------------------------------------------------------------
-- Setting Mixpanel special user properties
-------------------------------------------------------------------------------
mp_properties = mixpanel.properties.new()
mp_properties:set_first_name("John")
mp_properties:set_last_name("Doe")
mp_properties:set_name("John Doe")
mp_properties:set_created(t)
mp_properties:set_email("hello@example.com")
mp_properties:set_phone("+4423842399")
test_project:engage(mp_properties)
second_project:engage(mp_properties)
-------------------------------------------------------------------------------
-- User profile update using set_once operation
-------------------------------------------------------------------------------
mp_properties = mixpanel.properties.new()

local set_once_properties = {
    ["First login time"] = mixpanel.properties.convert_to_mixpanel_time(t)
}
mp_properties:set_once(set_once_properties)

test_project:engage(mp_properties)

-------------------------------------------------------------------------------
-- User profile update using add operation
-------------------------------------------------------------------------------
mp_properties = mixpanel.properties.new()

local add_properties = {
    ["Money spent"] = 1.23,
    ["Number of sessions"] = 1
}
mp_properties:add(add_properties)

test_project:engage(mp_properties)

-------------------------------------------------------------------------------
-- User profile update using append operation
-------------------------------------------------------------------------------
mp_properties = mixpanel.properties.new()

local append_properties = {
    Achievements = "Early adopter"
}
mp_properties:append(append_properties)

test_project:engage(mp_properties)

-------------------------------------------------------------------------------
-- User profile update using union operation
-------------------------------------------------------------------------------
mp_properties = mixpanel.properties.new()

local union_properties = {}
union_properties[1] = "item 0"
union_properties[2] = "item 2"
union_properties[3] = "item 3"

mp_properties:union( {["Purchased items"] = union_properties})

test_project:engage(mp_properties)

-------------------------------------------------------------------------------
-- User profile update using remove operation
-------------------------------------------------------------------------------
mp_properties = mixpanel.properties.new()
mp_properties:remove( {["Purchased items"] = "item 1"})
test_project:engage(mp_properties)

-------------------------------------------------------------------------------
-- User profile update using unset operation
-------------------------------------------------------------------------------
mp_properties = mixpanel.properties.new()

local unset_properties = {}
table.insert(unset_properties, "Achievements")

mp_properties:unset(unset_properties)
test_project:engage(mp_properties)

-------------------------------------------------------------------------------
-- User profile update using delete operation
-------------------------------------------------------------------------------
mp_properties = mixpanel.properties.new()
mp_properties:delete()
second_project:engage(mp_properties)