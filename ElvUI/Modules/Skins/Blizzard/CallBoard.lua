local E, L, V, P, G = unpack(ElvUI)
local S = E:GetModule("Skins")

local unpack = unpack

S:AddCallbackForAddon("AscensionUI", "Skin_CallBoard", function ()
	if not E.private.skins.blizzard.enable or not E.private.skins.blizzard.callboard then return end

    CallBoardUI:StripTextures()
    CallBoardUINineSlice:StripTextures()

    CallBoardUI.Tabs:StripTextures()
    CallBoardUI.content:StripTextures()
    CallBoardUI.content.TotalRewards.controlFrame:StripTextures()

	-- Strip Border Textures
    CallBoardUI.Tabs.NineSlice:StripTextures()
    CallBoardUI.content.NineSlice:StripTextures()
    CallBoardUI.content.TotalRewards:StripTextures()
    
    CallBoardUI.content.TotalRewards.NineSlice:StripTextures()
    CallBoardUI.content.ExtraSlots.Scroll.scrollTop:StripTextures()
    CallBoardUI.content.ExtraSlots.Scroll.scrollMid:StripTextures()
    CallBoardUI.content.ExtraSlots.Scroll.scrollBot:StripTextures()
    CallBoardUI.content.ExtraSlots.Scroll.scrollBG:StripTextures()
    
    local tabs = {CallBoardUI.Tabs:GetChildren()}

    -- Reskin the Frames in ElvUI style
    CallBoardUI:CreateBackdrop("Transparent")
    CallBoardUI.content.NineSlice:CreateBackdrop("Transparent")
    -- Fix NineSlice borderframe overlaying at the wrong FrameLevel
    CallBoardUI.content.NineSlice:SetFrameLevel(CallBoardUI.content:GetFrameLevel())

	S:HandleCloseButton(CallBoardUICloseButton)
    S:HandleScrollBar(CallBoardUI.content.ExtraSlots.Scroll.scrollBar)
    S:HandleScrollBar(CallBoardUI.content.statisticsScroll.ScrollBar)
    S:HandleButton(CallBoardUI.content.TotalRewards.controlFrame.buttonAccept, true)
    S:HandleButton(CallBoardUI.content.TotalRewards.controlFrame.buttonComplete, true)

end)