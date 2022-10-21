local E, L, V, P, G = unpack(select(2, ...)) --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local S = E:GetModule("Skins")

--Lua functions
local _G = _G
local unpack = unpack
local find = string.find
--WoW API / Variables
local GetItemInfo = GetItemInfo
local GetItemQualityColor = GetItemQualityColor
local GetLFGDungeonRewardLink = GetLFGDungeonRewardLink
local GetLFGDungeonRewards = GetLFGDungeonRewards
local hooksecurefunc = hooksecurefunc

S:AddCallback("Skin_LFD", function()
	if not E.private.skins.blizzard.enable or not E.private.skins.blizzard.lfd then return end

	AscensionLFGFrame:StripTextures(true)
	AscensionLFGFrame:CreateBackdrop("Transparent")
	AscensionLFGFrameContent:StripTextures(true)
	AscensionLFGFrameMenu:StripTextures(true)
	AscensionLFGFrameInset:StripTextures(true)
	AscensionLFGFrameInset:CreateBackdrop("Transparent")
	AscensionLFGFrameInsetNineSlice:StripTextures(true)
	AscensionLFGFrameNineSlice:StripTextures(true)
	AscensionLFGFrameMenuNineSlice:StripTextures(true)

	AscensionPVEFrameLFDFrame:StripTextures(true)
	AscensionPVEFrameLFDFrame:CreateBackdrop("Transparent")
	AscensionPVEFrameLFDFrameRandom:StripTextures(true)
	AscensionPVEFrameLFDFrameRandomScrollFrame:StripTextures(true)

	S:HookScript(LFDParentFrame, "OnShow", function(self)
		S:SetUIPanelWindowInfo(self, "width", 341)
		S:SetBackdropHitRect(self, AscensionLFGFrame.backdrop)
		S:Unhook(self, "OnShow")
	end)

	S:HandleCloseButton(AscensionLFGFrameCloseButton)

	LFDParentFramePortrait:Kill()

	-- Role Checkboxes
	S:HandleCheckBox(AscensionPVEFrameLFDFrameRoleButtonTank.checkButton)
	AscensionPVEFrameLFDFrameRoleButtonTank.checkButton:SetFrameLevel(AscensionPVEFrameLFDFrameRoleButtonTank.checkButton:GetFrameLevel() + 2)
	S:HandleCheckBox(AscensionPVEFrameLFDFrameRoleButtonHealer.checkButton)
	AscensionPVEFrameLFDFrameRoleButtonHealer.checkButton:SetFrameLevel(AscensionPVEFrameLFDFrameRoleButtonHealer.checkButton:GetFrameLevel() + 2)
	S:HandleCheckBox(AscensionPVEFrameLFDFrameRoleButtonDPS.checkButton)
	AscensionPVEFrameLFDFrameRoleButtonDPS.checkButton:SetFrameLevel(AscensionPVEFrameLFDFrameRoleButtonDPS.checkButton:GetFrameLevel() + 2)
	S:HandleCheckBox(AscensionPVEFrameLFDFrameRoleButtonLeader.checkButton)
	AscensionPVEFrameLFDFrameRoleButtonLeader.checkButton:SetFrameLevel(AscensionPVEFrameLFDFrameRoleButtonLeader.checkButton:GetFrameLevel() + 2)

	-- Dropdown
	S:HandleDropDownBox(AscensionPVEFrameLFDFrameTypeDropDown)
	AscensionPVEFrameLFDFrameTypeDropDown:HookScript("OnShow", function(self) self:Width(200) end)

	-- Specific Dungeons
	for i = 1, NUM_LFD_CHOICE_BUTTONS do
		local button = _G["AscensionPVEFrameLFDFrameSpecificListButton"..i]
		button.enableButton:StripTextures()
		button.enableButton:CreateBackdrop("Default")
		button.enableButton.backdrop:SetInside(nil, 4, 4)

		button.expandOrCollapseButton:SetNormalTexture(E.Media.Textures.Plus)
		button.expandOrCollapseButton.SetNormalTexture = E.noop
		button.expandOrCollapseButton:GetNormalTexture():Size(16)

		button.expandOrCollapseButton:SetHighlightTexture(nil)

		hooksecurefunc(button.expandOrCollapseButton, "SetNormalTexture", function(self, texture)
			if find(texture, "MinusButton") then
				self:GetNormalTexture():SetTexture(E.Media.Textures.Minus)
			elseif find(texture, "PlusButton") then
				self:GetNormalTexture():SetTexture(E.Media.Textures.Plus)
			end
		end)
	end

	AscensionPVEFrameLFDFrameSpecificListScrollFrame:StripTextures()
	S:HandleScrollBar(AscensionPVEFrameLFDFrameRandomScrollFrameScrollBar)
	S:HandleScrollBar(AscensionPVEFrameLFDFrameSpecificListScrollFrameScrollBar)

	--Side menu buttons
	for i = 1, 3 do
		local sidebutton = _G["AscensionLFGFrameButton"..i]
	S:HandleButton(sidebutton)
	end

	--Tabs
	for i = 1, 3 do
		local tab = _G["AscensionLFGFrameTab"..i]
		tab:Size(122, 32)
		tab:GetRegions():SetPoint("CENTER", 0, 2)
		S:HandleTab(tab)
	end
	
	S:HandleButton(AscensionPVEFrameLFDFrameFindGroupButton)
	--S:HandleButton(AscensionPVEFrameLFDFrameCancelButton)

	--S:HandleButton(AscensionPVEFrameLFDFramePartyBackfillBackfillButton)
	--S:HandleButton(AscensionPVEFrameLFDFramePartyBackfillNoBackfillButton)

	S:HandleButton(AscensionPVEFrameLFDFrameNoLFDWhileLFRLeaveQueueButton)

	AscensionPVEFrameLFDFrameRandomScrollFrameScrollBar:Point("TOPLEFT", AscensionPVEFrameLFDFrameRandomScrollFrame, "TOPRIGHT", 5, -22)
	AscensionPVEFrameLFDFrameRandomScrollFrameScrollBar:Point("BOTTOMLEFT", AscensionPVEFrameLFDFrameRandomScrollFrame, "BOTTOMRIGHT", 5, 19)

	AscensionPVEFrameLFDFrameSpecificListScrollFrameScrollBar:Point("TOPLEFT", AscensionPVEFrameLFDFrameSpecificListScrollFrame, "TOPRIGHT", 5, -17)
	AscensionPVEFrameLFDFrameSpecificListScrollFrameScrollBar:Point("BOTTOMLEFT", AscensionPVEFrameLFDFrameSpecificListScrollFrame, "BOTTOMRIGHT", 5, 17)

	AscensionPVEFrameLFDFrameFindGroupButton:Point("BOTTOMLEFT", 19, 10)
	--AscensionPVEFrameLFDFrameCancelButton:Point("BOTTOMRIGHT", -11, 12)

	--AscensionPVEFrameLFDFrameTypeDropDown:Point("TOPLEFT", 152, -119)

	--AscensionPVEFrameLFDFrameSpecificListButton1:Point("TOPLEFT", 25, -154)
	AscensionPVEFrameLFDFrameRandomScrollFrame:Point("BOTTOMRIGHT", -34, 41)

	--AscensionPVEFrameLFDFrameCooldownFrame:Size(325, 259)
	--AscensionPVEFrameLFDFrameCooldownFrame:Point("BOTTOMRIGHT", AscensionPVEFrameLFDFrame, "BOTTOMRIGHT", -11, 37)

	--[[AscensionPVEFrameLFDFrameCooldownFrame:HookScript("OnShow", function(self)
		self:SetFrameLevel(self:GetParent():GetFrameLevel() + 5)
	end)
	--]]

	-- PvP Tab
		-- Progress Bar
			--Honor
			S:HandleStatusBar(AscensionPVPFrameHonorBar)
			--Arena
			S:HandleStatusBar(AscensionPVPFrameArenaBar)

		-- Quick Match
		AscensionPVPFrame:StripTextures(true)
		AscensionPVPFrame:CreateBackdrop("Transparent")
		AscensionPVPFrameCasualFrame:StripTextures(true)
		AscensionPVPFrameCasualFrame:CreateBackdrop("Transparent")
		AscensionPVPFrameCasualFrameInset:StripTextures(true)
		AscensionPVPFrameCasualFrameInset:CreateBackdrop("Transparent")
		AscensionPVPFrameCasualFrameInsetNineSlice:StripTextures(true)
			-- Buttons (Queues)
			S:HandleButton(AscensionPVPFrameCasualFrameRandomBGButton)
			S:HandleButton(AscensionPVPFrameCasualFrameCallToArmsButton1)
			S:HandleButton(AscensionPVPFrameCasualFrameSkirmish1v1Button)
			S:HandleButton(AscensionPVPFrameCasualFrameSkirmish2v2Button)
			S:HandleButton(AscensionPVPFrameCasualFrameSkirmish3v3Button)
		-- Honor Section
		AscensionPVPFrameHonorInset:StripTextures(true)
		AscensionPVPFrameHonorInset:CreateBackdrop("Transparent")
		AscensionPVPFrameHonorInsetNineSlice:StripTextures(true)

		-- Buttons
		S:HandleButton(AscensionPVPFrameCasualFrameQueueButton)
		S:HandleButton(AscensionPVPFrameCasualFrameSoloQueueButton)

		--Rated Tab
		AscensionPVPFrameRatedFrame:StripTextures(true)
		AscensionPVPFrameRatedFrame:CreateBackdrop("Transparent")
		AscensionPVPFrameRatedFrameInset:StripTextures(true)
		AscensionPVPFrameRatedFrameInset:CreateBackdrop("Transparent")
		AscensionPVPFrameRatedFrameInsetNineSlice:StripTextures(true)
			-- Buttons (Rated)
			S:HandleButton(AscensionPVPFrameRatedFrameArena1v1)
			S:HandleButton(AscensionPVPFrameRatedFrameArena2v2)
			S:HandleButton(AscensionPVPFrameRatedFrameArena3v3)
			S:HandleButton(AscensionPVPFrameRatedFrameSoloQueueButton)
			S:HandleButton(AscensionPVPFrameRatedFrameQueueButton)

	-- PvP Ruleset
	AscensionRulesetFrame:StripTextures(true)

	--[[for i = 1, 3 do
		local pvpruleset = _G["AscensionRulesetFrameRuleset"..i]
		--pvpruleset:StripTextures(true)
		S:HandleButton(pvpruleset.Select)
	end
	]]--

	local function skinLFDRandomDungeonLoot(frame)
		if frame.isSkinned then return end

		local icon = _G[frame:GetName().."IconTexture"]
		local nameFrame = _G[frame:GetName().."NameFrame"]
		local count = _G[frame:GetName().."Count"]

		frame:StripTextures()
		frame:CreateBackdrop("Transparent")
		frame.backdrop:SetOutside(icon)

		icon:SetTexCoord(unpack(E.TexCoords))
		icon:SetDrawLayer("BORDER")
		icon:SetParent(frame.backdrop)

		nameFrame:SetSize(118, 39)

		count:SetParent(frame.backdrop)

		frame.isSkinned = true
	end

	local function getLFGDungeonRewardLinkFix(dungeonID, rewardIndex)
		local _, link = GetLFGDungeonRewardLink(dungeonID, rewardIndex)

		if not link then
			E.ScanTooltip:SetOwner(UIParent, "ANCHOR_NONE")
			E.ScanTooltip:SetLFGDungeonReward(dungeonID, rewardIndex)
			_, link = E.ScanTooltip:GetItem()
			E.ScanTooltip:Hide()
		end

		return link
	end

	--[[hooksecurefunc("AscensionPVEFrameLFDFrameRandom_UpdateFrame", function()
		local dungeonID = AscensionPVEFrameLFDFrame.type
		if not dungeonID then return end

		local _, _, _, _, _, numRewards = GetLFGDungeonRewards(dungeonID)
		for i = 1, numRewards do
			local frame = _G["AscensionPVEFrameLFDFrameRandomScrollFrameChildFrameItem"..i]
			local name = _G["AscensionPVEFrameLFDFrameRandomScrollFrameChildFrameItem"..i.."Name"]

			skinLFDRandomDungeonLoot(frame)

			local link = getLFGDungeonRewardLinkFix(dungeonID, i)
			if link then
				local _, _, quality = GetItemInfo(link)
				if quality then
					local r, g, b = GetItemQualityColor(quality)
					frame.backdrop:SetBackdropBorderColor(r, g, b)
					name:SetTextColor(r, g, b)
				end
			else
				frame.backdrop:SetBackdropBorderColor(unpack(E.media.bordercolor))
				name:SetTextColor(1, 1, 1)
			end
		end
	end)
	--]]

	-- LFDDungeonReadyStatus
	LFDDungeonReadyStatus:SetTemplate("Transparent")
	S:HandleCloseButton(LFDDungeonReadyStatusCloseButton, nil, "-")

	LFDSearchStatus:SetTemplate("Transparent")

	-- LFDRoleCheckPopup
	LFDRoleCheckPopup:SetTemplate("Transparent")

	S:HandleCheckBox(LFDRoleCheckPopupRoleButtonTank.checkButton)
	S:HandleCheckBox(LFDRoleCheckPopupRoleButtonHealer.checkButton)
	S:HandleCheckBox(LFDRoleCheckPopupRoleButtonDPS.checkButton)

	S:HandleButton(LFDRoleCheckPopupAcceptButton)
	S:HandleButton(LFDRoleCheckPopupDeclineButton)

	-- LFDDungeonReadyDialog
	LFDDungeonReadyDialog:SetTemplate("Transparent")

	LFDDungeonReadyDialog.label:Size(280, 0)
	LFDDungeonReadyDialog.label:Point("TOP", 0, -10)

	LFDDungeonReadyDialog:CreateBackdrop("Default")
	LFDDungeonReadyDialog.backdrop:Point("TOPLEFT", 10, -35)
	LFDDungeonReadyDialog.backdrop:Point("BOTTOMRIGHT", -10, 40)

	LFDDungeonReadyDialog.backdrop:SetFrameLevel(LFDDungeonReadyDialog:GetFrameLevel())
	LFDDungeonReadyDialog.background:SetInside(LFDDungeonReadyDialog.backdrop)

	LFDDungeonReadyDialogFiligree:SetTexture("")
	LFDDungeonReadyDialogBottomArt:SetTexture("")

	S:HandleCloseButton(LFDDungeonReadyDialogCloseButton, nil, "-")

	LFDDungeonReadyDialogEnterDungeonButton:Point("BOTTOMRIGHT", LFDDungeonReadyDialog, "BOTTOM", -7, 10)
	S:HandleButton(LFDDungeonReadyDialogEnterDungeonButton)
	LFDDungeonReadyDialogLeaveQueueButton:Point("BOTTOMLEFT", LFDDungeonReadyDialog, "BOTTOM", 7, 10)
	S:HandleButton(LFDDungeonReadyDialogLeaveQueueButton)

--[[
	LFDDungeonReadyDialogRoleIcon:Size(57)
	LFDDungeonReadyDialogRoleIcon:Point("BOTTOM", 1, 54)
	LFDDungeonReadyDialogRoleIcon:SetTemplate("Default")
	LFDDungeonReadyDialogRoleIconTexture:SetInside()

	function GetTexCoordsForRole(role)
		if role == "GUIDE" then
			return 0.0625, 0.1953125, 0.05859375, 0.19140625
		elseif role == "TANK" then
			return 0.0625, 0.1953125, 0.3203125, 0.453125
		elseif role == "HEALER" ) then
			return 0.32421875, 0.45703125, 0.0546875, 0.1875
		elseif role == "DAMAGER" then
			return 0.32421875, 0.453125, 0.31640625, 0.4453125
		end
	end
	GameTooltip:SetLFGDungeonReward(287, 1)
--]]

	local function skinLFDDungeonReadyDialogReward(button)
		if button.isSkinned then return end

		button:Size(28)
		button:SetTemplate("Default")
		if button.texture ~= nil then
			button.texture:SetInside()
			button.texture:SetTexCoord(unpack(E.TexCoords))
		end
		button:DisableDrawLayer("OVERLAY")

		button.isSkinned = true
	end

	hooksecurefunc("LFDDungeonReadyDialogReward_SetMisc", function(button)
		skinLFDDungeonReadyDialogReward(button)

		SetPortraitToTexture(button.texture, "")
		button.texture:SetTexture("Interface\\Icons\\inv_misc_coin_02")
	end)

	hooksecurefunc("LFDDungeonReadyDialogReward_SetReward", function(button, dungeonID, rewardIndex)
		skinLFDDungeonReadyDialogReward(button)

		local link = getLFGDungeonRewardLinkFix(dungeonID, rewardIndex)
		if link then
			local _, _, quality = GetItemInfo(link)
			button:SetBackdropBorderColor(GetItemQualityColor(quality))
		else
			button:SetBackdropBorderColor(unpack(E.media.bordercolor))
		end
		if button.texture ~= nil then
			local texturePath = button.texture:GetTexture()
			if texturePath then
				SetPortraitToTexture(button.texture, "")
				button.texture:SetTexture(texturePath)
			end
		end
	end)
end)