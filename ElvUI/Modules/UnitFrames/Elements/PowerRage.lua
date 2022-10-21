local E, L, V, P, G = unpack(select(2, ...)); --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local UF = E:GetModule("UnitFrames")

--Lua functions
local random = random
--WoW API / Variables
local CreateFrame = CreateFrame

local _, ns = ...
local ElvUF = ns.oUF
assert(ElvUF, "ElvUI was unable to locate oUF.")

function UF:Construct_RageBar(frame, bg, text, textPos)
	local rage = CreateFrame("StatusBar", nil, frame)
	UF.statusbars[rage] = true

	rage.RaisedElementParent = CreateFrame("Frame", nil, rage)
	rage.RaisedElementParent:SetFrameLevel(rage:GetFrameLevel() + 100)
	rage.RaisedElementParent:SetAllPoints()

	rage.PostUpdate = self.PostUpdateRage
	rage.PostUpdateColor = self.PostUpdateRageColor

	if bg then
		rage.BG = rage:CreateTexture(nil, "BORDER")
		rage.BG:SetAllPoints()
		rage.BG:SetTexture(E.media.blankTex)
	end

	if text then
		rage.value = frame.RaisedElementParent:CreateFontString(nil, "OVERLAY")
		UF:Configure_FontString(rage.value)

		local x = -2
		if textPos == "LEFT" then
			x = 2
		end

		rage.value:Point(textPos, frame.Health, textPos, x, 0)

		rage.value.frequentUpdates = true
	end

	rage.colorDisconnected = false
	rage.colorTapping = false
	rage:CreateBackdrop("Default", nil, nil, self.thinBorders, true)

	local clipFrame = CreateFrame('Frame', nil, rage)
	clipFrame:SetAllPoints()
	clipFrame:EnableMouse(false)
	clipFrame.__frame = frame
	rage.ClipFrame = clipFrame

	return rage
end

function UF:Configure_Rage(frame)
	if not frame.VARIABLES_SET then return end
	local db = frame.db
	local rage = frame.Rage
	rage.origParent = frame

	if frame.USE_RAGEBAR then
		if not frame:IsElementEnabled("Rage") then
			frame:EnableElement("Rage")
			rage:Show()
		end

		E:SetSmoothing(rage, self.db.smoothbars)

		--Text
		local attachPoint = self:GetObjectAnchorPoint(frame, db.rage.attachTextTo)
		rage.value:ClearAllPoints()
		rage.value:Point(db.rage.position, attachPoint, db.rage.position, db.rage.xOffset, db.rage.yOffset)
		frame:Tag(rage.value, db.rage.text_format)

		if db.rage.attachTextTo == "Rage" then
			rage.value:SetParent(rage.RaisedElementParent)
		else
			rage.value:SetParent(frame.RaisedElementParent)
		end

		--Colors
		rage.colorClass = nil
		rage.colorReaction = nil
		rage.colorRage = nil

		if self.db.colors.rageclass then
			rage.colorClass = true
			rage.colorReaction = true
		else
			rage.colorRage = true
		end

		--Fix height in case it is lower than the theme allows
		local heightChanged = false
		if (not self.thinBorders and not E.PixelMode) and frame.RAGEBAR_HEIGHT < 7 then --A height of 7 means 6px for borders and just 1px for the actual rage statusbar
			frame.RAGEBAR_HEIGHT = 7
			if db.rage then db.rage.height = 7 end
			heightChanged = true
		elseif (self.thinBorders or E.PixelMode) and frame.RAGEBAR_HEIGHT < 3 then --A height of 3 means 2px for borders and just 1px for the actual rage statusbar
			frame.RAGEBAR_HEIGHT = 3
			if db.rage then db.rage.height = 3 end
			heightChanged = true
		end
		if heightChanged then
			--Update health size
			frame.BOTTOM_OFFSET = UF:GetHealthBottomOffset(frame)
			UF:Configure_HealthBar(frame)
		end

		--Position
		rage:ClearAllPoints()
		if frame.RAGEBAR_DETACHED then
			rage:Width(frame.RAGEBAR_WIDTH - ((frame.BORDER + frame.SPACING)*2))
			rage:Height(frame.RAGEBAR_HEIGHT - ((frame.BORDER + frame.SPACING)*2))
			if not rage.Holder or (rage.Holder and not rage.Holder.mover) then
				rage.Holder = CreateFrame("Frame", nil, rage)
				rage.Holder:Size(frame.RAGEBAR_WIDTH, frame.RAGEBAR_HEIGHT)
				rage.Holder:Point("BOTTOM", frame, "BOTTOM", 0, -20)
				rage:ClearAllPoints()
				rage:Point("BOTTOMLEFT", rage.Holder, "BOTTOMLEFT", frame.BORDER+frame.SPACING, frame.BORDER+frame.SPACING)
				--Currently only Player and Target can detach rage bars, so doing it this way is okay for now
				if frame.unitframeType and frame.unitframeType == "player" then
					E:CreateMover(rage.Holder, "PlayerRageBarMover", L["Player Ragebar"], nil, nil, nil, "ALL,SOLO", nil, "unitframe,player,rage")
				elseif frame.unitframeType and frame.unitframeType == "target" then
					E:CreateMover(rage.Holder, "TargetRageBarMover", L["Target Ragebar"], nil, nil, nil, "ALL,SOLO", nil, "unitframe,target,rage")
				end
			else
				rage.Holder:Size(frame.RAGEBAR_WIDTH, frame.RAGEBAR_HEIGHT)
				rage:ClearAllPoints()
				rage:Point("BOTTOMLEFT", rage.Holder, "BOTTOMLEFT", frame.BORDER+frame.SPACING, frame.BORDER+frame.SPACING)
				rage.Holder.mover:SetScale(1)
				rage.Holder.mover:SetAlpha(1)
			end

			rage:SetFrameLevel(50) --RaisedElementParent uses 100, we want lower value to allow certain icons and texts to appear above rage
		elseif frame.USE_RAGEBAR_OFFSET then
			local anchor = frame.Health
			if frame.USE_POWERBAR and frame.USE_POWERBAR_OFFSET then
				anchor = frame.Power
			end
			if frame.USE_ENERGYBAR and frame.USE_ENERGYBAR_OFFSET then
				anchor = frame.Energy
			end
			if frame.ORIENTATION == "LEFT" then
				rage:Point("TOPRIGHT", anchor, "TOPRIGHT", frame.RAGEBAR_OFFSET + (frame.HAPPINESS_WIDTH or 0), -frame.RAGEBAR_OFFSET)
				rage:Point("BOTTOMLEFT", anchor, "BOTTOMLEFT", frame.RAGEBAR_OFFSET, -frame.RAGEBAR_OFFSET)
			elseif frame.ORIENTATION == "MIDDLE" then
				local preOffset = 0
				if frame.USE_POWERBAR and frame.USE_POWERBAR_OFFSET then
					preOffset = preOffset + frame.POWERBAR_OFFSET
				end
				if frame.USE_ENERGYBAR and frame.USE_ENERGYBAR_OFFSET then
					preOffset = preOffset + frame.ENERGYBAR_OFFSET
				end

				rage:Point("TOPLEFT", frame, "TOPLEFT",
					frame.BORDER + frame.SPACING,
					-(preOffset + frame.RAGEBAR_OFFSET + frame.CLASSBAR_YOFFSET) --+ frame.BORDER - frame.SPACING)
				)
				rage:Point("BOTTOMRIGHT", frame, "BOTTOMRIGHT",
					-(frame.BORDER + frame.SPACING),
					frame.BORDER + frame.SPACING
				)
			else
				rage:Point("TOPLEFT", anchor, "TOPLEFT", -frame.RAGEBAR_OFFSET - (frame.HAPPINESS_WIDTH or 0), -frame.RAGEBAR_OFFSET)
				rage:Point("BOTTOMRIGHT", anchor, "BOTTOMRIGHT", -frame.RAGEBAR_OFFSET, -frame.RAGEBAR_OFFSET)
			end
			rage:SetFrameLevel(frame.Health:GetFrameLevel() - 7) --Health uses 10
		elseif frame.USE_INSET_RAGEBAR then
			rage:Height(frame.RAGEBAR_HEIGHT - (frame.BORDER + frame.SPACING) * 2)
			rage:Point("BOTTOMLEFT", frame.Health, "BOTTOMLEFT", frame.BORDER + frame.BORDER * 2, frame.BORDER + frame.BORDER * 2)
			rage:Point("BOTTOMRIGHT", frame.Health, "BOTTOMRIGHT", -(frame.BORDER + frame.BORDER * 2), frame.BORDER + frame.BORDER * 2)
			rage:SetFrameLevel(50)
		elseif frame.USE_MINI_RAGEBAR then
			local totalHeight = frame.RAGEBAR_HEIGHT - frame.BORDER
			if frame.USE_POWERBAR and frame.USE_MINI_POWERBAR then
				totalHeight = totalHeight + (frame.POWERBAR_HEIGHT - frame.BORDER)
			end
			if frame.USE_ENERGYBAR and frame.USE_MINI_ENERGYBAR then
				totalHeight = totalHeight + (frame.ENERGYBAR_HEIGHT - frame.BORDER)
			end
			local yPos = -(totalHeight / 2) + (frame.RAGEBAR_HEIGHT - frame.BORDER)

			if frame.ORIENTATION == "LEFT" then
				rage:Width(frame.RAGEBAR_WIDTH - frame.BORDER * 2)
				rage:Point("TOPRIGHT", frame.Health, "BOTTOMRIGHT",
					-(frame.BORDER * 2 + 4) - (frame.HAPPINESS_WIDTH or 0),
					yPos
				)
			elseif frame.ORIENTATION == "RIGHT" then
				rage:Width(frame.RAGEBAR_WIDTH - frame.BORDER*2)
				rage:Point("TOPLEFT", frame.Health, "BOTTOMLEFT",
					frame.BORDER * 2 + 4 + (frame.HAPPINESS_WIDTH or 0),
					yPos
				)
			else
				rage:Point("TOPLEFT", frame.Health, "BOTTOMLEFT",
					frame.BORDER * 2 + 4,
					yPos
				)
				rage:Point("TOPRIGHT", frame.Health, "BOTTOMRIGHT",
					-(frame.BORDER * 2 + 4) - (frame.HAPPINESS_WIDTH or 0),
					yPos
				)
			end

			rage:Height(frame.RAGEBAR_HEIGHT - (frame.BORDER + frame.SPACING) * 2)
			rage:SetFrameLevel(50)
		else -- Filled
			local anchor = frame.Energy.backdrop
			if not frame.USE_ENERGYBAR or frame.USE_ENERGYBAR_DETACHED or frame.USE_INSET_ENERGYBAR or frame.USE_MINI_ENERGYBAR then
				if not frame.USE_POWERBAR or frame.USE_POWERBAR_DETACHED or frame.USE_INSET_POWERBAR or frame.USE_MINI_POWERBAR then
					anchor = frame.Health.backdrop
				else anchor = frame.Power.backdrop end
			end
			rage:Point("TOPRIGHT", anchor, "BOTTOMRIGHT",
				-frame.BORDER,
				-frame.SPACING * 3
			)
			rage:Point("TOPLEFT", anchor, "BOTTOMLEFT",
				frame.BORDER,
				-frame.SPACING * 3
			)
			rage:Height(frame.RAGEBAR_HEIGHT - (frame.BORDER + frame.SPACING) * 2)

			rage:SetFrameLevel(frame.Health:GetFrameLevel() - 5)
		end

		--Hide mover until we detach again
		if not frame.RAGEBAR_DETACHED then
			if rage.Holder and rage.Holder.mover then
				rage.Holder.mover:SetScale(0.0001)
				rage.Holder.mover:SetAlpha(0)
			end
		end

		if db.rage.strataAndLevel and db.rage.strataAndLevel.useCustomStrata then
			rage:SetFrameStrata(db.rage.strataAndLevel.frameStrata)
		else
			rage:SetFrameStrata("LOW")
		end
		if db.rage.strataAndLevel and db.rage.strataAndLevel.useCustomLevel then
			rage:SetFrameLevel(db.rage.strataAndLevel.frameLevel)
			rage.backdrop:SetFrameLevel(rage:GetFrameLevel() - 1)
		end

		if frame.RAGEBAR_DETACHED and db.rage.parent == "UIPARENT" then
			rage:SetParent(E.UIParent)
		else
			rage:SetParent(frame)
		end
	elseif frame:IsElementEnabled("Rage") then
		frame:DisableElement("Rage")
		rage:Hide()
		frame:Tag(rage.value, "")
	end

	rage.custom_backdrop = UF.db.colors.customragebackdrop and UF.db.colors.rage_backdrop

	--Transparency Settings
	UF:ToggleTransparentStatusBar(UF.db.colors.transparentRage, rage, rage.BG, nil, UF.db.colors.invertRage)
end

local tokens = {[0] = "MANA", "RAGE", "FOCUS", "ENERGY", "RUNIC_POWER"}
function UF:PostUpdateRageColor()
	local parent = self.origParent or self:GetParent()

	if parent.isForced then
		local color = ElvUF.colors.rage[tokens[random(0, 4)]]
		self:SetValue(random(1, self.max))

		if not self.colorClass then
			self:SetStatusBarColor(color[1], color[2], color[3])

			if self.BG then
				UF:UpdateBackdropTextureColor(self.BG, color[1], color[2], color[3])
			end
		end
	end
end

function UF:PostUpdateRage(unit)
	local parent = self.origParent or self:GetParent()
	if parent.isForced then
		self:SetValue(random(1, self.max))
	end

	if parent.db and parent.db.rage and parent.db.rage.hideonnpc then
		UF:PostNamePosition(parent, unit)
	end

	--Force update to AdditionalPower in order to reposition text if necessary
	if parent:IsElementEnabled("AdditionalPower") then
		E:Delay(0.01, parent.AdditionalPower.ForceUpdate, parent.AdditionalPower) --Delay it slightly so Power text has a chance to clear itself first
	end
end
