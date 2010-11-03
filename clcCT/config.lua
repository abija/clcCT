local modName, mod = ...

mod.mins = {
	energize = 1000,
}

mod.blacklist = {
	-- paladin - retribution
	-- Seal of Truth and Censure
	[42463] = true,
	[31803] = true, 
	[20424] = true,	-- Seals of Command
	[25742] = true,	-- Seal of Righteousness
	[20170] = true, -- Seal of Justice
	[85285] = true, -- Rebuke
}

mod.mergelist = {
	[81297] = true, -- consecration
	[53385] = true, -- divine storm
	[2812] = true, 	-- holt wrath
}

mod.config = {
	verbose = true,
	throttleMerge = 0.3,
	outgoing = {
		x = 0, y = -125,
		distance = 50,
		duration = 1.3,
		fontFile = [[Fonts\ARIALN.TTF]],
		fontSize = 20,
		fontFlags = "OUTLINE",
		iconSize = 18,
		iconPoint = "RIGHT",
		iconRelativePoint = "LEFT",
		iconX = -3, 
		iconY = 0,
		delay = 0.3,
	},
	incoming = {
		x = 0, y = -230,
		distance = -30,
		duration = 1,
		fontFile = [[Fonts\ARIALN.TTF]],
		fontSize = 20,
		fontFlags = "",
		iconSize = 18,
		iconPoint = "RIGHT",
		iconRelativePoint = "LEFT",
		iconX = -3, 
		iconY = 0,
		delay = 0.3,
	},
}

--[[
local testconsts = {
"COMBATLOG_OBJECT_TYPE_MASK",
"COMBATLOG_OBJECT_TYPE_OBJECT",
"COMBATLOG_OBJECT_TYPE_GUARDIAN",
"COMBATLOG_OBJECT_TYPE_PET",
"COMBATLOG_OBJECT_TYPE_NPC",
"COMBATLOG_OBJECT_TYPE_PLAYER",
"COMBATLOG_OBJECT_CONTROL_MASK",
"COMBATLOG_OBJECT_CONTROL_NPC",
"COMBATLOG_OBJECT_CONTROL_PLAYER",
"COMBATLOG_OBJECT_REACTION_MASK",
"COMBATLOG_OBJECT_REACTION_HOSTILE",
"COMBATLOG_OBJECT_REACTION_NEUTRAL",
"COMBATLOG_OBJECT_REACTION_FRIENDLY",
"COMBATLOG_OBJECT_AFFILIATION_MASK",
"COMBATLOG_OBJECT_AFFILIATION_OUTSIDER",
"COMBATLOG_OBJECT_AFFILIATION_RAID",
"COMBATLOG_OBJECT_AFFILIATION_PARTY",
"COMBATLOG_OBJECT_AFFILIATION_MINE",
"COMBATLOG_OBJECT_SPECIAL_MASK",
"COMBATLOG_OBJECT_NONE",
"COMBATLOG_OBJECT_RAIDTARGET8",
"COMBATLOG_OBJECT_RAIDTARGET7",
"COMBATLOG_OBJECT_RAIDTARGET6",
"COMBATLOG_OBJECT_RAIDTARGET5",
"COMBATLOG_OBJECT_RAIDTARGET4",
"COMBATLOG_OBJECT_RAIDTARGET3",
"COMBATLOG_OBJECT_RAIDTARGET2",
"COMBATLOG_OBJECT_RAIDTARGET1",
"COMBATLOG_OBJECT_MAINASSIST",
"COMBATLOG_OBJECT_MAINTANK",
"COMBATLOG_OBJECT_FOCUS",
"COMBATLOG_OBJECT_TARGET",
}
local test = 4369
for k, v in ipairs(testconsts) do
	if bit.band(8465, _G[v]) > 0 then
		print(v)
	end
end

--]]