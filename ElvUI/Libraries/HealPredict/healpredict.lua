--[[
API:
  * RegisterCallback(addon, callback)
   `callback` is called whenever some heal state (new heal/ heal stop/ heal delay) changes.
   callback`'s arguments will be all units affected by the change in heal state, e.g.,
   `callback("Tankguy", "Dpsguy")`.

  * UnregisterCallback(addon)
    Remove all callbacks registered by `addon`.

  * UnitGetIncomingHeals(unit[, healer])
    Return predicted incoming heals on unit. If `healer`, only predict incoming heals from healer.
]]
local ADDON_NAME = "HealPredict"

-- Wow API
local CheckInteractDistance = CheckInteractDistance
local CreateFrame = CreateFrame
local GetInventoryItemLink = GetInventoryItemLink
local GetLocale = GetLocale
local GetNumRaidMembers = GetNumRaidMembers
local GetSpellInfo = GetSpellInfo
local GetTime = GetTime
local SendAddonMessage = SendAddonMessage
local strjoin = strjoin
local strsplit = strsplit
local UIParent = UIParent
local UnitBuff = UnitBuff
local UnitCanAssist =UnitCanAssist
local UnitCastingInfo = UnitCastingInfo
local UnitChannelInfo = UnitChannelInfo
local UnitHealth = UnitHealth
local UnitHealthMax = UnitHealthMax
local UnitInRaid = UnitInRaid
local UnitName = UnitName
local UnitIsDeadOrGhost = UnitIsDeadOrGhost

-- Addon message constants:
local HEALSTOP = "HealStop"
local HEALDELAY = "HealDelay"
local HEAL = "Heal"
local SEP = "/"

-- Localize spell names:
local BEACON_OF_LIGHT
do
  local locales = {
    deDE = "Flamme des Glaubens",
    enUS = "Beacon of Light",
    esES = "Señal de la Luz",
    esMX = "Señal de la Luz",
    frFR = "Guide de lumière",
    itIT = "Faro di Luce",
    koKR = "빛의 봉화",
    ptBR = "Foco de Luz",
    ruRU = "Частица Света",
    zhCN = "圣光道标",
    zhTW = "聖光信標",
  }

  BEACON_OF_LIGHT = locales[GetLocale()] or locales.enUS
end

local CHAIN_HEAL
do
  local locales = {
    deDE = "Kettenheilung",
    enUS = "Chain Heal",
    esES = "Sanación en cadena",
    esMX = "Sanación en cadena",
    frFR = "Salve de guérison",
    itIT = "Catena di Guarigione",
    koKR = "연쇄 치유",
    ptBR = "Cura Encadeada",
    ruRU = "Цепное исцеление",
    zhCN = "治疗链",
    zhTW = "治療鍊",
  }

  CHAIN_HEAL = locales[GetLocale()] or locales.enUS
end

local PRAYER_OF_HEALING
do
  local locales = {
    deDE = "Gebet der Heilung",
    enUS = "Prayer of Healing",
    esES = "Rezo de curación",
    esMX = "Rezo de sanación",
    frFR = "Prière de soins",
    itIT = "Preghiera di Cura",
    koKR = "치유의 기원",
    ptBR = "Prece de Cura",
    ruRU = "Молитва исцеления",
    zhCN = "治疗祷言",
    zhTW = "治療禱言",
  }

  PRAYER_OF_HEALING = locales[GetLocale()] or locales.enUS
end

local PRAYER_OF_PRESERVATION = "Prayer of Preservation"

local TRANQUILITY
do
  local locales = {
    deDE = "Gelassenheit",
    enUS = "Tranquility",
    esES = "Tranquilidad",
    esMX = "Tranquilidad",
    frFR = "Tranquillité",
    itIT = "Tranquillità",
    koKR = "평온",
    ptBR = "Tranquilidade",
    ruRU = "Спокойствие",
    zhCN = "宁静",
    zhTW = "寧靜",
  }

  TRANQUILITY = locales[GetLocale()] or locales.enUS
end

local SMART_HEALS = { }
SMART_HEALS[TRANQUILITY] = 5
SMART_HEALS[PRAYER_OF_PRESERVATION] = 5
SMART_HEALS[CHAIN_HEAL] = 3

-- Addon locals
local player = UnitName("player")
local heals, callbacks, cache, gear_string = { }, { }, { }, ""
local is_healing, beacon_info, current_target

-- API functions
local healpredict = CreateFrame("Frame")
function healpredict.UnitGetIncomingHeals(unit, healer)
  if UnitIsDeadOrGhost(unit) then return 0 end

  local name = UnitName(unit)

  if not heals[name] then
    return 0
  end

  local sumheal, time = 0, GetTime()

  for sender, amount in pairs(heals[name]) do
    if amount[2] <= time then
      heals[name][sender] = nil
    elseif not healer or sender == healer then
      sumheal = sumheal + amount[1]
    end
  end

  return sumheal
end

function healpredict.RegisterCallback(addon, callback)
  callbacks[addon] = callback
end

function healpredict.UnregisterCallback(addon)
  callbacks[addon] = nil
end

-- Private functions
local function UpdateCache(spell, heal)
  --[[
  cache total of all heals and number of casts
  for calculating a rolling average of the heal
  ]]
  local heal = tonumber(heal)

  if not cache[spell] then
    cache[spell] = {heal, 1}
  else
    cache[spell][1] = cache[spell][1] + heal
    cache[spell][2] = cache[spell][2] + 1
  end
end

local function handleCallbacks(...)
  for _, v in pairs(callbacks) do
    v(...)
  end
end

local function Heal(sender, target, amount, duration)
  heals[target] = heals[target] or { }
  heals[target][sender] = {amount, GetTime() + duration / 1000}

  handleCallbacks(target)
end

local function HealStop(sender)
  local affected = { }
  for target, _ in pairs(heals) do
    for tsender in pairs(heals[target]) do
      if sender == tsender then
        heals[target][tsender] = nil
        table.insert(affected, target)
      end
    end
  end

  handleCallbacks(unpack(affected))
end

local function HealDelay(sender, delay)
  if type(delay) ~= "string" then
    local delay = delay / 1000
    local affected = { }
    for target, _ in pairs(heals) do
      for tsender, amount in pairs(heals[target]) do
        if sender == tsender then
          amount[2] = amount[2] + delay
          table.insert(affected, target)
        end
      end
    end
    handleCallbacks(unpack(affected))
  end
end

local function SendHealMsg(msg)
  SendAddonMessage(ADDON_NAME, msg, "RAID")
  SendAddonMessage(ADDON_NAME, msg, "BATTLEGROUND")
end

local function max(targets)
  local currentmax = -1
  local raidname

  for name, pct in pairs(targets) do
    if pct > currentmax then
      currentmax = pct
      raidname = name
    end
  end

  return raidname
end

local function BeaconTarget()
  if beacon_info then
    local beacon_target, endtime = unpack(beacon_info)
    if endtime > GetTime() then
      beacon_info = nil
    else
      return beacon_target
    end
  end
end

local function GroupHeal(amount, casttime)
  local partyN, partyname, beacon_found
  local beacon_target = BeaconTarget()

  for i=1,4 do
    partyN = "party"..i

    if CheckInteractDistance(partyN, 4) then
      partyname = (UnitName(partyN))
      if beacon_target and partyname == beacon_target then
        beacon_found = true
        Heal(player, partyname, amount * 1.4, casttime)
        SendHealMsg(strjoin(SEP, HEAL, partyname, amount * 1.4, casttime))
      elseif partyname then
        Heal(player, partyname, amount, casttime)
        SendHealMsg(strjoin(SEP, HEAL, partyname, amount, casttime))
      end
    end
  end

  if beacon_target and not beacon_found then
    Heal(player, beacon_target, amount * .4, casttime)
    SendHealMsg(strjoin(SEP, HEAL, beacon_target, amount * .4, casttime))
  end

  Heal(player, player, amount, casttime)
  SendHealMsg(strjoin(SEP, HEAL, player, amount, casttime))
end

local function SmartHeal(amount, casttime, n)
  if not UnitInRaid("player") then
    return GroupHeal(amount, casttime)
  end

  local beacon_target = BeaconTarget()
  local beacon_found

  local healthpct, currentmax
  local pcts = { }
  local raidN, raidname

  for i=1,GetNumRaidMembers() do
    raidN = "raid"..i

    if not UnitIsDeadOrGhost(raidN) and CheckInteractDistance(raidN, 4) then
      raidname = (UnitName(raidN))
      healthpct = UnitHealth(raidN) / UnitHealthMax(raidname)

      if #pcts < n then
        pcts[raidname] = healthpct

        if not currentmax or healthpct > pcts[currentmax] then
          currentmax = raidname
        end

      elseif healthpct < pcts[currentmax] then
        pcts[currentmax] = nil
        pcts[raidname] = healthpct
        currentmax = max(pcts)
      end
    end
  end

  for target, _ in pairs(pcts) do
    if beacon_target and target == beacon_target then
      beacon_found = true
      Heal(player, target, amount * 1.4, casttime)
      SendHealMsg(strjoin(SEP, HEAL, target, amount * 1.4, casttime))
    else
      Heal(player, target, amount, casttime)
      SendHealMsg(strjoin(SEP, HEAL, target, amount, casttime))
    end
  end

  if beacon_target and not beacon_found then
    Heal(player, beacon_target, amount * .4, casttime)
    SendHealMsg(strjoin(SEP, HEAL, beacon_target, amount * .4, casttime))
  end
end

local function UnitByName(name)
  if name == player then
    return "player"
  end

  local unit

  if UnitInRaid("player") then
    for i=1,GetNumRaidMembers() do
      unit = "raid"..i

      if (UnitName(unit)) == name then
        return unit
      end
    end
  end

  for i=1,4 do
    unit = "party"..i

    if (UnitName(unit)) == name then
      return unit
    end
  end
end

-- Message passing
healpredict:RegisterEvent("CHAT_MSG_ADDON")
healpredict:SetScript("OnEvent", function(_, _, prefix, msg, _, sender)
  if prefix == ADDON_NAME then
    local command, target_or_delay, amount, casttime = strsplit(SEP, msg)
    if command == HEALSTOP then
      HealStop(sender)
    elseif command == HEAL then
      Heal(sender, target_or_delay, amount, casttime)
    elseif command == HEALDELAY then
      HealDelay(sender, target_or_delay)
    end
  end
end)

-- Reset cache on skill or inventory change
local resetcache = CreateFrame("Frame")
resetcache:RegisterEvent("SKILL_LINES_CHANGED")
resetcache:RegisterEvent("UNIT_INVENTORY_CHANGED")
resetcache:SetScript("OnEvent", function(_, event, player)
  if player ~= "player" then
    return
  end

  if event == "UNIT_INVENTORY_CHANGED" then
    local gear = ""
    for id = 1, 18 do
      gear = gear .. (GetInventoryItemLink("player",id) or "")
    end

    if gear == gear_string then
      return
    end

    gear_string = gear
  end

  --  reset cache
  cache = { }
end)

--Event handling
----------------
local eventhandler = CreateFrame("Frame", ADDON_NAME .. "EventHandler", UIParent)

eventhandler:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
function eventhandler.COMBAT_LOG_EVENT_UNFILTERED(_, subevent, _, sourcename, _, _, destname, _, spellid, spellname, _, amount)
  if sourcename ~= player then return end

  if subevent == "SPELL_HEAL" then
    local _, rank = GetSpellInfo(spellid)
    local spellrank = spellname..(rank or "")
    UpdateCache(spellrank, amount)

    if spellname == TRANQUILITY then
      -- Need to re-acquire tranq targets
      HealStop(player)
      SendHealMsg(HEALSTOP)

      local _, _, _, _, starttime, endtime = UnitChannelInfo("player")
      if starttime ~= nil and endtime ~= nil then
        local casttime = endtime - starttime

        local total, casts = unpack(cache[spellrank])
        local amount = total / casts

        SmartHeal(amount, casttime, 5)
        is_healing = true
      end
    end
  elseif spellname == BEACON_OF_LIGHT then
    if subevent == "SPELL_AURA_APPLIED" then
      local unit = UnitByName(destname)

      if not unit then
        return
      end

      for i=1,40 do
        local buff, _, _, _, _, endtime = UnitBuff(unit, i)
        if buff == BEACON_OF_LIGHT then
          beacon_info = {destname, endtime}
          break
        end
      end

    elseif subevent == "SPELL_AURA_REMOVED" then
      beacon_info = nil
    end
  end
end

eventhandler:RegisterEvent("UNIT_SPELLCAST_SENT")
function eventhandler.UNIT_SPELLCAST_SENT(unit, _, _, target)
  if unit == "player" then
    if target == "" then
      current_target = UnitCanAssist("player", "target") and UnitName("target") or player
    else
      current_target = target
    end
  end
end

eventhandler:RegisterEvent("UNIT_SPELLCAST_START")
function eventhandler.UNIT_SPELLCAST_START(unit)
  if unit ~= "player" then return end

  local spell, rank, _, _, starttime, endtime = UnitCastingInfo("player")
  if not spell then
    spell, rank, _, _, starttime, endtime = UnitChannelInfo("player")
  end
  local casttime = endtime - starttime
  local spellrank = spell..(rank or "")

  if cache[spellrank] then
    local total, casts = unpack(cache[spellrank])
    local amount = total / casts

    if spell == PRAYER_OF_HEALING then
      GroupHeal(amount, casttime)
    elseif SMART_HEALS[spell] then
      SmartHeal(amount, casttime, SMART_HEALS[spell])
    else
      local beacon_target = BeaconTarget()

      if beacon_target then
        if beacon_target ~= current_target then
          Heal(player, current_target, amount, casttime)
          SendHealMsg(strjoin(SEP, HEAL, current_target, amount, casttime))

          Heal(player, beacon_target, amount * .4, casttime)
          SendHealMsg(strjoin(SEP, HEAL, beacon_target, amount * .4, casttime))
        else
          Heal(player, beacon_target, amount * 1.4, casttime)
          SendHealMsg(strjoin(SEP, HEAL, beacon_target, amount * 1.4, casttime))
        end
      else
        Heal(player, current_target, amount, casttime)
        SendHealMsg(strjoin(SEP, HEAL, current_target, amount, casttime))
      end
    end

    is_healing = true
  end
end

eventhandler:RegisterEvent("UNIT_SPELLCAST_CHANNEL_START")
eventhandler.UNIT_SPELLCAST_CHANNEL_START = eventhandler.UNIT_SPELLCAST_START

eventhandler:RegisterEvent("UNIT_SPELLCAST_FAILED")
function eventhandler.UNIT_SPELLCAST_FAILED(unit)
  if is_healing and unit == "player" then
    HealStop(player)
    SendHealMsg(HEALSTOP)
    is_healing = nil
  end
end

eventhandler:RegisterEvent("UNIT_SPELLCAST_INTERRUPTED")
eventhandler.UNIT_SPELLCAST_INTERRUPTED = eventhandler.UNIT_SPELLCAST_FAILED

eventhandler:RegisterEvent("UNIT_SPELLCAST_STOP")
eventhandler.UNIT_SPELLCAST_STOP = eventhandler.UNIT_SPELLCAST_FAILED

eventhandler:RegisterEvent("UNIT_SPELLCAST_CHANNEL_STOP")
eventhandler.UNIT_SPELLCAST_CHANNEL_STOP = eventhandler.UNIT_SPELLCAST_FAILED

eventhandler:RegisterEvent("UNIT_SPELLCAST_DELAYED")
function eventhandler.UNIT_SPELLCAST_DELAYED(unit, delay)
  if is_healing and unit == "player" then
    HealDelay(player, delay)
    SendHealMsg(strjoin(SEP, HEALDELAY, delay))
  end
end

eventhandler:SetScript("OnEvent", function(_, event, ...)
  local handler = eventhandler[event]
  if handler then
    handler(...)
  end
end)

_G[ADDON_NAME] = healpredict