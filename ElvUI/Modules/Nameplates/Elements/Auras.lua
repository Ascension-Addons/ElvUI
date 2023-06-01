local E, L, V, P, G = unpack(ElvUI)
local NP = E:GetModule('NamePlates')
local UF = E:GetModule('UnitFrames')
local LSM = E.Libs.LSM

local _G = _G
local wipe = wipe
local unpack = unpack
local CreateFrame = CreateFrame
local find = string.find

function NP:Construct_Auras(nameplate)
	local frameName = nameplate:GetName()

	local Buffs = CreateFrame('Frame', frameName..'Buffs', nameplate)
	Buffs:Size(1, 1)
	Buffs.size = 27
	Buffs.num = 4
	Buffs.spacing = E.Border * 2
	Buffs.onlyShowPlayer = false
	Buffs.disableMouse = true
	Buffs.isNamePlate = nameplate

	Buffs.initialAnchor = 'BOTTOMLEFT'
	Buffs.growthDirection = "RIGHT_UP"
	Buffs.type = 'buffs'
	Buffs.forceShow = nameplate == _G.ElvNP_Test
	Buffs.tickers = {} -- StyleFilters
	Buffs.stacks = {}
	Buffs.rows = {}

	local Debuffs = CreateFrame('Frame', frameName..'Debuffs', nameplate)
	Debuffs:Size(1, 1)
	Debuffs.size = 27
	Debuffs.num = 4
	Debuffs.spacing = E.Border * 2
	Debuffs.onlyShowPlayer = false
	Debuffs.disableMouse = true
	Debuffs.isNamePlate = nameplate
	Debuffs.initialAnchor = 'BOTTOMLEFT'
	Debuffs.growthDirection = "LEFT_UP"
	Debuffs.type = 'debuffs'
	Debuffs.forceShow = nameplate == _G.ElvNP_Test
	Debuffs.tickers = {} -- StyleFilters
	Debuffs.stacks = {}
	Debuffs.rows = {}

	Buffs.PreUpdate = UF.PreUpdateAura
	Buffs.PreSetPosition = UF.SortAuras
	Buffs.PostCreateIcon = NP.Construct_AuraIcon
	Buffs.PostUpdateIcon = UF.PostUpdateAura
	Buffs.CustomFilter = UF.AuraFilter

	Debuffs.PreUpdate = UF.PreUpdateAura
	Debuffs.PreSetPosition = UF.SortAuras
	Debuffs.PostCreateIcon = NP.Construct_AuraIcon
	Debuffs.PostUpdateIcon = UF.PostUpdateAura
	Debuffs.CustomFilter = UF.AuraFilter

	nameplate.Buffs_, nameplate.Debuffs_ = Buffs, Debuffs
	nameplate.Buffs, nameplate.Debuffs = Buffs, Debuffs
end

function NP:Construct_AuraIcon(button)
	if not button then return end
	local offset = UF.thinBorders and E.mult or E.Border
	button:SetTemplate(nil, nil, nil, UF.thinBorders, true)

	button.cd:SetReverse(true)
	button.cd:SetInside(button, offset, offset)

	button.icon:SetDrawLayer('ARTWORK')
	button.icon:SetInside(button, offset, offset)

	button.count:ClearAllPoints()
	button.count:Point('BOTTOMRIGHT', 1, 1)
	button.count:SetJustifyH('RIGHT')

	button.overlay:SetTexture()
	button.stealable:SetTexture()
	
	button.isNamePlate = true

	E:RegisterCooldown(button.cd, 'nameplates')

	local auras = button:GetParent()
	if auras and auras.type then
		local db = NP:PlateDB(auras.__owner)
		button.db = db[auras.type]
	end

	NP:UpdateAuraSettings(button)
end

function NP:Configure_Auras(nameplate, auras, db)
	auras.size = db.size
	auras.height = not db.keepSizeRatio and db.height
	auras.numAuras = db.numAuras
	auras.numRows = db.numRows
	auras.onlyShowPlayer = false
	auras.spacing = db.spacing
	auras.growthDirection = db.growthDirection or "RIGHT_UP"
	auras.xOffset = db.xOffset
	auras.yOffset = db.yOffset
	auras.anchorPoint = db.anchorPoint
	auras.auraSort = UF.SortAuraFuncs[db.sortMethod]
	auras.initialAnchor = E.InversePoints[db.anchorPoint]
	auras.filterList = UF:ConvertFilters(auras, db.priority)
	auras.smartPosition, auras.smartFluid = UF:SetSmartPosition(nameplate)
	auras.attachTo = UF:GetAuraAnchorFrame(nameplate, db.attachTo) -- keep below SetSmartPosition
	auras.num = db.numAuras * db.numRows
	auras.db = db -- for auraSort
	auras["growth-y"] = find(auras.growthDirection, "UP") and "UP" or "DOWN"
	auras["growth-x"] = find(auras.growthDirection, "RIGHT") and "RIGHT" or "LEFT"

	local index = 1
	while auras[index] do
		local button = auras[index]
		if button then
			button.db = db
			NP:UpdateAuraSettings(button)
			button:SetBackdropBorderColor(unpack(E.media.bordercolor))
		end

		index = index + 1
	end

	auras:ClearAllPoints()
	auras:Point(auras.initialAnchor, auras.attachTo, auras.anchorPoint, auras.xOffset, auras.yOffset)
	auras:Size(db.numAuras * db.size + ((db.numAuras - 1) * db.spacing), 1)
end

function NP:Update_Auras(nameplate)
	local db = NP:PlateDB(nameplate)

	if db.debuffs.enable or db.buffs.enable then
		if not nameplate:IsElementEnabled('Auras') then
			nameplate:EnableElement('Auras')
		end

		nameplate.Buffs_:ClearAllPoints()
		nameplate.Debuffs_:ClearAllPoints()

		if db.debuffs.enable then
			nameplate.Debuffs = nameplate.Debuffs_
			NP:Configure_Auras(nameplate, nameplate.Debuffs, db.debuffs)
			nameplate.Debuffs:Show()
			nameplate.Debuffs:ForceUpdate()
		elseif nameplate.Debuffs then
			nameplate.Debuffs:Hide()
			nameplate.Debuffs = nil
		end

		if db.buffs.enable then
			nameplate.Buffs = nameplate.Buffs_
			NP:Configure_Auras(nameplate, nameplate.Buffs, db.buffs)
			nameplate.Buffs:Show()
			nameplate.Buffs:ForceUpdate()
		elseif nameplate.Buffs then
			nameplate.Buffs:Hide()
			nameplate.Buffs = nil
		end
	elseif nameplate:IsElementEnabled('Auras') then
		nameplate:DisableElement('Auras')
	end
end

function NP:UpdateAuraSettings(button)
	local db = button.db
	if db then
		local point = db.countPosition or 'CENTER'
		button.count:ClearAllPoints()
		button.count:SetJustifyH(point:find('RIGHT') and 'RIGHT' or 'LEFT')
		button.count:Point(point, db.countXOffset, db.countYOffset)
		button.count:FontTemplate(LSM:Fetch('font', db.countFont), db.countFontSize, db.countFontOutline)
	end

	if button.icon then
		button.icon:SetTexCoord(unpack(E.TexCoords))
	end

	if button.auraInfo then
		wipe(button.auraInfo)
	else
		button.auraInfo = {}
	end

	button.needsButtonTrim = true
	button.needsUpdateCooldownPosition = true
end
