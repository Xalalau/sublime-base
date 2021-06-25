-- Start kill
local function Kill()
    local curChar = NanosWorld:GetLocalPlayer():GetControlledCharacter()

    if curChar and curChar:GetHealth() >= 0 then
        Events:CallRemote("LL_Kill", {})
    end
end

-- Start unkill
local function Unkill()
    local curChar = NanosWorld:GetLocalPlayer():GetControlledCharacter()

    if curChar and curChar:GetHealth() <= 0 then
        Events:CallRemote("LL_Unkill", {})
    end
end

-- Setup kill and unkill events
Client:Subscribe("MouseDown", Unkill)

Client:Subscribe("KeyPress", function(key_name)
    local player = NanosWorld:GetLocalPlayer()
    local char = player:GetControlledCharacter()

    if not char or player:GetValue("LL_KillCoolDown") then return end

    if key_name == "P" then
        Kill()
    else
        Unkill()
    end
end)

-- Reconnect unkilled player to Sandbox
Events:Subscribe("LL_SetSandboxChar", function()
    local curChar = NanosWorld:GetLocalPlayer():GetControlledCharacter()
    Package:Call("Sandbox", "UpdateLocalCharacter", { curChar })
end)

-- Add console command
ConCommand:Add("kill", function() Kill() end)