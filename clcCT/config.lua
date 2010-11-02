local modName, mod = ...

mod.mins = {
	energize = 1000,
}

mod.blacklist = {
	-- paladin - retribution
	[42463] = true,	-- Seal of Truth
	[20424] = true,	-- Seals of Command
	[25742] = true,	-- Seal of Righteousness
	[85285] = true, -- Rebuke
}

mod.config = {
	outgoing = {
		x = 0, y = -125,
		distance = 40,
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
	incoming = {
		x = 0, y = -230,
		distance = -30,
		duration = 0.7,
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

