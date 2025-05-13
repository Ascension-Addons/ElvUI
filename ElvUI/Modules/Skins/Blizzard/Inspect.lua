local E, L, V, P, G = unpack(select(2, ...)) -- Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local S = E:GetModule("Skins")

--Lua functions
local _G = _G
local unpack = unpack
--WoW API / Variables
local GetInventoryItemID = GetInventoryItemID
local GetItemInfo = GetItemInfo
local GetItemQualityColor = GetItemQualityColor

S:AddCallbackForAddon("Ascension_InspectUI", "Skin_InspectUI", function ()
	if not E.private.skins.blizzard.enable or not E.private.skins.blizzard.inspect then return end


	AscensionInspectFrame:StripTextures(true)
	AscensionInspectFrameNineSlice:StripTextures()
	AscensionInspectFrame:CreateBackdrop("Transparent")
	-- Cleanup Blizzard style Borders/Insets
	AscensionInspectFrameInset:StripTextures()
	AscensionInspectFrameRightInset:StripTextures()
	InspectPaperDollPanel:StripTextures(true)
	InspectPaperDollPanelModel:StripTextures(true)

	InspectPvPPanel:StripTextures(true)


	S:SetBackdropHitRect(AscensionInspectFrame)
	S:HandleCloseButton(AscensionInspectFrameCloseButton)
	
	S:HandleTabSystem(AscensionInspectFrame)
	-- TODO: Tab system for mystic enchant button continually updates after load - Ascension Bug?
	S:HandleTabSystem(AscensionInspectFrameRightInset)
	

	-- Stat Panel --
	InspectStatsPanel:StripTextures(true)
	InspectStatsPanel:CreateBackdrop("Default")
	S:HandleScrollList(InspectStatsPanel, function(button)
		S:HandleNextPrevButton(button.MoveDownButton, "down", nil, true)
		button.MoveDownButton:Size(16)
		button.MoveDownButton:SetPoint("RIGHT", -4, 1)
		S:HandleNextPrevButton(button.MoveUpButton, "up", nil, true)
		button.MoveUpButton:Size(16)
		button.MoveUpButton:SetPoint("RIGHT", button.MoveDownButton, "LEFT", 0, -1)
		local r, g, b, a = unpack(E.media.backdropfadecolor)
		button.Left:SetTexture(E.media.blankTex)
		button.Left:SetVertexColor(r, g, b, a)
		button.Right:SetTexture(E.media.blankTex)
		button.Right:SetVertexColor(r, g, b, a)
		button.Middle:SetTexture(E.media.blankTex)
		button.Middle:SetVertexColor(r, g, b, a)
	end)

	-- Mystic Enchant Panel
	InspectMysticEnchantPanel:StripTextures(true)
	InspectMysticEnchantPanel:CreateBackdrop("Default")
	S:HandleScrollList(InspectMysticEnchantPanel, function(button)
		button:GetNormalTexture():SetAllPoints()
		hooksecurefunc(button, "Update", function(self)
			self:SetNormalTexture(E.media.blankTex)
			local color = self.index % 2 == 0 and E.media.backdropcolor or E.media.backdropfadecolor
			self:GetNormalTexture():SetVertexColor(unpack(color))
		end)
	end)

	-- Handle item inspect frame
	local slots = {
		[1] = AscensionInspectHeadSlot,
		[2] = AscensionInspectNeckSlot,
		[3] = AscensionInspectShoulderSlot,
		[4] = AscensionInspectShirtSlot,
		[5] = AscensionInspectChestSlot,
		[6] = AscensionInspectWaistSlot,
		[7] = AscensionInspectLegsSlot,
		[8] = AscensionInspectFeetSlot,
		[9] = AscensionInspectWristSlot,
		[10] = AscensionInspectHandsSlot,
		[11] = AscensionInspectFinger0Slot,
		[12] = AscensionInspectFinger1Slot,
		[13] = AscensionInspectTrinket0Slot,
		[14] = AscensionInspectTrinket1Slot,
		[15] = AscensionInspectBackSlot,
		[16] = AscensionInspectMainHandSlot,
		[17] = AscensionInspectSecondaryHandSlot,
		[18] = AscensionInspectRangedSlot,
		[19] = AscensionInspectTabardSlot,
		[20] = AscensionInspectAmmoSlot, -- 0
	}

	for i, slotFrame in ipairs(slots) do
		local slotFrameName = slotFrame:GetName()
		local icon = _G[slotFrameName.."IconTexture"]

		slotFrame:StripTextures()
		slotFrame:SetFrameLevel(InspectPaperDollPanel:GetFrameLevel() + 2)
		slotFrame:CreateBackdrop("Default")
		slotFrame.backdrop:SetAllPoints()
		slotFrame.IconBorder:SetAlpha(0)

		slotFrame:StyleButton()

		icon:SetInside()
		icon:SetTexCoord(unpack(E.TexCoords))
		

		-- Set the item icon borders when Update function runs
		hooksecurefunc(slotFrame, "Update", function(button)
			if AscensionInspectFrame.unit then
				if button.hasItem then
					local itemID = GetInventoryItemID(AscensionInspectFrame.unit, button:GetID())
					if itemID then
						local _, _, quality = GetItemInfo(itemID)

						if not quality then
							E:Delay(0.1, awaitCache, button)
							return
						elseif quality then
							button.backdrop:SetBackdropBorderColor(GetItemQualityColor(quality))
							return
						end
					end
				end

				button.backdrop:SetBackdropBorderColor(unpack(E.media.bordercolor))
			end
		end)
	end

	-- Handle the Build tab
	InspectBuildPanel:StripTextures(true)
	InspectBuildPanel:CreateBackdrop("Default")
	HandleInspectBuildScrollFrame()
	InspectBuildPanelBuildScrollInset:StripTextures()

	InspectBuildPanelSpecs:StripTextures(true)
	InspectBuildPanelSpecs:CreateBackdrop("Default")
	S:HandleScrollList(InspectBuildPanelSpecs, function(button)
		button:GetNormalTexture():SetAllPoints()
		hooksecurefunc(button, "Update", function(self)
			self:SetNormalTexture(E.media.blankTex)
			local color = self.index % 2 == 0 and E.media.backdropcolor or E.media.backdropfadecolor
			self:GetNormalTexture():SetVertexColor(unpack(color))
		end)
	end)

end)

-- Ascension used custom-scroll frames which don't map directly to built-in ElvUI functions :(
function HandleInspectBuildScrollFrame()
	scrollList = InspectBuildPanel
	scrollListScroll = scrollList.BuildScroll
	if not scrollListScroll then return end
	scrollListScroll:StripTextures()

	local scrollBar = InspectBuildPanelBuildScrollScrollBar
	scrollBar:StripTextures()

	S:HandleNextPrevButton(InspectBuildPanelBuildScrollScrollBarScrollUpButton, 'up')
	InspectBuildPanelBuildScrollScrollBarScrollUpButton.Texture:SetAlpha(0)
	S:HandleNextPrevButton(InspectBuildPanelBuildScrollScrollBarScrollDownButton, 'down')
	InspectBuildPanelBuildScrollScrollBarScrollDownButton.Texture:SetAlpha(0)

	local thumb = scrollBar:GetThumbTexture()
	local function ThumbOnEnter(frame)
		local r, g, b = unpack(E.media.rgbvaluecolor)
		local thumb = frame.Thumb or frame
		if thumb.backdrop then
			thumb.backdrop:SetBackdropColor(r, g, b, .75)
		end
	end

	local function ThumbOnLeave(frame)
		local r, g, b = unpack(E.media.rgbvaluecolor)
		local thumb = frame.Thumb or frame

		if thumb.backdrop and not thumb.__isActive then
			thumb.backdrop:SetBackdropColor(r, g, b, .25)
		end
	end

	local function ThumbOnMouseDown(frame)
		local r, g, b = unpack(E.media.rgbvaluecolor)
		local thumb = frame.Thumb or frame
		thumb.__isActive = true

		if thumb.backdrop then
			thumb.backdrop:SetBackdropColor(r, g, b, .75)
		end
	end

	local function ThumbOnMouseUp(frame)
		local r, g, b = unpack(E.media.rgbvaluecolor)
		local thumb = frame.Thumb or frame
		thumb.__isActive = nil

		if thumb.backdrop then
			thumb.backdrop:SetBackdropColor(r, g, b, .25)
		end
	end

	if thumb then
		thumb.Begin:SetAlpha(0)
		thumb.End:SetAlpha(0)
		thumb.Middle:SetAlpha(0)
		thumb:CreateBackdrop('Transparent')
		thumb.backdrop:SetFrameLevel(thumb:GetFrameLevel()+1)

		local r, g, b = unpack(E.media.rgbvaluecolor)
		thumb.backdrop:SetBackdropColor(r, g, b, .25)
		thumb.backdrop:SetPoint("TOPLEFT", thumb.Begin)
		thumb.backdrop:SetPoint("BOTTOMRIGHT", thumb.End)

		thumb:HookScript('OnEnter', ThumbOnEnter)
		thumb:HookScript('OnLeave', ThumbOnLeave)
		thumb:HookScript('OnMouseUp', ThumbOnMouseUp)
		thumb:HookScript('OnMouseDown', ThumbOnMouseDown)
	end

	local children = {InspectBuildPanelBuildScrollChild:GetChildren()}

	for i, button in ipairs(children) do
		button:GetNormalTexture():SetAllPoints()
		hooksecurefunc(button, "Update", function(self)
			self:SetNormalTexture(E.media.blankTex)
			local color = i % 2 == 0 and E.media.backdropcolor or E.media.backdropfadecolor
			self:GetNormalTexture():SetVertexColor(unpack(color))
		end)
	end
end
