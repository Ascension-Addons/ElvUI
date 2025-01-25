local E, L, V, P, G = unpack(select(2, ...)) --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local S = E:GetModule("Skins")

--Lua functions
local _G = _G
local select = select
--WoW API / Variables
S:AddCallbackForAddon("Ascension_HelpUI", "Skin_Help", function()
	if not E.private.skins.blizzard.enable or not E.private.skins.blizzard.help then return end

	HelpMenuFrame.PortraitFrame:StripTextures(true)
	HelpMenuFrameNineSlice:StripTextures()
	HelpMenuFrame:StripTextures()
	HelpMenuFrame:CreateBackdrop("Transparent")
	HelpMenuFrame.backdrop:Point("TOPLEFT", 0, 0)
	HelpMenuFrame.backdrop:Point("BOTTOMRIGHT", 0, 0)

	HelpMenuFrameLeftInset:StripTextures()
	HelpMenuFrameRightInset:StripTextures()
	HelpMenuFrameRightInsetInsetNineSlice:StripTextures()

	S:SetBackdropHitRect(HelpMenuFrame)

	S:HandleCloseButton(HelpMenuFrameCloseButton, HelpMenuFrame.backdrop)

	S:HandleTabSystem(HelpMenuFrame.LeftInset)

	S:HandleScrollBar(HelpMenuFrameRightInsetScrollFrameScrollBar)

	HelpMenuFrameRightInsetItemRestorePanel:StripTextures()
	HelpMenuFrameRightInsetItemRestorePanelCategories:StripTextures()
	HelpMenuFrameRightInsetItemRestorePanelRecoveryScroll:StripTextures()

	S:HandleTabSystem(HelpMenuFrameRightInsetItemRestorePanelCategories)
	S:HandleEditBox(HelpMenuFrameRightInsetItemRestorePanelRecoveryScrollSearch)

	S:HandleScrollList(HelpMenuFrameRightInsetItemRestorePanelRecoveryScroll, function(button)
		button:StripTextures()
		S:HandleBorderIcon(button.Icon)
		S:HandleButton(button.RecoverItemButton)

		hooksecurefunc(button, "Update", function(self)
			self:SetNormalTexture(E.media.blankTex)
			button.Icon:SetRounded(false)
			if button.category == "RECOVERY_SERVICE_CATEGORY_DELETED_CHARACTER" then
				self.Icon.Icon:SetTexture("Interface\\Glues\\CharacterCreate\\UI-CHARACTERCREATE-RACES")
			else
				self.Icon.Icon:SetTexCoord(unpack(E.TexCoords))
			end
			local color = self.index % 2 == 0 and E.media.backdropcolor or E.media.backdropfadecolor
			self:GetNormalTexture():SetVertexColor(unpack(color))
		end)
	end)
end)