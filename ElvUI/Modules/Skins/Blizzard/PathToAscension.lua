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
	PathToAscensionFrameMentorPanelBecomeMentor:StripTextures()
	PathToAscensionFrameMentorPanelBecomeMentorBorder:StripTextures()
	PathToAscensionFrameMentorPanelFindHelp:StripTextures()
	PathToAscensionFrameMentorPanelFindHelpBorder:StripTextures()
	-- Strip Frame Inset from AvailableMentors list
	local mentorFrameChildren = {PathToAscensionFrameMentorPanelFindHelpAvailableMentors:GetChildren()}
	mentorFrameChildren[2]:StripTextures()


	PathToAscensionFrame:CreateBackdrop("Transparent")
	PathToAscensionFrameMentorPanelBecomeMentor:CreateBackdrop("Transparent")
	PathToAscensionFrameMentorPanelFindHelp:CreateBackdrop("Transparent")

	-- Strip Objective Panel Frame textures
	PathToAscensionFrameDisplay:StripTextures()
	PathToAscensionFrameDisplayQuestObjectives:StripTextures()

	-- Reskin the Frames in ElvUI style
	S:HandleCloseButton(PathToAscensionFrameCloseButton)
	S:HandleEditBox(PathToAscensionFrameObjectivesHeaderSearch)
	S:HandleEditBox(PathToAscensionFrameMentorPanelFindHelpSearchBox)

	S:HandleScrollBar(PathToAscensionFrameObjectivesScrollFrameScrollBar)
	S:HandleButton(PathToAscensionFrameDisplayQuestObjectivesInteractButton)
	S:HandleButton(PathToAscensionFrameDisplayLeftButton)
	S:HandleButton(PathToAscensionFrameDisplayRightButton)

	S:HandleButton(PathToAscensionFrameMentorPanelBecomeMentorBecomeMentorButton)
	S:HandleButton(PathToAscensionFrameMentorPanelFindHelpRefreshButton)
	PathToAscensionFrameMentorPanelFindHelpRefreshButton:Size(22, 22)

	S:HandleScrollList(PathToAscensionFrameMentorPanelFindHelpAvailableMentors)

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
	for i = 1, 13 do
		local objectiveButton = _G["PathToAscensionFrameObjectivesScrollFrameButton"..i]
		S:HandleButton(objectiveButton, true)
	end

	-- Reskin Mentor Checkboxes
	for i = 1, 10 do
		local checkBox = _G["PathToAscensionFrameMentorPanelBecomeMentorSpecialization"..i]
		S:HandleCheckBox(checkBox)
	end

	-- Reskin Available Mentors
	for i = 1, 9 do
		local mentor = _G["PathToAscensionFrameMentorPanelFindHelpAvailableMentorsScrollFrameButton"..i] 
		S:HandleButton(mentor, true)
	end

	PathToAscensionFrameMentorPanelFindHelpFilter:StripTextures(true)
	S:HandleButton(PathToAscensionFrameMentorPanelFindHelpFilter)
	
end)