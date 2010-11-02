local modName, mod = ...


local format = string.format
local GetTime = GetTime

mod.output = {}
local AddText

-- defines
--------------------------------------------------------------------------------
local NUM_FONTSTRINGS = 10

local pname = UnitName("player")
local pguid = UnitGUID("player")
local petguid = UnitGUID("playerpet")
local _, _, texSwing = GetSpellInfo(20597)

-- SPELL_SCHOOL_STRINGS
local STRINGS_SPELL_SCHOOL = {
	ARCANE = STRING_SCHOOL_ARCANE,
	CHAOS = STRING_SCHOOL_CHAOS,
	CHROMATIC = STRING_SCHOOL_CHROMATIC,
	DIVINE = STRING_SCHOOL_DIVINE,
	ELEMENTAL = STRING_SCHOOL_ELEMENTAL,
	FIRE = STRING_SCHOOL_FIRE,
	FIRESTORM = STRING_SCHOOL_FIRESTORM,
	FLAMESTRIKE = STRING_SCHOOL_FLAMESTRIKE,
	FROST = STRING_SCHOOL_FROST,
	FROSTFIRE = STRING_SCHOOL_FROSTFIRE,
	FROSTSTORM = STRING_SCHOOL_FROSTSTORM,
	FROSTSTRIKE = STRING_SCHOOL_FROSTSTRIKE,
	HOLY = STRING_SCHOOL_HOLY,
	HOLYFIRE = STRING_SCHOOL_HOLYFIRE,
	HOLYFROST = STRING_SCHOOL_HOLYFROST,
	HOLYSTORM = STRING_SCHOOL_HOLYSTORM,
	HOLYSTRIKE = STRING_SCHOOL_HOLYSTRIKE,
	MAGIC = STRING_SCHOOL_MAGIC,
	NATURE = STRING_SCHOOL_NATURE,
	PHYSICAL = STRING_SCHOOL_PHYSICAL,
	SHADOW = STRING_SCHOOL_SHADOW,
	SHADOWFLAME = STRING_SCHOOL_SHADOWFLAME,
	SHADOWFROST = STRING_SCHOOL_SHADOWFROST,
	SHADOWHOLY = STRING_SCHOOL_SHADOWHOLY,
	SHADOWLIGHT = STRING_SCHOOL_SHADOWLIGHT,
	SHADOWSTORM = STRING_SCHOOL_SHADOWSTORM,
	SHADOWSTRIKE = STRING_SCHOOL_SHADOWSTRIKE,
	SPELLFIRE = STRING_SCHOOL_SPELLFIRE,
	SPELLFROST = STRING_SCHOOL_SPELLFROST,
	SPELLSHADOW = STRING_SCHOOL_SPELLSHADOW,
	SPELLSTORM = STRING_SCHOOL_SPELLSTORM,
	SPELLSTRIKE = STRING_SCHOOL_SPELLSTRIKE,
	STORMSTRIKE = STRING_SCHOOL_STORMSTRIKE,
	UNKNOWN = STRING_SCHOOL_UNKNOWN,
}
-- ENVIRONMENTAL DAMAGE STRINGS
local STRINGS_ENVIRONMENTAL_DAMAGE = {
	DROWNING 	= STRING_ENVIRONMENTAL_DAMAGE_DROWNING,
	FALLING		= STRING_ENVIRONMENTAL_DAMAGE_FALLING,
	FATIGUE 	= STRING_ENVIRONMENTAL_DAMAGE_FATIGUE,
	FIRE 			= STRING_ENVIRONMENTAL_DAMAGE_FIRE,
	LAVA		 	= STRING_ENVIRONMENTAL_DAMAGE_LAVA,
	SLIME 		= STRING_ENVIRONMENTAL_DAMAGE_SLIME,
}
-- POWER TYPE STRINGS
local STRINGS_POWER_TYPE = { MANA, RAGE, FOCUS, ENERGY, HAPPINESS, RUNES, RUNIC_POWER, SOUL_SHARDS, ENERGY, HOLY_POWER }
--------------------------------------------------------------------------------

local function DamageFormat(amount, overkill, school, resisted, blocked, absorbed, critical, glancing, crushing)
	local t = tostring(amount)
	-- if overkill then t = format("%s (o: %d)", t, overkill) end
	if resisted then t = format("%s (R: %d)", t, resisted) end
	if blocked then t = format("%s (B: %d)", t, blocked) end
	if absorbed then t = format("%s (A: %d)", t, absorbed) end
	-- if glancing then t = t .. " (glancing)" end
	if crushing then t = t .. " (crushing)" end
	
	if critical then t = format("*%s*", t) end
	
	return t
end

local function HealFormat(dest, amount, overheal, absorb, critical)
	local t = format("%s +%d", dest, amount - overheal - absorb)
	if overheal > 0 then t = format("%s (O: %d)", t, overheal) end
	if absorb > 0 then t = format("%s (A: %d)", t, absorb) end
	
	if critical then t = format("*%s*", t) end
	
	return t
end

-- event color strings
local ecs = {
	PET = "|cffff5500%s",
	SPELL_DAMAGE = "|cffffff00%s",
	SPELL_MISSED = "|cffffff00%s",
	SPELL_HEAL = "|cff00ff00%s",
}

-- event handlers
--------------------------------------------------------------------------------
local eh = {}
function eh.SWING_DAMAGE(source, dest, ...)
	return DamageFormat(...)
end
function eh.SWING_MISSED(source, dest, t, amount)
	t = _G[t]
	if amount then
		t = format("%s %d", t, amount)
	end
	return t
end

function eh.SPELL_DAMAGE(source, dest, id, name, school, amount, overkill, school, resisted, blocked, absorbed, critical, glancing, crushing)
	if not mod.blacklist[id] then
		local _, _, icon = GetSpellInfo(id)
		return DamageFormat(amount, overkill, school, resisted, blocked, absorbed, critical, glancing, crushing), icon
	end
end
eh.RANGE_DAMAGE = eh.SPELL_DAMAGE
eh.SPELL_PERIODIC_DAMAGE = eh.SPELL_DAMAGE
eh.SPELL_BUILDING_DAMAGE = eh.SPELL_DAMAGE
eh.DAMAGE_SHIELD = eh.SPELL_DAMAGE
eh.DAMAGE_SPLIT = eh.SPELL_DAMAGE

function eh.SPELL_MISSED(source, dest, id, name, school, t, amount)
	if not mod.blacklist[id] then
		local _, _, icon = GetSpellInfo(id)
		t = _G[t]
		if amount then
			t = format("%s %d", t, amount)
		end
		return t, icon
	end
end
eh.RANGE_MISSED = eh.SPELL_MISSED
eh.DAMAGE_SHIELD_MISSED = eh.SPELL_MISSED
eh.SPELL_DISPEL_FAILED = eh.SPELL_MISSED
eh.SPELL_PERIODIC_MISSED = eh.SPELL_MISSED

function eh.ENVIRONMENTAL_DAMAGE(source, dest, t, ...)
	return format("%s %s", STRINGS_ENVIRONMENTAL_DAMAGE[t] or "", DamageFormat(...))
end

function eh.SPELL_HEAL(source, dest, id, name, school, amount, overheal, absorb, critical)
	if not mod.blacklist[id] then
		local _, _, icon = GetSpellInfo(id)
		return HealFormat(dest, amount, overheal, absorb, critical), icon
	end
end
eh.SPELL_PERIODIC_HEAL = eh.SPELL_HEAL

-- TODO not tested
function eh.SPELL_ENERGIZE(source, dest, id, name, school, amount, t, extra)
	if amount > mod.mins.energize and not mod.blacklist[id] then
		local _, _, icon = GetSpellInfo(id)
		return format("+%d %s", amount, STRINGS_POWER_TYPE[t+1]), icon
	end
end
eh.SPELL_PERIODIC_ENERGIZE = eh.SPELL_ENERGIZE
eh.SPELL_DRAIN = eh.SPELL_ENERGIZE
eh.SPELL_PERIODIC_DRAIN = eh.SPELL_DRAIN
eh.SPELL_LEECH = eh.SPELL_ENERGIZE
eh.SPELL_PERIODIC_LEECH = eh.SPELL_LEECH


function eh.SPELL_INTERRUPT(source, dest, id, name, school, extraId, extraName, extraSchool)
	if not extraId then return end
	local _, _, icon = GetSpellInfo(id)
	return format("%s %s %s", INTERRUPT, extraName, STRINGS_SPELL_SCHOOL[extraSchool]), icon
end

function eh.SPELL_DISPEL(source, dest, id, name, school, extraId, extraName, extraSchool, auraType)
	if not extraId then return end
	local _, _, icon = GetSpellInfo(id)
	return format("%s %s", extraName, ACTION_SPELL_DISPEL), icon
end
eh.SPELL_STOLEN = eh.SPELL_DISPEL

--------------------------------------------------------------------------------
local function CLEU(f, e, timestamp, event, sourceGUID, sourceName, sourceFlags, destGUID, destName, destFlags, ...)
	print(timestamp, event, sourceName, destName, destFlags, ...)
	if sourceGUID == pguid then
		if eh[event] then
			local text, icon = eh[event](sourceName, destName, ...)
			if text then
				if ecs[event] then text = format(ecs[event], text) end
				AddText("outgoing", text, icon)
			end
		end
	elseif petguid == sourceGUID then 
		if eh[event] then
			local text, icon = eh[event](sourceName, destName, ...)
			if text then
				AddText("outgoing", format(ecs.PET, text), icon)
			end
		end
	elseif destGUID == pguid then
		if eh[event] then
			local text, icon = eh[event](sourceName, destName, ...)
			if text then
				if ecs[event] then text = format(ecs[event], text) end
				AddText("incoming", text, icon)
			end
		end
	else
		-- notification
	end
end

local function AGOnFinished(ag)
	local fs = ag.fs
	fs:Hide()
	fs.agIcon:Stop()
	fs.icon:Hide()
	fs.cache[fs] = true
end
local function NewFontString(f)
	local fs, a, ag
	fs = f:CreateFontString()
	fs:SetAlpha(0)
	fs:Hide()
	fs:SetPoint("CENTER")
	fs:SetJustifyH("CENTER")
	fs:SetJustifyV("MIDDLE")
	fs:SetFont(f.cfg.fontFile, f.cfg.fontSize, f.cfg.fontFlags)
	fs.cache = f.fsCache
	
	-- animation group for font
	ag = fs:CreateAnimationGroup()
	fs.agText = ag
	ag.fs = fs
	-- on finished hide and add to cache
	ag:SetScript("OnFinished", AGOnFinished)
	-- alpha 0 -> 1 fast, to hide it while delayed
	a = ag:CreateAnimation("Alpha")
	a:SetOrder(1) a:SetDuration(0.1) a:SetChange(1)
	fs.delayText = a
	-- translation to move it
	a = ag:CreateAnimation("Translation")
	a:SetOrder(2) a:SetDuration(f.cfg.duration) a:SetOffset(0, f.cfg.distance)
	
	
	
	-- add texture with animation
	local t = f:CreateTexture()
	fs.icon = t
	t:SetPoint(f.cfg.iconPoint, fs, f.cfg.iconRelativePoint, f.cfg.iconX, f.cfg.iconY)
	t:SetSize(f.cfg.iconSize, f.cfg.iconSize)
	t:SetTexCoord(0.07, 0.93, 0.07, 0.93)
	t:SetAlpha(0)
	t:Hide()
	-- al
	ag = t:CreateAnimationGroup()
	fs.agIcon = ag
	a = ag:CreateAnimation("Alpha")
	a:SetOrder(1) a:SetDuration(0.1) a:SetChange(1)
	fs.delayIcon = a
	-- translation to move it
	a = ag:CreateAnimation("Translation")
	a:SetOrder(2) a:SetDuration(f.cfg.duration) a:SetOffset(0, f.cfg.distance)
	
	return fs
end

AddText = function(output, text, icon)
	local f = mod.output[output]
	if not f then return end
	local fs = next(f.fsCache)
	if fs then
		f.fsCache[fs] = nil
	else
		fs = NewFontString(f)
	end

	local ct = GetTime()
	local x = f.last + f.delay - ct
	if x > 0 then
		fs.delayText:SetStartDelay(x)
		fs.delayIcon:SetStartDelay(x)
		f.last = ct + x
	else
		fs.delayText:SetStartDelay(0)
		fs.delayIcon:SetStartDelay(0)
		f.last = ct
	end
	

	fs:SetText(text)
	fs:Show()
	fs.agText:Play()
	if icon then
		fs.icon:SetTexture(icon)
		fs.icon:Show()
		fs.agIcon:Play()
	end
end

local f
-- outgoing
f = CreateFrame("Frame", nil, UIParent)
f.cfg = mod.config.outgoing
f:SetSize(100, f.cfg.iconSize + 10)
f:SetPoint("CENTER", UIParent, "CENTER", f.cfg.x, f.cfg.y)
--[[
f:SetBackdrop(GameTooltip:GetBackdrop())
f:SetBackdropColor(0, 0, 0, 0.5)
f:SetBackdropBorderColor(0, 0, 0, 0)
--]]
f.last = 0
f.delay = f.cfg.delay
f.fsCache = {}
mod.output.outgoing = f

-- incoming
f = CreateFrame("Frame", nil, UIParent)
f.cfg = mod.config.incoming
f:SetSize(100, f.cfg.iconSize + 10)
f:SetPoint("CENTER", UIParent, "CENTER", f.cfg.x, f.cfg.y)
--[[
f:SetBackdrop(GameTooltip:GetBackdrop())
f:SetBackdropColor(0, 0, 0, 0.5)
f:SetBackdropBorderColor(0, 0, 0, 0)
--]]
f.last = 0
f.delay = f.cfg.delay
f.fsCache = {}
mod.output.incoming = f

-- start watching
local ef = CreateFrame("Frame")
ef:Hide()
ef:SetScript("OnEvent", CLEU)
ef:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")


-- rest of events
local function EventHandler(self, event, ...)
	local arg1 = ...
	if arg1 == "player" then
		petguid = UnitGUID("playerpet")
	end
end
local ref = CreateFrame("Frame")
ref:Hide()
ref:SetScript("OnEvent", EventHandler)
ref:RegisterEvent("UNIT_PET")