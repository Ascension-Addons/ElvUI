local E, L, V, P, G = unpack(select(2, ...)); --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB

P.gridSize = 64
P.farmSize = 340

local _, myclass = UnitClass("player")
--Core
P.general = {
	messageRedirect = DEFAULT_CHAT_FRAME:GetName(),
	smoothingAmount = 0.33,
	taintLog = false,
	stickyFrames = true,
	loginmessage = true,
	interruptAnnounce = "NONE",
	autoRoll = false,
	autoAcceptInvite = false,
	bottomPanel = true,
	hideErrorFrame = true,
	enhancedPvpMessages = true,
	watchFrameHeight = 480,
	watchFrameAutoHide = true,
	vehicleSeatIndicatorSize = 128,
	afk = true,
	numberPrefixStyle = "ENGLISH",
	decimalLength = 1,
	font = "PT Sans Narrow",
	fontSize = 12,
	fontStyle = "OUTLINE",
	bordercolor = {r = 0, g = 0, b = 0},
	backdropcolor = {r = 0.1, g = 0.1, b = 0.1},
	backdropfadecolor = {r = 0.06, g = 0.06, b = 0.06, a = 0.8},
	valuecolor = {r = 0.99, g = 0.48, b = 0.17},
	herocolor = RAID_CLASS_COLORS[myclass],
	cropIcon = 2,
	minimap = {
		size = 176,
		locationText = "MOUSEOVER",
		locationFontSize = 12,
		locationFontOutline = "OUTLINE",
		locationFont = "PT Sans Narrow",
		resetZoom = {
			enable = false,
			time = 3
		},
		icons = {
			calendar = {
				scale = 1,
				position = "TOPRIGHT",
				xOffset = 0,
				yOffset = 0,
				hide = true
			},
			mail = {
				scale = 1,
				position = "TOPRIGHT",
				xOffset = 3,
				yOffset = 4
			},
			lfgEye = {
				scale = 1,
				position = "BOTTOMRIGHT",
				xOffset = 3,
				yOffset = 0
			},
			battlefield = {
				scale = 1,
				position = "BOTTOMRIGHT",
				xOffset = 3,
				yOffset = 0
			},
			difficulty = {
				scale = 1,
				position = "TOPLEFT",
				xOffset = 0,
				yOffset = 0
			},
			vehicleLeave = {
				scale = 1,
				position = "BOTTOMLEFT",
				xOffset = 2,
				yOffset = 2,
				hide = false
			}
		}
	},
	mapMarkers = {
		enable = true,
		showRaidMarkers = true,
		iconSize = 31,
	},
	threat = {
		enable = true,
		position = "RIGHTCHAT",
		textSize = 12,
		textOutline = "NONE"
	},
	totems = {
		enable = true,
		growthDirection = "VERTICAL",
		sortDirection = "ASCENDING",
		size = 40,
		spacing = 4
	},
	reminder = {
		enable = false,
		durations = true,
		reverse = true,
		position = "RIGHT",
		font = "Homespun",
		fontSize = 10,
		fontOutline = "MONOCHROMEOUTLINE"
	},
	kittys = false
}

--DataBars
P.databars = {
	experience = {
		enable = true,
		width = 10,
		height = 180,
		textFormat = "NONE",
		textSize = 11,
		font = "PT Sans Narrow",
		fontOutline = "NONE",
		mouseover = false,
		orientation = "VERTICAL",
		hideAtMaxLevel = true,
		hideInVehicle = false,
		hideInCombat = false,
		showBubbles = false,
		questXP = {
			color = {r = 0, g = 1, b = 0, a = 0.4},
			tooltip = true,
			questCurrentZoneOnly = false,
			questCompletedOnly = false
		}
	},
	reputation = {
		enable = false,
		width = 10,
		height = 180,
		textFormat = "NONE",
		textSize = 11,
		font = "PT Sans Narrow",
		fontOutline = "NONE",
		mouseover = false,
		orientation = "VERTICAL",
		hideInVehicle = false,
		hideInCombat = false,
		showBubbles = false
	}
}

--Bags
P.bags = {
	sortInverted = true,
	bagSize = 34,
	bankSize = 34,
	bagWidth = 406,
	bankWidth = 406,
	currencyFormat = "ICON_TEXT_ABBR",
	moneyFormat = "SMART",
	moneyCoins = true,
	junkIcon = false,
	junkDesaturate = true,
	ignoredItems = {},
	itemLevel = true,
	itemLevelThreshold = 1,
	itemLevelFont = "Homespun",
	itemLevelFontSize = 10,
	itemLevelFontOutline = "MONOCHROMEOUTLINE",
	itemLevelCustomColorEnable = false,
	itemLevelCustomColor = {r = 1, g = 1, b = 1},
	countFont = "Homespun",
	countFontSize = 10,
	countFontOutline = "MONOCHROMEOUTLINE",
	countFontColor = {r = 1, g = 1, b = 1},
	reverseSlots = false,
	clearSearchOnClose = false,
	disableBagSort = false,
	disableBankSort = false,
	strata = "DIALOG",
	qualityColors = true,
	showBindType = false,
	transparent = false,
	questIcon = true,
	professionBagColors = true,
	questItemColors = true,
	colors = {
		profession = {
			quiver = {r = 1, g = 0.69, b = 0.41},
			ammoPouch = {r = 1, g = 0.69, b = 0.41},
			soulBag = {r = 1, g = 0.69, b = 0.41},
			leatherworking = {r = 0.88, g = 0.73, b = 0.29},
			inscription = {r = 0.29, g = 0.30, b = 0.88},
			herbs = {r = 0.07, g = 0.71, b = 0.13},
			enchanting = {r = 0.76, g = 0.02, b = 0.8},
			engineering = {r = 0.91, g = 0.46, b = 0.18},
			gems = {r = 0.03, g = 0.71, b = 0.81},
			mining = {r = 0.54, g = 0.40, b = 0.04}
		},
		items = {
			questStarter = {r = 1, g = 1, b = 0},
			questItem = {r = 1, g = 0.30, b = 0.30}
		}
	},
	split = {
		bagSpacing = 5,
		player = false,
		bank = false,
		bag1 = false,
		bag2 = false,
		bag3 = false,
		bag4 = false,
		bag5 = false,
		bag6 = false,
		bag7 = false,
		bag8 = false,
		bag9 = false,
		bag10 = false,
		bag11 = false
	},
	cooldown = {
		override = false,
		reverse = false,
		threshold = 3,
		expiringColor = {r = 1, g = 0, b = 0},
		secondsColor = {r = 1, g = 1, b = 1},
		minutesColor = {r = 1, g = 1, b = 1},
		hoursColor = {r = 1, g = 1, b = 1},
		daysColor = {r = 1, g = 1, b = 1},
		expireIndicator = {r = 1, g = 1, b = 1},
		secondsIndicator = {r = 1, g = 1, b = 1},
		minutesIndicator = {r = 1, g = 1, b = 1},
		hoursIndicator = {r = 1, g = 1, b = 1},
		daysIndicator = {r = 1, g = 1, b = 1},
		hhmmColorIndicator = {r = 1, g = 1, b = 1},
		mmssColorIndicator = {r = 1, g = 1, b = 1},

		checkSeconds = false,
		hhmmColor = {r = 0.43, g = 0.43, b = 0.43},
		mmssColor = {r = 0.56, g = 0.56, b = 0.56},
		hhmmThreshold = -1,
		mmssThreshold = -1,

		fonts = {
			enable = false,
			font = "PT Sans Narrow",
			fontOutline = "OUTLINE",
			fontSize = 18
		}
	},
	bagBar = {
		growthDirection = "VERTICAL",
		sortDirection = "ASCENDING",
		size = 30,
		spacing = 4,
		backdropSpacing = 4,
		showBackdrop = false,
		mouseover = false,
		visibility = ""
	}
}

local NP_Auras = {
	enable = true,
	desaturate = true,
	numAuras = 8,
	numRows = 1,
	size = 20,
	height = 23,
	attachTo = 'FRAME',
	keepSizeRatio = true,
	anchorPoint = 'TOPLEFT',
	growthDirection = 'RIGHT_UP',
	onlyShowPlayer = false,
	stackAuras = true,
	sortDirection = 'DESCENDING',
	sortMethod = 'TIME_REMAINING',
	spacing = 1,
	yOffset = 5,
	xOffset = 0,
	font = 'PT Sans Narrow',
	fontOutline = 'OUTLINE',
	fontSize = 11,
	countPosition = 'BOTTOMRIGHT',
	countFont = 'PT Sans Narrow',
	countFontOutline = 'OUTLINE',
	countFontSize = 9,
	countXOffset = 0,
	countYOffset = 2,
	durationPosition = 'CENTER',
	minDuration = 0,
	maxDuration = 300,
	priority = ''
}

local NP_Health = {
	enable = true,
	healPrediction = true,
	height = 10,
	useClassColor = true,
	text = {
		enable = true,
		format = '[health:percent]',
		position = 'CENTER',
		parent = 'Nameplate',
		xOffset = 0,
		yOffset = 0,
		font = 'PT Sans Narrow',
		fontOutline = 'OUTLINE',
		fontSize = 11,
	},
}

local NP_Power = {
	enable = false,
	classColor = false,
	hideWhenEmpty = false,
	costPrediction = true,
	width = 150,
	height = 8,
	xOffset = 0,
	yOffset = -10,
	displayAltPower = false,
	useAtlas = false,
	text = {
		enable = false,
		format = '[power:percent]',
		position = 'CENTER',
		parent = 'Nameplate',
		xOffset = 0,
		yOffset = -10,
		font = 'PT Sans Narrow',
		fontOutline = 'OUTLINE',
		fontSize = 11,
	},
}

local NP_PvPIcon = {
	enable = false,
	showBadge = true,
	position = 'RIGHT',
	size = 36,
	xOffset = 0,
	yOffset = 0,
}

local NP_PvPClassificationIndicator = {
	enable = false,
	position = 'TOPLEFT',
	size = 36,
	xOffset = 0,
	yOffset = 0,
}

local NP_Portrait = {
	enable = false,
	position = 'RIGHT',
	classicon = true,
	height = 28,
	width = 28,
	xOffset = 3,
	yOffset = -5,
}

local NP_Name = {
	enable = true,
	format = '[classcolor][name]',
	position = 'TOPLEFT',
	parent = 'Nameplate',
	xOffset = 0,
	yOffset = -7,
	font = 'PT Sans Narrow',
	fontOutline = 'OUTLINE',
	fontSize = 11,
}

local NP_Level = {
	enable = true,
	format = '[difficultycolor][level]',
	position = 'TOPRIGHT',
	parent = 'Nameplate',
	xOffset = 0,
	yOffset = -7,
	font = 'PT Sans Narrow',
	fontOutline = 'OUTLINE',
	fontSize = 11,
}

local NP_RaidTargetIndicator = {
	enable = true,
	size = 24,
	position = 'LEFT',
	xOffset = -4,
	yOffset = 0,
}

local NP_Castbar = {
	enable = true,
	width = 150,
	height = 8,
	displayTarget = false,
	hideSpellName = false,
	hideTime = false,
	sourceInterrupt = true,
	sourceInterruptClassColor = true,
	castTimeFormat = 'CURRENT',
	channelTimeFormat = 'CURRENT',
	timeToHold = 0,
	textPosition = 'BELOW',
	iconPosition = 'RIGHT',
	iconSize = 30,
	iconOffsetX = 0,
	iconOffsetY = 0,
	showIcon = true,
	xOffset = 0,
	yOffset = -10,
	timeXOffset = 0,
	timeYOffset = 0,
	textYOffset = 0,
	textXOffset = 0,
	font = 'PT Sans Narrow',
	fontOutline = 'OUTLINE',
	fontSize = 11,
}

local NP_Title = {
	enable = false,
	format = '[guild:brackets]',
	position = 'TOPRIGHT',
	parent = 'Nameplate',
	xOffset = 0,
	yOffset = -7,
	font = 'PT Sans Narrow',
	fontOutline = 'OUTLINE',
	fontSize = 11,
}

local NP_EliteIcon = {
	enable = false,
	size = 20,
	position = 'RIGHT',
	xOffset = 15,
	yOffset = 0,
}

local NP_QuestIcon = {
	enable = true,
	hideIcon = false,
	position = 'RIGHT',
	textPosition = 'BOTTOMRIGHT',
	size = 20,
	xOffset = 0,
	yOffset = 0,
	font = 'PT Sans Narrow',
	fontOutline = 'OUTLINE',
	fontSize = 12
}

--NamePlate
P.nameplates = {
	fadeIn = true,
	font = 'PT Sans Narrow',
	fontOutline = 'OUTLINE',
	fontSize = 11,
	highlight = true,
	loadDistance = 41,
	lowHealthThreshold = 0.4,
	motionType = 'STACKED',
	nameColoredGlow = false,
	overlapH = 0.8,
	overlapV = 1.1,
	showEnemyCombat = 'DISABLED',
	showFriendlyCombat = 'DISABLED',
	smoothbars = false,
	statusbar = 'ElvUI Norm',
	thinBorders = true,
	clickThrough = {
		personal = false,
		friendly = false,
		enemy = false,
	},
	bossMods = {
		enable = true,
		anchorPoint = 'BOTTOM',
		growthDirection = 'RIGHT_UP',
		size = 34,
		height = 24,
		spacing = 1,
		yOffset = -5,
		xOffset = 0
	},
	plateSize = {
		personalWidth = 150,
		personalHeight = 30,
		friendlyWidth = 150,
		friendlyHeight = 30,
		enemyWidth = 150,
		enemyHeight = 30,
	},
	threat = {
		enable = true,
		beingTankedByPet = true,
		beingTankedByTank = true,
		goodScale = 1,
		badScale = 1,
		useThreatColor = true,
		indicator = false,
	},
	filters = {
		ElvUI_Boss = {triggers = {enable = false}},
		ElvUI_Target = {triggers = {enable = true}},
		ElvUI_NonTarget = {triggers = {enable = true}},
		ElvUI_Explosives = {triggers = {enable = true}},
	},
	colors = {
		auraByType = true,
		auraByDispels = true,
		preferGlowColor = true,
		glowColor = {r = 1, g = 1, b = 1, a = 1},
		lowHealthColor = {r = 1, g = 1, b = 0.3, a = 1},
		lowHealthHalf = {r = 1, g = 0.3, b = 0.3, a = 1},
		castColor = {r = 1, g = 0.81, b = 0},
		tapped = {r = 0.6, g = 0.6, b = 0.6},
		castNoInterruptColor = {r = 0.78, g = 0.25, b = 0.25},
		castInterruptedColor = {r = 0.30, g = 0.30, b = 0.30},
		castbarDesaturate = true,
		chargingRunes = true,
		runeBySpec = true,
		reactions = {
			good = {r = .29, g = .68, b = .30},
			neutral = {r = .85, g = .77, b = .36},
			bad = {r = 0.78, g = 0.25, b = 0.25},
		},
		healPrediction = {
			personal = {r = 0, g = 1, b = 0.5, a = 0.25},
			others = {r = 0, g = 1, b = 0, a = 0.25},
		},
		threat = {
			goodColor = {r = 0.20, g = 0.71, b = 0.00},
			badColor = {r = 1.00, g = 0.18, b = 0.18},
			goodTransition = {r = 1.00, g = 0.85, b = 0.20},
			badTransition ={r = 1.00, g = 0.51, b = 0.20},
			offTankColor = {r = 0.73, g = 0.20, b = 1.00},
			offTankColorGoodTransition = {r = .31, g = .45, b = .63},
			offTankColorBadTransition = {r = 0.71, g = 0.43, b = 0.27},
		},
		power = {
			ENERGY = {r = 1, g = 0.96, b = 0.41},
			FOCUS = {r = 1, g = 0.50, b = 0.25},
			MANA = {r = 0.31, g = 0.45, b = 0.63},
			RAGE = {r = 0.78, g = 0.25, b = 0.25},
			RUNIC_POWER = {r = 0, g = 0.82, b = 1},
			ALT_POWER = {r = 0.2, g = 0.4, b = 0.8},
		},
		selection = {
			[ 0] = {r = 1.00, g = 0.18, b = 0.18}, -- HOSTILE
			[ 1] = {r = 1.00, g = 0.51, b = 0.20}, -- UNFRIENDLY
			[ 2] = {r = 1.00, g = 0.85, b = 0.20}, -- NEUTRAL
			[ 3] = {r = 0.20, g = 0.71, b = 0.00}, -- FRIENDLY
			[ 5] = {r = 0.40, g = 0.53, b = 1.00}, -- PLAYER_EXTENDED
			[ 6] = {r = 0.40, g = 0.20, b = 1.00}, -- PARTY
			[ 7] = {r = 0.73, g = 0.20, b = 1.00}, -- PARTY_PVP
			[ 8] = {r = 0.20, g = 1.00, b = 0.42}, -- FRIEND
			[ 9] = {r = 0.60, g = 0.60, b = 0.60}, -- DEAD
			[13] = {r = 0.10, g = 0.58, b = 0.28}, -- BATTLEGROUND_FRIENDLY_PVP
		},
		empoweredCast = {
			{r = 1.00, g = 0.26, b = 0.20, a = 0.3}, -- red
			{r = 1.00, g = 0.80, b = 0.26, a = 0.3}, -- orange
			{r = 1.00, g = 1.00, b = 0.26, a = 0.3}, -- yellow
			{r = 0.66, g = 1.00, b = 0.40, a = 0.3}, -- green
		},
		classResources = {
			chargedComboPoint = { r = 0.16, g = 0.64, b = 1.0 },
			comboPoints = {
				{r = 0.75, g = 0.31, b = 0.31},
				{r = 0.78, g = 0.56, b = 0.31},
				{r = 0.81, g = 0.81, b = 0.31},
				{r = 0.56, g = 0.78, b = 0.31},
				{r = 0.43, g = 0.76, b = 0.31},
				{r = 0.31, g = 0.75, b = 0.31},
				{r = 0.36, g = 0.81, b = 0.54},
			},
			DEATHKNIGHT = {
				[-1] = {r = 0.5, g = 0.5, b = 0.5},
				[0] = {r = 0.8, g = 0.1, b = 0.28},
				{r = 1, g = 0.25, b = 0.25},
				{r = 0.25, g = 1, b = 1},
				{r = 0.25, g = 1, b = 0.25},
				{r = 0.8, g = 0.4, b = 1}
			},
		},
	},
	visibility = {
		showAll = true,
		showOnlyNames = false,
		enemy = {
			guardians = false,
			pets = false,
			totems = false,
		},
		friendly = {
			guardians = false,
			npcs = true,
			pets = false,
			totems = false,
		},
	},
	cutaway = {
		health = {
			enabled = false,
			fadeOutTime = 0.6,
			lengthBeforeFade = 0.3,
			forceBlankTexture = true,
		},
		power = {
			enabled = false,
			fadeOutTime = 0.6,
			lengthBeforeFade = 0.3,
			forceBlankTexture = true,
		},
	},
	units = {
		PLAYER = {
			useStaticPosition = false,
			clickthrough = false,
			classpower = {
				enable = true,
				classColor = false,
				height = 7,
				sortDirection = 'NONE',
				width = 130,
				xOffset = 0,
				yOffset = 10,
			},
			visibility = {
				alphaDelay = 1,
				hideDelay = 3,
				showAlways = false,
				showInCombat = true,
				showWithTarget = false,
			},
		},
		TARGET = {
			arrow = 'Arrow',
			arrowSize = 48,
			arrowSpacing = 3,
			glowStyle = 'style2',
			classpower = {
				enable = false,
				classColor = false,
				height = 7,
				sortDirection = 'NONE',
				width = 125,
				xOffset = 0,
				yOffset = 30,
			},
		},
		FRIENDLY_PLAYER = {
			markHealers = true,
			markTanks = true,
		},
		ENEMY_PLAYER = {
			markHealers = true,
			markTanks = true,
		},
		FRIENDLY_NPC = {},
		ENEMY_NPC = {},
	},
}

for unit, data in next, P.nameplates.units do
	data.enable = unit ~= 'PLAYER'

	if unit ~= 'TARGET' then
		data.showTitle = true
		data.smartAuraPosition = 'DISABLED'
		data.nameOnly = unit == 'FRIENDLY_NPC'

		data.buffs = CopyTable(NP_Auras)
		data.castbar = CopyTable(NP_Castbar)
		data.debuffs = CopyTable(NP_Auras)
		data.health = CopyTable(NP_Health)
		data.level = CopyTable(NP_Level)
		data.name = CopyTable(NP_Name)
		data.portrait = CopyTable(NP_Portrait)
		data.power = CopyTable(NP_Power)
		data.pvpindicator = CopyTable(NP_PvPIcon)
		data.raidTargetIndicator = CopyTable(NP_RaidTargetIndicator)
		data.title = CopyTable(NP_Title)

		if strfind(unit, '_NPC') then
			data.eliteIcon = CopyTable(NP_EliteIcon)
			data.questIcon = CopyTable(NP_QuestIcon)
		else
			data.pvpclassificationindicator = CopyTable(NP_PvPClassificationIndicator)
		end
	end
end

P.nameplates.units.PLAYER.buffs.maxDuration = 300
P.nameplates.units.PLAYER.buffs.priority = 'Blacklist,Dispellable,blockNoDuration,Personal,TurtleBuffs,PlayerBuffs'
P.nameplates.units.PLAYER.debuffs.anchorPoint = 'TOPRIGHT'
P.nameplates.units.PLAYER.debuffs.growthDirection = 'LEFT_UP'
P.nameplates.units.PLAYER.debuffs.yOffset = 35
P.nameplates.units.PLAYER.debuffs.priority = 'Blacklist,blockNoDuration,Personal,Boss,CCDebuffs,RaidDebuffs,Dispellable'
P.nameplates.units.PLAYER.name.enable = false
P.nameplates.units.PLAYER.name.format = '[name]'
P.nameplates.units.PLAYER.level.enable = false
P.nameplates.units.PLAYER.power.enable = true
P.nameplates.units.PLAYER.castbar.yOffset = -20

P.nameplates.units.FRIENDLY_PLAYER.buffs.priority = 'Blacklist,Dispellable,blockNoDuration,Personal,TurtleBuffs,PlayerBuffs'
P.nameplates.units.FRIENDLY_PLAYER.debuffs.anchorPoint = 'TOPRIGHT'
P.nameplates.units.FRIENDLY_PLAYER.debuffs.growthDirection = 'LEFT_UP'
P.nameplates.units.FRIENDLY_PLAYER.debuffs.yOffset = 35
P.nameplates.units.FRIENDLY_PLAYER.debuffs.priority = 'Blacklist,Personal,RaidDebuffs,CCDebuffs,Whitelist'

P.nameplates.units.ENEMY_PLAYER.buffs.priority = 'Blacklist,Dispellable,blockNoDuration,Personal,TurtleBuffs,PlayerBuffs'
P.nameplates.units.ENEMY_PLAYER.buffs.maxDuration = 300
P.nameplates.units.ENEMY_PLAYER.debuffs.anchorPoint = 'TOPRIGHT'
P.nameplates.units.ENEMY_PLAYER.debuffs.growthDirection = 'LEFT_UP'
P.nameplates.units.ENEMY_PLAYER.debuffs.yOffset = 35
P.nameplates.units.ENEMY_PLAYER.debuffs.priority = 'Blacklist,Personal,RaidDebuffs,CCDebuffs,Whitelist'
P.nameplates.units.ENEMY_PLAYER.name.format = '[classcolor][name:abbrev:long]'

P.nameplates.units.FRIENDLY_NPC.buffs.priority = 'Blacklist,Dispellable,blockNoDuration,Personal,TurtleBuffs,PlayerBuffs'
P.nameplates.units.FRIENDLY_NPC.debuffs.anchorPoint = 'TOPRIGHT'
P.nameplates.units.FRIENDLY_NPC.debuffs.growthDirection = 'LEFT_UP'
P.nameplates.units.FRIENDLY_NPC.debuffs.yOffset = 35
P.nameplates.units.FRIENDLY_NPC.debuffs.priority = 'Blacklist,Personal,RaidDebuffs,CCDebuffs,Whitelist'
P.nameplates.units.FRIENDLY_NPC.level.format = '[difficultycolor][level][shortclassification]'
P.nameplates.units.FRIENDLY_NPC.title.format = '[npctitle]'

P.nameplates.units.ENEMY_NPC.buffs.priority = 'Blacklist,Dispellable,blockNoDuration,Personal,TurtleBuffs,PlayerBuffs'
P.nameplates.units.ENEMY_NPC.debuffs.anchorPoint = 'TOPRIGHT'
P.nameplates.units.ENEMY_NPC.debuffs.growthDirection = 'LEFT_UP'
P.nameplates.units.ENEMY_NPC.debuffs.yOffset = 35
P.nameplates.units.ENEMY_NPC.debuffs.priority = 'Blacklist,Personal,RaidDebuffs,CCDebuffs,Whitelist'
P.nameplates.units.ENEMY_NPC.level.format = '[difficultycolor][level][shortclassification]'
P.nameplates.units.ENEMY_NPC.title.format = '[npctitle]'
P.nameplates.units.ENEMY_NPC.name.format = '[name]'

--Auras
P.auras = {
	font = "Homespun",
	fontOutline = "MONOCHROMEOUTLINE",
	countYOffset = 0,
	countXOffset = 0,
	timeYOffset = 0,
	timeXOffset = 0,
	fadeThreshold = 6,
	showDuration = true,
	barShow = false,
	barTexture = "ElvUI Norm",
	barPosition = "BOTTOM",
	barWidth = 2,
	barHeight = 2,
	barSpacing = 2,
	barColor = {r = 0, g = .8, b = 0},
	barColorGradient = false,
	barNoDuration = true,
	buffs = {
		growthDirection = "LEFT_DOWN",
		wrapAfter = 12,
		maxWraps = 3,
		horizontalSpacing = 6,
		verticalSpacing = 16,
		sortMethod = "TIME",
		sortDir = "-",
		seperateOwn = 1,
		size = 32,
		countFontsize = 10,
		durationFontSize = 10
	},
	debuffs = {
		growthDirection = "LEFT_DOWN",
		wrapAfter = 12,
		maxWraps = 1,
		horizontalSpacing = 6,
		verticalSpacing = 16,
		sortMethod = "TIME",
		sortDir = "-",
		seperateOwn = 1,
		size = 32,
		countFontsize = 10,
		durationFontSize = 10
	},
	cooldown = {
		override = false,
		reverse = false,
		threshold = 3,
		expiringColor = {r = 1, g = 0, b = 0},
		secondsColor = {r = 1, g = 1, b = 1},
		minutesColor = {r = 1, g = 1, b = 1},
		hoursColor = {r = 1, g = 1, b = 1},
		daysColor = {r = 1, g = 1, b = 1},
		expireIndicator = {r = 1, g = 1, b = 1},
		secondsIndicator = {r = 1, g = 1, b = 1},
		minutesIndicator = {r = 1, g = 1, b = 1},
		hoursIndicator = {r = 1, g = 1, b = 1},
		daysIndicator = {r = 1, g = 1, b = 1},
		hhmmColorIndicator = {r = 1, g = 1, b = 1},
		mmssColorIndicator = {r = 1, g = 1, b = 1},

		checkSeconds = false,
		hhmmColor = {r = 0.43, g = 0.43, b = 0.43},
		mmssColor = {r = 0.56, g = 0.56, b = 0.56},
		hhmmThreshold = -1,
		mmssThreshold = -1
	}
}

--Chat
P.chat = {
	lockPositions = true,
	url = true,
	shortChannels = true,
	hyperlinkHover = true,
	throttleInterval = 30,
	scrollDownInterval = 15,
	fade = true,
	inactivityTimer = 120,
	font = "PT Sans Narrow",
	fontOutline = "NONE",
	sticky = true,
	emotionIcons = true,
	keywordSound = "None",
	noAlertInCombat = false,
	chatHistory = true,
	maxLines = 128,
	historySize = 100,
	editboxHistorySize = 20,
	channelAlerts = {
		GUILD = "None",
		OFFICER = "None",
		BATTLEGROUND = "None",
		PARTY = "None",
		RAID = "None",
		WHISPER = "Whisper Alert"
	},
	showHistory = {
		WHISPER = true,
		GUILD = true,
		OFFICER = true,
		PARTY = true,
		RAID = true,
		BATTLEGROUND = true,
		CHANNEL = true,
		SAY = true,
		YELL = true,
		EMOTE = true
	},
	tabSelector = "NONE",
	tabSelectedTextEnabled = false,
	tabSelectedTextColor = {r = 1, g = 1, b = 1},
	tabSelectorColor = {r = 0.3, g = 1, b = 0.3},
	timeStampFormat = "NONE",
	keywords = "ElvUI",
	separateSizes = false,
	panelWidth = 412,
	panelHeight = 180,
	panelWidthRight = 412,
	panelHeightRight = 180,
	panelBackdropNameLeft = "",
	panelBackdropNameRight = "",
	panelBackdrop = "SHOWBOTH",
	panelTabBackdrop = false,
	panelTabTransparency = false,
	editBoxPosition = "BELOW_CHAT",
	fadeUndockedTabs = true,
	fadeTabsNoBackdrop = true,
	fadeChatToggles = true,
	useAltKey = false,
	classColorMentionsChat = true,
	numAllowedCombatRepeat = 5,
	useCustomTimeColor = true,
	customTimeColor = {r = 0.7, g = 0.7, b = 0.7},
	numScrollMessages = 3,
	tabFont = "PT Sans Narrow",
	tabFontSize = 12,
	tabFontOutline = "NONE",
	panelColor = {r = 0.06, g = 0.06, b = 0.06, a = 0.8}
}

--Datatexts
P.datatexts = {
	font = "PT Sans Narrow",
	fontSize = 12,
	fontOutline = "NONE",
	wordWrap = false,
	panels = {
		LeftChatDataPanel = {
			left = "Armor",
			middle = "Durability",
			right = "Avoidance"
		},
		RightChatDataPanel = {
			left = "System",
			middle = "Time",
			right = "Gold"
		},
		LeftMiniPanel = "Guild",
		RightMiniPanel = "Friends",
		BottomMiniPanel = "",
		TopMiniPanel = "",
		BottomLeftMiniPanel = "",
		BottomRightMiniPanel = "",
		TopRightMiniPanel = "",
		TopLeftMiniPanel = ""
	},
	battleground = true,
	panelTransparency = false,
	panelBackdrop = true,
	noCombatClick = false,
	noCombatHover = false,

	--Datatext Options
	---General
	goldFormat = "BLIZZARD",
	goldCoins = true,
	---Time
	realmTime = false,
	timeFormat = "%I:%M",
	dateFormat = "",
	---Friends
	friends = {
		--status
		hideAFK = false,
		hideDND = false,
	},
	--Enabled/Disabled Panels
	minimapPanels = true,
	leftChatPanel = true,
	rightChatPanel = true,
	minimapTop = false,
	minimapTopLeft = false,
	minimapTopRight = false,
	minimapBottom = false,
	minimapBottomLeft = false,
	minimapBottomRight = false
}

--Tooltip
P.tooltip = {
	cursorAnchor = false,
	cursorAnchorType = "ANCHOR_CURSOR",
	cursorAnchorX = 0,
	cursorAnchorY = 0,
	alwaysShowRealm = false,
	targetInfo = true,
	playerTitles = true,
	guildRanks = true,
	itemCount = "BAGS_ONLY",
	spellID = true,
	npcID = true,
	inspectInfo = true,
	font = "PT Sans Narrow",
	fontOutline = "NONE",
	headerFontSize = 12,
	textFontSize = 12,
	smallTextFontSize = 12,
	colorAlpha = 0.8,
	visibility = {
		unitFrames = "NONE",
		bags = "NONE",
		actionbars = "NONE",
		combat = false,
		combatOverride = "ALL",
	},
	healthBar = {
		text = true,
		height = 7,
		font = "Homespun",
		fontSize = 10,
		fontOutline = "OUTLINE",
		statusPosition = "BOTTOM"
	},
	useCustomFactionColors = false,
	factionColors = {
		[1] = {r = 0.8, g = 0.3, b = 0.22},
		[2] = {r = 0.8, g = 0.3, b = 0.22},
		[3] = {r = 0.75, g = 0.27, b = 0},
		[4] = {r = 0.9, g = 0.7, b = 0},
		[5] = {r = 0, g = 0.6, b = 0.1},
		[6] = {r = 0, g = 0.6, b = 0.1},
		[7] = {r = 0, g = 0.6, b = 0.1},
		[8] = {r = 0, g = 0.6, b = 0.1}
	}
}

--UnitFrame
P.unitframe = {
	smoothbars = false,
	statusbar = "ElvUI Norm",
	font = "Homespun",
	fontSize = 10,
	fontOutline = "MONOCHROMEOUTLINE",
	debuffHighlighting = "FILL",
	smartRaidFilter = true,
	targetOnMouseDown = false,
	auraBlacklistModifier = "SHIFT",
	thinBorders = false,
	cooldown = {
		override = true,
		reverse = false,
		threshold = 3,
		expiringColor = {r = 1, g = 0, b = 0},
		secondsColor = {r = 1, g = 1, b = 1},
		minutesColor = {r = 1, g = 1, b = 1},
		hoursColor = {r = 1, g = 1, b = 1},
		daysColor = {r = 1, g = 1, b = 1},
		expireIndicator = {r = 1, g = 1, b = 1},
		secondsIndicator = {r = 1, g = 1, b = 1},
		minutesIndicator = {r = 1, g = 1, b = 1},
		hoursIndicator = {r = 1, g = 1, b = 1},
		daysIndicator = {r = 1, g = 1, b = 1},
		hhmmColorIndicator = {r = 1, g = 1, b = 1},
		mmssColorIndicator = {r = 1, g = 1, b = 1},

		checkSeconds = false,
		hhmmColor = {r = 0.43, g = 0.43, b = 0.43},
		mmssColor = {r = 0.56, g = 0.56, b = 0.56},
		hhmmThreshold = -1,
		mmssThreshold = -1,

		fonts = {
			enable = false,
			font = "PT Sans Narrow",
			fontOutline = "OUTLINE",
			fontSize = 18
		}
	},
	colors = {
		borderColor = {r = 0, g = 0, b = 0},
		healthclass = false,
		forcehealthreaction = false,
		powerclass = false,
		colorhealthbyvalue = true,
		colorhealthbyvalue_threshold = false,
		colorhealthbyvalue_thresholdgradient = true,
		customhealthbackdrop = false,
		custompowerbackdrop = false,
		customcastbarbackdrop = false,
		customaurabarbackdrop = false,
		customclasspowerbackdrop = false,
		useDeadBackdrop = false,
		classbackdrop = false,
		healthMultiplier = 0,
		auraBarByType = true,
		auraBarTurtle = true,
		auraBarTurtleColor = {r = 0.56, g = 0.39, b = 0.61},
		transparentHealth = false,
		transparentPower = false,
		transparentCastbar = false,
		transparentAurabars = false,
		transparentClasspower = false,
		invertCastBar = false,
		invertAurabars = false,
		invertPower = false,
		invertClasspower = false,
		castColor = {r = 0.31, g = 0.31, b = 0.31},
		castNoInterrupt = {r = 0.78, g = 0.25, b = 0.25},
		castClassColor = false,
		castReactionColor = false,
		health = {r = 0.31, g = 0.31, b = 0.31},
		health_backdrop = {r = 0.8, g = 0.01, b = 0.01},
		health_backdrop_dead = {r = 0.8, g = 0.01, b = 0.01},
		castbar_backdrop = {r = 0.5, g = 0.5, b = 0.5},
		classpower_backdrop = {r = 0.5, g = 0.5, b = 0.5},
		aurabar_backdrop = {r = 0.5, g = 0.5, b = 0.5},
		power_backdrop = {r = 0.5, g = 0.5, b = 0.5},
		tapped = {r = 0.55, g = 0.57, b = 0.61},
		disconnected = {r = 0.84, g = 0.75, b = 0.65},
		auraBarBuff = {r = 0.31, g = 0.31, b = 0.31},
		auraBarDebuff = {r = 0.8, g = 0.1, b = 0.1},
		threshold_20 = {r = 1, g = 0, b = 0},
		threshold_35 = {r = 1, g = 0, b = 0.8},
		threshold_50 = {r = 1, g = 0.5, b = 0},
		threshold_75 = {r = 1, g = 1, b = 0},
		power = {
			MANA = {r = 0.31, g = 0.45, b = 0.63},
			RAGE = {r = 0.78, g = 0.25, b = 0.25},
			FOCUS = {r = 0.71, g = 0.43, b = 0.27},
			ENERGY = {r = 0.65, g = 0.63, b = 0.35},
			RUNIC_POWER = {r = 0, g = 0.82, b = 1}
		},
		reaction = {
			BAD = {r = 0.78, g = 0.25, b = 0.25},
			NEUTRAL = {r = 0.85, g = 0.77, b = 0.36},
			GOOD = {r = 0.29, g = 0.68, b = 0.29}
		},
		threat = {
			[ 0] = {r = 0.5, g = 0.5, b = 0.5}, -- low
			[ 1] = {r = 1.0, g = 1.0, b = 0.5}, -- overnuking
			[ 2] = {r = 1.0, g = 0.5, b = 0.0}, -- losing threat
			[ 3] = {r = 1.0, g = 0.2, b = 0.2}, -- tanking securely
		},
		healPrediction = {
			personal = {r = 0, g = 1, b = 0.5, a = 0.25},
			others = {r = 0, g = 1, b = 0, a = 0.25},
			maxOverflow = 0
		},
		classResources = {
			comboPoints = {
				[1] = {r = 0.69, g = 0.31, b = 0.31},
				[2] = {r = 0.69, g = 0.31, b = 0.31},
				[3] = {r = 0.65, g = 0.63, b = 0.35},
				[4] = {r = 0.65, g = 0.63, b = 0.35},
				[5] = {r = 0.33, g = 0.59, b = 0.33}
			},
			DEATHKNIGHT = {
				[1] = {r = 1, g = 0, b = 0},
				[2] = {r = 0, g = 1, b = 0},
				[3] = {r = 0, g = 1, b = 1},
				[4] = {r = 0.9, g = 0.1, b = 1}
			}
		},
		frameGlow = {
			mainGlow = {
				enable = false,
				class = false,
				color = {r = 1, g = 1, b = 1, a = 1}
			},
			targetGlow = {
				enable = true,
				class = true,
				color = {r = 1, g = 1, b = 1, a = 1}
			},
			mouseoverGlow = {
				enable = true,
				class = false,
				texture = "ElvUI Blank",
				color = {r = 1, g = 1, b = 1, a = 0.1}
			}
		},
		debuffHighlight = {
			Magic = {r = 0.2, g = 0.6, b = 1, a = 0.45},
			Curse = {r = 0.6, g = 0, b = 1, a = 0.45},
			Disease = {r = 0.6, g = 0.4, b = 0, a = 0.45},
			Poison = {r = 0, g = 0.6, b = 0, a = 0.45},
			blendMode = "ADD"
		}
	},
	units = {
		player = {
			enable = true,
			orientation = "LEFT",
			width = 270,
			height = 54,
			lowmana = 30,
			healPrediction = {
				enable = true
			},
			threatStyle = "GLOW",
			smartAuraPosition = "DISABLED",
			colorOverride = "USE_DEFAULT",
			disableMouseoverGlow = false,
			disableTargetGlow = true,
			health = {
				text_format = "[healthcolor][health:current-percent]",
				position = "LEFT",
				xOffset = 2,
				yOffset = 0,
				attachTextTo = "Health"
			},
			fader = {
				enable = false,
				--range = true, [player doesnt get this option]
				hover = true,
				combat = true,
				playertarget = true,
				--unittarget = false, [player doesnt get this option]
				focus = false,
				health = true,
				power = true,
				vehicle = true,
				casting = true,
				smooth = 0.33,
				minAlpha = 0.35,
				maxAlpha = 1,
				delay = 0
			},
			power = {
				enable = true,
				text_format = "[powercolor][power:current]",
				width = "fill",
				height = 10,
				offset = 0,
				position = "RIGHT",
				hideonnpc = false,
				xOffset = -2,
				yOffset = 0,
				attachTextTo = "Health",
				detachFromFrame = false,
				detachedWidth = 250,
				strataAndLevel = {
					useCustomStrata = false,
					frameStrata = "LOW",
					useCustomLevel = false,
					frameLevel = 1
				},
				parent = "FRAME"
			},
			energy = {
				enable = true,
				text_format = "[energycolor][energy:current]",
				width = "fill",
				height = 10,
				offset = 0,
				position = "RIGHT",
				hideonnpc = false,
				xOffset = -2,
				yOffset = 1,
				attachTextTo = "Energy",
				detachFromFrame = false,
				detachedWidth = 250,
				strataAndLevel = {
					useCustomStrata = false,
					frameStrata = "LOW",
					useCustomLevel = false,
					frameLevel = 1
				},
				parent = "FRAME"
			},
			rage = {
				enable = true,
				text_format = "[ragecolor][rage:current]",
				width = "fill",
				height = 10,
				offset = 0,
				position = "RIGHT",
				hideonnpc = false,
				xOffset = -2,
				yOffset = 1,
				attachTextTo = "Rage",
				detachFromFrame = false,
				detachedWidth = 250,
				strataAndLevel = {
					useCustomStrata = false,
					frameStrata = "LOW",
					useCustomLevel = false,
					frameLevel = 1
				},
				parent = "FRAME"
			},
			infoPanel = {
				enable = false,
				height = 20,
				transparent = false
			},
			name = {
				position = "CENTER",
				text_format = "",
				xOffset = 0,
				yOffset = 0,
				attachTextTo = "Health"
			},
			pvp = {
				position = "BOTTOM",
				text_format = "||cFFB04F4F[pvptimer][mouseover]||r",
				xOffset = 0,
				yOffset = 0
			},
			RestIcon = {
				enable = true,
				defaultColor = true,
				color = {r = 1, g = 1, b = 1, a = 1},
				anchorPoint = "TOPLEFT",
				xOffset = -3,
				yOffset = 6,
				size = 22,
				texture = "DEFAULT"
			},
			raidRoleIcons = {
				enable = true,
				position = "TOPLEFT"
			},
			CombatIcon = {
				enable = true,
				defaultColor = true,
				color = {r = 1, g = 0.2, b = 0.2, a = 1},
				anchorPoint = "CENTER",
				xOffset = 0,
				yOffset = 0,
				size = 20,
				texture = "DEFAULT"
			},
			pvpIcon = {
				enable = false,
				anchorPoint = "CENTER",
				xOffset = 0,
				yOffset = 0,
				scale = 1
			},
			portrait = {
				enable = false,
				width = 45,
				overlay = false,
				fullOverlay = false,
				style = "3D",
				overlayAlpha = 0.35
			},
			buffs = {
				enable = false,
				perrow = 8,
				numrows = 1,
				attachTo = "DEBUFFS",
				anchorPoint = "TOPLEFT",
				countFont = "PT Sans Narrow",
				countFontOutline = "OUTLINE",
				countFontSize = 12,
				durationPosition = "CENTER",
				sortMethod = "TIME_REMAINING",
				sortDirection = "DESCENDING",
				clickThrough = false,
				minDuration = 0,
				maxDuration = 0,
				priority = "Blacklist,Personal,PlayerBuffs,Whitelist,blockNoDuration,nonPersonal", --Player Buffs
				xOffset = 0,
				yOffset = 0
			},
			debuffs = {
				enable = true,
				perrow = 8,
				numrows = 1,
				attachTo = "FRAME",
				anchorPoint = "TOPLEFT",
				countFont = "PT Sans Narrow",
				countFontOutline = "OUTLINE",
				countFontSize = 12,
				durationPosition = "CENTER",
				sortMethod = "TIME_REMAINING",
				sortDirection = "DESCENDING",
				clickThrough = false,
				minDuration = 0,
				maxDuration = 0,
				priority = "Blacklist,Personal,nonPersonal", --Player Debuffs
				xOffset = 0,
				yOffset = 0
			},
			castbar = {
				enable = true,
				width = 270,
				height = 18,
				icon = true,
				latency = true,
				format = "REMAINING",
				ticks = true,
				spark = true,
				displayTarget = false,
				iconSize = 42,
				iconAttached = true,
				insideInfoPanel = true,
				iconAttachedTo = "Frame",
				iconPosition = "LEFT",
				iconXOffset = -10,
				iconYOffset = 0,
				tickWidth = 1,
				tickColor = {r = 0, g = 0, b = 0, a = 0.8},
				timeToHold = 0,
				strataAndLevel = {
					useCustomStrata = false,
					frameStrata = "LOW",
					useCustomLevel = false,
					frameLevel = 1
				}
			},
			classbar = {
				enable = true,
				fill = "fill",
				height = 10,
				autoHide = false,
				additionalPowerText = true,
				detachFromFrame = false,
				detachedWidth = 250,
				parent = "FRAME",
				verticalOrientation = false,
				orientation = "HORIZONTAL",
				spacing = 5,
				strataAndLevel = {
					useCustomStrata = false,
					frameStrata = "LOW",
					useCustomLevel = false,
					frameLevel = 1
				}
			},
			aurabar = {
				enable = true,
				anchorPoint = "ABOVE",
				attachTo = "DEBUFFS",
				maxBars = 6,
				minDuration = 0,
				maxDuration = 120,
				priority = "Blacklist,blockNoDuration,Personal,RaidDebuffs,PlayerBuffs", --Player AuraBars
				friendlyAuraType = "HELPFUL",
				enemyAuraType = "HARMFUL",
				height = 20,
				sort = "TIME_REMAINING",
				uniformThreshold = 0,
				yOffset = 0,
				spacing = 0
			},
			raidicon = {
				enable = true,
				size = 18,
				attachTo = "TOP",
				attachToObject = "Frame",
				xOffset = 0,
				yOffset = 8
			},
			cutaway = {
				health = {
					enabled = false,
					fadeOutTime = 0.6,
					lengthBeforeFade = 0.3,
					forceBlankTexture = true
				},
				power = {
					enabled = false,
					fadeOutTime = 0.6,
					lengthBeforeFade = 0.3,
					forceBlankTexture = true
				}
			}
		},
		target = {
			enable = true,
			width = 270,
			height = 54,
			orientation = "RIGHT",
			threatStyle = "GLOW",
			smartAuraPosition = "DISABLED",
			colorOverride = "USE_DEFAULT",
			healPrediction = {
				enable = true
			},
			middleClickFocus = true,
			disableMouseoverGlow = false,
			disableTargetGlow = true,
			health = {
				text_format = "[healthcolor][health:current-percent]",
				position = "RIGHT",
				xOffset = -2,
				yOffset = 0,
				attachTextTo = "Health"
			},
			fader = {
				enable = true,
				range = true,
				hover = false,
				combat = false,
				playertarget = false,
				unittarget = false,
				focus = false,
				health = false,
				power = false,
				vehicle = false,
				casting = false,
				smooth = 0.33,
				minAlpha = 0.35,
				maxAlpha = 1,
				delay = 0
			},
			power = {
				enable = true,
				text_format = "[powercolor][power:current]",
				width = "fill",
				height = 10,
				offset = 0,
				position = "LEFT",
				hideonnpc = false,
				xOffset = 2,
				yOffset = 0,
				detachFromFrame = false,
				detachedWidth = 250,
				attachTextTo = "Health",
				strataAndLevel = {
					useCustomStrata = false,
					frameStrata = "LOW",
					useCustomLevel = false,
					frameLevel = 1
				},
				parent = "FRAME"
			},
			infoPanel = {
				enable = false,
				height = 20,
				transparent = false
			},
			name = {
				position = "CENTER",
				text_format = "[namecolor][name:medium] [difficultycolor][smartlevel] [shortclassification]",
				xOffset = 0,
				yOffset = 0,
				attachTextTo = "Health"
			},
			pvpIcon = {
				enable = false,
				anchorPoint = "CENTER",
				xOffset = 0,
				yOffset = 0,
				scale = 1
			},
			portrait = {
				enable = false,
				width = 45,
				overlay = false,
				fullOverlay = false,
				style = "3D",
				overlayAlpha = 0.35
			},
			buffs = {
				enable = true,
				perrow = 8,
				numrows = 1,
				attachTo = "FRAME",
				anchorPoint = "TOPRIGHT",
				countFont = "PT Sans Narrow",
				countFontOutline = "OUTLINE",
				countFontSize = 12,
				durationPosition = "CENTER",
				clickThrough = false,
				sortMethod = "TIME_REMAINING",
				sortDirection = "DESCENDING",
				minDuration = 0,
				maxDuration = 0,
				priority = "Blacklist,Personal,nonPersonal", --Target Buffs
				xOffset = 0,
				yOffset = 0
			},
			debuffs = {
				enable = true,
				perrow = 8,
				numrows = 1,
				attachTo = "BUFFS",
				anchorPoint = "TOPRIGHT",
				countFont = "PT Sans Narrow",
				countFontOutline = "OUTLINE",
				countFontSize = 12,
				durationPosition = "CENTER",
				clickThrough = false,
				sortMethod = "TIME_REMAINING",
				sortDirection = "DESCENDING",
				minDuration = 0,
				maxDuration = 300,
				priority = "Blacklist,Personal,RaidDebuffs,CCDebuffs,Friendly:Dispellable", --Target Debuffs
				xOffset = 0,
				yOffset = 0
			},
			castbar = {
				enable = true,
				width = 270,
				height = 18,
				icon = true,
				format = "REMAINING",
				spark = true,
				iconSize = 42,
				iconAttached = true,
				insideInfoPanel = true,
				iconAttachedTo = "Frame",
				iconPosition = "LEFT",
				iconXOffset = -10,
				iconYOffset = 0,
				timeToHold = 0,
				strataAndLevel = {
					useCustomStrata = false,
					frameStrata = "LOW",
					useCustomLevel = false,
					frameLevel = 1
				}
			},
			combobar = {
				enable = true,
				fill = "fill",
				height = 10,
				autoHide = true,
				detachFromFrame = false,
				detachedWidth = 250,
				parent = "FRAME",
				orientation = "HORIZONTAL",
				spacing = 5,
				strataAndLevel = {
					useCustomStrata = false,
					frameStrata = "LOW",
					useCustomLevel = false,
					frameLevel = 1
				}
			},
			aurabar = {
				enable = true,
				anchorPoint = "ABOVE",
				attachTo = "DEBUFFS",
				maxBars = 6,
				minDuration = 0,
				maxDuration = 120,
				priority = "Blacklist,Personal,blockNoDuration,PlayerBuffs,RaidDebuffs", --Target AuraBars
				friendlyAuraType = "HELPFUL",
				enemyAuraType = "HARMFUL",
				height = 20,
				sort = "TIME_REMAINING",
				uniformThreshold = 0,
				yOffset = 0,
				spacing = 0
			},
			raidicon = {
				enable = true,
				size = 18,
				attachTo = "TOP",
				attachToObject = "Frame",
				xOffset = 0,
				yOffset = 8
			},
			GPSArrow = {
				enable = false,
				size = 45,
				xOffset = 0,
				yOffset = 0,
				onMouseOver = true,
				outOfRange = true
			},
			cutaway = {
				health = {
					enabled = false,
					fadeOutTime = 0.6,
					lengthBeforeFade = 0.3,
					forceBlankTexture = true
				},
				power = {
					enabled = false,
					fadeOutTime = 0.6,
					lengthBeforeFade = 0.3,
					forceBlankTexture = true
				}
			}
		},
		targettarget = {
			enable = true,
			threatStyle = "NONE",
			orientation = "MIDDLE",
			smartAuraPosition = "DISABLED",
			colorOverride = "USE_DEFAULT",
			width = 130,
			height = 36,
			disableMouseoverGlow = false,
			disableTargetGlow = true,
			health = {
				text_format = "",
				position = "RIGHT",
				xOffset = -2,
				yOffset = 0
			},
			fader = {
				enable = true,
				range = true,
				hover = false,
				combat = false,
				playertarget = false,
				unittarget = false,
				focus = false,
				health = false,
				power = false,
				vehicle = false,
				casting = false,
				smooth = 0.33,
				minAlpha = 0.35,
				maxAlpha = 1,
				delay = 0
			},
			power = {
				enable = true,
				text_format = "",
				width = "fill",
				height = 7,
				offset = 0,
				position = "LEFT",
				hideonnpc = false,
				xOffset = 2,
				yOffset = 0
			},
			infoPanel = {
				enable = false,
				height = 14,
				transparent = false
			},
			name = {
				position = "CENTER",
				text_format = "[namecolor][name:medium]",
				xOffset = 0,
				yOffset = 0,
				attachTextTo = "Health"
			},
			portrait = {
				enable = false,
				width = 45,
				overlay = false,
				fullOverlay = false,
				style = "3D",
				overlayAlpha = 0.35
			},
			buffs = {
				enable = false,
				perrow = 7,
				numrows = 1,
				attachTo = "FRAME",
				anchorPoint = "BOTTOMLEFT",
				countFont = "PT Sans Narrow",
				countFontOutline = "OUTLINE",
				countFontSize = 12,
				durationPosition = "CENTER",
				clickThrough = false,
				sortMethod = "TIME_REMAINING",
				sortDirection = "DESCENDING",
				minDuration = 0,
				maxDuration = 300,
				priority = "Blacklist,Personal,PlayerBuffs,Dispellable", --TargetTarget Buffs
				xOffset = 0,
				yOffset = 0
			},
			debuffs = {
				enable = true,
				perrow = 5,
				numrows = 1,
				attachTo = "FRAME",
				anchorPoint = "BOTTOMRIGHT",
				countFont = "PT Sans Narrow",
				countFontOutline = "OUTLINE",
				countFontSize = 12,
				durationPosition = "CENTER",
				clickThrough = false,
				sortMethod = "TIME_REMAINING",
				sortDirection = "DESCENDING",
				minDuration = 0,
				maxDuration = 300,
				priority = "Blacklist,Personal,RaidDebuffs,CCDebuffs,Dispellable,Whitelist", --TargetTarget Debuffs
				xOffset = 0,
				yOffset = 0
			},
			raidicon = {
				enable = true,
				size = 18,
				attachTo = "TOP",
				attachToObject = "Frame",
				xOffset = 0,
				yOffset = 8
			},
			cutaway = {
				health = {
					enabled = false,
					fadeOutTime = 0.6,
					lengthBeforeFade = 0.3,
					forceBlankTexture = true
				},
				power = {
					enabled = false,
					fadeOutTime = 0.6,
					lengthBeforeFade = 0.3,
					forceBlankTexture = true
				}
			}
		},
		targettargettarget = {
			enable = false,
			orientation = "MIDDLE",
			threatStyle = "NONE",
			smartAuraPosition = "DISABLED",
			colorOverride = "USE_DEFAULT",
			width = 130,
			height = 36,
			disableMouseoverGlow = false,
			disableTargetGlow = false,
			health = {
				text_format = "",
				position = "RIGHT",
				xOffset = -2,
				yOffset = 0
			},
			fader = {
				enable = true,
				range = true,
				hover = false,
				combat = false,
				playertarget = false,
				unittarget = false,
				focus = false,
				health = false,
				power = false,
				vehicle = false,
				casting = false,
				smooth = 0.33,
				minAlpha = 0.35,
				maxAlpha = 1,
				delay = 0
			},
			power = {
				enable = true,
				text_format = "",
				width = "fill",
				height = 7,
				offset = 0,
				position = "LEFT",
				hideonnpc = false,
				xOffset = 2,
				yOffset = 0
			},
			infoPanel = {
				enable = false,
				height = 12,
				transparent = false
			},
			name = {
				position = "CENTER",
				text_format = "[namecolor][name:medium]",
				xOffset = 0,
				yOffset = 0
			},
			portrait = {
				enable = false,
				width = 45,
				overlay = false,
				fullOverlay = false,
				style = "3D",
				overlayAlpha = 0.35
			},
			buffs = {
				enable = false,
				perrow = 7,
				numrows = 1,
				attachTo = "FRAME",
				anchorPoint = "BOTTOMLEFT",
				countFont = "PT Sans Narrow",
				countFontOutline = "OUTLINE",
				countFontSize = 12,
				durationPosition = "CENTER",
				clickThrough = false,
				sortMethod = "TIME_REMAINING",
				sortDirection = "DESCENDING",
				minDuration = 0,
				maxDuration = 300,
				priority = "Blacklist,Personal,nonPersonal", --TargetTargetTarget Buffs
				xOffset = 0,
				yOffset = 0
			},
			debuffs = {
				enable = true,
				perrow = 5,
				numrows = 1,
				attachTo = "FRAME",
				anchorPoint = "BOTTOMRIGHT",
				countFont = "PT Sans Narrow",
				countFontOutline = "OUTLINE",
				countFontSize = 12,
				durationPosition = "CENTER",
				clickThrough = false,
				sortMethod = "TIME_REMAINING",
				sortDirection = "DESCENDING",
				minDuration = 0,
				maxDuration = 300,
				priority = "Blacklist,Personal,nonPersonal", --TargetTargetTarget Debuffs
				xOffset = 0,
				yOffset = 0
			},
			raidicon = {
				enable = true,
				size = 18,
				attachTo = "TOP",
				attachToObject = "Frame",
				xOffset = 0,
				yOffset = 8
			},
			cutaway = {
				health = {
					enabled = false,
					fadeOutTime = 0.6,
					lengthBeforeFade = 0.3,
					forceBlankTexture = true
				},
				power = {
					enabled = false,
					fadeOutTime = 0.6,
					lengthBeforeFade = 0.3,
					forceBlankTexture = true
				}
			}
		},
		focus = {
			enable = true,
			threatStyle = "GLOW",
			orientation = "MIDDLE",
			smartAuraPosition = "DISABLED",
			colorOverride = "USE_DEFAULT",
			width = 190,
			height = 36,
			healPrediction = {
				enable = true
			},
			disableMouseoverGlow = false,
			disableTargetGlow = false,
			health = {
				text_format = "",
				position = "RIGHT",
				xOffset = -2,
				yOffset = 0,
				attachTextTo = "Health",
			},
			fader = {
				enable = true,
				range = true,
				hover = false,
				combat = false,
				playertarget = false,
				unittarget = false,
				focus = false,
				health = false,
				power = false,
				vehicle = false,
				casting = false,
				smooth = 0.33,
				minAlpha = 0.35,
				maxAlpha = 1,
				delay = 0
			},
			power = {
				enable = true,
				text_format = "",
				width = "fill",
				height = 7,
				offset = 0,
				position = "LEFT",
				hideonnpc = false,
				xOffset = 2,
				yOffset = 0,
				attachTextTo = "Health"
			},
			infoPanel = {
				enable = false,
				height = 14,
				transparent = false
			},
			name = {
				position = "CENTER",
				text_format = "[namecolor][name:medium]",
				xOffset = 0,
				yOffset = 0,
				attachTextTo = "Health"
			},
			portrait = {
				enable = false,
				width = 45,
				overlay = false,
				fullOverlay = false,
				style = "3D",
				overlayAlpha = 0.35
			},
			buffs = {
				enable = false,
				perrow = 7,
				numrows = 1,
				attachTo = "FRAME",
				anchorPoint = "BOTTOMLEFT",
				countFont = "PT Sans Narrow",
				countFontOutline = "OUTLINE",
				countFontSize = 12,
				durationPosition = "CENTER",
				clickThrough = false,
				sortMethod = "TIME_REMAINING",
				sortDirection = "DESCENDING",
				minDuration = 0,
				maxDuration = 300,
				priority = "Blacklist,Personal,PlayerBuffs,CastByUnit,Dispellable", --Focus Buffs
				xOffset = 0,
				yOffset = 0
			},
			debuffs = {
				enable = true,
				perrow = 5,
				numrows = 1,
				attachTo = "FRAME",
				anchorPoint = "TOPRIGHT",
				countFont = "PT Sans Narrow",
				countFontOutline = "OUTLINE",
				countFontSize = 12,
				durationPosition = "CENTER",
				clickThrough = false,
				sortMethod = "TIME_REMAINING",
				sortDirection = "DESCENDING",
				minDuration = 0,
				maxDuration = 300,
				priority = "Blacklist,Personal,RaidDebuffs,Dispellable,Whitelist", --Focus Debuffs
				xOffset = 0,
				yOffset = 0
			},
			castbar = {
				enable = true,
				width = 190,
				height = 18,
				icon = true,
				format = "REMAINING",
				spark = true,
				iconSize = 32,
				iconAttached = true,
				insideInfoPanel = true,
				iconAttachedTo = "Frame",
				iconPosition = "LEFT",
				iconXOffset = -10,
				iconYOffset = 0,
				timeToHold = 0,
				strataAndLevel = {
					useCustomStrata = false,
					frameStrata = "LOW",
					useCustomLevel = false,
					frameLevel = 1
				}
			},
			aurabar = {
				enable = false,
				anchorPoint = "ABOVE",
				attachTo = "DEBUFFS",
				maxBars = 3,
				minDuration = 0,
				maxDuration = 120,
				priority = "Blacklist,blockNoDuration,Personal,PlayerBuffs,RaidDebuffs", --Focus AuraBars
				friendlyAuraType = "HELPFUL",
				enemyAuraType = "HARMFUL",
				height = 20,
				sort = "TIME_REMAINING",
				uniformThreshold = 0,
				yOffset = 0,
				spacing = 0
			},
			raidicon = {
				enable = true,
				size = 18,
				attachTo = "TOP",
				attachToObject = "Frame",
				xOffset = 0,
				yOffset = 8
			},
			GPSArrow = {
				enable = true,
				size = 45,
				xOffset = 0,
				yOffset = 0,
				onMouseOver = true,
				outOfRange = true
			},
			cutaway = {
				health = {
					enabled = false,
					fadeOutTime = 0.6,
					lengthBeforeFade = 0.3,
					forceBlankTexture = true
				},
				power = {
					enabled = false,
					fadeOutTime = 0.6,
					lengthBeforeFade = 0.3,
					forceBlankTexture = true
				}
			}
		},
		focustarget = {
			enable = false,
			threatStyle = "NONE",
			orientation = "MIDDLE",
			smartAuraPosition = "DISABLED",
			colorOverride = "USE_DEFAULT",
			width = 190,
			height = 26,
			disableMouseoverGlow = false,
			disableTargetGlow = false,
			health = {
				text_format = "",
				position = "RIGHT",
				xOffset = -2,
				yOffset = 0,
			},
			fader = {
				enable = true,
				range = true,
				hover = false,
				combat = false,
				playertarget = false,
				unittarget = false,
				focus = false,
				health = false,
				power = false,
				vehicle = false,
				casting = false,
				smooth = 0.33,
				minAlpha = 0.35,
				maxAlpha = 1,
				delay = 0
			},
			power = {
				enable = false,
				text_format = "",
				width = "fill",
				height = 7,
				offset = 0,
				position = "LEFT",
				hideonnpc = false,
				xOffset = 2,
				yOffset = 0
			},
			infoPanel = {
				enable = false,
				height = 12,
				transparent = false
			},
			name = {
				position = "CENTER",
				text_format = "[namecolor][name:medium]",
				yOffset = 0,
				xOffset = 0
			},
			portrait = {
				enable = false,
				width = 45,
				overlay = false,
				fullOverlay = false,
				style = "3D",
				overlayAlpha = 0.35
			},
			buffs = {
				enable = false,
				perrow = 7,
				numrows = 1,
				attachTo = "FRAME",
				anchorPoint = "BOTTOMLEFT",
				countFont = "PT Sans Narrow",
				countFontOutline = "OUTLINE",
				countFontSize = 12,
				durationPosition = "CENTER",
				clickThrough = false,
				sortMethod = "TIME_REMAINING",
				sortDirection = "DESCENDING",
				minDuration = 0,
				maxDuration = 300,
				priority = "Blacklist,Personal,PlayerBuffs,Dispellable,CastByUnit", --FocusTarget Buffs
				xOffset = 0,
				yOffset = 0
			},
			debuffs = {
				enable = false,
				perrow = 5,
				numrows = 1,
				attachTo = "FRAME",
				anchorPoint = "BOTTOMRIGHT",
				countFont = "PT Sans Narrow",
				countFontOutline = "OUTLINE",
				countFontSize = 12,
				durationPosition = "CENTER",
				clickThrough = false,
				sortMethod = "TIME_REMAINING",
				sortDirection = "DESCENDING",
				minDuration = 0,
				maxDuration = 300,
				priority = "Blacklist,Personal,RaidDebuffs,Dispellable,Whitelist", --FocusTarget Debuffs
				xOffset = 0,
				yOffset = 0
			},
			raidicon = {
				enable = true,
				size = 18,
				attachTo = "TOP",
				attachToObject = "Frame",
				xOffset = 0,
				yOffset = 8
			},
			cutaway = {
				health = {
					enabled = false,
					fadeOutTime = 0.6,
					lengthBeforeFade = 0.3,
					forceBlankTexture = true
				},
				power = {
					enabled = false,
					fadeOutTime = 0.6,
					lengthBeforeFade = 0.3,
					forceBlankTexture = true
				}
			}
		},
		pet = {
			enable = true,
			orientation = "MIDDLE",
			threatStyle = "GLOW",
			smartAuraPosition = "DISABLED",
			colorOverride = "USE_DEFAULT",
			width = 130,
			height = 36,
			healPrediction = {
				enable = true
			},
			disableMouseoverGlow = false,
			disableTargetGlow = true,
			health = {
				text_format = "",
				position = "RIGHT",
				yOffset = 0,
				xOffset = -2,
			},
			fader = {
				enable = true,
				range = true,
				hover = false,
				combat = false,
				playertarget = false,
				unittarget = false,
				focus = false,
				health = false,
				power = false,
				vehicle = false,
				casting = false,
				smooth = 0.33,
				minAlpha = 0.35,
				maxAlpha = 1,
				delay = 0
			},
			power = {
				enable = true,
				text_format = "",
				width = "fill",
				height = 7,
				offset = 0,
				position = "LEFT",
				hideonnpc = false,
				yOffset = 0,
				xOffset = 2
			},
			infoPanel = {
				enable = false,
				height = 12,
				transparent = false
			},
			name = {
				position = "CENTER",
				text_format = "[namecolor][name:medium]",
				yOffset = 0,
				xOffset = 0
			},
			portrait = {
				enable = false,
				width = 45,
				overlay = false,
				fullOverlay = false,
				style = "3D",
				overlayAlpha = 0.35
			},
			happiness = {
				enable = false,
				autoHide = false,
				width = 10
			},
			buffs = {
				enable = false,
				perrow = 7,
				numrows = 1,
				attachTo = "FRAME",
				anchorPoint = "BOTTOMLEFT",
				countFont = "PT Sans Narrow",
				countFontOutline = "OUTLINE",
				countFontSize = 12,
				durationPosition = "CENTER",
				sortMethod = "TIME_REMAINING",
				sortDirection = "DESCENDING",
				clickThrough = false,
				minDuration = 0,
				maxDuration = 300,
				priority = "Blacklist,Personal,PlayerBuffs", --Pet Buffs
				xOffset = 0,
				yOffset = 0
			},
			debuffs = {
				enable = false,
				perrow = 5,
				numrows = 1,
				attachTo = "FRAME",
				anchorPoint = "BOTTOMRIGHT",
				countFont = "PT Sans Narrow",
				countFontOutline = "OUTLINE",
				countFontSize = 12,
				durationPosition = "CENTER",
				sortMethod = "TIME_REMAINING",
				sortDirection = "DESCENDING",
				clickThrough = false,
				minDuration = 0,
				maxDuration = 300,
				priority = "Blacklist,RaidDebuffs,Dispellable,Whitelist", --Pet Debuffs
				xOffset = 0,
				yOffset = 0
			},
			aurabar = {
				enable = false,
				anchorPoint = "ABOVE",
				attachTo = "FRAME",
				maxBars = 6,
				minDuration = 0,
				maxDuration = 120,
				priority = "",
				friendlyAuraType = "HELPFUL",
				enemyAuraType = "HARMFUL",
				height = 20,
				sort = "TIME_REMAINING",
				uniformThreshold = 0,
				yOffset = 2,
				spacing = 2
			},
			buffIndicator = {
				enable = true,
				size = 8,
				fontSize = 10
			},
			castbar = {
				enable = true,
				width = 130,
				height = 18,
				icon = true,
				format = "REMAINING",
				spark = true,
				iconSize = 26,
				iconAttached = true,
				insideInfoPanel = true,
				iconAttachedTo = "Frame",
				iconPosition = "LEFT",
				iconXOffset = -10,
				iconYOffset = 0,
				timeToHold = 0,
				strataAndLevel = {
					useCustomStrata = false,
					frameStrata = "LOW",
					useCustomLevel = false,
					frameLevel = 1
				}
			},
			cutaway = {
				health = {
					enabled = false,
					fadeOutTime = 0.6,
					lengthBeforeFade = 0.3,
					forceBlankTexture = true
				},
				power = {
					enabled = false,
					fadeOutTime = 0.6,
					lengthBeforeFade = 0.3,
					forceBlankTexture = true
				}
			}
		},
		pettarget = {
			enable = false,
			threatStyle = "NONE",
			orientation = "MIDDLE",
			smartAuraPosition = "DISABLED",
			colorOverride = "USE_DEFAULT",
			width = 130,
			height = 26,
			disableMouseoverGlow = false,
			disableTargetGlow = false,
			health = {
				text_format = "",
				position = "RIGHT",
				yOffset = 0,
				xOffset = -2,
			},
			fader = {
				enable = true,
				range = true,
				hover = false,
				combat = false,
				playertarget = false,
				unittarget = false,
				focus = false,
				health = false,
				power = false,
				vehicle = false,
				casting = false,
				smooth = 0.33,
				minAlpha = 0.35,
				maxAlpha = 1,
				delay = 0
			},
			power = {
				enable = false,
				text_format = "",
				width = "fill",
				height = 7,
				offset = 0,
				position = "LEFT",
				hideonnpc = false,
				yOffset = 0,
				xOffset = 2
			},
			infoPanel = {
				enable = false,
				height = 12,
				transparent = false
			},
			name = {
				position = "CENTER",
				text_format = "[namecolor][name:medium]",
				yOffset = 0,
				xOffset = 0
			},
			portrait = {
				enable = false,
				width = 45,
				overlay = false,
				fullOverlay = false,
				style = "3D",
				overlayAlpha = 0.35
			},
			buffs = {
				enable = false,
				perrow = 7,
				numrows = 1,
				attachTo = "FRAME",
				anchorPoint = "BOTTOMLEFT",
				countFont = "PT Sans Narrow",
				countFontOutline = "OUTLINE",
				countFontSize = 12,
				durationPosition = "CENTER",
				clickThrough = false,
				sortMethod = "TIME_REMAINING",
				sortDirection = "DESCENDING",
				minDuration = 0,
				maxDuration = 300,
				priority = "Blacklist,PlayerBuffs,CastByUnit,Whitelist", --PetTarget Buffs
				xOffset = 0,
				yOffset = 0
			},
			debuffs = {
				enable = false,
				perrow = 5,
				numrows = 1,
				attachTo = "FRAME",
				anchorPoint = "BOTTOMRIGHT",
				countFont = "PT Sans Narrow",
				countFontOutline = "OUTLINE",
				countFontSize = 12,
				durationPosition = "CENTER",
				clickThrough = false,
				sortMethod = "TIME_REMAINING",
				sortDirection = "DESCENDING",
				minDuration = 0,
				maxDuration = 300,
				priority = "Blacklist,Personal,RaidDebuffs", --PetTarget Debuffs
				xOffset = 0,
				yOffset = 0
			},
			cutaway = {
				health = {
					enabled = false,
					fadeOutTime = 0.6,
					lengthBeforeFade = 0.3,
					forceBlankTexture = true
				},
				power = {
					enabled = false,
					fadeOutTime = 0.6,
					lengthBeforeFade = 0.3,
					forceBlankTexture = true
				}
			}
		},
		boss = {
			enable = true,
			growthDirection = "DOWN",
			orientation = "RIGHT",
			smartAuraPosition = "DISABLED",
			colorOverride = "USE_DEFAULT",
			width = 216,
			height = 46,
			spacing = 25,
			disableMouseoverGlow = false,
			disableTargetGlow = false,
			health = {
				text_format = "[healthcolor][health:current]",
				position = "LEFT",
				yOffset = 0,
				xOffset = 2,
				attachTextTo = "Health",
			},
			fader = {
				enable = true,
				range = true,
				hover = false,
				combat = false,
				playertarget = false,
				unittarget = false,
				focus = false,
				health = false,
				power = false,
				vehicle = false,
				casting = false,
				smooth = 0.33,
				minAlpha = 0.35,
				maxAlpha = 1,
				delay = 0
			},
			power = {
				enable = true,
				text_format = "[powercolor][power:current]",
				width = "fill",
				height = 7,
				offset = 0,
				position = "RIGHT",
				hideonnpc = false,
				yOffset = 0,
				xOffset = -2,
				attachTextTo = "Health"
			},
			portrait = {
				enable = false,
				width = 35,
				overlay = false,
				fullOverlay = false,
				style = "3D",
				overlayAlpha = 0.35
			},
			infoPanel = {
				enable = false,
				height = 16,
				transparent = false
			},
			name = {
				position = "CENTER",
				text_format = "[namecolor][name:medium]",
				yOffset = 0,
				xOffset = 0,
				attachTextTo = "Health"
			},
			buffs = {
				enable = true,
				perrow = 3,
				numrows = 1,
				attachTo = "FRAME",
				anchorPoint = "LEFT",
				countFont = "PT Sans Narrow",
				countFontOutline = "OUTLINE",
				countFontSize = 12,
				durationPosition = "CENTER",
				sortMethod = "TIME_REMAINING",
				sortDirection = "DESCENDING",
				clickThrough = false,
				minDuration = 0,
				maxDuration = 0,
				priority = "Blacklist,CastByUnit,Whitelist", --Boss Buffs
				xOffset = 0,
				yOffset = 20,
				sizeOverride = 22
			},
			debuffs = {
				enable = true,
				perrow = 3,
				numrows = 2,
				attachTo = "FRAME",
				anchorPoint = "LEFT",
				countFont = "PT Sans Narrow",
				countFontOutline = "OUTLINE",
				countFontSize = 12,
				durationPosition = "CENTER",
				sortMethod = "TIME_REMAINING",
				sortDirection = "DESCENDING",
				clickThrough = false,
				minDuration = 0,
				maxDuration = 0,
				priority = "Blacklist,Personal,RaidDebuffs,CastByUnit,Whitelist", --Boss Debuffs
				xOffset = 0,
				yOffset = -3,
				sizeOverride = 22
			},
			castbar = {
				enable = true,
				width = 215,
				height = 18,
				icon = true,
				format = "REMAINING",
				spark = true,
				iconSize = 32,
				iconAttached = true,
				insideInfoPanel = true,
				iconAttachedTo = "Frame",
				iconPosition = "LEFT",
				iconXOffset = -10,
				iconYOffset = 0,
				timeToHold = 0,
				strataAndLevel = {
					useCustomStrata = false,
					frameStrata = "LOW",
					useCustomLevel = false,
					frameLevel = 1
				}
			},
			raidicon = {
				enable = true,
				size = 18,
				attachTo = "TOP",
				attachToObject = "Frame",
				xOffset = 0,
				yOffset = 8
			},
			cutaway = {
				health = {
					enabled = false,
					fadeOutTime = 0.6,
					lengthBeforeFade = 0.3,
					forceBlankTexture = true
				},
				power = {
					enabled = false,
					fadeOutTime = 0.6,
					lengthBeforeFade = 0.3,
					forceBlankTexture = true
				}
			}
		},
		arena = {
			enable = true,
			growthDirection = "DOWN",
			orientation = "RIGHT",
			smartAuraPosition = "DISABLED",
			spacing = 25,
			width = 246,
			height = 47,
			healPrediction = {
				enable = true
			},
			colorOverride = "USE_DEFAULT",
			disableMouseoverGlow = false,
			disableTargetGlow = false,
			health = {
				text_format = "[healthcolor][health:current]",
				position = "LEFT",
				yOffset = 0,
				xOffset = 2,
				attachTextTo = "Health",
			},
			fader = {
				enable = true,
				range = true,
				hover = false,
				combat = false,
				playertarget = false,
				unittarget = false,
				focus = false,
				health = false,
				power = false,
				vehicle = false,
				casting = false,
				smooth = 0.33,
				minAlpha = 0.35,
				maxAlpha = 1,
				delay = 0
			},
			power = {
				enable = true,
				text_format = "[powercolor][power:current]",
				width = "fill",
				height = 7,
				offset = 0,
				attachTextTo = "Health",
				position = "RIGHT",
				hideonnpc = false,
				yOffset = 0,
				xOffset = -2
			},
			infoPanel = {
				enable = false,
				height = 17,
				transparent = false
			},
			name = {
				position = "CENTER",
				text_format = "[namecolor][name:medium]",
				yOffset = 0,
				xOffset = 0,
				attachTextTo = "Health"
			},
			portrait = {
				enable = false,
				width = 45,
				overlay = false,
				fullOverlay = false,
				style = "3D",
				overlayAlpha = 0.35
			},
			buffs = {
				enable = true,
				perrow = 3,
				numrows = 1,
				attachTo = "FRAME",
				anchorPoint = "LEFT",
				countFont = "PT Sans Narrow",
				countFontOutline = "OUTLINE",
				countFontSize = 12,
				durationPosition = "CENTER",
				clickThrough = false,
				sortMethod = "TIME_REMAINING",
				sortDirection = "DESCENDING",
				minDuration = 0,
				maxDuration = 300,
				priority = "Blacklist,TurtleBuffs,PlayerBuffs,Dispellable", --Arena Buffs
				sizeOverride = 27,
				xOffset = 0,
				yOffset = 16
			},
			debuffs = {
				enable = true,
				perrow = 3,
				numrows = 1,
				attachTo = "FRAME",
				anchorPoint = "LEFT",
				countFont = "PT Sans Narrow",
				countFontOutline = "OUTLINE",
				countFontSize = 12,
				durationPosition = "CENTER",
				clickThrough = false,
				sortMethod = "TIME_REMAINING",
				sortDirection = "DESCENDING",
				minDuration = 0,
				maxDuration = 300,
				priority = "Blacklist,blockNoDuration,Personal,CCDebuffs,Whitelist", --Arena Debuffs
				sizeOverride = 27,
				xOffset = 0,
				yOffset = -16
			},
			castbar = {
				enable = true,
				width = 256,
				height = 18,
				icon = true,
				format = "REMAINING",
				spark = true,
				iconSize = 32,
				iconAttached = true,
				insideInfoPanel = true,
				iconAttachedTo = "Frame",
				iconPosition = "LEFT",
				iconXOffset = -10,
				iconYOffset = 0,
				timeToHold = 0,
				strataAndLevel = {
					useCustomStrata = false,
					frameStrata = "LOW",
					useCustomLevel = false,
					frameLevel = 1
				}
			},
			pvpTrinket = {
				enable = true,
				position = "RIGHT",
				size = 46,
				xOffset = 1,
				yOffset = 0
			},
			cutaway = {
				health = {
					enabled = false,
					fadeOutTime = 0.6,
					lengthBeforeFade = 0.3,
					forceBlankTexture = true
				},
				power = {
					enabled = false,
					fadeOutTime = 0.6,
					lengthBeforeFade = 0.3,
					forceBlankTexture = true
				}
			}
		},
		party = {
			enable = true,
			threatStyle = "GLOW",
			orientation = "LEFT",
			visibility = "[@raid6,exists][nogroup] hide;show",
			growthDirection = "UP_RIGHT",
			horizontalSpacing = 0,
			verticalSpacing = 3,
			numGroups = 1,
			groupsPerRowCol = 1,
			groupBy = "GROUP",
			sortDir = "ASC",
			raidWideSorting = false,
			invertGroupingOrder = false,
			startFromCenter = false,
			showPlayer = true,
			healPrediction = {
				enable = false
			},
			colorOverride = "USE_DEFAULT",
			width = 184,
			height = 54,
			groupSpacing = 0,
			disableMouseoverGlow = false,
			disableTargetGlow = false,
			health = {
				text_format = "[healthcolor][health:current-percent]",
				position = "LEFT",
				orientation = "HORIZONTAL",
				attachTextTo = "Health",
				frequentUpdates = false,
				yOffset = 0,
				xOffset = 2,
			},
			fader = {
				enable = true,
				range = true,
				hover = false,
				combat = false,
				playertarget = false,
				unittarget = false,
				focus = false,
				health = false,
				power = false,
				vehicle = false,
				casting = false,
				smooth = 0.33,
				minAlpha = 0.35,
				maxAlpha = 1,
				delay = 0
			},
			power = {
				enable = true,
				text_format = "[powercolor][power:current]",
				attachTextTo = "Health",
				width = "fill",
				height = 7,
				offset = 0,
				position = "RIGHT",
				hideonnpc = false,
				yOffset = 0,
				xOffset = -2
			},
			infoPanel = {
				enable = false,
				height = 15,
				transparent = false
			},
			name = {
				position = "CENTER",
				attachTextTo = "Health",
				text_format = "[namecolor][name:medium] [difficultycolor][smartlevel]",
				yOffset = 0,
				xOffset = 0,
			},
			portrait = {
				enable = false,
				width = 45,
				overlay = false,
				fullOverlay = false,
				style = "3D",
				overlayAlpha = 0.35
			},
			buffs = {
				enable = false,
				perrow = 4,
				numrows = 1,
				attachTo = "FRAME",
				anchorPoint = "LEFT",
				sortMethod = "TIME_REMAINING",
				sortDirection = "DESCENDING",
				countFont = "PT Sans Narrow",
				countFontOutline = "OUTLINE",
				countFontSize = 12,
				durationPosition = "CENTER",
				clickThrough = false,
				minDuration = 0,
				maxDuration = 300,
				priority = "Blacklist,TurtleBuffs", --Party Buffs
				xOffset = 0,
				yOffset = 0
			},
			debuffs = {
				enable = true,
				perrow = 4,
				numrows = 1,
				attachTo = "FRAME",
				anchorPoint = "RIGHT",
				countFont = "PT Sans Narrow",
				countFontOutline = "OUTLINE",
				countFontSize = 12,
				durationPosition = "CENTER",
				sortMethod = "TIME_REMAINING",
				sortDirection = "DESCENDING",
				clickThrough = false,
				minDuration = 0,
				maxDuration = 300,
				priority = "Blacklist,RaidDebuffs,CCDebuffs,Dispellable,Whitelist", --Party Debuffs
				xOffset = 0,
				yOffset = 0,
				sizeOverride = 52
			},
			buffIndicator = {
				enable = true,
				size = 8,
				fontSize = 10,
				profileSpecific = false
			},
			rdebuffs = {
				enable = false,
				showDispellableDebuff = true,
				onlyMatchSpellID = false,
				fontSize = 10,
				font = "Homespun",
				fontOutline = "MONOCHROMEOUTLINE",
				size = 26,
				xOffset = 0,
				yOffset = 0,
				duration = {
					position = "CENTER",
					xOffset = 0,
					yOffset = 0,
					color = {r = 1, g = 0.9, b = 0, a = 1}
				},
				stack = {
					position = "BOTTOMRIGHT",
					xOffset = 0,
					yOffset = 2,
					color = {r = 1, g = 0.9, b = 0, a = 1}
				}
			},
			castbar = {
				enable = false,
				width = 256,
				height = 18,
				icon = true,
				format = "REMAINING",
				spark = true,
				iconSize = 32,
				iconAttached = true,
				insideInfoPanel = true,
				iconAttachedTo = "Frame",
				iconPosition = "LEFT",
				iconXOffset = -10,
				iconYOffset = 0,
				timeToHold = 0,
				strataAndLevel = {
					useCustomStrata = false,
					frameStrata = "LOW",
					useCustomLevel = false,
					frameLevel = 1
				}
			},
			roleIcon = {
				enable = true,
				position = "TOPRIGHT",
				attachTo = "Health",
				xOffset = 0,
				yOffset = 0,
				size = 15,
				tank = true,
				healer = true,
				damager = true,
				combatHide = false
			},
			raidRoleIcons = {
				enable = true,
				position = "TOPLEFT"
			},
			petsGroup = {
				enable = false,
				width = 100,
				height = 22,
				anchorPoint = "TOPLEFT",
				xOffset = -1,
				yOffset = 0,
				name = {
					position = "CENTER",
					text_format = "[namecolor][name:short]",
					yOffset = 0,
					xOffset = 0
				}
			},
			targetsGroup = {
				enable = false,
				width = 100,
				height = 22,
				anchorPoint = "TOPLEFT",
				xOffset = -1,
				yOffset = 0,
				name = {
					position = "CENTER",
					text_format = "[namecolor][name:short]",
					yOffset = 0,
					xOffset = 0
				},
				raidicon = {
					enable = true,
					size = 18,
					attachTo = "TOP",
					attachToObject = "Frame",
					xOffset = 0,
					yOffset = 8
				}
			},
			raidicon = {
				enable = true,
				size = 18,
				attachTo = "TOP",
				attachToObject = "Frame",
				xOffset = 0,
				yOffset = 8
			},
			GPSArrow = {
				enable = true,
				size = 45,
				xOffset = 0,
				yOffset = 0,
				onMouseOver = true,
				outOfRange = true
			},
			readycheckIcon = {
				enable = true,
				size = 12,
				attachTo = "Health",
				position = "BOTTOM",
				xOffset = 0,
				yOffset = 2
			},
			resurrectIcon = {
				enable = true,
				size = 30,
				attachTo = "CENTER",
				attachToObject = "Frame",
				xOffset = 0,
				yOffset = 0
			},
			cutaway = {
				health = {
					enabled = false,
					fadeOutTime = 0.6,
					lengthBeforeFade = 0.3,
					forceBlankTexture = true
				},
				power = {
					enabled = false,
					fadeOutTime = 0.6,
					lengthBeforeFade = 0.3,
					forceBlankTexture = true
				}
			}
		},
		raid = {
			enable = true,
			threatStyle = "GLOW",
			orientation = "MIDDLE",
			visibility = "[@raid6,noexists][@raid26,exists] hide;show",
			growthDirection = "RIGHT_DOWN",
			horizontalSpacing = 3,
			verticalSpacing = 3,
			numGroups = 5,
			groupsPerRowCol = 1,
			groupBy = "GROUP",
			sortDir = "ASC",
			showPlayer = true,
			healPrediction = {
				enable = false
			},
			colorOverride = "USE_DEFAULT",
			width = 80,
			height = 44,
			groupSpacing = 0,
			disableMouseoverGlow = false,
			disableTargetGlow = false,
			health = {
				text_format = "[healthcolor][health:deficit]",
				position = "BOTTOM",
				orientation = "HORIZONTAL",
				attachTextTo = "Health",
				frequentUpdates = false,
				yOffset = 2,
				xOffset = 0,
			},
			fader = {
				enable = true,
				range = true,
				hover = false,
				combat = false,
				playertarget = false,
				unittarget = false,
				focus = false,
				health = false,
				power = false,
				vehicle = false,
				casting = false,
				smooth = 0.33,
				minAlpha = 0.35,
				maxAlpha = 1,
				delay = 0
			},
			power = {
				enable = true,
				text_format = "",
				width = "fill",
				height = 7,
				offset = 0,
				position = "BOTTOMRIGHT",
				hideonnpc = false,
				yOffset = 2,
				xOffset = -2
			},
			infoPanel = {
				enable = false,
				height = 12,
				transparent = false
			},
			name = {
				position = "CENTER",
				attachTextTo = "Health",
				text_format = "[namecolor][name:short]",
				yOffset = 0,
				xOffset = 0
			},
			portrait = {
				enable = false,
				width = 45,
				overlay = false,
				fullOverlay = false,
				style = "3D",
				overlayAlpha = 0.35
			},
			buffs = {
				enable = false,
				perrow = 3,
				numrows = 1,
				attachTo = "FRAME",
				anchorPoint = "LEFT",
				countFont = "PT Sans Narrow",
				countFontOutline = "OUTLINE",
				countFontSize = 12,
				durationPosition = "CENTER",
				sortMethod = "TIME_REMAINING",
				sortDirection = "DESCENDING",
				clickThrough = false,
				minDuration = 0,
				maxDuration = 300,
				priority = "Blacklist,TurtleBuffs", --Raid Buffs
				xOffset = 0,
				yOffset = 0
			},
			debuffs = {
				enable = false,
				perrow = 3,
				numrows = 1,
				attachTo = "FRAME",
				anchorPoint = "RIGHT",
				countFont = "PT Sans Narrow",
				countFontOutline = "OUTLINE",
				countFontSize = 12,
				durationPosition = "CENTER",
				sortMethod = "TIME_REMAINING",
				sortDirection = "DESCENDING",
				clickThrough = false,
				minDuration = 0,
				maxDuration = 300,
				priority = "Blacklist,RaidDebuffs,CCDebuffs,Dispellable", --Raid Debuffs
				xOffset = 0,
				yOffset = 0
			},
			buffIndicator = {
				enable = true,
				size = 8,
				fontSize = 10,
				profileSpecific = false
			},
			rdebuffs = {
				enable = true,
				showDispellableDebuff = true,
				onlyMatchSpellID = false,
				fontSize = 10,
				font = "Homespun",
				fontOutline = "MONOCHROMEOUTLINE",
				size = 26,
				xOffset = 0,
				yOffset = 2,
				duration = {
					position = "CENTER",
					xOffset = 0,
					yOffset = 0,
					color = {r = 1, g = 0.9, b = 0, a = 1}
				},
				stack = {
					position = "BOTTOMRIGHT",
					xOffset = 0,
					yOffset = 2,
					color = {r = 1, g = 0.9, b = 0, a = 1}
				}
			},
			raidRoleIcons = {
				enable = true,
				position = "TOPLEFT"
			},
			raidicon = {
				enable = true,
				size = 18,
				attachTo = "TOP",
				attachToObject = "Frame",
				xOffset = 0,
				yOffset = 8
			},
			GPSArrow = {
				enable = true,
				size = 40,
				xOffset = 0,
				yOffset = 0,
				onMouseOver = true,
				outOfRange = true
			},
			readycheckIcon = {
				enable = true,
				size = 12,
				attachTo = "Health",
				position = "BOTTOM",
				xOffset = 0,
				yOffset = 2
			},
			resurrectIcon = {
				enable = true,
				size = 30,
				attachTo = "CENTER",
				attachToObject = "Frame",
				xOffset = 0,
				yOffset = 0
			},
			cutaway = {
				health = {
					enabled = false,
					fadeOutTime = 0.6,
					lengthBeforeFade = 0.3,
					forceBlankTexture = true
				},
				power = {
					enabled = false,
					fadeOutTime = 0.6,
					lengthBeforeFade = 0.3,
					forceBlankTexture = true
				}
			}
		},
		raid40 = {
			enable = true,
			threatStyle = "GLOW",
			orientation = "MIDDLE",
			visibility = "[@raid26,noexists] hide;show",
			growthDirection = "RIGHT_DOWN",
			horizontalSpacing = 3,
			verticalSpacing = 3,
			numGroups = 8,
			groupsPerRowCol = 1,
			groupBy = "GROUP",
			sortDir = "ASC",
			showPlayer = true,
			healPrediction = {
				enable = false
			},
			colorOverride = "USE_DEFAULT",
			width = 80,
			height = 27,
			groupSpacing = 0,
			disableMouseoverGlow = false,
			disableTargetGlow = false,
			health = {
				text_format = "[healthcolor][health:deficit]",
				position = "BOTTOM",
				orientation = "HORIZONTAL",
				frequentUpdates = false,
				attachTextTo = "Health",
				yOffset = 2,
				xOffset = 0,
			},
			fader = {
				enable = true,
				range = true,
				hover = false,
				combat = false,
				playertarget = false,
				unittarget = false,
				focus = false,
				health = false,
				power = false,
				vehicle = false,
				casting = false,
				smooth = 0.33,
				minAlpha = 0.35,
				maxAlpha = 1,
				delay = 0
			},
			power = {
				enable = false,
				text_format = "",
				width = "fill",
				height = 7,
				offset = 0,
				position = "BOTTOMRIGHT",
				hideonnpc = false,
				yOffset = 2,
				xOffset = -2
			},
			infoPanel = {
				enable = false,
				height = 12,
				transparent = false
			},
			name = {
				position = "CENTER",
				text_format = "[namecolor][name:short]",
				yOffset = 0,
				xOffset = 0,
				attachTextTo = "Health"
			},
			portrait = {
				enable = false,
				width = 45,
				overlay = false,
				fullOverlay = false,
				style = "3D",
				overlayAlpha = 0.35
			},
			buffs = {
				enable = false,
				perrow = 3,
				numrows = 1,
				attachTo = "FRAME",
				anchorPoint = "LEFT",
				countFont = "PT Sans Narrow",
				countFontOutline = "OUTLINE",
				countFontSize = 12,
				durationPosition = "CENTER",
				sortMethod = "TIME_REMAINING",
				sortDirection = "DESCENDING",
				clickThrough = false,
				minDuration = 0,
				maxDuration = 300,
				priority = "Blacklist,TurtleBuffs", --Raid40 Buffs
				xOffset = 0,
				yOffset = 0
			},
			debuffs = {
				enable = false,
				perrow = 3,
				numrows = 1,
				attachTo = "FRAME",
				anchorPoint = "RIGHT",
				countFont = "PT Sans Narrow",
				countFontOutline = "OUTLINE",
				countFontSize = 12,
				durationPosition = "CENTER",
				sortMethod = "TIME_REMAINING",
				sortDirection = "DESCENDING",
				clickThrough = false,
				minDuration = 0,
				maxDuration = 300,
				priority = "Blacklist,RaidDebuffs,CCDebuffs,Dispellable,Whitelist", --Raid40 Debuffs
				xOffset = 0,
				yOffset = 0
			},
			rdebuffs = {
				enable = false,
				showDispellableDebuff = true,
				onlyMatchSpellID = false,
				fontSize = 10,
				font = "Homespun",
				fontOutline = "MONOCHROMEOUTLINE",
				size = 22,
				xOffset = 0,
				yOffset = 0,
				duration = {
					position = "CENTER",
					xOffset = 0,
					yOffset = 0,
					color = {r = 1, g = 0.9, b = 0, a = 1}
				},
				stack = {
					position = "BOTTOMRIGHT",
					xOffset = 0,
					yOffset = 2,
					color = {r = 1, g = 0.9, b = 0, a = 1}
				}
			},
			raidRoleIcons = {
				enable = true,
				position = "TOPLEFT"
			},
			buffIndicator = {
				enable = true,
				size = 8,
				fontSize = 10,
				profileSpecific = false
			},
			raidicon = {
				enable = true,
				size = 18,
				attachTo = "TOP",
				attachToObject = "Frame",
				xOffset = 0,
				yOffset = 8
			},
			GPSArrow = {
				enable = true,
				size = 45,
				xOffset = 0,
				yOffset = 0,
				onMouseOver = true,
				outOfRange = true
			},
			readycheckIcon = {
				enable = true,
				size = 12,
				attachTo = "Health",
				position = "BOTTOM",
				xOffset = 0,
				yOffset = 2
			},
			resurrectIcon = {
				enable = true,
				size = 30,
				attachTo = "CENTER",
				attachToObject = "Frame",
				xOffset = 0,
				yOffset = 0
			},
			cutaway = {
				health = {
					enabled = false,
					fadeOutTime = 0.6,
					lengthBeforeFade = 0.3,
					forceBlankTexture = true
				},
				power = {
					enabled = false,
					fadeOutTime = 0.6,
					lengthBeforeFade = 0.3,
					forceBlankTexture = true
				}
			}
		},
		raidpet = {
			enable = false,
			orientation = "MIDDLE",
			threatStyle = "GLOW",
			visibility = "[group:raid] show; hide",
			growthDirection = "DOWN_RIGHT",
			horizontalSpacing = 3,
			verticalSpacing = 3,
			numGroups = 2,
			groupsPerRowCol = 1,
			groupBy = "PETNAME",
			sortDir = "ASC",
			raidWideSorting = true,
			invertGroupingOrder = false,
			startFromCenter = false,
			healPrediction = {
				enable = true
			},
			colorOverride = "USE_DEFAULT",
			width = 80,
			height = 30,
			groupSpacing = 0,
			disableMouseoverGlow = false,
			disableTargetGlow = false,
			health = {
				text_format = "[healthcolor][health:deficit]",
				position = "BOTTOM",
				orientation = "HORIZONTAL",
				frequentUpdates = true,
				yOffset = 2,
				xOffset = 0,
				attachTextTo = "Health",
			},
			fader = {
				enable = true,
				range = true,
				hover = false,
				combat = false,
				playertarget = false,
				unittarget = false,
				focus = false,
				health = false,
				power = false,
				vehicle = false,
				casting = false,
				smooth = 0.33,
				minAlpha = 0.35,
				maxAlpha = 1,
				delay = 0
			},
			name = {
				position = "TOP",
				text_format = "[namecolor][name:short]",
				yOffset = -2,
				xOffset = 0,
				attachTextTo = "Health"
			},
			portrait = {
				enable = false,
				width = 45,
				overlay = false,
				fullOverlay = false,
				style = "3D",
				overlayAlpha = 0.35
			},
			buffs = {
				enable = false,
				perrow = 3,
				numrows = 1,
				attachTo = "FRAME",
				anchorPoint = "LEFT",
				countFont = "PT Sans Narrow",
				countFontOutline = "OUTLINE",
				countFontSize = 12,
				durationPosition = "CENTER",
				sortMethod = "TIME_REMAINING",
				sortDirection = "DESCENDING",
				clickThrough = false,
				minDuration = 0,
				maxDuration = 0,
				priority = "Blacklist,Personal,PlayerBuffs,blockNoDuration,nonPersonal", --RaidPet Buffs
				xOffset = 0,
				yOffset = 0
			},
			debuffs = {
				enable = false,
				perrow = 3,
				numrows = 1,
				attachTo = "FRAME",
				anchorPoint = "RIGHT",
				countFont = "PT Sans Narrow",
				countFontOutline = "OUTLINE",
				countFontSize = 12,
				durationPosition = "CENTER",
				sortMethod = "TIME_REMAINING",
				sortDirection = "DESCENDING",
				clickThrough = false,
				minDuration = 0,
				maxDuration = 0,
				priority = "Blacklist,Personal,Whitelist,RaidDebuffs,blockNoDuration,nonPersonal", --RaidPet Debuffs
				xOffset = 0,
				yOffset = 0
			},
			buffIndicator = {
				enable = true,
				size = 8,
				fontSize = 10,
			},
			rdebuffs = {
				enable = true,
				showDispellableDebuff = true,
				onlyMatchSpellID = false,
				fontSize = 10,
				font = "Homespun",
				fontOutline = "MONOCHROMEOUTLINE",
				size = 26,
				xOffset = 0,
				yOffset = 2,
				duration = {
					position = "CENTER",
					xOffset = 0,
					yOffset = 0,
					color = {r = 1, g = 0.9, b = 0, a = 1}
				},
				stack = {
					position = "BOTTOMRIGHT",
					xOffset = 0,
					yOffset = 2,
					color = {r = 1, g = 0.9, b = 0, a = 1}
				}
			},
			raidicon = {
				enable = true,
				size = 18,
				attachTo = "TOP",
				attachToObject = "Frame",
				xOffset = 0,
				yOffset = 8
			},
			cutaway = {
				health = {
					enabled = false,
					fadeOutTime = 0.6,
					lengthBeforeFade = 0.3,
					forceBlankTexture = true
				},
				power = {
					enabled = false,
					fadeOutTime = 0.6,
					lengthBeforeFade = 0.3,
					forceBlankTexture = true
				}
			}
		},
		tank = {
			enable = true,
			orientation = "LEFT",
			threatStyle = "GLOW",
			colorOverride = "USE_DEFAULT",
			width = 120,
			height = 28,
			disableMouseoverGlow = false,
			disableTargetGlow = false,
			disableDebuffHighlight = true,
			name = {
				position = "CENTER",
				text_format = "[namecolor][name:medium]",
				yOffset = 0,
				xOffset = 0,
				attachTextTo = "Health"
			},
			fader = {
				enable = true,
				range = true,
				hover = false,
				combat = false,
				playertarget = false,
				unittarget = false,
				focus = false,
				health = false,
				power = false,
				vehicle = false,
				casting = false,
				smooth = 0.33,
				minAlpha = 0.35,
				maxAlpha = 1,
				delay = 0
			},
			buffs = {
				enable = false,
				perrow = 6,
				numrows = 1,
				attachTo = "FRAME",
				anchorPoint = "TOPLEFT",
				countFont = "PT Sans Narrow",
				countFontOutline = "OUTLINE",
				countFontSize = 12,
				durationPosition = "CENTER",
				sortMethod = "TIME_REMAINING",
				sortDirection = "DESCENDING",
				clickThrough = false,
				minDuration = 0,
				maxDuration = 0,
				priority = "",
				xOffset = 0,
				yOffset = 2
			},
			debuffs = {
				enable = false,
				perrow = 6,
				numrows = 1,
				attachTo = "BUFFS",
				anchorPoint = "TOPRIGHT",
				countFont = "PT Sans Narrow",
				countFontOutline = "OUTLINE",
				countFontSize = 12,
				durationPosition = "CENTER",
				sortMethod = "TIME_REMAINING",
				sortDirection = "DESCENDING",
				clickThrough = false,
				minDuration = 0,
				maxDuration = 0,
				priority = "",
				xOffset = 0,
				yOffset = 1
			},
			buffIndicator = {
				enable = true,
				size = 8,
				fontSize = 10,
				profileSpecific = false
			},
			rdebuffs = {
				enable = true,
				showDispellableDebuff = true,
				onlyMatchSpellID = false,
				fontSize = 10,
				font = "Homespun",
				fontOutline = "MONOCHROMEOUTLINE",
				size = 26,
				xOffset = 0,
				yOffset = 0,
				duration = {
					position = "CENTER",
					xOffset = 0,
					yOffset = 0,
					color = {r = 1, g = 0.9, b = 0, a = 1}
				},
				stack = {
					position = "BOTTOMRIGHT",
					xOffset = 0,
					yOffset = 2,
					color = {r = 1, g = 0.9, b = 0, a = 1}
				}
			},
			raidicon = {
				enable = true,
				size = 18,
				attachTo = "TOP",
				attachToObject = "Frame",
				xOffset = 0,
				yOffset = 8
			},
			targetsGroup = {
				enable = true,
				anchorPoint = "RIGHT",
				xOffset = 1,
				yOffset = 0,
				width = 120,
				height = 28,
				colorOverride = "USE_DEFAULT",
				name = {
					position = "CENTER",
					text_format = "[namecolor][name:medium]",
					yOffset = 0,
					xOffset = 0,
					attachTextTo = "Health"
				},
				raidicon = {
					enable = true,
					size = 18,
					attachTo = "TOP",
					attachToObject = "Frame",
					xOffset = 0,
					yOffset = 8
				}
			},
			cutaway = {
				health = {
					enabled = false,
					fadeOutTime = 0.6,
					lengthBeforeFade = 0.3,
					forceBlankTexture = true
				},
				power = {
					enabled = false,
					fadeOutTime = 0.6,
					lengthBeforeFade = 0.3,
					forceBlankTexture = true
				}
			}
		},
		assist = {
			enable = true,
			orientation = "LEFT",
			threatStyle = "GLOW",
			colorOverride = "USE_DEFAULT",
			width = 120,
			height = 28,
			disableMouseoverGlow = false,
			disableTargetGlow = false,
			disableDebuffHighlight = true,
			name = {
				position = "CENTER",
				text_format = "[namecolor][name:medium]",
				yOffset = 0,
				xOffset = 0,
				attachTextTo = "Health"
			},
			fader = {
				enable = true,
				range = true,
				hover = false,
				combat = false,
				playertarget = false,
				unittarget = false,
				focus = false,
				health = false,
				power = false,
				vehicle = false,
				casting = false,
				smooth = 0.33,
				minAlpha = 0.35,
				maxAlpha = 1,
				delay = 0
			},
			buffs = {
				enable = false,
				perrow = 6,
				numrows = 1,
				attachTo = "FRAME",
				anchorPoint = "TOPLEFT",
				countFont = "PT Sans Narrow",
				countFontOutline = "OUTLINE",
				countFontSize = 12,
				durationPosition = "CENTER",
				sortMethod = "TIME_REMAINING",
				sortDirection = "DESCENDING",
				clickThrough = false,
				minDuration = 0,
				maxDuration = 0,
				priority = "",
				xOffset = 0,
				yOffset = 2
			},
			debuffs = {
				enable = false,
				perrow = 6,
				numrows = 1,
				attachTo = "BUFFS",
				anchorPoint = "TOPRIGHT",
				countFont = "PT Sans Narrow",
				countFontOutline = "OUTLINE",
				countFontSize = 12,
				durationPosition = "CENTER",
				sortMethod = "TIME_REMAINING",
				sortDirection = "DESCENDING",
				clickThrough = false,
				minDuration = 0,
				maxDuration = 0,
				priority = "",
				xOffset = 0,
				yOffset = 1
			},
			buffIndicator = {
				enable = true,
				size = 8,
				fontSize = 10,
				profileSpecific = false
			},
			rdebuffs = {
				enable = true,
				showDispellableDebuff = true,
				onlyMatchSpellID = false,
				fontSize = 10,
				font = "Homespun",
				fontOutline = "MONOCHROMEOUTLINE",
				size = 26,
				xOffset = 0,
				yOffset = 0,
				duration = {
					position = "CENTER",
					xOffset = 0,
					yOffset = 0,
					color = {r = 1, g = 0.9, b = 0, a = 1}
				},
				stack = {
					position = "BOTTOMRIGHT",
					xOffset = 0,
					yOffset = 2,
					color = {r = 1, g = 0.9, b = 0, a = 1}
				}
			},
			raidicon = {
				enable = true,
				size = 18,
				attachTo = "TOP",
				attachToObject = "Frame",
				xOffset = 0,
				yOffset = 8
			},
			targetsGroup = {
				enable = true,
				anchorPoint = "RIGHT",
				xOffset = 1,
				yOffset = 0,
				width = 120,
				height = 28,
				colorOverride = "USE_DEFAULT",
				name = {
					position = "CENTER",
					text_format = "[namecolor][name:medium]",
					yOffset = 0,
					xOffset = 0,
					attachTextTo = "Frame"
				},
				raidicon = {
					enable = true,
					size = 18,
					attachTo = "TOP",
					attachToObject = "Frame",
					xOffset = 0,
					yOffset = 8
				}
			},
			cutaway = {
				health = {
					enabled = false,
					fadeOutTime = 0.6,
					lengthBeforeFade = 0.3,
					forceBlankTexture = true
				},
				power = {
					enabled = false,
					fadeOutTime = 0.6,
					lengthBeforeFade = 0.3,
					forceBlankTexture = true
				}
			}
		}
	}
}

--Cooldown
P.cooldown = {
	enable = true,
	threshold = 3,
	expiringColor = {r = 1, g = 0, b = 0},
	secondsColor = {r = 1, g = 1, b = 0},
	minutesColor = {r = 1, g = 1, b = 1},
	hoursColor = {r = 0.4, g = 1, b = 1},
	daysColor = {r = 0.4, g = 0.4, b = 1},
	expireIndicator = {r = 1, g = 1, b = 1},
	secondsIndicator = {r = 1, g = 1, b = 1},
	minutesIndicator = {r = 1, g = 1, b = 1},
	hoursIndicator = {r = 1, g = 1, b = 1},
	daysIndicator = {r = 1, g = 1, b = 1},
	hhmmColorIndicator = {r = 1, g = 1, b = 1},
	mmssColorIndicator = {r = 1, g = 1, b = 1},

	checkSeconds = false,
	hhmmColor = {r = 0.43, g = 0.43, b = 0.43},
	mmssColor = {r = 0.56, g = 0.56, b = 0.56},
	hhmmThreshold = -1,
	mmssThreshold = -1,

	fonts = {
		enable = false,
		font = "PT Sans Narrow",
		fontOutline = "OUTLINE",
		fontSize = 18
	}
}

--Actionbar
P.actionbar = {
	font = "Homespun",
	fontSize = 10,
	fontOutline = "MONOCHROMEOUTLINE",
	fontColor = {r = 1, g = 1, b = 1},

	macrotext = false,
	hotkeytext = true,

	hotkeyTextPosition = "TOPRIGHT",
	hotkeyTextXOffset = 0,
	hotkeyTextYOffset = -3,

	countTextPosition = "BOTTOMRIGHT",
	countTextXOffset = 0,
	countTextYOffset = 2,

	keyDown = true,
	movementModifier = "SHIFT",
	transparentBackdrops = false,
	transparentButtons = false,
	globalFadeAlpha = 0,
	lockActionBars = true,
	rightClickSelfCast = false,
	desaturateOnCooldown = false,

	equippedItem = false,
	equippedItemColor = {r = 0.4, g = 1.0, b = 0.4},

	useRangeColorText = false,
	noRangeColor = {r = 0.8, g = 0.1, b = 0.1},
	noPowerColor = {r = 0.5, g = 0.5, b = 1},
	usableColor = {r = 1, g = 1, b = 1},
	notUsableColor = {r = 0.4, g = 0.4, b = 0.4},

	cooldown = {
		override = true,
		threshold = 3,
		expiringColor = {r = 1, g = 0, b = 0},
		secondsColor = {r = 1, g = 1, b = 1},
		minutesColor = {r = 1, g = 1, b = 1},
		hoursColor = {r = 1, g = 1, b = 1},
		daysColor = {r = 1, g = 1, b = 1},
		expireIndicator = {r = 1, g = 1, b = 1},
		secondsIndicator = {r = 1, g = 1, b = 1},
		minutesIndicator = {r = 1, g = 1, b = 1},
		hoursIndicator = {r = 1, g = 1, b = 1},
		daysIndicator = {r = 1, g = 1, b = 1},
		hhmmColorIndicator = {r = 1, g = 1, b = 1},
		mmssColorIndicator = {r = 1, g = 1, b = 1},

		checkSeconds = false,
		hhmmColor = {r = 0.43, g = 0.43, b = 0.43},
		mmssColor = {r = 0.56, g = 0.56, b = 0.56},
		hhmmThreshold = -1,
		mmssThreshold = -1,

		fonts = {
			enable = false,
			font = "PT Sans Narrow",
			fontOutline = "OUTLINE",
			fontSize = 18
		}
	},

	microbar = {
		enabled = true,
		mouseover = false,
		buttonsPerRow = 11,
		buttonSize = 20,
		buttonSpacing = 2,
		alpha = 1,
		visibility = "show"
	},
	bar1 = {
		enabled = true,
		buttons = 12,
		mouseover = false,
		buttonsPerRow = 12,
		point = "BOTTOMLEFT",
		backdrop = false,
		heightMult = 1,
		widthMult = 1,
		buttonsize = 32,
		buttonspacing = 2,
		backdropSpacing = 2,
		alpha = 1,
		inheritGlobalFade = false,
		showGrid = true,
		paging = {
			DRUID = "[bonusbar:1,nostealth] 7; [bonusbar:1,stealth] 8; [bonusbar:2] 8; [bonusbar:3] 9; [bonusbar:4] 10;",
			HERO = "[bonusbar:1,nostealth] 7; [bonusbar:1,stealth] 8; [bonusbar:2] 8; [bonusbar:3] 9; [bonusbar:4] 10;",
			PRIEST = "[bonusbar:1] 7;",
			PROPHET = "[stealth] 7; [nostealth] 1;",
			RANGER = "[stealth] 7; [nostealth] 1;",
			REAPER = "[stealth] 7; [nostealth] 1;",
			ROGUE = "[bonusbar:1] 7; [form:3] 7;",
			SPIRITMAGE = "[stealth] 7; [nostealth] 1;",
			WARRIOR = "[bonusbar:1] 7; [bonusbar:2] 8; [bonusbar:3] 9;",
		},
		visibility = ""
	},
	bar2 = {
		enabled = false,
		mouseover = false,
		buttons = 12,
		buttonsPerRow = 12,
		point = "BOTTOMLEFT",
		backdrop = false,
		heightMult = 1,
		widthMult = 1,
		buttonsize = 32,
		buttonspacing = 2,
		backdropSpacing = 2,
		alpha = 1,
		inheritGlobalFade = false,
		showGrid = true,
		paging = {},
		visibility = "[vehicleui] hide;show"
	},
	bar3 = {
		enabled = true,
		mouseover = false,
		buttons = 6,
		buttonsPerRow = 6,
		point = "BOTTOMLEFT",
		backdrop = false,
		heightMult = 1,
		widthMult = 1,
		buttonsize = 32,
		buttonspacing = 2,
		backdropSpacing = 2,
		alpha = 1,
		inheritGlobalFade = false,
		showGrid = true,
		paging = {},
		visibility = "[vehicleui] hide;show"
	},
	bar4 = {
		enabled = true,
		mouseover = false,
		buttons = 12,
		buttonsPerRow = 1,
		point = "TOPRIGHT",
		backdrop = true,
		heightMult = 1,
		widthMult = 1,
		buttonsize = 32,
		buttonspacing = 2,
		backdropSpacing = 2,
		alpha = 1,
		inheritGlobalFade = false,
		showGrid = true,
		paging = {},
		visibility = "[vehicleui] hide;show"
	},
	bar5 = {
		enabled = true,
		mouseover = false,
		buttons = 6,
		buttonsPerRow = 6,
		point = "BOTTOMLEFT",
		backdrop = false,
		heightMult = 1,
		widthMult = 1,
		buttonsize = 32,
		buttonspacing = 2,
		backdropSpacing = 2,
		alpha = 1,
		inheritGlobalFade = false,
		showGrid = true,
		paging = {},
		visibility = "[vehicleui] hide;show"
	},
	bar6 = {
		enabled = false,
		mouseover = false,
		buttons = 12,
		buttonsPerRow = 12,
		point = "BOTTOMLEFT",
		backdrop = false,
		heightMult = 1,
		widthMult = 1,
		buttonsize = 32,
		buttonspacing = 2,
		backdropSpacing = 2,
		alpha = 1,
		inheritGlobalFade = false,
		showGrid = true,
		paging = {},
		visibility = "[vehicleui] hide;show"
	},
	barPet = {
		enabled = true,
		mouseover = false,
		buttons = NUM_PET_ACTION_SLOTS,
		buttonsPerRow = 1,
		point = "TOPRIGHT",
		backdrop = true,
		heightMult = 1,
		widthMult = 1,
		buttonsize = 32,
		buttonspacing = 2,
		backdropSpacing = 2,
		alpha = 1,
		inheritGlobalFade = false,
		visibility = "[pet,novehicleui,nobonusbar:5] show;hide"
	},
	stanceBar = {
		enabled = true,
		style = "darkenInactive",
		mouseover = false,
		buttonsPerRow = NUM_SHAPESHIFT_SLOTS,
		buttons = NUM_SHAPESHIFT_SLOTS,
		point = "TOPLEFT",
		backdrop = false,
		heightMult = 1,
		widthMult = 1,
		buttonsize = 32,
		buttonspacing = 2,
		backdropSpacing = 2,
		alpha = 1,
		inheritGlobalFade = false,
		visibility = "[vehicleui] hide;show"
	},
	barTotem = {
		enabled = true,
		mouseover = false,
		flyoutDirection = "UP",
		buttonsize = 32,
		buttonspacing = 2,
		flyoutSpacing = 2,
		alpha = 1,
		visibility = "[vehicleui] hide;show"
	}
}

do -- cooldown stuff
	P.actionbar.cooldown = CopyTable(P.cooldown)
	P.actionbar.cooldown.expiringColor = { r = 1, g = 0.2, b = 0.2 }
	P.actionbar.cooldown.secondsColor = { r = 1, g = 1, b = 1 }
	P.actionbar.cooldown.hoursColor = { r = 1, g = 1, b = 1 }
	P.actionbar.cooldown.daysColor = { r = 1, g = 1, b = 1 }

	P.actionbar.cooldown.targetAuraColor = { r = 1, g = 0.6, b = 0.1 }
	P.actionbar.cooldown.expiringAuraColor = { r = 1, g = 0.4, b = 0.1 }

	P.actionbar.cooldown.targetAuraIndicator = { r = 0.6, g = 0.6, b = 0.6 }
	P.actionbar.cooldown.expiringAuraIndicator = { r = 0.6, g = 0.6, b = 0.6 }

	P.auras.cooldown = CopyTable(P.actionbar.cooldown)
	P.bags.cooldown = CopyTable(P.actionbar.cooldown)
	P.nameplates.cooldown = CopyTable(P.actionbar.cooldown)
	P.unitframe.cooldown = CopyTable(P.actionbar.cooldown)

	P.WeakAuras = {} -- native cooldown support with our module
	P.WeakAuras.cooldown = CopyTable(P.actionbar.cooldown)
	P.WeakAuras.cooldown.override = false

	-- color override
	P.auras.cooldown.override = false
	P.bags.cooldown.override = false
	P.actionbar.cooldown.override = true
	P.nameplates.cooldown.override = true
	P.unitframe.cooldown.override = true

	-- auras doesn't have a reverse option
	P.actionbar.cooldown.reverse = false
	P.nameplates.cooldown.reverse = false
	P.unitframe.cooldown.reverse = false
	P.bags.cooldown.reverse = false

	-- auras don't have override font settings
	P.auras.cooldown.fonts = nil

	-- we gonna need this on by default :3
	P.cooldown.enable = true
end