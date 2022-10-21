local E, L, V, P, G = unpack(select(2, ...)); --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local UF = E:GetModule("UnitFrames")

--Lua functions
local random = random
--WoW API / Variables
local CreateFrame = CreateFrame
local UnitIsTapped = UnitIsTapped
local UnitIsTappedByPlayer = UnitIsTappedByPlayer
local UnitReaction = UnitReaction
local UnitIsPlayer = UnitIsPlayer
local UnitClass = UnitClass
local UnitIsDeadOrGhost = UnitIsDeadOrGhost

local _, ns = ...
local ElvUF = ns.oUF
assert(ElvUF, "ElvUI was unable to locate oUF.")

function UF.HealthClipFrame_OnUpdate(clipFrame)
	UF.HealthClipFrame_HealComm(clipFrame.__frame)

	clipFrame:SetScript("OnUpdate", nil)
end

function UF:Construct_HealthBar(frame, bg, text, textPos)
	local health = CreateFrame("StatusBar", nil, frame)
	UF.statusbars[health] = true

	health:SetFrameLevel(10) --Make room for Portrait and Power which should be lower by default
	health.PostUpdate = self.PostUpdateHealth
	health.PostUpdateColor = self.PostUpdateHealthColor

	if bg then
		health.bg = health:CreateTexture(nil, "BORDER")
		health.bg:SetAllPoints()
		health.bg:SetTexture(E.media.blankTex)
		health.bg.multiplier = 0.25
	end

	if text then
		health.value = frame.RaisedElementParent:CreateFontString(nil, "OVERLAY")
		UF:Configure_FontString(health.value)

		local x = -2
		if textPos == "LEFT" then
			x = 2
		end

		health.value:Point(textPos, health, textPos, x, 0)
	end

	health.colorTapping = true
	health.colorDisconnected = true
	health:CreateBackdrop(nil, nil, nil, self.thinBorders, true)

	local clipFrame = CreateFrame("Frame", nil, health)
	clipFrame:SetScript("OnUpdate", UF.HealthClipFrame_OnUpdate)
	clipFrame:SetAllPoints()
	clipFrame:EnableMouse(false)
	clipFrame.__frame = frame
	health.ClipFrame = clipFrame

	return health
end

function UF:Configure_HealthBar(frame)
	if not frame.VARIABLES_SET then return end
	local db = frame.db
	local health = frame.Health

	E:SetSmoothing(health, self.db.smoothbars)

	--Text
	if db.health and health.value then
		local attachPoint = self:GetObjectAnchorPoint(frame, db.health.attachTextTo)
		health.value:ClearAllPoints()
		health.value:Point(db.health.position, attachPoint, db.health.position, db.health.xOffset, db.health.yOffset)
		frame:Tag(health.value, db.health.text_format)
	end

	--Colors
	health.colorSmooth = nil
	health.colorHealth = nil
	health.colorClass = nil
	health.colorReaction = nil

	if db.colorOverride and db.colorOverride == "FORCE_ON" then
		health.colorClass = true
		health.colorReaction = true
	elseif db.colorOverride and db.colorOverride == "FORCE_OFF" then
		if self.db.colors.colorhealthbyvalue then
			health.colorSmooth = true
		else
			health.colorHealth = true
		end
	else
		if self.db.colors.healthclass ~= true then
			if self.db.colors.colorhealthbyvalue then
				health.colorSmooth = true
			else
				health.colorHealth = true
			end
		else
			health.colorClass = (not self.db.colors.forcehealthreaction)
			health.colorReaction = true
		end
	end

	--Position
	health:ClearAllPoints()
	health.WIDTH = db.width
	health.HEIGHT = db.height

	if frame.ORIENTATION == "LEFT" then
		health:Point("TOPRIGHT", frame, "TOPRIGHT",
			-frame.BORDER - frame.SPACING - (frame.HAPPINESS_WIDTH or 0),
			-frame.BORDER - frame.SPACING - frame.CLASSBAR_YOFFSET
		)

		if frame.USE_POWERBAR_OFFSET or frame.USE_ENERGYBAR_OFFSET or frame.USE_RAGEBAR_OFFSET then
			local totalOffset = 0
			if frame.USE_POWERBAR and frame.USE_POWERBAR_OFFSET then
				totalOffset = totalOffset + frame.POWERBAR_OFFSET
			end
			if frame.USE_ENERGYBAR and frame.USE_ENERGYBAR_OFFSET then
				totalOffset = totalOffset + frame.ENERGYBAR_OFFSET
			end
			if frame.USE_RAGEBAR and frame.USE_RAGEBAR_OFFSET then
				totalOffset = totalOffset + frame.RAGEBAR_OFFSET
			end

			health:Point("TOPRIGHT", frame, "TOPRIGHT",
				-frame.BORDER - frame.SPACING - totalOffset - (frame.HAPPINESS_WIDTH or 0),
				-frame.BORDER - frame.SPACING - frame.CLASSBAR_YOFFSET
			)
			health:Point("BOTTOMLEFT", frame, "BOTTOMLEFT",
				frame.PORTRAIT_WIDTH + frame.BORDER + frame.SPACING,
				frame.BORDER + frame.SPACING + totalOffset
			)

			health.WIDTH = health.WIDTH - (frame.BORDER + frame.SPACING + totalOffset + (frame.HAPPINESS_WIDTH or 0)) - (frame.BORDER + frame.SPACING + frame.PORTRAIT_WIDTH)
			health.HEIGHT = health.HEIGHT - (frame.BORDER + frame.SPACING + frame.CLASSBAR_YOFFSET) - (frame.BORDER + frame.SPACING + totalOffset)
		elseif frame.POWERBAR_DETACHED or not frame.USE_POWERBAR or frame.USE_INSET_POWERBAR then
			health:Point("BOTTOMLEFT", frame, "BOTTOMLEFT", frame.PORTRAIT_WIDTH + frame.BORDER + frame.SPACING, frame.BORDER + frame.SPACING + frame.BOTTOM_OFFSET)

			health.WIDTH = health.WIDTH - (frame.BORDER + frame.SPACING + (frame.HAPPINESS_WIDTH or 0)) - (frame.BORDER + frame.SPACING + frame.PORTRAIT_WIDTH)
			health.HEIGHT = health.HEIGHT - (frame.BORDER + frame.SPACING + frame.CLASSBAR_YOFFSET) - (frame.BORDER + frame.SPACING + frame.BOTTOM_OFFSET)
		elseif frame.USE_MINI_POWERBAR or frame.USE_MINI_ENERGYBAR or frame.USE_MINI_RAGEBAR then
			local totalHeight = 0
			if frame.USE_POWERBAR and frame.USE_MINI_POWERBAR then
				totalHeight = totalHeight + (frame.POWERBAR_HEIGHT - frame.BORDER)
			end
			if frame.USE_ENERGYBAR and frame.USE_MINI_ENERGYBAR then
				totalHeight = totalHeight + (frame.ENERGYBAR_HEIGHT - frame.BORDER)
			end
			if frame.USE_RAGEBAR and frame.USE_MINI_RAGEBAR then
				totalHeight = totalHeight + (frame.RAGEBAR_HEIGHT - frame.BORDER)
			end
			health:Point("BOTTOMLEFT", frame, "BOTTOMLEFT",
				frame.PORTRAIT_WIDTH + frame.BORDER + frame.SPACING,
				frame.SPACING + (totalHeight / 2)
			)

			health.WIDTH = health.WIDTH - (frame.BORDER + frame.SPACING + (frame.HAPPINESS_WIDTH or 0)) - (frame.BORDER + frame.SPACING + frame.PORTRAIT_WIDTH)
			health.HEIGHT = health.HEIGHT - (frame.BORDER + frame.SPACING + frame.CLASSBAR_YOFFSET) - (frame.SPACING + totalHeight / 2)
		else
			health:Point("BOTTOMLEFT", frame, "BOTTOMLEFT",
				frame.PORTRAIT_WIDTH + frame.BORDER + frame.SPACING,
				frame.BORDER + frame.SPACING + frame.BOTTOM_OFFSET
			)

			health.WIDTH = health.WIDTH - (frame.BORDER + frame.SPACING + (frame.HAPPINESS_WIDTH or 0)) - (frame.BORDER + frame.SPACING + frame.PORTRAIT_WIDTH)
			health.HEIGHT = health.HEIGHT - (frame.BORDER + frame.SPACING + frame.CLASSBAR_YOFFSET) - (frame.BORDER + frame.SPACING + frame.BOTTOM_OFFSET)
		end
	elseif frame.ORIENTATION == "RIGHT" then
		health:Point("TOPLEFT", frame, "TOPLEFT", frame.BORDER + frame.SPACING + (frame.HAPPINESS_WIDTH or 0), -frame.BORDER - frame.SPACING - frame.CLASSBAR_YOFFSET)

		if frame.USE_POWERBAR_OFFSET or frame.USE_ENERGYBAR_OFFSET or frame.USE_RAGEBAR_OFFSET then
			local totalOffset = 0
			if frame.USE_POWERBAR and frame.USE_POWERBAR_OFFSET then
				totalOffset = totalOffset + frame.POWERBAR_OFFSET
			end
			if frame.USE_ENERGYBAR and frame.USE_ENERGYBAR_OFFSET then
				totalOffset = totalOffset + frame.ENERGYBAR_OFFSET
			end
			if frame.USE_RAGEBAR and frame.USE_RAGEBAR_OFFSET then
				totalOffset = totalOffset + frame.RAGEBAR_OFFSET
			end

			health:Point("TOPLEFT", frame, "TOPLEFT",
				frame.BORDER + frame.SPACING + totalOffset + (frame.HAPPINESS_WIDTH or 0),
				-frame.BORDER - frame.SPACING - frame.CLASSBAR_YOFFSET
			)
			health:Point("BOTTOMRIGHT", frame, "BOTTOMRIGHT",
				-frame.PORTRAIT_WIDTH - frame.BORDER - frame.SPACING,
				frame.BORDER + frame.SPACING + totalOffset
			)

			health.WIDTH = health.WIDTH - (frame.BORDER + frame.SPACING + totalOffset + (frame.HAPPINESS_WIDTH or 0)) - (frame.BORDER + frame.SPACING + frame.PORTRAIT_WIDTH)
			health.HEIGHT = health.HEIGHT - (frame.BORDER + frame.SPACING + frame.CLASSBAR_YOFFSET) - (frame.BORDER + frame.SPACING + totalOffset)
		elseif frame.POWERBAR_DETACHED or not frame.USE_POWERBAR or frame.USE_INSET_POWERBAR then
			health:Point("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -frame.PORTRAIT_WIDTH - frame.BORDER - frame.SPACING, frame.BORDER + frame.SPACING + frame.BOTTOM_OFFSET)

			health.WIDTH = health.WIDTH - (frame.BORDER + frame.SPACING + (frame.HAPPINESS_WIDTH or 0)) - (frame.BORDER + frame.SPACING + frame.PORTRAIT_WIDTH)
			health.HEIGHT = health.HEIGHT - (frame.BORDER + frame.SPACING + frame.CLASSBAR_YOFFSET) - (frame.BORDER + frame.SPACING + frame.BOTTOM_OFFSET)
		elseif frame.USE_MINI_POWERBAR or frame.USE_MINI_ENERGYBAR or frame.USE_MINI_RAGEBAR then
			local totalHeight = 0
			if frame.USE_POWERBAR and frame.USE_MINI_POWERBAR then
				totalHeight = totalHeight + (frame.POWERBAR_HEIGHT - frame.BORDER)
			end
			if frame.USE_ENERGYBAR and frame.USE_MINI_ENERGYBAR then
				totalHeight = totalHeight + (frame.ENERGYBAR_HEIGHT - frame.BORDER)
			end
			if frame.USE_RAGEBAR and frame.USE_MINI_RAGEBAR then
				totalHeight = totalHeight + (frame.RAGEBAR_HEIGHT - frame.BORDER)
			end
			health:Point("BOTTOMRIGHT", frame, "BOTTOMRIGHT",
				-frame.PORTRAIT_WIDTH - frame.BORDER - frame.SPACING,
				frame.SPACING + (totalHeight / 2)
			)

			health.WIDTH = health.WIDTH - (frame.BORDER + frame.SPACING + (frame.HAPPINESS_WIDTH or 0)) - (frame.BORDER + frame.SPACING + frame.PORTRAIT_WIDTH)
			health.HEIGHT = health.HEIGHT - (frame.BORDER + frame.SPACING + frame.CLASSBAR_YOFFSET) - (frame.SPACING + totalHeight / 2)
		else
			health:Point("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -frame.PORTRAIT_WIDTH - frame.BORDER - frame.SPACING, frame.BORDER + frame.SPACING + frame.BOTTOM_OFFSET)

			health.WIDTH = health.WIDTH - (frame.BORDER + frame.SPACING + (frame.HAPPINESS_WIDTH or 0)) - (frame.BORDER + frame.SPACING + frame.PORTRAIT_WIDTH)
			health.HEIGHT = health.HEIGHT - (frame.BORDER + frame.SPACING + frame.CLASSBAR_YOFFSET) - (frame.BORDER + frame.SPACING + frame.BOTTOM_OFFSET)
		end
	elseif frame.ORIENTATION == "MIDDLE" then
		health:Point("TOPRIGHT", frame, "TOPRIGHT", -frame.BORDER - frame.SPACING - (frame.HAPPINESS_WIDTH or 0), -frame.BORDER - frame.SPACING - frame.CLASSBAR_YOFFSET)

		if frame.USE_POWERBAR_OFFSET or frame.USE_ENERGYBAR_OFFSET or frame.USE_RAGEBAR_OFFSET then
			local totalOffset = 0
			if frame.USE_POWERBAR and frame.USE_POWERBAR_OFFSET then
				totalOffset = totalOffset + frame.POWERBAR_OFFSET
			end
			if frame.USE_ENERGYBAR and frame.USE_ENERGYBAR_OFFSET then
				totalOffset = totalOffset + frame.ENERGYBAR_OFFSET
			end
			if frame.USE_RAGEBAR and frame.USE_RAGEBAR_OFFSET then
				totalOffset = totalOffset + frame.RAGEBAR_OFFSET
			end

			health:Point("TOPRIGHT", frame, "TOPRIGHT",
				-frame.BORDER - frame.SPACING - totalOffset,
				-frame.BORDER - frame.SPACING - frame.CLASSBAR_YOFFSET
			)
			health:Point("BOTTOMLEFT", frame, "BOTTOMLEFT",
				frame.BORDER + frame.SPACING + totalOffset,
				frame.BORDER + frame.SPACING + totalOffset
			)

			health.WIDTH = health.WIDTH - (frame.BORDER + frame.SPACING + totalOffset) - (frame.BORDER + frame.SPACING + totalOffset)
			health.HEIGHT = health.HEIGHT - (frame.BORDER + frame.SPACING + frame.CLASSBAR_YOFFSET) - (frame.BORDER + frame.SPACING + totalOffset)
		elseif frame.POWERBAR_DETACHED or not frame.USE_POWERBAR or frame.USE_INSET_POWERBAR then
			health:Point("BOTTOMLEFT", frame, "BOTTOMLEFT", frame.BORDER + frame.SPACING, frame.BORDER + frame.SPACING + frame.BOTTOM_OFFSET)

			health.WIDTH = health.WIDTH - (frame.BORDER + frame.SPACING + (frame.HAPPINESS_WIDTH or 0)) - (frame.BORDER + frame.SPACING)
			health.HEIGHT = health.HEIGHT - (frame.BORDER + frame.SPACING + frame.CLASSBAR_YOFFSET) - (frame.BORDER + frame.SPACING + frame.BOTTOM_OFFSET)
		elseif frame.USE_MINI_POWERBAR then
			local totalHeight = 0
			if frame.USE_POWERBAR and frame.USE_MINI_POWERBAR then
				totalHeight = totalHeight + (frame.POWERBAR_HEIGHT - frame.BORDER)
			end
			if frame.USE_ENERGYBAR and frame.USE_MINI_ENERGYBAR then
				totalHeight = totalHeight + (frame.ENERGYBAR_HEIGHT - frame.BORDER)
			end
			if frame.USE_RAGEBAR and frame.USE_MINI_RAGEBAR then
				totalHeight = totalHeight + (frame.RAGEBAR_HEIGHT - frame.BORDER)
			end
			health:Point("BOTTOMLEFT", frame, "BOTTOMLEFT",
				frame.BORDER + frame.SPACING,
				frame.SPACING + (totalHeight / 2)
			)

			health.WIDTH = health.WIDTH - (frame.BORDER + frame.SPACING + (frame.HAPPINESS_WIDTH or 0)) - (frame.BORDER + frame.SPACING)
			health.HEIGHT = health.HEIGHT - (frame.BORDER + frame.SPACING + frame.CLASSBAR_YOFFSET) - (frame.SPACING + totalHeight / 2)
		else
			health:Point("BOTTOMLEFT", frame, "BOTTOMLEFT", frame.PORTRAIT_WIDTH + frame.BORDER + frame.SPACING, frame.BORDER + frame.SPACING + frame.BOTTOM_OFFSET)

			health.WIDTH = health.WIDTH - (frame.BORDER + frame.SPACING + (frame.HAPPINESS_WIDTH or 0)) - (frame.BORDER + frame.SPACING + frame.PORTRAIT_WIDTH)
			health.HEIGHT = health.HEIGHT - (frame.BORDER + frame.SPACING + frame.CLASSBAR_YOFFSET) - (frame.BORDER + frame.SPACING + frame.BOTTOM_OFFSET)
		end
	end

	if db.health then
		--Party/Raid Frames allow to change statusbar orientation
		if db.health.orientation then
			health:SetOrientation(db.health.orientation)
		end

		--Party/Raid Frames can toggle frequent updates
		if db.health.frequentUpdates == nil then
			db.health.frequentUpdates = true
		end

		--health:SetFrequentUpdates(db.health.frequentUpdates)
	end

	--Transparency Settings
	UF:ToggleTransparentStatusBar(UF.db.colors.transparentHealth, frame.Health, frame.Health.bg, true, nil)

	--Prediction Texture; keep under ToggleTransparentStatusBar
	UF:UpdatePredictionStatusBar(frame.HealthPrediction, frame.Health)

	--Highlight Texture
	UF:Configure_FrameGlow(frame)

	if frame:IsElementEnabled("Health") then
		frame.Health:ForceUpdate()
	end
end

function UF:GetHealthBottomOffset(frame)
	local bottomOffset = 0
	if frame.USE_POWERBAR and not frame.POWERBAR_DETACHED and not frame.USE_INSET_POWERBAR then
		bottomOffset = bottomOffset + frame.POWERBAR_HEIGHT - (frame.BORDER-frame.SPACING)
	end
	if frame.USE_ENERGYBAR and not frame.ENERGYBAR_DETACHED and not frame.USE_INSET_ENERGYBAR then
		bottomOffset = bottomOffset + frame.ENERGYBAR_HEIGHT - (frame.BORDER-frame.SPACING)
	end
	if frame.USE_RAGEBAR and not frame.RAGEBAR_DETACHED and not frame.USE_INSET_RAGEBAR then
		bottomOffset = bottomOffset + frame.RAGEBAR_HEIGHT - (frame.BORDER-frame.SPACING)
	end
	if frame.USE_INFO_PANEL then
		bottomOffset = bottomOffset + frame.INFO_PANEL_HEIGHT - (frame.BORDER - frame.SPACING)
	end

	return bottomOffset
end

function UF:PostUpdateHealthColor(unit, r, g, b)
	local parent = self:GetParent()
	local colors = E.db.unitframe.colors

	local newr, newg, newb -- fallback for bg if custom settings arent used
	if not b then r, g, b = colors.health.r, colors.health.g, colors.health.b end
	if (((colors.healthclass and colors.colorhealthbyvalue) or (colors.colorhealthbyvalue and parent.isForced) or colors.colorhealthbyvalue_threshold) and not (UnitIsTapped(unit) and not UnitIsTappedByPlayer(unit))) then
		local cur, max = self.cur or 1, self.max or 100
		if parent.isForced then
			cur = parent.forcedHealth or cur
			max = (cur > max and cur * 2) or max
		end
		if colors.colorhealthbyvalue then
			newr, newg, newb = ElvUF:ColorGradient(cur, max, 1, 0, 0, 1, 1, 0, r, g, b)
		elseif colors.colorhealthbyvalue_threshold then 
			local perc = cur / max
			if perc > 0.75 then
				if colors.colorhealthbyvalue_thresholdgradient then
					newr, newg, newb = ElvUF:ColorGradient(perc, 1, r, g, b, colors.threshold_75.r, colors.threshold_75.g, colors.threshold_75.b, r, g, b)
				else
					newr, newg, newb = r, g, b
				end
			elseif perc > 0.5 then
				if colors.colorhealthbyvalue_thresholdgradient then
					newr, newg, newb = ElvUF:ColorGradient(((perc / .5) + 1), 2.5, r, g, b, colors.threshold_50.r, colors.threshold_50.g, colors.threshold_50.b, colors.threshold_75.r, colors.threshold_75.g, colors.threshold_75.b)
				else
					newr, newg, newb = colors.threshold_75.r, colors.threshold_75.g, colors.threshold_75.b
				end
			elseif perc > 0.35 then
				if colors.colorhealthbyvalue_thresholdgradient then
					newr, newg, newb = ElvUF:ColorGradient(((perc / .35) + 1), 2.43, r, g, b, colors.threshold_35.r, colors.threshold_35.g, colors.threshold_35.b, colors.threshold_50.r, colors.threshold_50.g, colors.threshold_50.b)
				else
					newr, newg, newb = colors.threshold_50.r, colors.threshold_50.g, colors.threshold_50.b
				end
			elseif perc > 0.2 then
				if colors.colorhealthbyvalue_thresholdgradient then
					newr, newg, newb = ElvUF:ColorGradient(((perc / .2) + 1), 2.75, r, g, b, colors.threshold_20.r, colors.threshold_20.g, colors.threshold_20.b, colors.threshold_35.r, colors.threshold_35.g, colors.threshold_35.b)
				else
					newr, newg, newb = colors.threshold_35.r, colors.threshold_35.g, colors.threshold_35.b
				end
			else
				newr, newg, newb = colors.threshold_20.r, colors.threshold_20.g, colors.threshold_20.b
			end
		end
		self:SetStatusBarColor(newr, newg, newb)
	end

	if self.bg then
		self.bg.multiplier = (colors.healthMultiplier > 0 and colors.healthMultiplier) or 0.35

		if colors.useDeadBackdrop and UnitIsDeadOrGhost(unit) then
			self.bg:SetVertexColor(colors.health_backdrop_dead.r, colors.health_backdrop_dead.g, colors.health_backdrop_dead.b)
		elseif colors.customhealthbackdrop then
			self.bg:SetVertexColor(colors.health_backdrop.r, colors.health_backdrop.g, colors.health_backdrop.b)
		elseif colors.classbackdrop then
			local reaction, color = (UnitReaction(unit, "player"))

			if UnitIsPlayer(unit) then
				local _, Class = UnitClass(unit)
				color = parent.colors.class[Class]
			elseif reaction then
				color = parent.colors.reaction[reaction]
			end

			if color then
				self.bg:SetVertexColor(color[1] * self.bg.multiplier, color[2] * self.bg.multiplier, color[3] * self.bg.multiplier)
			end
		elseif newb then
			self.bg:SetVertexColor(newr * self.bg.multiplier, newg * self.bg.multiplier, newb * self.bg.multiplier)
		else
			self.bg:SetVertexColor(r * self.bg.multiplier, g * self.bg.multiplier, b * self.bg.multiplier)
		end
	end
end

function UF:PostUpdateHealth(_, _, max)
	local parent = self:GetParent()
	if parent.isForced then
		local cur = random(1, max or 100)
		parent.forcedHealth = cur
		self:SetValue(cur)
	else
		if parent.forcedHealth then
			parent.forcedHealth = nil
		end
	end
end
