local E, L, V, P, G = unpack(select(2, ...)); --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local D = E:GetModule("DebugTools")

--Lua functions
local format = string.format
--WoW API / Variables
local GetCVarBool = GetCVarBool
local InCombatLockdown = InCombatLockdown

function D:ModifyErrorFrame()
	ScriptErrorsFrameScrollFrameText.cursorOffset = 0
	ScriptErrorsFrameScrollFrameText.cursorHeight = 0
	ScriptErrorsFrameScrollFrameText:SetScript("OnEditFocusGained", nil)

	local Orig_ScriptErrorsFrame_Update = ScriptErrorsFrame_Update
	ScriptErrorsFrame_Update = function(...)
		-- Sometimes the locals table does not have an entry for an index, which can cause an argument #6 error
		-- in Blizzard_DebugTools.lua:430 and then cause a C stack overflow, this will prevent that
		local index = ScriptErrorsFrame.index
		if not index or not ScriptErrorsFrame.order[index] then
			index = #(ScriptErrorsFrame.order)
		end

		if index > 0 then
			ScriptErrorsFrame.locals[index] = ScriptErrorsFrame.locals[index] or "No locals to dump"
		end

		Orig_ScriptErrorsFrame_Update(...)

		if GetCVarBool("scriptErrors") == 1 then
			-- Stop text highlighting again
			ScriptErrorsFrameScrollFrameText:HighlightText(0, 0)
		end
	end

	-- Unhighlight text when focus is hit
	ScriptErrorsFrameScrollFrameText:HookScript("OnEscapePressed", function(self)
		self:HighlightText(0, 0)
	end)

	ScriptErrorsFrame:Size(500, 300)
	ScriptErrorsFrameScrollFrame:Size(455, 229)

	ScriptErrorsFrameScrollFrameText:Width(455)

	local BUTTON_WIDTH = 75
	local BUTTON_HEIGHT = 24
	local BUTTON_SPACING = 2

	-- Add a first button
	local firstButton = CreateFrame("Button", nil, ScriptErrorsFrame, "UIPanelButtonTemplate")
	firstButton:SetPoint("BOTTOM", -((BUTTON_WIDTH + BUTTON_WIDTH/2) + (BUTTON_SPACING * 4)), 8)
	firstButton:SetText("First")
	firstButton:SetHeight(BUTTON_HEIGHT)
	firstButton:SetWidth(BUTTON_WIDTH)
	firstButton:SetScript("OnClick", function()
		ScriptErrorsFrame.index = 1
		ScriptErrorsFrame_Update()
	end)
	ScriptErrorsFrame.firstButton = firstButton

	-- add reload button
	local reloadButton = CreateFrame("Button", nil, ScriptErrorsFrame, "UIPanelButtonTemplate")
	reloadButton:SetPoint("LEFT", firstButton, "LEFT", -30, 0)
	reloadButton:SetText("R")
	reloadButton:SetHeight(BUTTON_HEIGHT)
	reloadButton:SetWidth(30)
	reloadButton:SetScript("OnClick", function()
		ReloadUI()
	end)
	ScriptErrorsFrame.reloadButton = reloadButton

	-- Also add a Last button for errors
	local lastButton = CreateFrame("Button", nil, ScriptErrorsFrame, "UIPanelButtonTemplate")
	lastButton:SetPoint("BOTTOMLEFT", ScriptErrorsFrame.next, "BOTTOMRIGHT", BUTTON_SPACING, 0)
	lastButton:SetHeight(BUTTON_HEIGHT)
	lastButton:SetWidth(BUTTON_WIDTH)
	lastButton:SetText("Last")
	lastButton:SetScript("OnClick", function()
		ScriptErrorsFrame.index = #(ScriptErrorsFrame.order)
		ScriptErrorsFrame_Update()
	end)
	ScriptErrorsFrame.lastButton = lastButton

	ScriptErrorsFrame.previous:ClearAllPoints()
	ScriptErrorsFrame.previous:SetPoint("BOTTOMLEFT", firstButton, "BOTTOMRIGHT", BUTTON_SPACING, 0)
	ScriptErrorsFrame.previous:SetWidth(BUTTON_WIDTH)
	ScriptErrorsFrame.previous:SetHeight(BUTTON_HEIGHT)

	ScriptErrorsFrame.next:ClearAllPoints()
	ScriptErrorsFrame.next:SetPoint("BOTTOMLEFT", ScriptErrorsFrame.previous, "BOTTOMRIGHT", BUTTON_SPACING, 0)
	ScriptErrorsFrame.next:SetWidth(BUTTON_WIDTH)
	ScriptErrorsFrame.next:SetHeight(BUTTON_HEIGHT)

	ScriptErrorsFrame.close:ClearAllPoints()
	ScriptErrorsFrame.close:SetPoint("BOTTOMRIGHT", -8, 8)
	ScriptErrorsFrame.close:SetSize(75, BUTTON_HEIGHT)

	ScriptErrorsFrame.indexLabel:ClearAllPoints()
	ScriptErrorsFrame.indexLabel:SetPoint("BOTTOMLEFT", 0, 12)
end

function D:ScriptErrorsFrame_UpdateButtons()
	local numErrors = #ScriptErrorsFrame.order
	local index = ScriptErrorsFrame.index
	if index == 0 then
		ScriptErrorsFrame.lastButton:Disable()
		ScriptErrorsFrame.firstButton:Disable()
	else
		if numErrors == 1 then
			ScriptErrorsFrame.lastButton:Disable()
			ScriptErrorsFrame.firstButton:Disable()
		else
			ScriptErrorsFrame.lastButton:Enable()
			ScriptErrorsFrame.firstButton:Enable()
		end
	end
end

function D:ScriptErrorsFrame_OnError(_, keepHidden)
	if keepHidden or self.MessagePrinted or not InCombatLockdown() or GetCVarBool("scriptErrors") ~= 1 then return end

	E:Print(L["|cFFE30000Lua error recieved. You can view the error message when you exit combat."])
	self.MessagePrinted = true
end

function D:PLAYER_REGEN_ENABLED()
	ScriptErrorsFrame:SetParent(UIParent)
	self.MessagePrinted = nil
end

function D:PLAYER_REGEN_DISABLED()
	ScriptErrorsFrame:SetParent(self.HideFrame)
end

function D:TaintError(event, addonName, addonFunc)
	if GetCVarBool("scriptErrors") ~= 1 or E.db.general.taintLog ~= true then return end
	ScriptErrorsFrame_OnError(format(L["%s: %s tried to call the protected function '%s'."], event, addonName or "<name>", addonFunc or "<func>"), false)
end

function D:StaticPopup_Show(name)
	if name == "ADDON_ACTION_FORBIDDEN" and E.db.general.taintLog ~= true then
		StaticPopup_Hide(name)
	end
end

function D:Initialize()
	self.Initialized = true
	self.HideFrame = CreateFrame("Frame")
	self.HideFrame:Hide()

	if not IsAddOnLoaded("Blizzard_DebugTools") then
		LoadAddOn("Blizzard_DebugTools")
	end

	self:ModifyErrorFrame()
	self:SecureHook("ScriptErrorsFrame_UpdateButtons")
	self:SecureHook("ScriptErrorsFrame_OnError")
	self:SecureHook("StaticPopup_Show")
	self:RegisterEvent("PLAYER_REGEN_DISABLED")
	self:RegisterEvent("PLAYER_REGEN_ENABLED")
end

local function InitializeCallback()
	D:Initialize()
end

E:RegisterModule(D:GetName(), InitializeCallback)