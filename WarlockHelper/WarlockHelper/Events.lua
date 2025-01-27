

local EventFrame, events = CreateFrame("Frame"), {};

local playerGUID = UnitGUID("player")
local MSG_DEBUG_SPELL_EVENT = "subevent %s spellID %d"
local MSG_DEBUG_UNIT_AURA = "UNIT_AURA unit: %s"
local MSG_DEBUG_PlayerAuras = "PlayerAuras Demon/Grimoire "
local debugOn = false


function events:PLAYER_ENTERING_WORLD(...)
    if debugOn then
       print("PLAYER_ENTERING_WORLD event")
	end
end

function events:PLAYER_LEAVING_WORLD(...)
    if debugOn then
        print("PLAYER_LEAVING_WORLD event")
	end

end

local DemonArmorSpellId = 11734
local GrimoireOfSynergySpellId = 426301
local DemonArmorActive = false
local GrimoireOfSynergyActive = false

local function dumpAuras()
    if debugOn then
        print(MSG_DEBUG_PlayerAuras,DemonArmorActive,GrimoireOfSynergyActive)
	end
end

local function UpdatePlayerAuras()
    local buffNumber = 1
    local name, _, _, _, duration, expirationTime, _, _, _,spellId = UnitAura("player", buffNumber, "HELPFUL") 
    local newDemonActive = false
    local newGrimoireActive = false
    while (name) do
        if spellId == DemonArmorSpellId then
		    newDemonActive = true
        end
        if spellId == GrimoireOfSynergySpellId then
		    newGrimoireActive = true
        end
        buffNumber = buffNumber + 1
        name, _, _, _, duration, expirationTime, _, _, _,spellId = UnitAura("player", buffNumber, "HELPFUL") 
	end
    DemonArmorActive = newDemonActive
    GrimoireOfSynergyActive = newGrimoireActive
end

local function UpdatePlayerAurasFull()
    UpdatePlayerAuras()
end
local function UpdatePlayerAurasIncremental(unitAuraUpdateInfo)
    UpdatePlayerAuras()
end

function events:UNIT_AURA(...)
    local args = {...}  -- Store all arguments in a table named 'args'
    local unit = args[1]
    local unitAuraUpdateInfo = args[2]

    if debugOn then
        print(MSG_DEBUG_UNIT_AURA:format(unit))
	end

    if unit ~= "player" then
        return
    end

    if unitAuraUpdateInfo == nil or unitAuraUpdateInfo.isFullUpdate then
        UpdatePlayerAurasFull()
    else
        UpdatePlayerAurasIncremental(unitAuraUpdateInfo)
    end

    dumpAuras()
end




function events:GROUP_ROSTER_UPDATE(...)
    if debugOn then
        print("GROUP_ROSTER_UPDATE event")
	end

    -- Get the list of people in the group
    local partyList={}
    partyList = getPartyRaidList()

    -- Save show is currently selected
    local selectedID = UIDropDownMenu_GetSelectedID(TargetDropDownMenu)
    if debugOn then
        print("TargetDropDownMenu Selected = %s",selectedID)
	end

    -- Add them to the dropdown menu
    TargetDropDownMenu_OnLoad()
    -- Redo the current selection (if possible)
end


function events:RAID_ROSTER_UPDATE(...)
    if debugOn then
        print("RAID_ROSTER_UPDATE event")
	end
	
end

function events:COMBAT_LOG_EVENT_UNFILTERED(...)

	local _, subevent, _, sourceGUID, _, _, _, _, destName = CombatLogGetCurrentEventInfo()
	local spellId

    if sourceGUID == playerGUID then
        if subevent == "SPELL_CAST_SUCCESS" or subevent == "SPELL_MISSED" then
	   	    spellId, _, _, amount, _, _, _, _, _, critical = select(12, CombatLogGetCurrentEventInfo())

            if debugOn then
                print(MSG_DEBUG_SPELL_EVENT:format(subevent, spellId))
			end
			
            if spellId then
                -- Chaos Bolt
                if spellId == 403629 then
                    ChaosBoltCooldown:SetCooldown(GetTime(),12)
                -- Conflag
                elseif spellId == 18930 then
                    ConflagCooldown:SetCooldown(GetTime(),10)
                -- Immolate
                elseif spellId == 11667 then
                    if debugOn then
                        print("Immolate")
					end
				end
	        end
        end

	end
end


EventFrame:SetScript("OnEvent", function(self, event, ...)
  events[event](self, ...); -- call one of the functions above
end);
for k, v in pairs(events) do
  EventFrame:RegisterEvent(k); -- Register all events for which handlers have been defined
end