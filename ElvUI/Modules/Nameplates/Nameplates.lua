local E, L, V, P, G = unpack(ElvUI)
local NP = E:GetModule('NamePlates')
local UF = E:GetModule('UnitFrames')
local LSM = E.Libs.LSM
local ElvUF = E.oUF

local _G = _G
local select, strsplit, tostring = select, strsplit, tostring
local pairs, ipairs, wipe, tinsert = pairs, ipairs, wipe, tinsert

local CreateFrame = CreateFrame
local GetCVar = GetCVar
local GetCVarDefault = GetCVarDefault
local GetInstanceInfo = GetInstanceInfo
local GetNumGroupMembers = GenerateClosure(C_Player.GetNumGroupMembers, C_Player)
local GetNumSubgroupMembers = GetNumPartyMembers
local GetPartyAssignment = GetPartyAssignment
local InCombatLockdown = InCombatLockdown
local IsInGroup, IsInRaid = GenerateClosure(C_Player.IsInGroup, C_Player), GenerateClosure(C_Player.IsInRaid, C_Player)
local SetCVar = SetCVar
local UnitClass = UnitClass
local UnitClassification = UnitClassification
local UnitCreatureType = UnitCreatureType
local UnitExists = UnitExists
local UnitFactionGroup = UnitFactionGroup
local UnitGroupRolesAssigned = UnitGroupRolesAssigned
local UnitGUID = UnitGUID
local UnitIsEnemy = UnitIsEnemy
local UnitIsFriend = UnitIsFriend
local UnitIsPlayer = UnitIsPlayer
local UnitIsPVPSanctuary = UnitIsPVPSanctuary
local UnitIsUnit = UnitIsUnit
local UnitName = UnitName
local UnitReaction = UnitReaction
local UnitThreatSituation = UnitThreatSituation
local C_NamePlate_SetNamePlateEnemySize = C_NamePlateManager.SetNamePlateEnemySize
local C_NamePlate_SetNamePlateFriendlySize = C_NamePlateManager.SetNamePlateFriendlySize
local hooksecurefunc = hooksecurefunc

do	-- credit: oUF/private.lua
	local selectionTypes = {[0]=0,[1]=1,[2]=2,[3]=3,[4]=4,[5]=5,[6]=6,[7]=7,[8]=8,[9]=9,[13]=13}
	-- 10 and 11 are unavailable to players, 12 is inconsistent due to bugs and its reliance on cvars

	function NP:UnitExists(unit)
		return unit and UnitExists(unit)
	end

	function NP:UnitSelectionType(unit, considerHostile)
		if considerHostile and UnitThreatSituation('player', unit) then
			return 0
		end
	end
end

local Blacklist = {
	PLAYER = {
		enable = true,
		health = {
			enable = true,
		},
	},
	ENEMY_PLAYER = {},
	FRIENDLY_PLAYER = {},
	ENEMY_NPC = {},
	FRIENDLY_NPC = {},
}

function NP:ResetSettings(unit)
	E:CopyTable(NP.db.units[unit], P.nameplates.units[unit])
end

function NP:CopySettings(from, to)
	if from == to then
		E:Print(L["You cannot copy settings from the same unit."])
		return
	end

	E:CopyTable(NP.db.units[to], E:FilterTableFromBlacklist(NP.db.units[from], Blacklist[to]))
end

do
	local empty = {}
	function NP:PlateDB(nameplate)
		return (nameplate and NP.db.units[nameplate.frameType]) or empty
	end
end

function NP:SetCVar(cvar, value)
	if GetCVar(cvar) ~= tostring(value) then
		SetCVar(cvar, value)
	end
end

function NP:CVarReset()
	-- NP:SetCVar('nameplateMinAlpha', 1)
	-- NP:SetCVar('nameplateMaxAlpha', 1)
	-- NP:SetCVar('nameplateClassResourceTopInset', GetCVarDefault('nameplateClassResourceTopInset'))
	-- NP:SetCVar('nameplateGlobalScale', 1)
	-- NP:SetCVar('NamePlateHorizontalScale', 1)
	-- NP:SetCVar('nameplateLargeBottomInset', GetCVarDefault('nameplateLargeBottomInset'))
	-- NP:SetCVar('nameplateLargerScale', 1)
	-- NP:SetCVar('nameplateLargeTopInset', GetCVarDefault('nameplateLargeTopInset'))
	-- NP:SetCVar('nameplateMaxAlphaDistance', GetCVarDefault('nameplateMaxAlphaDistance'))
	-- NP:SetCVar('nameplateMaxScale', 1)
	-- NP:SetCVar('nameplateMaxScaleDistance', 40)
	-- NP:SetCVar('nameplateMinAlphaDistance', GetCVarDefault('nameplateMinAlphaDistance'))
	-- NP:SetCVar('nameplateMinScale', 1)
	-- NP:SetCVar('nameplateMinScaleDistance', 0)
	-- NP:SetCVar('nameplateMotionSpeed', GetCVarDefault('nameplateMotionSpeed'))
	-- NP:SetCVar('nameplateOccludedAlphaMult', GetCVarDefault('nameplateOccludedAlphaMult'))
	-- NP:SetCVar('nameplateOtherAtBase', GetCVarDefault('nameplateOtherAtBase'))
	-- NP:SetCVar('nameplateResourceOnTarget', GetCVarDefault('nameplateResourceOnTarget'))
	-- NP:SetCVar('nameplateSelectedAlpha', 1)
	-- NP:SetCVar('nameplateSelectedScale', 1)
	-- NP:SetCVar('nameplateSelfAlpha', 1)
	-- NP:SetCVar('nameplateSelfBottomInset', GetCVarDefault('nameplateSelfBottomInset'))
	-- NP:SetCVar('nameplateSelfScale', 1)
	-- NP:SetCVar('nameplateSelfTopInset', GetCVarDefault('nameplateSelfTopInset'))
	-- NP:SetCVar('nameplateTargetBehindMaxDistance', 40)

	-- if not E.Retail then
	-- 	NP:SetCVar('nameplateNotSelectedAlpha', 1)
	-- end
end

function NP:SetCVars()
	NP:SetCVar('nameplateAllowOverlap', NP.db.motionType == 'STACKED' and 1 or 0)
	NP:SetCVar('nameplateDistance', NP.db.loadDistance)

	-- the order of these is important !!
	if not NP.db.visibility.friendly then
		NP.db.visibility.friendly = {}
	end
	NP:SetCVar('nameplateShowEnemyGuardians', NP.db.visibility.enemy.guardians and 1 or 0)
	NP:SetCVar('nameplateShowEnemyPets', NP.db.visibility.enemy.pets and 1 or 0)
	NP:SetCVar('nameplateShowEnemyTotems', NP.db.visibility.enemy.totems and 1 or 0)
	NP:SetCVar('nameplateShowFriendlyGuardians', NP.db.visibility.friendly.guardians and 1 or 0)
	NP:SetCVar('nameplateShowFriendlyTotems', NP.db.visibility.friendly.totems and 1 or 0)
	NP:SetCVar('nameplateShowFriendlyPets', NP.db.visibility.friendly.pets and 1 or 0)
	NP:SetCVar('showVKeyCastbar', 1)
	SetNamePlateCastBarMode(1)
end

function NP:PLAYER_REGEN_DISABLED()
	if NP.db.showFriendlyCombat == 'TOGGLE_ON' then
		NP:SetCVar('nameplateShowFriends', 1)
	elseif NP.db.showFriendlyCombat == 'TOGGLE_OFF' then
		NP:SetCVar('nameplateShowFriends', 0)
	end

	if NP.db.showEnemyCombat == 'TOGGLE_ON' then
		NP:SetCVar('nameplateShowEnemies', 1)
	elseif NP.db.showEnemyCombat == 'TOGGLE_OFF' then
		NP:SetCVar('nameplateShowEnemies', 0)
	end
end

function NP:PLAYER_REGEN_ENABLED()
	if NP.db.showFriendlyCombat == 'TOGGLE_ON' then
		NP:SetCVar('nameplateShowFriends', 0)
	elseif NP.db.showFriendlyCombat == 'TOGGLE_OFF' then
		NP:SetCVar('nameplateShowFriends', 1)
	end

	if NP.db.showEnemyCombat == 'TOGGLE_ON' then
		NP:SetCVar('nameplateShowEnemies', 0)
	elseif NP.db.showEnemyCombat == 'TOGGLE_OFF' then
		NP:SetCVar('nameplateShowEnemies', 1)
	end
end

function NP:Style(unit)
	if self:GetName() == 'ElvNP_TargetClassPower' then
		NP:StyleTargetPlate(self, unit)
	else
		NP:StylePlate(self, unit)
	end

	return self
end

function NP:Construct_RaisedELement(nameplate)
	local RaisedElement = CreateFrame('Frame', nameplate:GetName() .. 'RaisedElement', nameplate)
	RaisedElement:SetFrameLevel(nameplate:GetFrameLevel()+10)
	RaisedElement:SetAllPoints()
	RaisedElement:EnableMouse(false)

	return RaisedElement
end

function NP:Construct_ClassPowerTwo(nameplate)
	if E.myclass == 'DEATHKNIGHT' then
		nameplate.Runes = NP:Construct_Runes(nameplate)
	elseif E.myclass == 'MONK' then
		nameplate.Stagger = NP:Construct_Stagger(nameplate)
	end
end

function NP:Update_ClassPowerTwo(nameplate)
	if E.myclass == 'DEATHKNIGHT' then
		NP:Update_Runes(nameplate)
	elseif E.myclass == 'MONK' then
		NP:Update_Stagger(nameplate)
	end
end

function NP:StyleTargetPlate(nameplate)
	nameplate:SetScale(E.mult)
	nameplate:ClearAllPoints()
	nameplate:Point('CENTER')
	nameplate:Size(NP.db.plateSize.personalWidth or 150, NP.db.plateSize.personalHeight or 40)

	nameplate.RaisedElement = NP:Construct_RaisedELement(nameplate)
	nameplate.ClassPower = NP:Construct_ClassPower(nameplate)

	NP:Construct_ClassPowerTwo(nameplate)
end

function NP:UpdateTargetPlate(nameplate)
	NP:Update_ClassPower(nameplate)
	--NP:Update_ClassPowerTwo(nameplate)

	nameplate:UpdateAllElements('OnShow')
end

function NP:ScalePlate(nameplate, scale, targetPlate)
	if targetPlate and NP.targetPlate then
		NP.targetPlate:SetScale(E.mult)
		NP.targetPlate = nil
	end

	if not nameplate then return end
	nameplate:SetScale(scale * E.mult)

	if nameplate ~= NP.currentTarget then
		if scale > 1 then
			nameplate:SetFrameLevel(30)
		elseif scale < 1 then
			nameplate:SetFrameLevel(10)
		else
			nameplate:SetFrameLevel(20)
		end
	end

	if targetPlate then
		NP.targetPlate = nameplate
	end
end

function NP:PostUpdateAllElements(event)
	if event and (event == 'ForceUpdate' or not NP.StyleFilterEventFunctions[event]) then
		NP:StyleFilterUpdate(self, event)
		self.StyleFilterBaseAlreadyUpdated = nil -- keep after StyleFilterUpdate
	end

	if event == 'NAME_PLATE_UNIT_ADDED' and self.isTarget then
		NP:SetupTarget(self)
	end
end

function NP:StylePlate(nameplate)
	nameplate:SetScale(E.mult)

	nameplate.RaisedElement = NP:Construct_RaisedELement(nameplate)
	nameplate.Health = NP:Construct_Health(nameplate)
	nameplate.Health.Text = NP:Construct_TagText(nameplate.RaisedElement)
	nameplate.Health.Text.frequentUpdates = .1
	nameplate.HealCommBar = NP:Construct_HealComm(nameplate)
	nameplate.Power = NP:Construct_Power(nameplate)
	nameplate.Power.Text = NP:Construct_TagText(nameplate.RaisedElement)
	nameplate.Name = NP:Construct_TagText(nameplate.RaisedElement)
	nameplate.Level = NP:Construct_TagText(nameplate.RaisedElement)
	nameplate.Title = NP:Construct_TagText(nameplate.RaisedElement)
	nameplate.ClassificationIndicator = NP:Construct_ClassificationIndicator(nameplate.RaisedElement)
	nameplate.Castbar = NP:Construct_Castbar(nameplate)
	nameplate.Portrait = NP:Construct_Portrait(nameplate.RaisedElement)
	nameplate.QuestIcons = NP:Construct_QuestIcons(nameplate.RaisedElement)
	nameplate.RaidTargetIndicator = NP:Construct_RaidTargetIndicator(nameplate.RaisedElement)
	nameplate.TargetIndicator = NP:Construct_TargetIndicator(nameplate)
	nameplate.ThreatIndicator = NP:Construct_ThreatIndicator(nameplate.RaisedElement)
	nameplate.Highlight = NP:Construct_Highlight(nameplate)
	nameplate.ClassPower = NP:Construct_ClassPower(nameplate)
	nameplate.PvPIndicator = NP:Construct_PvPIndicator(nameplate.RaisedElement) -- Horde / Alliance / HonorInfo
	nameplate.PvPClassificationIndicator = NP:Construct_PvPClassificationIndicator(nameplate.RaisedElement) -- Cart / Flag / Orb / Assassin Bounty
	nameplate.PVPRole = NP:Construct_PVPRole(nameplate.RaisedElement)
	nameplate.Cutaway = NP:Construct_Cutaway(nameplate)
	nameplate.BossMods = NP:Construct_BossMods(nameplate)

	NP:Construct_Auras(nameplate)
	NP:StyleFilterEvents(nameplate) -- prepare the watcher

	--NP:Construct_ClassPowerTwo(nameplate)

	NP.Plates[nameplate] = nameplate:GetName()

	hooksecurefunc(nameplate, 'UpdateAllElements', NP.PostUpdateAllElements)
end

function NP:UpdatePlate(nameplate, updateBase)
	NP:Update_RaidTargetIndicator(nameplate)
	NP:Update_PVPRole(nameplate)
	NP:Update_Portrait(nameplate)
	NP:Update_QuestIcons(nameplate)
	NP:Update_BossMods(nameplate)

	local db = NP:PlateDB(nameplate)
	if db.nameOnly or not db.enable then
		NP:DisablePlate(nameplate, db.enable and db.nameOnly)

		if not db.enable and nameplate.RaisedElement:IsShown() then
			nameplate.RaisedElement:Hide()
		end
	elseif updateBase then
		NP:Update_Tags(nameplate)
		NP:Update_Health(nameplate)
		NP:Update_HealComm(nameplate)
		NP:Update_Highlight(nameplate)
		--NP:Update_Power(nameplate)
		NP:Update_Castbar(nameplate)
		NP:Update_ClassPower(nameplate)
		NP:Update_Auras(nameplate)
		NP:Update_ClassificationIndicator(nameplate)
		NP:Update_PvPIndicator(nameplate) -- Horde / Alliance / HonorInfo
		NP:Update_PvPClassificationIndicator(nameplate) -- Cart / Flag / Orb / Assassin Bounty
		NP:Update_TargetIndicator(nameplate)
		NP:Update_ThreatIndicator(nameplate)
		NP:Update_Cutaway(nameplate)

		--NP:Update_ClassPowerTwo(nameplate)

		if nameplate == _G.ElvNP_Player then
			NP:Update_Fader(nameplate)
		end
	else
		NP:Update_Health(nameplate, true) -- this will only reset the ouf vars so it won't hold stale threat ones
	end
end

NP.DisableInNotNameOnly = {
	'QuestIcons',
	'Highlight',
	'Portrait',
	'PVPRole'
}

NP.DisableElements = {
	'Health',
	'HealCommBar',
	--'Power',
	'ClassificationIndicator',
	'Castbar',
	'ThreatIndicator',
	'TargetIndicator',
	--header'ClassPower',
	'PvPIndicator',
	'PvPClassificationIndicator',
	'Auras'
}

if E.myclass == 'DEATHKNIGHT' then
	tinsert(NP.DisableElements, 'Runes')
elseif E.myclass == 'MONK' then
	tinsert(NP.DisableElements, 'Stagger')
end

function NP:DisablePlate(nameplate, nameOnly, nameOnlySF)
	for _, element in ipairs(NP.DisableElements) do
		if nameplate:IsElementEnabled(element) then
			nameplate:DisableElement(element)
		end
	end

	if nameOnly then
		NP:Update_Tags(nameplate, nameOnlySF)
		NP:Update_Highlight(nameplate, nameOnlySF)
		NP:Update_TargetIndicator(nameplate, nameOnlySF)
		-- The position values here are forced on purpose.
		nameplate.Name:ClearAllPoints()
		nameplate.Name:Point('CENTER', nameplate, 'CENTER', 0, 0)

		nameplate.RaidTargetIndicator:ClearAllPoints()
		nameplate.RaidTargetIndicator:Point('BOTTOM', nameplate, 'TOP', 0, 0)

		nameplate.Portrait:ClearAllPoints()
		nameplate.Portrait:Point('RIGHT', nameplate.Name, 'LEFT', -6, 0)

		nameplate.PVPRole:ClearAllPoints()
		nameplate.PVPRole:Point('RIGHT', (nameplate.Portrait:IsShown() and nameplate.Portrait) or nameplate.Name, 'LEFT', -6, 0)

		nameplate.QuestIcons:ClearAllPoints()
		nameplate.QuestIcons:Point('LEFT', nameplate.Name, 'RIGHT', 6, 0)

		nameplate.Title:ClearAllPoints()
		nameplate.Title:Point('TOP', nameplate.Name, 'BOTTOM', 0, -2)

		if nameplate.isTarget then
			NP:SetupTarget(nameplate, true)
		end
	else
		for _, element in ipairs(NP.DisableInNotNameOnly) do
			if nameplate:IsElementEnabled(element) then
				nameplate:DisableElement(element)
			end
		end
	end
end

function NP:GetClassAnchor()
	local TCP = _G.ElvNP_TargetClassPower
	return TCP.realPlate or TCP
end

function NP:SetupTarget(nameplate, removed)
	if not (NP.db.units and NP.db.units.TARGET) then return end

	local TCP = _G.ElvNP_TargetClassPower
	local cp = NP.db.units.TARGET.classpower or {}

	if removed and nameplate then
		nameplate:SetFrameLevel(20)
		if NP.currentTarget == nameplate then
			NP.currentTarget = nil
		end
	elseif nameplate then
		if NP.currentTarget and NP.currentTarget ~= nameplate then
			NP.currentTarget:SetFrameLevel(20)
		end
		NP.currentTarget = nameplate
		nameplate:SetFrameLevel(100)
	end

	if removed or not nameplate or not cp.enable then
		TCP.realPlate = nil
	else
		local db = NP:PlateDB(nameplate)
		TCP.realPlate = not db.nameOnly and nameplate or nil
	end

	local anchor = NP:GetClassAnchor()
	if TCP.ClassPower then
		TCP.ClassPower:SetParent(anchor)
		TCP.ClassPower:ClearAllPoints()
		TCP.ClassPower:Point('CENTER', anchor, 'CENTER', cp.xOffset, cp.yOffset)
	end

	if TCP.Runes then
		TCP.Runes:SetParent(anchor)
		TCP.Runes:ClearAllPoints()
		TCP.Runes:Point('CENTER', anchor, 'CENTER', cp.xOffset, cp.yOffset)
	elseif TCP.Stagger then
		TCP.Stagger:SetParent(anchor)
		TCP.Stagger:ClearAllPoints()
		TCP.Stagger:Point('CENTER', anchor, 'CENTER', cp.xOffset, cp.yOffset)
	end
end

function NP:Update_StatusBars()
	for bar in pairs(NP.StatusBars) do
		local sf = NP:StyleFilterChanges(bar:GetParent())
		if not sf.HealthTexture then
			local texture = LSM:Fetch('statusbar', NP.db.statusbar) or E.media.normTex
			if bar.SetStatusBarTexture then
				bar:SetStatusBarTexture(texture)
			else
				bar:SetTexture(texture)
			end
		end
	end
end

function NP:PARTY_MEMBERS_CHANGED()
	return self:RAID_ROSTER_UPDATE()
end

function NP:RAID_ROSTER_UPDATE()
	local isInRaid = IsInRaid()
	NP.IsInGroup = isInRaid or IsInGroup()

	wipe(NP.GroupRoles)

	if NP.IsInGroup then
		local group = isInRaid and 'raid' or 'party'
		for i = 1, (isInRaid and GetNumGroupMembers()) or GetNumSubgroupMembers() do
			local unit = group .. i
			if UnitExists(unit) then
				NP.GroupRoles[UnitName(unit)] = (GetPartyAssignment('MAINTANK', unit) and 'TANK' or 'NONE')
			end
		end
	end
end

function NP:PLAYER_ENTERING_WORLD(_, initLogin, isReload)
	NP.InstanceType = select(2, GetInstanceInfo())

	if not self.initLogin then
		self.initLogin = true
		NP:ConfigureAll(true)
	end
end

function NP:ConfigurePlates(init)
	NP.SkipFading = true
	if not init then -- these only need to happen when changing options
		for nameplate in pairs(NP.Plates) do
			if nameplate.frameType == 'FRIENDLY_PLAYER' or nameplate.frameType == 'FRIENDLY_NPC' then
				nameplate:Size(NP.db.plateSize.friendlyWidth, NP.db.plateSize.friendlyHeight)
			else
				nameplate:Size(NP.db.plateSize.enemyWidth, NP.db.plateSize.enemyHeight)
			end

			nameplate.previousType = nil -- keep over the callback, we still need a full update
			NP:NamePlateCallBack(nameplate, 'NAME_PLATE_UNIT_ADDED')

			nameplate.StyleFilterBaseAlreadyUpdated = nil
			nameplate:UpdateAllElements('ForceUpdate')
		end
	end

	NP.SkipFading = nil
end

function NP:ConfigureAll(init)
	if not E.private.nameplates.enable then return end

	NP:StyleFilterConfigure() -- keep this at the top
	NP:SetNamePlateSizes()
	NP:PLAYER_REGEN_ENABLED()
	NP:UpdateTargetPlate(_G.ElvNP_TargetClassPower)
	NP:Update_StatusBars()

	NP:ConfigurePlates(init) -- keep before toggle static
end

function NP:PlateFade(nameplate, timeToFade, startAlpha, endAlpha)
	if not nameplate.nameplateAnchor:IsShown() then return end
	-- we need our own function because we want a smooth transition and dont want it to force update every pass.
	-- its controlled by fadeTimer which is reset when UIFrameFadeOut or UIFrameFadeIn code runs.

	if not nameplate.FadeObject then
		nameplate.FadeObject = {}
	end

	nameplate.FadeObject.timeToFade = (nameplate.isTarget and 0) or timeToFade
	nameplate.FadeObject.startAlpha = startAlpha
	nameplate.FadeObject.endAlpha = endAlpha
	nameplate.FadeObject.diffAlpha = endAlpha - startAlpha

	if nameplate.FadeObject.fadeTimer then
		nameplate.FadeObject.fadeTimer = 0
	else
		E:UIFrameFade(nameplate, nameplate.FadeObject)
	end
end

function NP:UnitNPCID(unit) -- also used by Bags.lua
	local guid = UnitGUID(unit)
	return guid and GetCreatureIDFromGUID(guid), guid
end

function NP:UpdatePlateGUID(nameplate, guid)
	NP.PlateGUID[nameplate.unitGUID] = (guid and nameplate) or nil
end

function NP:UpdatePlateType(nameplate)
	if nameplate.isPVPSanctuary then
		nameplate.frameType = 'FRIENDLY_PLAYER'
	elseif not nameplate.isEnemy and (not nameplate.reaction or nameplate.reaction > 4) then -- keep as: not isEnemy, dont switch to isFriend
		nameplate.frameType = (nameplate.isPlayer and 'FRIENDLY_PLAYER') or 'FRIENDLY_NPC'
	else
		nameplate.frameType = (nameplate.isPlayer and 'ENEMY_PLAYER') or 'ENEMY_NPC'
	end
end

function NP:UpdatePlateSize(nameplate)
	if nameplate.frameType == 'FRIENDLY_PLAYER' or nameplate.frameType == 'FRIENDLY_NPC' then
		nameplate.width, nameplate.height = NP.db.plateSize.friendlyWidth, NP.db.plateSize.friendlyHeight
		C_NamePlate_SetNamePlateFriendlySize(nameplate.width, nameplate.height)
	else
		nameplate.width, nameplate.height = NP.db.plateSize.enemyWidth, NP.db.plateSize.enemyHeight
		C_NamePlate_SetNamePlateEnemySize(nameplate.width, nameplate.height)
	end

	nameplate:Size(nameplate.width, nameplate.height)
end


function NP:UpdatePlateBase(nameplate)
	local update = nameplate.frameType ~= nameplate.previousType
	NP:UpdatePlate(nameplate, update)
	nameplate.StyleFilterBaseAlreadyUpdated = update
	nameplate.previousType = nameplate.frameType
end

function NP:NamePlateCallBack(nameplate, event, unit)
	if event == 'UNIT_FACTION' or event == 'UNIT_FLAGS' then
		nameplate.reaction = UnitReaction('player', unit) -- Player Reaction
		nameplate.repReaction = UnitReaction(unit, 'player') -- Reaction to Player
		nameplate.isFriend = UnitIsFriend('player', unit)
		nameplate.isEnemy = UnitIsEnemy('player', unit)
		nameplate.faction = UnitFactionGroup(unit)
		nameplate.battleFaction = GetUnitBattlefieldFaction(unit)
		nameplate.classColor = (nameplate.isPlayer and RAID_CLASS_COLORS[nameplate.classFile]) or (nameplate.repReaction and NP.db.colors.reactions[nameplate.repReaction == 4 and 'neutral' or nameplate.repReaction <= 3 and 'bad' or 'good']) or nil

		NP:UpdatePlateType(nameplate)
		NP:UpdatePlateSize(nameplate)
		NP:UpdatePlateBase(nameplate)

		NP:StyleFilterUpdate(nameplate, event) -- keep this after UpdatePlateBase
		nameplate.StyleFilterBaseAlreadyUpdated = nil -- keep after StyleFilterUpdate
	elseif event == 'PLAYER_TARGET_CHANGED' then -- we need to check if nameplate exists in here
		NP:SetupTarget(nameplate) -- pass it, even as nil here
	elseif event == 'NAME_PLATE_UNIT_ADDED' then
		if not unit then unit = nameplate.unit end

		nameplate.classification = UnitClassification(unit)
		nameplate.creatureType = UnitCreatureType(unit)
		nameplate.isMe = UnitIsUnit(unit, 'player')
		nameplate.isPet = UnitIsUnit(unit, 'pet')
		nameplate.isFriend = UnitIsFriend('player', unit)
		nameplate.isEnemy = UnitIsEnemy('player', unit)
		nameplate.isPlayer = UnitIsPlayer(unit)
		nameplate.isPVPSanctuary = UnitIsPVPSanctuary(unit)
		nameplate.reaction = UnitReaction('player', unit) -- Player Reaction
		nameplate.repReaction = UnitReaction(unit, 'player') -- Reaction to Player
		nameplate.faction = UnitFactionGroup(unit)
		nameplate.battleFaction = GetUnitBattlefieldFaction(unit)
		nameplate.unitName, nameplate.unitRealm = UnitName(unit)
		nameplate.className, nameplate.classFile, nameplate.classID = UnitClass(unit)
		nameplate.npcID, nameplate.unitGUID = NP:UnitNPCID(unit)
		nameplate.classColor = (nameplate.isPlayer and RAID_CLASS_COLORS[nameplate.classFile]) or (nameplate.repReaction and NP.db.colors.reactions[nameplate.repReaction == 4 and 'neutral' or nameplate.repReaction <= 3 and 'bad' or 'good']) or nil

		if nameplate.unitGUID then
			NP:UpdatePlateGUID(nameplate, nameplate.unitGUID)
		end

		NP:UpdatePlateType(nameplate)
		NP:UpdatePlateSize(nameplate)

		if not nameplate.RaisedElement:IsShown() then
			nameplate.RaisedElement:Show()
		end

		NP:UpdatePlateBase(nameplate)
		NP:BossMods_UpdateIcon(nameplate)

		NP:StyleFilterEventWatch(nameplate) -- fire up the watcher
		NP:StyleFilterSetVariables(nameplate) -- sets: isTarget, isTargetingMe, isFocused

		if (NP.db.fadeIn and not NP.SkipFading) and nameplate.frameType ~= 'PLAYER' then
			NP:PlateFade(nameplate, 0.5, 0, 1)
		end
	elseif event == 'NAME_PLATE_UNIT_REMOVED' then
		if nameplate.isTarget then
			NP:ScalePlate(nameplate, 1, true)
			NP:SetupTarget(nameplate, true)
		end

		if nameplate.unitGUID then
			NP:UpdatePlateGUID(nameplate)
		end

		NP:BossMods_UpdateIcon(nameplate, true)

		NP:StyleFilterEventWatch(nameplate, true) -- shut down the watcher
		NP:StyleFilterClearVariables(nameplate)

		-- these can appear on SoftTarget nameplates and they aren't
		-- from NAME_PLATE_UNIT_ADDED which means, they will still be shown
		-- in some cases when the plate previously had the element
		if nameplate.QuestIcons then
			nameplate.QuestIcons:Hide()
		end

		-- vars that we need to keep in a nonstale state
		nameplate.Health.cur = nil -- cutaway
		--nameplate.Power.cur = nil -- cutaway
		nameplate.npcID = nil -- just cause
	end
end

local optionsTable = {
	'EnemyMinus',
	'EnemyMinions',
	'FriendlyMinions',
	'nameplateDistance',
	'MotionDropDown',
	'ShowAll'
}

function NP:HideInterfaceOptions()
	-- for _, x in pairs(optionsTable) do
	-- 	local o = _G['InterfaceOptionsNamesPanelUnitNameplates' .. x]
	-- 	if o then
	-- 		o:SetSize(0.00001, 0.00001)
	-- 		o:SetAlpha(0)
	-- 		o:Hide()
	-- 	end
	-- end
end

function NP:SetNamePlateSizes()
	--if InCombatLockdown() then return end
	C_NamePlate_SetNamePlateEnemySize(NP.db.plateSize.enemyWidth, NP.db.plateSize.enemyHeight)
	C_NamePlate_SetNamePlateFriendlySize(NP.db.plateSize.friendlyWidth, NP.db.plateSize.friendlyHeight)
end

function NP:Initialize()
	NP.db = E.db.nameplates

	if not E.private.nameplates.enable then return end
	NP.Initialized = true

	NP.thinBorders = NP.db.thinBorders
	NP.SPACING = (NP.thinBorders or E.twoPixelsPlease) and 0 or 1
	NP.BORDER = (NP.thinBorders and not E.twoPixelsPlease) and 1 or 2

	ElvUF:RegisterStyle('ElvNP', NP.Style)
	ElvUF:SetActiveStyle('ElvNP')

	SetCVar('nameplateShowOnlyNames', NP.db.visibility.nameplateShowOnlyNames and '1' or '0')

	NP.Plates = {}
	NP.PlateGUID = {}
	NP.StatusBars = {}
	NP.GroupRoles = {}
	NP.multiplier = 0.35

	ElvUF:Spawn('player', 'ElvNP_TargetClassPower')

	_G.ElvNP_TargetClassPower:Size(NP.db.plateSize.personalWidth or 150, NP.db.plateSize.personalHeight or 40)
	_G.ElvNP_TargetClassPower.frameType = 'TARGET'
	_G.ElvNP_TargetClassPower:SetAttribute('toggleForVehicle', true)
	_G.ElvNP_TargetClassPower:ClearAllPoints()
	_G.ElvNP_TargetClassPower:Point('TOP', E.UIParent, 'BOTTOM', 0, -500)

	ElvUF:SpawnNamePlates('ElvNP_', function(nameplate, event, unit)
		NP:NamePlateCallBack(nameplate, event, unit)
	end)

	NP:RegisterEvent('PLAYER_REGEN_ENABLED')
	NP:RegisterEvent('PLAYER_REGEN_DISABLED')
	NP:RegisterEvent('PLAYER_ENTERING_WORLD')
	NP:RegisterEvent('COMBAT_LOG_EVENT_UNFILTERED')
	NP:RegisterEvent('RAID_ROSTER_UPDATE')
	NP:RegisterEvent('PARTY_MEMBERS_CHANGED')
	NP:RegisterEvent('PLAYER_LOGOUT')

	NP:BossMods_RegisterCallbacks()
	NP:StyleFilterInitialize()
	NP:HideInterfaceOptions()
	NP:RAID_ROSTER_UPDATE()
	NP:PARTY_MEMBERS_CHANGED()
	NP:SetCVars()
end

local AuraUpdateEvents = {
	["SPELL_AURA_APPLIED"] = true,
	["SPELL_AURA_REMOVED"] = true,
	["SPELL_AURA_REFRESH"] = true,
	["SPELL_AURA_BROKEN"] = true,
	["SPELL_AURA_BROKEN_SPELL"] = true,
	["SPELL_AURA_APPLIED_DOSE"] = true,
	["SPELL_AURA_REMOVED_DOSE"] = true,
}

function NP:COMBAT_LOG_EVENT_UNFILTERED(_, _, event, _, sourceGUID, sourceName, targetGUID)
	NP:CASTBAR_COMBAT_LOG_EVENT_UNFILTERED(event, sourceGUID, sourceName, targetGUID)
	local auraUpdate = AuraUpdateEvents[event]
	if not auraUpdate then return end
	if targetGUID and targetGUID ~= "" then
		local nameplate = NP.PlateGUID[targetGUID]
		if not nameplate then return end

		nameplate:UpdateElement('Auras')
		NP:StyleFilterUpdate(nameplate, 'UNIT_AURA')
		nameplate.StyleFilterBaseAlreadyUpdated = nil -- keep after StyleFilterUpdate
	end
end

E:RegisterModule(NP:GetName())
