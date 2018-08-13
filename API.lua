--WOW API
local type = type
local strmatch = strmatch
local strtrim = strtrim
local tonumber = tonumber
local select = select
local strfind = strfind
local strlower = strlower
local strsub = strsub
local strsplit = strsplit
local tostring = tostring
local gmatch = gmatch
local unpack = unpack
local getglobal = getglobal
local tinsert = tinsert
local error = error
local strupper = strupper
local strlen = strlen
local format = format
local setmetatable = setmetatable
local pairs = pairs
local print = print
local next = next
local tremove = tremove
local sort = sort
local pi = math.pi
local tan = math.tan
local cos = math.cos
local sin = math.sin
local abs = math.abs
local atan = math.atan
local sqrt = math.sqrt
local pow = math.pow
local bitbor = bit.bor
local tContains = tContains
local wipe = wipe
local GetName = GetName
local GetText = GetText
local GetTime = GetTime
local GetItemInfo = GetItemInfo
local GetSpellInfo = GetSpellInfo
local GetSpellLink = GetSpellLink
local GetUnitSpeed = GetUnitSpeed
local GetTotemInfo = GetTotemInfo
local GetTalentInfo = GetTalentInfo
local GetActiveSpecGroup = GetActiveSpecGroup
local GetItemCooldown = GetItemCooldown
local GetSpellCooldown = GetSpellCooldown
local IsUsableItem = IsUsableItem
local ItemHasRange = ItemHasRange
local IsUsableSpell = IsUsableSpell
local IsCurrentSpell = IsCurrentSpell
local IsSpellInRange = IsSpellInRange
local SpellHasRange = SpellHasRange
local IsAutoRepeatSpell = IsAutoRepeatSpell
local IsMouseButtonDown = IsMouseButtonDown
local IsHarmfulSpell = IsHarmfulSpell
local IsHelpfulSpell = IsHelpfulSpell
local IsPassiveSpell = IsPassiveSpell
local IsActiveBattlefieldArena = IsActiveBattlefieldArena
local CameraOrSelectOrMoveStop = CameraOrSelectOrMoveStop
local CameraOrSelectOrMoveStart = CameraOrSelectOrMoveStart
local TurnOrActionStart = TurnOrActionStart
local TurnOrActionStop = TurnOrActionStop
local CheckInteractDistance = CheckInteractDistance
local UnitIsVisible = UnitIsVisible
local UnitInPhase = UnitInPhase
local UnitGUID = UnitGUID
local UnitName = UnitName
local GetUnitName = GetUnitName
local UnitHealth = UnitHealth
local UnitHealthMax = UnitHealthMax
local UnitClass = UnitClass
local UnitPower = UnitPower
local UnitPowerMax = UnitPowerMax
local UnitCastingInfo = UnitCastingInfo
local UnitChannelInfo = UnitChannelInfo
local UnitBuff = UnitBuff
local UnitDebuff = UnitDebuff
local UnitIsUnit = UnitIsUnit
local UnitCanAssist = UnitCanAssist
local UnitCanAttack = UnitCanAttack
local UnitClassBase = UnitClassBase
local UnitGetIncomingHeals = UnitGetIncomingHeals
local GetSpecialization = GetSpecialization
local GetSpecializationInfo = GetSpecializationInfo
local GetSpellDescription = GetSpellDescription
local GetNumSubgroupMembers = GetNumSubgroupMembers
local GetNumGroupMembers = GetNumGroupMembers
local GetSpellCharges = GetSpellCharges
local GetRuneCooldown = GetRuneCooldown
local GetWeaponEnchantInfo = GetWeaponEnchantInfo
local GetNumGlyphSockets = GetNumGlyphSockets
local GetGlyphSocketInfo = GetGlyphSocketInfo
local UnitIsDeadOrGhost = UnitIsDeadOrGhost
local GetRuneCount = GetRuneCount
local IsFishingLoot = IsFishingLoot
local GetNumLootItems = GetNumLootItems
local ConfirmLootSlot = ConfirmLootSlot
local LootSlot = LootSlot
local CloseLoot = CloseLoot
local InteractUnit = InteractUnit
local GetMeleeHaste = GetMeleeHaste
local IsIteminRange = IsIteminRange
local IsInRaid = IsInRaid
local GetSpellTabInfo = GetSpellTabInfo
local GetNumSpellTabs = GetNumSpellTabs
local GetSpellBookItemInfo = GetSpellBookItemInfo
local GetSpellBookItemName = GetSpellBookItemName
local UnitExists = UnitExists

--lib
--local GRange = LibStub("LibRangeCheck-2.0");
local RunMacroText = RunMacroText
local CastSpellByName = CastSpellByName
local UseItemByName = UseItemByName
--FH API
local FireHack = FireHack
local ObjectPointer = ObjectPointer
local ObjectType = ObjectType
local UnitHeight = UnitHeight
local GetObjectCount = GetObjectCount
local GetObjectWithIndex = GetObjectWithIndex
local ObjectIsVisible = ObjectIsVisible
local ObjectRawType = ObjectRawType
local ObjectFacing = ObjectFacing
local FaceDirection = FaceDirection
local GetAnglesBetweenObjects = GetAnglesBetweenObjects
local ObjectPosition = ObjectPosition
local ClickPosition = ClickPosition
local CancelPendingSpell = CancelPendingSpell
local TraceLine = TraceLine
local GetObjectWithGUID = GetObjectWithGUID
local GetDistanceBetweenPositions = GetDistanceBetweenPositions
local ObjectIsBehind = ObjectIsBehind
local ObjectIsFacing = ObjectIsFacing
local GetPositionBetweenObjects = GetPositionBetweenObjects
local GetDistanceBetweenObjects = GetDistanceBetweenObjects
local UnitTarget = UnitTarget
local IsAoEPending = IsAoEPending
local GetSessionVariable = GetSessionVariable
local UnitBoundingRadius = UnitBoundingRadius
local UnitCombatReach = UnitCombatReach
local MoveTo = MoveTo
local StopFalling = StopFalling
local ObjectDescriptor = ObjectDescriptor
local ObjectField = ObjectField
local Types = Types
local IsHackEnabled = IsHackEnabled
---------------------------------------------------------------------------------

--技能检查
---------------------------------------------------------------------------------
local spellsByName_spell = {}
local spellsByID_spell = {}
local spellsByName_pet = {}
local spellsByID_pet = {}
local TalentSpell = {}
local function UpdateBook(bookType)
	local _, _, offset, numSpells = GetSpellTabInfo(2)
	local spellsByName, spellsByID = {}, {}
	if bookType == "spell" then
		spellsByName = spellsByName_spell
		spellsByID = spellsByID_spell
	elseif bookType == "pet" then
		spellsByName = spellsByName_pet
		spellsByID = spellsByID_pet
	end
	wipe(spellsByName)
	wipe(spellsByID)
	for spellBookID = offset + 1, numSpells + offset do
		local type, baseSpellID = GetSpellBookItemInfo(spellBookID, bookType)
		if type == "SPELL" then
			local currentSpellName = GetSpellBookItemName(spellBookID, bookType)
			local link = GetSpellLink(currentSpellName)
			local currentSpellID = tonumber(link and link:gsub("|", "||"):match("spell:(%d+)"))
			local baseSpellName = GetSpellInfo(baseSpellID)
			if currentSpellName then
				spellsByName[strlower(currentSpellName)] = spellBookID
			end
			if baseSpellName then
				spellsByName[strlower(baseSpellName)] = spellBookID
			end
			if currentSpellID then
				spellsByID[currentSpellID] = spellBookID
			end
			if baseSpellID then
				spellsByID[baseSpellID] = spellBookID
			end
		end
	end
	--天赋
	local ActiveSpecGroup = GetActiveSpecGroup()
	for Column = 1, 3 do
		for Row = 1, 7 do
			local _, namePve, _, selectedPve, _, idPve = GetTalentInfo(Row, Column, ActiveSpecGroup)
			if namePve then
				TalentSpell[namePve] = selectedPve
				TalentSpell[idPve] = selectedPve
			end
		end
		--[[ 	for Row = 1, 6 do
			local _, namePvp, _, selectedPvp, _, idpvp = GetPvpTalentInfo(Row, Column, ActiveSpecGroup)
			if namePvp then
				TalentSpell[namePvp] = selectedPvp
				TalentSpell[idpvp] = selectedPvp
			end
		end ]]
		for Row = 1, 4 do
			local slotInfo = C_SpecializationInfo.GetPvpTalentSlotInfo(Row)
			local talentID1 = slotInfo.selectedTalentID
			if talentID1 then
				local talentID, name, texture, selected, available, spellID, unknown, row, column =
					GetPvpTalentInfoByID(talentID1, GetSpecializationInfo(GetSpecialization()))
				if name then
					TalentSpell[name] = available
					TalentSpell[spellID] = available
				end
			end
		end
	end
end
local function UpdateSpells()
	UpdateBook("spell")
	UpdateBook("pet")
end
local updaterFrame = CreateFrame("Frame")
updaterFrame:RegisterEvent("SPELLS_CHANGED")
updaterFrame:SetScript("OnEvent", UpdateSpells)
UpdateSpells()
---------------------------------------------------------------------------------

--目标是否在技能范围内
---------------------------------------------------------------------------------
function msISIR(spellInput, unit)
	if type(spellInput) == "number" then
		local spell = spellsByID_spell[spellInput]
		if spell then
			return IsSpellInRange(spell, "spell", unit)
		else
			local spell = spellsByID_pet[spellInput]
			if spell then
				return IsSpellInRange(spell, "pet", unit)
			end
		end
	elseif type(spellInput) == "string" then
		spellInput = strtrim(spellInput)
		local spell = spellsByName_spell[spellInput]
		if spell then
			return IsSpellInRange(spell, "spell", unit)
		else
			local spell = spellsByName_pet[spellInput]
			if spell then
				return IsSpellInRange(spell, "pet", unit)
			end
		end
		return IsSpellInRange(spellInput, unit)
	end
end
---------------------------------------------------------------------------------

--目标是否在技能范围内
---------------------------------------------------------------------------------
function msISR(spellInput, unit)
	unit = unit or "target"
	if type(spellInput) == "number" then
		local spell = spellsByID_spell[spellInput]
		if spell then
			return IsSpellInRange(spell, "spell", unit) == 1
		else
			local spell = spellsByID_pet[spellInput]
			if spell then
				return IsSpellInRange(spell, "pet", unit) == 1
			end
		end
	else
		spellInput = strtrim(spellInput)
		local spell = spellsByName_spell[spellInput]
		if spell then
			return IsSpellInRange(spell, "spell", unit) == 1
		else
			local spell = spellsByName_pet[spellInput]
			if spell then
				return IsSpellInRange(spell, "pet", unit) == 1
			end
		end
		return IsSpellInRange(spellInput, unit) == 1
	end
end
---------------------------------------------------------------------------------

--技能是否有范围
---------------------------------------------------------------------------------
function msISHR(spellInput)
	if type(spellInput) == "number" then
		local spell = spellsByID_spell[spellInput]
		if spell then
			return SpellHasRange(spell, "spell")
		else
			local spell = spellsByID_pet[spellInput]
			if spell then
				return SpellHasRange(spell, "pet")
			end
		end
	else
		spellInput = strtrim(spellInput)
		local spell = spellsByName_spell[spellInput]
		if spell then
			return SpellHasRange(spell, "spell")
		else
			local spell = spellsByName_pet[spellInput]
			if spell then
				return SpellHasRange(spell, "pet")
			end
		end
		return SpellHasRange(spellInput)
	end
end
---------------------------------------------------------------------------------

--技能是否伤害技能
---------------------------------------------------------------------------------
function msIsHarm(spellInput)
	if type(spellInput) == "number" then
		local spell = spellsByID_spell[spellInput]
		if spell then
			return IsHarmfulSpell(spell, "spell")
		else
			local spell = spellsByID_pet[spellInput]
			if spell then
				return IsHarmfulSpell(spell, "pet")
			end
		end
	else
		spellInput = strtrim(spellInput)
		local spell = spellsByName_spell[spellInput]
		if spell then
			return IsHarmfulSpell(spell, "spell")
		else
			local spell = spellsByName_pet[spellInput]
			if spell then
				return IsHarmfulSpell(spell, "pet")
			end
		end
		return IsHarmfulSpell(spellInput)
	end
end
---------------------------------------------------------------------------------

--技能是否友善类
---------------------------------------------------------------------------------
function msIsHelp(spellInput)
	if type(spellInput) == "number" then
		local spell = spellsByID_spell[spellInput]
		if spell then
			return IsHelpfulSpell(spell, "spell")
		else
			local spell = spellsByID_pet[spellInput]
			if spell then
				return IsHelpfulSpell(spell, "pet")
			end
		end
	else
		spellInput = strtrim(spellInput)
		local spell = spellsByName_spell[spellInput]
		if spell then
			return IsHelpfulSpell(spell, "spell")
		else
			local spell = spellsByName_pet[spellInput]
			if spell then
				return IsHelpfulSpell(spell, "pet")
			end
		end
		return IsHelpfulSpell(spellInput)
	end
end
---------------------------------------------------------------------------------

--技能是否可以使用
---------------------------------------------------------------------------------
function msIsUseSpell(spellInput)
	if type(spellInput) == "number" then
		local spell = spellsByID_spell[spellInput]
		if spell then
			return IsUsableSpell(spell, "spell")
		else
			local spell = spellsByID_pet[spellInput]
			if spell then
				return IsUsableSpell(spell, "pet")
			end
		end
	else
		spellInput = strtrim(spellInput)
		local spell = spellsByName_spell[spellInput]
		print(spell)
		if spell then
			return IsUsableSpell(spell, "spell")
		else
			local spell = spellsByName_pet[spellInput]
			if spell then
				return IsUsableSpell(spell, "pet")
			end
		end
		return IsUsableSpell(spellInput)
	end
end
---------------------------------------------------------------------------------

--技能物品识别
----------------------------------------------------------------------------------
function msGSI(spell)
	if not spell then
		return nil, "INVALID"
	end
	local spelltype, spellid, spellname, ID, isspell, isitem
	spelltype = strsub(spell, 1, 5)
	ID = strsub(spell, 6, -1)
	spellid = tonumber(ID)
	if spelltype == "SPELL" then
		spellname = GetSpellInfo(spellid)
		if spellname then
			return spelltype, spellname, spellid
		else
			return nil, "INVALID"
		end
	else
		spelltype = strsub(spell, 1, 4)
		ID = strsub(spell, 5, -1)
		spellid = tonumber(ID)
		if spelltype == "ITEM" then
			spellname = GetItemInfo(spellid)
			if spellname then
				return spelltype, spellname, spellid
			else
				return nil, "INVALID"
			end
		else
			spelltype = nil
		end
	end
	if not spelltype then
		--local Spell_name, _, _, _, _, Spell_Id = GetSpellInfo(spell)
		local Spell_name, rank, icon, castTime, minRange, maxRange, Spell_Id = GetSpellInfo(spell)
		if Spell_name then
			isspell = true
			spelltype = "SPELL"
			spellid = Spell_Id
			spellname = Spell_name
		end
		local itemName, itemLink = GetItemInfo(spell)
		if itemName then
			isitem = true
			spelltype = "ITEM"
			spellname = itemName
			spellid = strmatch(itemLink, "item:(%d*)")
		end
	end
	if (isspell and isitem) then
		return nil, "AMBIGUOUS"
	elseif isspell or isitem then
		return spelltype, spellname, spellid
	end
	return nil, "INVALID"
end
----------------------------------------------------------------------------------

--获取技能或物品spell是否可以对目标unit施放,是否忽略移动判断
----------------------------------------------------------------------------------
function msISC(spell, unit, Face, move)
	if type(spell) ~= "string" then
		return false, "技能或物品名称无效。", spell
	elseif type(unit) == "string" and strtrim(unit) == "" then
		unit = nil
	end
	if type(unit) == "string" then
		if not UnitIsVisible(unit) or not UnitInPhase(unit) then
			return false, "目标不存在。", unit
		elseif Face and not msIF(unit) then
			return false, "没有面对目标。", unit
		elseif not UnitCanAssist("player", unit) and not UnitCanAttack("player", unit) then
			return false, "该目标无法被攻击或辅助。", spell, unit
		end
	end
	local spelltype, spellname, spellId = msGSI(strtrim(spell))
	if not spelltype then
		if spellname == "AMBIGUOUS" then
			return false, "技能或物品名称存在二义性，请添加前缀进行限定。如:", "SPELL" .. spell .. " 或者 ITEM" .. spell
		elseif spellname == "INVALID" then
			return false, "技能或物品名称不存在。", spell
		else
			return false, "技能或物品无法判断。", spell
		end
	end
	if spelltype == "ITEM" then
		if not IsUsableItem(spellId) then
			return false, "无法使用物品。", spellname
		end
		local starttime, duration = GetItemCooldown(spellId)
		local nowtime = GetTime()
		if starttime and nowtime - starttime < duration then
			return false, "物品尚未冷却：", duration - (nowtime - starttime)
		end
		if ItemHasRange(spellId) and UnitIsVisible(unit) and UnitInPhase(unit) and not IsIteminRange(spellId, unit) then
			return false, "目标距离太远。", spellname, unit
		end
	elseif spelltype == "SPELL" then
		local starttime, duration = GetSpellCooldown(spellId)
		local nowtime = GetTime()
		local casttime = select(4, GetSpellInfo(spellId))
		if starttime and nowtime - starttime < duration then
			return false, "技能尚未冷却：", duration - (nowtime - starttime)
		end
		if casttime > 0 and GetUnitSpeed("player") > 0 and not move and not IsHackEnabled("MovingCast") then
			return false, "玩家正在移动,需要移动中施法可把参数3设置成true。"
		end
		if not msIsUseSpell(spellId) then
			return false, "无法使用技能。", spellname
		end
		if IsAutoRepeatSpell(spellname) then
			return false, "无法施放自动施放技能。", spellname
		end
		if casttime == 0 and IsCurrentSpell(spellname) then
			return false, "技能需要目标。", spellname
		end
		local isInRange = msISIR(spellId, unit)
		if isInRange == 0 then
			return false, "目标距离太远。", spellname, unit
		end
	else
		return false, "技能或物品名称不存在。", spellname
	end
	return true, spellname, spellId
end
----------------------------------------------------------------------------------

--对unit施放spell
----------------------------------------------------------------------------------
function msRun(spell, unit, Face)
	if type(spell) ~= "string" then
		return false, "技能或物品名称无效。", spell
	elseif type(unit) == "string" and strtrim(unit) == "" then
		unit = nil
	end
	spell = strtrim(spell)
	local isMacro, spelltype, spellname
	if strsub(spell, 1, 1) == "/" then
		isMacro = true
		spellname = spell
	else
		spelltype, spellname = msGSI(spell)
		if not spelltype then
			if (spellname == "AMBIGUOUS") then
				return false, "技能或物品名称存在二义性，请添加前缀进行限定。"
			elseif (spellname == "INVALID") then
				return false, "技能或物品名称不存在。"
			else
				return nil
			end
		end
	end
	if isMacro then
		RunMacroText(spellname)
	elseif spelltype == "SPELL" then
		if Face and not msIPC() and UnitIsVisible(unit) and UnitInPhase(unit) and not UnitIsUnit("player", unit) then
			local Facing = ObjectFacing("player")
			FaceDirection(GetAnglesBetweenObjects("player", unit), true)
			CastSpellByName(spellname, unit)
			FaceDirection(Facing)
		else
			CastSpellByName(spellname, unit)
		end
	elseif spelltype == "ITEM" then
		UseItemByName(spellname, unit)
	end
	if UnitIsVisible(unit) and UnitInPhase(unit) and IsAoEPending() then
		ClickPosition(ObjectPosition(unit))
		CancelPendingSpell()
	elseif type(unit) == "table" and IsAoEPending() then
		ClickPosition(unpack(unit))
		CancelPendingSpell()
	end
	return true, spellname, unit
end
msR = msRun
----------------------------------------------------------------------------------

--获取指定中心周围有限范围内的所有单位（包括玩家与NPC,敌对与友善）,友善/敌对,玩家/怪物
----------------------------------------------------------------------------------
function msGetUnits(isFriend, objType, distance, Central)
	if isFriend == true then
		isFriend = UnitCanAssist
	elseif isFriend == false then
		isFriend = UnitCanAttack
	elseif isFriend == nil then
		isFriend = function(unit1, unit2)
			return UnitCanAssist(unit1, unit2) or UnitCanAttack(unit1, unit2)
		end
	end
	local ExObjectTypes = UnitIsDeadOrGhost
	local InObjectTypes = ObjectType.Unit
	if objType == true then
		InObjectTypes = ObjectType.Player
	elseif objType == false then
		ExObjectTypes = ObjectRawType
		NOTPlayer = ObjectType.Player
	end
	if type(distance) ~= "number" then
		distance = nil
	end
	if type(Central) ~= "string" then
		Central = "player"
	end
	local GetUnitsTable = {}
	if not UnitIsVisible(Central) or not UnitInPhase(Central) then
		return GetUnitsTable
	end
	for i = 1, GetObjectCount() do
		local thisUnit = GetObjectWithIndex(i)
		if ObjectRawType(thisUnit, InObjectTypes) and not ExObjectTypes(thisUnit, NOTPlayer) then
			local a =
				UnitCreatureType(thisUnit) ~= "野生宠物" and UnitCreatureType(thisUnit) ~= "未指定" and
				UnitCreatureType(thisUnit) ~= "非战斗宠物"
			if
				UnitIsVisible(thisUnit) and UnitInPhase(thisUnit) and not UnitIsDeadOrGhost(thisUnit) and a and
					isFriend(thisUnit, Central)
			 then
				if not distance then
					tinsert(GetUnitsTable, thisUnit)
				elseif distance and msGD(thisUnit, Central) < distance then
					tinsert(GetUnitsTable, thisUnit)
				end
			end
		end
	end
	return GetUnitsTable
end
----------------------------------------------------------------------------------

--队伍成员刷新机制
local GuidTable = {}
local function GROUP_UPDATE()
	--print(GetNumGroupMembers(),GetNumSubgroupMembers(),"刷新队伍列表")
	wipe(GuidTable)
	--local group = IsInRaid() and "raid" or "party"
	local gourptype
	local InRaid = IsInRaid()
	local InParty = UnitInParty("player")
	if InRaid and InParty then
		grouptype = "raid"
	end
	if InRaid == false and InParty then
		grouptype = "party"
	end
	--local Members = IsInRaid() and GetNumGroupMembers() or (GetNumSubgroupMembers() + 1)
	local Members = GetNumGroupMembers()
	if Members > 0 then
		for i = 1, Members do
			--if ObjectRawType(thisUnit, player)
			--[[	if i == Members and group == "party" then
				Unit = "player"
			else
				Unit = group .. i
			end
			--print(UnitName(Unit))]]
			local Unit = grouptype .. i
			tinsert(GuidTable, Unit)
		end
	end
end
local GROUPUPDATE = CreateFrame("Frame")
GROUPUPDATE:RegisterEvent("GROUP_ROSTER_UPDATE")
GROUPUPDATE:SetScript("OnEvent", GROUP_UPDATE)
GROUP_UPDATE()

----------------------------------------------------------------------------------
--[[在目标group数组中根据过滤条件 FilterFunc,对比 ValueFunc 值大小的目标GUID
GetSort(group,FilterFunc,ValueFunc)
group		目标群表,默认小队/团队
FilterFunc	条件函数function,如可以被我攻击的:function(unit) return UnitCanAttack(unit,"player") end
ValueFunc	对比函数function,如对比距离我最小的:function(a,b) return msGD(a) < msGD(b) end 或对比血量最大的目标function(a,b) return msGHP(a) > msGHP(b) end

例如:找出参数1条件为(身边可以攻击的),参数2为(距离我最近)的目标
local GUnits = msGetUnits(false,nil)
local Unit = msGetSort(GUnits,function(unit)
		return UnitCanAttack(unit,"player")
	end,
	function(a,b)
		return msGD(a) < msGD(b)
	end)
例如:找到身边40码内友善的玩家,他们中血量最小的那个
local GUnits = msGetUnits(true,true)--获取友善的玩家
local Unit = msGetSort(GUnits,function(unit) return msGFD(unit)<=40 end,function(a,b) return msGHP(a) < msGHP(b) end)

]]
----------------------------------------------------------------------------------
function msGetSort(group, FilterFunc, ValueFunc)
	if type(FilterFunc) ~= "function" then
		FilterFunc = function(unit)
			return UnitIsVisible(unit) and UnitInPhase(unit)
		end
	end
	if type(ValueFunc) ~= "function" then
		ValueFunc = function(a, b)
			return msGHP(a) < msGHP(b)
		end
	end
	local guidtable = {}
	if type(group) ~= "table" then
		guidtable = GuidTable
	elseif type(group) == "table" and #group > 0 then
		guidtable = group
	else
		return false, group, "无目标。"
	end
	local GetSortTable = {}
	for i = 1, #guidtable do
		local unit = guidtable[i]
		if FilterFunc(unit) then
			tinsert(GetSortTable, unit)
		end
	end
	sort(GetSortTable, ValueFunc)
	return unpack(GetSortTable)
end
----------------------------------------------------------------------------------

--[[在目标group数组中过滤条件 FilterFunc,获取 ValueFunc 值最小的目标并返回ValueFunc值
msGetMin(group,FilterFunc,ValueFunc)
group		目标群表,默认小队/团队
FilterFunc	条件函数function,如可以被我攻击的:function(unit) return UnitCanAttack("player",unit) end
ValueFunc	对比函数function,如对比距离:function(unit) return msGD(unit) end 或对比血量:function(unit) return msGHP(unit) end

例如:找出参数1条件为(身边可以攻击的),参数2为(距离)我最小的目标
local GUnits = msGetUnits(nil,nil)
local Unit = msGetSort(GUnits,function(unit)
		return UnitCanAttack("player",unit)
	end,
	function(unit)
		return msGD(unit)
	end)
例如:找到身边40码内友善的玩家,他们中血量最小的那个
local GUnits = msGetUnits(true,true)--获取友善的玩家
local Unit = msGetSort(GUnits,function(unit) return msGFD(unit)<=40 end,function(unit) return msGHP(unit) end)

]]
----------------------------------------------------------------------------------
function msGetMin(group, FilterFunc, ValueFunc)
	if type(FilterFunc) ~= "function" then
		FilterFunc = function(unit)
			return UnitIsVisible(unit) and UnitInPhase(unit)
		end
	end
	if type(ValueFunc) ~= "function" then
		ValueFunc = msGHP
	end
	local guidtable = {}
	if type(group) ~= "table" then
		guidtable = GuidTable
	elseif type(group) == "table" and #group > 0 then
		guidtable = group
	else
		return false, group, "无目标。"
	end
	local number, result
	for i = 1, #guidtable do
		local unit = guidtable[i]
		if FilterFunc(unit) then
			local value = ValueFunc(unit)
			if not number then
				number = value
				result = unit
			end
			if value < number then
				number = value
				result = unit
			end
		end
	end
	return result, number
end
----------------------------------------------------------------------------------

--在目标group数组中过滤条件 FilterFunc,获取 ValueFunc 值最大的目标并返回ValueFunc值
----------------------------------------------------------------------------------
function msGetMax(group, FilterFunc, ValueFunc)
	if type(FilterFunc) ~= "function" then
		FilterFunc = function(unit)
			return UnitIsVisible(unit) and UnitInPhase(unit)
		end
	end
	if type(ValueFunc) ~= "function" then
		ValueFunc = msGHP
	end
	local guidtable = {}
	if type(group) ~= "table" then
		guidtable = GuidTable
	elseif type(group) == "table" and #group > 0 then
		guidtable = group
	else
		return false, group, "无目标。"
	end
	local number, result
	for i = 1, #guidtable do
		local unit = guidtable[i]
		if FilterFunc(unit) then
			local value = ValueFunc(unit)
			if not number then
				number = value
				result = unit
			end
			if value > number then
				number = value
				result = unit
			end
		end
	end
	return result, number
end
----------------------------------------------------------------------------------

--在目标group数组中寻找符合条件condition的目标（组）
----------------------------------------------------------------------------------
function msFindUnit(group, FilterFunc)
	if type(FilterFunc) ~= "function" then
		FilterFunc = function(unit)
			return UnitIsVisible(unit) and UnitInPhase(unit)
		end
	end
	local guidtable = {}
	if type(group) ~= "table" then
		guidtable = GuidTable
	elseif type(group) == "table" and #group > 0 then
		guidtable = group
	else
		return false, group, "无目标。"
	end
	local FindUnitTable, Unit = {}
	for i = 1, #guidtable do
		local FindUnit = guidtable[i]
		if FilterFunc(FindUnit) then
			Unit = FindUnit
			tinsert(FindUnitTable, FindUnit)
		end
	end
	return Unit, FindUnitTable
end
----------------------------------------------------------------------------------

--在目标guidtable数组中寻找最密集的目标(密集程度scale码,默认10码),返回值1为中心目标，返回值2为技能影响数量
----------------------------------------------------------------------------------
function msFGC(scale, guidtable)
	if not scale or type(scale) ~= "number" then
		scale = 10
	end
	if not guidtable or type(guidtable) ~= "table" or #guidtable == 0 then
		return false, 0, "目标不存在。"
	end
	local Node, Unit = 0
	for _, Target in ipairs(guidtable) do
		local Neighbors = 0
		for _, Neighbor in ipairs(guidtable) do
			if msGD(Target, Neighbor) <= scale then
				Neighbors = Neighbors + 1
			end
		end
		if Neighbors >= Node and Neighbors > 0 then
			Node = Neighbors
			Unit = Target
		end
	end
	return Unit, Node
end
----------------------------------------------------------------------------------

--判断目标unit的是否正在读spells法术中的任何一个[，并且可打断性为interruptable]
----------------------------------------------------------------------------------
function msICS(unit, spells, interrupt)
	if type(unit) ~= "string" then
		unit = "target"
	end
	if not UnitIsVisible(unit) then
		return false, "目标不存在", unit
	end
	if type(spells) ~= "string" then
		spells = "*"
	else
		spells = strtrim(spells)
	end
	if type(interrupt) ~= "boolean" then
		interrupt = nil
	end
	--local spell1, _, _, _, starttime1, endtime1, _, _, interrupt1 = UnitCastingInfo(unit) --不可以打断返回true,可以打断返回false
	local spell1, text1, texture1, starttime1, endtime1, isTradeSkill, castID, interrupt1, spellId1 = UnitCastingInfo(unit)
	--local spell2, _, _, _, starttime2, endtime2, _, interrupt2 = UnitChannelInfo(unit)
	local spell2, text2, texture2, starttime2, endtime2, isTradeSkill, interrupt2 = UnitChannelInfo(unit)
	if spell1 then
		if interrupt == interrupt1 then
			return false, "目标正在施放一个技能，但其可打断性不是", interrupt
		end
		if spells == "*" then
			return true, 1, spell1, (endtime1 - starttime1) / 1000, endtime1 / 1000 - GetTime(), GetTime() - starttime1 / 1000
		else
			spells = {strsplit(",", spells)}
			for i = 1, #spells do
				if spell1 == spells[i] then
					return true, 1, spell1, (endtime1 - starttime1) / 1000, endtime1 / 1000 - GetTime(), GetTime() - starttime1 / 1000
				end
			end
		end
		return false, "目标没有正在施放指定读条技能。", unit
	elseif spell2 then
		if interrupt == interrupt2 then
			return false, "目标正在施放一个技能，但其可打断性不是", unit, interrupt
		end
		if spells == "*" then
			return true, 2, spell2, (endtime2 - starttime2) / 1000, endtime2 / 1000 - GetTime(), GetTime() - starttime2 / 1000
		else
			spells = {strsplit(",", spells)}
			for i = 1, #spells do
				if spell2 == spells[i] then
					return true, 2, spell2, (endtime2 - starttime2) / 1000, endtime2 / 1000 - GetTime(), GetTime() - starttime2 / 1000
				end
			end
		end
		return false, "目标没有正在施放指定读条技能。", unit
	else
		return false, "目标没有正在施放任何读条技能。", unit
	end
end
----------------------------------------------------------------------------------

--获取目标读条技能的剩余时间及经历时间,msGCST("player")
----------------------------------------------------------------------------------
function msGCST(unit)
	if type(unit) ~= "string" then
		unit = "target"
	end
	if not UnitIsVisible(unit) then
		return -1, -1, "目标不存在", unit
	end
	local spell1, _, _, _, starttime1, endtime1 = UnitCastingInfo(unit)
	local spell2, _, _, _, starttime2, endtime2 = UnitChannelInfo(unit)
	if spell1 then
		return endtime1 / 1000 - GetTime(), GetTime() - starttime1 / 1000
	elseif spell2 then
		return endtime2 / 1000 - GetTime(), GetTime() - starttime2 / 1000
	end
	return -1, -1, "目标没有正在施放任何读条技能。", unit
end
----------------------------------------------------------------------------------

--判断unit2是否正在面向目标unit1
----------------------------------------------------------------------------------
function msIF(unit1, unit2, delta)
	if type(unit1) ~= "string" then
		unit1 = "target"
	end
	if not UnitIsVisible(unit1) then
		return false, "目标不存在:", unit1
	end
	if type(unit2) ~= "string" then
		unit2 = "player"
	end
	if not UnitIsVisible(unit2) then
		return false, "目标不存在:", unit2
	end
	if UnitIsUnit(unit1, unit2) then
		return true, "目标相同。"
	end
	if (type(delta) ~= "number") then
		delta = pi / 2
	end
	local x1, y1, _, r1 = msGUL(unit2)
	local x2, y2 = msGUL(unit1)
	if x1 and x2 then
		local guage = atan((y2 - y1) / (x2 - x1))
		if (guage < 0) then
			guage = guage + pi
		end
		if (y2 < y1) then
			guage = guage + pi
		end
		local curdelta = abs(r1 - guage)
		if (curdelta < pi) then
			return curdelta <= delta
		else
			return pi * 2 - curdelta <= delta
		end
	else
		return false, "找不到目标的位置坐标。"
	end
end
----------------------------------------------------------------------------------

--判断unit2是否正在面向目标unit1的背后
----------------------------------------------------------------------------------
function msIFB(unit1, unit2)
	if type(unit1) ~= "string" then
		unit1 = "target"
	end
	if not UnitIsVisible(unit1) then
		return false, "目标不存在:", unit1
	end
	if type(unit2) ~= "string" then
		unit2 = "player"
	end
	if not UnitIsVisible(unit2) then
		return false, "目标不存在:", unit2
	end
	local x, y, _, r = msGUL(unit2)
	local x0, y0, _, r0 = msGUL(unit1)
	if x and x0 then
		local liney = (x0 - x) / tan(r0) + y0
		local flag1
		if (r0 >= 0 and r0 < pi) then
			flag1 = (y <= liney)
		else
			flag1 = (y >= liney)
		end
		local flag2 = (abs(r - r0) <= pi * 0.5 or abs(r - r0) >= pi * 1.5)
		return flag1 and flag2 and msIF(unit1, unit2)
	else
		return false, "找不到目标的位置坐标。", unit1
	end
end
----------------------------------------------------------------------------------

--判断指定目标是否在视野中
----------------------------------------------------------------------------------
function msII(unit1, unit2)
	if type(unit1) ~= "table" and type(unit1) ~= "string" then
		unit1 = "target"
	end
	if type(unit2) ~= "table" and type(unit2) ~= "string" then
		unit2 = "player"
	end
	if type(unit1) ~= "table" and (not UnitIsVisible(unit1) or not UnitInPhase(unit1)) then
		return false, "目标或坐标无效:", unit1
	end
	if type(unit2) ~= "table" and (not UnitIsVisible(unit2) or not UnitInPhase(unit2)) then
		return false, "目标或坐标无效:", unit2
	end
	local x1, y1, z1, x2, y2, z2
	local h1, h2 = 0, 0
	if type(unit1) == "string" then
		--h1 = UnitHeight(unit1)
		x1, y1, z1 = ObjectPosition(unit1)
	elseif type(unit1) == "table" then
		x1, y1, z1 = unit1[1], unit1[2], unit1[3]
	end
	if type(unit2) == "string" then
		--	h2 = UnitHeight(unit2)
		x2, y2, z2 = ObjectPosition(unit2)
	elseif type(unit2) == "table" then
		x2, y2, z2 = unit2[1], unit2[2], unit2[3]
	end
	if type(x1) ~= "number" or type(y1) ~= "number" or type(z1) ~= "number" then
		return false, "目标或坐标无效"
	end
	if type(x2) ~= "number" or type(y2) ~= "number" or type(z2) ~= "number" then
		return false, "目标或坐标无效"
	end
	local losFlags = bit.bor(0x10, 0x100, 0x1)
	if TraceLine(x1, y1, z1 + h1, x2, y2, z2 + h2, losFlags) then
		return false
	else
		return true
	end
	-- if UnitGUID(unit2)==UnitGUID("player") and not UnitIsPlayer(unit1) and z1 < z2 then
	-- z1 = z2;
	-- end
	-- z1 = z1 + 2.25;
	-- z2 = z2 + 2.25;
	-- M2Collision = 0x1,
	-- M2Render = 0x2,
	-- WMOCollision = 0x10,
	-- WMORender = 0x20,
	-- Terrain = 0x100,
	-- WaterWalkableLiquid = 0x10000,
	-- Liquid = 0x20000,
	-- EntityCollision = 0x100000,
	-- bit.bor(0x10, 0x20) bitbor
	-- if TraceLine(x1, y1, z1, x2, y2, z2, 0x10) or TraceLine(x1, y1, z1, x2, y2, z2, 0x100) then
	-- return false;
	-- else
	-- return true;
	-- end
	--bit.bor(0x10, 0x100)
end
----------------------------------------------------------------------------------

--判断unit是否正在移动
----------------------------------------------------------------------------------
function msIM(unit)
	if (type(unit) ~= "string") then
		unit = "player"
	end
	return GetUnitSpeed(unit) > 0
end
----------------------------------------------------------------------------------

--判断指定玩家是否正在自动攻击
----------------------------------------------------------------------------------
local IsAutoAttacking = false
local StartAutoAttackingEvent = CreateFrame("Frame")
StartAutoAttackingEvent:RegisterEvent("PLAYER_ENTER_COMBAT")
StartAutoAttackingEvent:RegisterEvent("PLAYER_LEAVE_COMBAT")
StartAutoAttackingEvent:SetScript(
	"OnEvent",
	function(self, event)
		if event == "PLAYER_ENTER_COMBAT" then
			IsAutoAttacking = true
		end
		if event == "PLAYER_LEAVE_COMBAT" then
			IsAutoAttacking = false
		end
	end
)
function msIAA()
	return IsAutoAttacking
end
----------------------------------------------------------------------------------

--获取目标unit的生命值百分比
----------------------------------------------------------------------------------
function msGHP(unit)
	if type(unit) ~= "string" then
		unit = "player"
	end
	if not UnitIsVisible(unit) then
		return -1, "目标不存在", unit
	end
	return tonumber(format("%.1f", UnitHealth(unit) / UnitHealthMax(unit) * 100))
	-- local health = UnitHealth(unit);
	-- local healthmax = UnitHealthMax(unit);
	-- if type(health) == "number" and type(healthmax) == "number" and healthmax > 0 then
	-- local nNum = tonumber(format("%.1f",health / healthmax * 100))
	-- return nNum;
	-- else
	-- return -1, "目标没有生命值", unit;
	-- end
end
----------------------------------------------------------------------------------

--获取目标unit的能量值百分比
----------------------------------------------------------------------------------
function msGPP(unit)
	if type(unit) ~= "string" then
		unit = "player"
	end
	if not UnitIsVisible(unit) then
		return -1, "目标不存在", unit
	end
	local power = UnitPower(unit)
	local powermax = UnitPowerMax(unit)
	if type(power) == "number" and type(powermax) == "number" and powermax > 0 then
		local nNum = tonumber(format("%.1f", power / powermax * 100))
		return nNum
	else
		return -1, "目标没有能量值", unit
	end
end
----------------------------------------------------------------------------------

--获取指定目标unit拥有指定buffs的总数量
----------------------------------------------------------------------------------
function msGUBS(buffs, unit, harmful)
	if type(buffs) ~= "string" and type(buffs) ~= "table" and type(buffs) ~= "number" then
		return false, "BUFF参数错误", buffs
	elseif type(buffs) ~= "table" then
		buffs = {strsplit(",", buffs)}
	end
	if type(unit) ~= "string" then
		unit = "player"
	end
	if not UnitIsVisible(unit) then
		return 0, "目标不存在", unit
	end
	if harmful then
		UnitDebuffORbuff = UnitDebuff
	else
		UnitDebuffORbuff = UnitBuff
	end
	local Sum = 0
	for j = 1, #buffs do
		local i = 1
		local Name, _, _, _, _, _, _, _, _, Id = UnitDebuffORbuff(unit, i)
		buffId = buffs[j]
		while Name do
			i = i + 1
			if (buffId == strtrim(Id) or buffId == Name) then
				Sum = Sum + 1
			end
			Name, _, _, _, _, _, _, _, _, Id = UnitDebuffORbuff(unit, i)
		end
	end
	return Sum
end
----------------------------------------------------------------------------------

--判断目标unit是否有指定buffs
----------------------------------------------------------------------------------
function msGUB(buffs, unit, Caster, harmful)
	if type(buffs) ~= "string" and type(buffs) ~= "number" then
		return false, "BUFF参数错误", buffs
	elseif type(buffs) ~= "table" then
		buffs = {strsplit(",", buffs)}
	end
	if type(unit) ~= "string" then
		unit = "player"
	end
	if not UnitIsVisible(unit) then
		return false, "目标不存在", unit
	end
	if type(harmful) ~= "boolean" then
		harmful = nil
	end
	for j = 1, #buffs do
		local b, d = 1, 1
		local name1,
			icon1,
			count1,
			debuffType1,
			duration1,
			expirationTime1,
			unitCaster1,
			isStealable1,
			nameplateShowPersonal1,
			spellId1,
			canApplyAura1,
			isBossDebuff2,
			nameplateShowAll2,
			timeMod2 = UnitBuff(unit, b)
		local name2,
			icon2,
			count2,
			debuffType2,
			duration2,
			expirationTime2,
			unitCaster2,
			isStealable2,
			nameplateShowPersonal2,
			spellId2,
			canApplyAura2,
			isBossDebuff2,
			nameplateShowAll2,
			timeMod2 = UnitDebuff(unit, d)
		buffId = buffs[j]
		while name1 do
			b = b + 1
			if
				(buffId == strtrim(spellId1) or buffId == name1) and
					(not UnitIsVisible(Caster) or UnitIsVisible(unitCaster1) and UnitIsUnit(Caster, unitCaster1)) and
					harmful ~= true
			 then
				return true, name1
			end
			name1,
				icon1,
				count1,
				debuffType1,
				duration1,
				expirationTime1,
				unitCaster1,
				isStealable1,
				nameplateShowPersonal1,
				spellId1,
				canApplyAura1,
				isBossDebuff2,
				nameplateShowAll2,
				timeMod2 = UnitBuff(unit, b)
		end
		while name2 do
			d = d + 1
			if
				(buffId == strtrim(spellId2) or buffId == name2) and
					(not UnitIsVisible(Caster) or UnitIsVisible(unitCaster2) and UnitIsUnit(Caster, unitCaster2)) and
					harmful ~= false
			 then
				return true, name2
			end
			name2,
				icon2,
				count2,
				debuffType2,
				duration2,
				expirationTime2,
				unitCaster2,
				isStealable2,
				nameplateShowPersonal2,
				spellId2,
				canApplyAura2,
				isBossDebuff2,
				nameplateShowAll2,
				timeMod2 = UnitDebuff(unit, d)
		end
	end
	return false
end
----------------------------------------------------------------------------------

--获取目标unit指定buff的剩余时间
----------------------------------------------------------------------------------
function msGBT(buff, unit, Caster, harmful)
	if type(buff) ~= "string" and type(buff) ~= "number" then
		return -1, "BUFF参数错误", buff
	end
	if type(unit) ~= "string" then
		unit = "player"
	end
	if not UnitIsVisible(unit) then
		return -1, "目标不存在", unit
	end
	if type(harmful) ~= "boolean" then
		harmful = nil
	end
	local b, d = 1, 1
	local name1,
		icon1,
		count1,
		debuffType1,
		duration1,
		Expiration1,
		Source1,
		isStealable1,
		nameplateShowPersonal1,
		Id1,
		canApplyAura1,
		isBossDebuff2,
		nameplateShowAll2,
		timeMod2 = UnitBuff(unit, b)
	local name2,
		icon2,
		count2,
		debuffType2,
		duration2,
		Expiration2,
		Source2,
		isStealable2,
		nameplateShowPersonal2,
		Id2,
		canApplyAura2,
		isBossDebuff2,
		nameplateShowAll2,
		timeMod2 = UnitDebuff(unit, d)
	while name1 do
		b = b + 1
		if
			(buff == name1 or buff == Id1) and
				(not UnitIsVisible(Caster) or UnitIsVisible(Source1) and UnitIsUnit(Caster, Source1)) and
				harmful ~= true
		 then
			if Expiration1 == 0 then
				return 1, name1
			end
			return Expiration1 - GetTime(), name1
		end
		name1,
			icon1,
			count1,
			debuffType1,
			duration1,
			Expiration1,
			Source1,
			isStealable1,
			nameplateShowPersonal1,
			Id1,
			canApplyAura1,
			isBossDebuff2,
			nameplateShowAll2,
			timeMod2 = UnitBuff(unit, b)
	end
	while name2 do
		d = d + 1
		if
			(buff == name2 or buff == Id2) and
				(not UnitIsVisible(Caster) or UnitIsVisible(Source2) and UnitIsUnit(Caster, Source2)) and
				harmful ~= false
		 then
			if Expiration2 == 0 then
				return 1, name2
			end
			return Expiration2 - GetTime(), name2
		end
		name2,
			icon2,
			count2,
			debuffType2,
			duration2,
			Expiration2,
			Source2,
			isStealable2,
			nameplateShowPersonal2,
			Id2,
			canApplyAura2,
			isBossDebuff2,
			nameplateShowAll2,
			timeMod2 = UnitDebuff(unit, d)
	end
	return -1
end
----------------------------------------------------------------------------------

--获取目标unit指定buff中的剩余时间最多的那个buff的剩余时间
----------------------------------------------------------------------------------
function msGBTM(buffs, unit, Caster, harmful)
	if type(buffs) ~= "string" and type(buffs) ~= "number" then
		return false, "BUFF参数错误", buffs
	elseif type(buffs) ~= "table" then
		buffs = {strsplit(",", buffs)}
	end
	if type(unit) ~= "string" then
		unit = "player"
	end
	if not UnitIsVisible(unit) then
		return -1, "目标不存在", unit
	end
	if type(harmful) ~= "boolean" then
		harmful = nil
	end
	local b, d, ExTime, ExBuff = 1, 1, 0
	local Name1, _, _, _, _, Expiration1, Source1, _, _, Id1 = UnitBuff(unit, b)
	local Name2, _, _, _, _, Expiration2, Source2, _, _, Id2 = UnitDebuff(unit, d)
	while Name1 do
		b = b + 1
		if
			(tContains(buffs, Name1) or tContains(buffs, strtrim(Id1))) and
				(not UnitIsVisible(Caster) or UnitIsVisible(Source1) and UnitIsUnit(Caster, Source1)) and
				harmful ~= true
		 then
			local ReTime = Expiration1 - GetTime()
			if ReTime > ExTime then
				ExTime = ReTime
				ExBuff = Name1
			end
		end
		Name1, _, _, _, _, Expiration1, Source1, _, _, Id1 = UnitBuff(unit, b)
	end
	while Name2 do
		d = d + 1
		if
			(tContains(buffs, Name2) or tContains(buffs, strtrim(Id2))) and
				(not UnitIsVisible(Caster) or UnitIsVisible(Source2) and UnitIsUnit(Caster, Source2)) and
				harmful ~= false
		 then
			local ReTime = Expiration2 - GetTime()
			if ReTime > ExTime then
				ExTime = ReTime
				ExBuff = Name2
			end
		end
		Name2, _, _, _, _, Expiration2, Source2, _, _, Id2 = UnitDebuff(unit, d)
	end
	return ExTime, ExBuff
end
----------------------------------------------------------------------------------

--获取目标unit指定buff的层数
----------------------------------------------------------------------------------
function msGBC(buff, unit, Caster, harmful)
	if type(buff) ~= "string" and type(buff) ~= "number" then
		return -1, "BUFF参数错误", buff
	end
	if type(unit) ~= "string" then
		unit = "player"
	end
	if not UnitIsVisible(unit) then
		return -1, "目标不存在", unit
	end
	if type(harmful) ~= "boolean" then
		harmful = nil
	end
	local b, d = 1, 1
	local Name1, _, Count1, _, _, _, Source1, _, _, Id1 = UnitBuff(unit, b)
	local Name2, _, Count2, _, _, _, Source2, _, _, Id2 = UnitDebuff(unit, d)
	while Name1 do
		b = b + 1
		if
			(buff == Name1 or buff == Id1) and
				(not UnitIsVisible(Caster) or UnitIsVisible(Source1) and UnitIsUnit(Caster, Source1)) and
				harmful ~= true
		 then
			if Count1 < 1 then
				return 1, Name1
			else
				return Count1, Name1
			end
		end
		Name1, _, Count1, _, _, _, Source1, _, _, Id1 = UnitBuff(unit, b)
	end
	while Name2 do
		d = d + 1
		if
			(buff == Name2 or buff == Id2) and
				(not UnitIsVisible(Caster) or UnitIsVisible(Source2) and UnitIsUnit(Caster, Source2)) and
				harmful ~= false
		 then
			if Count2 < 1 then
				return 1, Name2
			else
				return Count2, Name2
			end
		end
		Name2, _, Count2, _, _, _, Source2, _, _, Id2 = UnitDebuff(unit, d)
	end
	return 0
end ----------------------------------------------------------------------------------
--
----------------------------------------------------------------------------------

--获取unit指定buff类型的数量.
--[[
参数(可以多个以逗号,分隔):buffTypes
Curse	诅咒
Disease	疾病
Magic	魔法
Poison	毒药

参数:harmful
true	有害
false	有益(默认)
]] function msGBS(
	buffTypes,
	unit,
	harmful)
	if type(buffTypes) ~= "string" and type(buffTypes) ~= "table" then
		return false, "BUFF类型参数错误", buffTypes
	end
	if type(buffTypes) == "string" then
		buffTypes = {strsplit(",", buffTypes)}
	end
	if type(unit) ~= "string" then
		unit = "player"
	end
	if not UnitIsVisible(unit) then
		return 0, "目标不存在", unit
	end
	local UnitDebuffORbuff
	if harmful then
		UnitDebuffORbuff = UnitDebuff
	else
		UnitDebuffORbuff = UnitBuff
	end
	local i, number = 1, 0
	local name, _, _, dispelType = UnitDebuffORbuff(unit, i)
	while name do
		i = i + 1
		for j = 1, #buffTypes do
			if buffTypes[j] == dispelType then
				number = number + 1
			end
		end
		name, _, _, dispelType = UnitDebuffORbuff(unit, i)
	end
	return number
end
----------------------------------------------------------------------------------

----------------------------------------------------------------------------------
--通过鼠标提示读取描述
---------------------------------------------------------------------------------
local Tooltip
local LoadGameTooltip = CreateFrame("Frame")
LoadGameTooltip:RegisterAllEvents()
LoadGameTooltip:SetScript(
	"OnEvent",
	function()
		--self, event, ...
		if GameTooltip then
			LoadGameTooltip:UnregisterAllEvents()
			Tooltip = CreateFrame("GameTooltip", "MagicDataTooltip", UIParent, "GameTooltipTemplate")
		end
	end
)
function GetBuffDesc(unit, index)
	if (type(unit) ~= "string" or type(index) ~= "number") then
		return nil
	end
	local buffName = UnitBuff(unit, index)
	if (type(buffName) ~= "string" or buffName == "") then
		return nil
	end
	Tooltip:ClearLines()
	Tooltip:SetOwner(UIParent, "ANCHOR_NONE")
	Tooltip:SetUnitBuff(unit, index)
	local i = 1
	local result = ""
	local textobject = getglobal("MagicDataTooltipTextLeft1")
	while (textobject) do
		local text = textobject:GetText()
		if (type(text) == "string" and text ~= buffName) then
			result = result .. text
			if (strtrim(text) ~= "") then
				result = result .. "\n"
			end
		end
		i = i + 1
		textobject = getglobal("MagicDataTooltipTextLeft" .. i)
	end
	return strtrim(result)
end
function GetDebuffDesc(unit, index)
	if (type(unit) ~= "string" or type(index) ~= "number") then
		return nil
	end
	local buffName = UnitDebuff(unit, index)
	if (type(buffName) ~= "string" or buffName == "") then
		return nil
	end
	Tooltip:ClearLines()
	Tooltip:SetOwner(UIParent, "ANCHOR_NONE")
	Tooltip:SetUnitDebuff(unit, index)
	local i = 1
	local result = ""
	local textobject = getglobal("MagicDataTooltipTextLeft1")
	while (textobject) do
		local text = textobject:GetText()
		if (type(text) == "string" and text ~= buffName) then
			result = result .. text
			if (strtrim(text) ~= "") then
				result = result .. "\n"
			end
		end
		i = i + 1
		textobject = getglobal("MagicDataTooltipTextLeft" .. i)
	end
	return strtrim(result)
end
---------------------------------------------------------------------------------

--获取目标unit指定buff的描述	--msGBB(158300)	UnitBuff("player",158300)
----------------------------------------------------------------------------------
function msGBB(buff, unit)
	if type(buff) ~= "string" and type(buff) ~= "number" then
		return nil, "msGBB(buff, unit):buff参数错误"
	end
	if type(unit) ~= "string" then
		unit = "player"
	end
	if not UnitIsVisible(unit) then
		return nil, "目标不存在", unit
	end
	for i = 1, 40 do
		local curName1, _, _, _, _, _, _, _, _, curId1 = UnitBuff(unit, i)
		local curName2, _, _, _, _, _, _, _, _, curId2 = UnitDebuff(unit, i)
		if curId1 and buff == tonumber(curId1) or buff == curName1 then
			return GetBuffDesc(unit, i)
		end
		if curId2 and buff == tonumber(curId2) or buff == curName2 then
			return GetDebuffDesc(unit, i)
		end
	end
end
----------------------------------------------------------------------------------

--获取buff描述里的数字信息,buff支持中文及数字ID
---------------------------------------------------------------------------------
function msGBN(buff, unit)
	unit = unit or "target"
	local text = msGBB(buff, unit)
	local v = {}
	if text then
		while true do
			local j = strfind(text, "%d,%d")
			if not j then
				break
			end
			local firsthalf = strsub(text, 1, j)
			local lasthalf = strsub(text, j + 2, #text)
			text = firsthalf .. lasthalf
		end
		while true do
			local j = strfind(text, "%d%.%d")
			if not j then
				break
			end
			local firsthalf = strsub(text, 1, j)
			local lasthalf = strsub(text, j + 2, #text)
			text = firsthalf .. lasthalf
		end
		for k in gmatch(text, "%d+") do
			if tonumber(k) > 0 then
				tinsert(v, tonumber(k))
			end
		end
	end
	return unpack(v)
end
---------------------------------------------------------------------------------

--获取技能描述里的数字信息,spell支持中文及数字ID
---------------------------------------------------------------------------------
function msGSN(spell)
	local text = GetSpellDescription(spell)
	local v = {}
	local i = 1
	if text then
		while true do
			local j = strfind(text, "%d,%d")
			if not j then
				break
			end
			local firsthalf = strsub(text, 1, j)
			local lasthalf = strsub(text, j + 2, #text)
			text = firsthalf .. lasthalf
		end
		while true do
			local j = strfind(text, "%d%.%d")
			if not j then
				break
			end
			local firsthalf = strsub(text, 1, j)
			local lasthalf = strsub(text, j + 2, #text)
			text = firsthalf .. lasthalf
		end
		for k in gmatch(text, "%d+") do
			if tonumber(k) > 0 then
				tinsert(v, tonumber(k))
			end
		end
	end
	return unpack(v)
end
---------------------------------------------------------------------------------

--获取目标1（或坐标表1）与目标2（或坐标表2）之间的精确距离（码）
----------------------------------------------------------------------------------
function msGD(unit1, unit2)
	if type(unit1) ~= "table" and type(unit1) ~= "string" then
		unit1 = "target"
	end
	if type(unit2) ~= "table" and type(unit2) ~= "string" then
		unit2 = "player"
	end
	if UnitIsVisible(unit1) and UnitIsVisible(unit2) and UnitInPhase(unit1) and UnitInPhase(unit2) then
		return GetDistanceBetweenObjects(unit1, unit2)
	end
	local x1, y1, z1, x2, y2, z2
	if type(unit1) == "table" then
		x1, y1, z1 = unit1[1], unit1[2], unit1[3]
	end
	if type(unit2) == "table" then
		x2, y2, z2 = unit2[1], unit2[2], unit2[3]
	end
	if UnitIsVisible(unit1) and UnitInPhase(unit1) then
		x1, y1, z1 = ObjectPosition(unit1)
	end
	if UnitIsVisible(unit2) and UnitInPhase(unit2) then
		x2, y2, z2 = ObjectPosition(unit2)
	end
	if type(x1) ~= "number" or type(y1) ~= "number" or type(z1) ~= "number" then
		return 100, "目标或坐标无效"
	end
	if type(x2) ~= "number" or type(y2) ~= "number" or type(z2) ~= "number" then
		return 100, "目标或坐标无效"
	end
	--return sqrt(pow(x1 - x2, 2) + pow(y1 - y2, 2) + pow(z1 - z2, 2));
	return GetDistanceBetweenPositions(x1, y1, z1, x2, y2, z2)
end
----------------------------------------------------------------------------------

--获取目标与玩家之间的距离（码）范围,更加适用与目标体积更大的目标(如BOSS)
----------------------------------------------------------------------------------
function msGFD(unit)
	if type(unit) ~= "string" then
		unit = "target"
	end
	local _, MaxRange = LibStub("LibRangeCheck-2.0"):GetRange(unit)
	if MaxRange then
		return MaxRange
	else
		return 100
	end
end
----------------------------------------------------------------------------------

--判断目标是否距离玩家8码内,更加适用与目标体积更大的目标(如BOSS)
----------------------------------------------------------------------------------
function msIFD(unit)
	if type(unit) ~= "string" then
		unit = "target"
	end
	if
		UnitIsVisible(unit) and UnitInPhase(unit) and
			(CheckInteractDistance(unit, 2) or CheckInteractDistance(unit, 3) or CheckInteractDistance(unit, 5))
	 then
		return true
	else
		return false
	end
end
----------------------------------------------------------------------------------

--获取玩家的指定图腾的剩余时间(填写图腾中文全称名称)
--获取玩家的蘑菇剩余时间.index置空返回最快冷却的,否则反回指定位置的:1,2,3
--获取玩家的雕像的剩余时间
----------------------------------------------------------------------------------
function msGTT(index)
	local v1
	if (type(index) == "string") then
		for i = 1, 4 do
			local haveTotem, name, startTime, duration = GetTotemInfo(i)
			if haveTotem and index == name then
				local v = duration - (GetTime() - startTime)
				if v < 0 then
					v = 0
				end
				if not v1 then
					v1 = v
				end
				if v < v1 then
					v1 = v
				end
			end
		end
		return v1 or -1
	elseif (type(index) == "nil") then
		for i = 1, 4 do
			local haveTotem, _, startTime, duration = GetTotemInfo(i)
			if haveTotem then
				local v = duration - (GetTime() - startTime)
				if v < 0 then
					v = 0
				end
				if not v1 then
					v1 = v
				end
				if v < v1 then
					v1 = v
				end
			end
		end
		return v1 or -1
	elseif (type(index) == "number") then
		local haveTotem, _, startTime, duration = GetTotemInfo(index)
		if not haveTotem then
			return 9999
		end
		local cd = duration - (GetTime() - startTime)
		if cd < 0 then
			cd = 0
		end
		return cd
	end
end
----------------------------------------------------------------------------------

--获取玩家蘑菇的数量
----------------------------------------------------------------------------------
function msGMT()
	local v1 = 0
	for i = 1, 4 do
		if GetTotemInfo(i) then
			v1 = v1 + 1
		end
	end
	return v1
end
----------------------------------------------------------------------------------

--判断TellMeWhen插件指定图标是否显示	参数groupN:分组;参数iconN:图标	返回:是否显示,目标,法术,层数,剩余时间
----------------------------------------------------------------------------------
function msTMW(groupN, iconN)
	if not TMW then
		return false, "未加载TellMeWhen插件,请自行下载安装"
	end
	local tmw = _G["TellMeWhen_Group" .. tostring(groupN) .. "_Icon" .. tostring(iconN)]
	--print(_G["TellMeWhen_Group"..tostring(groupN).."_Icon"..tostring(iconN)])
	if tmw then
		local shown = tmw.attributes.shown and tmw.attributes.alpha ~= 0 and tmw.attributes.realAlpha ~= 0
		local unit = tmw.attributes.unit
		local spell = tmw.attributes.spell
		local stack = tmw.attributes.stack
		local start, duration = tmw.attributes.start, tmw.attributes.duration
		return shown, unit, spell, stack, (duration + start - GetTime())
	else
		return false, "参数错误"
	end
end
----------------------------------------------------------------------------------

--返回符文最快的冷却时间
----------------------------------------------------------------------------------
function msGRC()
	local Cooldown
	local start, duration, cd
	for i = 1, 6 do
		start, duration = GetRuneCooldown(i)
		if start > 0 then
			cd = duration - (GetTime() - start)
			if not Cooldown then
				Cooldown = duration
			end
			if cd <= Cooldown and cd > 0 then
				Cooldown = cd
			end
		end
	end
	return Cooldown or 0
end
----------------------------------------------------------------------------------

--返回可用的符文数量
----------------------------------------------------------------------------------
function msGRN()
	local Cooldown = 0
	for i = 1, 6 do
		Cooldown = Cooldown + GetRuneCount(i)
	end
	return Cooldown
end
----------------------------------------------------------------------------------

--返回主手和副手武器附魔信息(1-主手;2-副手)
----------------------------------------------------------------------------------
function msGetWEI(n)
	local a1, b1, c1, d1, a2, b2, c2, d2 = GetWeaponEnchantInfo()
	if n == 1 and a1 then
		return b1 / 1000, a1, c1, d1
	elseif n == 2 and a2 then
		return b2 / 1000, a1, c2, d2
	end
	return -1
end
----------------------------------------------------------------------------------

--是否启用了指定天赋(参数直接填写中文天赋名称)
----------------------------------------------------------------------------------
function msIT(Nameid)
	-- local ActiveSpecGroup = GetActiveSpecGroup();
	-- for Row = 1, 7 do
	-- for Column = 1, 3 do
	-- local _, name, _, selected, _, id = GetTalentInfo(Row,Column,ActiveSpecGroup)
	-- if Nameid == name or Nameid == id then
	-- return selected;
	-- end
	-- local _, namePvp, _, selectedPvp, _, idpvp = GetPvpTalentInfo(Row,Column,ActiveSpecGroup)
	-- if Nameid == namePvp or Nameid == idpvp then
	-- return selectedPvp;
	-- end
	-- end
	-- end
	-- return false
	return TalentSpell[Nameid]
end
---------------------------------------------------------------------------------

--获取技能或物品的冷却时间(spell格式参考msISC的spell)	61304
---------------------------------------------------------------------------------
function msGCD(spell)
	local spelltype, spellname, spellId = msGSI(spell)
	local starttime, duration = GetSpellCooldown(61304)
	if (spelltype == "SPELL") then
		starttime, duration = GetSpellCooldown(spellId)
	elseif (spelltype == "ITEM") then
		starttime, duration = GetItemCooldown(spellId)
	end
	if starttime and duration then
		if starttime == 0 then
			return 0
		else
			return starttime + duration - GetTime()
		end
	end
	return 10000
end
---------------------------------------------------------------------------------

--获取信息的总值,填写数字(1-强度;2-敏捷;3-耐力;4-智力;5-精神).默认判断自己
---------------------------------------------------------------------------------
function msGetUnitStat(statID, unit)
	if not unit then
		unit = "plaer"
	end
	local stat, effectiveStat, posBuff, negBuff = UnitStat(unit, statID)
	return stat + posBuff + negBuff
end
---------------------------------------------------------------------------------

--设置变量,变量名称:VariableName,变量内容:Value
---------------------------------------------------------------------------------
local VariableWarehouse = {}
function msSV(VariableName, Value)
	VariableWarehouse[VariableName] = Value
	return VariableWarehouse[VariableName]
end
---------------------------------------------------------------------------------

--读取变量,变量名称:VariableName
---------------------------------------------------------------------------------
function msGV(VariableName)
	if VariableName == nil then
		return nil
	end
	return VariableWarehouse[VariableName]
end
---------------------------------------------------------------------------------

--延时,延迟
---------------------------------------------------------------------------------
local NewTimer = {}
function msINT(TimeName, Time)
	if type(TimeName) ~= "string" or type(Time) ~= "number" then
		return false
	end
	local Gtime = NewTimer[TimeName]
	if Gtime and GetTime() - Gtime > Time then
		NewTimer[TimeName] = GetTime()
		return true
	elseif not Gtime then
		NewTimer[TimeName] = GetTime()
		return true
	end
	return false
end
---------------------------------------------------------------------------------

--获取特殊能量
---------------------------------------------------------------------------------
function msGPO()
	local _, englishClass = UnitClass("player")
	local ezj, zj = GetSpecializationInfo(GetSpecialization())

	if englishClass == "PALADIN" then
		return UnitPower("player", 9)
	elseif englishClass == "DRUID" then
		return UnitPower("player", 4)
	elseif englishClass == "WARLOCK" then
		return UnitPower("player", 7)
	elseif englishClass == "MONK" then
		return UnitPower("player", 12)
	elseif englishClass == "PRIEST" then
		return UnitPower("player", 13)
	end
	return -1
end
---------------------------------------------------------------------------------

--技能正在执行时按下鼠标左键
---------------------------------------------------------------------------------
function msICM(Spell)
	if IsCurrentSpell(Spell) then
		msMouse()
		--CancelAoeSpell();
		return true
	end
	return false
end
---------------------------------------------------------------------------------

--点击鼠标左键	IsCurrentSpell("英勇飞跃")判断技能是否点亮
---------------------------------------------------------------------------------
local msLastMouseAction = GetTime()
function msMouse()
	if (GetTime() - msLastMouseAction > 0.15) then
		msLastMouseAction = GetTime()
		local leftdown = IsMouseButtonDown(1)
		local Rightdown = IsMouseButtonDown(2)
		if leftdown and Rightdown then
			CameraOrSelectOrMoveStop()
			TurnOrActionStop()
			CameraOrSelectOrMoveStop()
			CameraOrSelectOrMoveStart()
			CameraOrSelectOrMoveStop()
			CameraOrSelectOrMoveStart()
			TurnOrActionStart()
		elseif leftdown and (not Rightdown) then
			CameraOrSelectOrMoveStop()
			CameraOrSelectOrMoveStart()
		elseif (not leftdown) and Rightdown then
			TurnOrActionStop()
			CameraOrSelectOrMoveStart()
			CameraOrSelectOrMoveStop()
			TurnOrActionStart()
		else
			CameraOrSelectOrMoveStart()
			CameraOrSelectOrMoveStop()
		end
	end
end
---------------------------------------------------------------------------------

--获取指定名称的DBM进度条的剩余时间
---------------------------------------------------------------------------------
function msDBM(barname)
	for bar in DBM.Bars:GetBarIterator() do
		local Name = _G[bar.frame:GetName() .. "BarName"]:GetText()
		if strfind(Name, barname) then
			return bar.timer
		end
		--print(_G[bar.frame:GetName().."BarName"]:GetText())
	end
	return 10000
end
---------------------------------------------------------------------------------

--判断是否在某姿态中,填数字,从动作条左到右
---------------------------------------------------------------------------------
function msIsStance(index)
	if index <= 0 then
		return false
	end
	local _, _, active = GetShapeshiftFormInfo(index)
	return active
end
---------------------------------------------------------------------------------

--判断目标是否指定职业,可以填写一个或多个中文名称.如:潜行者
---------------------------------------------------------------------------------
function msIC(Class, Unit)
	if type(Class) ~= "string" and type(Class) ~= "table" then
		return false
	elseif type(Class) ~= "table" then
		Class = strtrim(Class)
		Class = {strsplit(",", Class)}
	elseif type(Unit) ~= "string" then
		Unit = "target"
	end
	local playerClass, englishClass = UnitClass(Unit)
	for i = 1, #Class do
		if playerClass == Class[i] then
			return playerClass
		end
	end
	return false
end
---------------------------------------------------------------------------------

--判断自己是否失去控制
local eventIndex = C_LossOfControl.GetNumEvents
local GetEventInfo = C_LossOfControl.GetEventInfo
--[[
local LossOfControl = CreateFrame("Frame")
LossOfControl:RegisterEvent("LOSS_OF_CONTROL_ADDED");
-- LossOfControl:RegisterEvent("LOSS_OF_CONTROL_UPDATE");
-- LossOfControl:RegisterEvent("PLAYER_CONTROL_GAINED");
-- LossOfControl:RegisterEvent("PLAYER_CONTROL_LOST");
LossOfControl:SetScript("OnEvent", function(self,Event)
	--print(GetEventInfo(eventIndex()))
	local locType, spellID, text, iconTexture, startTime, timeRemaining, duration, lockoutSchool, priority, displayType = GetEventInfo(eventIndex())
	if locType and spellID and text and iconTexture and startTime and timeRemaining and duration and lockoutSchool and priority and displayType then
		WriteFile("D:\\World of Warcraft\\被控制数据.lua",locType .. "," .. spellID .. "," .. text .. "," .. iconTexture .. "," .. startTime .. "," .. timeRemaining .. "," .. duration .. "," .. lockoutSchool .. "," .. priority .. "," .. displayType .. "\n",true)
	end

end)
]]
---------------------------------------------------------------------------------
function msIPC(number)
	if not number then
		number = 5
	end
	local eventIndex = eventIndex()
	if eventIndex > 0 then
		local Eventarg = {GetEventInfo(eventIndex)}
		if Eventarg[1] == number or Eventarg[9] == number then
			return true
		end
	else
		return false
	end
end
---------------------------------------------------------------------------------

--自动打断敌对读条
---------------------------------------------------------------------------------
function msInterrupt(spell, casttime, spells, objType)
	if (type(spell) ~= "string") then
		ThrowError("msInterrupt(spell,casttime,spells,objType)", L["The parameters are invalid."])
		return nil
	end
	if (type(casttime) ~= "number") then
		casttime = 1
	end
	for i = 1, GetObjectCount() do
		local thisUnit = GetObjectWithIndex(i)
		if
			UnitIsVisible(thisUnit) and UnitCanAttack(thisUnit, "player") and msIII(thisUnit) and UnitAffectingCombat(thisUnit) and
				not UnitIsDeadOrGhost(thisUnit) and
				(not objType or UnitIsPlayer(thisUnit))
		 then
			local result, spellType, spellName, _, spellRemaining = msICS(thisUnit, "*", true)
			if result and not spells then
				if
					msISC(spell, thisUnit) and
						(spellType == 1 and spellRemaining < casttime or spellType == 2 and spellRemaining > casttime)
				 then
					msRun(spell, thisUnit, true)
				end
			elseif result and (type(spells) == "string") then
				spells = {strsplit(",", spells)}
				if
					tContains(spells, spellName) and msISC(spell, thisUnit) and
						(spellType == 1 and spellRemaining < casttime or spellType == 2 and spellRemaining > casttime)
				 then
					msRun(spell, thisUnit, true)
				end
			end
		end
	end
	return msGCD(spell)
end
---------------------------------------------------------------------------------

--Ovale全职业输出助手插件.参数填写数字,用第几个图标的技能
---------------------------------------------------------------------------------
function msOvale(number, unit)
	if not Ovale then
		print("|cffff0000Ovale全职业输出助手插件没有安装！")
	else
		local spellId = Ovale["frame"]["actions"][number]["spellId"]
		unit = unit or "target"
		if type(spellId) == "number" and not UnitIsDeadOrGhost(unit) and UnitChannelInfo("player") ~= GetSpellInfo(spellId) then
			if select(2, UnitClassBase("player")) == "HUNTER" and msISC("SPELL" .. spellId, unit, nil, true) then
				msRun("SPELL" .. spellId, unit)
				return true
			elseif msISC("SPELL" .. spellId, unit) then
				msRun("SPELL" .. spellId, unit)
				return true
			end
		else
			return false
		end
	end
end
---------------------------------------------------------------------------------

--Decursive插件一键驱散,参数填是否需要打断当前施法
---------------------------------------------------------------------------------
function msDecursive_EX(id)
	local Dcr = DecursiveRootTable["Dcr"]
	local unit = Dcr.Status.Unit_Array[id]
	local f = Dcr["MicroUnitF"]["UnitToMUF"][unit]
	if not f then
		return false
	end
	local IsDebuffed = f["IsDebuffed"]
	if IsDebuffed then
		local DebuffType = f["FirstDebuffType"]
		local Spell = Dcr.Status.CuringSpells[DebuffType]
		local IsCharmed = f["IsCharmed"]
		local Debuff1Prio = f["Debuff1Prio"]
		return unit, Spell, IsCharmed, Debuff1Prio
	end
end
function msDecursive(Break)
	if not DecursiveRootTable then
		print("|cffff0000需要安装Decursive插件才能使用msDecursive(Break)")
		return false
	end
	local n = DecursiveRootTable["Dcr"]["Status"]["UnitNum"]
	local i
	for i = 1, n do
		local unit, Spell, IsCharmed, Debuff1Prio = msDecursive_EX(i)
		if UnitIsVisible(unit) and UnitInPhase(unit) and Spell then
			if msISC(Spell, unit) then
				if Break then
					RunMacroText("/stopcasting")
					msRun(Spell, unit)
				else
					msRun(Spell, unit)
				end
				return true
			end
		end
	end
end
---------------------------------------------------------------------------------

--获取目标的治疗量,参数:目标,返回值:目标收到的过量治疗量,目标收到我的治疗量,目标收到所有人的治疗量
---------------------------------------------------------------------------------
function msGUH(unit)
	if UnitIsVisible(unit) then
		local Health = UnitHealth(unit)
		local HealthMax = UnitHealthMax(unit)
		local AllIncomingHeal = UnitGetIncomingHeals(unit)
		local MyIncomingHeal = UnitGetIncomingHeals(unit, "player")
		if type(MyIncomingHeal) == "number" and type(AllIncomingHeal) == "number" then
			local HealthExcess = Health + AllIncomingHeal - HealthMax
			return HealthExcess, MyIncomingHeal, AllIncomingHeal
		end
	end
	return -1, -1, -1
end
---------------------------------------------------------------------------------

--技能插入,	技能:Spell; 目标:Unit; 是否打断当前施法:Stop; 插入时间:Time;
---------------------------------------------------------------------------------
function msIS(Spell, Unit, Stop, Time)
	if (type(Time) ~= "number") then
		Time = 1.5 / (1 + GetMeleeHaste() / 100)
	end
	msSV("sv_msinspell_Spell", Spell)
	msSV("sv_msinspell_Unit", Unit)
	msSV("sv_msinspell_Stop", Stop)
	msSV("sv_msinspell_Time", GetTime() + Time)
	return true
end
---------------------------------------------------------------------------------

--调用技能插入
---------------------------------------------------------------------------------
function msRS()
	if msGV("sv_msinspell_Time") and GetTime() > msGV("sv_msinspell_Time") then
		msSV("sv_msinspell_Spell", nil)
		msSV("sv_msinspell_Unit", nil)
		msSV("sv_msinspell_Stop", nil)
		msSV("sv_msinspell_Time", nil)
		return false
	end
	local Spell = msGV("sv_msinspell_Spell")
	local Unit = msGV("sv_msinspell_Unit")
	local StopSPELL = msGV("sv_msinspell_Stop")
	if not Spell then
		return
	end
	if Spell and msISC(Spell, Unit) then
		if StopSPELL and SpellStopCasting() and SpellStopCasting() then
			msRun(Spell, Unit, true)
			msSV("sv_msinspell_Spell", nil)
			msSV("sv_msinspell_Unit", nil)
			msSV("sv_msinspell_Stop", nil)
			msSV("sv_msinspell_Time", nil)
			return true
		elseif not (UnitCastingInfo("player") or UnitChannelInfo("player")) then
			msRun(Spell, Unit, true)
			msSV("sv_msinspell_Spell", nil)
			msSV("sv_msinspell_Unit", nil)
			msSV("sv_msinspell_Stop", nil)
			msSV("sv_msinspell_Time", nil)
			return true
		end
	end
end
---------------------------------------------------------------------------------
local MagicStonehelper = MagicStonehelper
--技能插入
local UseAction_msInRun = UseAction
--[[UseAction = function(slot, ...)
	if not GetCursorInfo() then
		local actionType, id = GetActionInfo(slot)
		local starttime, duration = GetSpellCooldown(61304)
		if starttime > 0 then
			MagicStonehelper.InsertTime = starttime + duration
			if actionType == "spell" then
				MagicStonehelper.InsertSpell = GetSpellInfo(id)
			end
		end
	end
	securecall(UseAction_msInRun, slot)
end]]
--防止暂离
local SetHackEnabled_Original = SetHackEnabled
function SetHackEnabled(Name, Enable)
	if Name == "NoAutoAway" then
		MagicStonehelper.NoAutoAway = Enable
	end
	return SetHackEnabled_Original(Name, Enable)
end
function LoadedAutoAway()
	local NoAutoAway = MagicStonehelper.NoAutoAway
	if IsHackEnabled("NoAutoAway") ~= NoAutoAway then
		SetHackEnabled("NoAutoAway", NoAutoAway)
	end
end

---------------------------------------------------------------------------------
local Spell_Spell, Spell_Target, Last_Spell, Monk_SPELL
local GetSpellCast = {}
local CastSpellFrame = CreateFrame("Frame")
CastSpellFrame:RegisterEvent("UNIT_SPELLCAST_SENT") --技能释放开始
CastSpellFrame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED") --技能释放成功
CastSpellFrame:RegisterEvent("LOADING_SCREEN_ENABLED") --地图刷新
CastSpellFrame:SetScript(
	"OnEvent",
	function(self, event, ...)
		local Eventarg = {...}
		--上一个技能
		if event == "COMBAT_LOG_EVENT_UNFILTERED" then
			Eventarg = {CombatLogGetCurrentEventInfo()}
			if Eventarg[2] == "SPELL_CAST_SUCCESS" and Eventarg[4] == UnitGUID("player") then
				if (not IsPassiveSpell(Eventarg[12])) then
					Last_Spell = Eventarg[13]
				end
				if tContains({"猛虎掌", "幻灭踢", "旭日东升踢", "怒雷破", "风领主之击", "升龙霸", "神鹤引项踢", "真气波", "碎玉闪电", "轮回之触", "翔龙在天"}, Eventarg[13]) then
					Monk_SPELL = Eventarg[13]
				--print(Eventarg[13])
				end
			end
		end
		if event == "UNIT_SPELLCAST_SENT" and Eventarg[1] == "player" and Eventarg[2] then
			local name, _, _, castTime = GetSpellInfo(Eventarg[2])
			if name and castTime == 0 and not IsPassiveSpell(name) then
				Last_Spell = name
			end
		end
		if event == "UNIT_SPELLCAST_SENT" and Eventarg[1] == "player" and Eventarg[2] and Eventarg[4] then
			local name, _, _, castTime = GetSpellInfo(Eventarg[2])
			if name and castTime > 0 then
				Spell_Spell = Eventarg[2]
				Spell_Target = Eventarg[4] ~= "" and Eventarg[4] or "player"
			end
		end
		if event == "COMBAT_LOG_EVENT_UNFILTERED" and Eventarg[2] == "SPELL_CAST_SUCCESS" and Eventarg[4] and Eventarg[13] then
			GetSpellCast[Eventarg[4]] = GetSpellCast[Eventarg[4]] or {}
			GetSpellCast[Eventarg[4]][Eventarg[13]] = GetSpellCast[Eventarg[4]][Eventarg[13]] or {}
			GetSpellCast[Eventarg[4]][Eventarg[13]]["time"] = GetTime()
			GetSpellCast[Eventarg[4]][Eventarg[13]]["destGUID"] = Eventarg[8]
			GetSpellCast[Eventarg[4]][Eventarg[13]]["destName"] = Eventarg[9]
		--print(Eventarg[8]=="",Eventarg[8])
		end
		if event == "LOADING_SCREEN_ENABLED" then
			--print("LOADING_SCREEN_ENABLED")
			wipe(GetSpellCast)
		end
	end
)
---------------------------------------------------------------------------------

--获取玩家当前读条信息,返回当前读条的目标及目标的血量百分比,目标收到的过量治疗量,目标收到我的治疗量,目标收到所有人的治疗量
---------------------------------------------------------------------------------
function msGC()
	if
		Spell_Spell and Spell_Target and
			(Spell_Spell == UnitCastingInfo("player") or Spell_Spell == UnitChannelInfo("player"))
	 then
		local unit
		if UnitIsVisible(Spell_Target) then
			unit = Spell_Target
		elseif Spell_Target == GetUnitName("focus", true) then
			unit = "focus"
		elseif Spell_Target == GetUnitName("target", true) then
			unit = "target"
		elseif Spell_Target == GetUnitName("player", true) then
			unit = "mouseover"
		end
		if UnitIsVisible(unit) then
			return unit, msGHP(unit), msGUH(unit)
		end
	end
	return false, -1, -1, -1, -1
end
---------------------------------------------------------------------------------

--获取指定目标成功释放指定技能后经历的时间及该技能命中的目标
---------------------------------------------------------------------------------
function msGSCT(sourceGUID, spellName)
	local sourceGUID = UnitGUID(sourceGUID)
	if GetSpellCast[sourceGUID] and GetSpellCast[sourceGUID][spellName] then
		local destGUID = GetSpellCast[sourceGUID][spellName]["destGUID"]
		local destTime = GetSpellCast[sourceGUID][spellName]["time"]
		if destGUID and destGUID ~= "" then
			return GetTime() - GetSpellCast[sourceGUID][spellName]["time"], msGUG(destGUID)
		elseif type(destTime) == "number" then
			return GetTime() - destTime, GetSpellCast[sourceGUID][spellName]["destName"]
		end
	end
	return -1, false
end
---------------------------------------------------------------------------------

--获取自己施放上一个技能的名称
---------------------------------------------------------------------------------
function msGLS()
	if Last_Spell then
		return Last_Spell
	end
	return false
end
---------------------------------------------------------------------------------

--获取自己施放上一个技能的名称(武僧连击专用)
---------------------------------------------------------------------------------
function msGMS()
	if Monk_SPELL then
		return Monk_SPELL
	end
	return false
end
---------------------------------------------------------------------------------

--目标的目标是否自己
---------------------------------------------------------------------------------
function msIUT(unit)
	if type(unit) ~= "string" then
		unit = "target"
	end
	if not UnitIsVisible(unit) then
		return false, "目标不存在:", unit
	end
	return UnitTarget(unit) == ObjectPointer("player")
end
---------------------------------------------------------------------------------

--目标的目标是否队友
----------------------------------------------------------------------------------
function msIUP(unit)
	if type(unit) ~= "string" then
		unit = "target"
	end
	if not UnitIsVisible(unit) then
		return false, "目标不存在:", unit
	end
	local unitTarget = UnitTarget(unit)
	if unitTarget then
		return UnitInParty(unitTarget)
	end
	return false
end
----------------------------------------------------------------------------------

--获取目标的目标
---------------------------------------------------------------------------------
function msGUT(unit)
	if type(unit) ~= "string" then
		unit = "target"
	end
	if not UnitIsVisible(unit) then
		return false, "目标不存在:", unit
	end
	return UnitTarget(unit)
end
---------------------------------------------------------------------------------

--JJC内被集火的目标及集火数量
---------------------------------------------------------------------------------
function msGACA()
	local name = {}
	local Coun = 0
	local unittarget
	for i = 1, 3 do
		unit = GetUnitName("arena" .. i .. "-target")
		if unit then
			if name[unit] then
				name[unit] = name[unit] + 1
			else
				name[unit] = 1
			end
			if name[unit] > Coun then
				Coun = name[unit]
				unittarget = unit
			end
		end
	end
	return Coun, unittarget
end
---------------------------------------------------------------------------------

--能量恢复所需时间,Unit目标,MAX回复到的期望值(默认满能量)
---------------------------------------------------------------------------------
function msGTTM(Unit, MAX)
	if not UnitIsVisible(Unit) then
		Unit = "player"
	end
	local curr2
	local max = MAX or UnitPowerMax(Unit)
	local curr = UnitPower(Unit)
	local regen = select(2, GetPowerRegen(Unit))
	-- if select(4,GetTalentInfo(4,1,GetActiveSpecGroup())) then
	-- curr2 = curr + 4*GetComboPoints("player")
	-- else
	-- curr2 = curr
	-- end
	curr2 = (max - curr) * (1.0 / regen)
	if curr2 <= 0 then
		return 0
	else
		return curr2
	end
end
---------------------------------------------------------------------------------

--获取目标死亡需要的时间
---------------------------------------------------------------------------------
local thpcurr, thpstart, timestart, currtar, priortar, timecurr, timeToDie
function msGTTD(unit)
	unit = unit or "target"
	if thpcurr == nil then
		thpcurr = 0
	end
	if thpstart == nil then
		thpstart = 0
	end
	if timestart == nil then
		timestart = 0
	end
	if UnitIsVisible(unit) and not UnitIsDeadOrGhost(unit) then
		if currtar ~= UnitGUID(unit) then
			priortar = currtar
			currtar = UnitGUID(unit)
		end
		if thpstart == 0 and timestart == 0 then
			thpstart = UnitHealth(unit)
			timestart = GetTime()
		else
			thpcurr = UnitHealth(unit)
			timecurr = GetTime()
			if thpcurr >= thpstart then
				thpstart = thpcurr
				timeToDie = 999
			else
				if ((timecurr - timestart) == 0) or ((thpstart - thpcurr) == 0) then
					timeToDie = 999
				else
					timeToDie = round2(thpcurr / ((thpstart - thpcurr) / (timecurr - timestart)), 2)
				end
			end
		end
	elseif not UnitIsVisible(unit) or currtar ~= UnitGUID(unit) then
		currtar = 0
		priortar = 0
		thpstart = 0
		timestart = 0
		timeToDie = 0
	end
	if timeToDie == nil then
		return 999
	else
		return timeToDie
	end
end
function round2(num, idp)
	mult = 10 ^ (idp or 0)
	return math.floor(num * mult + 0.5) / mult
end
---------------------------------------------------------------------------------

--通过GUID寻找目标指针	GetObjectWithGUID
---------------------------------------------------------------------------------
function msGUG(GUID)
	if type(GUID) ~= "string" then
		return nil, "指针不存在", GUID
	end
	return GetObjectWithGUID(GUID)
end
---------------------------------------------------------------------------------

--是否指定专精,参数直接填专精中文名称
---------------------------------------------------------------------------------
function msITN(name)
	local n = GetSpecialization()
	if n then
		local _, Talent = GetSpecializationInfo(n)
		return Talent == name
	end
end
---------------------------------------------------------------------------------

--返回目标的坐标及朝向,默认当前目标
---------------------------------------------------------------------------------
function msGUL(unit)
	if type(unit) ~= "string" then
		unit = "target"
	end
	if UnitIsVisible(unit) then
		local x, y, z = ObjectPosition(unit)
		local r = ObjectFacing(unit)
		return x, y, z, r
	end
end
---------------------------------------------------------------------------------

--获取目标First的Distance码的位置
---------------------------------------------------------------------------------
function msGPBU(Distance, First, Second)
	First = First or "target"
	Second = Second or "Player"
	if not UnitIsVisible(First) or not UnitIsVisible(Second) then
		return nil
	end
	return GetPositionBetweenObjects(First, Second, Distance)
	-- local fX,fY,fZ = ObjectPosition(First);
	-- local sX,sY,sZ = ObjectPosition(Second);
	-- local Facing = math.atan2(sY-fY,sX-fX)%(math.pi*2);
	-- local Pitch = math.atan((sZ-fZ)/math.sqrt(((fX-sX)^2)+((fY-sY)^2)))%(math.pi*2);
	-- return math.cos(Facing)*Distance+fX,math.sin(Facing)*Distance+fY,math.sin(Pitch)*Distance+fZ;
end
---------------------------------------------------------------------------------

--获取充能技能的可用数量及冷却时间,参数可以ID或技能名称
---------------------------------------------------------------------------------
function msGSC(spell)
	local charges, maxCharges, start, duration = GetSpellCharges(spell)
	local cd
	if charges then
		cd = duration + start - GetTime()
		if cd >= duration then
			cd = 0
		end
		return charges, cd
	end
	cd = msGCD(spell)
	if msISC(spell) then
		return 1, cd
	end
	return 0, cd
end
---------------------------------------------------------------------------------

--获取JJC敌对相应专精的目标群;填写数字specID;http://wowprogramming.com/docs/api_types#specID
---------------------------------------------------------------------------------
function msGAOS(specID)
	if not IsActiveBattlefieldArena() then
		return false
	end
	if (type(specID) ~= "table") then
		specID = {strsplit(",", specID)}
	end
	local Arena, unit = {}
	for i = 1, 3 do
		local Spec = GetArenaOpponentSpec(i)
		for j = 1, #specID do
			if tonumber(Spec) == tonumber(specID[j]) then
				unit = "arena" .. i
				tinsert(Arena, "arena" .. i)
			end
		end
	end
	return unit, Arena
end
---------------------------------------------------------------------------------

--获取目标模型半径
---------------------------------------------------------------------------------
function msGBR(unit)
	if type(unit) ~= "string" then
		unit = "target"
	end
	if UnitIsVisible(unit) then
		return UnitBoundingRadius(unit)
	end
	return -1, "获取失败", unit
end
---------------------------------------------------------------------------------

--获取目标可攻击范围
---------------------------------------------------------------------------------
function msGCR(unit)
	if type(unit) ~= "string" then
		unit = "target"
	end
	if UnitIsVisible(unit) then
		return UnitCombatReach(unit)
	end
	return -1, "获取失败:", unit
end
---------------------------------------------------------------------------------

--判断目标是否副本中的boss
---------------------------------------------------------------------------------
function msIB(unit)
	-- if type(unit) ~= "string" and UnitGUID("boss1") then
	-- return true;
	-- end
	if not UnitIsVisible(unit) then
		return false, "目标不存在:", unit
	end
	local i = 1
	local boss = UnitGUID("boss" .. i)
	while boss do
		if UnitGUID(unit) == boss then
			return true
		end
		i = i + 1
		boss = UnitGUID("boss" .. i)
	end
	return false, "目标不是boss:", unit
end
---------------------------------------------------------------------------------

--判断是否含有该名字的boss
---------------------------------------------------------------------------------
function msIBN(name)
	if type(name) ~= "table" then
		name = {strsplit(",", name)}
	end
	local i = 1
	local boss = UnitIsVisible("boss" .. i)
	while boss do
		--local GUID = GetObjectWithGUID(boss)
		if tContains(name, UnitName("boss" .. i)) then
			return true
		end
		i = i + 1
		boss = UnitIsVisible("boss" .. i)
	end
	return false, "boss不是该名字", unit
end
---------------------------------------------------------------------------------

--面对目标
----------------------------------------------------------------------------------
function msSA(unit)
	if not UnitIsVisible(unit) then
		return false, "目标不存在:", unit
	end
	FaceDirection(GetAnglesBetweenObjects("player", unit))
end
----------------------------------------------------------------------------------

--获取目标2面对目标1的方向
----------------------------------------------------------------------------------
function msGA(unit1, unit2)
	if type(unit1) ~= "string" then
		unit = "target"
	end
	if type(unit2) ~= "string" then
		unit = "player"
	end
	local X1, Y1, Z1 = msGUL(unit1)
	local X2, Y2, Z2 = msGUL(unit2)
	if X1 and X2 then
		--local Angle = atan((Z1 - Z2) / sqrt(pow(X1 - X2, 2) + pow(Y1 - Y2, 2))) % pi;
		return atan2(Y2 - Y1, X2 - X1) % (pi * 2)
	end
end
----------------------------------------------------------------------------------

--移动到指定目标或坐标
----------------------------------------------------------------------------------
function msMT(unit)
	if type(unit) == "string" and UnitIsVisible(unit) then
		MoveTo(ObjectPosition(unit))
	elseif type(unit) == "table" then
		MoveTo(unit[1], unit[2], unit[3])
	end
end
--
----------------------------------------------------------------------------------

--自动钓鱼
----------------------------------------------------------------------------------
--[[
ObjectField(Object, 0x1E0, Types.Short) == 1
ObjectDescriptor(Object, 0x40, Types.UInt) == 668

]]
function msFISH()
	if IsFishingLoot() then
		for i = 1, GetNumLootItems() do
			ConfirmLootSlot(i)
			LootSlot(i)
		end
		CloseLoot()
	elseif not IsFishingLoot() and msINT("msFISH准备放鱼钩", 0.5) then
		local name = GetSpellInfo(131474)
		if UnitChannelInfo("player") == name then
			--local playerULong = ObjectDescriptor("player", 0, Types.ULong)
			for i = 1, GetObjectCount() do
				local Object = GetObjectWithIndex(i)
				--if ObjectDescriptor(Object, 0x30, Types.ULong) == playerULong and ObjectField(Object, 0x14C, Types.Byte) == 1 and ObjectName(Object) == "鱼漂" then
				if ObjectField(Object, 0x14C, Types.Byte) == 1 and ObjectName(Object) == "鱼漂" then
					InteractUnit(Object)
					return
				end
			end
		elseif not UnitChannelInfo("player") and not UnitAffectingCombat("player") and GetUnitSpeed("player") == 0 then
			CastSpellByName(name)
		end
	end
end
----------------------------------------------------------------------------------

--停止移动
----------------------------------------------------------------------------------
function msSM()
	AscendStop()
	DescendStop()
	MoveAndSteerStop()
	MoveBackwardStop()
	MoveForwardStop()
	PitchDownStop()
	PitchUpStop()
	StrafeLeftStop()
	StrafeRightStop()
	TurnLeftStop()
	TurnRightStop()
	TurnOrActionStop()
end
----------------------------------------------------------------------------------

--摧毁指定名称的物品（多个物品名中间用“,”分隔），可指定最高稀有度限制
----------------------------------------------------------------------------------
function msDI(itemName, rarity)
	if (not itemName or type(itemName) ~= "string") then
		return false
	end
	local itemnames = {strsplit(",", itemName)}
	for i = 0, 4 do
		local slotcount = GetContainerNumSlots(i)
		if (slotcount > 0) then
			for j = 1, slotcount do
				local item = GetContainerItemLink(i, j)
				if (item) then
					local itemName, _, itemRarity = GetItemInfo(item)
					for k = 1, #itemnames do
						local curName = strtrim(itemnames[k])
						if (itemName and strlen(curName) > 0) then
							--if (strfind(itemName, curName)) then
							if itemName == curName then
								if (type(rarity) ~= "number" or type(rarity) == "number" and itemRarity <= rarity) then
									PickupContainerItem(i, j)
									DeleteCursorItem()
								end
							end
						end
					end
				end
			end
		end
	end
	return true
end
----------------------------------------------------------------------------------
if msIIIt == nil then
	msIIIt = {}
end
msIIIt = {
	56754, -- Azure Serpent (Shado'pan Monestary)
	56895, -- Weak Spot - Raigon (Gate of the Setting Sun)
	76585, -- Ragewing
	77692, -- Kromog
	77182, -- Oregorger
	-- 86644,     -- Ore Crate from Oregorger boss
	96759, -- Helya
	100360, -- Grasping Tentacle (Helya fight)
	100354, -- Grasping Tentacle (Helya fight)
	100362, -- Grasping Tentacle (Helya fight)
	98363, -- Grasping Tentacle (Helya fight)
	99803, -- Destructor Tentacle (Helya fight)
	99801, -- Destructor Tentacle (Helya fight)
	98696, -- Illysanna Ravencrest (Black Rook Hold)
	114900, -- Grasping Tentacle (Trials of Valor)
	114901, -- Gripping Tentacle (Trials of Valor)
	116195, -- Bilewater Slime (Trials of Valor)
	120436, -- Fallen Avatar (Tomb of Sargeras)
	116939, -- Fallen Avatar (Tomb of Sargeras)
	118462, -- Soul Queen Dejahna (Tomb of Sargeras)
	119072, -- Desolate Host (Tomb of Sargeras)
	118460, -- Engine of Souls (Tomb of Sargeras)
	122450, -- Garothi Worldbreaker (Antorus the Burning Throne - Confirmed in game)
	123371, -- Garothi Worldbreaker (Antorus the Burning Throne)
	122778, -- Annihilator - Garothi Worldbreaker (Antorus the Burning Throne)
	122773, -- Decimator - Garothi Worldbreaker (Antorus the Burning Throne)
	122578, -- Kin'garoth (Antorus the Burning Throne - Confirmed in game)
	125050 -- Kin'garoth (Antorus the Burning Throne)
}
function msIII(Unit1, Unit2)
	if Unit2 == nil then
		if Unit1 == "player" then
			Unit2 = "target"
		else
			Unit2 = "player"
		end
	end
	local djh = msIIIt
	for i = 1, #djh do
		if ObjectID(Unit1) == djh[i] or ObjectID(Unit2) == djh[i] then
			return true
		end
	end
	if ObjectExists(Unit1) and UnitIsVisible(Unit1) and ObjectExists(Unit2) and UnitIsVisible(Unit2) then
		local X1, Y1, Z1 = ObjectPosition(Unit1)
		local X2, Y2, Z2 = ObjectPosition(Unit2)
		if TraceLine(X1, Y1, Z1 + 2, X2, Y2, Z2 + 2, 0x10) == nil then
			return true
		else
			return false
		end
	else
		return true
	end
end
-------------------------------
function msOvaleIcon(icon) -----
	--[[
		修改Ovale\dist\Icon.lua
		在
		                self.icone:Show()
				self.icone:SetTexture(actionTexture)
				后面一行添加一个全局变量=actionTexture
				如：
				msOvale2 = actionTexture
				在msR()中调用，不能添加目标参数
	]]
	if not _G.OvaleDB then
		return false, "请先安装Ovale插件。"
	end
	if icon == nil then
		icon = msOvale2
	end
	--print(type(icon))
	if type(icon) ~= "number" then
		return false, "图标材质ID不正确，ID为数字，清确保按注释修改。"
	end
	for i = 1, MAX_SKILLLINE_TABS do
		local name, texture, offset, numSpells = GetSpellTabInfo(i)
		if not texture then
			break
		end
		for s = offset + 1, offset + numSpells do
			local name1, rank1, icon1, castTime1, minRange1, maxRange1, spellId1 = GetSpellInfo(s, BOOKTYPE_SPELL)
			if icon1 == icon then
				return name1, spellId1
			end
			-- DEFAULT_CHAT_FRAME:AddMessage(name1..": "..spellId1);
		end
	end
end
