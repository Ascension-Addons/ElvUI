local _, ns = ...
local oUF = ns.oUF

local unpack = unpack

local GetPetHappiness = GetPetHappiness
local UnitClass = UnitClass
local UnitIsConnected = UnitIsConnected
local UnitIsPlayer = UnitIsPlayer
local UnitIsTapped = UnitIsTapped
local UnitIsTappedByPlayer = UnitIsTappedByPlayer
local UnitIsUnit = UnitIsUnit
local UnitPlayerControlled = UnitPlayerControlled
local UnitPower = UnitPower
local UnitPowerMax = UnitPowerMax
local UnitPowerType = UnitPowerType
local UnitReaction = UnitReaction

local function UpdateColor(self, event, unit)
	if(self.unit ~= unit) then return end
	local element = self.Rage

	local ptype, ptoken, altR, altG, altB = UnitPowerType(unit)
	local r, g, b
	local t = self.colors.power["RAGE"]
	if(element.colorDisconnected and element.disconnected) then
		t = self.colors.disconnected
	elseif(element.colorTapping and not UnitPlayerControlled(unit) and (UnitIsTapped(unit) and not UnitIsTappedByPlayer(unit) and not UnitIsTappedByAllThreatList(unit))) then
		t = self.colors.tapped
	elseif(element.colorThreat and not UnitPlayerControlled(unit) and UnitThreatSituation('player', unit)) then
		t =  self.colors.threat[UnitThreatSituation('player', unit)]
	elseif(element.colorHappiness and UnitIsUnit(unit, 'pet') and GetPetHappiness()) then
		t = self.colors.happiness[GetPetHappiness()]
	elseif(element.colorPower) then
		t = self.colors.power[ptoken or ptype]
		if(not t) then
			if(element.GetAlternativeColor) then
				r, g, b = element:GetAlternativeColor(unit, ptype, ptoken, altR, altG, altB)
			elseif(altR) then
				r, g, b = altR, altG, altB
			end
		end
	elseif(element.colorClass and UnitIsPlayer(unit)) or
		(element.colorClassNPC and not UnitIsPlayer(unit)) or
		(element.colorClassPet and UnitPlayerControlled(unit) and not UnitIsPlayer(unit)) then
		local _, class = UnitClass(unit)
		t = self.colors.class[class]
	elseif(element.colorReaction and UnitReaction(unit, 'player')) then
		t = self.colors.reaction[UnitReaction(unit, 'player')]
	elseif(element.colorSmooth) then
		r, g, b = self:ColorGradient(element.cur or 1, element.max or 1, unpack(element.smoothGradient or self.colors.smooth))
	end

	if(t) then
		r, g, b = t[1], t[2], t[3]
	end

	element:SetStatusBarTexture(element.texture)

	if(b) then
		element:SetStatusBarColor(r, g, b)
	end

	local bg = element.bg
	if(bg and b) then
		local mu = bg.multiplier or 1
		bg:SetVertexColor(r * mu, g * mu, b * mu)
	end

	if(element.PostUpdateColor) then
		element:PostUpdateColor(unit, r, g, b)
	end
end

local function ColorPath(self, ...)
	--[[ Override: Rage.UpdateColor(self, event, unit)
	Used to completely override the internal function for updating the widgets' colors.

	* self  - the parent object
	* event - the event triggering the update (string)
	* unit  - the unit accompanying the event (string)
	--]]
	(self.Rage.UpdateColor or UpdateColor) (self, ...)
end

local function Update(self, event, unit)
	if(self.unit ~= unit) then return end
	local element = self.Rage

	--[[ Callback: Rage:PreUpdate(unit)
	Called before the element has been updated.

	* self - the Rage element
	* unit - the unit for which the update has been triggered (string)
	--]]
	if(element.PreUpdate) then
		element:PreUpdate(unit)
	end

	local cur, max = UnitPower(unit, 1), UnitPowerMax(unit, 1)
	local disconnected = not UnitIsConnected(unit)
	if max == 0 then
		max = 1
	end

	element:SetMinMaxValues(0, max)

	if(disconnected) then
		element:SetValue(max)
	else
		element:SetValue(cur)
	end

	element.cur = cur
	element.max = max
	element.disconnected = disconnected

	--[[ Callback: Rage:PostUpdate(unit, cur, max)
	Called after the element has been updated.

	* self - the Rage element
	* unit - the unit for which the update has been triggered (string)
	* cur  - the unit's current rage value (number)
	* max  - the unit's maximum possible rage value (number)
	--]]
	if(element.PostUpdate) then
		element:PostUpdate(unit, cur, max)
	end
end

local function Path(self, ...)
	--[[ Override: Rage.Override(self, event, unit, ...)
	Used to completely override the internal update function.

	* self  - the parent object
	* event - the event triggering the update (string)
	* unit  - the unit accompanying the event (string)
	* ...   - the arguments accompanying the event
	--]]
	(self.Rage.Override or Update) (self, ...);

	ColorPath(self, ...)
end

local function ForceUpdate(element)
	Path(element.__owner, 'ForceUpdate', element.__owner.unit)
end

--[[ Rage:SetColorDisconnected(state)
Used to toggle coloring if the unit is offline.

* self  - the Rage element
* state - the desired state (boolean)
--]]
local function SetColorDisconnected(element, state)
	if(element.colorDisconnected ~= state) then
		element.colorDisconnected = state
		if(element.colorDisconnected) then
			element.__owner:RegisterEvent('UNIT_CONNECTION', ColorPath)
		else
			element.__owner:UnregisterEvent('UNIT_CONNECTION', ColorPath)
		end
	end
end

--[[ Rage:SetColorTapping(state)
Used to toggle coloring if the unit isn't tapped by the player.

* self  - the Rage element
* state - the desired state (boolean)
--]]
local function SetColorTapping(element, state)
	if(element.colorTapping ~= state) then
		element.colorTapping = state
		if(element.colorTapping) then
			element.__owner:RegisterEvent('UNIT_FACTION', ColorPath)
		else
			element.__owner:UnregisterEvent('UNIT_FACTION', ColorPath)
		end
	end
end

--[[ Rage:SetColorThreat(state)
Used to toggle coloring by the unit's threat status.

* self  - the Rage element
* state - the desired state (boolean)
--]]
local function SetColorThreat(element, state)
	if(element.colorThreat ~= state) then
		element.colorThreat = state
		if(element.colorThreat) then
			element.__owner:RegisterEvent('UNIT_THREAT_LIST_UPDATE', ColorPath)
		else
			element.__owner:UnregisterEvent('UNIT_THREAT_LIST_UPDATE', ColorPath)
		end
	end
end

--[[ Rage:SetColorHappiness(state)
Used to toggle coloring by the unit's happiness status.

* self  - the Rage element
* state - the desired state (boolean)
--]]
local function SetColorHappiness(element, state)
	if(element.colorHappiness ~= state) then
		element.colorHappiness = state
		if(element.colorHappiness) then
			element.__owner:RegisterEvent('UNIT_HAPPINESS', ColorPath)
		else
			element.__owner:UnregisterEvent('UNIT_HAPPINESS', ColorPath)
		end
	end
end


local function onRageUpdate(self)
	if(self.disconnected) then return end

	local unit = self.__owner.unit
	local rage = UnitPower(unit, 1)

	if(rage ~= self.rage) then
		self.rage = rage

		return Path(self.__owner, 'OnRageUpdate', unit)
	end
end

--[[ Rage:SetFrequentUpdates(state)
Used to toggle frequent updates.

* self  - the Rage element
* state - the desired state (boolean)
--]]
local function SetFrequentUpdates(element, state)
	--if(not unit or (unit ~= 'player' and unit ~= 'pet')) then return end

	if(element.frequentUpdates ~= state) then
		element.frequentUpdates = state
		if(element.frequentUpdates and not element:GetScript('OnUpdate')) then
			element:SetScript('OnUpdate', onRageUpdate)

			element.__owner:UnregisterEvent('UNIT_RAGE', Path)
		elseif(not element.frequentUpdates and element:GetScript('OnUpdate')) then
			element:SetScript('OnUpdate', nil)

			element.__owner:RegisterEvent('UNIT_RAGE', Path)
		end
	end
end

local function Enable(self, unit)
	local element = self.Rage
	if(element) then
		element.__owner = self
		element.ForceUpdate = ForceUpdate
		element.SetColorDisconnected = SetColorDisconnected
		element.SetColorTapping = SetColorTapping
		element.SetColorThreat = SetColorThreat
		element.SetColorHappiness = SetColorHappiness
		element.SetFrequentUpdates = SetFrequentUpdates

		if(element.colorDisconnected) then
			self:RegisterEvent('UNIT_CONNECTION', ColorPath)
		end

		if(element.colorTapping) then
			self:RegisterEvent('UNIT_FACTION', ColorPath)
		end

		if(element.colorThreat) then
			self:RegisterEvent('UNIT_THREAT_LIST_UPDATE', ColorPath)
		end

		if(element.colorHappiness) then
			self:RegisterEvent('UNIT_HAPPINESS', ColorPath)
		end

		-- if(element.frequentUpdates and (unit == 'player' or unit == 'pet')) then
		if((unit == 'player' or unit == 'pet')) then
			element:SetScript('OnUpdate', onRageUpdate)
		else
			self:RegisterEvent('UNIT_RAGE', Path)
		end

		self:RegisterEvent('UNIT_MAXRAGE', Path)

		if(element:IsObjectType('StatusBar')) then
			element.texture = element:GetStatusBarTexture() and element:GetStatusBarTexture():GetTexture() or [[Interface\TargetingFrame\UI-StatusBar]]
			element:SetStatusBarTexture(element.texture)
		end

		element:Show()

		return true
	end
end

local function Disable(self)
	local element = self.Rage
	if(element) then
		element:Hide()

		if(element:GetScript('OnUpdate')) then
			element:SetScript('OnUpdate', nil)
		else
			self:UnregisterEvent('UNIT_RAGE', Path)
		end

		self:UnregisterEvent('UNIT_MAXRAGE', Path)

		self:UnregisterEvent('UNIT_CONNECTION', ColorPath)
		self:UnregisterEvent('UNIT_THREAT_LIST_UPDATE', ColorPath)
		self:UnregisterEvent('UNIT_FACTION', ColorPath)
		self:UnregisterEvent('UNIT_HAPPINESS', ColorPath)
	end
end

oUF:AddElement('Rage', Path, Enable, Disable)
