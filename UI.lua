BINDING_HEADER_MagicStone = "MagicStone"
BINDING_NAME_MagicStoneShow = "显示/隐藏插件图标"
BINDING_NAME_MagicStoneOnce = "插件运行一次"
BINDING_NAME_MagicStoneStartStop = "启动/停止插件运行"
BINDING_NAME_MagicStoneStart = "启动插件运行"
BINDING_NAME_MagicStoneStop = "停止插件运行"

--StaticPopupDialogs["NoFireHack"] =
--{text = "|cFF00FF00MagicStone：未加载!|r",button1 = "知道了",	timeout = 0, exclusive = 1,	whileDead = 1, hideOnEscape = nil};

SlashCmdList["msrl"] = msrlUI
SLASH_msrl1 = "/rl"
MagicStoneLuaList = {}
MagicStonehelper = {
	Queuingtime = 5, --排队进入时间
	Queuingchecked = false, --排队开关
	Used = true, --功能列表缩放开关
	Loadscript = true, --魔石文件列表缩放开关
	wowlua = true, --编辑框列表缩放开关
	Insert = false, --技能插入开关
	NoAutoAway = false, --防暂离开关
	AddonLoadedRun = false, --自动插件开关
	Talent = false --野外切换天赋
}
----
--API
local UnitAffectingCombat = UnitAffectingCombat
local GetTalentInfo = GetTalentInfo
local IsAddOnLoaded = IsAddOnLoaded
local LoadAddOn = LoadAddOn
local IsResting = IsResting
local IsMouseButtonDown = IsMouseButtonDown
--local AcceptProposal = AcceptProposal;
local AcceptBattlefieldPort = AcceptBattlefieldPort
local CreateFrame = CreateFrame
local wipe = wipe
local IsModifierKeyDown = IsModifierKeyDown
local GetSpellInfo = GetSpellInfo
local GetUnitName = GetUnitName
local GetItemInfo = GetItemInfo
local GetActionInfo = GetActionInfo
local GetCursorInfo = GetCursorInfo
local GetMaxBattlefieldID = GetMaxBattlefieldID
local GetBattlefieldStatus = GetBattlefieldStatus
local GetTime = GetTime
local IsFalling = IsFalling
local UnitPower = UnitPower
local GetSpellCooldown = GetSpellCooldown
local UnitCastingInfo = UnitCastingInfo
local UnitChannelInfo = UnitChannelInfo
local UnitGUID = UnitGUID
local format = format
local pairs = pairs
local tonumber = tonumber
local type = type
local ipairs = ipairs
local WowLua = WowLua
local tinsert = tinsert
local tContains = tContains
local strlower = strlower
local loadstring = loadstring
local pcall = pcall
local print = print
local error = error
local select = select
local C_Timer = C_Timer
local CastSpellByName = CastSpellByName
local msISC = msISC
--FH API
local ReadFile = ReadFile
local ObjectPosition = ObjectPosition
local GetDirectoryFiles = GetDirectoryFiles
local GetGameDirectory = GetWoWDirectory
--库
local luaScript = {}
local Files
local wowluaScript = {}
local firstone = true
local ResetEditbox = function()
	if firstone then
		local page, entry = WowLua:GetCurrentPage()
		WowLuaFrameEditBox:SetText(entry.content)
		WowLua:UpdateButtons()
		WowLua:SetTitle()
		firstone = false
		for name, _ in pairs(MagicStoneLuaList) do
			if not tContains(luaScript, name) then
				MagicStoneLuaList[name] = nil
			end
		end
	end
end
--帮助
--
local MagicStoneList = {}
local menu = MagicStoneScriptMenu("AbinDropDownMenu")
menu:SetMenuRequestFunc(MagicStoneList, "OnMenuRequest")
function MagicStoneList:OnMenuRequest(level, value, menu)
	MagicStoneLoadscript()
	if level == 1 then
		menu:AddLine(
			"text",
			"|cFF00FF00使用说明|r",
			"icon",
			"Interface\\Icons\\INV_Scroll_11",
			"func",
			function()
				OpenURL(GetWoWDirectory() .. "\\Interface\\AddOns\\MagicStone\\MagicStone函数说明书.html")
			end
		)
		menu:AddLine("line", 1, "LineBrightness", 1, "LineHeight", 10)
		menu:AddLine(
			"text",
			"|cff00ffff特殊列表|r",
			"isTitle",
			1,
			"ToggleButton",
			1,
			"ToggleState",
			not MagicStonehelper.Used,
			"ToggleButtonFun",
			function()
				MagicStonehelper.Used = not MagicStonehelper.Used
				menu:Refresh(level)
			end
		)
		if MagicStonehelper.Used then
			menu:AddLine("line", 1, "LineBrightness", 1, "LineHeight", 10)
			menu:AddLine(
				"text",
				"切换天赋",
				"arg1",
				MagicStonehelper,
				"checked",
				MagicStonehelper.Talent,
				"func",
				function(arg1)
					if arg1.Talent then
						arg1.Talent = false
					else
						arg1.Talent = true
					end
					menu:Refresh(level)
				end,
				"tooltipText",
				"切换天赋不需要宁神书卷。\n战斗状态与大米中不能用！"
			)
			menu:AddLine("line", 1, "LineHeight", 5)
			menu:AddLine(
				"text",
				"防止暂离",
				"arg1",
				MagicStonehelper,
				"checked",
				MagicStonehelper.NoAutoAway,
				"func",
				function(arg1)
					if arg1.NoAutoAway then
						arg1.NoAutoAway = false
					else
						arg1.NoAutoAway = true
					end
					menu:Refresh(level)
				end,
				"tooltipText",
				"只要勾选开关\n则永远不会暂离下线"
			)
			menu:AddLine("line", 1, "LineHeight", 5)
			menu:AddLine(
				"text",
				"技能插入",
				"arg1",
				MagicStonehelper,
				"checked",
				MagicStonehelper.Insert,
				"func",
				function(arg1)
					if arg1.Insert then
						arg1.Insert = false
					else
						arg1.Insert = true
					end
					menu:Refresh(level)
				end,
				"tooltipText",
				"直接使用动作条上技能\n即可在下个技能插入。\n不支持宏及物品。"
			)
			menu:AddLine("line", 1, "LineHeight", 5)
			menu:AddLine(
				"text",
				"|cFF00FF00自动进入|r",
				"hasEditBox",
				1,
				"editBoxText",
				MagicStonehelper.Queuingtime,
				"editBoxArg1",
				MagicStonehelper,
				"editBoxArg2",
				self.text,
				"editBoxFunc",
				function(arg1, text)
					local text = tonumber(text)
					if type(text) == "number" then
						arg1.Queuingtime = text
						menu:Refresh(level)
					end
				end,
				"arg1",
				MagicStonehelper,
				"checked",
				MagicStonehelper.Queuingchecked,
				"func",
				function(arg1)
					if arg1.Queuingchecked then
						arg1.Queuingchecked = false
					else
						arg1.Queuingchecked = true
					end
					menu:Refresh(level)
				end,
				"tooltipText",
				"延时" .. MagicStonehelper.Queuingtime .. "秒后自动进入：\n竞技场、战场、副本、情景模式。"
			)
		end
		menu:AddLine("line", 1, "LineBrightness", 1, "LineHeight", 10)
		menu:AddLine(
			"text",
			"|cff00ffff魔石列表|r",
			"ToggleButton",
			1,
			"ToggleState",
			not MagicStonehelper.Loadscript,
			"isTitle",
			1,
			"ToggleButtonFun",
			function()
				MagicStonehelper.Loadscript = not MagicStonehelper.Loadscript
				menu:Refresh(level)
			end,
			"tooltipText",
			"本列表自动实时识别文件内所有.lua格式的脚本文件。\n文件夹目录：\n" ..
				GetWoWDirectory() .. "\\ms\\\n特点：\n1.脚本在游戏外编写。\n2.所有角色共用脚本。\n3.脚本与插件及游戏独立储存。"
		)
		if MagicStonehelper.Loadscript then
			menu:AddLine("line", 1, "LineBrightness", 1, "LineHeight", 10)
			if Files then
				for page, name in ipairs(luaScript) do
					menu:AddLine(
						"text",
						name,
						"arg1",
						name,
						"value",
						name,
						"checked",
						MagicStoneLuaList[name].checked,
						"hasArrow",
						1,
						"func",
						function(arg1)
							if MagicStoneLuaList[name].checked then
								MagicStoneLuaList[name].checked = false
							else
								MagicStoneLuaList[name].checked = true
							end
							menu:Refresh(level)
						end
					)
					if page < #luaScript then
						menu:AddLine("line", 1, "LineBrightness", 0.3, "LineHeight", 6)
					end
				end
			else
				menu:AddLine(
					"text",
					"无脚本文件",
					"isTitle",
					1,
					"tooltipText",
					'请在游戏根目录创建名为"魔石"的文件夹：\n' .. GetWoWDirectory() .. "\\魔石\\\n并放置后续为lua的脚本文件"
				)
			end
		end
		menu:AddLine("line", 1, "LineBrightness", 1, "LineHeight", 10)
		menu:AddLine(
			"text",
			"|cff00ffff编辑器列表|r",
			"ToggleButton",
			1,
			"ToggleState",
			not MagicStonehelper.wowlua,
			"isTitle",
			1,
			"ToggleButtonFun",
			function()
				MagicStonehelper.wowlua = not MagicStonehelper.wowlua
				menu:Refresh(level)
			end,
			"tooltipText",
			"本列表需要在游戏内自行新建编写。\n特点：\n1.脚本在游戏内编写。\n2.所有角色独立脚本。\n3.脚本储存于客户端的人物配置文件内:\n" .. GetWoWDirectory() .. "\\WTF\\"
		)
		menu:AddLine("line", 1, "LineBrightness", 1, "LineHeight", 10)
		if MagicStonehelper.wowlua then
			menu:AddLine(
				"text",
				"|cFF00FF00新建脚本|r",
				"icon",
				"Interface\\Icons\\INV_Scroll_11",
				"func",
				function()
					ResetEditbox()
					WowLuaFrame:Show()
					WowLua:Button_New()
					menu:Refresh(level)
				end
			)
			menu:AddLine("line", 1, "LineBrightness", 0.3, "LineHeight", 6)
			for page, entry in ipairs(WowLua_DB.pages) do
				menu:AddLine(
					"text",
					entry.name,
					"arg1",
					entry,
					"value",
					page,
					"checked",
					entry.checked,
					"hasArrow",
					1,
					"func",
					function(arg1)
						if arg1.checked then
							arg1.checked = false
						else
							arg1.checked = true
						end
						msScriptList()
						menu:Refresh(level)
					end
				)
				menu:AddLine("line", 1, "LineBrightness", 0.3, "LineHeight", 6)
			end
		end
	elseif level == 2 then
		if MagicStonehelper.Loadscript and type(value) == "string" then
			menu:AddLine("text", "|cffff7700" .. value, "isTitle", 1, "text_X", -20)
			menu:AddLine("line", 1, "LineBrightness", 1, "LineHeight", 10)
			menu:AddLine(
				"text",
				"脚本调试",
				"icon",
				"Interface\\ICONS\\INV_Scroll_05",
				"arg1",
				value,
				"func",
				function(name)
					local Script = ReadFile(GetWoWDirectory() .. "\\ms\\" .. name)
					RunLuaScript(Script, name)
				end
			)
			menu:AddLine("line", 1, "LineBrightness", 0.3, "LineHeight", 6)
			menu:AddLine(
				"text",
				"脚本延时",
				"icon",
				"Interface\\ICONS\\INV_Elemental_SpiritofHarmony_2",
				"hasEditBox",
				1,
				"editBoxText",
				MagicStoneLuaList[value].runtime,
				"editBoxArg1",
				MagicStoneLuaList[value],
				"editBoxArg2",
				self.text,
				"editBoxFunc",
				function(editBoxArg1, text)
					local text = tonumber(text)
					if type(text) == "number" then
						editBoxArg1.runtime = text
						menu:Refresh(level)
					end
				end
			)
		end
		if MagicStonehelper.wowlua and type(value) == "number" then
			menu:AddLine("text", "|cffff7700" .. WowLua_DB.pages[value].name, "isTitle", 1, "text_X", -20)
			menu:AddLine("line", 1, "LineBrightness", 1, "LineHeight", 10)
			menu:AddLine(
				"text",
				"重命名",
				"icon",
				"Interface\\ICONS\\INV_Scroll_04",
				"hasEditBox",
				1,
				"editBoxText",
				WowLua_DB.pages[value].name,
				"editBoxArg1",
				WowLua_DB.pages[value],
				"editBoxArg2",
				self.text,
				"editBoxFunc",
				function(entry, text)
					if type(text) ~= "nil" then
						entry.name = text
						menu:Refresh(1)
						WowLua:UpdateButtons()
						WowLua:SetTitle(false)
					end
				end
			)
			menu:AddLine("line", 1, "LineHeight", 5)
			menu:AddLine(
				"text",
				"编辑脚本",
				"arg1",
				value,
				"icon",
				"Interface\\ICONS\\INV_Scroll_05",
				"func",
				function(arg1)
					ResetEditbox()
					WowLuaFrame:Show()
					WowLua:GoToPage(arg1)
				end
			)
			menu:AddLine("line", 1, "LineHeight", 5)
			local runtime = WowLua_DB.pages[value].runtime
			menu:AddLine(
				"text",
				"脚本延时",
				"icon",
				"Interface\\ICONS\\INV_Elemental_SpiritofHarmony_2",
				"hasEditBox",
				1,
				"editBoxText",
				runtime,
				"editBoxArg1",
				WowLua_DB.pages[value],
				"editBoxArg2",
				self.text,
				"editBoxFunc",
				function(entry, text)
					local text = tonumber(text)
					if type(text) == "number" then
						entry.runtime = text
						menu:Refresh(level)
					end
				end
			)
			menu:AddLine("line", 1, "LineHeight", 5)
			menu:AddLine(
				"text",
				"往上移动",
				"func",
				ScriptMobileButton,
				"arg1",
				value,
				"arg2",
				"up",
				"icon",
				"INTERFACE\\BUTTONS\\Arrow-Up-UP"
			) --, "iconWidth",25, "iconHeight", 25
			menu:AddLine("line", 1, "LineHeight", 5)
			menu:AddLine(
				"text",
				"往下移动",
				"func",
				ScriptMobileButton,
				"arg1",
				value,
				"arg2",
				"down",
				"icon",
				"INTERFACE\\BUTTONS\\Arrow-DOWN-UP"
			)
			menu:AddLine("line", 1, "LineBrightness", 1, "LineHeight", 10)
			menu:AddLine(
				"text",
				"|cFFFF0000删除脚本|r",
				"tooltipTitle",
				"编辑框内输入|cFFFF0000delete|r回车即可删除",
				"disabled",
				WowLua_DB.pages[value].locked,
				"icon",
				"Interface\\ICONS\\inv_misc_volatilefire",
				"hasEditBox",
				1,
				"editBoxArg1",
				value,
				"editBoxArg2",
				self.text,
				"editBoxFunc",
				function(entry, text)
					if text == "delete" then
						DeleteScriptButton(entry)
					end
				end
			)
		end
	end
end
--排队助手
local SafeQueue = CreateFrame("Frame")
SafeQueue:RegisterEvent("UPDATE_BATTLEFIELD_STATUS")
SafeQueue:RegisterEvent("LFG_PROPOSAL_SHOW")
SafeQueue:SetScript(
	"OnEvent",
	function(self, event, ...)
		if event == "UPDATE_BATTLEFIELD_STATUS" and MagicStonehelper.Queuingchecked then
			for i = 1, GetMaxBattlefieldID() do
				local status = GetBattlefieldStatus(i)
				if status == "confirm" then
					C_Timer.NewTimer(
						MagicStonehelper.Queuingtime,
						function()
							AcceptBattlefieldPort(i, 1)
						end
					)
				end
			end
		end
		if event == "LFG_PROPOSAL_SHOW" and MagicStonehelper.Queuingchecked then
			C_Timer.NewTimer(
				MagicStonehelper.Queuingtime,
				function()
					securecall(AcceptProposal)
				end
			)
		end
	end
)
function OnUpdateScriptMenu()
	menu:Close(2)
	menu:Refresh(1)
end
function DeleteScriptButton(arg1)
	ResetEditbox()
	if WowLua:IsModified() then
		local dialog = StaticPopup_Show("WOWLUA_UNSAVED")
		dialog.data = "Button_Delete"
		return
	end
	if WowLua:GetNumPages() == 1 then
		WowLua_DB.untitled = 1
		WowLua:Button_New()
		WowLua:Button_Previous()
	end
	WowLua:DeletePage(arg1)
	if arg1 > 1 then
		arg1 = arg1 - 1
	end
	local entry = WowLua:SelectPage(arg1)
	WowLuaFrameEditBox:SetText(entry.content)
	WowLua:UpdateButtons()
	WowLua:SetTitle(false)
end
--- 防暂离
if MagicStonehelper.NoAutoAway then
	SetHackEnabled("NoAutoAway", true)
end
function ScriptMobileButton(arg1, arg2)
	if arg2 == "up" and arg1 > 1 then
		local entry = table_copy_table(WowLua_DB.pages[arg1 - 1])
		table_copy_table(WowLua_DB.pages[arg1], WowLua_DB.pages[arg1 - 1])
		table_copy_table(entry, WowLua_DB.pages[arg1])
		firstone = true
		WowLuaFrame:Hide()
		menu:Refresh(1)
	elseif arg2 == "down" and arg1 < #WowLua_DB.pages then
		local entry = table_copy_table(WowLua_DB.pages[arg1 + 1])
		table_copy_table(WowLua_DB.pages[arg1], WowLua_DB.pages[arg1 + 1])
		table_copy_table(entry, WowLua_DB.pages[arg1])
		firstone = true
		WowLuaFrame:Hide()
		menu:Refresh(1)
	end
end
function table_copy_table(ori_tab, new_tab)
	if (type(ori_tab) ~= "table") then
		return nil
	end
	if (type(new_tab) ~= "table") then
		new_tab = {}
	end
	for i, v in pairs(ori_tab) do
		local vtyp = type(v)
		if (vtyp == "table") then
			new_tab[i] = table_copy_table(v)
		elseif (vtyp == "thread") then
			new_tab[i] = v
		elseif (vtyp == "userdata") then
			new_tab[i] = v
		else
			new_tab[i] = v
		end
	end
	return new_tab
end

function RunLuaScript(Script, name)
	local func, err = loadstring(Script, name)
	if not func then
		print("|cffff0000" .. err .. "|r")
		return false, err
	else
		local succ, err = pcall(func)
		if not succ then
			print("|cffff0000" .. err .. "|r")
			return false, err
		end
	end
end
local newTalent
local TALENT_UPDATE = CreateFrame("Frame")
--TALENT_UPDATE:RegisterEvent("PLAYER_TALENT_UPDATE")
TALENT_UPDATE:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
TALENT_UPDATE:SetScript(
	"OnEvent",
	function(...)
		if newTalent then --and PlayerTalentFrame:IsVisible()
			LearnTalent(newTalent)
			newTalent = nil
		end
	end
)
local function SelectionTalent()
	hooksecurefunc(
		"PlayerTalentFrameTalent_OnClick",
		function(self)
			if IsModifierKeyDown() then
				return
			end
			newTalent = self:GetID()
			row = select(8, GetTalentInfoByID(newTalent))
			for column = 1, 3 do
				local selectedTalent, _, _, TorF = GetTalentInfo(row, column, 1)
				if TorF and MagicStonehelper.Talent and not IsResting() then
					RemoveTalent(selectedTalent)
					RemoveTalent(selectedTalent)
				end
			end
		end
	)
end
--计时器
local AutoScriptStartStop
CreateFrame("Frame"):SetScript(
	"OnUpdate",
	function()
		local MagicStonehelper = MagicStonehelper
		if MagicStonehelper.Insert then
			if MagicStonehelper.InsertSpell and msISC(MagicStonehelper.InsertSpell) then
				CastSpellByName(MagicStonehelper.InsertSpell)
			end
			if MagicStonehelper.InsertTime and GetTime() > MagicStonehelper.InsertTime then
				MagicStonehelper.InsertSpell = nil
				MagicStonehelper.InsertTime = nil
			end
		end
		if AutoScriptStartStop then
			for _, name in ipairs(wowluaScript) do
				if name and GetTime() > name.StartTime then
					RunLuaScript(name.content, name.name)
					name.StartTime = GetTime() + name.runtime
				end
			end
		end
	end
)
--加载函数库
local IsMagicStoneLoaded = {}
local FireHackTrue
IsMagicStoneLoaded =
	C_Timer.NewTicker(
	1,
	function()
		if FireHack then
			FireHackTrue = true
			IsMagicStoneLoaded:Cancel()
			ReadFile = _G.ReadFile
			CastSpellByName = _G.CastSpellByName
			GetGameDirectory = _G.GetWoWDirectory
			GetDirectoryFiles = _G.GetDirectoryFiles
			AcceptBattlefieldPort = _G.AcceptBattlefieldPort
			local fullpath = GetWoWDirectory() .. "\\Interface\\Addons\\MagicStone\\API.lua"
			local content = ReadFile(fullpath)
			RunLuaScript(content, "函数库")
			msISC = _G.msISC
			--LoadedAutoAway();
			SpellTargettext:SetText("加载成功")
		end
	end
)
function MagicStoneLoadscript()
	wipe(wowluaScript)
	wipe(luaScript)
	local Directory = GetWoWDirectory() .. "\\ms\\"
	Files = pcall(GetDirectoryFiles, Directory .. "*.lua")
	if Files then
		luaScript = GetDirectoryFiles(Directory .. "*.lua")
		for i = 1, #luaScript do
			local luaScriptName = luaScript[i]
			if not MagicStoneLuaList[luaScriptName] then
				MagicStoneLuaList[luaScriptName] = {checked = false, runtime = 0}
			end
			if MagicStoneLuaList[luaScriptName].checked then
				luaScript[luaScriptName] = {
					StartTime = 0,
					runtime = MagicStoneLuaList[luaScriptName].runtime,
					content = ReadFile(Directory .. luaScriptName),
					name = luaScriptName
				}
				tinsert(wowluaScript, luaScript[luaScriptName])
			end
		end
	end
	for _, entry in ipairs(WowLua_DB.pages) do
		if entry.checked then
			entry.StartTime = 0
			tinsert(wowluaScript, entry)
		end
	end
end

function msScriptList(Value)
	if not FireHack then
		StaticPopup_Show("NoFireHack")
		return
	end
	MagicStoneLoadscript()
	if Value == "start" then
		AutoScriptStartStop = true
		ActionButton_ShowOverlayGlow(ScenarioButton)
	elseif Value == "stop" then
		AutoScriptStartStop = false
		ActionButton_HideOverlayGlow(ScenarioButton)
	elseif Value == "once" then
		ActionButton_HideOverlayGlow(ScenarioButton)
		AutoScriptStartStop = false
		for _, name in ipairs(luaScript) do
			if MagicStoneLuaList[name].checked then
				RunLuaScript(luaScript[name].content, name)
			end
		end
		for _, entry in ipairs(WowLua_DB.pages) do
			if entry.checked and entry.content then
				RunLuaScript(entry.content, entry.name)
			end
		end
	elseif Value == "startstop" and not AutoScriptStartStop then
		AutoScriptStartStop = true
		ActionButton_ShowOverlayGlow(ScenarioButton)
	elseif Value == "startstop" and AutoScriptStartStop then
		AutoScriptStartStop = false
		ActionButton_HideOverlayGlow(ScenarioButton)
	end
end

function msSSS(name, switch)
	if not FireHack then
		StaticPopup_Show("NoFireHack")
		return
	end
	switch = strlower(switch)
	if MagicStoneLuaList[name] then
		if switch == "start" then
			MagicStoneLuaList[name].checked = true
		elseif switch == "stop" then
			MagicStoneLuaList[name].checked = false
		elseif switch == "once" then
			MagicStoneLuaList[name].checked = false
			local Script = ReadFile(GetWoWDirectory() .. "\\ms\\" .. name)
			RunLuaScript(Script, name)
		elseif switch == "startstop" then
			if MagicStoneLuaList[name].checked then
				MagicStoneLuaList[name].checked = false
			else
				MagicStoneLuaList[name].checked = true
			end
		end
	end
	for _, entry in ipairs(WowLua_DB.pages) do
		if name == entry.name then
			if switch == "start" then
				entry.checked = true
			elseif switch == "stop" then
				entry.checked = false
			elseif switch == "once" then
				entry.checked = false
				RunLuaScript(entry.content, entry.name)
			elseif switch == "startstop" then
				if entry.checked then
					entry.checked = false
				else
					entry.checked = true
				end
			end
		end
	end
	MagicStoneLoadscript()
	if menu:IsOpen(1) then
		menu:Refresh(1)
	end
end
local ScenarioButton = CreateFrame("Button", "ScenarioButton", UIParent)
ScenarioButton:SetSize(55, 55)
ScenarioButton:SetPoint("CENTER", 100, 100)
ScenarioButton:RegisterForClicks("AnyUp")
ScenarioButton:SetFrameStrata("DIALOG")
ScenarioButton:SetClampedToScreen(true)
ScenarioButton:EnableMouse(true)
ScenarioButton:SetMovable(true)
ScenarioButton:RegisterForDrag("LeftButton")
ScenarioButton:SetNormalTexture("Interface\\Icons\\Inv_Misc_SummerFest_BrazierOrange")
ScenarioButton:SetScript("OnDragStart", ScenarioButton.StartMoving)
ScenarioButton:SetScript("OnDragStop", ScenarioButton.StopMovingOrSizing)
ScenarioButton:SetScript(
	"OnHide",
	function()
		menu:Close(1)
	end
)
ScenarioButton:SetScript(
	"OnClick",
	function(self, Button)
		if Button == "LeftButton" then
			msScriptList("startstop")
		elseif Button == "RightButton" then
			if not FireHack then
				StaticPopup_Show("NoFireHack")
				return
			end
			if menu:IsOpen(1) then
				menu:Close(1)
			else
				menu:Open("TOPLEFT", ScenarioButton, "BOTTOMLEFT")
			end
		end
	end
)
local Spell_Target
local School = {
	[1] = "|CFFFFFF00",
	[2] = "|CFFFFE680",
	[4] = "|CFFFF8000",
	[8] = "|CFF4DFF4D",
	[16] = "|CFF80FFFF",
	[32] = "|CFF8080FF",
	[64] = "|CFFFF80FF"
}
local SpellTargettext =
	ScenarioButton:CreateFontString("SpellTargettext", "BACKGROUND", "GameFontHighlightSmallOutline")
SpellTargettext:SetText("未加载")
SpellTargettext:SetPoint("CENTER", 0, -50)
ScenarioButton:RegisterEvent("UNIT_SPELLCAST_SENT")
ScenarioButton:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
ScenarioButton:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
ScenarioButton:SetScript(
	"OnEvent",
	function(self, event, ...)
		if not FireHackTrue then
			return
		end
		local Eventarg = {...}
		if (event == "UNIT_SPELLCAST_SENT") and Eventarg[1] == "player" then
			Spell_Target = Eventarg[4] ~= "" and Eventarg[4] or GetUnitName("player")
			local name, _, icon, castTime = GetSpellInfo(Eventarg[2])
			if name and icon then
				self:SetNormalTexture(icon)
				SpellTargettext:SetText(format("%s\n%s", name, Spell_Target))
			end
		elseif
			event == "COMBAT_LOG_EVENT_UNFILTERED" and Eventarg[2] == "SPELL_CAST_SUCCESS" and Eventarg[4] == UnitGUID("player")
		 then
			local SchoolColor = School[Eventarg[14]] or "|CFFFFFFFF"
			Spell_Target = Eventarg[9] or Spell_Target or GetUnitName("player")
			self:SetNormalTexture(select(3, GetSpellInfo(Eventarg[12])) or select(10, GetItemInfo(Eventarg[12])))
			SpellTargettext:SetText(format("%s%s%s\n%s\n", SchoolColor, Eventarg[13], "|r", Spell_Target))
		end
	end
)
local ADDON_LOADED_AutoRun = CreateFrame("Frame")
ADDON_LOADED_AutoRun:RegisterEvent("ADDON_LOADED")
ADDON_LOADED_AutoRun:SetScript(
	"OnEvent",
	function(self, event, name, ...)
		if name == "Blizzard_TalentUI" then
			SelectionTalent()
		end
	end
)
