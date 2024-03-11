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
	AscensionSpellbookFrame:SetWidth(500)
	AscensionSpellbookFrameNineSlice:StripTextures(true)
	AscensionSpellbookFrame:StripTextures(true)
	AscensionSpellbookFramePortraitFrame:StripTextures(true)
	AscensionSpellbookFrameInsetNineSlice:StripTextures(true)
	AscensionSpellbookFrame:CreateBackdrop("Transparent")

	AscensionSpellbookFrame:RegisterForDrag("LeftButton")
	AscensionSpellbookFrame:SetMovable(true)
	AscensionSpellbookFrame:SetScript("OnDragStart", function(self) self:StartMoving() end)
	AscensionSpellbookFrame:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end)

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

	SpellBookPageText:SetTextColor(1, 1, 1)

	--Professions
	AscensionSpellbookFrameContentProfessions:StripTextures(true)

	for _, button in ipairs(AscensionSpellbookFrameContentProfessions.professionButtons) do
		hooksecurefunc(button, "SetProfession", function(button, skillID)
			local _, _, icon = ProfessionUtil.GetProfessionByID(skillID)
			button.Icon:SetTexture(icon)
			button.Icon:SetTexCoord(unpack(E.TexCoords))

			for extraButton in button.ExtraButtonPool:EnumerateActive() do
				local extraIcon = select(3, GetSpellInfo(extraButton.spellID))
				extraButton.Icon:SetTexture(extraIcon)
				extraButton.Icon:SetTexCoord(unpack(E.TexCoords))
				extraButton.IconBorder:StripTextures()
				extraButton.Highlight:StripTextures()
			end

			if button:IsEnabled() == 0 then
				button.Icon:SetAlpha(0.7)
    			button.Icon:SetDesaturated(true)
			else
				button.Icon:SetAlpha(1)
    			button.Icon:SetDesaturated(false)
			end
		end)
		S:HandleIcon(button.Icon)
		button.IconBorder:StripTextures()
		button.Highlight:StripTextures()
		S:HandleStatusBar(button.ProgressBar)
		S:HandleCloseButton(button.AbandonButton)
		button.ProgressBar.RankText:SetPoint("CENTER", 0, 0)
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
end)