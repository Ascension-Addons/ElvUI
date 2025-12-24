local E = unpack(select(2, ...))

local type = type
local assert = assert
local setmetatable = setmetatable
local CreateFrame = CreateFrame

local barFrame = CreateFrame("Frame")
local reversibleBar_SetScript = barFrame.SetScript

local function reversibleBar_Update(self, sizeChanged, width, height)
	local progress = (self.VALUE - self.MINVALUE) / (self.MAXVALUE - self.MINVALUE)

	local align1, align2
	local TLx, TLy, BLx, BLy, TRx, TRy, BRx, BRy
	local TLx_, TLy_, BLx_, BLy_, TRx_, TRy_, BRx_, BRy_
	local xprogress, yprogress

	width = width or self:GetWidth()
	height = height or self:GetHeight()

	if self.ORIENTATION == "HORIZONTAL" then
		xprogress = width * progress
		if self.FILLSTYLE == "CENTER" then
			align1, align2 = "TOP", "BOTTOM"
		elseif self.REVERSE or self.FILLSTYLE == "REVERSE" then
			align1, align2 = "TOPRIGHT", "BOTTOMRIGHT"
		else
			align1, align2 = "TOPLEFT", "BOTTOMLEFT"
		end
	elseif self.ORIENTATION == "VERTICAL" then
		yprogress = height * progress
		if self.FILLSTYLE == "CENTER" then
			align1, align2 = "LEFT", "RIGHT"
		elseif self.REVERSE or self.FILLSTYLE == "REVERSE" then
			align1, align2 = "TOPLEFT", "TOPRIGHT"
		else
			align1, align2 = "BOTTOMLEFT", "BOTTOMRIGHT"
		end
	end

	if self.ROTATE then
		TLx, TLy = 0.0, 1.0
		TRx, TRy = 0.0, 0.0
		BLx, BLy = 1.0, 1.0
		BRx, BRy = 1.0, 0.0
		TLx_, TLy_ = TLx, TLy
		TRx_, TRy_ = TRx, TRy
		BLx_, BLy_ = BLx * progress, BLy
		BRx_, BRy_ = BRx * progress, BRy
	else
		TLx, TLy = 0.0, 0.0
		TRx, TRy = 1.0, 0.0
		BLx, BLy = 0.0, 1.0
		BRx, BRy = 1.0, 1.0
		TLx_, TLy_ = TLx, TLy
		TRx_, TRy_ = TRx * progress, TRy
		BLx_, BLy_ = BLx, BLy
		BRx_, BRy_ = BRx * progress, BRy
	end

	if not sizeChanged then
		self.bg:ClearAllPoints()
		self.bg:SetAllPoints()
		self.bg:SetTexCoord(TLx, TLy, BLx, BLy, TRx, TRy, BRx, BRy)

		self.fg:ClearAllPoints()
		self.fg:SetPoint(align1)
		self.fg:SetPoint(align2)
		self.fg:SetTexCoord(TLx_, TLy_, BLx_, BLy_, TRx_, TRy_, BRx_, BRy_)
	end

	if xprogress then
		self.fg:SetWidth(xprogress > 0 and xprogress or 0.1)
	end
	if yprogress then
		self.fg:SetHeight(yprogress > 0 and yprogress or 0.1)
	end
end

local function reversibleBar_OnSizeChanged(self, width, height)
	reversibleBar_Update(self, true, width, height)
end

local function WithinRange(value, minValue, maxValue)
	return value >= minValue and value <= maxValue
end

local reversibleBar = setmetatable({
	MINVALUE = 0.0,
	MAXVALUE = 1.0,
	VALUE = 1.0,
	ROTATE = true,
	REVERSE = false,
	ORIENTATION = "HORIZONTAL",
	FILLSTYLE = "STANDARD",
	SetMinMaxValues = function(self, minValue, maxValue)
		assert(
			(type(minValue) == "number" and type(maxValue) == "number"),
			"Usage: StatusBar:SetMinMaxValues(number, number)"
		)

		if self.MINVALUE == minValue and self.MAXVALUE == maxValue then return end

		if maxValue > minValue then
			self.MINVALUE = minValue
			self.MAXVALUE = maxValue
		else
			self.MINVALUE = 0
			self.MAXVALUE = 1
		end

		if not self.VALUE or self.VALUE > self.MAXVALUE then
			self.VALUE = self.MAXVALUE
		elseif not self.VALUE or self.VALUE < self.MINVALUE then
			self.VALUE = self.MINVALUE
		end

		reversibleBar_Update(self)
	end,
	GetMinMaxValues = function(self)
		return self.MINVALUE, self.MAXVALUE
	end,
	SetValue = function(self, value)
		assert(type(value) == "number", "Usage: StatusBar:SetValue(number)")
		if WithinRange(value, self.MINVALUE, self.MAXVALUE) then
			if self.VALUE == value then return end
			self.VALUE = value
			reversibleBar_Update(self)
		end
	end,
	GetValue = function(self)
		return self.VALUE
	end,
	SetOrientation = function(self, orientation)
		if orientation == "HORIZONTAL" or orientation == "VERTICAL" then
			if self.ORIENTATION == orientation then return end
			self.ORIENTATION = orientation
			reversibleBar_Update(self)
		end
	end,
	GetOrientation = function(self)
		return self.ORIENTATION
	end,
	SetRotatesTexture = function(self, rotate)
		local newRotate = (rotate ~= nil and rotate ~= false)
		if self.ROTATE == newRotate then return end
		self.ROTATE = newRotate
		reversibleBar_Update(self)
	end,
	GetRotatesTexture = function(self)
		return self.ROTATE
	end,
	SetReverseFill = function(self, reverse)
		local newReverse = (reverse == true)
		if self.REVERSE == newReverse then return end
		self.REVERSE = newReverse
		reversibleBar_Update(self)
	end,
	GetReverseFill = function(self)
		return self.REVERSE
	end,
	SetFillStyle = function(self, style)
		assert(type(style) == "string" or style == nil, "Usage: StatusBar:SetFillStyle(string)")
		local newStyle = "STANDARD"
		if style and style:lower() == "center" then
			newStyle = "CENTER"
		elseif style and style:lower() == "reverse" then
			newStyle = "REVERSE"
		end

		if self.FILLSTYLE == newStyle then return end
		self.FILLSTYLE = newStyle
		reversibleBar_Update(self)
	end,
	GetFillStyle = function(self)
		return self.FILLSTYLE
	end,
	SetStatusBarTexture = function(self, texture)
		self.fg:SetTexture(texture)
		self.bg:SetTexture(texture)
	end,
	GetStatusBarTexture = function(self)
		return self.fg
	end,
	SetStatusBarColor = function(self, r, g, b, a)
		self.fg:SetVertexColor(r, g, b, a)
	end,
	GetStatusBarColor = function(self)
		return self.fg:GetVertexColor()
	end,
	SetVertexColor = function(self, r, g, b, a)
		self.fg:SetVertexColor(r, g, b, a)
	end,
	GetVertexColor = function(self)
		return self.fg:GetVertexColor()
	end,
	GetObjectType = function(self)
		return "StatusBar"
	end,
	IsObjectType = function(self, otype)
		return (otype == "StatusBar") and 1 or nil
	end,
	SetScript = function(self, event, callback)
		reversibleBar_SetScript(self, event, callback)
	end,
	Show = function(self)
		self:SetAlpha(1)
	end,
	Hide = function(self)
		self:SetAlpha(0)
	end,
	SetAlpha = function(self, alpha)
		self:GetParent().SetAlpha(self, alpha)
	end
}, {__index = barFrame})

local reversibleBar_mt = {__index = reversibleBar}

function E:CreateReversibleStatusBar(name, parent)
	local bar = setmetatable(CreateFrame("Frame", name, parent), reversibleBar_mt)
	bar.fg = bar.fg or bar:CreateTexture(name and "$parent.Texture", "ARTWORK")
	bar.bg = bar.bg or bar:CreateTexture(name and "$parent.Background", "BACKGROUND")
	bar.bg:Hide()

	bar:HookScript("OnSizeChanged", reversibleBar_OnSizeChanged)
	bar:SetRotatesTexture(false)
	return bar
end
