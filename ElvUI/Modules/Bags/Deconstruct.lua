--[[
	Deconstruct Module for ElvUI (WoW 3.3.5a / Ascension)
	Adapted from ElvUI_SLE retail version
	
	This module provides functionality to disenchant, mill, prospect, and unlock items
	directly from bags by creating an overlay button when mousing over compatible items.
]] --
local E, L, V, P, G = unpack(select(2, ...))
local B = E:GetModule("Bags")

local D = B:NewModule("Deconstruct", "AceHook-3.0", "AceEvent-3.0")

-- Lua functions
local _G = _G
local format, strfind, type, tostring = format, strfind, type, tostring
local pairs, select, unpack = pairs, select, unpack

-- WoW API
local GetTradeTargetItemLink = GetTradeTargetItemLink
local InCombatLockdown = InCombatLockdown
local GetContainerItemLink = GetContainerItemLink
local GetSpellInfo = GetSpellInfo
local GetItemInfo = GetItemInfo
local GetItemCount = GetItemCount
local CreateFrame = CreateFrame
local GameTooltip = GameTooltip

-- Constants (with fallbacks in case they're not loaded yet)
local LOCKED = LOCKED or "Locked"
local VIDEO_OPTIONS_ENABLED = VIDEO_OPTIONS_ENABLED or "Enabled"
local VIDEO_OPTIONS_DISABLED = VIDEO_OPTIONS_DISABLED or "Disabled"

-- Module variables
D.DeconstructMode = false
D.ItemTable = {
	['DoNotDE'] = {
		['49715'] = true, -- Rose helm
		['44731'] = true, -- Rose offhand
		['21524'] = true, -- Red winter hat
		['51525'] = true, -- Green winter hat
		['70923'] = true, -- Sweater
		['34486'] = true, -- Orgrimmar achievement fish
		['11287'] = true, -- Lesser Magic Wand
		['11288'] = true -- Greater Magic Wand
	},
	['Cooking'] = {
		['46349'] = true -- Chef's Hat
	},
	['Fishing'] = {
		['19022'] = true, -- Nat Pagle's Extreme Angler FC-5000
		['19970'] = true, -- Arcanite Fishing Pole
		['25978'] = true, -- Seth's Graphite Fishing Pole
		['44050'] = true, -- Mastercraft Kalu'ak Fishing Pole
		['45858'] = true, -- Nat's Lucky Fishing Pole
		['45991'] = true, -- Bone Fishing Pole
		['45992'] = true -- Jeweled Fishing Pole
	}
}

D.Keys = {}
D.BlacklistDE = {}
D.BlacklistLOCK = {}

-- Profession spell names
D.DEname = GetSpellInfo(13262) -- Disenchant
D.MILLname = GetSpellInfo(51005) -- Milling
D.PROSPECTname = GetSpellInfo(31252) -- Prospecting
D.LOCKname = GetSpellInfo(1804) -- Pick Lock

-- Check if player has any relevant professions
function D:HasRelevantProfession()
	if D.HasEnchanting then return true end
	if D.HasInscription then return true end
	if D.HasJewelcrafting then return true end
	if D.HasPickLock then return true end
	return false
end

-- Update button state (enabled/disabled)
function D:UpdateButtonState()
	if not D.DeconstructButton then return end
	
	local hasProf = D:HasRelevantProfession()
	
	if hasProf then
		D.DeconstructButton:Enable()
		D.DeconstructButton:SetAlpha(1)
	else
		D.DeconstructButton:Disable()
		D.DeconstructButton:SetAlpha(0.5)
	end
end

-- Check which professions the player has
function D:UpdateProfessions()
	D.HasEnchanting = false
	D.HasInscription = false
	D.HasJewelcrafting = false
	D.HasPickLock = false

	if D.DEname and GetSpellInfo(D.DEname) then D.HasEnchanting = true end
	if D.MILLname and GetSpellInfo(D.MILLname) then D.HasInscription = true end
	if D.PROSPECTname and GetSpellInfo(D.PROSPECTname) then D.HasJewelcrafting = true end
	if D.LOCKname and GetSpellInfo(D.LOCKname) then D.HasPickLock = true end
end

-- Helper function to check if player has a skeleton key
local function HaveKey() for key in pairs(D.Keys) do if GetItemCount(key) > 0 then return key end end end

-- Build blacklist from settings
function D:Blacklisting(skill) D['BuildBlacklist' .. skill](self) end

function D:BuildBlacklistDE(...)
	wipe(D.BlacklistDE)
	for index = 1, select('#', ...) do
		local name = select(index, ...)
		if name and name ~= "" then
			local itemName = GetItemInfo(name)
			if itemName then D.BlacklistDE[itemName] = true end
		end
	end
end

function D:BuildBlacklistLOCK(...)
	wipe(D.BlacklistLOCK)
	for index = 1, select('#', ...) do
		local name = select(index, ...)
		if name and name ~= "" then
			local itemName = GetItemInfo(name)
			if itemName then D.BlacklistLOCK[itemName] = true end
		end
	end
end

-- Check if item can be disenchanted
function D:IsBreakable(itemId, itemName, itemQuality, equipSlot)
	if not itemId then return false end
	if type(itemId) == "number" then itemId = tostring(itemId) end

	-- Check blacklists
	if D.ItemTable['DoNotDE'][itemId] then return false end
	if D.ItemTable['Cooking'][itemId] then return false end
	if D.ItemTable['Fishing'][itemId] then return false end
	if D.BlacklistDE[itemName] then return false end

	return true
end

-- Check if item is disenchantable
function D:IsDisenchantable(itemId)
	if not itemId then return false end

	local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc = GetItemInfo(itemId)
	if not itemName then return false end

	-- Quality: 2=Uncommon, 3=Rare, 4=Epic
	if not itemRarity or itemRarity < 2 or itemRarity > 4 then return false end

	if itemType ~= "Armor" and itemType ~= "Weapon" then return false end
	if not itemEquipLoc or itemEquipLoc == "" then return false end
	if not D.HasEnchanting then return false end

	return true
end

-- Check if item can be prospected
function D:IsProspectable(itemId)
	if not itemId or not D.HasJewelcrafting then return false end

	-- Prospectable ores in WotLK (3.3.5a)
	local prospectableOres = {
		[2770] = true, -- Copper Ore
		[2771] = true, -- Tin Ore
		[2772] = true, -- Iron Ore
		[3858] = true, -- Mithril Ore
		[10620] = true, -- Thorium Ore
		[23424] = true, -- Fel Iron Ore
		[23425] = true, -- Adamantite Ore
		[36909] = true, -- Cobalt Ore
		[36912] = true, -- Saronite Ore
		[36910] = true -- Titanium Ore
	}

	return prospectableOres[tonumber(itemId)] or false
end

-- Check if item can be milled
function D:IsMillable(itemId)
	if not itemId or not D.HasInscription then return false end

	-- Millable herbs in WotLK (3.3.5a)
	local millableHerbs = {
		[765] = true, -- Silverleaf
		[2447] = true, -- Peacebloom
		[2449] = true, -- Earthroot
		[785] = true, -- Mageroyal
		[2450] = true, -- Briarthorn
		[2452] = true, -- Swiftthistle
		[2453] = true, -- Bruiseweed
		[3820] = true, -- Stranglekelp
		[3369] = true, -- Grave Moss
		[3356] = true, -- Kingsblood
		[3357] = true, -- Liferoot
		[3818] = true, -- Fadeleaf
		[3821] = true, -- Goldthorn
		[3358] = true, -- Khadgar's Whisker
		[3819] = true, -- Dragon's Teeth (Wintersbite)
		[8836] = true, -- Arthas' Tears
		[8838] = true, -- Sungrass
		[8839] = true, -- Blindweed
		[8845] = true, -- Ghost Mushroom
		[8846] = true, -- Gromsblood
		[13464] = true, -- Golden Sansam
		[13463] = true, -- Dreamfoil
		[13465] = true, -- Mountain Silversage
		[13466] = true, -- Plaguebloom
		[13467] = true, -- Icecap
		[22785] = true, -- Felweed
		[22786] = true, -- Dreaming Glory
		[22787] = true, -- Ragveil
		[22789] = true, -- Terocone
		[22790] = true, -- Ancient Lichen
		[22791] = true, -- Netherbloom
		[22792] = true, -- Nightmare Vine
		[22793] = true, -- Mana Thistle
		[36901] = true, -- Goldclover
		[36903] = true, -- Adder's Tongue
		[36904] = true, -- Tiger Lily
		[36905] = true, -- Lichbloom
		[36906] = true, -- Icethorn
		[36907] = true, -- Talandra's Rose
		[37921] = true, -- Deadnettle
		[39970] = true -- Fire Leaf
	}

	return millableHerbs[tonumber(itemId)] or false
end

-- Check if item is currently locked (scan tooltip)
function D:IsUnlockable(itemLink)
	if not itemLink then return false end

	-- Scan tooltip for "Locked" text
	GameTooltip:SetOwner(UIParent, "ANCHOR_NONE")
	GameTooltip:SetHyperlink(itemLink)

	for i = 2, GameTooltip:NumLines() do
		local line = _G["GameTooltipTextLeft" .. i]
		if line then
			local text = line:GetText()
			if text and strfind(text, LOCKED) then
				GameTooltip:Hide()
				return true
			end
		end
	end

	GameTooltip:Hide()
	return false
end

-- Apply the deconstruct overlay to a bag slot
function D:ApplyDeconstruct(itemLink, itemId, spell, spellType, r, g, b, slot)
	if not slot then return end
	if slot == D.DeconstructionReal then return end

	local bag = slot:GetParent():GetID()

	-- Verify the bag and slot exist in ElvUI's bag or bank structure
	local validBag = (B.BagFrame and B.BagFrame.Bags and B.BagFrame.Bags[bag]) or (B.BankFrame and B.BankFrame.Bags and B.BankFrame.Bags[bag])
	if not validBag then return end

	D.DeconstructionReal.Bag = bag
	D.DeconstructionReal.Slot = slot:GetID()

	-- Check if in trade window
	if GetTradeTargetItemLink and GetTradeTargetItemLink(7) == itemLink then
		return
	elseif GetContainerItemLink(bag, slot:GetID()) == itemLink then
		D.DeconstructionReal.ID = itemId
		D.DeconstructionReal:SetAttribute('type1', spellType)
		D.DeconstructionReal:SetAttribute(spellType, spell)
		D.DeconstructionReal:SetAttribute('target-bag', D.DeconstructionReal.Bag)
		D.DeconstructionReal:SetAttribute('target-slot', D.DeconstructionReal.Slot)
		D.DeconstructionReal:SetAllPoints(slot)
		D.DeconstructionReal:Show()

		-- Apply visual effect (ActionButton_ShowOverlayGlow confirmed on Ascension)
		ActionButton_ShowOverlayGlow(D.DeconstructionReal)
	end
end

-- Get deconstruct mode status text
function D:GetDeconMode()
	local text
	if D.DeconstructMode then
		text = '|cff00FF00 ' .. VIDEO_OPTIONS_ENABLED .. '|r'
	else
		text = '|cffFF0000 ' .. VIDEO_OPTIONS_DISABLED .. '|r'
	end
	return text
end

-- Toggle deconstruct mode (called from button click)
function D:ToggleMode()
	-- Don't toggle if player doesn't have required professions
	if not D:HasRelevantProfession() then return end
	
	D.DeconstructMode = not D.DeconstructMode

	if D.DeconstructButton then
		local normalTex = D.DeconstructButton:GetNormalTexture()
		if normalTex then
			if D.DeconstructMode then
				normalTex:SetTexture([[Interface\ICONS\INV_Enchant_EssenceCosmicGreater]])
				ActionButton_ShowOverlayGlow(D.DeconstructButton)
			else
				normalTex:SetTexture([[Interface\ICONS\INV_Rod_Enchantedcobalt]])
				ActionButton_HideOverlayGlow(D.DeconstructButton)
			end
		end

		D.DeconstructButton.ttText2 = format(L["Deconstruct Mode Desc"] .. "\n" .. L["Current state: %s."], D:GetDeconMode())
		if GameTooltip:IsOwned(D.DeconstructButton) then B.Tooltip_Show(D.DeconstructButton) end
	end

	-- Update both bag and bank slots
	if B.BagFrame then D:UpdateBagSlots(B.BagFrame, D.DeconstructMode) end
	if B.BankFrame then D:UpdateBagSlots(B.BankFrame, D.DeconstructMode) end
end

-- Create the actual deconstruct button overlay
function D:ConstructRealDecButton()
	D.DeconstructionReal = CreateFrame('Button', 'ElvUI_DeconReal', E.UIParent, 'SecureActionButtonTemplate')
	D.DeconstructionReal:SetScript('OnEvent', function(obj, event, ...) obj[event](obj, ...) end)
	D.DeconstructionReal:RegisterForClicks('AnyUp', 'AnyDown')
	D.DeconstructionReal:SetFrameStrata('TOOLTIP')

	D.DeconstructionReal.OnLeave = function(frame)
		if InCombatLockdown() then
			frame:SetAlpha(0)
			frame:RegisterEvent('PLAYER_REGEN_ENABLED')
		else
			frame:ClearAllPoints()
			frame:SetAlpha(1)
			if GameTooltip then GameTooltip:Hide() end

			-- Stop visual effects
			ActionButton_HideOverlayGlow(frame)

			frame:Hide()
		end
	end

	D.DeconstructionReal.SetTip = function(f)
		GameTooltip:SetOwner(f, 'ANCHOR_LEFT', 0, 4)
		GameTooltip:ClearLines()
		GameTooltip:SetBagItem(f.Bag, f.Slot)
	end

	D.DeconstructionReal:SetScript('OnEnter', D.DeconstructionReal.SetTip)
	D.DeconstructionReal:SetScript('OnLeave', function() D.DeconstructionReal:OnLeave() end)
	D.DeconstructionReal:Hide()

	function D.DeconstructionReal:PLAYER_REGEN_ENABLED()
		self:UnregisterEvent('PLAYER_REGEN_ENABLED')
		D.DeconstructionReal:OnLeave()
	end
end

-- Parse tooltip to determine if item should show deconstruct button
function D:DeconstructParser()
	if not D.DeconstructMode then return end
	if not GameTooltip:IsVisible() then return end

	local owner = GameTooltip:GetOwner()
	if not owner then return end

	local ownerName = owner.GetName and owner:GetName()
	if not ownerName then return end

	-- Only process ElvUI bag and bank slots
	if not (strfind(ownerName, 'ElvUI_ContainerFrameBag') or strfind(ownerName, 'ElvUI_BankContainerFrameBag')) then return end

	-- Get the bag and slot from the owner
	local bag, slot
	if owner.GetParent then
		local parent = owner:GetParent()
		if parent.GetID then bag = parent:GetID() end
	end
	if owner.GetID then slot = owner:GetID() end

	if not bag or not slot then return end

	local itemLink = GetContainerItemLink(bag, slot)
	if not itemLink then return end

	local itemId = tonumber(itemLink:match("item:(%d+)"))
	if not itemId then return end

	if InCombatLockdown() then return end

	-- Check what can be done with this item
	local r, g, b

	-- Check for lockboxes
	local hasKey = HaveKey()
	if (D.HasPickLock or hasKey) and D:IsUnlockable(itemLink) then
		r, g, b = 0, 1, 1
		if D.HasPickLock then
			D:ApplyDeconstruct(itemLink, itemId, D.LOCKname, 'spell', r, g, b, owner)
		elseif hasKey then
			D:ApplyDeconstruct(itemLink, itemId, hasKey, 'item', r, g, b, owner)
		end
		return
	end

	-- Check for prospectable ores (Jewelcrafting only)
	if D.HasJewelcrafting and D:IsProspectable(itemId) then
		r, g, b = 1, 0.5, 0
		D:ApplyDeconstruct(itemLink, itemId, D.PROSPECTname, 'spell', r, g, b, owner)
		return
	end

	-- Check for millable herbs (Inscription only)
	if D.HasInscription and D:IsMillable(itemId) then
		r, g, b = 0, 1, 0
		D:ApplyDeconstruct(itemLink, itemId, D.MILLname, 'spell', r, g, b, owner)
		return
	end

	-- Check for disenchantable items (Enchanting only)
	if D.HasEnchanting and D:IsDisenchantable(itemId) then
		local itemName, _, itemQuality, _, _, _, _, _, equipSlot = GetItemInfo(itemId)
		if D:IsBreakable(itemId, itemName, itemQuality, equipSlot) then
			r, g, b = 0.5, 0, 1
			D:ApplyDeconstruct(itemLink, itemId, D.DEname, 'spell', r, g, b, owner)
			return
		end
	end
end

-- Check if an item can be processed (disenchant/mill/prospect/unlock)
function D:CanProcessItem(itemLink, hasKey)
	if not itemLink then return false end

	local itemId = tonumber(itemLink:match("item:(%d+)"))
	if not itemId then return false end

	-- Check lockboxes (Rogues only)
	if (D.HasPickLock or hasKey) and D:IsUnlockable(itemLink) then return true end

	-- Check prospectable (Jewelcrafting only)
	if D.HasJewelcrafting and D:IsProspectable(itemId) then return true end

	-- Check millable (Inscription only)
	if D.HasInscription and D:IsMillable(itemId) then return true end

	-- Check disenchantable (Enchanting only)
	if D.HasEnchanting and D:IsDisenchantable(itemId) then
		local itemName, _, itemQuality, _, _, _, _, _, equipSlot = GetItemInfo(itemId)
		if D:IsBreakable(itemId, itemName, itemQuality, equipSlot) then return true end
	end

	return false
end

-- Update all bag/bank slots to dim non-processable items
function D:UpdateBagSlots(frame, isActive)
	if not frame or not frame.Bags then return end

	local hasKey = HaveKey()
	for _, bagID in ipairs(frame.BagIDs) do
		if frame.Bags[bagID] then
			for slotID = 1, GetContainerNumSlots(bagID) do
				local slot = frame.Bags[bagID][slotID]
				if slot then
					if isActive then
						-- Dim items that can't be processed
						local itemLink = GetContainerItemLink(bagID, slotID)
						if itemLink and D:CanProcessItem(itemLink, hasKey) then
							slot:SetAlpha(1)
						else
							slot:SetAlpha(0.3)
						end
					else
						-- Restore normal alpha
						slot:SetAlpha(1)
					end
				end
			end
		end
	end
end

-- Helper function to create and setup the deconstruct button
local function CreateDeconstructButton(bagFrame)
	if not bagFrame or not bagFrame.holderFrame then return end
	if bagFrame.deconstructButton then return end -- Already created

	-- Create the button
	local button = CreateFrame("Button", nil, bagFrame.holderFrame)
	button:Size(16 + E.Border)
	button:SetTemplate()
	button:Point("RIGHT", bagFrame.vendorGraysButton, "LEFT", -5, 0)
	button:SetNormalTexture("Interface\\ICONS\\INV_Rod_Enchantedcobalt")
	button:GetNormalTexture():SetTexCoord(unpack(E.TexCoords))
	button:GetNormalTexture():SetInside()
	button:SetPushedTexture("Interface\\ICONS\\INV_Rod_Enchantedcobalt")
	button:GetPushedTexture():SetTexCoord(unpack(E.TexCoords))
	button:GetPushedTexture():SetInside()
	button:StyleButton(nil, true)
	button.ttText = L["Deconstruct Mode"]
	button.ttText2 = format(L["Deconstruct Mode Desc"] .. "\n" .. L["Current state: %s."], D:GetDeconMode())
	button:SetScript("OnEnter", B.Tooltip_Show)
	button:SetScript("OnLeave", GameTooltip_Hide)
	button:SetScript("OnClick", function() D:ToggleMode() end)

	bagFrame.deconstructButton = button
	D.DeconstructButton = button

	-- Re-anchor the search box to the deconstruct button
	if bagFrame.editBox then
		bagFrame.editBox:ClearAllPoints()
		bagFrame.editBox:Point("BOTTOMLEFT", bagFrame.holderFrame, "TOPLEFT", (E.Border * 2) + 18, E.Border * 2 + 2)
		bagFrame.editBox:Point("RIGHT", bagFrame.deconstructButton, "LEFT", -5, 0)
	end
end

-- Helper function to setup button and hooks (called once when bags are first opened)
local function SetupDeconstructButton()
	if D.DeconstructButton then return end

	-- Update professions first
	D:UpdateProfessions()

	if not B.BagFrame then return end

	-- Create the button (always show if module is enabled)
	CreateDeconstructButton(B.BagFrame)
	
	-- Update button state (enabled/disabled)
	D:UpdateButtonState()

	-- Only create the real deconstruct button and hooks once
	if not D.DeconstructionReal then
		D:ConstructRealDecButton()

		-- Hook GameTooltip to detect when mousing over items
		GameTooltip:HookScript('OnShow', function() D:DeconstructParser() end)
		GameTooltip:HookScript('OnUpdate', function() D:DeconstructParser() end)
	end

	-- Hide deconstruct mode when bags close
	B.BagFrame:HookScript('OnHide', function()
		D.DeconstructMode = false
		if D.DeconstructButton then
			local normalTex = D.DeconstructButton:GetNormalTexture()
			if normalTex then normalTex:SetTexture([[Interface\ICONS\INV_Rod_Enchantedcobalt]]) end
			ActionButton_HideOverlayGlow(D.DeconstructButton)
		end
		if B.BagFrame then D:UpdateBagSlots(B.BagFrame, false) end
		if B.BankFrame then D:UpdateBagSlots(B.BankFrame, false) end
		if D.DeconstructionReal then D.DeconstructionReal:OnLeave() end
	end)
end

-- Initialize the module
function D:Initialize()
	if not E.private.bags.enable then return end
	if not E.db.bags.deconstruct then return end -- Check if deconstruct is enabled

	-- Hook into Layout to setup button for bags and reapply dimming
	hooksecurefunc(B, "Layout", function(_, isBank)
		if not isBank then if B.BagFrame and not D.DeconstructButton then E:Delay(0.1, function() SetupDeconstructButton() end) end end

		-- Reapply dimming after layout (layout resets slot alpha)
		if D.DeconstructMode then
			E:Delay(0.05, function()
				if B.BagFrame then D:UpdateBagSlots(B.BagFrame, true) end
				if B.BankFrame then D:UpdateBagSlots(B.BankFrame, true) end
			end)
		end
	end)

	-- Build blacklists
	D:Blacklisting('DE')
	D:Blacklisting('LOCK')

	-- Register events
	D:RegisterEvent('BAG_UPDATE')
	D:RegisterEvent('SKILL_LINES_CHANGED')

	-- If bag frame already exists, setup button now
	if B.BagFrame and not D.DeconstructButton then E:Delay(0.1, function() SetupDeconstructButton() end) end
end

-- Handle SKILL_LINES_CHANGED event
function D:SKILL_LINES_CHANGED()
	D:UpdateProfessions()

	-- Update button state (enabled/disabled) based on professions
	D:UpdateButtonState()
end

-- Handle BAG_UPDATE event
function D:BAG_UPDATE()
	if D.DeconstructMode then
		if B.BagFrame then D:UpdateBagSlots(B.BagFrame, true) end
		if B.BankFrame then D:UpdateBagSlots(B.BankFrame, true) end
	end
end

-- Wait for ElvUI to fully load before initializing
hooksecurefunc(B, "Initialize", function() D:Initialize() end)
