-- Block kills/Unkills for 1.3 second
local function SetCooldown(curChar)
    local player = curChar:GetPlayer()

    if not player then return end

    player:SetValue("LL_KillCoolDown", true)

    Timerx.Simple(1.3, function()
        player:SetValue("LL_KillCoolDown", false)
    end)
end

-- Unkill player
local function Unkill(player)
    if not player:GetValue("LL_KillCoolDown") then
        Package.Call("sandbox", "SpawnPlayer",  player)
        Events.CallRemote("LL_SetSandboxChar", player)
    end
end

-- Kill player
local function Kill(player)
    -- Get the current char 
    local killedChar = player:GetControlledCharacter()

    -- Check if the current char is dead or if we are cooling down
    if killedChar:GetHealth() <= 0 or player:GetValue("LL_KillCoolDown") then return end

    -- Reset kill cooldown and our current char table entry
    SetCooldown(killedChar)

    -- Kill the current char
    killedChar:ApplyDamage(killedChar:GetHealth(), "", DamageType.Unknown, Vector(0, 0 ,0), player)

    -- Check if the player is still dead after 4.7 seconds (Sandbox uses 5s), respawn him and delete the killed char
    Timerx.Simple(4.8, function()
        local curChar = player:GetControlledCharacter()

        if curChar == killedChar then
            killedChar:Respawn()   
        else
            killedChar:Destroy()
        end
    end)
end

-- Hook kill
Events.Subscribe("LL_Unkill", Unkill)

-- Hook Unkill
Events.Subscribe("LL_Kill", Kill)

-- Deal with normal deaths
Character.Subscribe("Death", SetCooldown)
