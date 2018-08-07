WowLuaLocals = {}
local L = WowLuaLocals


L.RELOAD_COMMAND = "/reload"
L.RESET_COMMAND  = "/reset"

L.TOOLTIPS = {}
if GetLocale() == "zhCN" then
	L.TOOLTIPS["New"] = { name = "新建", text = "创建一个新的脚本。" }
	L.TOOLTIPS["Open"] = { name = "打开", text = "打开一个已保存的脚本。" }
	L.TOOLTIPS["Save"] = { name = "保存、重命名", text = "\n点击：保存当前脚本\n\nshift+点击: 重命名。" }
	L.TOOLTIPS["Undo"] = { name = "撤销", text = "撤销修改。" }
	L.TOOLTIPS["Redo"] = { name = "恢复", text = "恢复修改。" }
	L.TOOLTIPS["Delete"] = { name = "删除", text = "删除当前脚本。" }
	L.TOOLTIPS["Lock"] = { name = "锁定", text = "锁定当前脚本\n提示: 锁定后不能删除、编辑本脚本。" }
	L.TOOLTIPS["Unlock"] = { name = "解锁", text = "解锁当前脚本\n提示: 解锁后可以删除、编辑本脚本。" }
	L.TOOLTIPS["Previous"] = { name = "前", text = "打开上一个脚本" }
	L.TOOLTIPS["Next"] = { name = "后", text = "打开下一个脚本" }
	L.TOOLTIPS["Run"] = { name = "调试", text = "调试当前脚本" }
	L.TOOLTIPS["Config"] = { name = "设置", text = "设置脚本文字大小" }
	L.TOOLTIPS["Close"] = { name = "关闭" }
	
	L.NEW_PAGE_TITLE = "新建脚本 %d"
	L.Editor = "No.%s -- |cffFFFFFF%s|r%s"
	L.Notsaved = " -- |cffFF0000未保存|r"
	L.OPEN_MENU_TITLE = "选择一个脚本"
	L.SAVE_AS_TEXT = "%s 名称修改成一下:"
	L.UNSAVED_TEXT = "脚本还没保存！！\n\n是否放弃保存?"
	L.CONFIG_SUBTITLE = "调整脚本字体大小。"
	L.CONFIG_TITLE = "%s 配置"
	L.CONFIG_FONTSIZE = "文字大小"
	L.CONFIG_LABEL_FONTSIZE = "文字大小："
	L.CONFIG_FONTSIZE_TOOLTIP = "设置脚本编辑框内文字显示的大小"

	
else

	L.TOOLTIPS["New"] = { name = "New", text = "Create a new script page" }
	L.TOOLTIPS["Open"] = { name = "Open", text = "Open an existing script page" }
	L.TOOLTIPS["Save"] = { name = "Save", text = "Save the current page\n\nHint: You can shift-click this button to rename a page" }
	L.TOOLTIPS["Undo"] = { name = "Undo", text = "Undo the last change" }
	L.TOOLTIPS["Redo"] = { name = "Redo", text = "Redo the last change" }
	L.TOOLTIPS["Delete"] = { name = "Delete", text = "Delete the current page" }
	L.TOOLTIPS["Lock"] = { name = "Lock", text = "This page is unlocked to allow changes. Click to lock." }
	L.TOOLTIPS["Unlock"] = { name = "Unlock", text = "This page is locked to prevent changes. Click to unlock." }
	L.TOOLTIPS["Previous"] = { name = "Previous", text = "Navigate back one page" }
	L.TOOLTIPS["Next"] = { name = "Next", text = "Navigate forward one page" }
	L.TOOLTIPS["Run"] = { name = "Run", text = "Run the current script" }
	L.TOOLTIPS["Config"] = { name = "Config", text = "Open the configuration panel for WowLua" }
	L.TOOLTIPS["Close"] = { name = "Close" }
	
	
	L.NEW_PAGE_TITLE = "Untitled %d"
	L.Editor = " - wowlua Editor"
	L.OPEN_MENU_TITLE = "Select a Script"
	L.SAVE_AS_TEXT = "Save %s with the following name:"
	L.UNSAVED_TEXT = "You have unsaved changes on this page that will be lost if you navigate away from it.  Continue?"
	L.CONFIG_SUBTITLE = "This panel can be used to configure the NinjaPanel LDB display."
	L.CONFIG_TITLE = "%s Configuration"
	L.CONFIG_FONTSIZE = "Font size"
	L.CONFIG_LABEL_FONTSIZE = "Font size:"
	L.CONFIG_FONTSIZE_TOOLTIP = "Configure the font size of the WowLua frame interpreter/editor"

end