local E, L, V, P, G = unpack(ElvUI)
local S = E:GetModule("Skins")
local AS = E:GetModule("AddOnSkins")

if not AS:IsAddonLODorEnabled("AllStats") then return end

-- All Stats 1.1
-- https://www.curseforge.com/wow/addons/all-stats/files/430951

S:AddCallbackForAddon("AllStats", "AllStats", function()
	if not E.private.addOnSkins.AllStats then return end

	AllStatsFrame:StripTextures()
	AllStatsFrame:SetTemplate("Transparent")
	AllStatsFrame:Height(424)
	AllStatsFrame:Point("TOPLEFT", AscensionCharacterFrame, "TOPRIGHT", 2, -6)

	S:HandleButton(AllStatsButtonShowFrame)
	AllStatsButtonShowFrame:Height(21)
	AllStatsButtonShowFrame:Point("BOTTOMRIGHT", 20, -22)
end)