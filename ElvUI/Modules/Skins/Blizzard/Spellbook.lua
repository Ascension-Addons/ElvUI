local E, L, V, P, G = unpack(select(2, ...)) --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local S = E:GetModule("Skins")

--Lua functions
local _G = _G
local unpack = unpack
--WoW API / Variables
--local SpellBook_GetCurrentPage = SpellBook_GetCurrentPage
--local BOOKTYPE_SPELL = BOOKTYPE_SPELL
local MAX_SKILLLINE_TABS = MAX_SKILLLINE_TABS

S:AddCallback("Skin_Spellbook", function()
	if not E.private.skins.blizzard.enable or not E.private.skins.blizzard.spellbook then return end

	-- AscensionSpellbook

	AscensionSpellbookFrame:StripTextures(true)
	AscensionSpellbookFrame:CreateBackdrop("Transparent")
	--AscensionSpellbookFrame:Size  											-- for later on, the spells will need to be moved as well
	AscensionSpellbookFrameNineSlice:StripTextures(true)
	--AscensionSpellbookFrameNineSlice:CreateBackdrop("Transparent")
	AscensionSpellbookFrameInsetNineSlice:StripTextures(true)
	AscensionSpellbookFrameInset:StripTextures(true)
	AscensionSpellbookFrameInset:CreateBackdrop("Transparent")

	AscensionSpellbookFrame:RegisterForDrag("LeftButton")
	AscensionSpellbookFrame:SetMovable(true)
	AscensionSpellbookFrame:SetScript("OnDragStart", function(self) self:StartMoving() end)
	AscensionSpellbookFrame:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end)
	
	-- AscensionSpellbookFrame:SetScale(0.9)

	for i = 1, 3 do
		local tab = _G["AscensionSpellbookFrameTab"..i]
		tab:Size(122, 32)
		tab:GetRegions():SetPoint("CENTER", 0, 2)
		S:HandleTab(tab)
	end

	AscensionSpellbookFrameTab1:Point("CENTER", AscensionSpellbookFrame, "BOTTOMLEFT", 72, 62)
	AscensionSpellbookFrameTab2:Point("LEFT", AscensionSpellbookFrameTab1, "RIGHT", -15, 0)
	AscensionSpellbookFrameTab3:Point("LEFT", AscensionSpellbookFrameTab2, "RIGHT", -15, 0)

	S:HandleNextPrevButton(AscensionSpellbookFramePreviousPageButton, nil, nil, true)
	S:HandleNextPrevButton(AscensionSpellbookFrameNextPageButton, nil, nil, true)

	S:HandleCloseButton(AscensionSpellbookFrameCloseButton)

	S:HandleCheckBox(AscensionSpellbookFrameContentSpellsShowAllSpellRanks)
	
	S:HandleEditBox(AscensionSpellbookFrameContentSpellsSearch)

	for i = 1, SPELLS_PER_PAGE do
		local button = _G["AscensionSpellbookFrameContentSpellsSpellButton"..i]
		local autoCast = _G["AscensionSpellbookFrameContentSpellsSpellButton"..i.."AutoCastable"]
		button:StripTextures()
		button:CreateBackdrop("Default", true)

		autoCast:SetTexture("Interface\\Buttons\\UI-AutoCastableOverlay")
		autoCast:SetOutside(button, 16, 16)

		_G["AscensionSpellbookFrameContentSpellsSpellButton"..i.."IconTexture"]:SetTexCoord(unpack(E.TexCoords))

		E:RegisterCooldown(_G["AscensionSpellbookFrameContentSpellsSpellButton"..i.."Cooldown"])
	end

	hooksecurefunc("SpellButton_UpdateButton", function(self)
		local name = self:GetName()
		_G[name.."SpellName"]:SetTextColor(1, 0.80, 0.10)
		_G[name.."SubSpellName"]:SetTextColor(1, 1, 1)
		_G[name.."Highlight"]:SetTexture(1, 1, 1, 0.3)
	end)

	for i = 1, MAX_SKILLLINE_TABS do
		local tab = _G["AscensionSpellbookFrameSideBarTab"..i]

		tab:StripTextures()
		tab:StyleButton(nil, true)
		tab:SetTemplate("Default", true)

		tab:GetNormalTexture():SetInside()
		tab:GetNormalTexture():SetTexCoord(unpack(E.TexCoords))
	end

	AscensionSpellbookFrameSideBarTab1:Point("TOPLEFT", AscensionSpellbookFrame, "TOPRIGHT", 0, -40)

	for i = 2, MAX_SKILLLINE_TABS do
		local tab = _G["AscensionSpellbookFrameSideBarTab"..i]
		local previous = _G["AscensionSpellbookFrameSideBarTab"..i - 1]
	
		tab:SetPoint("TOPLEFT", previous, "BOTTOMLEFT", 0, -8)
	end

	SpellBookPageText:SetTextColor(1, 1, 1)

	--Professions
	AscensionSpellbookFrameContentProfessions:StripTextures(true)

	for i = 1, 5 do
		local professions = _G["AscensionSpellbookFrameContentProfessionsProfession"..i]
		--_G["AscensionSpellbookFrameContentProfessionsProfession"..i.."MainSpellIconTexture"]:SetTexCoord(unpack(E.TexCoords))
		--_G["AscensionSpellbookFrameContentProfessionsProfession"..i.."ExtraSpellIconTexture"]:SetTexCoord(unpack(E.TexCoords))
		S:HandleStatusBar(_G["AscensionSpellbookFrameContentProfessionsProfession"..i.."StatusBar"])
		professions.MissingText:FontTemplate(nil,12)
		professions.MissingText:SetTextColor(1, 1, 1)

	end

	-- Pet Tab
	AscensionSpellbookFrameContentPetSpells:StripTextures(true)
	AscensionSpellbookFrameContentPetSpells:CreateBackdrop("Transparent")

	for i = 1, 12 do
		local button = _G["AscensionSpellbookFrameContentPetSpellsSpellButton"..i]
		button:StripTextures()
		button:CreateBackdrop("Default", true)

		_G["AscensionSpellbookFrameContentPetSpellsSpellButton"..i.."IconTexture"]:SetTexCoord(unpack(E.TexCoords))

		E:RegisterCooldown(_G["AscensionSpellbookFrameContentPetSpellsSpellButton"..i.."Cooldown"])
	end



	-- Blizz Spellbook (Leaving here for now)
	SpellBookFrame:StripTextures(true)
	SpellBookFrame:CreateBackdrop("Transparent")
	SpellBookFrame.backdrop:Point("TOPLEFT", 11, -12)
	SpellBookFrame.backdrop:Point("BOTTOMRIGHT", -32, 76)

	S:SetUIPanelWindowInfo(SpellBookFrame, "width", nil, 32)
	S:SetBackdropHitRect(SpellBookFrame)

--[[
	SpellBookFrame:EnableMouseWheel(true)
	SpellBookFrame:SetScript("OnMouseWheel", function(_, value)
		--do nothing if not on an appropriate book type
		if SpellBookFrame.bookType ~= BOOKTYPE_SPELL then
			return
		end

		local currentPage, maxPages = SpellBook_GetCurrentPage()

		if value > 0 then
			if currentPage > 1 then
				SpellBookPrevPageButton_OnClick()
			end
		else
			if currentPage < maxPages then
				SpellBookNextPageButton_OnClick()
			end
		end
	end)
]]

	for i = 1, 3 do
		local tab = _G["SpellBookFrameTabButton"..i]
		tab:Size(122, 32)
		tab:GetNormalTexture():SetTexture(nil)
		tab:GetDisabledTexture():SetTexture(nil)
		tab:GetRegions():SetPoint("CENTER", 0, 2)
		S:HandleTab(tab)
	end

	SpellBookFrameTabButton1:Point("CENTER", SpellBookFrame, "BOTTOMLEFT", 72, 62)
	SpellBookFrameTabButton2:Point("LEFT", SpellBookFrameTabButton1, "RIGHT", -15, 0)
	SpellBookFrameTabButton3:Point("LEFT", SpellBookFrameTabButton2, "RIGHT", -15, 0)

	S:HandleNextPrevButton(SpellBookPrevPageButton, nil, nil, true)
	S:HandleNextPrevButton(SpellBookNextPageButton, nil, nil, true)

	S:HandleCloseButton(SpellBookCloseButton, SpellBookFrame.backdrop)

	S:HandleCheckBox(ShowAllSpellRanksCheckBox)

	for i = 1, SPELLS_PER_PAGE do
		local button = _G["SpellButton"..i]
		local autoCast = _G["SpellButton"..i.."AutoCastable"]
		button:StripTextures()

		autoCast:SetTexture("Interface\\Buttons\\UI-AutoCastableOverlay")
		autoCast:SetOutside(button, 16, 16)

		button:CreateBackdrop("Default", true)

		_G["SpellButton"..i.."IconTexture"]:SetTexCoord(unpack(E.TexCoords))

		E:RegisterCooldown(_G["SpellButton"..i.."Cooldown"])
	end

	hooksecurefunc("SpellButton_UpdateButton", function(self)
		local name = self:GetName()
		_G[name.."SpellName"]:SetTextColor(1, 0.80, 0.10)
		_G[name.."SubSpellName"]:SetTextColor(1, 1, 1)
		_G[name.."Highlight"]:SetTexture(1, 1, 1, 0.3)
	end)

	for i = 1, MAX_SKILLLINE_TABS do
		local tab = _G["SpellBookSkillLineTab"..i]

		tab:StripTextures()
		tab:StyleButton(nil, true)
		tab:SetTemplate("Default", true)

		tab:GetNormalTexture():SetInside()
		tab:GetNormalTexture():SetTexCoord(unpack(E.TexCoords))
	end

	SpellBookSkillLineTab1:Point("TOPLEFT", SpellBookFrame, "TOPRIGHT", -33, -65)

	SpellBookPageText:SetTextColor(1, 1, 1)
end)