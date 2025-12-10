local E, L, V, P, G = unpack(ElvUI)
local NP = E:GetModule('NamePlates')
local UF = E:GetModule('UnitFrames')
local LSM = E.Libs.LSM

local ipairs = ipairs
local unpack = unpack
local UnitPlayerControlled = UnitPlayerControlled
local UnitClass = UnitClass
local UnitReaction = UnitReaction
local UnitIsConnected = UnitIsConnected
local CreateFrame = CreateFrame
local UnitIsTapped = UnitIsTapped
local UnitIsTappedByPlayer = UnitIsTappedByPlayer
local UnitIsDeadOrGhost = UnitIsDeadOrGhost
local UnitIsPlayer = UnitIsPlayer

function NP:Health_UpdateColor(_, unit)
	if not unit or self.unit ~= unit then return end
	local element = self.Health

	local r, g, b, t
	if element.colorDisconnected and not UnitIsConnected(unit) then
		t = self.colors.disconnected
	elseif (element.colorClass and self.isPlayer) or (element.colorClassNPC and not self.isPlayer) or (element.colorClassPet and UnitPlayerControlled(unit) and not self.isPlayer) then
		local _, class = UnitClass(unit)
		t = self.colors.class[class]
	elseif element.colorReaction and UnitReaction(unit, 'player') then
		local reaction = UnitReaction(unit, 'player')
		t = NP.db.colors.reactions[reaction == 4 and 'neutral' or reaction <= 3 and 'bad' or 'good']
	elseif element.colorSmooth then
		r, g, b = self:ColorGradient(element.cur or 1, element.max or 1, unpack(element.smoothGradient or self.colors.smooth))
	elseif element.colorHealth then
		t = NP.db.colors.health
	end

	if t then
		r, g, b = t.r, t.g, t.b
		element.r, element.g, element.b = r, g, b -- save these for the style filter to switch back
	end

	local db = NP:PlateDB(self)
	if db.greyTappedTargets and UnitIsTapped(unit) and not UnitIsTappedByPlayer(unit) and not UnitIsPlayer(unit) and not UnitIsDeadOrGhost(unit) then
		r, g, b = 0.5, 0.5, 0.5
		element.r, element.g, element.b = r, g, b
	end

	local sf = NP:StyleFilterChanges(self)
	if sf.HealthColor then
		r, g, b = sf.HealthColor.r, sf.HealthColor.g, sf.HealthColor.b
	end

	if b then
		element:SetStatusBarColor(r, g, b)

		if element.bg then
			element.bg:SetVertexColor(r * NP.multiplier, g * NP.multiplier, b * NP.multiplier)
		end
	end

	if element.PostUpdateColor then
		element:PostUpdateColor(unit, r, g, b)
	end
end

function NP:Construct_Health(nameplate)
	local Health = CreateFrame('StatusBar', nameplate:GetName()..'Health', nameplate)
	Health:SetParent(nameplate)
	Health:CreateBackdrop('Transparent', nil, nil, nil, nil, true, true)
	Health:SetStatusBarTexture(LSM:Fetch('statusbar', NP.db.statusbar))
	Health.considerSelectionInCombatHostile = true
	Health.UpdateColor = NP.Health_UpdateColor

	NP.StatusBars[Health] = true

	local statusBarTexture = Health:GetStatusBarTexture()
	local healthFlashTexture = Health:CreateTexture(nameplate:GetName()..'FlashTexture', 'OVERLAY')
	healthFlashTexture:SetTexture(LSM:Fetch('background', 'ElvUI Blank'))
	healthFlashTexture:Point('BOTTOMLEFT', statusBarTexture, 'BOTTOMLEFT')
	healthFlashTexture:Point('TOPRIGHT', statusBarTexture, 'TOPRIGHT')
	healthFlashTexture:Hide()
	nameplate.HealthFlashTexture = healthFlashTexture

	local clipFrame = CreateFrame("Frame", nil, Health)
	clipFrame:SetScript("OnUpdate", UF.HealthClipFrame_OnUpdate)
	clipFrame:SetAllPoints()
	clipFrame:EnableMouse(false)
	clipFrame.__frame = Health
	Health.ClipFrame = clipFrame

	return Health
end

function NP:Health_SetColors(nameplate, threatColors)
	if threatColors then -- managed by ThreatIndicator_PostUpdate
		nameplate.Health:SetColorTapping(nil)
		nameplate.Health:SetColorSelection(nil)
		nameplate.Health.colorReaction = nil
		nameplate.Health.colorClass = nil
	else
		local db = NP:PlateDB(nameplate)
		nameplate.Health:SetColorTapping(true)
		nameplate.Health:SetColorSelection(true)
		nameplate.Health.colorReaction = true
		nameplate.Health.colorClass = db.health and db.health.useClassColor
	end
end

function NP:Update_Health(nameplate, skipUpdate)
	local db = NP:PlateDB(nameplate)

	NP:Health_SetColors(nameplate)

	if skipUpdate then return end

	if db.health.enable then
		if not nameplate:IsElementEnabled('Health') then
			nameplate:EnableElement('Health')
		end

		nameplate.Health:Point('CENTER')
		nameplate.Health:Point('LEFT')
		nameplate.Health:Point('RIGHT')

		E:SetSmoothing(nameplate.Health, NP.db.smoothbars)
	elseif nameplate:IsElementEnabled('Health') then
		nameplate:DisableElement('Health')
	end

	nameplate.Health.width = db.health.width
	nameplate.Health.height = db.health.height
	nameplate.Health:Height(db.health.height)
end

function NP:Update_HealComm(nameplate)
	local db = NP:PlateDB(nameplate)

	if db.health.enable and db.health.healPrediction and db.health.healPrediction.enable then
		if not nameplate:IsElementEnabled('HealCommBar') then
			nameplate:EnableElement('HealCommBar')
		end

		local c = NP.db.colors.healPrediction
		nameplate.HealCommBar.myBar:SetStatusBarColor(c.personal.r, c.personal.g, c.personal.b)
		nameplate.HealCommBar.otherBar:SetStatusBarColor(c.others.r, c.others.g, c.others.b)

		if nameplate.HealCommBar.absorbBar then
			nameplate.HealCommBar.absorbBar:SetStatusBarColor(c.absorbs.r, c.absorbs.g, c.absorbs.b, c.absorbs.a)
		end

		if nameplate.HealCommBar.healAbsorbBar then
			nameplate.HealCommBar.healAbsorbBar:SetStatusBarColor(c.healAbsorbs.r, c.healAbsorbs.g, c.healAbsorbs.b, c.healAbsorbs.a)
		end

		if nameplate.HealCommBar.overAbsorb then
			nameplate.HealCommBar.overAbsorb:SetVertexColor(c.overAbsorbs.r, c.overAbsorbs.g, c.overAbsorbs.b, c.overAbsorbs.a)
		end

		if nameplate.HealCommBar.overHealAbsorb then
			nameplate.HealCommBar.overHealAbsorb:SetVertexColor(c.overHealAbsorbs.r, c.overHealAbsorbs.g, c.overHealAbsorbs.b, c.overHealAbsorbs.a)
		end
	elseif nameplate:IsElementEnabled('HealCommBar') then
		nameplate:DisableElement('HealCommBar')
	end
end

function NP.HealthClipFrame_HealComm(frame)
	local pred = frame.HealCommBar
	if pred then
		NP:SetAlpha_HealComm(pred, true)
		NP:SetVisibility_HealComm(pred)
	end
end

function NP:SetAlpha_HealComm(obj, show)
	obj.myBar:SetAlpha(show and 1 or 0)
	obj.otherBar:SetAlpha(show and 1 or 0)
	if obj.absorbBar then
		obj.absorbBar:SetAlpha(show and 1 or 0)
	end
	if obj.healAbsorbBar then
		obj.healAbsorbBar:SetAlpha(show and 1 or 0)
	end
end

function NP:SetVisibility_HealComm(obj)
	-- the first update is from `HealthClipFrame_HealComm`
	-- we set this variable to allow `Configure_HealComm` to
	-- update the elements overflow lock later on by option
	if not obj.allowClippingUpdate then
		obj.allowClippingUpdate = true
	end

	if obj.maxOverflow > 1 then
		obj.myBar:SetParent(obj.health)
		obj.otherBar:SetParent(obj.health)
		if obj.absorbBar then
			obj.absorbBar:SetParent(obj.health)
		end
		if obj.healAbsorbBar then
			obj.healAbsorbBar:SetParent(obj.health)
		end
	else
		obj.myBar:SetParent(obj.parent)
		obj.otherBar:SetParent(obj.parent)
		if obj.absorbBar then
			obj.absorbBar:SetParent(obj.parent)
		end
		if obj.healAbsorbBar then
			obj.healAbsorbBar:SetParent(obj.parent)
		end
	end
end

function NP:Construct_HealComm(frame)
	local health = frame.Health
	local parent = health.ClipFrame

	local myBar = E:CreateReversibleStatusBar(nil, parent)
	local otherBar = E:CreateReversibleStatusBar(nil, parent)
	local absorbBar = E:CreateReversibleStatusBar(nil, parent)
	local healAbsorbBar = E:CreateReversibleStatusBar(nil, parent)

	myBar:SetFrameLevel(health:GetFrameLevel()+2)
	otherBar:SetFrameLevel(health:GetFrameLevel()+2)
	absorbBar:SetFrameLevel(health:GetFrameLevel()+2)
	healAbsorbBar:SetFrameLevel(health:GetFrameLevel()+2)

	local texture = health:GetStatusBarTexture() or E.media.blankTex
	myBar:SetStatusBarTexture(texture)
	otherBar:SetStatusBarTexture(texture)
	absorbBar:SetStatusBarTexture(texture)
	healAbsorbBar:SetStatusBarTexture(texture)

	myBar:SetMinMaxValues(0, 1)
	myBar:SetValue(0)
	otherBar:SetMinMaxValues(0, 1)
	otherBar:SetValue(0)
	absorbBar:SetMinMaxValues(0, 1)
	absorbBar:SetValue(0)
	healAbsorbBar:SetMinMaxValues(0, 1)
	healAbsorbBar:SetValue(0)

	local healPrediction = {
		myBar = myBar,
		otherBar = otherBar,
		absorbBar = absorbBar,
		healAbsorbBar = healAbsorbBar,
		PostUpdate = NP.UpdateHealComm,
		maxOverflow = 1,
		health = health,
		parent = parent,
		frame = frame
	}

	NP:SetAlpha_HealComm(healPrediction)

	return healPrediction
end

function NP:Configure_HealComm(frame)
	local db = NP:PlateDB(frame)

	if db.health.enable and db.health.healPrediction then
		if not frame:IsElementEnabled('HealComm4') then
			frame:EnableElement('HealComm4')
		end

		local healPrediction = frame.HealCommBar
		local myBar = healPrediction.myBar
		local otherBar = healPrediction.otherBar
		local absorbBar = healPrediction.absorbBar
		local healAbsorbBar = healPrediction.healAbsorbBar
		local c = db.colors.healPrediction

		healPrediction.maxOverflow = 1 + (c.maxOverflow or 0)
		healPrediction.overflowHeals = c.overflowHeals
		healPrediction.overflowAbsorbs = c.overflowAbsorbs
		healPrediction.absorbs = frame.db.healPrediction.absorbs

		if healPrediction.allowClippingUpdate then
			NP:SetVisibility_HealComm(healPrediction)
		end

		local health = frame.Health
		local orientation = health:GetOrientation()
		local healthTexture = health:GetStatusBarTexture()
		local width = health:GetWidth()
		width = (width > 0 and width) or health.WIDTH
		local height = health:GetHeight()
		height = (height > 0 and height) or health.HEIGHT

		healPrediction.healthBarTexture = healthTexture
		healPrediction.myBarTexture = myBar:GetStatusBarTexture()
		healPrediction.otherBarTexture = otherBar:GetStatusBarTexture()

		myBar:SetOrientation(orientation)
		otherBar:SetOrientation(orientation)
		absorbBar:SetOrientation(orientation)
		healAbsorbBar:SetOrientation(orientation)

		healPrediction.cachedOrientation = orientation

		myBar._anchorState = nil
		otherBar._anchorState = nil
		absorbBar._anchorState = nil
		healAbsorbBar._anchorState = nil

		if orientation == "HORIZONTAL" then
			local p1 = "LEFT"
			local p2 = "RIGHT"

			healPrediction.anchor1 = p1
			healPrediction.anchor2 = p2

			myBar:SetSize(width, height)
			myBar:ClearAllPoints()
			myBar:Point("TOP", health)
			myBar:Point("BOTTOM", health)
			myBar:Point(p1, healthTexture, p2)
			myBar:SetReverseFill(false)

			otherBar:SetSize(width, height)
			otherBar:ClearAllPoints()
			otherBar:Point("TOP", health)
			otherBar:Point("BOTTOM", health)
			otherBar:Point(p1, healPrediction.myBarTexture, p2)
			otherBar:SetReverseFill(false)

			absorbBar:SetSize(width, height)
			absorbBar:ClearAllPoints()
			absorbBar:Point("TOP", health)
			absorbBar:Point("BOTTOM", health)
			absorbBar:Point(p1, healthTexture, p2)
			absorbBar:SetReverseFill(false)

			healAbsorbBar:SetSize(width, height)
			healAbsorbBar:ClearAllPoints()
			healAbsorbBar:Point("TOP", health)
			healAbsorbBar:Point("BOTTOM", health)
			healAbsorbBar:Point(p2, healthTexture, p2)
			healAbsorbBar:SetReverseFill(true)
		else -- VERTICAL
			local p1 = "BOTTOM"
			local p2 = "TOP"

			healPrediction.anchor1 = p1
			healPrediction.anchor2 = p2

			myBar:SetSize(width, height)
			myBar:ClearAllPoints()
			myBar:Point("LEFT", health)
			myBar:Point("RIGHT", health)
			myBar:Point(p1, healthTexture, p2)
			myBar:SetReverseFill(false)

			otherBar:SetSize(width, height)
			otherBar:ClearAllPoints()
			otherBar:Point("LEFT", health)
			otherBar:Point("RIGHT", health)
			otherBar:Point(p1, healPrediction.myBarTexture, p2)
			otherBar:SetReverseFill(false)

			absorbBar:SetSize(width, height)
			absorbBar:ClearAllPoints()
			absorbBar:Point("LEFT", health)
			absorbBar:Point("RIGHT", health)
			absorbBar:Point(p1, healthTexture, p2)
			absorbBar:SetReverseFill(false)

			healAbsorbBar:SetSize(width, height)
			healAbsorbBar:ClearAllPoints()
			healAbsorbBar:Point("LEFT", health)
			healAbsorbBar:Point("RIGHT", health)
			healAbsorbBar:Point(p2, healthTexture, p2)
			healAbsorbBar:SetReverseFill(true)
		end

		local hpc = NP.db.colors.healPrediction
		frame.HealCommBar.myBar:SetStatusBarColor(hpc.personal.r, hpc.personal.g, hpc.personal.b)
		frame.HealCommBar.otherBar:SetStatusBarColor(hpc.others.r, hpc.others.g, hpc.others.b)
		frame.HealCommBar.absorbBar:SetStatusBarColor(hpc.absorbs.r, hpc.absorbs.g, hpc.absorbs.b, hpc.absorbs.a)
		frame.HealCommBar.healAbsorbBar:SetStatusBarColor(hpc.healAbsorbs.r, hpc.healAbsorbs.g, hpc.healAbsorbs.b, hpc.healAbsorbs.a)

		if not healPrediction.absorbs then
			absorbBar:Hide()
			healAbsorbBar:Hide()
		end
	elseif frame:IsElementEnabled('HealComm4') then
		frame:DisableElement('HealComm4')
	end
end

local function AnchorPredictionBar(bar, health, orientation, anchorTexture, hasEnoughSpace, overflowMode, p1, p2, reverseAnchorTexture)
	local needsReverse = not overflowMode and not hasEnoughSpace
	local anchorKey = orientation .. (overflowMode and "O" or (hasEnoughSpace and "E" or "R"))
	if bar._anchorState == anchorKey and bar._reverseFill == needsReverse then
		return
	end

	bar._anchorState = anchorKey
	bar._reverseFill = needsReverse

	bar:ClearAllPoints()

	if orientation == "HORIZONTAL" then
		bar:Point("TOP", health)
		bar:Point("BOTTOM", health)
	else -- VERTICAL
		bar:Point("LEFT", health)
		bar:Point("RIGHT", health)
	end

	if overflowMode then
		bar:Point(p1, anchorTexture, p2)
		bar:SetReverseFill(false)
	elseif hasEnoughSpace then
		bar:Point(p1, anchorTexture, p2)
		bar:SetReverseFill(false)
	else
		local reverseAnchor = reverseAnchorTexture or health
		bar:Point(p2, reverseAnchor, p2)
		bar:SetReverseFill(true)
	end
end

function NP:UpdateHealComm(unit, myIncomingHeal, allIncomingHeal, totalAbsorb, myCurrentHealAbsorb, allHealAbsorb)
	if not self.frame or not self.health then return end

	local health = self.health
	local healthTexture = self.healthBarTexture
	if not healthTexture then
		healthTexture = health:GetStatusBarTexture()
		self.healthBarTexture = healthTexture
	end

	local currentHealth = UnitHealth(unit) or 0
	local maxHealth = UnitHealthMax(unit) or 1
	local missingHealth = maxHealth - currentHealth
	local otherIncomingHeal = allIncomingHeal - myIncomingHeal
	local totalIncomingHeal = myIncomingHeal + otherIncomingHeal

	local orientation = self.cachedOrientation or health:GetOrientation()
	local p1 = self.anchor1 or (orientation == "HORIZONTAL" and "LEFT" or "BOTTOM")
	local p2 = self.anchor2 or (orientation == "HORIZONTAL" and "RIGHT" or "TOP")

	local overflowHeals = self.overflowHeals or false
	local overflowAbsorbs = self.overflowAbsorbs or false

	AnchorPredictionBar(self.myBar, health, orientation, healthTexture, missingHealth >= myIncomingHeal, overflowHeals, p1, p2)
	AnchorPredictionBar(self.otherBar, health, orientation, self.myBarTexture, missingHealth >= totalIncomingHeal, overflowHeals, p1, p2)
	AnchorPredictionBar(self.absorbBar, health, orientation, healthTexture, missingHealth >= totalAbsorb, overflowAbsorbs, p1, p2)
	AnchorPredictionBar(self.healAbsorbBar, health, orientation, healthTexture, false, false, p1, p2, healthTexture)
end