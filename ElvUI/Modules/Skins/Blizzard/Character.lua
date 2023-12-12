local E, L, V, P, G = unpack(select(2, ...)) --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local S = E:GetModule("Skins")

--Lua functions
local _G = _G
local getmetatable = getmetatable
local ipairs = ipairs
local select = select
local unpack = unpack
local find = string.find
--WoW API / Variables
local GetCurrencyListInfo = GetCurrencyListInfo
local GetInventoryItemQuality = GetInventoryItemQuality
local GetInventoryItemTexture = GetInventoryItemTexture
local GetItemInfo = GetItemInfo
local GetItemQualityColor = GetItemQualityColor
local hooksecurefunc = hooksecurefunc

S:AddCallback("Skin_Character", function()
	if not E.private.skins.blizzard.enable or not E.private.skins.blizzard.character then return end

	-- CharacterFrame
	AscensionCharacterFrame:StripTextures(true)
	AscensionCharacterFrameNineSlice:StripTextures(true)
	AscensionCharacterFrameInset:StripTextures(true)
	AscensionCharacterFrame:CreateBackdrop("Transparent")
	S:HandleCloseButton(AscensionCharacterFrameCloseButton)

	AscensionPaperDollPanel:StripTextures(true)
	AscensionPaperDollPanelModel:StripTextures(true)

	S:HandleTabSystem(AscensionCharacterFrame)
	
	local popoutButtonOnEnter = function(self) self.icon:SetVertexColor(unpack(E.media.rgbvaluecolor)) end
	local popoutButtonOnLeave = function(self) self.icon:SetVertexColor(1, 1, 1) end

	local slots = {
		[1] = AscensionCharacterHeadSlot,
		[2] = AscensionCharacterNeckSlot,
		[3] = AscensionCharacterShoulderSlot,
		[4] = AscensionCharacterShirtSlot,
		[5] = AscensionCharacterChestSlot,
		[6] = AscensionCharacterWaistSlot,
		[7] = AscensionCharacterLegsSlot,
		[8] = AscensionCharacterFeetSlot,
		[9] = AscensionCharacterWristSlot,
		[10] = AscensionCharacterHandsSlot,
		[11] = AscensionCharacterFinger0Slot,
		[12] = AscensionCharacterFinger1Slot,
		[13] = AscensionCharacterTrinket0Slot,
		[14] = AscensionCharacterTrinket1Slot,
		[15] = AscensionCharacterBackSlot,
		[16] = AscensionCharacterMainHandSlot,
		[17] = AscensionCharacterSecondaryHandSlot,
		[18] = AscensionCharacterRangedSlot,
		[19] = AscensionCharacterTabardSlot,
		[20] = AscensionCharacterAmmoSlot, -- 0
	}

	for i, slotFrame in ipairs(slots) do
		local slotFrameName = slotFrame:GetName()
		local icon = _G[slotFrameName.."IconTexture"]

		slotFrame:StripTextures()
		slotFrame:StyleButton(false)
		slotFrame:SetTemplate("Default", true, true)
		slotFrame.IconBorder:SetAlpha(0)

		icon:SetInside()
		icon:SetTexCoord(unpack(E.TexCoords))

		slotFrame:SetFrameLevel(AscensionPaperDollPanel:GetFrameLevel() + 2)

		if i ~= 20 then
			local cooldown = _G[slotFrameName.."Cooldown"]
			local popout = _G[slotFrameName.."PopoutButton"]

			E:RegisterCooldown(cooldown)

			popout:StripTextures()
			popout:HookScript("OnEnter", popoutButtonOnEnter)
			popout:HookScript("OnLeave", popoutButtonOnLeave)

			popout.icon = popout:CreateTexture(nil, "ARTWORK")
			popout.icon:Size(24)
			popout.icon:Point("CENTER")
			popout.icon:SetTexture(E.Media.Textures.ArrowUp)

			if slotFrame.verticalFlyout then
				popout.icon:SetRotation(S.ArrowRotation.down)
			else
				popout.icon:SetRotation(S.ArrowRotation.right)
			end

			hooksecurefunc(popout, "SetOpenArtwork", function(self)
				if self:GetParent().verticalFlyout then
					self.icon:SetRotation(S.ArrowRotation.down)
				else
					self.icon:SetRotation(S.ArrowRotation.right)
				end
			end)

			hooksecurefunc(popout, "SetClosedArtwork", function(self)
				if self:GetParent().verticalFlyout then
					self.icon:SetRotation(S.ArrowRotation.up)
				else
					self.icon:SetRotation(S.ArrowRotation.left)
				end
			end)
		end
	end

	local function updateSlotFrame(self, event, slotID, exist)
		if event then
			self = slots[slotID]
		end

		if exist then
			local quality = GetInventoryItemQuality("player", slotID)

			if quality then
				self:SetBackdropBorderColor(GetItemQualityColor(quality))
			else
				self:SetBackdropBorderColor(unpack(E.media.bordercolor))
			end
		else
			self:SetBackdropBorderColor(unpack(E.media.bordercolor))
		end
	end

	local function colorItemBorder()
		for _, slotFrame in ipairs(slots) do
			local slotID = slotFrame:GetID()
			updateSlotFrame(slotFrame, nil, slotID, GetInventoryItemTexture("player", slotID) ~= nil)
		end
	end

	local f = CreateFrame("Frame")
	f:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")
	f:SetScript("OnEvent", updateSlotFrame)

	AscensionCharacterFrame:HookScript("OnShow", colorItemBorder)
	colorItemBorder()

	hooksecurefunc(EquipmentFlyoutFrame, "RefreshItems", function(self)
		for button in self.ButtonPool:EnumerateActive() do
			if not button.isSkinned then
				button.icon = _G[button:GetName().."IconTexture"]
				button.IconBorder:SetAlpha(0)
				button:GetNormalTexture():SetTexture(nil)
				button:SetTemplate("Default")
				button:StyleButton()
	
				button.icon:SetInside()
				button.icon:SetTexCoord(unpack(E.TexCoords))
	
				E:RegisterCooldown(button.Cooldown)
			end
	
			if not button.location or button.location >= PDFITEMFLYOUT_FIRST_SPECIAL_LOCATION then return end
	
			local id = EquipmentManager_GetItemInfoByLocation(button.location)
			local _, _, quality = GetItemInfo(id)
	
			button:SetBackdropBorderColor(GetItemQualityColor(quality))
		end
	end)

	-- Side tabs
	AscensionCharacterFrameRightInset:StripTextures(true)
	S:HandleTabSystem(AscensionCharacterFrameRightInset)

	-- Stat Panel
	AscensionCharacterStatsPanel:StripTextures(true)
	AscensionCharacterStatsPanel:CreateBackdrop("Default")
	S:HandleScrollList(AscensionCharacterStatsPanel, function(button)
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

	-- Title Panel
	AscensionCharacterTitlesPanel:StripTextures(true)
	AscensionCharacterTitlesPanel:CreateBackdrop("Default")
	S:HandleScrollList(AscensionCharacterTitlesPanel, function(button)
		button:StripTextures()
		button.Active:SetOutside(button)
		button.Active:SetTexCoord(0, 1, 0, 1)
		button.Active:SetTexture(E.media.blankTex)
		button.Active:SetBlendMode("BLEND")
		button.Active:SetAlpha(0.2)
		local r, g, b = unpack(E.media.rgbvaluecolor)
		button.Active:SetVertexColor(r, g, b)
	end)

	-- Equipment Manager
	AscensionCharacterEquipmentManagerPanel:StripTextures(true)
	AscensionCharacterEquipmentManagerPanel:CreateBackdrop("Default")
	S:HandleScrollList(AscensionCharacterEquipmentManagerPanel, function(button)
		button:StripTextures()
		S:HandleBorderIcon(button.Icon)

		hooksecurefunc(button, "Update", function(self)
			if self.index ~= 1 then
				self.Icon.Icon:SetTexCoord(unpack(E.TexCoords)) -- add set button will mess with tex coord
			end
			self:SetNormalTexture(E.media.blankTex)
			local color = self.index % 2 == 0 and E.media.backdropcolor or E.media.backdropfadecolor
			self:GetNormalTexture():SetVertexColor(unpack(color))
		end)
	end)

	-- Mystic Enchants
	AscensionCharacterMysticEnchantPanel:StripTextures(true)
	AscensionCharacterMysticEnchantPanel:CreateBackdrop("Default")
	S:HandleScrollList(AscensionCharacterMysticEnchantPanel, function(button)
		button:GetNormalTexture():SetAllPoints()
		hooksecurefunc(button, "Update", function(self)
			self:SetNormalTexture(E.media.blankTex)
			local color = self.index % 2 == 0 and E.media.backdropcolor or E.media.backdropfadecolor
			self:GetNormalTexture():SetVertexColor(unpack(color))
		end)
	end)

	-- Companions
	AscensionCharacterCompanionPanel:StripTextures(true)
	AscensionCharacterCompanionPanel:CreateBackdrop("Default")
	S:HandleScrollList(AscensionCharacterCompanionPanel, function(button)
		button:StripTextures()
		S:HandleBorderIcon(button.Icon)

		hooksecurefunc(button, "Update", function(self)
			self:SetNormalTexture(E.media.blankTex)
			self.Icon.Icon:SetTexCoord(unpack(E.TexCoords))
			local color = self.index % 2 == 0 and E.media.backdropcolor or E.media.backdropfadecolor
			self:GetNormalTexture():SetVertexColor(unpack(color))
		end)
	end)

	S:HandleEditBox(AscensionCharacterCompanionPanelSearchBox)

	-- PetPaperDollFrame
	AscensionPetPaperDollPanel:StripTextures(true)
	S:HandleTabSystem(AscensionPetPaperDollPanel)
	AscensionPetPaperDollPanelPetTab:StripTextures(true)
	AscensionPetPaperDollPanelPetTabOverlay:StripTextures(true)

	-- PetPaperDollFrame CompanionFrame
	AscensionPetPaperDollPanelCompanionTab:StripTextures(true)
	AscensionPetPaperDollPanelCompanionTabCompanionModel:StripTextures(true)
	AscensionPetPaperDollPanelCompanionTabCompanionModelOverlay:StripTextures(true)

	S:HandleButton(AscensionPetPaperDollPanelCompanionTabCompanionModelOverlaySummonButton)

	-- Reputation Frame
	AscensionReputationPanel:StripTextures(true)
	S:HandleScrollList(AscensionReputationPanelScrollList, function(button)
		button:StripTextures(true)
		button.ReputationBar.LeftTexture:SetTexture()
		button.ReputationBar.RightTexture:SetTexture()
		button.ReputationBar:SetStatusBarTexture(E.media.normTex)
		E:RegisterStatusBar(button.ReputationBar)
		button.ExpandOrCollapseButton:SetNormalTexture(E.Media.Textures.Minus)
		button.ExpandOrCollapseButton.SetNormalTexture = E.noop
		button.ExpandOrCollapseButton:GetNormalTexture():Size(15)
		button.ExpandOrCollapseButton:SetHighlightTexture(nil)

		hooksecurefunc(button, "Update", function(self)
			if self.isCollapsed then
				self.ExpandOrCollapseButton:GetNormalTexture():SetTexture(E.Media.Textures.Plus)
			else
				self.ExpandOrCollapseButton:GetNormalTexture():SetTexture(E.Media.Textures.Minus)
			end
		end)
	end)

	-- Reputation DetailFrame
	AscensionReputationPanelDetailsFrame:StripTextures()
	AscensionReputationPanelDetailsFrame:SetTemplate("Transparent")

	S:HandleCloseButton(AscensionReputationPanelDetailsFrameCloseButton, AscensionReputationPanelDetailsFrame)

	S:HandleCheckBox(AscensionReputationPanelDetailsFrameAtWarToggle)
	AscensionReputationPanelDetailsFrameAtWarToggle:SetCheckedTexture("Interface\\Buttons\\UI-CheckBox-SwordCheck")
	S:HandleCheckBox(AscensionReputationPanelDetailsFrameInactiveToggle)
	S:HandleCheckBox(AscensionReputationPanelDetailsFrameWatchToggle)

	-- Skill Frame
	AscensionSkillsPanel:StripTextures(true)

	S:HandleScrollList(AscensionSkillsPanelScrollList, function(button)
		button.StatusBar:SetStatusBarTexture(E.media.normTex)
		E:RegisterStatusBar(button.StatusBar)
		button.StatusBar.Border:SetTexture()
		button.ExpandIcon:Size(15)
		_G[button.StatusBar:GetName().."Background"]:SetTexture()

		hooksecurefunc(button, "Update", function(self)
			self.CategoryBackground:SetTexture()
			local _, _, isExpanded = GetSkillLineInfo(self.index)
			self.ExpandIcon:SetTexCoord(0, 1, 0, 1)
			if isExpanded then
				self.ExpandIcon:SetTexture(E.Media.Textures.Minus)
			else
				self.ExpandIcon:SetTexture(E.Media.Textures.Plus)
			end
		end)
	end)

	AscensionSkillsPanelDetailsFrame:StripTextures()
	AscensionSkillsPanelDetailsFrame:CreateBackdrop("Default")

	S:HandleCloseButton(AscensionSkillsPanelDetailsFrameCloseButton)
	S:HandleButton(AscensionSkillsPanelDetailsFrameAbandonButton)

	-- Token Frame
	AscensionCurrencyPanel:StripTextures(true)

	S:HandleScrollList(AscensionCurrencyPanelScrollList, function(button)
		button.ExpandIcon:SetTexCoord(0, 1, 0, 1)
		button.ExpandIcon:SetTexture(E.Media.Textures.Minus)
		button.ExpandIcon:Size(15)
		hooksecurefunc(button, "Update", function(self)
			self.CategoryBackground:SetTexture()
			local _, _, isExpanded = GetCurrencyListInfo(self.index)
			self.ExpandIcon:SetTexCoord(0, 1, 0, 1)
			if isExpanded then
				self.ExpandIcon:SetTexture(E.Media.Textures.Minus)
			else
				self.ExpandIcon:SetTexture(E.Media.Textures.Plus)
			end
		end)
	end)

	-- Token Frame Popup
	AscensionCurrencyPanelDetailsFrame:StripTextures()
	AscensionCurrencyPanelDetailsFrame:SetTemplate("Transparent")

	S:HandleCloseButton(AscensionCurrencyPanelDetailsFrameCloseButton, AscensionCurrencyPanelDetailsFrame)

	S:HandleCheckBox(AscensionCurrencyPanelDetailsFrameInactiveToggle)
	S:HandleCheckBox(AscensionCurrencyPanelDetailsFrameBackpackToggle)
end)