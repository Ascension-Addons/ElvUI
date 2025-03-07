local E, L, V, P, G = unpack(ElvUI)
local S = E:GetModule("Skins")

local unpack = unpack

S:AddCallbackForAddon("Ascension_PathToAscension", "Skin_PathToAscension", function ()
	if not E.private.skins.blizzard.enable or not E.private.skins.blizzard.pathtoascension then return end

	PathToAscensionFrame:StripTextures()
	PathToAscensionFramePortraitFrame:StripTextures()
	-- Strip Border Textures
	PathToAscensionFrameNineSlice:StripTextures()
	PathToAscensionFrameDisplayNineSlice:StripTextures()
	PathToAscensionFrameObjectivesInsetFrame:StripTextures()

	PathToAscensionFrameMentorPanel:StripTextures()

	PathToAscensionFrame:CreateBackdrop("Transparent")

	-- Strip Objective Panel Frame textures
	PathToAscensionFrameDisplay:StripTextures()
	PathToAscensionFrameDisplayQuestObjectives:StripTextures()

	-- Reskin the Frames in ElvUI style
	S:HandleEditBox(PathToAscensionFrameObjectivesHeaderSearch)

	S:HandleScrollBar(PathToAscensionFrameObjectivesScrollFrameScrollBar)
	S:HandleButton(PathToAscensionFrameDisplayQuestObjectivesInteractButton)
	S:HandleButton(PathToAscensionFrameDisplayLeftButton)
	S:HandleButton(PathToAscensionFrameDisplayRightButton)


	S:HandleTabSystem(PathToAscensionFrame)

	-- sRGB values pulled from Achievement.lua
	local sbcR, sbcG, sbcB = 4/255, 179/255, 30/255

	local function skinStatusBar(bar)
		bar:StripTextures()
		bar:SetBackgroundTexture()
		bar:SetStatusBarTexture(E.media.normTex)
		bar:SetStatusBarColor(sbcR, sbcG, sbcB)
		-- Clear out Unnamed Frames backdrop
		local children = {bar:GetChildren()}
		for i, child in ipairs(children) do
			child:SetBackdrop(nil)
		end
	
		E:RegisterStatusBar(bar)
	end

	skinStatusBar(PathToAscensionFrameCompleteProgressRewardProgress)

	PathToAscensionFrameObjectivesScrollFrameArtOverlay:StripTextures(true)

	-- Reskin the objectives list
	for i = 1, 12 do
		local objectiveButton = _G["PathToAscensionFrameObjectivesScrollFrameButton"..i]
		S:HandleButton(objectiveButton, true)
	end

end)