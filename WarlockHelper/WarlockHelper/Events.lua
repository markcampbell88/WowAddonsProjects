

local EventFrame, events = CreateFrame("Frame"), {};

local playerGUID = UnitGUID("player")
local MSG_DEBUG_SPELL_EVENT = "subevent %s spellID %d"
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