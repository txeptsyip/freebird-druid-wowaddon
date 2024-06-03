FreeBirdSavedMusic = "Interface\\AddOns\\FreeBird\\freebird.mp3"

local function freeBird_Loop()
    if IsFalling() then
        C_Timer.After(0.5, freeBird_Loop)
    else
        StopMusic()
    end
end

local AuraInstanceID
local function testFalling()
    if IsFalling() then
        PlayMusic(FreeBirdSavedMusic)
        freeBird_Loop()
    end
end

local function freeBird_onEvent(self, event, unit, info)
    if info.addedAuras then
        for _, v in pairs(info.addedAuras) do
            if v.spellId == 40120 or v.spellId == 33943 then -- cata swift flight form
                AuraInstanceID = v.auraInstanceID
                StopMusic()
                break
            end
        end
    end
    if info.removedAuraInstanceIDs then
        for _, v in pairs(info.removedAuraInstanceIDs) do
            if v == AuraInstanceID then
                AuraInstanceID = nil
                RunNextFrame(testFalling)
                break
            end
        end
    end
end

SLASH_FREEBIRD1 = "/fb1"
SlashCmdList["FREEBIRD"] = function(msg)
    if msg == "original" then
       FreeBirdSavedMusic = "Interface\\AddOns\\FreeBird\\freebird.mp3"
    elseif msg == "harmonica" then
       FreeBirdSavedMusic = "Interface\\AddOns\\FreeBird\\FreeBirdHarmonica.mp3"
    else
        print("/fb1 original, /fb1 harmonica")
    end
end

local f = CreateFrame("Frame")
f:RegisterUnitEvent("UNIT_AURA", "player")
f:SetScript("OnEvent", freeBird_onEvent)
