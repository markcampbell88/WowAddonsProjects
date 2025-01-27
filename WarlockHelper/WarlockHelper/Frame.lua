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

function SetupMacrosDetail(assistTarget)

    local macroString = [[/assist %s
/petattack
/cast %s]]
    local immolateString = ""
    local incinerateString = ""
    local conflagString = ""
    local chaosBoltString = ""
    local shadowBoltString = ""

    if assistTarget == "None" then
            macroString = [[/petattack
/cast %s]]
        immolateString = string.format(macroString, "Immolate")
        incinerateString = string.format(macroString, "Incinerate")
        conflagString = string.format(macroString, "Conflagrate")
        chaosBoltString = string.format(macroString, "Chaos Bolt")
        shadowBoltString = string.format(macroString, "Shadow Bolt")
    else
        immolateString = string.format(macroString, assistTarget, "Immolate")
        incinerateString = string.format(macroString, assistTarget, "Incinerate")
        conflagString = string.format(macroString, assistTarget, "Conflagrate")
        chaosBoltString = string.format(macroString, assistTarget, "Chaos Bolt")
        shadowBoltString = string.format(macroString, assistTarget, "Shadow Bolt")
	end

    ImmolateButton:SetAttribute("type1", "macro")
    ImmolateButton:SetAttribute("macrotext1", immolateString)

    IncinerateButton:SetAttribute("type1", "macro")
    IncinerateButton:SetAttribute("macrotext1", incinerateString)

    ConflagButton:SetAttribute("type1", "macro")
    ConflagButton:SetAttribute("macrotext1", conflagString)

    ChaosBoltButton:SetAttribute("type1", "macro")
    ChaosBoltButton:SetAttribute("macrotext1", chaosBoltString)

    ShadowBoltButton:SetAttribute("type1", "macro")
    ShadowBoltButton:SetAttribute("macrotext1", shadowBoltString)
end

function SetupMacros()
    SetupMacrosDetail("None")
end

function SetupRuneSwapMacros()
    local SBVRunemacroString = [[/run if C_Engraving.IsRuneEquipped(48352) then C_Engraving.CastRune(48345) end
/use 10
/click StaticPopup1Button1]]

    local CBRunemacroString = [[/run if C_Engraving.IsRuneEquipped(48345) then C_Engraving.CastRune(48352) end
/use 10
/click StaticPopup1Button1]]

    ChaosBoltRuneButton:SetAttribute("type1", "macro")
    ChaosBoltRuneButton:SetAttribute("macrotext1", CBRunemacroString)

    ShadowBoltVolleyRuneButton:SetAttribute("type1", "macro")
    ShadowBoltVolleyRuneButton:SetAttribute("macrotext1", SBVRunemacroString)

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
    SetupRuneSwapMacros()

	print("WarlockHelper loaded")
    -- print("isDemonArmorActive " .. tostring(IsDemonArmorActive()))

end

function Button2_OnClick()
    local isDemonArmorActive = IsDemonArmorActive()
    if isDemonArmorActive then
        print("Demon Armor is active")
	else
        print("Demon Armor is not active")
    end   
end


function ShowSummonButton_OnClick()
    if SummonSpellFrame:IsShown() then
	else
        SummonSpellFrame:Show()
        BuffSpellFrame:Hide()
        RuneSpellFrame:Hide()
	end
		
end

function ShowBuffButton_OnClick()
    if BuffSpellFrame:IsShown() then
	else
        BuffSpellFrame:Show()
        SummonSpellFrame:Hide()
        RuneSpellFrame:Hide()
	end 
end

function ShowRuneButton_OnClick()
    if RuneSpellFrame:IsShown() then
	else
        BuffSpellFrame:Hide()
        SummonSpellFrame:Hide()
        RuneSpellFrame:Show()
	end 
end


function getPartyRaidList()
    local plist={}
    if IsInRaid() then
        for i=1,40 do
            if (UnitName('raid'..i)) then
                tinsert(plist,(UnitName('raid'..i)))
            end
        end
    elseif IsInGroup() then
        for i=1,4 do
            if (UnitName('party'..i)) then
                tinsert(plist,(UnitName('party'..i)))
            end
        end
    end
    if debugOn then
        for i=1,#plist do
            print("getPartyRaidList " .. plist[i])
	    end
	end
    return plist
end

function PartyTargetSelected(self, arg1, arg2, checked)
    if debugOn then
        print("PartyTargetSelected")
        print(self)
        print(self.value)
        print(arg1)
        print(arg2)
        print(checked)
	end
    UIDropDownMenu_SetSelectedName(TargetDropDownMenu, self.value, useValue)

    -- Setup the macros with the name
    SetupMacrosDetail(self.value)
end

function TargetDropDownMenu_OnLoad()
    info            = {};
    info.text       = "Item Called ";
    info.value      = "OptionVariable";
 
    
	local partyList = getPartyRaidList()
    local info = UIDropDownMenu_CreateInfo();
    info.text = "None"
    info.value = "None"
    info.func = PartyTargetSelected
    UIDropDownMenu_AddButton(info);
    for i=1,#partyList do
        if debugOn then
            print("Party Member: " .. partyList[i])
		end

        info.text = partyList[i]
        info.value = partyList[i]
        info.func = PartyTargetSelected
        UIDropDownMenu_AddButton(info);
	end
	
end


 