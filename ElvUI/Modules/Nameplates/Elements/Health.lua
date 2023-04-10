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

function NP:Health_UpdateColor(_, unit)
	if unit and self.isNamePlate and unit:sub(1, 9) ~= "nameplate" then
		local isUnit = self.unit and UnitIsUnit(self.unit, unit)
		if isUnit then
			unit = self.unit
		end
	end
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

	if db.health.enable and db.health.healPrediction then
		if not nameplate:IsElementEnabled('HealCommBar') then
			nameplate:EnableElement('HealCommBar')
		end

		nameplate.HealCommBar.myBar:SetStatusBarColor(NP.db.colors.healPrediction.personal.r, NP.db.colors.healPrediction.personal.g, NP.db.colors.healPrediction.personal.b)
		nameplate.HealCommBar.otherBar:SetStatusBarColor(NP.db.colors.healPrediction.others.r, NP.db.colors.healPrediction.others.g, NP.db.colors.healPrediction.others.b)
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
	else
		obj.myBar:SetParent(obj.parent)
		obj.otherBar:SetParent(obj.parent)
	end
end

function NP:Construct_HealComm(frame)
	local health = frame.Health
	local parent = health.ClipFrame

	local myBar = CreateFrame("StatusBar", nil, parent)
	local otherBar = CreateFrame("StatusBar", nil, parent)

	myBar:SetFrameLevel(health:GetFrameLevel()+1)
	otherBar:SetFrameLevel(health:GetFrameLevel()+1)

	NP.StatusBars[myBar] = true
	NP.StatusBars[otherBar] = true

	local healPrediction = {
		myBar = myBar,
		otherBar = otherBar,
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
		local c = db.colors.healPrediction
		healPrediction.maxOverflow = 1 + (c.maxOverflow or 0)

		if healPrediction.allowClippingUpdate then
			NP:SetVisibility_HealComm(healPrediction)
		end

		local health = frame.Health
		local orientation = health:GetOrientation()
		
		local myBar = healPrediction.myBar
		local otherBar = healPrediction.otherBar

		myBar:SetOrientation(orientation)
		otherBar:SetOrientation(orientation)

		if orientation == "HORIZONTAL" then
			local width = health:GetWidth()
			width = (width > 0 and width) or health.WIDTH
			local healthTexture = health:GetStatusBarTexture()

			myBar:Size(width, 0)
			myBar:ClearAllPoints()
			myBar:Point("TOP", health, "TOP")
			myBar:Point("BOTTOM", health, "BOTTOM")
			myBar:Point("LEFT", healthTexture, "RIGHT")

			otherBar:Size(width, 0)
			otherBar:ClearAllPoints()
			otherBar:Point("TOP", health, "TOP")
			otherBar:Point("BOTTOM", health, "BOTTOM")
			otherBar:Point("LEFT", myBar:GetStatusBarTexture(), "RIGHT")
		else
			local height = health:GetHeight()
			height = (height > 0 and height) or health.HEIGHT
			local healthTexture = health:GetStatusBarTexture()

			myBar:Size(0, height)
			myBar:ClearAllPoints()
			myBar:Point("LEFT", health, "LEFT")
			myBar:Point("RIGHT", health, "RIGHT")
			myBar:Point("BOTTOM", healthTexture, "TOP")

			otherBar:Size(0, height)
			otherBar:ClearAllPoints()
			otherBar:Point("LEFT", health, "LEFT")
			otherBar:Point("RIGHT", health, "RIGHT")
			otherBar:Point("BOTTOM", myBar:GetStatusBarTexture(), "TOP")
		end

		frame.HealCommBar.myBar:SetStatusBarColor(NP.db.colors.healPrediction.personal.r, NP.db.colors.healPrediction.personal.g, NP.db.colors.healPrediction.personal.b)
		frame.HealCommBar.otherBar:SetStatusBarColor(NP.db.colors.healPrediction.others.r, NP.db.colors.healPrediction.others.g, NP.db.colors.healPrediction.others.b)
	elseif frame:IsElementEnabled('HealComm4') then
		frame:DisableElement('HealComm4')
	end
end

local function UpdateFillBar(frame, previousTexture, bar, amount)
	if amount == 0 then
		bar:Hide()
		return previousTexture
	end

	local orientation = frame:GetOrientation()
	bar:ClearAllPoints()
	if orientation == "HORIZONTAL" then
		bar:SetPoint("TOPLEFT", previousTexture, "TOPRIGHT")
		bar:SetPoint("BOTTOMLEFT", previousTexture, "BOTTOMRIGHT")
	else
		bar:SetPoint("BOTTOMRIGHT", previousTexture, "TOPRIGHT")
		bar:SetPoint("BOTTOMLEFT", previousTexture, "TOPLEFT")
	end

	local totalWidth, totalHeight = frame:GetSize()
	if orientation == "HORIZONTAL" then
		bar:Width(totalWidth)
	else
		bar:Height(totalHeight)
	end

	return bar:GetStatusBarTexture()
end

function NP:UpdateHealComm(_, myIncomingHeal, allIncomingHeal)
	local health = self.health
	local previousTexture = health:GetStatusBarTexture()

	previousTexture = UpdateFillBar(health, previousTexture, self.myBar, myIncomingHeal)
	UpdateFillBar(health, previousTexture, self.otherBar, allIncomingHeal)
end
