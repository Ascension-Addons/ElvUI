local E, L, V, P, G = unpack(ElvUI)
local S = E:GetModule("Skins")
local AS = E:GetModule("AddOnSkins")

if not AS:IsAddonLODorEnabled("AtlasLoot") then return end

local select = select
local unpack = unpack

-- AtlasLoot for Ascension

S:AddCallbackForAddon("AtlasLoot", "AtlasLoot", function()
	if not E.private.addOnSkins.AtlasLoot then return end

	AtlasLootTooltip:HookScript("OnShow", function(self)
		self:SetTemplate("Transparent", nil, true)

		local r, g, b = self:GetBackdropColor()
		self:SetBackdropColor(r, g, b, E.db.tooltip.colorAlpha)

		local iLink = select(2, self:GetItem())
		local quality = iLink and select(3, GetItemInfo(iLink))
		if quality and quality >= 2 then
			self:SetBackdropBorderColor(GetItemQualityColor(quality))
		else
			self:SetBackdropBorderColor(unpack(E["media"].bordercolor))
		end
	end)

	AtlasLootDefaultFrame:StripTextures()
	AtlasLootDefaultFrame:SetTemplate("Transparent")

	S:HandleCloseButton(AtlasLootDefaultFrame_CloseButton, AtlasLootDefaultFrame)

	S:HandleButton(AtlasLootDefaultFrame_Options)
	S:HandleButton(AtlasLootDefaultFrame_LoadModules)
	S:HandleButton(AtlasLootDefaultFrame_Menu)
	S:HandleButton(AtlasLootDefaultFrame_SubMenu)
	S:HandleButton(AtlasLootDefaultFrame_ExpansionMenu)
	S:HandleButton(AtlasLootDefaultFrame_LoadInstanceButton)
	S:HandleButton(AtlasLootDefaultFrame_MapButton)
	S:HandleButton(AtlasLootDefaultFrame_MapSelectButton)

	AtlasLootDefaultFrame_LootBackground_Back:SetTexture()
	AtlasLootDefaultFrame_LootBackground:SetTemplate("Transparent")

	S:HandleButton(AtlasLootDefaultFrame_Preset1)
	S:HandleButton(AtlasLootDefaultFrame_Preset2)
	S:HandleButton(AtlasLootDefaultFrame_Preset3)
	S:HandleButton(AtlasLootDefaultFrame_Preset4)

	S:HandleButton(AtlasLootDefaultFrameWishListButton)
	S:HandleEditBox(AtlasLootDefaultFrameSearchBox)
	S:HandleButton(AtlasLootDefaultFrameSearchButton)
	S:HandleNextPrevButton(AtlasLootDefaultFrameSearchOptionsButton)
	S:HandleButton(AtlasLootDefaultFrameSearchClearButton)
	S:HandleButton(AtlasLootDefaultFrameLastResultButton)
	S:HandleButton(AtlasLootDefaultFrameAdvancedSearchButton)

	Atlasloot_Difficulty_ScrollFrame:StripTextures()
	Atlasloot_Difficulty_ScrollFrame:SetTemplate("Transparent")
	Atlasloot_SubTableFrame:StripTextures()
	Atlasloot_SubTableFrame:SetTemplate("Transparent")

	AtlasLootDefaultFrame_Options:Point("TOPLEFT", AtlasLootDefaultFrame, "TOPLEFT", 40, -8)
	AtlasLootDefaultFrame_LoadModules:Point("TOPRIGHT", AtlasLootDefaultFrame, "TOPRIGHT", -30, -8)
	AtlasLootDefaultFrame_Menu:Point("TOPLEFT", AtlasLootDefaultFrame, "TOPLEFT", 40, -55)
	AtlasLootDefaultFrame_SelectedCategory:Point("BOTTOM", AtlasLootDefaultFrame_Menu, "TOP", 0, 6)
	AtlasLootDefaultFrame_SelectedTable:Point("BOTTOM", AtlasLootDefaultFrame_SubMenu, "TOP", 0, 6)
	AtlasLootDefaultFrame_SelectedTable2:Point("BOTTOM", AtlasLootDefaultFrame_ExpansionMenu, "TOP", 0, 6)
	AtlasLootDefaultFrame_ExpansionMenu:Point("RIGHT", AtlasLootDefaultFrame_LootBackground, "RIGHT", 0, 0)
	Atlasloot_Difficulty_ScrollFrame:Point("TOPLEFT", AtlasLootDefaultFrame_ExpansionMenu, "TOPRIGHT", 5, 0)
	Atlasloot_SubTableFrame:Point("BOTTOMLEFT", AtlasLootDefaultFrame_LootBackground, "BOTTOMRIGHT", 5, 0)
	AtlasLootDefaultFrame_Preset1:Point("LEFT", AtlasLootDefaultFrameWishListButton, "RIGHT", 5, 0)
	AtlasLootDefaultFrame_Preset4:Point("RIGHT", AtlasLootDefaultFrame_LootBackground, "RIGHT", 0, 0)
	AtlasLootDefaultFrame_MapSelectButton:Point("TOPLEFT", AtlasLootDefaultFrame_MapButton, "TOPRIGHT", 5, 0)
	AtlasLootDefaultFrame_MapSelectButton:Point("RIGHT", Atlasloot_SubTableFrame, "RIGHT", 0, 0)
	AtlasLootDefaultFrameSearchBox:Point("TOPLEFT", AtlasLootDefaultFrameWishListButton, "BOTTOMLEFT", 0, -6)
	AtlasLootDefaultFrameSearchBox:Point("BOTTOM", AtlasLootDefaultFrameWishListButton, "BOTTOM", 0, -28)
	AtlasLootDefaultFrameSearchButton:Point("LEFT", AtlasLootDefaultFrameSearchBox, "RIGHT", 5, 0)
	AtlasLootDefaultFrameSearchOptionsButton:Size(24)
	AtlasLootDefaultFrameSearchOptionsButton:Point("LEFT", AtlasLootDefaultFrameSearchButton, "RIGHT", 2, 0)
	AtlasLootDefaultFrameSearchClearButton:Point("LEFT", AtlasLootDefaultFrameSearchOptionsButton, "RIGHT", 5, 0)
	AtlasLootDefaultFrameLastResultButton:Point("LEFT", AtlasLootDefaultFrameSearchClearButton, "RIGHT", 5, 0)
	AtlasLootDefaultFrameAdvancedSearchButton:Point("LEFT", AtlasLootDefaultFrameLastResultButton, "RIGHT", 5, 0)
	AtlasLootDefaultFrame_LoadInstanceButton:Point("TOPLEFT", AtlasLootDefaultFrameAdvancedSearchButton, "TOPRIGHT", 5, 0)
	AtlasLootDefaultFrame_LoadInstanceButton:Point("BOTTOMLEFT", AtlasLootDefaultFrameAdvancedSearchButton, "BOTTOMRIGHT", 5, 0)
	AtlasLootDefaultFrame_LoadInstanceButton:Point("TOPRIGHT", AtlasLootDefaultFrame_MapSelectButton, "BOTTOMRIGHT", 0, -6)

	S:HandleCheckBox(AtlasLootFilterCheck)
	S:HandleButton(AtlasLootItemsFrame_BACK)
	S:HandleNextPrevButton(AtlasLootQuickLooksButton)
	S:HandleNextPrevButton(AtlasLootItemsFrame_PREV)
	S:HandleNextPrevButton(AtlasLootItemsFrame_NEXT)

	AtlasLootItemsFrame_Back:SetTexture()
	AtlasLootItemsFrame_BACK:Height(24)
	AtlasLootItemsFrame_BACK:Point("BOTTOM", 0, 3)

	AtlasLootFilterCheck:Point("BOTTOM", 115, 28)
	AtlasLootQuickLooksButton:Point("BOTTOM", 58, 32)

	AtlasLootItemsFrame_PREV:Point("BOTTOMLEFT", 7, 6)
	AtlasLootItemsFrame_NEXT:Point("BOTTOMRIGHT", -6, 6)

	-- Options Frame
	S:HandleCheckBox(AtlasLootOptionsFrameDefaultTT)
	S:HandleCheckBox(AtlasLootOptionsFrameLootlinkTT)
	S:HandleCheckBox(AtlasLootOptionsFrameItemSyncTT)
	S:HandleCheckBox(AtlasLootOptionsFrameOpaque)
	S:HandleCheckBox(AtlasLootOptionsFrameItemID)
	S:HandleCheckBox(AtlasLootOptionsFrameLoDStartup)
	S:HandleCheckBox(AtlasLootOptionsFrameSafeLinks)
	S:HandleCheckBox(AtlasLootOptionsFrameEquipCompare)
	S:HandleCheckBox(AtlasLootOptionsFrameAutoInstance)
	S:HandleDropDownBox(AtlasLoot_SelectLootBrowserStyle)
	S:HandleSliderFrame(AtlasLootOptionsFrameLootBrowserScale)
	S:HandleButton(AtlasLootOptionsFrame_ResetWishlist)
	S:HandleButton(AtlasLootOptionsFrame_ResetAtlasLoot)
	S:HandleButton(AtlasLootOptionsFrame_ResetQuicklooks)
	S:HandleButton(AtlasLootOptionsFrame_FuBarShow)
	if AtlasLootOptionsFrame_FuBarHide then
		S:HandleButton(AtlasLootOptionsFrame_FuBarHide)
	end

	AtlasLootOptionsFrameLootBrowserScale:Point("TOP", AtlasLoot_SelectLootBrowserStyle, "BOTTOM", -32, -24)

	-- TODO: Skin other option frames.

	-- Advanced Search Frame
	S:HandleCloseButton(AtlasLootDefaultFrame_AdvancedSearchPanel_CloseButton, AtlasLootDefaultFrame_AdvancedSearchPanel)
	S:HandleEditBox(AtlasLootDefaultFrame_AdvancedSearchPanel_SearchBox)
	S:HandleButton(AtlasLootDefaultFrame_AdvancedSearchPanel_QualityButton)
	S:HandleButton(	AtlasLootDefaultFrame_AdvancedSearchPanel_EquipButton)
	S:HandleButton(AtlasLootDefaultFrame_AdvancedSearchPanel_EquipSubButton)
	S:HandleEditBox(AtlasLootDefaultFrame_AdvancedSearchPanel_LevelMin)
	S:HandleEditBox(AtlasLootDefaultFrame_AdvancedSearchPanel_LevelMax)
	S:HandleEditBox(AtlasLootDefaultFrame_AdvancedSearchPanel_iLevelMin)
	S:HandleEditBox(AtlasLootDefaultFrame_AdvancedSearchPanel_iLevelMax)
	S:HandleCheckBox(AtlasLootDefaultFrame_AdvancedSearchPanel_LevelToggle)

	S:HandleButton(AtlasLootDefaultFrame_AdvancedSearchPanel_ArgumentContainerAddArgBtn)
	S:HandleButton(AtlasLootDefaultFrame_AdvancedSearchPanel_ArgumentContainerRemArgBtn)

	for i = 1, 6 do
		S:HandleButton(_G["AtlasLootDefaultFrame_AdvancedSearchPanel_ArgumentContainer"..i])
		local sub = _G["AtlasLootDefaultFrame_AdvancedSearchPanel_ArgumentContainer"..i.."Sub"]
		local editbox = _G["AtlasLootDefaultFrame_AdvancedSearchPanel_ArgumentContainer"..i.."Value"]

		S:HandleButton(sub)
		S:HandleEditBox(editbox)
		editbox:Point("TOP", sub, "TOP", 0, 0)
		editbox:Point("BOTTOM", sub, "BOTTOM", 0, 0)
	end

	S:HandleButton(AtlasLootDefaultFrame_AdvancedSearchPanel_SearchButton)
	S:HandleButton(AtlasLootDefaultFrame_AdvancedSearchPanel_ClearButton)

	AtlasLootDefaultFrame_AdvancedSearchPanel_CloseButton:Point("TOPRIGHT", AtlasLootDefaultFrame_LootBackground, "TOPRIGHT", -2, -3)
	AtlasLootDefaultFrame_AdvancedSearchPanel_SearchBox.title:Point("TOPLEFT", AtlasLootDefaultFrame_LootBackground, "TOPLEFT", 24, -49)
	AtlasLootDefaultFrame_AdvancedSearchPanel_SearchBox:Point("TOPLEFT", AtlasLootDefaultFrame_AdvancedSearchPanel_SearchBox.title, "BOTTOMLEFT", 0, -7)
	AtlasLootDefaultFrame_AdvancedSearchPanel_SearchBox:Point("BOTTOM", AtlasLootDefaultFrame_AdvancedSearchPanel_SearchBox.title, "BOTTOM", 0, -29)
	AtlasLootDefaultFrame_AdvancedSearchPanel_QualityButton.title:Point("TOPLEFT", AtlasLootDefaultFrame_LootBackground, "TOPLEFT", 309, -49)
	AtlasLootDefaultFrame_AdvancedSearchPanel_QualityButton:Point("TOPLEFT", AtlasLootDefaultFrame_AdvancedSearchPanel_QualityButton.title, "BOTTOMLEFT", 0, -6)

	AtlasLootDefaultFrame_AdvancedSearchPanel_EquipButton.title:Point("TOPLEFT", AtlasLootDefaultFrame_AdvancedSearchPanel_SearchBox, "BOTTOMLEFT", 0, -6)
	AtlasLootDefaultFrame_AdvancedSearchPanel_EquipButton:Point("TOPLEFT", AtlasLootDefaultFrame_AdvancedSearchPanel_EquipButton.title, "BOTTOMLEFT", 0, -6)
	AtlasLootDefaultFrame_AdvancedSearchPanel_EquipSubButton.title:Point("TOPLEFT", AtlasLootDefaultFrame_AdvancedSearchPanel_EquipButton.title, "TOPLEFT", 150, 0)
	AtlasLootDefaultFrame_AdvancedSearchPanel_EquipSubButton:Point("TOPLEFT", AtlasLootDefaultFrame_AdvancedSearchPanel_EquipSubButton.title, "BOTTOMLEFT", 0, -6)

	AtlasLootDefaultFrame_AdvancedSearchPanel_LevelMin.title:Point("TOPLEFT", AtlasLootDefaultFrame_AdvancedSearchPanel_EquipButton, "BOTTOMLEFT", 0, -6)
	AtlasLootDefaultFrame_AdvancedSearchPanel_LevelMin:Point("TOPLEFT", AtlasLootDefaultFrame_AdvancedSearchPanel_LevelMin.title, "BOTTOMLEFT", 0, -6)
	AtlasLootDefaultFrame_AdvancedSearchPanel_LevelMin:Point("BOTTOM", AtlasLootDefaultFrame_AdvancedSearchPanel_LevelMin.title, "BOTTOM", 0, -28)
	AtlasLootDefaultFrame_AdvancedSearchPanel_LevelMax:Point("TOPLEFT", AtlasLootDefaultFrame_AdvancedSearchPanel_LevelMin, "TOPRIGHT", 5, 0)
	AtlasLootDefaultFrame_AdvancedSearchPanel_LevelMax:Point("BOTTOM", AtlasLootDefaultFrame_AdvancedSearchPanel_LevelMin, "BOTTOM", 0, 0)
	AtlasLootDefaultFrame_AdvancedSearchPanel_iLevelMin.title:Point("TOPLEFT", AtlasLootDefaultFrame_AdvancedSearchPanel_LevelMin.title, "TOPLEFT", 150, 0)
	AtlasLootDefaultFrame_AdvancedSearchPanel_iLevelMin:Point("TOPLEFT", AtlasLootDefaultFrame_AdvancedSearchPanel_iLevelMin.title, "BOTTOMLEFT", 0, -6)
	AtlasLootDefaultFrame_AdvancedSearchPanel_iLevelMin:Point("BOTTOM", AtlasLootDefaultFrame_AdvancedSearchPanel_iLevelMin.title, "BOTTOM", 0, -28)
	AtlasLootDefaultFrame_AdvancedSearchPanel_iLevelMax:Point("TOPLEFT", AtlasLootDefaultFrame_AdvancedSearchPanel_iLevelMin, "TOPRIGHT", 5, 0)
	AtlasLootDefaultFrame_AdvancedSearchPanel_iLevelMax:Point("BOTTOM", AtlasLootDefaultFrame_AdvancedSearchPanel_iLevelMin, "BOTTOM", 0, 0)

	AtlasLootDefaultFrame_AdvancedSearchPanel_LevelToggle.title:Point("TOPLEFT", AtlasLootDefaultFrame_AdvancedSearchPanel_LevelMin, "BOTTOMLEFT", 0, -6)
	AtlasLootDefaultFrame_AdvancedSearchPanel_LevelToggle:Point("TOPRIGHT", AtlasLootDefaultFrame_AdvancedSearchPanel_LevelToggle.title, "TOPRIGHT", 29, 0)

	AtlasLootDefaultFrame_AdvancedSearchPanel_ArgumentContainer.title:Point("TOPLEFT", AtlasLootDefaultFrame_AdvancedSearchPanel_LevelToggle.title, "BOTTOMLEFT", 0, -8)
	AtlasLootDefaultFrame_AdvancedSearchPanel_ArgumentContainerAddArgBtn:Point("TOPLEFT", AtlasLootDefaultFrame_AdvancedSearchPanel_ArgumentContainer.title, "TOPRIGHT", 5, 0)

	AS:SkinLibrary("Dewdrop-2.0")
end)

S:AddCallbackForAddon("AtlasLootFu", "AtlasLootFu", function()
	AS:SkinLibrary("AceAddon-2.0")
	AS:SkinLibrary("Tablet-2.0")
end)