local _, ns = ...
local oUF = oUF or ns.oUF
if not oUF then return end

local UnitAura = UnitAura
local UnitCanAssist = UnitCanAssist

local function GetDebuffType(unit, filterTable)
	if not unit or not UnitCanAssist("player", unit) then return nil end

	local i = 1
	while true do
		local name, _, texture, _, debufftype, _, _, _, _, _, spellID = UnitAura(unit, i, "HARMFUL")
		if not texture then break end

		local filterSpell = filterTable[spellID] or filterTable[name]

		if filterTable and filterSpell and filterSpell.enable then
			return debufftype, texture, true, filterSpell.style, filterSpell.color
		elseif debufftype then
			return debufftype, texture
		end

		i = i + 1
	end
end

local function Update(object, event, unit)
	if unit and object.isNamePlate and unit:sub(1, 9) ~= "nameplate" then
		local isUnit = object.unit and UnitIsUnit(object.unit, unit)
		if isUnit then
			unit = object.unit
		end
	end
	if unit ~= object.unit then return end

	local debuffType, texture, wasFiltered, style, color = GetDebuffType(unit, object.DebuffHighlightFilterTable)

	if wasFiltered then
		if style == "GLOW" and object.DBHGlow then
			object.DBHGlow:Show()
			object.DBHGlow:SetBackdropBorderColor(color.r, color.g, color.b)
		elseif object.DBHGlow then
			object.DBHGlow:Hide()
			object.DebuffHighlight:SetVertexColor(color.r, color.g, color.b, color.a or object.DebuffHighlightAlpha or .5)
		end
	elseif debuffType then
		color = DebuffTypeColor[debuffType]

		if object.DebuffHighlightBackdrop and object.DBHGlow then
			object.DBHGlow:Show()
			object.DBHGlow:SetBackdropBorderColor(color.r, color.g, color.b)
		elseif object.DebuffHighlightUseTexture then
			object.DebuffHighlight:SetTexture(texture)
		else
			object.DebuffHighlight:SetVertexColor(color.r, color.g, color.b, object.DebuffHighlightAlpha or .5)
		end
	else
		if object.DBHGlow then
			object.DBHGlow:Hide()
		end

		if object.DebuffHighlightUseTexture then
			object.DebuffHighlight:SetTexture(nil)
		else
			object.DebuffHighlight:SetVertexColor(0, 0, 0, 0)
		end
	end

	if object.DebuffHighlight.PostUpdate then
		object.DebuffHighlight:PostUpdate(object, debuffType, texture, wasFiltered, style, color)
	end
end

local function Enable(object)
	-- if we're not highlighting this unit return
	if not object.DebuffHighlightBackdrop and not object.DebuffHighlight and not object.DBHGlow then
		return
	end

	-- make sure aura scanning is active for this object
	object:RegisterEvent("UNIT_AURA", Update)

	return true
end

local function Disable(object)
	object:UnregisterEvent("UNIT_AURA", Update)

	if object.DBHGlow then
		object.DBHGlow:Hide()
	end
end

oUF:AddElement("DebuffHighlight", Update, Enable, Disable)