local E, L, V, P, G = unpack(select(2, ...)); --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local UF = E:GetModule("UnitFrames")

--Lua functions
local random = random
--WoW API / Variables
local CreateFrame = CreateFrame

local _, ns = ...
local ElvUF = ns.oUF
assert(ElvUF, "ElvUI was unable to locate oUF.")

function UF:Construct_EnergyBar(frame, bg, text, textPos)
	local energy = CreateFrame("StatusBar", nil, frame)
	UF.statusbars[energy] = true

	energy.RaisedElementParent = CreateFrame("Frame", nil, energy)
	energy.RaisedElementParent:SetFrameLevel(energy:GetFrameLevel() + 100)
	energy.RaisedElementParent:SetAllPoints()

	energy.PostUpdate = self.PostUpdateEnergy
	energy.PostUpdateColor = self.PostUpdateEnergyColor

	if bg then
		energy.BG = energy:CreateTexture(nil, "BORDER")
		energy.BG:SetAllPoints()
		energy.BG:SetTexture(E.media.blankTex)
	end

	if text then
		energy.value = frame.RaisedElementParent:CreateFontString(nil, "OVERLAY")
		UF:Configure_FontString(energy.value)

		local x = -2
		if textPos == "LEFT" then
			x = 2
		end

		energy.value:Point(textPos, frame.Health, textPos, x, 0)

		energy.value.frequentUpdates = true
	end

	energy.colorDisconnected = false
	energy.colorTapping = false
	energy:CreateBackdrop("Default", nil, nil, self.thinBorders, true)

	local clipFrame = CreateFrame('Frame', nil, energy)
	clipFrame:SetAllPoints()
	clipFrame:EnableMouse(false)
	clipFrame.__frame = frame
	energy.ClipFrame = clipFrame

	return energy
end

function UF:Configure_Energy(frame)
	if not frame.VARIABLES_SET then return end
	local db = frame.db
	local energy = frame.Energy
	energy.origParent = frame

	if frame.USE_ENERGYBAR and C_Player:IsHero() then
		if not frame:IsElementEnabled("Energy") then
			frame:EnableElement("Energy")
			energy:Show()
		end

		E:SetSmoothing(energy, self.db.smoothbars)

		--Text
		local attachPoint = self:GetObjectAnchorPoint(frame, db.energy.attachTextTo)
		energy.value:ClearAllPoints()
		energy.value:Point(db.energy.position, attachPoint, db.energy.position, db.energy.xOffset, db.energy.yOffset)
		frame:Tag(energy.value, db.energy.text_format)

		if db.energy.attachTextTo == "Energy" then
			energy.value:SetParent(energy.RaisedElementParent)
		else
			energy.value:SetParent(frame.RaisedElementParent)
		end

		--Colors
		energy.colorClass = nil
		energy.colorReaction = nil
		energy.colorEnergy = nil

		if self.db.colors.energyclass then
			energy.colorClass = true
			energy.colorReaction = true
		else
			energy.colorEnergy = true
		end

		--Fix height in case it is lower than the theme allows
		local heightChanged = false
		if (not self.thinBorders and not E.PixelMode) and frame.ENERGYBAR_HEIGHT < 7 then --A height of 7 means 6px for borders and just 1px for the actual energy statusbar
			frame.ENERGYBAR_HEIGHT = 7
			if db.energy then db.energy.height = 7 end
			heightChanged = true
		elseif (self.thinBorders or E.PixelMode) and frame.ENERGYBAR_HEIGHT < 3 then --A height of 3 means 2px for borders and just 1px for the actual energy statusbar
			frame.ENERGYBAR_HEIGHT = 3
			if db.energy then db.energy.height = 3 end
			heightChanged = true
		end
		if heightChanged then
			--Update health size
			frame.BOTTOM_OFFSET = UF:GetHealthBottomOffset(frame)
			UF:Configure_HealthBar(frame)
		end

		--Position
		energy:ClearAllPoints()
		if frame.ENERGYBAR_DETACHED then
			energy:Width(frame.ENERGYBAR_WIDTH - ((frame.BORDER + frame.SPACING)*2))
			energy:Height(frame.ENERGYBAR_HEIGHT - ((frame.BORDER + frame.SPACING)*2))
			if not energy.Holder or (energy.Holder and not energy.Holder.mover) then
				energy.Holder = CreateFrame("Frame", nil, energy)
				energy.Holder:Size(frame.ENERGYBAR_WIDTH, frame.ENERGYBAR_HEIGHT)
				energy.Holder:Point("BOTTOM", frame, "BOTTOM", 0, -20)
				energy:ClearAllPoints()
				energy:Point("BOTTOMLEFT", energy.Holder, "BOTTOMLEFT", frame.BORDER+frame.SPACING, frame.BORDER+frame.SPACING)
				--Currently only Player and Target can detach energy bars, so doing it this way is okay for now
				if frame.unitframeType and frame.unitframeType == "player" then
					E:CreateMover(energy.Holder, "PlayerEnergyBarMover", L["Player Energybar"], nil, nil, nil, "ALL,SOLO", nil, "unitframe,player,energy")
				elseif frame.unitframeType and frame.unitframeType == "target" then
					E:CreateMover(energy.Holder, "TargetEnergyBarMover", L["Target Energybar"], nil, nil, nil, "ALL,SOLO", nil, "unitframe,target,energy")
				end
			else
				energy.Holder:Size(frame.ENERGYBAR_WIDTH, frame.ENERGYBAR_HEIGHT)
				energy:ClearAllPoints()
				energy:Point("BOTTOMLEFT", energy.Holder, "BOTTOMLEFT", frame.BORDER+frame.SPACING, frame.BORDER+frame.SPACING)
				energy.Holder.mover:SetScale(1)
				energy.Holder.mover:SetAlpha(1)
			end

			energy:SetFrameLevel(50) --RaisedElementParent uses 100, we want lower value to allow certain icons and texts to appear above energy
		elseif frame.USE_ENERGYBAR_OFFSET then
			local anchor = frame.Health
			if frame.USE_POWERBAR and frame.USE_POWERBAR_OFFSET then
				anchor = frame.Power
			end
			if frame.ORIENTATION == "LEFT" then
				energy:Point("TOPRIGHT", anchor, "TOPRIGHT", frame.ENERGYBAR_OFFSET + (frame.HAPPINESS_WIDTH or 0), -frame.ENERGYBAR_OFFSET)
				energy:Point("BOTTOMLEFT", anchor, "BOTTOMLEFT", frame.ENERGYBAR_OFFSET, -frame.ENERGYBAR_OFFSET)
			elseif frame.ORIENTATION == "MIDDLE" then
				local preOffset = 0
				if frame.USE_POWERBAR and frame.USE_POWERBAR_OFFSET then
					preOffset = preOffset + frame.POWERBAR_OFFSET
				end
				local postOffset = 0
				if frame.USE_RAGEBAR and frame.USE_RAGEBAR_OFFSET then
					postOffset = postOffset + frame.RAGEBAR_OFFSET
				end

				energy:Point("TOPLEFT", frame, "TOPLEFT",
					frame.BORDER + frame.SPACING + postOffset,
					-(preOffset + frame.ENERGYBAR_OFFSET + frame.CLASSBAR_YOFFSET) --+ frame.BORDER - frame.SPACING)
				)
				energy:Point("BOTTOMRIGHT", frame, "BOTTOMRIGHT",
					-(frame.BORDER + frame.SPACING + postOffset),
					frame.BORDER + frame.SPACING + postOffset
				)
			else
				energy:Point("TOPLEFT", anchor, "TOPLEFT", -frame.ENERGYBAR_OFFSET - (frame.HAPPINESS_WIDTH or 0), -frame.ENERGYBAR_OFFSET)
				energy:Point("BOTTOMRIGHT", anchor, "BOTTOMRIGHT", -frame.ENERGYBAR_OFFSET, -frame.ENERGYBAR_OFFSET)
			end
			energy:SetFrameLevel(frame.Health:GetFrameLevel() - 6) --Health uses 10
		elseif frame.USE_INSET_ENERGYBAR then
			if frame.USE_INSET_RAGEBAR and frame.USE_RAGEBAR then
				energy:Point("BOTTOMLEFT", frame.Rage, "TOPLEFT",
					0,
					frame.BORDER * 2
				)
				energy:Point("BOTTOMRIGHT", frame.Rage, "TOPRIGHT",
					0,
					frame.BORDER * 2
				)
			else
				energy:Point("BOTTOMLEFT", frame.Health, "BOTTOMLEFT",
					frame.BORDER + frame.BORDER * 2,
					frame.BORDER + frame.BORDER * 2
				)
				energy:Point("BOTTOMRIGHT", frame.Health, "BOTTOMRIGHT",
					-(frame.BORDER + frame.BORDER * 2),
					frame.BORDER + frame.BORDER * 2
				)
			end

			energy:Height(frame.ENERGYBAR_HEIGHT - (frame.BORDER + frame.SPACING) * 2)
			energy:SetFrameLevel(50)
		elseif frame.USE_MINI_ENERGYBAR then
			local totalHeight = frame.ENERGYBAR_HEIGHT - frame.BORDER
			if frame.USE_POWERBAR and frame.USE_MINI_POWERBAR then
				totalHeight = totalHeight + (frame.POWERBAR_HEIGHT - frame.BORDER)
			end
			if frame.USE_RAGEBAR and frame.USE_MINI_RAGEBAR then
				totalHeight = totalHeight + (frame.RAGEBAR_HEIGHT - frame.BORDER)
			end
			local yPos = (totalHeight / 2) - (frame.POWERBAR_HEIGHT - frame.BORDER)

			if frame.ORIENTATION == "LEFT" then
				energy:Width(frame.ENERGYBAR_WIDTH - frame.BORDER * 2)
				energy:Point("TOPRIGHT", frame.Health, "BOTTOMRIGHT",
					-(frame.BORDER * 2 + 4) - (frame.HAPPINESS_WIDTH or 0),
					yPos
				)
			elseif frame.ORIENTATION == "RIGHT" then
				energy:Width(frame.ENERGYBAR_WIDTH - frame.BORDER*2)
				energy:Point("TOPLEFT", frame.Health, "BOTTOMLEFT",
					frame.BORDER * 2 + 4 + (frame.HAPPINESS_WIDTH or 0),
					yPos
				)
			else
				energy:Point("TOPLEFT", frame.Health, "BOTTOMLEFT",
					frame.BORDER * 2 + 4,
					yPos
				)
				energy:Point("TOPRIGHT", frame.Health, "BOTTOMRIGHT",
					-(frame.BORDER * 2 + 4) - (frame.HAPPINESS_WIDTH or 0),
					yPos
				)
			end

			energy:Height(frame.ENERGYBAR_HEIGHT - (frame.BORDER + frame.SPACING) * 2)
			energy:SetFrameLevel(50)
		else -- Filled
			local anchor = frame.Power.backdrop
			if not frame.USE_POWERBAR or frame.USE_POWERBAR_DETACHED or frame.USE_INSET_POWERBAR or frame.USE_MINI_POWERBAR then
				anchor = frame.Health.backdrop
			end
			energy:Point("TOPLEFT", anchor, "BOTTOMLEFT",
				frame.BORDER,
				-frame.SPACING * 3
			)
			energy:Point("TOPRIGHT", anchor, "BOTTOMRIGHT",
				-frame.BORDER,
				-frame.SPACING * 3
			)
			energy:Height(frame.ENERGYBAR_HEIGHT - (frame.BORDER + frame.SPACING) * 2)
			energy:SetFrameLevel(frame.Health:GetFrameLevel() - 5)
		end

		--Hide mover until we detach again
		if not frame.ENERGYBAR_DETACHED then
			if energy.Holder and energy.Holder.mover then
				energy.Holder.mover:SetScale(0.0001)
				energy.Holder.mover:SetAlpha(0)
			end
		end

		if db.energy.strataAndLevel and db.energy.strataAndLevel.useCustomStrata then
			energy:SetFrameStrata(db.energy.strataAndLevel.frameStrata)
		else
			energy:SetFrameStrata("LOW")
		end
		if db.energy.strataAndLevel and db.energy.strataAndLevel.useCustomLevel then
			energy:SetFrameLevel(db.energy.strataAndLevel.frameLevel)
			energy.backdrop:SetFrameLevel(energy:GetFrameLevel() - 1)
		end

		if frame.ENERGYBAR_DETACHED and db.energy.parent == "UIPARENT" then
			energy:SetParent(E.UIParent)
		else
			energy:SetParent(frame)
		end
	elseif frame:IsElementEnabled("Energy") then
		frame:DisableElement("Energy")
		energy:Hide()
		frame:Tag(energy.value, "")
	end

	energy.custom_backdrop = UF.db.colors.customenergybackdrop and UF.db.colors.energy_backdrop

	--Transparency Settings
	UF:ToggleTransparentStatusBar(UF.db.colors.transparentEnergy, energy, energy.BG, nil, UF.db.colors.invertEnergy)
end

local tokens = {[0] = "MANA", "RAGE", "FOCUS", "ENERGY", "RUNIC_POWER"}
function UF:PostUpdateEnergyColor()
	local parent = self.origParent or self:GetParent()

	if parent.isForced then
		local color = ElvUF.colors.energy[tokens[random(0, 4)]]
		self:SetValue(random(1, self.max))

		if not self.colorClass then
			self:SetStatusBarColor(color[1], color[2], color[3])

			if self.BG then
				UF:UpdateBackdropTextureColor(self.BG, color[1], color[2], color[3])
			end
		end
	end
end

function UF:PostUpdateEnergy(unit)
	local parent = self.origParent or self:GetParent()
	if parent.isForced then
		self:SetValue(random(1, self.max))
	end

	if parent.db and parent.db.energy and parent.db.energy.hideonnpc then
		UF:PostNamePosition(parent, unit)
	end

	--Force update to AdditionalPower in order to reposition text if necessary
	if parent:IsElementEnabled("AdditionalPower") then
		E:Delay(0.01, parent.AdditionalPower.ForceUpdate, parent.AdditionalPower) --Delay it slightly so Power text has a chance to clear itself first
	end
end
