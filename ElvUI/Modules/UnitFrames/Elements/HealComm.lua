local E, L, V, P, G = unpack(select(2, ...)); --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local UF = E:GetModule("UnitFrames")

--Lua functions
--WoW API / Variables
local CreateFrame = CreateFrame

function UF.HealthClipFrame_HealComm(frame)
	local pred = frame.HealCommBar
	if pred then
		UF:SetAlpha_HealComm(pred, true)
		UF:SetVisibility_HealComm(pred)
	end
end

function UF:SetAlpha_HealComm(obj, show)
	obj.myBar:SetAlpha(show and 1 or 0)
	obj.otherBar:SetAlpha(show and 1 or 0)
	obj.absorbBar:SetAlpha(show and 1 or 0)
	obj.healAbsorbBar:SetAlpha(show and 1 or 0)
end

function UF:SetVisibility_HealComm(obj)
	-- the first update is from `HealthClipFrame_HealComm`
	-- we set this variable to allow `Configure_HealComm` to
	-- update the elements overflow lock later on by option
	if not obj.allowClippingUpdate then
		obj.allowClippingUpdate = true
	end

	if obj.maxOverflow > 1 then
		obj.myBar:SetParent(obj.health)
		obj.otherBar:SetParent(obj.health)
		obj.absorbBar:SetParent(obj.health)
		obj.healAbsorbBar:SetParent(obj.health)
	else
		obj.myBar:SetParent(obj.parent)
		obj.otherBar:SetParent(obj.parent)
		obj.absorbBar:SetParent(obj.parent)
		obj.healAbsorbBar:SetParent(obj.parent)
	end
end

function UF:Construct_HealComm(frame)
	local health = frame.Health
	local parent = health.ClipFrame

	local myBar = E:CreateReversibleStatusBar(nil, parent)
	local otherBar = E:CreateReversibleStatusBar(nil, parent)
	local absorbBar = E:CreateReversibleStatusBar(nil, parent)
	local healAbsorbBar = E:CreateReversibleStatusBar(nil, parent)

	myBar:SetFrameLevel(12)
	otherBar:SetFrameLevel(12)
	absorbBar:SetFrameLevel(12)
	healAbsorbBar:SetFrameLevel(12)

	local texture = (not health.isTransparent and health:GetStatusBarTexture()) or E.media.blankTex
	myBar:SetStatusBarTexture(texture)
	otherBar:SetStatusBarTexture(texture)
	absorbBar:SetStatusBarTexture(texture)
	healAbsorbBar:SetStatusBarTexture(texture)

	local healPrediction = {
		myBar = myBar,
		otherBar = otherBar,
		absorbBar = absorbBar,
		healAbsorbBar = healAbsorbBar,
		PostUpdate = UF.UpdateHealComm,
		maxOverflow = 1,
		health = health,
		parent = parent,
		frame = frame
	}

	UF:SetAlpha_HealComm(healPrediction)

	return healPrediction
end

function UF:Configure_HealComm(frame)
	if frame.db.healPrediction and frame.db.healPrediction.enable then
		local healPrediction = frame.HealCommBar
		local myBar = healPrediction.myBar
		local otherBar = healPrediction.otherBar
		local absorbBar = healPrediction.absorbBar
		local healAbsorbBar = healPrediction.healAbsorbBar
		local c = self.db.colors.healPrediction

		healPrediction.maxOverflow = 1 + (c.maxOverflow or 0)
		healPrediction.overflowHeals = c.overflowHeals
		healPrediction.overflowAbsorbs = c.overflowAbsorbs

		if healPrediction.allowClippingUpdate then
			UF:SetVisibility_HealComm(healPrediction)
		end

		if not frame:IsElementEnabled("HealComm4") then
			frame:EnableElement("HealComm4")
		end

		if frame.db.health then
			local health = frame.Health
			local orientation = frame.db.health.orientation or health:GetOrientation()
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
			else
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
		end

		myBar:SetStatusBarColor(c.personal.r, c.personal.g, c.personal.b, c.personal.a)
		otherBar:SetStatusBarColor(c.others.r, c.others.g, c.others.b, c.others.a)
		absorbBar:SetStatusBarColor(c.absorbs.r, c.absorbs.g, c.absorbs.b, c.absorbs.a)
		healAbsorbBar:SetStatusBarColor(c.healAbsorbs.r, c.healAbsorbs.g, c.healAbsorbs.b, c.healAbsorbs.a)
	elseif frame:IsElementEnabled("HealComm4") then
		frame:DisableElement("HealComm4")
	end
end

local function AnchorPredictionBar(bar, health, orientation, anchorTexture, hasEnoughSpace, overflowMode, p1, p2, reverseAnchorTexture)
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

function UF:UpdateHealComm(unit, myIncomingHeal, allIncomingHeal, totalAbsorb, myCurrentHealAbsorb, allHealAbsorb)
	if not self.frame or not self.health then return end

	local health = self.health
	local healthTexture = self.healthBarTexture or health:GetStatusBarTexture()
	local orientation = health:GetOrientation()

	local currentHealth = UnitHealth(unit) or 0
	local maxHealth = UnitHealthMax(unit) or 1
	local missingHealth = maxHealth - currentHealth
	local otherIncomingHeal = allIncomingHeal - myIncomingHeal
	local totalIncomingHeal = myIncomingHeal + otherIncomingHeal

	local p1 = self.anchor1 or (orientation == "HORIZONTAL" and "LEFT" or "BOTTOM")
	local p2 = self.anchor2 or (orientation == "HORIZONTAL" and "RIGHT" or "TOP")

	local overflowHeals = self.overflowHeals or false
	local overflowAbsorbs = self.overflowAbsorbs or false

	AnchorPredictionBar(self.myBar, health, orientation, healthTexture, missingHealth >= myIncomingHeal, overflowHeals, p1, p2)
	AnchorPredictionBar(self.otherBar, health, orientation, self.myBarTexture, missingHealth >= totalIncomingHeal, overflowHeals, p1, p2)
	AnchorPredictionBar(self.absorbBar, health, orientation, healthTexture, missingHealth >= totalAbsorb, overflowAbsorbs, p1, p2)
	AnchorPredictionBar(self.healAbsorbBar, health, orientation, healthTexture, false, false, p1, p2, healthTexture)
end