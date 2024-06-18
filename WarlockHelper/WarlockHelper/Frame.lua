-- Author      : markc
-- Create Date : 6/5/2024 9:00:35 AM


local function IsDemonArmorActive()
    local name = AuraUtil.FindAuraByName("Demon Armor", "player")

    if name == nil then
        return false
    else
        return true
    end
end

function SetupMacros()	
    ImmolateButton:SetAttribute("type1", "macro")
    ImmolateButton:SetAttribute("macrotext1", [[/petattack
/cast Immolate]])

    IncinerateButton:SetAttribute("type1", "macro")
    IncinerateButton:SetAttribute("macrotext1", [[/petattack
/cast Incinerate]])

    ConflagButton:SetAttribute("type1", "macro")
    ConflagButton:SetAttribute("macrotext1", [[/petattack
/cast Conflagrate]])

    ChaosBoltButton:SetAttribute("type1", "macro")
    ChaosBoltButton:SetAttribute("macrotext1", [[/petattack
/cast Chaos Bolt]])
end







--[[
local function UpdateDemonArmorHighlight()
    if not IsDemonArmorActive() then
        DemonArmorButton:SetNormalTexture("Interface\\Buttons\\UI-Panel-Button-Disabled")
    else
        DemonArmorButton:SetNormalTexture("Interface\\Buttons\\UI-Panel-Button-Up")
    end
end

DemonArmorButton:SetScript("OnEvent", function(self, event, ...)
    if event == "PLAYER_ENTERING_WORLD" then
        UpdateDemonArmorHighlight()
    end
end)

DemonArmorButton:RegisterEvent("PLAYER_ENTERING_WORLD")
--]]

function MainFrame_OnLoad()
	print("WarlockHelper loading")

    SetupMacros()

	print("WarlockHelper loaded")
    print("isDemonArmorActive " .. tostring(IsDemonArmorActive()))

end

function Button2_OnClick()
    local isDemonArmorActive = IsDemonArmorActive()
    if isDemonArmorActive then
        print("Demon Armor is active")
	else
        print("Demon Armor is not active")
    end   
end

local playerGUID = UnitGUID("player")
local MSG_DEBUG_SPELL_EVENT = "subevent %s spellID %d"

local EventFrame = CreateFrame("Frame")
EventFrame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
EventFrame:SetScript("OnEvent", function(self, event)
	local _, subevent, _, sourceGUID, _, _, _, _, destName = CombatLogGetCurrentEventInfo()
	local spellId

    if sourceGUID == playerGUID then
        if subevent == "SPELL_CAST_SUCCESS" or subevent == "SPELL_MISSED" then
	   	    spellId, _, _, amount, _, _, _, _, _, critical = select(12, CombatLogGetCurrentEventInfo())

            -- print(MSG_DEBUG_SPELL_EVENT:format(subevent, spellId))
            if spellId then
                -- Chaos Bolt
                if spellId == 403629 then
                    ChaosBoltCooldown:SetCooldown(GetTime(),12)
                -- Conflag
                elseif spellId == 18930 then
                    ConflagCooldown:SetCooldown(GetTime(),10)
                -- Immolate
                elseif spellId == 11667 then
                    print("Immolate")
				end
	        end
        end

	end

end)


SLASH_WARLOCKHELPER_WH1 = "/wh"
SlashCmdList["WARLOCKHELPER_WH"] = function(msg, editBox)
    -- Show the main window
    MainFrame:Show()
end

