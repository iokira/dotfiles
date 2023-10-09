local core = {}

local function setValue(path)
    local config = require(path)
    for name, value in pairs(config) do
        core[name] = value
    end
end

setValue("lua.core.start")
setValue("lua.core.font")
setValue("lua.core.window")
setValue("lua.keymap")

return core
