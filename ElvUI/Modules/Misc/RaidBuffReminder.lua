local E, L, V, P, G = unpack(select(2, ...)) --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local RB = E:GetModule("ReminderBuffs")
local LSM = E.Libs.LSM

--Lua functions
local ipairs, unpack = ipairs, unpack
--WoW API / Variables
local CooldownFrame_SetTimer = CooldownFrame_SetTimer
local CreateFrame = CreateFrame
local GetSpellInfo = GetSpellInfo
local GetTime = GetTime
local UnitAura = UnitAura

RB.Spell1Buffs = {
	67016, -- Flask of the North (SP)
	67017, -- Flask of the North (AP)
	67018, -- Flask of the North (STR)
	53755, -- Flask of the Frost Wyrm
	53758, -- Flask of Stoneblood
	53760, -- Flask of Endless Rage
	54212, -- Flask of Pure Mojo
	53752, -- Lesser Flask of Toughness (50 Resilience)
	17627, -- Flask of Distilled Wisdom

	33721, -- Spellpower Elixir
	53746, -- Wrath Elixir
	28497, -- Elixir of Mighty Agility
	53748, -- Elixir of Mighty Strength
	60346, -- Elixir of Lightning Speed
	60344, -- Elixir of Expertise
	60341, -- Elixir of Deadly Strikes
	60345, -- Elixir of Armor Piercing
	60340, -- Elixir of Accuracy
	53749, -- Guru's Elixir

	60343, -- Elixir of Mighty Defense
	53751, -- Elixir of Mighty Fortitude
	53764, -- Elixir of Mighty Mageblood
	60347, -- Elixir of Mighty Thoughts
	53763, -- Elixir of Protection
	53747, -- Elixir of Spirit
}

RB.Spell2Buffs = {
	57325, -- 80 AP
	57327, -- 46 SP
	57329, -- 40 Critical Strike Rating
	57332, -- 40 Haste Rating
	57334, -- 20 MP5
	57356, -- 40 Expertise Rating
	57358, -- 40 ARP
	57360, -- 40 Hit Rating
	57363, -- Tracking Humanoids
	57365, -- 40 Spirit
	57367, -- 40 AGI
	57371, -- 40 STR
	57373, -- Tracking Beasts
	57399, -- 80 AP, 46 SP
	59230, -- 40 Dodge Rating
	65247, -- 20 STR
}

RB.Spell3Buffs = {
	72588, -- Gift of the Wild
	48469, -- Mark of the Wild
}

RB.Spell4Buffs = {
	25898, -- Greater Blessing of Kings
	20217, -- Blessing of Kings
	72586, -- Blessing of Forgotten Kings
}

RB.Spell5Buffs = {
	48162, -- Prayer of Fortitude
	48161, -- Power Word: Fortitude
	72590, -- Fortitude
}

RB.Spell6Buffs = {
	20911, -- Blessing of Sanctuary
	25899, -- Greater Blessing of Sanctuary
}

RB.CasterSpell7Buffs = {
	61316, -- Dalaran Brilliance
	43002, -- Arcane Brilliance
	42995, -- Arcane Intellect
}

RB.AttackSpell7Buffs = {
	48934, -- Greater Blessing of Might
	48932, -- Blessing of Might
	47436, -- Battle Shout
}

RB.Spell8Buffs = {
	6307, -- Blood Pact
	469, -- Commanding Shout
}

-- Armor buffs
RB.Spell9Buffs = {
	25506, -- Stoneskin Totem
	465, -- Devotion Aura
}

-- Concentration / Thorns
RB.CasterSpell10Buffs = {
	19746, -- Concentration Aura
}
RB.AttackSpell10Buffs = {
	467, -- Thorns
	7294, -- Retribution Aura
}

-- SP / Str+Dex totems
RB.CasterSpell11Buffs = {
	30706, -- Totem of Wrath
	8227, -- Flametongue Totem
	47236, -- Demonic Pact
}
RB.AttackSpell11Buffs = {
	25527, -- Strength of Earth Totem
}

-- Mana regen
RB.Spell12Buffs = {
	48938, -- Greater Blessing of Wisdom
	48936, -- Blessing of Wisdom
	58777, -- Mana Spring
}

-- Crit % Increase
RB.CasterSpell13Buffs = {
	51471, -- Elemental Oath
	24907, -- Moonkin Aura
}
RB.AttackSpell13Buffs = {
	17007, -- Leader of the Pack
	29801, -- Rampage
}

-- Haste % Increase
RB.CasterSpell14Buffs = {
	50172, -- Moonkin's Presence
	2895, -- Wrath of Air
	853648, -- Swift Retribution
}
RB.AttackSpell14Buffs = {
	8512, -- Windfury Totem
}

-- Spirit Buff
RB.CasterSpell15Buffs = {
	14752, -- Divine Spirit
	27681, -- Prayer of Spirit
}
-- Percent AP
RB.AttackSpell15Buffs = {
	19506, -- Trueshot Aura
	30802, -- Unleashed Rage
	53137, -- Abomination's Might
}

-- Percent Damage
RB.Spell16Buffs = {
	31579, -- Arcane Empowerment
	31869, -- Sanctified Retribution
	34455, -- Ferocious Inspiration
}

function RB:CheckFilterForActiveBuff(filter)
	for _, spell in ipairs(filter) do
		local spellName = GetSpellInfo(spell)
		local name, _, texture, _, _, duration, expirationTime = UnitAura("player", spellName)

		if name then
			return texture, duration, expirationTime
		end
	end
end

function RB:UpdateReminderTime(elapsed)
	self.expiration = self.expiration - elapsed

	if self.nextUpdate > 0 then
		self.nextUpdate = self.nextUpdate - elapsed
		return
	end

	if self.expiration <= 0 then
		self.timer:SetText("")
		self:SetScript("OnUpdate", nil)
		return
	end

	local value, id, nextUpdate, remainder = E:GetTimeInfo(self.expiration, 4)
	self.nextUpdate = nextUpdate

	local style = E.TimeFormats[id]
	if style then
		self.timer:SetFormattedText(style[1], value, remainder)
	end
end

function RB:UpdateReminder(event, unit)
	if event == "UNIT_AURA" and unit ~= "player" then return end

	for i = 1, 16 do
		local texture, duration, expirationTime = self:CheckFilterForActiveBuff(self["Spell"..i.."Buffs"])
		local button = self.frame[i]

		if texture then
			button.t:SetTexture(texture)

			if (duration == 0 and expirationTime == 0) or E.db.general.reminder.durations ~= true then
				button.t:SetAlpha(E.db.general.reminder.reverse and 1 or 0.3)
				button:SetScript("OnUpdate", nil)
				button.timer:SetText(nil)
				CooldownFrame_SetTimer(button.cd, 0, 0, 0)
			else
				button.expiration = expirationTime - GetTime()
				button.nextUpdate = 0
				button.t:SetAlpha(1)
				CooldownFrame_SetTimer(button.cd, expirationTime - duration, duration, 1)
				button.cd:SetReverse(E.db.general.reminder.reverse)
				button:SetScript("OnUpdate", self.UpdateReminderTime)
			end
		else
			CooldownFrame_SetTimer(button.cd, 0, 0, 0)
			button.t:SetAlpha(E.db.general.reminder.reverse and 0.3 or 1)
			button:SetScript("OnUpdate", nil)
			button.timer:SetText(nil)
			button.t:SetTexture(self.DefaultIcons[i])
		end
	end
end

function RB:CreateButton()
	local button = CreateFrame("Button", nil, ElvUI_ReminderBuffs)
	button:SetTemplate("Default")

	button.t = button:CreateTexture(nil, "OVERLAY")
	button.t:SetTexCoord(unpack(E.TexCoords))
	button.t:SetInside()
	button.t:SetTexture("Interface\\Icons\\INV_Misc_QuestionMark")

	button.cd = CreateFrame("Cooldown", nil, button, "CooldownFrameTemplate")
	button.cd:SetInside()
	button.cd.noOCC = true
	button.cd.noCooldownCount = true

	button.timer = button.cd:CreateFontString(nil, "OVERLAY")
	button.timer:SetPoint("CENTER")

	return button
end

function RB:EnableRB()
	ElvUI_ReminderBuffs:Show()
	self:RegisterEvent("UNIT_AURA", "UpdateReminder")
	self:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED", "UpdateReminder")
	self:RegisterEvent("CHARACTER_POINTS_CHANGED", "UpdateReminder")
	E.RegisterCallback(self, "RoleChanged", "UpdateSettings")
	self:UpdateReminder()
end

function RB:DisableRB()
	ElvUI_ReminderBuffs:Hide()
	self:UnregisterEvent("UNIT_AURA")
	self:UnregisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
	self:UnregisterEvent("CHARACTER_POINTS_CHANGED")
	E.UnregisterCallback(self, "RoleChanged", "UpdateSettings")
end

function RB:UpdateSettings(isCallback)
	local frame = self.frame
	frame:Width(E.RBRWidth * 2)

	self:UpdateDefaultIcons()

	for i = 1, 16 do
		local button = frame[i]
		button:ClearAllPoints()
		button:SetWidth(E.RBRWidth)
		button:SetHeight(E.RBRWidth)

		if i == 1 then
			button:SetPoint("TOPLEFT", ElvUI_ReminderBuffs, "TOPLEFT", 0, -1)
		elseif i == 9 then
			button:SetPoint("TOPRIGHT", ElvUI_ReminderBuffs, "TOPRIGHT", 0, -1)
		else
			button:Point("TOP", frame[i - 1], "BOTTOM", 0, E.Border - E.Spacing*3)
		end

		if E.db.general.reminder.durations then
			button.cd:SetAlpha(1)
		else
			button.cd:SetAlpha(0)
		end

		button.timer:FontTemplate(LSM:Fetch("font", E.db.general.reminder.font), E.db.general.reminder.fontSize, E.db.general.reminder.fontOutline)
	end

	if not isCallback then
		if E.db.general.reminder.enable then
			RB:EnableRB()
		else
			RB:DisableRB()
		end
	else
		self:UpdateReminder()
	end
end

function RB:UpdatePosition()
	Minimap:ClearAllPoints()
	ElvConfigToggle:ClearAllPoints()
	ElvUI_ReminderBuffs:ClearAllPoints()
	if E.db.general.reminder.position == "LEFT" then
		Minimap:Point("TOPRIGHT", MMHolder, "TOPRIGHT", -E.Border, -E.Border)
		ElvConfigToggle:SetPoint("TOPRIGHT", LeftMiniPanel, "TOPLEFT", E.Border - E.Spacing*3, 0)
		ElvConfigToggle:SetPoint("BOTTOMRIGHT", LeftMiniPanel, "BOTTOMLEFT", E.Border - E.Spacing*3, 0)
		ElvUI_ReminderBuffs:SetPoint("TOPRIGHT", Minimap.backdrop, "TOPLEFT", E.Border - E.Spacing*3, 0)
		ElvUI_ReminderBuffs:SetPoint("BOTTOMRIGHT", Minimap.backdrop, "BOTTOMLEFT", E.Border - E.Spacing*3, 0)
	else
		Minimap:Point("TOPLEFT", MMHolder, "TOPLEFT", E.Border, -E.Border)
		ElvConfigToggle:SetPoint("TOPLEFT", RightMiniPanel, "TOPRIGHT", -E.Border + E.Spacing*3, 0)
		ElvConfigToggle:SetPoint("BOTTOMLEFT", RightMiniPanel, "BOTTOMRIGHT", -E.Border + E.Spacing*3, 0)
		ElvUI_ReminderBuffs:SetPoint("TOPLEFT", Minimap.backdrop, "TOPRIGHT", -E.Border + E.Spacing*3, 0)
		ElvUI_ReminderBuffs:SetPoint("BOTTOMLEFT", Minimap.backdrop, "BOTTOMRIGHT", -E.Border + E.Spacing*3, 0)
	end
end

function RB:UpdateDefaultIcons()
	local isCaster = E.private.general.reminder.classtype == "Caster"
	self.DefaultIcons = {
		[1] = "Interface\\Icons\\INV_Potion_97",
		[2] = "Interface\\Icons\\Spell_Misc_Food",
		[3] = "Interface\\Icons\\Spell_Nature_Regeneration",
		[4] = "Interface\\Icons\\Spell_Magic_GreaterBlessingofKings",
		[5] = "Interface\\Icons\\Spell_Holy_WordFortitude",
		[6] = "Interface\\Icons\\spell_nature_lightningshield",
		[7] = (isCaster and "Interface\\Icons\\Spell_Holy_MagicalSentry") or "Interface\\Icons\\spell_holy_fistofjustice",
		[8] = "Interface\\Icons\\ability_warrior_rallyingcry",
		[9] = "Interface\\Icons\\spell_nature_stoneskintotem",
		[10] = (isCaster and "Interface\\Icons\\spell_holy_mindsooth") or "Interface\\Icons\\spell_nature_thorns",
		[11] = (isCaster and "Interface\\Icons\\spell_fire_totemofwrath") or "Interface\\Icons\\spell_nature_earthbindtotem",
		[12] = "Interface\\Icons\\Spell_Holy_GreaterBlessingofWisdom",
		[13] = (isCaster and "Interface\\Icons\\spell_nature_moonglow") or "Interface\\Icons\\spell_nature_unyeildingstamina",
		[14] = (isCaster and "Interface\\Icons\\spell_nature_forceofnature") or "Interface\\Icons\\spell_nature_windfury",
		[15] = (isCaster and "Interface\\Icons\\spell_holy_prayerofspirit") or "Interface\\Icons\\ability_trueshot",
		[16] = "Interface\\Icons\\spell_nature_starfall",
	}

	self.Spell7Buffs = isCaster and self.CasterSpell7Buffs or self.AttackSpell7Buffs

	self.Spell10Buffs = isCaster and self.CasterSpell10Buffs or self.AttackSpell10Buffs
	self.Spell11Buffs = isCaster and self.CasterSpell11Buffs or self.AttackSpell11Buffs

	self.Spell13Buffs = isCaster and self.CasterSpell13Buffs or self.AttackSpell13Buffs
	self.Spell14Buffs = isCaster and self.CasterSpell14Buffs or self.AttackSpell14Buffs
	self.Spell15Buffs = isCaster and self.CasterSpell15Buffs or self.AttackSpell15Buffs
end

function RB:Initialize()
	if not E.private.general.minimap.enable then return end

	self.db = E.db.general.reminder

	local frame = CreateFrame("Frame", "ElvUI_ReminderBuffs", Minimap)
	frame:Width(E.RBRWidth)
	if E.db.general.reminder.position == "LEFT" then
		frame:Point("TOPRIGHT", Minimap.backdrop, "TOPLEFT", E.Border - E.Spacing*3, 0)
		frame:Point("BOTTOMRIGHT", Minimap.backdrop, "BOTTOMLEFT", E.Border - E.Spacing*3, 0)
	else
		frame:Point("TOPLEFT", Minimap.backdrop, "TOPRIGHT", -E.Border + E.Spacing*3, 0)
		frame:Point("BOTTOMLEFT", Minimap.backdrop, "BOTTOMRIGHT", -E.Border + E.Spacing*3, 0)
	end
	self.frame = frame

	for i = 1, 16 do
		frame[i] = self:CreateButton()
		frame[i]:SetID(i)
	end

	self:UpdateSettings()
end

local function InitializeCallback()
	RB:Initialize()
end

E:RegisterModule(RB:GetName(), InitializeCallback)