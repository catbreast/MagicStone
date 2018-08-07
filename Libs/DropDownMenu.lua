	--------------------------------------------------------------------------
	-- DropDownMenu-1.0.lua
	--------------------------------------------------------------------------

	-- This library provides an easy-to-use dropdown menu interface, unlike the default
	-- dropdown menu from Blizzard's "UIDropDownMenuTemplate" template, which, frankly
	-- speaking, aside from the not-OOP coding style, is incomprehensive on commonly expected
	-- capabilities. While being primitive and built-in, it is not competent in certain
	-- circumstances such as where we would need things like editboxes and sliders, or when
	-- people need to put bulk data into the menu and need the menu to be scroll-able, or
	-- further more, where our data are split into "fields" and needed to be displayed in
	-- a multi-column-list style.

	-- Now you are probably going to mention the "DewDrop" library, but before you do I
	-- will have to say two things, one, "DewDrop" is awesome, two, on the other hand, it is bad.
	-- It's awesome because it indeed is, it's bad because of Ace2. And lemme tell you why...
	--
	-- I would personally say that it was a terrible decision made by the author to push "DewDrop"
	-- into the blackhole of Ace2, as a result, people those who dislike Ace2 will consequently have
	-- to stay away from "DewDrop" as well. It isn't that "DewDrop" is not good enough, but I don't
	-- want my addon size to be 300 KB winrar'ed that could otherwise be 15 KB. Man, I just want
	-- the nice little menu, not the whole truck load of things that stick along with it.
	--
	-- So here comes "DropDownMenu-1.0", a lightweight stand-alone dropdown menu interface which
	-- has almost every thing that "DewDrop" offers, plus some more capabilities. Most important,
	-- it is independent from any other files or libraries, which means all you need to include to
	-- your addon is this single file. So in summary:

	-- 1, Much much more powerful than "UIDropDownMenuTemplate".
	-- 2, Even more powerful than "DewDrop", if not much.
	-- 3, No dependencies at all.
	-- 4, Becomes scroll-able when number of lines have reached certain point, in which case a
	--    slider shows up on right side of the menu frame.
	-- 5, Supports table data displaying!
	-- 6, Is that enough or not?

	-- This file is provided "as is" with no expressed or implied warranty.

	-- Abin (abinn32@yahoo.com)
	-- 18/1/2009

	--------------------------------------------------------------------------
	-- API Documentation
	--------------------------------------------------------------------------

	-- menu = DropDownMenu_GetHandle() -- Acquire a new handle from DropDownMenu-1.0 library

	-- menu:SetMenuRequestFunc(func) -- Specify the function which is called when menu contents are requested.
	-- menu:SetMenuRequestFunc(object, "method") -- Specify the object and its method which is called when menu contents are requested.

	-- menu:Open(relativeTo) -- Show the dropdown menu and anchor to a region, "point" and "relativePoint" are automatically determined according to screen circumstances
	-- menu:Open("point", relativeTo, "relativePoint" [, xOffset, yOffset]) -- Show the dropdown menu and anchor to a region
	-- menu:Toggle(relativeTo) -- Toggle show/hide stats of the dropdown menu
	-- menu:Toggle("point", relativeTo, "relativePoint" [, xOffset, yOffset]) -- Toggle show/hide stats of the dropdown menu
	-- menu:Refresh([level]) -- Refresh contents of a menu and all its subsequent menus
	-- menu:Close([level]) -- Hide the dropdown menu, hide a particalar submenu if level is present
	-- menu:IsOpen([level]) -- Check whether a particular submenu is opened, default value of level is 1, which is the root

	-- The following methods are only valid inside the user defined menu-request function:

	-- menu:AddColumnHeader(["text" [, "justifyH"]]) -- Add a column header to the menu to make it become a table. Call it multiple times if your data has more than one fields
	-- menu:AddLine() -- Add a separator: a non-clickable blank button whose height is 1/3 of a normal menu button
	-- menu:AddLine("key1", value1 [, "key2", value2 [,...]]) -- Add a menu line from arg-pairs, each arg-pair consists of a key(string) and a value (see "AddLine Arguments")

	--------------------------------------------------------------------------
	-- AddLine function arguments
	--------------------------------------------------------------------------

	-- "DropDownMenu-1.0" supports all arguments provided by Blizzard and some more,
	-- the following is a complete list of key names for valid arg-pairs.

	-- text: [STRING]  --  The text of the menu line
	-- justifyH: [STRING] -- Justify button text, "LEFT", "CENTER", "RIGHT"
	-- colorCode: [STRING] -- "|cAARRGGBB" embedded hex value of the button text color. Only used when button is enabled.
	-- textR, textG, textB: [0.0 - 1.0]  -- R/G/B value for the menu text color. Only used when button is enabled.

	-- text1, text2, ..., textN: [STRING]  --  Texts for grids if the menu is displaying as a table.
	-- colorCode1, colorCode2, ..., colorCodeN: [STRING] -- "|cAARRGGBB" color code for grids if the menu is displaying as a table.
	-- text1R, text2R, ..., textNR: [0.0 - 1.0]  -- R value for grids if the menu is displaying as a table.
	-- text1G, text2G, ..., textNG: [0.0 - 1.0]  -- G value for grids if the menu is displaying as a table.
	-- text1B, text2B, ..., textNB: [0.0 - 1.0]  -- B value for grids if the menu is displaying as a table.

	-- isRadio: [nil, 1]  --  If it's a radio the check mark will be a radio button appearance.
	-- checked: [nil, 1, function]  --  Check the button if true or function returns true
	-- notClickable: [nil, 1]  --  Disable the button and color the font white
	-- notCheckable: [nil, 1]  --  Shrink the size of the buttons and don't display a check box
	-- closeWhenClicked: [nil, 1]  --  Hide the menu after a button is clicked
	-- isTitle: [nil, 1]  --  If it's a title the button is non-clickable and the font color is set to yellow
	-- disabled: [nil, 1]  --  Disable the button, font color is set to grey.
	-- hasArrow: [nil, 1]  --  Show the expand arrow for multilevel menus.
	-- value: [ANYTHING]  --  The value that will be passed to your "OnMenuRequest" function

	-- func: [function([arg1 [, arg2]])]  --  The function that is called when you click the menu item, arg2 is only present when arg1 is not nil
	-- arg1, arg2: [ANYTHING] -- Arguments used by "func"
	-- hasConfirm: [nil, 1] -- If ture, a confirm dialog pops up when the menu item is clicked, "func" will not be called until you click the "ok" button.
	-- confirmText: [STRING] -- Alternative text for the confirm dialog.
	-- confirmButton1: [STRING] -- Alternative text for the "ok" button.
	-- confirmButton2: [STRING] -- Alternative text for the "cancel" button.

	-- icon: [STRING] -- File path of the icon texture file to be displayed on menu.
	-- iconR, iconG, iconB: [0.0 - 1.0] -- If "icon" is a string, these are vertex color R/G/B values for the texture, otherwise the icon becomes a raw color-suqre.
	-- iconWidth: [NUMBER] -- Width of the icon
	-- iconHeight: [NUMBER] -- Height of the icon
	-- tCoordLeft, tCoordRight, tCoordTop, tCoordBottom: [NUMBER] -- Left, right, top, bottom texture coord for the icon, only valid if "icon" is a string.

	-- hasColorSwatch: [nil, 1]  --  Show color swatch or not, for color selection
	-- r, g, b: [0.0 - 1.0]  --  Red, green, blue color value of the color swatch
	-- hasOpacity: [nil, 1]  --  Show the opacity slider on the colorpicker frame
	-- opacity: [0.0 - 1.0]  --  Percentatge of the opacity, 1.0 is fully shown, 0 is transparent
	-- swatchFunc: [function([swatchArg1 [, swatchArg2],] r, g, b, a)]  --  Function called by the color picker on color change, swatchArg2 is only present when swatchArg1 is not nil
	-- swatchArg1, swatchArg2: [ANYTHING] -- Arguments used by "swatchFunc"

	-- tooltipTitle: [STRING] -- Title of the tooltip shown on mouseover
	-- tooltipText: [STRING] -- Text of the tooltip shown on mouseover
	-- tooltipFunc: [function([tooltipArg1 [, tooltipArg2]])]  --  Function to call when mouse hovers a menu button, tooltipArg2 is only present when tooltipArg1 is not nil
	-- tooltipArg1, tooltipArg2: [ANYTHING] -- Arguments used by "tooltipFunc".

	-- hasEditBox: [nil, 1]  --  Whether the sublevel is an edit box.
	-- editBoxText: [STRING]  --  The string initially set to the edit box.
	-- editBoxNumeric: [nil, 1]  --  Whether the edit box only receives digits, also apply for slider edit box.
	-- editBoxFunc: [function([editBoxArg1 [, editBoxArg2],] text)]  --  Function to call when the enter key is pressed in the edit box. If the return value is nil the edit box closes. editBoxArg2 is only present when editBoxArg1 is not nil
	-- editBoxArg1, editBoxArg2: [ANYTHING]  --  Arguments used by "editBoxFunc", comes after the owner object and edit box text.
	-- editBoxChangeFunc: [function([editBoxChangeArg1 [, editBoxChangeArg2],] text)]  --  Function to call when text of the edit box is changed. If the return value is a string it is set to the edit box. editBoxChangeArg2 is only present when editBoxChangeArg1 is not nil
	-- editBoxChangeArg1, editBoxChangeArg2: [ANYTHING]  --  Arguments used by "editBoxChangeFunc"

	-- hasSlider: [nil, 1]  --  Whether the sublevel is a slider.
	-- sliderMin, sliderMax: [NUMBER]  --  Min & max values of the slider.
	-- sliderMinText, sliderMaxText: [STRING]  --  Specify the texts to be shown on both ends of the slider, if not provided, it uses "sliderMin" & "sliderMax".
	-- sliderValue: [NUMBER]  --  Value of the slider.
	-- sliderStep: [NUMBER]  --  Value step of the slider.
	-- sliderIsPercent: [nil, 1]  --  Whether the slider text shows a "%" symbol.
	-- sliderDecimals: [nil, 1]  --  Specifies the decimal places of the slider value to be displayed, default is 0, which means display as integers.
	-- sliderFunc: [function([sliderArg1 [, sliderArg2],] value)]  --  Function to call when value of the slider is changed. If the return value is a number it is set to the slider. sliderArg2 is only present when sliderArg1 is not nil
	-- sliderArg1, sliderArg2: [ANYTHING]  --  Arguments used by "sliderFunc"
 
	--------------------------------------------------------------------------
	-- Simple Usage:
	--------------------------------------------------------------------------
	--[[
		MyAddon = {} -- Your addon object

		local menu = DropDownMenu_GetHandle() -- Get a new dropdown menu handle
		menu:SetMenuRequestFunc(MyAddon, "OnMenuRequest") -- So that MyAddon:OnMenuRequest will be called for menu contents population

		-- Define "OnMenuRequest" function, this is a must.
		function MyAddon:OnMenuRequest(level, value, menu)
			if level == 1 then
				menu:AddLine("text", "MyAddon", "isTitle", 1) -- Title line, not click-able
				menu:AddLine() -- An empty line
				menu:AddLine("text", UnitName("player"))
				menu:AddLine("text", "Party members", "hasArrow", 1, "value", "party") -- Mouse hovers this will open a sub-menu
				menu:AddLine("text", "Test edit", "hasEditBox ", 1) -- Editbox
				menu:AddLine("text", "Test slider", "hasSlider ", 1) -- Slider

			elseif level == 2 then
				if value == "party" then
					menu:AddLine("text", UnitName("party1")) -- Display names of all party members
					menu:AddLine("text", UnitName("party2"))
					menu:AddLine("text", UnitName("party3"))
					menu:AddLine("text", UnitName("party4"))
				end
			end
		end

		menu:Open() -- Show the dropdown menu at cursor position
	--]]

	---local DropDownMenus={};
	
	local MenusWinDows=true;
	
	local Sounds={};
	Sounds.open="MINIMAPOPEN";
	Sounds.close="MINIMAPCLOSE";
	Sounds.clicked="UChatScrollButton";
	Sounds.OpenSounds=false;
	
	Sounds.isopen=true;
	Sounds.isclose=true;
	Sounds.isclicked=true;
	Sounds.log=log(23);
	local OpenMenus={}; --外部菜单句柄
	GlobalMeunLevelIndex={}; -- 全局层数菜单对应索引
	
	local function GlobalLevel()
		
		local maxLevel=0;
		for k,v in pairs(GlobalMeunLevelIndex) do
			
		
			if v:IsShown() then
			
				maxLevel = math.max(maxLevel, v.GlobalLevel)
			end
		end
		
		return maxLevel;
				
	end
	
	
	
function MagicStoneScriptMenu(DROPDOWNMENU_NAME_PREFIX)
		
		local MeunLevel=0; --继承上级调用的菜单层数
		
		local MeunParentEx;
		
		local Frames={};
		
		

		local ArrowColorL={0.1, 1, 1, 0.3};
		local ArrowColorH={0, 1, 0, 1};

		local _FrameBackdropTitle = {
				bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
				edgeFile = "",
				tile = true, tileSize = 16, edgeSize = 0,
				insets = { left = 3, right = 3, top = 3, bottom = 0 }
			}
		
	--------------------------------------------------------------------------
	-- Library version
	--------------------------------------------------------------------------
	local MAJOR_VERSION = 1.0
	local MINOR_VERSION = 10023

	--------------------------------------------------------------------------
	-- Common variables & functions
	--------------------------------------------------------------------------
	--if type(AbinDropDownMenuIsNewerVersion) == "function" and not AbinDropDownMenuIsNewerVersion(MAJOR_VERSION, MINOR_VERSION) then return end
	--local DROPDOWNMENU_NAME_PREFIX = "AbinDropDownMenu" -- Menu name prefix
	local function GetDropDownMenu(level) return getglobal(DROPDOWNMENU_NAME_PREFIX.."Level"..(type(level) == "number" and level or 1)) end -- Acquire a menu level

	-- Table data recycling drastically reduces memory usage of your addon, at the cost of slightly slowing it down a bit, no big deal...
	local recycled = {}
	local function AcquireData() return tremove(recycled) or {} end
	local function ReleaseData(data) if type(data) == "table" then tinsert(recycled, wipe(data)) end end

	--------------------------------------------------------------------------
	-- DropDownMenu_GetHandle - Acquire a new DropDownMenu handle
	--------------------------------------------------------------------------
	
	local function CloseMenuEx(menu)
	
		local tbl={};
		
			
			local v = menu;
			local ok,w;
			
			for i=1,128 do
				
				local m ;
				if i==1 then
					m= menu.GetMeunParentEx();
				
				else
					if w then
						m = w.GetMeunParentEx();
						w=nil;
						
					end
				end
				
				if m then
						
						
						
												
						if OpenMenus[m:GetName()] then
						
							tbl[m:GetName()]=true;
							
							w=m;
						end
					
					
				else
					break;
				end
				
			
			end
			
		for k, data in pairs(OpenMenus) do	
		
			if not tbl[data:GetName()] then
				data:Hide();
			end
			
		end
		
	
	end
	
	
	local GetHandleEx=nil;

	local function DropDownMenu_GetHandleEx() return {

		------------------------------------------------------------------
		-- Public functions, you may call them all the time
		------------------------------------------------------------------
		ArrowHide = function(self,v1,level)
			
			local menu = GetDropDownMenu(level);
			if menu and menu.arrow then
				menu.arrow:Hide();
			end
			
		end,
		
		GetMenusWinDows = function(self)
			
			return MenusWinDows;
		end,
		
		SetMenusWinDows = function(self,value)
			
			MenusWinDows = value;
			
			for k, data in pairs(Frames) do
				
			
				if MenusWinDows then
				
					if not data.MenuCloseButton:IsShown() then
					
						data.MenuCloseButton:Show();
					end
					
				else
					
					if data.MenuCloseButton:IsShown() then
						data.MenuCloseButton:Hide();
					end
					
					
				end
			
			end
			
			return ;
		end,
		
		SetSounds = function(self,name,value)
			
			Sounds[name] = value;
			
			return ;
		end,
		
		GetSounds = function(self,name)
			
			return Sounds[name];
			
		end,
		
		SetSoundsDefault= function(self)
			
			Sounds.open="MINIMAPOPEN";
			Sounds.close="MINIMAPCLOSE";
			Sounds.clicked="UChatScrollButton";
			Sounds.OpenSounds=false;
			
			Sounds.isopen=true;
			Sounds.isclose=true;
			Sounds.isclicked=true;
			
		end,
		
		-- Check if a particular level of menu is opened by this instance, level is 1 if not specified
		IsOpen = function(self, level)
			local menu = GetDropDownMenu(level)
			return menu and menu:IsOwned(self)
		end,

		-- Open the menu level 1
		Open = function(self, point, relativeTo, relativePoint, xOffset, yOffset)
			local menu = GetDropDownMenu(1)
			if menu:SetAnchor(point, relativeTo, relativePoint, xOffset, yOffset) then
			
				return menu:Open(self)
			end
		end,
		
		OpenEx = function(self,...)
			local v1,v2,v3,v4,v5 = ...;
			local menu = GetDropDownMenu(1)
			
			if menu:IsShown() then
				menu:Hide();
			end
				
			if menu:SetAnchor(point, relativeTo, relativePoint, xOffset, yOffset) then
			
			Sounds = v4;
			MenusWinDows=v3;
			menu.ExternalData=v2;
			menu.ExternalMenu=v1;
			menu.ExOpenMenus = v5;
			
			
			GetHandleEx:SetMenusWinDows(MenusWinDows)
				
				
				return menu:Open(self)
			end
		end,

		-- Close a particular level of menu if it was opened by this instance, level is 1 if not specified
		Close = function(self, level)
			return self:IsOpen(level) and GetDropDownMenu(level):Hide()
		end,
		
		GetGlobalLevel = function(self, level)
			
			if level then
				local menu =GetDropDownMenu(level);
				if menu then
					return menu.GlobalLevel;
				end
				
			else
				
				
				return GlobalLevel();
			end
			
		end,
		
		
		GlobaClose = function(self, Globalevel,level,value)
		
			local index;
			if Globalevel then
				index=Globalevel;
			elseif level and value then
			
				index=self:GetGlobalLevel(level)
				if index then
					index = index + value;
				end
			else
				return;
			end
			
			local menu = GlobalMeunLevelIndex[index];
			
			if menu and menu:IsShown() then
				local level = menu:GetLevel();
				
				return menu:GetHandleEx():IsOpen(level) and menu:Hide();
			end
			
			
		end,
		
		GlobaRefresh = function(self, level)
		
			local name="";
			local dbf={};
			
			for k,v in pairs(GlobalMeunLevelIndex) do
			
				if k >= level and v:IsShown() then
					local c = v:GetMenuName();
					if c ~= name then
						name=c;
						
						local Level = v:GetLevel();
						
						v:GetHandleEx():Refresh(level);
					end
				end
				
			end
			
			local tbl={};
			
			local T={};
			
			for k,v in pairs(GlobalMeunLevelIndex) do
			
				if k >= level then
				
					local name = v:GetMenuName();
					local Level = v:GetLevel();
					
					if not tbl[name] then
						
						tbl[name]={}
						tbl[name]["Level"]=Level;
						tbl[name]["Meun"]=v;
						
						table.insert(T,name);
					else
					
						if tbl[name]["Level"]>Level then
							tbl[name]["Level"]=Level;
							tbl[name]["Meun"]=v;
						end
						
					end
				end
			end
			
			
			for k,v in pairs(T) do
			
				local menu = tbl[v]["Meun"];
				local level = tbl[v]["Level"];
				
				
				
				if menu and menu:IsShown() then
				
					if menu:GetHandleEx():IsOpen(level) then
						menu:GetName();
						menu:GetHandleEx():Refresh(level);
					end
				end
				
			end
			--]]
		end,
		

		-- Toggle show/hide stats of the root dropdown menu
		Toggle = function(self, point, relativeTo, relativePoint, xOffset, yOffset)
			if self:IsOpen(1) then
				self:Close(1)
			else
				self:Open(point, relativeTo, relativePoint, xOffset, yOffset)
			end
		end,

		-- Refresh the contents of a particular level of menu if it was opened by this instance, level is 1 if not specified
		Refresh = function(self, level)
			if level<=0 then
				level =1;
			end
			if self:IsOpen(level) then
				return GetDropDownMenu(level):Refresh(self)
			end
		end,

		-- Specify the function which is called when menu contents are requested.
		SetMenuRequestFunc = function(self, object, func)
			self.menuRequestObject, self.menuRequestFunc = nil
			if type(object) == "function" then
				self.menuRequestFunc = object
			elseif type(object) == "table" and (type(func) == "function" or type(func) == "string") then
				self.menuRequestObject, self.menuRequestFunc = object, func
			end
		end,

		-- Add a column header, this will make the menu displays as a table for formatted data
		AddColumnHeader = function(self, text, justifyH)
			if self.headerList then
				local data = AcquireData()
				data.text, data.justifyH = text, justifyH
				tinsert(self.headerList, data)
			end
		end,

		-- Add a menu line, see API documentation for arguments details
		AddLine = function(self, ...)
			if not self.infoList then
				return
			end

			local info = AcquireData()
			
			
			local COUNT = select("#", ...)
			local i, key, hasContents
			
			
			
			for i = 1, COUNT do
				local val = select(i, ...)
				if i % 2 == 0 then
					-- Even number: value
					
					
					if val ~= nil then -- "false" is also considered as a value!
						info[key] = val
						hasContents = 1
						if key == "line" then
							info["disabled"]=1;
							info["notCheckable"]=1;
						end
					end
					
					if key == "checked" then
						info[key] = val or false;
					end
					
					
				else
					-- Odd number: key
					if type(val) == "string" then
						key = val
					else
						break -- A key must be a string
					end
				end
			end
			
			--if info.checked_X and (info.isRadio or info.checked) then
			--	info.text_X=info.checked_X;
			--end
			
			
			if hasContents or self.hasContents then
				info.hasContents, self.hasContents = hasContents, hasContents
				tinsert(self.infoList, info)
				return 1
			else
			
				ReleaseData(info)
			end
		end,
	} end

	local function DropDownMenu_GetHandle()
		GetHandleEx = DropDownMenu_GetHandleEx();
		return GetHandleEx;
	end
	--------------------------------------------------------------------------
	-- Local utility variables & functions
	--------------------------------------------------------------------------
	local DROPDOWNMENU_GUID = "{FA9471E6-1E60-4D7A-B07C-7B2119DFDD91"..DROPDOWNMENU_NAME_PREFIX.."}" -- Library guid
	local DROPDOWNMENU_INSET_HORIZONTAL = 12 -- Menu horizontal edge size
	local DROPDOWNMENU_INSET_VERTICAL = 15 -- Menu vertical edge size
	local DROPDOWNMENU_BUTTON_HEIGHT = 18 -- Menu button height
	local DROPDOWNMENU_HEADER_HEIGHT = 20 -- Menu header height
	local DROPDOWNMENU_BUTTON_WIDTH_MIN = 50 -- 120 Menu button minimum width
	local DROPDOWNMENU_SEPARATOR_HEIGHT = 6 -- Menu separator height
	local DROPDOWNMENU_TEXT_INSET = 2 -- Menu text inset
	local DROPDOWNMENU_COLUMN_SPACING = 6 -- Menu column spacing
	local DROPDOWNMENU_FRAME_SPACING = 7 -- Menu frame spacing
	local DROPDOWNMENU_RIGHT_EXTRA = 6 -- If none of the menu buttons has arrow or color swatch, append this extra space to the right edge
	local DROPDOWNMENU_EDITBOX_WIDTH = 150

	local function NOOP() end

	-- Verify a number
	local function VerifyMenuNumber(number)
		return type(number) == "number" and number or 1
	end

	-- Retrieve the EditBox frame
	local function GetEditBoxMenu()
		return getglobal(DROPDOWNMENU_NAME_PREFIX.."EditBoxFrame")
	end

	-- Retrieve the Slider frame
	local function GetSliderMenu()
		return getglobal(DROPDOWNMENU_NAME_PREFIX.."SliderFrame")
	end

	-- Close our menu
	local function CloseOurMenu(level)
		level = VerifyMenuNumber(level)
		local menu = GetDropDownMenu(level)
		if menu and menu:IsShown() then
			menu:Hide()
			return 1
		end

		menu = GetEditBoxMenu()
		if menu and menu:IsShown() and menu:GetLevel() == level then
			menu:Hide()
			return 1
		end

		menu = GetSliderMenu()
		if menu and menu:IsShown() and menu:GetLevel() == level then
			menu:Hide()
			return 1
		end
	end

	-- Safely invike a function
	local function SafeCall(info, prefix, ...)

		
		
		if not info then
			return
		end

		local func = info[prefix and prefix.."Func" or "func"]
		
		
		
		local a1 = info[prefix and prefix.."Arg1" or "arg1"]
		local a2 = info[prefix and prefix.."Arg2" or "arg2"]
		
		if type(func) ~= "function" then
			if type(a1) == "table" and type(func) == "string" then
				func = a1[func]
				
				if type(func) ~= "function" then
					return
				end
				
			else
				return
			end
		end

		if a1 ~= nil and a2 ~= nil then
			return func(a1, a2, ...)
		elseif a1 ~= nil then
			return func(a1, ...)
		else
			return func(...)
		end
	end

	local function CreateMenuFontString(owner, template, justifyH, justifyV)
		local fs = owner:CreateFontString(nil, "ARTWORK", template or "GameFontHighlightSmall")
		fs:SetFont(STANDARD_TEXT_FONT, (UIDROPDOWNMENU_DEFAULT_TEXT_HEIGHT or 10))

		if justifyH then
			fs:SetJustifyH(justifyH)
		end

		if justifyV then
			fs:SetJustifyV(justifyV)
		end
		return fs
	end

	local function GetCurrentColor(hasOpacity)
		local r, g, b = ColorPickerFrame:GetColorRGB()
		local a = hasOpacity and OpacitySliderFrame:GetValue() or nil
		return r, g, b, a
	end

	-- Validate text settings
	local function ValidateTextInfo(text, justifyH, r, g, b, colorCode, isTitle, disabled)
		if not text then
			return nil, "LEFT", HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b
		end

		text = tostring(text)
		justifyH = strupper(tostring(justifyH))
		if justifyH ~= "CENTER" and justifyH ~= "RIGHT" then
			justifyH = "LEFT"
		end

		-- disabled(grey) has the highest priority, if a button is disabled it's always grey
		if disabled then
			r, g, b = GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b
		else
			-- RGB priority is lower than disabled
			r = type(r) == "number" and math.min(1, math.max(0, r)) or nil
			g = r and type(g) == "number" and math.min(1, math.max(0, g)) or nil
			b = g and type(b) == "number" and math.min(1, math.max(0, b)) or nil
		end

		-- colorCode priority is lower than RGB
		colorCode = not r and type(colorCode) == "string" and strlower(colorCode) or nil
		if colorCode then
			local _, _, code = strfind(colorCode, "^|c(%x+)$")
			if not code or strlen(code) ~= 8 then
				colorCode = nil
			end
		end

		-- isTitle(yellow) priority is lower than colorCode
		if isTitle and not disabled and not r and not colorCode then
			r, g, b = NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b
		end

		-- If not color specified whatsoever, use default
		if not r and not colorCode then
			r, g, b = HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b
		end

		return text, justifyH, r, g, b, colorCode
	end

	-- Validate information passed from DropDownMenu:AddLine(...)
	local function ValidateInfo(info)
		-- data validation
		info.disabled = info.disabled or not info.hasContents -- need to grey out the entire button, must be boolean not nil nil
		info.notClickable = info.notClickable or info.isTitle or info.disabled or nil

		if info.notCheckable then
			info.checked = nil
			info.isRadio = nil
			info.icon = nil
			info.iconR = nil
		end

		if info.isRadio or info.checked then
			info.icon = nil
			info.iconR = nil
		end

		info.icon = type(info.icon) == "string" and info.icon or nil
		if info.icon and not info.tCoordLeft and strfind(strupper(info.icon), strupper("^Interface\\Icons\\")) then
			info.tCoordLeft, info.tCoordRight, info.tCoordTop, info.tCoordBottom = 0.08, 0.92, 0.08, 0.92
		end

		info.iconWidth = type(info.iconWidth) == "number" and math.max(1, info.iconWidth) or 16
		info.iconHeight = type(info.iconHeight) == "number" and math.max(1, info.iconHeight) or 16

		if not info.icon then
			info.iconR = type(info.iconR) == "number" and math.min(1, math.max(0, info.iconR)) or nil
			info.iconG = info.iconR and type(info.iconG) == "number" and math.min(1, math.max(0, info.iconG)) or nil
			info.iconB = info.iconG and type(info.iconB) == "number" and math.min(1, math.max(0, info.iconB)) or nil
		end

		if info.hasColorSwatch then
			info.r = type(info.r) == "number" and math.min(1, math.max(0, info.r)) or 0
			info.g = info.r and type(info.g) == "number" and math.min(1, math.max(0, info.g)) or 0
			info.b = info.g and type(info.b) == "number" and math.min(1, math.max(0, info.b)) or 0
			info.opacity = type(info.opacity) == "number" and math.min(1, math.max(0, info.opacity)) or nil
		end

		info.hasArrow = info.hasArrow or info.hasEditBox or info.hasSlider -- if any one of hasEditBox and hasSlider is true, hasArrow should become true automatically, "DewDrop" seems stupid on this one...
		info.hasEditBox = info.hasEditBox and not info.disabled
		info.hasSlider = info.hasSlider and not info.hasEditBox and not info.disabled -- if hasEditBox is true, do not allow a slider to show together
		if info.hasSlider then
			info.sliderMin = type(info.sliderMin) == "number" and info.sliderMin or 0
			info.sliderMax = math.max(info.sliderMin, type(info.sliderMax) == "number" and info.sliderMax or 1)
			info.sliderValue = math.min(info.sliderMax, math.max(info.sliderMin, type(info.sliderValue) == "number" and info.sliderValue or 0))
			info.sliderStep = type(info.sliderStep) == "number" and math.max(0.0001, info.sliderStep) or 1
			info.sliderDecimals = type(info.sliderDecimals) == "number" and math.max(0, info.sliderDecimals) or nil
		end
	end

	local colorInfo = {}
	local function OnColorPickSelect()
		SafeCall(colorInfo, "swatch", GetCurrentColor(colorInfo.hasOpacity))
	end

	local function OnColorPickCancel()
		SafeCall(colorInfo, "swatch", colorInfo.r, colorInfo.g, colorInfo.b, colorInfo.opacity)
	end

	local function MenuButton_Swatch_OnClick(self)
		local info = self:GetParent().info
		if info.disabled then
			return
		end

		colorInfo.swatchFunc, colorInfo.swatchArg1, colorInfo.swatchArg2, colorInfo.r, colorInfo.g, colorInfo.b, colorInfo.opacity, colorInfo.hasOpacity = info.swatchFunc, info.swatchArg1, info.swatchArg2, info.r, info.g, info.b, info.opacity, info.hasOpacity
		CloseOurMenu(1)

		ColorPickerFrame.hasOpacity = colorInfo.hasOpacity
		ColorPickerFrame.opacity = colorInfo.opacity
		ColorPickerFrame:SetColorRGB(colorInfo.r, colorInfo.g, colorInfo.b)
		ColorPickerFrame.func = OnColorPickSelect
		ColorPickerFrame.opacityFunc = OnColorPickSelect
		ColorPickerFrame.cancelFunc = OnColorPickCancel
		ShowUIPanel(ColorPickerFrame)
	end

	local function MenuButton_Swatch_OnEnter(self)
		local menu = self:GetParent():GetParent()
		menu:StopCounting()
		CloseOurMenu(menu:GetLevel() + 1)
		if not self:GetParent().info.disabled then
			self.bkgnd:SetVertexColor(NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b)
		end
	end

	local function MenuButton_Swatch_OnLeave(self)
		self:GetParent():GetParent():StartCounting()
		if not self:GetParent().info.disabled then
			self.bkgnd:SetVertexColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b)
		end
	end

	-- Data for the confirm dialog
	local confirmInfo = {}
	local confirmData = {
		timeout = 0,
		whileDead = 1,
		hideOnEscape = 1,
		OnAccept = function() SafeCall(confirmInfo) end
	}

	StaticPopupDialogs[DROPDOWNMENU_GUID] = confirmData
	
	local function AdjustPosition_Ex(memenu,button,subMenu)
		
		local width, leftSpace, rightSpace = memenu:GetWidth(), button:GetLeft(), GetScreenWidth() - button:GetRight()
		local directionH
		if memenu:GetLevel() == 2 then
			directionH = (leftSpace > rightSpace * 2.5 or (rightSpace < width and leftSpace >= width)) and "LEFT" or "RIGHT"
		else
			directionH = subMenu:GetParent():GetDirectionH()
			if directionH == "RIGHT" then
				if rightSpace < width then
					directionH = "LEFT"
				end
			else
				if leftSpace < width then
					directionH = "RIGHT"
				end
			end
		end


		memenu.directionH = directionH
		local pointH = directionH == "LEFT" and "RIGHT" or "LEFT"
		local point, relativePoint = pointH, directionH
		local x = directionH == "LEFT" and -DROPDOWNMENU_FRAME_SPACING or DROPDOWNMENU_FRAME_SPACING
		local y = 0

		if not memenu.subControlType then
			local height, topSpace, bottomSpace = memenu:GetHeight(), GetScreenHeight() - button:GetTop(), button:GetBottom()
			local directionV = (bottomSpace < height and topSpace >= height) and "TOP" or "BOTTOM"
			memenu.directionV = directionV
			local pointV = directionV == "TOP" and "BOTTOM" or "TOP"
			point, relativePoint = pointV..pointH, pointV..directionH
			y = directionV == "TOP" and -(DROPDOWNMENU_INSET_VERTICAL + DROPDOWNMENU_BUTTON_HEIGHT / 2) or (DROPDOWNMENU_INSET_VERTICAL + DROPDOWNMENU_BUTTON_HEIGHT / 2)
		end

		memenu:ClearAllPoints()
		memenu:SetPoint(point, button, directionH, x, y)

	end
	
	local function SetGameTooltip(self,info,direction)
	
		
		GameTooltip:SetOwner(self, direction == "RIGHT" and "ANCHOR_LEFT" or "ANCHOR_RIGHT")
		GameTooltip:ClearLines()
		
		if info and info.Spell then
			local name,_,Texture = GetSpellInfo(info.Spell);
			local spellLink,_=GetSpellLink(info.Spell);
			--GameTooltip:AddSpellByID(info.Spell);
			GameTooltip:SetSpellByID(info.Spell);
			local text = GameTooltipTextLeft1:GetText()
			if text then
			
				GameTooltipTextLeft1:SetText("|T" ..Texture..":24|t "..text);
			end
			GameTooltip:AddLine(" ");
			GameTooltip:AddLine("Id:" .. info.Spell,1,1,1,1)
			
		end
		
		if info and info.Item then
			--local name,_,Texture = GetItemInfo(info.Item);
			--local spellLink,_=GetSpellLink(info.Item);
			local name, link, quality, iLevel, reqLevel, class, subclass, maxStack, equipSlot, Texture, vendorPrice = GetItemInfo(info.Item);
			--GameTooltip:AddSpellByID(info.Item);
			GameTooltip:SetItemByID(info.Item);
			--GameTooltip:SetHyperlink(link);
			local text = GameTooltipTextLeft1:GetText()
			if text then
			
				GameTooltipTextLeft1:SetText("|T" ..Texture..":24|t "..text);
			end
			
			GameTooltip:AddLine(" ");
			GameTooltip:AddLine("Id:" .. info.Item,1,1,1,1)
		
			
		end
		
		if info and info.PetSpell then
			GameTooltip:SetPetAction(info.PetSpell);
			
			local name, subtext, Texture, isToken, isActive, autoCastAllowed, autoCastEnabled = GetPetActionInfo(info.PetSpell);
			local text = GameTooltipTextLeft1:GetText()
			local spellName, spellRank, spellID = GameTooltip:GetSpell()
			if spellID then
			
				GameTooltipTextLeft1:SetText("|T" ..Texture..":24|t "..text);
				GameTooltip:AddLine(" ");
				GameTooltip:AddLine("Id:" .. spellID,1,1,1,1)
			end
		
			
		end
		
		
	 --rL [, gL [, bL [, rR [, gR [, bR]]]]]])

		--GameTooltip:AddDoubleLine("Left", "Right", 1,0,0, 0,0,1);
		if info and info.tooltipTitle and  not info.Spell and not info.Item then
			GameTooltip:AddLine(info.tooltipTitle);
		end

		if info and info.tooltipText then
			
			if type(info.tooltipText) == "table" then
				
				for i,v in pairs(info.tooltipText) do
					
					if v["type"]=="AddDoubleLine" then
					
						GameTooltip:AddDoubleLine(v["left"],v["right"],v.rL, v.gL, v.bL, v.rR, v.gR, v.bR);
					
					elseif v["type"]=="AddLine" then
						GameTooltip:AddLine(v["text"], v.r, v.g, v.b, 1);
					end
					
				end
				
			else
				GameTooltip:AddLine(info.tooltipText, 1, 1, 1, 1)
			end
		end
		
		

		SafeCall(info, "tooltip")
		GameTooltip:Show()
		
	end
	
	
	
	
	
	
	
	local function MenuButton_OnClick_Ex(self)
		local info = self.info
		if info.notClickable then --or (MenusWinDows and not self.IsOld_highlightTextureH) then
			return -- not clickable
		end
		
		
		
		if info.hasConfirm then
			StaticPopup_Hide(DROPDOWNMENU_GUID)
			confirmData.text = info.confirmText or info.text or info.text1
			confirmData.button1 = info.confirmButton1 or OKAY
			confirmData.button2 = info.confirmButton2 or CANCEL
			confirmInfo.func, confirmInfo.arg1, confirmInfo.arg2 = info.func, info.arg1, info.arg2
			
			StaticPopup_Show(DROPDOWNMENU_GUID):SetFrameStrata("TOOLTIP");
			
			
		else
			
			
			if info.checked==nil or IsControlKeyDown() or IsAltKeyDown() or IsShiftKeyDown() then
		
				SafeCall(info);
			end
			
		end

		if info.closeWhenClicked then
		
			self:GetParent():Hide()
		end
		
		--if Sounds.OpenSounds and not MenusWinDows and Sounds.isclicked then
		
		if Sounds.OpenSounds and Sounds.isclicked then
			PlaySound(Sounds.clicked)
		end
		
	end
	
	local function MenuButton_OnClick(self)
		
		--if not MenusWinDows or IsControlKeyDown() or IsAltKeyDown() or IsShiftKeyDown() then
			MenuButton_OnClick_Ex(self);
		--end
	end
	
	
	
	local function MenuButton_OnEnter(self)
		
		
		local menu = self:GetParent()
		local level = menu:GetLevel()
		local owner = menu:GetOwner()
		local info = self.info
		local direction = "RIGHT"
		
		if info and info.line then
			return;
		end
		
		if info and info.Key then
			
			self:SetScript("OnKeyDown", function(self,Button)
				
			SafeCall(info,"Key",self,Button);
			end);
		end
		
		if MenusWinDows and not self.LeftButton and not self.RightButton then
		
			if not info.disabled then
				if not info.notClickable then
					local texture = self.highlightTexture
					if texture:GetParent() ~= self then
						texture:SetParent(self)
						texture:ClearAllPoints()
						texture:SetAllPoints(self)
					end
					texture:Show()
				end
			end
			
			if true or IsControlKeyDown() then
				local temp =GetDropDownMenu(level+1);
				if temp then
					if temp:IsShown() then
						direction = temp:GetDirectionH();
					end
					
				end
				
				if self.OpenMemuEx and self.OpenMemuEx:IsShown() then
					direction = self.OpenMemuEx:GetDirectionH();
				end
				
				
				GameTooltip:SetOwner(self, direction == "RIGHT" and "ANCHOR_LEFT" or "ANCHOR_RIGHT")
				GameTooltip:ClearLines()
				SetGameTooltip(self,info,direction);
				
			end
			
			return;
			
		end
		
		
		if info and not info.disabled and not info.notClickable then
		
			--关闭上个窗口
			GetHandleEx.GlobaClose(GetHandleEx,false,level,1)
						
		--print(111)
		
		--清除高亮条
		
			if not menu.highlightTextureH then
				menu.highlightTextureH = self.highlightTextureH;
				menu.highlightTexture_text=info.text;
				
			end
			
			if menu.highlightTextureH ~= self.highlightTextureH then
				menu.highlightTextureH:Hide();
				menu.highlightTextureH = self.highlightTextureH;
				menu.highlightTexture_text=info.text;
				
				self.highlightTextureH:Show();
				
			end
			
			if not self.highlightTextureH:IsShown() then
				if menu.highlightTextureH:IsShown() then
					menu.highlightTextureH:Hide();
				end
				self.highlightTextureH:Show();
			end
			
			
			
			if not menu.arrow and info.hasArrow then
				menu.arrow = self.arrow;
			end
			
			if menu.arrow ~= self.arrow  and info.hasArrow then
				
				menu.arrow:SetVertexColor(ArrowColorL[1],ArrowColorL[2],ArrowColorL[3],ArrowColorL[4]);
				menu.arrow = self.arrow;
				self.arrow:SetVertexColor(ArrowColorH[1],ArrowColorH[2],ArrowColorH[3],ArrowColorH[4]);
			end
			
			-------------------
			
			if not menu.CloseButton then
				menu.CloseButton = self.CloseButton;
			end
			
			if menu.CloseButton ~= self.CloseButton then
				if menu.CloseButton:IsShown() then
					menu.CloseButton:Hide();
				end;
				menu.CloseButton = self.CloseButton;
				if info.CloseButtonFunc and not self.CloseButton:IsShown() then
					self.CloseButton:Show();
				end
				
			end
			
			if not self.CloseButton:IsShown() then
				if menu.CloseButton:IsShown() then
					menu.CloseButton:Hide();
				end
				if info.CloseButtonFunc then
					self.CloseButton:Show();
				end
			end
			---------------
		
		end
		
		
			
	
		
	
		
		
	
		
		menu.mouseover = self
		CloseOurMenu(level + 1)
		menu:StopCounting();

		
		if info and not info.disabled  and not self.RightButton then
			if not info.notClickable then
				local texture = self.highlightTexture
				if texture:GetParent() ~= self then
					texture:SetParent(self)
					texture:ClearAllPoints()
					texture:SetAllPoints(self)
				end
				
				texture:Show()
			end

			local subMenu
			if info.hasEditBox then
				subMenu = GetEditBoxMenu()
			elseif info.hasSlider then
				subMenu = GetSliderMenu()
			elseif info.hasArrow then
				
				menu.MenuEx=false;
			
				if info.OpenMenu and info.OpenMenuValue then
					local subMenu = menu:CreateSubMenu();
					direction = subMenu:GetDirectionH();
					subMenu:Hide();
						--info.OpenMenu.GetBuff_Tbl=info.OpenMenuValue;
						
					local _,memenu = info.OpenMenu:OpenEx(self,info.OpenMenuValue,MenusWinDows,Sounds,GetDropDownMenu(1));
					
					
					
					----DropDownMenus.memenu=memenu;
					menu.MenuEx=memenu;
					
					self.OpenMemuEx =memenu;
					
					local button = self;
					
					AdjustPosition_Ex(memenu,button,subMenu);
								
				else
					subMenu = menu:CreateSubMenu()
				end
				
			end

			if subMenu then
				subMenu:SetInfo(info)
				subMenu:Open(owner, info.value, self, level)
				direction = subMenu:GetDirectionH()
			end
		end
		if self.OpenMemuEx and self.OpenMemuEx:IsShown() then
			direction = self.OpenMemuEx:GetDirectionH();
		end
		
		SetGameTooltip(self,info,direction);
		
	end

	local function MenuButton_OnLeave(self)
		
		
		
		if self:GetScript("OnKeyDown") then
		
			self:SetScript("OnKeyDown", nil);
		end
		
		self:GetParent().mouseover = nil
		if GameTooltip:IsOwned(self) then
			GameTooltip:Hide()
		end

		local texture = self.highlightTexture
		if texture:GetParent() == self then
			texture:Hide()
		end
		
		self:GetParent():StartCounting()
	end
	
	local function CheckButton_OnLeave(self)
		
		
		local b = self:GetParent();
		
		if b:GetScript("OnKeyDown") then
		
			b:SetScript("OnKeyDown", nil);
		end
		
		b:GetParent().mouseover = nil
		if GameTooltip:IsOwned(b) then
			GameTooltip:Hide()
		end

		local texture = b.highlightTexture
		if texture:GetParent() == b then
			texture:Hide()
		end
		
		b:GetParent():StartCounting()
	end
	
	local function CheckButton_OnEnter(self)
		
		local b = self:GetParent();
		--[[
		local info = b.info
		
		if not info.disabled then
			if not info.notClickable then
				local texture = b.highlightTexture
				if texture:GetParent() ~= b  then
					texture:SetParent(b)
					texture:ClearAllPoints()
					texture:SetAllPoints(b)
				end
				texture:Show()
			end
		end
		--]]
		
		if MenusWinDows then
		MenuButton_OnEnter(b);
		end
		
	end
	
	
	
	
	local function MenuButton_OnMouseDown(self,button)
		
		local menu = self:GetParent()
		local level = menu:GetLevel()
		local owner = menu:GetOwner()
		local info = self.info
		local direction = "RIGHT"
		
		
		
		--if MenusWinDows and button == "LeftButton" then
		
		if button == "LeftButton" then
			--self.IsOld_highlightTextureH=self.highlightTextureH:IsShown();
			self.LeftButton=true;
			MenuButton_OnEnter(self);
			self.LeftButton=false;
		
		elseif button == "RightButton" then
		
			--self.IsOld_highlightTextureH=self.highlightTextureH:IsShown();
			self.RightButton=true;
			MenuButton_OnEnter(self);
			self.RightButton=false	
			
			if info.OpenRightMenu then
				
				
			
				local subMenu = menu:CreateSubMenu();
				direction = subMenu:GetDirectionH();
				subMenu:Hide();
				
				local _,memenu = info.OpenRightMenu:OpenEx(self,info.OpenRightMenuValue,MenusWinDows,Sounds,GetDropDownMenu(1));
			
				----DropDownMenus.memenu=memenu;
				menu.MenuEx=memenu;
				
				self.OpenMemuEx =memenu;
				
				local button = self;
				
				AdjustPosition_Ex(memenu,button,subMenu);
		
			end
			
		end
	end
	
	local function CheckButton_OnClick(self,button)
	
		local info = self:GetParent().info
		
		if not info.disabled then
			if not info.notClickable then		
				SafeCall(info);
			end
		end
		
		MenuButton_OnMouseDown(self:GetParent(),button)
		
	end

	local function MenuButton_HideAllFS(self)
		local fs
		for _, fs in ipairs(self.fontStrings) do
			fs:Hide()
		end
	end

	local function MenuButton_OnHide(self)
		self:Hide()
		MenuButton_HideAllFS(self)
		
		if self.infid and self.infid == amGlowBoxWidget.Id then
			
			amGlowBoxWidget.GlowBox:Hide();
		end
		
		self.info = nil
		
	end

	local function MenuButton_GetFS(self, id)
		local fs = self.fontStrings[id or 1]
		if not fs then
			fs = CreateMenuFontString(self)
			tinsert(self.fontStrings, fs)
			
			fs.RightString = CreateMenuFontString(self);
			
						
			
		end
		
		--print(fs.SetPoint)
		return fs
	end

	local function MenuButton_SetText(self, id, text, justifyH, r, g, b, colorCode, isTitle, disabled)
		local fs = MenuButton_GetFS(self, id)
		text, justifyH, r, g, b, colorCode = ValidateTextInfo(text, justifyH, r, g, b, colorCode, isTitle, disabled)
		if text and colorCode then
			fs:SetText(colorCode..text.."|r")
		else
			fs:SetText(text)
		end

		fs:SetJustifyH(justifyH)
		fs:SetTextColor(r, g, b)
		
		local menu = self:GetParent()
		local info = self.info
		local w =0;
		if info and info.RightText then
			fs.RightString:SetText(info.RightText)
			w=8;
		else
			fs.RightString:SetText(nil)
		end
		
		fs.RightString:SetPoint("RIGHT",self,"RIGHT",-22,0)
		fs.RightString:SetJustifyH("RIGHT");
		
		return math.ceil(fs:GetWidth()) + math.ceil(fs.RightString:GetWidth()) + w +  DROPDOWNMENU_TEXT_INSET, text
	end

	local function MenuButton_CloseButton_OnClick(self,info)
		
		
		SafeCall(self.info,"CloseButtonFun");
		

	end

	-- Use the info table to initialize a button
	local function MenuButton_SetInfo(self, info, header)
		ValidateInfo(info)
		self.info = info
		local menu = self:GetParent();
		local level = menu:GetLevel();
		--[[
		if info.Key then
			
			self:SetScript("OnKeyDown", function(self,Button)
				
			SafeCall(info,"Key",self,Button);
			end);
			
		else
			self:SetScript("OnKeyDown", nil)
		end
		
		--]]
		

		
		
		if info.isRadio then
			self.radioBg:Show()
			self.check:SetTexture("Interface\\Buttons\\UI-RadioButton")
			self.check:SetTexCoord(0.25, 0.49, 0, 1)
			self.check:SetWidth(16)
			self.check:SetHeight(16)
			self.check:SetAlpha(1);
		else
			self.radioBg:Hide()
			
			if info.checked then
				self.check:SetTexture("Interface\\Buttons\\UI-CheckBox-Check")
				self.check:SetAlpha(1);
			elseif info.checked==false then
				self.check:SetTexture("Interface\\Buttons\\UI-CheckBox-Check-Disabled")
				self.check:SetAlpha(0.3);
			end
			self.check:SetTexCoord(0, 1, 0, 1)
			self.check:SetWidth(24)
			self.check:SetHeight(24)
			
			
			
			
			
		end
		
		
		
		if info.checked_X then
		
			self.radioBg:SetPoint("CENTER", self, "LEFT", 10 + info.checked_X , 0);
			self.check:SetPoint("CENTER", self, "LEFT", 10 + info.checked_X , 0);
			self.CheckButton:SetPoint("CENTER", self, "LEFT", 10 + info.checked_X , 0);
		else
			self.radioBg:SetPoint("CENTER", self, "LEFT", 10, 0);
			self.check:SetPoint("CENTER", self, "LEFT", 10, 0);
			self.CheckButton:SetPoint("CENTER", self, "LEFT", 10, 0)
		end
		
		if info.line or info.checked==nil or info.disabled or info.notClickable then
		
			self.CheckButton:Hide();
			
		else
			self.CheckButton:Show();
		end
		
		

		if type(info.checked) == "function" then
			info.checked = info.checked()
		end

		if info.checked or (info.checked==false and not info.isRadio) then
			self.check:Show()
		else
			self.check:Hide()
		end

		if info.icon then
			self.icon:SetTexture(info.icon)
			if info.iconR then
				self.icon:SetVertexColor(info.iconR, info.iconG, info.iconB)
			else
				self.icon:SetVertexColor(1, 1, 1)
			end

			if info.tCoordLeft then
				self.icon:SetTexCoord(info.tCoordLeft, info.tCoordRight, info.tCoordTop, info.tCoordBottom)
			else
				self.icon:SetTexCoord(0, 1, 0, 1)
			end

		elseif info.iconR then
			self.icon:SetTexture(info.iconR, info.iconG, info.iconB)
			self.icon:SetVertexColor(1, 1, 1)
			self.icon:SetTexCoord(0, 1, 0, 1)
		end

		if info.icon or info.iconR then
			self.icon:SetWidth(info.iconWidth)
			self.icon:SetHeight(info.iconHeight)
			self.icon:Show()
		else
			self.icon:Hide()
		end

		if info.hasArrow then
			self.arrow:Show()
		else
			self.arrow:Hide()
		end

		if info.hasColorSwatch then
			if info.disabled then
				self.colorSwatch.bkgnd:SetTexture(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b)
			else
				self.colorSwatch.bkgnd:SetTexture(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b)
			end
			self.colorSwatch.texture:SetVertexColor(info.r, info.g, info.b)
			self.colorSwatch:Show()
		else
			self.colorSwatch:Hide()
		end

		self.icon:SetDesaturated(info.disabled)
		self.check:SetDesaturated(info.disabled)
		self.radioBg:SetDesaturated(info.disabled)
		self.arrow:SetDesaturated(info.disabled)

		if info.notClickable then
			self:SetPushedTextOffset(0, 0)
		else
			self:SetPushedTextOffset(1, -1)
		end

		local textWidth = 0
		if #header > 0 then
			if not info.text1 then
				info.text1 = info.text
			end

			local i
			for i = 1, #header do
			
				local width = MenuButton_SetText(self, i, info["text"..i], header[i].justifyH, info["text"..i.."R"], info["text"..i.."G"], info["text"..i.."B"], info["colorCode"..i], info.isTitle, info.disabled) + DROPDOWNMENU_COLUMN_SPACING
				if width > (header[i].width or 0) then
					header[i].width = width
				end
			end
		else
			if not info.text then
				info.text = info.text1
			end
		
			textWidth = MenuButton_SetText(self, 1, info.text, info.justifyH, info.textR, info.textG, info.textB, info.colorCode, info.isTitle, info.disabled)
		end

		local leftExtra, swatchWidth, arrowWidth = 0, 0, 0
		if not info.notCheckable and (info.text or info.text1) then
			leftExtra = 22
		end

		if info.hasColorSwatch then
			swatchWidth = 20
		end

		if info.hasArrow then
			arrowWidth = 20
		end
		
		if info.infchecked and info.inftitle then
			amCreateGlowBoxWidget(info.infid,self,info.inftitle,info.inftext,info.infx,info.infy,info.infwidth,info.infheight);
		end
		
		if info.CloseButtonFunc then
		
			self.CloseButton:SetScript("OnClick", function() 
				if info.CloseButtonFront then
					
					local v = info.CloseButtonFront;
					
					if type(v) == "number" then
						GetHandleEx.GlobaClose(GetHandleEx,v);
						
					elseif type(v) == "table" then
						
						v[1][v[2]]=v[3];
					
					elseif type(v) == "function" then
						v();
					end
					
				end
				SafeCall(info,"CloseButton")
			end);
			
			
			
		else
			self.CloseButton:Hide();
		end
		
		
		
			
		
		local height;
		
		if info.line then
			height = info.LineHeight or DROPDOWNMENU_SEPARATOR_HEIGHT/2;
		else

		height = info.hasContents and DROPDOWNMENU_BUTTON_HEIGHT or DROPDOWNMENU_SEPARATOR_HEIGHT
		
		end
		
		--print(info.LineBrightness,info.LineHeight)
		
		self:SetHeight(height)
		
			
				
		if info.line then
			
			
			if not self.line then
			
				
				self.line = self:CreateTexture(nil, "BORDER")
				
				local LineY = info.LineY or 0;
				self.line:SetPoint("LEFT",self,"TOPLEFT",0,height/2*-1 + LineY );
				self.line:SetPoint("RIGHT",self,"RIGHT")
				
				self.line:SetTexture("Interface\\QuestFrame\\UI-QuestTitleHighlight")
				self.line:SetBlendMode("ADD")
				self.line:SetHeight(1);
				
				
			end
				
				self.line:SetVertexColor(1, 1, 1, info.LineBrightness or 0.15)			
			--self.line:SetBackdropBorderColor(0.75, 0.75, 0.75, info.LineBrightness or 0.15);
			
			if not self.line:IsShown() then
				self.line:Show();
			end
		else
			
			if self.line then
				
				if self.line:IsShown() then
					self.line:Hide();
				end
				
			end
			
			
		end
		
	-- Toggle Button
	
		if info.ToggleButton then
			
			if not self.ToggleButton then
			
				local toggleBtn = CreateFrame("Button","ToggleBtn",self,'UIPanelCloseButton')
				toggleBtn.Visible = false
				toggleBtn:SetWidth(16)
				toggleBtn:SetHeight(16)
				toggleBtn:SetPoint("TOPLEFT", self, "TOPLEFT", 3, - 2)

				toggleBtn:SetNormalTexture("Interface\\Buttons\\UI-PlusButton-UP")
				toggleBtn:SetPushedTexture("Interface\\Buttons\\UI-PlusButton-DOWN")
				toggleBtn:SetHighlightTexture("Interface\\Buttons\\UI-PlusButton-Hilight")
				local t = toggleBtn:GetHighlightTexture()
				t:SetBlendMode("ADD");
				
				toggleBtn:SetScript("OnClick", function(self) 
					local Btn = self:GetParent()
					if Btn.info.ToggleButtonFun then
						local temp = menu.highlightTextureH and menu.highlightTextureH:Hide();
						CloseOurMenu(level + 1)
						GetHandleEx.GlobaClose(GetHandleEx,menu.GlobalLevel+1);
						Btn.info.ToggleButtonFun();
					end
					
				end);
				
				self.ToggleButton=toggleBtn;
			end
			
				
			
			
			if info.ToggleState then
				
				self.ToggleButton:SetNormalTexture("Interface\\Buttons\\UI-PlusButton-UP")
				self.ToggleButton:SetPushedTexture("Interface\\Buttons\\UI-PlusButton-DOWN")
			
			else
				self.ToggleButton:SetNormalTexture("Interface\\Buttons\\UI-MinusButton-UP")
				self.ToggleButton:SetPushedTexture("Interface\\Buttons\\UI-MinusButton-DOWN")
			end
			
			if not self.ToggleButton:IsShown()then
				self.ToggleButton:Show();
			end
			
			
			local ToggleX,ToggleY
			if info.line then
				ToggleX= (info.ToggleX or 0) + -5;
				ToggleY= (info.ToggleY or 0) + 3;
			else
				ToggleX = info.ToggleX or 0;
				ToggleY = info.ToggleY or 0;
			end
			
			self.ToggleButton:SetPoint("TOPLEFT", self, "TOPLEFT", 3 + ToggleX, - 2 + ToggleY);
			
			
			
		else
			
			if self.ToggleButton and self.ToggleButton:IsShown()then
				self.ToggleButton:Hide();
			end
		end
		
		if info.text_X then
			textWidth = textWidth+info.text_X;
		end	
		
		
		--print(self.highlightTextureH:IsShown(),info.line)
		if self.highlightTextureH:IsShown() then
		
			if info.disabled or info.notClickable or info.line then
				self.highlightTextureH:Hide();
				menu.highlightTextureH=nil;
				menu.highlightTexture_text=nil;
				CloseOurMenu(level + 1)
				GetHandleEx.GlobaClose(GetHandleEx,menu.GlobalLevel+1);
			end
		end
		--[[
		if self.highlightTextureH:IsShown() then
			
			if info.text ~= menu.highlightTexture_text then
				
				self.highlightTextureH:Hide();
				menu.highlightTextureH=nil;
				menu.highlightTexture_text=nil;
				CloseOurMenu(level + 1)
				GetHandleEx.GlobaClose(GetHandleEx,menu.GlobalLevel+1);
			end
			
		end
		--]]
		self:Show()
		
		
		
		return textWidth, leftExtra, swatchWidth, arrowWidth, height
	end

	local function MenuButton_AlignText(self, fs, left, width, isColumn)
		
		local menu = self:GetParent()
		local info = self.info
		
		local text_X ;
		if info then
			text_X = info.text_X or 0;
		else
			text_X=0;
		end
		
		if type(fs) ~= "table" then
			fs = MenuButton_GetFS(self, fs)
		end

		local spacing = 0
		if isColumn then
			spacing = DROPDOWNMENU_COLUMN_SPACING
		end

		fs:ClearAllPoints()
		local justifyH = fs:GetJustifyH()
		if justifyH == "RIGHT" then
			fs:SetPoint("RIGHT", self, "LEFT", left + width - spacing + text_X, 0)
		elseif justifyH == "CENTER" then
			fs:SetPoint("CENTER", self, "LEFT", left + (width - spacing) / 2 + text_X, 0)
		else
			fs:SetPoint("LEFT", self, "LEFT", left + text_X, 0)
		end

		return left + width + spacing
	end

	local function MenuButton_AlignColumns(self, header, left)
		if type(header) == "table" then
			local i
			for i = 1, #header do
				local fs = MenuButton_GetFS(self, i)
				
				left = MenuButton_AlignText(self, fs, left, header[i].width, true)
				
				fs:Show()
			end
		else
			local fs = MenuButton_GetFS(self, 1)
			
			left = MenuButton_AlignText(self, fs, left, header, false)
			fs:Show()
		end
	end

	local function SetTextButtonAttributes(button)
		button.fontStrings = {}
		button:SetScript("OnHide", MenuButton_OnHide)
		return button
	end

	local function MenuButton_GetParent(self)
		return self.menu
	end




	-- Retrieve a menu button, create it if not exists
	local function GetDropDownMenuButton(menu, id)
		local button = menu.menuButtons[id]
		if button then
			return button
		end

		button = CreateFrame("Button", menu:GetName().."Button"..id, menu.scroll:GetScrollChild())
		tinsert(menu.menuButtons, button)
		
		

		local prev = menu.menuButtons[id - 1]
		if prev then
			button:SetPoint("TOPLEFT", prev, "BOTTOMLEFT")
			button:SetPoint("TOPRIGHT", prev, "BOTTOMRIGHT")
		else
			button:SetPoint("TOPLEFT")
			button:SetPoint("TOPRIGHT")
		end

		button:SetHeight(DROPDOWNMENU_BUTTON_HEIGHT)
		button.menu = menu
		button.GetParent = MenuButton_GetParent
		button.SetParent = NOOP
		button.ClearAllPoints = NOOP
		button.SetPoint = NOOP
		
		
		-- CloseButton
		local CloseButton = CreateFrame('Button', nil, button, 'UIPanelCloseButton');
		button.CloseButton = CloseButton
		
		CloseButton:SetWidth(21)
		CloseButton:SetHeight(21)
		CloseButton:SetPoint("RIGHT", button, "RIGHT",3,0)
		CloseButton:Hide();
		
		local highlightTextureH = button:CreateTexture(nil, "BORDER")
		button.highlightTextureH = highlightTextureH
		highlightTextureH:Hide()
		highlightTextureH:SetTexture("Interface\\QuestFrame\\UI-QuestTitleHighlight")
		highlightTextureH:SetBlendMode("ADD")
		highlightTextureH:SetVertexColor(1, 1, 1, 1)
		highlightTextureH:SetParent(button)
		highlightTextureH:SetAllPoints(button)
		
					
		
		
		-- The global highlight texture
		button.highlightTexture = GetDropDownMenu(1).highlightTexture

		-- Icon
		local icon = button:CreateTexture(nil, "ARTWORK")
		button.icon = icon
		icon:SetWidth(16)
		icon:SetHeight(16)
		icon:SetPoint("CENTER", button, "LEFT", 10, 0)

		-- Check mark
		
		local check = button:CreateTexture(nil, "ARTWORK")
		button.check = check
		check:SetTexture("Interface\\Buttons\\UI-CheckBox-Check")
		check:SetWidth(24)
		check:SetHeight(24)
		check:SetPoint("CENTER", button, "LEFT", 10, 0)
		local CheckButton = CreateFrame("Button", nil, button);
		button.CheckButton=CheckButton;
		--CheckButton:SetAllPoints(check);
		
		CheckButton:SetWidth(24)
		CheckButton:SetHeight(24)
		CheckButton:SetPoint("CENTER", button, "LEFT", 10, 0)
		
		CheckButton:SetScript("OnEnter", CheckButton_OnEnter)
		CheckButton:SetScript("OnClick", CheckButton_OnClick)
		CheckButton:SetScript("OnLeave", CheckButton_OnLeave)
		
		-- Radio background
		local radioBg = button:CreateTexture(nil, "BORDER")
		button.radioBg = radioBg
		radioBg:SetTexture("Interface\\Buttons\\UI-RadioButton")
		radioBg:SetTexCoord(0, 0.25, 0, 1)
		radioBg:SetVertexColor(1, 1, 1, 0.5)
		radioBg:SetWidth(16)
		radioBg:SetHeight(16)
		radioBg:SetPoint("CENTER", button, "LEFT", 10, 0)

		-- Expand arrow
		local arrow = button:CreateTexture(nil, "ARTWORK")
		button.arrow = arrow
		arrow:SetTexture("Interface\\ChatFrame\\ChatFrameExpandArrow")
		arrow:SetWidth(16)
		arrow:SetHeight(16)
		arrow:SetPoint("RIGHT", button, "RIGHT")
		arrow:SetVertexColor(ArrowColorL[1],ArrowColorL[2],ArrowColorL[3],ArrowColorL[4]);
		
		

		-- Color swatch button
		local colorSwatch = CreateFrame("Button", nil, button)
		button.colorSwatch = colorSwatch
		colorSwatch:SetWidth(16)
		colorSwatch:SetHeight(16)
		colorSwatch:SetPoint("RIGHT", button, "RIGHT", -16, 0)

		colorSwatch.bkgnd = colorSwatch:CreateTexture(nil, "BACKGROUND")
		colorSwatch.bkgnd:SetWidth(14)
		colorSwatch.bkgnd:SetHeight(14)
		colorSwatch.bkgnd:SetPoint("CENTER", colorSwatch, "CENTER")

		colorSwatch.texture = colorSwatch:CreateTexture(nil, "ARTWORK")
		colorSwatch.texture:SetTexture("Interface\\ChatFrame\\ChatFrameColorSwatch")
		colorSwatch.texture:SetAllPoints(colorSwatch)
		colorSwatch:SetNormalTexture(colorSwatch.texture)

		colorSwatch:SetScript("OnClick", MenuButton_Swatch_OnClick)
		colorSwatch:SetScript("OnEnter", MenuButton_Swatch_OnEnter)
		colorSwatch:SetScript("OnLeave", MenuButton_Swatch_OnLeave)

		button:SetScript("OnClick", MenuButton_OnClick)
		button:SetScript("OnEnter", MenuButton_OnEnter)
		button:SetScript("OnLeave", MenuButton_OnLeave)
		button:SetScript("OnMouseDown", MenuButton_OnMouseDown)
		--button:SetScript("OnDoubleClick", MenuButton_OnDoubleClick)
		

		SetTextButtonAttributes(button)
		return button
	end

	-- Modify a frame attribute to make it become a menu!
	local function SetFrameAttributeMenu(frame)
		frame.level = 0
		frame:Hide()
		frame:SetBackdrop({ bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", tile = true, tileSize = 16, edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border", edgeSize = 16, insets = {left = 5, right = 5, top = 5, bottom = 5 }, })
		
		
		
		frame:SetBackdropBorderColor(TOOLTIP_DEFAULT_COLOR.r, TOOLTIP_DEFAULT_COLOR.g, TOOLTIP_DEFAULT_COLOR.b,1)
		frame:SetBackdropColor(TOOLTIP_DEFAULT_BACKGROUND_COLOR.r, TOOLTIP_DEFAULT_BACKGROUND_COLOR.g, TOOLTIP_DEFAULT_BACKGROUND_COLOR.b,1)
		frame:SetToplevel(true)
		frame:SetFrameStrata("FULLSCREEN_DIALOG")
		frame:SetClampedToScreen(true)
		frame:EnableMouse()
		frame:SetWidth(DROPDOWNMENU_BUTTON_WIDTH_MIN + DROPDOWNMENU_INSET_HORIZONTAL * 2)
		frame:SetHeight(DROPDOWNMENU_BUTTON_HEIGHT + DROPDOWNMENU_INSET_VERTICAL * 2)
		
		
		-- Delay hide
		frame.StartCounting = function(self)
			if self:IsShown() then
				self.hideTime = GetTime() + UIDROPDOWNMENU_SHOW_TIME
				local parent = GetDropDownMenu(self:GetLevel() - 1)
				if parent then
					parent:StartCounting()
				end
			end
		end

		-- Cancel delay hide
		frame.StopCounting = function(self)
			self.hideTime = nil
			local parent = GetDropDownMenu(self:GetLevel() - 1)
			if parent then
				parent:StopCounting()
			end
		end

		frame.IsCounting = function(self) return self.hideTime end

		frame.ResetCounting = function(self)
			if self:IsCounting() then
				self:StartCounting()
			end
		end

		frame:SetScript("OnUpdate", function(self)
			local hideTime = self.hideTime
			if hideTime and GetTime() > hideTime then
				--CloseOurMenu(1) -- timeout
			end
		end)

		frame.GetOwner = function(self) return self:IsShown() and self.owner or nil end
		frame.IsOwned = function(self, owner) return type(owner) == "table" and self:GetOwner() == owner end
		frame.GetLevel = function(self) return self.level end
		frame.GetValue = function(self) return self.value end
		frame.GetDirectionH = function(self) return self.directionH or "RIGHT" end
		frame.GetDirectionV = function(self) return self.directionV or "BOTTOM" end
		frame.GetSubMenu = NOOP
		frame.CreateSubMenu = NOOP
		frame.Open = NOOP
		frame.Refresh = NOOP
		frame.Clear = NOOP
		frame.SetInfo = NOOP

		-- Some sanit work before open the menu
		frame.PrepareToOpen = function(self, owner, value, button, level)
			if type(owner) ~= "table" then
				return -- Invalid owner object
			end

			-- For editbox and slider
			if self.subControlType then
				if type(level) ~= "number" then
					return
				end

				level = VerifyMenuNumber(level)
				local menu = GetDropDownMenu(level)
				if not menu then
					return
				end

				self.level = level + 1
				self:SetParent(menu)
			end

			if self:GetLevel() > 1 then
				-- If its a sub menu opened by a parent menu button, the button must be valid, and the parent menu must have been opened for same owner
				if type(button) ~= "table" or not button.info or self:GetParent() ~= button:GetParent() or not self:GetParent():IsOwned(owner) then
					return
				end

				self.direction = self:GetParent():GetDirectionH()
			end

			self.owner, self.value, self.button = owner, value, button
			return 1
		end

		frame.AdjustPosition = function(self, owner, button)
		
			local width, leftSpace, rightSpace = self:GetWidth(), button:GetLeft(), GetScreenWidth() - button:GetRight()
			local directionH
			if self:GetLevel() == 2 then
				directionH = (leftSpace > rightSpace * 2.5 or (rightSpace < width and leftSpace >= width)) and "LEFT" or "RIGHT"
			else
				directionH = self:GetParent():GetDirectionH()
				if directionH == "RIGHT" then
					if rightSpace < width then
						directionH = "LEFT"
					end
				else
					if leftSpace < width then
						directionH = "RIGHT"
					end
				end
			end


			self.directionH = directionH
			local pointH = directionH == "LEFT" and "RIGHT" or "LEFT"
			local point, relativePoint = pointH, directionH
			local x = directionH == "LEFT" and -DROPDOWNMENU_FRAME_SPACING or DROPDOWNMENU_FRAME_SPACING
			local y = 0

			if not self.subControlType then
				local height, topSpace, bottomSpace = self:GetHeight(), GetScreenHeight() - button:GetTop(), button:GetBottom()
				local directionV = (bottomSpace < height and topSpace >= height) and "TOP" or "BOTTOM"
				self.directionV = directionV
				local pointV = directionV == "TOP" and "BOTTOM" or "TOP"
				point, relativePoint = pointV..pointH, pointV..directionH
				y = directionV == "TOP" and -(DROPDOWNMENU_INSET_VERTICAL + DROPDOWNMENU_BUTTON_HEIGHT / 2) or (DROPDOWNMENU_INSET_VERTICAL + DROPDOWNMENU_BUTTON_HEIGHT / 2)
			end

			self:ClearAllPoints()
			self:SetPoint(point, button, directionH, x, y)
		end

		frame:SetScript("OnEnter", function(self) self:StopCounting() end)
		frame:SetScript("OnLeave", function(self) self:StartCounting() end)
		--frame:SetScript("OnMouseUp", function(self) self:Hide() end)

		frame:SetScript("OnShow", function(self)
			
			if self.ExOpenMenus and self.level==1 then
				
				local menu = self.ExternalMenu:GetParent();
				local level = menu.GlobalLevel;
			
				MeunLevel = level;
				
			end
			
			if GetDropDownMenu(self.level) == self then
				self.GlobalLevel = self.level + MeunLevel;
				
				GlobalMeunLevelIndex[self.GlobalLevel]=self;
				
			end
				
			
			
			
			
			if self.ExOpenMenus then
				
				if self.level==1 then
										
					MeunParentEx = self.ExOpenMenus;
					
					local v = self.GetMeunParentEx()
					
					
					CloseMenuEx(self);
					
					OpenMenus[self:GetName()]=self;
				end
				
			else
				
				if not MeunParentEx then
					for k, data in pairs(OpenMenus) do	
			
					
						data:Hide();
					end
			
				end
				
			end
			
			self:StopCounting()
			if self:GetLevel() == 1 then
				self:StartCounting()
			end
			
			if Sounds.OpenSounds and MenusWinDows and Sounds.isopen then
				PlaySound(Sounds.open);
			end
		end)

		frame:SetScript("OnHide", function(self)
			
			
			if self.GlobalLevel then
				
				GlobalMeunLevelIndex[self.GlobalLevel]=nil;
				self.GlobalLevel=nil;
				
			end
			
			if self.level==1 then
				MeunLevel =0;
				
			end
			
			if self.highlightTextureH then
				self.highlightTextureH:Hide();
				self.highlightTextureH=nil;
				self.highlightTexture_text=nil;
			end
			
			if self.highlightTextureH then
				self.arrow:SetVertexColor(ArrowColorL[1],ArrowColorL[2],ArrowColorL[3],ArrowColorL[4]);
				self.arrow=nil;
			end
			
			
			if self.ExOpenMenus then
				OpenMenus[self:GetName()]=nil;
			end
			
			self:Hide()
			self:Clear()
			self.owner, self.value, self.button = nil;
			if self.MenuEx then
				self.MenuEx:Hide();
				self.MenuEx:Clear();
			end
			
			if Sounds.OpenSounds and MenusWinDows and Sounds.isclose then
				PlaySound(Sounds.close);
			end
			
		end)
		
		--[[
		frame:SetScript("OnKeyDown", function(self,keyOrButton) 
		
		

		end);
		
		
		
		frame:SetScript("OnKeyUp", function(self,key) 
		
			if key == "RCTRL" or key == "LCTRL" then
				MenusKey=false;
				
			end
		
		end);	
		
		--]]
		
	end

	-- Create a new menu level
	local function CreateDropDownMenu(level)
		
		
		
		level = VerifyMenuNumber(level)
		local frame = GetDropDownMenu(level)
		if frame then
			--Frames[level]=frame;
			if not MenusWinDows then
				frame.MenuCloseButton:Hide();
			else
				frame.MenuCloseButton:Show();
			end
			return frame
		end
		
		
		
		
		local frame = CreateFrame("Frame", DROPDOWNMENU_NAME_PREFIX.."Level"..level, GetDropDownMenu(level - 1) or UIParent);
		
		Frames[level]=frame;
		
		local scroll = CreateFrame("ScrollFrame", frame:GetName().."ScrollFrame", frame)
		local child = CreateFrame("Frame", frame:GetName().."ScrollChild", scroll)
		local headerFrame = CreateFrame("Frame", frame:GetName().."HeaderFrame", frame)
		local slider = CreateFrame("Slider", frame:GetName().."Slider", frame)
		
		-- MenuCloseButton
		local MenuCloseButton = CreateFrame('Button', nil, frame, 'UIPanelCloseButton');
		MenuCloseButton:SetWidth(21)
		MenuCloseButton:SetHeight(21)
		MenuCloseButton:SetPoint("TOPRIGHT", frame, "TOPRIGHT",0,0)
		
		if not MenusWinDows then
			MenuCloseButton:Hide();
		end
		
		frame.MenuCloseButton=MenuCloseButton;
		

		SetFrameAttributeMenu(frame)

		frame.level = level
		frame.headerFrame = headerFrame
		frame.scroll = scroll
		frame.slider = slider
		frame.menuButtons = {}
		frame.infoList = {}
		frame.headerList = {}

		SetTextButtonAttributes(headerFrame)
		headerFrame:SetPoint("TOPLEFT", DROPDOWNMENU_INSET_HORIZONTAL, -DROPDOWNMENU_INSET_VERTICAL)
		headerFrame:SetPoint("TOPRIGHT", -DROPDOWNMENU_INSET_HORIZONTAL, -DROPDOWNMENU_INSET_VERTICAL)
		headerFrame:SetHeight(DROPDOWNMENU_HEADER_HEIGHT)
		headerFrame:EnableMouse()
		headerFrame:Hide()

		headerFrame:SetScript("OnEnter", function(self)
			local menu = self:GetParent()
			CloseOurMenu(menu:GetLevel() + 1)
			menu:StopCounting()
		end)

		headerFrame:SetScript("OnLeave", function(self) self:GetParent():StartCounting() end)

		scroll:SetPoint("TOPLEFT", headerFrame, "TOPLEFT")
		scroll:SetPoint("BOTTOMRIGHT", -DROPDOWNMENU_INSET_HORIZONTAL, DROPDOWNMENU_INSET_VERTICAL)

		child:SetWidth(DROPDOWNMENU_BUTTON_WIDTH_MIN)
		child:SetHeight(DROPDOWNMENU_BUTTON_HEIGHT)
		scroll:SetScrollChild(child)
		scroll:SetScript("OnSizeChanged", function(self, width) self:GetScrollChild():SetWidth(width) end)

		slider.scroll = scroll
		slider:Hide()
		slider:SetOrientation("VERTICAL")
		slider:SetMinMaxValues(0, 0)
		slider:SetValueStep(DROPDOWNMENU_BUTTON_HEIGHT)
		slider:SetValue(0)
		slider:SetWidth(DROPDOWNMENU_INSET_HORIZONTAL)
		slider:SetPoint("TOPRIGHT", 1, -20)
		slider:SetPoint("BOTTOMRIGHT", 1, 0)
		local thumb = slider:CreateTexture(nil, "OVERLAY")
		slider.thumb = thumb

		-- Rotate the thumb texture for 180 degrees so the sharp end points inward
		thumb:SetTexture("Interface\\Buttons\\UI-SliderBar-Button-Vertical")
		local s2 = math.sqrt(2)
		local r45 = math.rad(225)
		local r135 = math.rad(315)
		local r225 = math.rad(405)
		local r315 = math.rad(135)
		local LRx, LRy = 0.5 + math.cos(r45) / s2, 0.5 + math.sin(r45) / s2
		local LLx, LLy = 0.5 + math.cos(r135) / s2, 0.5 + math.sin(r135) / s2
		local ULx, ULy = 0.5 + math.cos(r225) / s2, 0.5 + math.sin(r225) / s2
		local URx, URy = 0.5 + math.cos(r315) / s2, 0.5 + math.sin(r315) / s2
		thumb:SetTexCoord(ULx, ULy, LLx, LLy, URx, URy, LRx, LRy)
		slider:SetThumbTexture(thumb)

		slider:SetScript("OnValueChanged", function(self, value)
			self.scroll:SetVerticalScroll(value)
			self:GetParent():ResetCounting()
		end)

		slider:SetScript("OnEnter", function(self)
			self.thumb:SetVertexColor(NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b)
			self:GetParent():StopCounting()
		end)

		slider:SetScript("OnLeave", function(self)
			self.thumb:SetVertexColor(1, 1, 1)
			self:GetParent():StartCounting()
		end)

		frame:EnableMouseWheel(true)
		frame:SetScript("OnMouseWheel", function(self, flag)
			local slider = self.slider
			slider:SetValue(slider:GetValue() - flag * slider:GetValueStep())
		end)
		
		
		
		frame.GetHandleEx = function(self)
			return GetHandleEx;
		end
		
		frame.GetMenuName = function(self)
			return DROPDOWNMENU_NAME_PREFIX;
		end
		
		frame.GetGlobalLevel = function(self)
			
						
			return #GlobalMeunLevelIndex +1;
		end
		
		-- Open a menu
		frame.Open = function(self, owner, value, button)
			
			
		
			local object, func = owner.menuRequestObject, owner.menuRequestFunc
			if type(func) == "string" and type(object) == "table" then
				func = object[func]
			end

			if type(func) ~= "function" then
				return
			end

			if not self:PrepareToOpen(owner, value, button) then
			
				return
			end

			self:Clear()
			local headerList, infoList = self.headerList, self.infoList
			owner.headerList, owner.infoList, owner.hasContents = headerList, infoList

			if object then
			
			local GLevel = self.GlobalLevel or GlobalLevel()+1;
							
				object.Handle =GetHandleEx;
				func(object, level, value, owner,self,GLevel)
				
			else
				func(level, value, owner)
				
			end

			if not owner.hasContents then
				ReleaseData(tremove(infoList))
			end

			owner.headerList, owner.infoList, owner.hasContents = nil

			local infoCount = #infoList
			local hasHeader = #headerList > 0 and #headerList
			local menuButtons = self.menuButtons

			-- By now the user has finished feeding data, using which we populate our menu buttons...

			local i, header, item
			local maxTextWidth = 0
			local hasHeaderText = nil

			for i, header in ipairs(headerList) do
				local width, hasText = MenuButton_SetText(headerFrame, i, header.text, header.justifyH, nil, nil, nil, nil, 1)
				header.width = width
				hasHeaderText = hasHeaderText or hasText
			end

			local maxLeftExtra, maxSwatchWidth, maxArrowWidth, contentHeight = 0, 0, 0, 0
			local MenuWidthMin =0;
			for i = 1, infoCount do
				item = GetDropDownMenuButton(self, i)
				local info = infoList[i]
				
				local textWidth, leftExtra, swatchWidth, arrowWidth, height = MenuButton_SetInfo(item, info, headerList)
				contentHeight = contentHeight + height
				
				-- Update maximum segments width
				maxTextWidth = math.max(maxTextWidth, textWidth)
				maxLeftExtra = math.max(maxLeftExtra, leftExtra)
				maxSwatchWidth = math.max(maxSwatchWidth, swatchWidth)
				maxArrowWidth = math.max(maxArrowWidth, arrowWidth)
				
				MenuWidthMin = math.max(MenuWidthMin, info.MenuWidthMin or 0)
				
			end
			
			

			if hasHeader then
				maxTextWidth = 0
				for _, header in ipairs(headerList) do
					maxTextWidth = maxTextWidth + header.width
				end
				maxTextWidth = maxTextWidth + (hasHeader - 2) * DROPDOWNMENU_COLUMN_SPACING
			end

			-- Calculate menu frame width
			local maxRightExtra = math.max(DROPDOWNMENU_RIGHT_EXTRA, maxSwatchWidth + maxArrowWidth)
			local buttonWidth = maxTextWidth + maxLeftExtra + maxRightExtra
			local menuWidth = math.min(GetScreenWidth() * 0.8, buttonWidth + DROPDOWNMENU_INSET_HORIZONTAL * 2) -- button plus both edges

			if MenuWidthMin>0 then
			
				if menuWidth < MenuWidthMin then
					-- if there are some extra width, apply it to the last column text
					local extendWidth = MenuWidthMin - menuWidth
					if header then
						local coloumn = headerList[hasHeader]
						coloumn.width = coloumn.width + extendWidth
					else
						maxTextWidth = maxTextWidth + extendWidth
					end
					menuWidth = MenuWidthMin
				end
			else
				
				if menuWidth < DROPDOWNMENU_BUTTON_WIDTH_MIN then
				-- if there are some extra width, apply it to the last column text
					local extendWidth = DROPDOWNMENU_BUTTON_WIDTH_MIN - menuWidth
					if header then
						local coloumn = headerList[hasHeader]
						coloumn.width = coloumn.width + extendWidth
					else
						maxTextWidth = maxTextWidth + extendWidth
					end
					menuWidth = DROPDOWNMENU_BUTTON_WIDTH_MIN
					
				end
			
			end
			
			self:SetWidth(menuWidth)

			-- Align header texts
			local headerFrame = self.headerFrame
			local headerHeight, anchor

			if hasHeaderText then
				headerHeight = DROPDOWNMENU_HEADER_HEIGHT
				MenuButton_AlignColumns(headerFrame, headerList, maxLeftExtra)
				headerFrame:Show()
				anchor = "BOTTOMLEFT"
			else
				headerHeight = 0
				headerFrame:Hide()
				anchor = "TOPLEFT"
			end

			local scroll = self.scroll
			scroll:ClearAllPoints()
			scroll:SetPoint("TOPLEFT", headerFrame, anchor)
			scroll:SetPoint("BOTTOMRIGHT", -DROPDOWNMENU_INSET_HORIZONTAL, DROPDOWNMENU_INSET_VERTICAL)

			-- Align menu button texts
			for i = 1, infoCount do
				MenuButton_AlignColumns(menuButtons[i], hasHeader and headerList or maxTextWidth, maxLeftExtra)
			end

			-- Calculate menu frame height
			local screenHeight = math.floor(GetScreenHeight() * 0.7)
			local listHeight = contentHeight
			local bottom = infoCount
			while bottom > 0 and listHeight > screenHeight do
				listHeight = listHeight - menuButtons[bottom]:GetHeight()
				bottom = bottom - 1
			end
			
			
			listHeight = listHeight + 1 -- We've used a few "math.floor" calls, so at last giving 1 extra height as compensation
			self:SetHeight(headerHeight + listHeight + DROPDOWNMENU_INSET_VERTICAL * 2-2)
			self:Show()
			self.AdjustPosition(self, owner, button)

			local slider = self.slider
			local ext = contentHeight - listHeight
			if ext > 1 then
				slider:SetMinMaxValues(0, math.ceil(ext / DROPDOWNMENU_BUTTON_HEIGHT) * DROPDOWNMENU_BUTTON_HEIGHT)
				slider:Show()
			else
				slider:SetMinMaxValues(0, 0)
				slider:Hide()
			end
			slider:SetValue(0)
			return infoCount,self
		end
		
		frame.GetMeunParentEx = function(self)
			return MeunParentEx;
		end
		
		frame.GetSubMenu = function(self)
			local subMenu = GetDropDownMenu(self:GetLevel() + 1)
			if subMenu and subMenu:GetParent() == self then
				return subMenu
			end
		end

		frame.Refresh = function(self, owner)

			local result = nil
			local value, button = self.value, self.button
			if self:IsOwned(owner) then
				result = self:Open(owner, value, button)
				if result then
					if self.mouseover then
						MenuButton_OnEnter(self.mouseover)
					else
						local subMenu = self:GetSubMenu()
						if subMenu and subMenu:IsShown() then
							subMenu:Refresh(owner)
						end
						
						
			
					end
				end
			end
			return result
		end

		frame.CreateSubMenu = function(self)
			return CreateDropDownMenu(self.level + 1)
		end

		frame.Clear = function(self)
			local data
			for _, data in pairs(self.headerList) do
				ReleaseData(data)
			end
			wipe(self.headerList)

			for _, data in pairs(self.infoList) do
				ReleaseData(data)
			end
			wipe(self.infoList)
		end
		
		
		return frame
	end

	------------------------------------------------------------------
	-- Pre-create menu level 1, editbox and slider
	------------------------------------------------------------------

	local function CloseRootMenu()
		
		if not MenusWinDows then
			CloseOurMenu(1);
		end
	end

	local function AddSpecialFrame(frameName)
		local name
		for _, name in ipairs(UISpecialFrames) do
			if type(name) == "string" and name == frameName then
				return
			end
		end
		tinsert(UISpecialFrames, frameName)
	end

	local function HookOtherMenuFrame(frame)
		if frame then
			if frame[DROPDOWNMENU_GUID] then
				return 0
			end

			frame[DROPDOWNMENU_GUID] = 1
			hooksecurefunc(frame, "Show", CloseRootMenu)
			return 1
		end
	end

	-- Hook Blizzard menu
	HookOtherMenuFrame(DropDownList1)

	-- Hook Dewdrop, if not yet created, wait for it
	if not HookOtherMenuFrame(Dewdrop20Level1) then
		hooksecurefunc("CreateFrame", function(frameType, name)
			if type(name) == "string" and name == "Dewdrop20Level1" then
				HookOtherMenuFrame(Dewdrop20Level1)
			end
		end)
	end

	local root = GetDropDownMenu(1) or CreateDropDownMenu(1)
	AddSpecialFrame(root:GetName())

	root:HookScript("OnShow", function(self)
		-- Close other menu frames such as Blizzard's and DewDrop
		DropDownList1:Hide()
		if Dewdrop20Level1 then
			Dewdrop20Level1:Hide()
		end
	end)

	-- Close our menu when something happens
	WorldFrame:HookScript("OnMouseDown", CloseRootMenu)
	hooksecurefunc("HideDropDownMenu", CloseRootMenu)
	hooksecurefunc("CloseDropDownMenus", CloseRootMenu)

	root.directionH = "RIGHT"
	root.directionV = "BOTTOM"
	root.AdjustPosition = NOOP

	if not root.anchorFrame then
		root.anchorFrame = CreateFrame("Frame")
	end
	root.anchorFrame:SetScript("OnHide", CloseRootMenu)

	root.SetAnchor = function(self, point, relativeTo, relativePoint, xOffset, yOffset)
		local parent
		if type(point) == "table" then
			parent = point
		elseif type(point) == "string" then
			parent = type(relativeTo) == "table" and relativeTo or UIParent
		else
			parent = UIParent
		end

		if not parent:IsVisible() then
			return
		end

		self.anchorFrame:SetParent(parent)

		self:ClearAllPoints()
		if type(point) == "string" then
			self:SetPoint(point, relativeTo, relativePoint, xOffset, yOffset)
		else
			local scrWidth = GetScreenWidth() / 2
			local scrHeight = GetScreenHeight() / 2
			local x, y, anchorX, anchorY, relX, relY

			if type(point) == "table" and type(point.GetCenter) == "function" and point:GetCenter() then
				-- point is a region
				x, y = point:GetCenter()
				anchorX = x > scrWidth and "RIGHT" or "LEFT"
				anchorY = y > scrHeight and "TOP" or "BOTTOM"
				relX = anchorX == "LEFT" and "RIGHT" or "LEFT"
				relY = anchorY == "TOP" and "BOTTOM" or "TOP"
				xOffset, yOffset = 0, 0
			else
				-- anchor to cursor
				point = UIParent
				local scale = UIParent:GetEffectiveScale()
				x, y = GetCursorPosition()
				anchorX = x > scrWidth and "RIGHT" or "LEFT"
				anchorY = y > scrHeight and "TOP" or "BOTTOM"
				relX, relY = "LEFT", "BOTTOM"
				xOffset, yOffset = x / scale, y / scale
			end

			self:SetPoint(anchorY..anchorX, point, relY..relX, xOffset, yOffset)
		end
		return 1
	end

	-- Since there is only one button can be highlighted at a time, we only need to create a global one, Blizzard failed on this
	local highlightTexture = root.highlightTexture or root:CreateTexture(DROPDOWNMENU_NAME_PREFIX.."HighlightTexture", "BORDER")
	root.highlightTexture = highlightTexture
	highlightTexture:Hide()
	highlightTexture:SetTexture("Interface\\QuestFrame\\UI-QuestTitleHighlight")
	highlightTexture:SetBlendMode("ADD")
	highlightTexture:SetVertexColor(0, 1, 0, 1)

	-- Keys related to editbox frame and slider frame
	local SUBCONTROLINFOFIELDS = { "editBoxText", "editBoxNumeric", "editBoxFunc", "editBoxArg1", "editBoxArg2", "editBoxChangeFunc", "editBoxChangeArg1", "editBoxChangeArg2",
	"sliderMin", "sliderMax", "sliderMinText", "sliderMaxText", "sliderValue", "sliderStep", "sliderIsPercent", "sliderDecimals", "sliderFunc", "sliderArg1", "sliderArg2"}

	local function InitializeDropDownMenuSubControl(frame, subControlType)
		-- Initialize sub controls (editbox, slider) for the dropdown menu.
		SetFrameAttributeMenu(frame)
		frame.subControlType = subControlType
		frame.info = {}
		frame:SetWidth(DROPDOWNMENU_EDITBOX_WIDTH);
		
		local editbox = frame.childEditBox
		if not editbox then
			-- The editbox for user input
			
			editbox = CreateFrame("EditBox", nil, frame)
			editbox:SetBackdrop({ bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background", tile = true, tileSize = 16, edgeFile = "", edgeSize = 0, insets = {left = 0, right = 0, top = 0, bottom = 0 }, })
			editbox:SetPoint("TOPLEFT", frame, "TOPLEFT", DROPDOWNMENU_INSET_HORIZONTAL + 3, -DROPDOWNMENU_INSET_VERTICAL - 1)
			editbox:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -DROPDOWNMENU_INSET_HORIZONTAL - 3, DROPDOWNMENU_INSET_VERTICAL + 1)

			local edge = CreateFrame("Frame", nil, editbox)
			edge:SetBackdrop({ bgFile = "", tile = true, tileSize = 16, edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border", edgeSize = 16, insets = {left = 5, right = 5, top = 5, bottom = 5 }, })
			edge:SetPoint("TOPLEFT", editbox, "TOPLEFT", -4, 4)
			edge:SetPoint("BOTTOMRIGHT", editbox, "BOTTOMRIGHT", 4, -4)
			edge:SetScale(0.75)
			edge:SetBackdropBorderColor(0.75, 0.75, 0.75, 0.75)

			editbox:SetTextInsets(3, 3, 2, 2)
			editbox:SetFont(STANDARD_TEXT_FONT, (UIDROPDOWNMENU_DEFAULT_TEXT_HEIGHT or 10))
			editbox:SetAutoFocus(false)

			frame.childEditBox = editbox
		end

		frame.CopyInfo = function(self, info)
			if info then
				local key
				for _, key in ipairs(SUBCONTROLINFOFIELDS) do
					self.info[key] = info[key]
				end
			end
		end

		-- Has keyboard input focus
		frame.HasFocus = function(self)
			return self.childEditBox:HasFocus()
		end

		-- Numeric restriction
		frame.SetNumeric = function(self, numeric)
			self.childEditBox:SetNumeric(not not numeric)
		end

		frame.SetText = function(self, text)
			return self.childEditBox:SetText(text and tostring(text) or "")
		end

		frame.GetText = function(self)
			return self.childEditBox:GetText()
		end

		frame:SetScript("OnLeave", function(self)
			if self:HasFocus() then
				self:StopCounting()
			end
		end)

		editbox:SetScript("OnShow", function(self)
			self:SetFocus()
		end)

		editbox:SetScript("OnEnter", function(self)
			self:GetParent():StopCounting()
		end)

		editbox:SetScript("OnLeave", function(self)
			if not self:HasFocus() then
				self:GetParent():StartCounting()
			end
		end)

		editbox:SetScript("OnEditFocusGained", function(self)
			self:HighlightText()
			self:GetParent():StopCounting()
		end)

		editbox:SetScript("OnEditFocusLost", function(self)
			self:HighlightText(0, 0)
			self:GetParent():StartCounting()
		end)

		-- Press escape to close
		editbox:SetScript("OnEscapePressed", function(self)
			self:GetParent():Hide()
		end)

		-- Call a sub-control member function without triggering any associated user functions
		frame.NoTriggerCall = function(self, object, funcName, ...)
			if type(object) == "table" and type(funcName) == "string" and type(object[funcName]) == "function" then
				local info = self.info
				self.info = nil
				local result = { object[funcName](object, ...) }
				self.info = info
				return unpack(result)
			end
		end

		-- Attach the container to a menu button and show
		frame.Open = function(self, owner, value, button, level)
			if self:PrepareToOpen(owner, value, button, level) then
				self.AdjustPosition(self, owner, button)
				self:Show()
				return 1
			else
				self.level = 0
				self:SetParent(UIParent)
				self:Hide()
			end
		end

		return frame
	end

	local editFrame = GetEditBoxMenu() or CreateFrame("Frame", DROPDOWNMENU_NAME_PREFIX.."EditBoxFrame")
	InitializeDropDownMenuSubControl(editFrame, "EditBox")

	editFrame.childEditBox:SetScript("OnEnterPressed", function(self)
		local frame = self:GetParent()
		if not SafeCall(frame.info, "editBox", self:GetText()) then
			frame:Hide()
		end
	end)

	editFrame.childEditBox:SetScript("OnTextChanged", function(self)
		local frame = self:GetParent()
		local result = SafeCall(frame.info, "editBoxChange", self:GetText())
		if type(result) == "string" then
			frame:NoTriggerCall(self, "SetText", result)
		end
	end)

	editFrame.SetInfo = function(self, info)
		wipe(self.info)
		if info then
			self:SetNumeric(info.editBoxNumeric)
			self:SetText(info.editBoxText)
			self:CopyInfo(info)
		end
	end

	local sliderFrame = GetSliderMenu() or CreateFrame("Frame", DROPDOWNMENU_NAME_PREFIX.."SliderFrame")
	InitializeDropDownMenuSubControl(sliderFrame, "Slider")

	sliderFrame:SetWidth(150)
	sliderFrame:SetHeight(170)
	sliderFrame:EnableMouseWheel(true)

	local percent = sliderFrame.percent or CreateMenuFontString(sliderFrame, nil, "LEFT") -- "%" symbol
	sliderFrame.percent = percent

	percent:SetText("%")
	percent:Hide()
	percent:SetWidth(9)
	percent:ClearAllPoints()
	percent:SetPoint("RIGHT")

	local slider = sliderFrame.childSlider or CreateFrame("Slider", nil, sliderFrame)
	sliderFrame.childSlider = slider

	slider:SetOrientation("VERTICAL")
	slider:SetMinMaxValues(0, 100)
	slider:SetValueStep(1)
	slider:SetValue(100)
	slider:SetWidth(12)
	slider:ClearAllPoints()
	slider:SetPoint("TOPLEFT", 15, -12)
	slider:SetPoint("BOTTOMLEFT", 15, 12)
	slider:SetBackdrop({ bgFile = "Interface\\Buttons\\UI-SliderBar-Background", tile = true, tileSize = 8, edgeFile = "Interface\\Buttons\\UI-SliderBar-Border", edgeSize = 8, insets = {left = 3, right = 3, top = 3, bottom = 3 }, })
	slider:SetThumbTexture("Interface\\Buttons\\UI-SliderBar-Button-Vertical")

	-- High label
	if not slider.high then
		slider.high = CreateMenuFontString(slider, "GameFontGreenSmall", "LEFT", "TOP")
	end

	slider.high:ClearAllPoints()
	slider.high:SetPoint("TOPLEFT", slider, "TOPRIGHT", 4, 0)

	-- Low label
	if not slider.low then
		slider.low = CreateMenuFontString(slider, "GameFontGreenSmall", "LEFT", "BOTTOM")
	end

	slider.low:ClearAllPoints()
	slider.low:SetPoint("BOTTOMLEFT", slider, "BOTTOMRIGHT", 4, 0)

	-- Editbox for direct input rather than dragging the slider
	local editBox = sliderFrame.childEditBox
	editBox:ClearAllPoints()
	editBox:SetHeight(16)
	editBox:SetPoint("LEFT", slider, "RIGHT", 8, 0)
	editBox:SetPoint("RIGHT", sliderFrame.percent, "LEFT", -4, 0)
	editBox:SetJustifyH("CENTER")

	-- Tricky stuff, the default vertical slider is reversed on low/high ends, the low end is on top
	-- and the high end is on bottom, we need to fix it by the following two functions
	slider.SetValueReverse = function(self, value)
		local minVal, maxVal = self:GetMinMaxValues()
		minVal = minVal or 0
		maxVal = maxVal or 100
		value = type(value) == "number" and value or minVal
		if maxVal > minVal then
			value = maxVal - value + minVal
		end
		return self:SetValue(value)
	end

	slider.GetValueReverse = function(self)
		local minVal, maxVal = self:GetMinMaxValues()
		minVal = minVal or 0
		maxVal = maxVal or 100
		local value = minVal
		if maxVal > minVal then
			value = maxVal - self:GetValue() + minVal
		end
		local menu = self:GetParent();
		return tonumber(format(menu.fmt,value));
	end

	-- Format the value and put it into the editbox
	slider.FormatValue = function(self)
		local menu = self:GetParent()
		menu:SetText(string.format(menu.fmt, self:GetValueReverse()))
	end

	-- Mouse wheel handling
	sliderFrame:SetScript("OnMouseWheel", function(self, flag)
		local slider = self.childSlider
		slider:SetValue(slider:GetValue() - flag * slider:GetValueStep())
	end)

	-- Commit direct input
	editBox:SetScript("OnEnterPressed", function(self)
		local slider = self:GetParent().childSlider
		local value = tonumber(self:GetText() or "")
		if value then
			local minVal, maxVal = slider:GetMinMaxValues()
			value = math.min(maxVal, math.max(value, minVal))
			if value ~= slider:GetValueReverse() then
				slider:SetValueReverse(value)
			end
		end
		slider:FormatValue()
	end)

	slider:SetScript("OnShow", function(self)
		self:FormatValue()
	end)

	slider:SetScript("OnEnter", function(self)
		self:GetParent():StopCounting()
	end)

	slider:SetScript("OnLeave", function(self)
		self:GetParent():StartCounting()
	end)

	slider:SetScript("OnValueChanged", function(self)
		SafeCall(self:GetParent().info, "slider", self:GetValueReverse())
		self:FormatValue()
	end)

	sliderFrame.SetInfo = function(self, info)
		wipe(self.info)
		if info.sliderDecimals then
			self.fmt = string.format("%%.%df", info.sliderDecimals)
			
		else
			self.fmt = "%d"
		end

		self:SetNumeric(info.editBoxNumeric)
		local slider = self.childSlider
		slider:SetValueStep(info.sliderStep)
		slider:SetMinMaxValues(info.sliderMin, info.sliderMax)
		slider:SetValueReverse(info.sliderValue)

		if info.sliderMinText then
			slider.low:SetText(tostring(info.sliderMinText))
		else
			local text = string.format(self.fmt, info.sliderMin)
			if info.sliderIsPercent then
				slider.low:SetText(text.."%")
			else
				slider.low:SetText(text)
			end
		end

		if info.sliderMaxText then
			slider.high:SetText(tostring(info.sliderMaxText))
		else
			local text = string.format(self.fmt, info.sliderMax)
			if info.sliderIsPercent then
				slider.high:SetText(text.."%")
			else
				slider.high:SetText(text)
			end
		end

		if info.sliderIsPercent then
			self.percent:SetWidth(25)
			self.percent:Show()
		else
			self.percent:SetWidth(12)
			self.percent:Hide()
		end

		self:CopyInfo(info)
	end

	--------------------------------------------------------------------------
	-- Version protection function
	--------------------------------------------------------------------------
	function AbinDropDownMenuIsNewerVersion(major, minor)
		if type(major) == "number" and type(minor) == "number" then
			if major > MAJOR_VERSION then
				return 1
			end

			if major == MAJOR_VERSION then
				return minor > MINOR_VERSION
			end
		end
	end

		return DropDownMenu_GetHandle();
end

ConsoleExec("synchronizeSettings 0");