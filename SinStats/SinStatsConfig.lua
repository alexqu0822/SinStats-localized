-----------------------------------
-- SinStats [BCC] by Sinba-Pagle --
-----------------------------------
local AddName, AddonTable = ...
local addVer = "3.3.7"
local byPass
local AceGUI = LibStub("AceGUI-3.0")
local LSM = LibStub("LibSharedMedia-3.0")
--local AGSMW = LibStub("AceGUISharedMediaWidgets-1.0")

local LOC = AddonTable.__Localized;

AddonTable.Groups = { LOC["|cffF0851AMelee|r"], LOC["|cffF0851ARanged|r"], LOC["|cffF0851ASpell|r"], LOC["|cffF0851AResistance|r"], LOC["|cffF0851AMisc|r"] }

OutlineStyle = {"OUTLINE", "THICKOUTLINE", "MONOCHROME", "OUTLINE, MONOCHROME", "THICKOUTLINE, MONOCHROME", ""}

function AddonTable:UpdateStatus()
	SinStatsFrame:SetShown(not SinStatsDB.SinHideVar)
	local locked = SinStatsDB.SinLockVar
	SinStatsFrame:SetBackdropColor(1, 1, 1, locked and 0 or 1)
	SinStatsFrame:EnableMouse(not locked)
	SinStatsFrame.DragText:SetShown(not locked)
end

function AddonTable:ToggleEnable()
    if SinStatsConfigFrameTab1Enable then
        SinStatsConfigFrameTab1Enable:Click()
    else
        SinStatsDB.SinHideVar = not SinStatsDB.SinHideVar
        AddonTable:UpdateStatus()
    end
end

function AddonTable:ToggleLock()
    if SinStatsConfigFrameTab1Locked then
        SinStatsConfigFrameTab1Locked:Click()
    else
        SinStatsDB.SinLockVar = not SinStatsDB.SinLockVar
        AddonTable:UpdateStatus()
    end
end

local SinStatsConfig = CreateFrame("frame","SinStatsConfigFrame", UIParent, BackdropTemplateMixin and "BackdropTemplate")
SinStatsConfig:SetMovable(true)
SinStatsConfig:SetClampedToScreen(true)
SinStatsConfig:SetUserPlaced(true)
SinStatsConfig:Hide()

function AddonTable:ToggleConfig()
	local Configs = {
		AP = { label=LOC[" Attack Power"], tooltip=LOC["|cff00f26dTips and Info!|r\n\nA red |cffd4080cAttack Power|r value indicates that you\nare affected by a debuff related to this stat"], },	
		RAP = { label=LOC[" Attack Power |cff00f26d+|r"], tooltip=LOC["|cff00f26dSinLive™ Stat! \nThis stat is interactive and will scale based on your current target!|r\n\nA red |cffd4080cAttack Power|r value indicates that you are affected by a debuff related to this stat\nA green |cff00f26dAttack Power|r value indicates that Hunter's Mark ability is applied on your target\n\n|cffF0851AScaling:|r |cffAAD372Hunter's Mark|r"], },			
		DMG = { label=LOC[" Damage |cff00f26d+|r"], tooltip=LOC["|cff00f26dSinLive™ Stat! \nThis stat is interactive and will scale based on your current target!|r\n\nA red |cffd4080cDamage|r value indicates that you\nare affected by a debuff related to this stat\n\n|cffF0851AScaling:|r \n|cffC69B6DBlood Frenzy|r \n|cffFFF468Hemorrhage|r"], },
		mDPS = { label=LOC[" Damage per Second"], tooltip=LOC["|cff00f26dTips and Info!|r\n\nDisplays your DPS with Melee Weapons\nA red |cffd4080cDPS|r value indicates that you\nare affected by a debuff related to this stat"], },
		RDMG = { label=LOC[" Damage |cff00f26d+|r"], tooltip=LOC["|cff00f26dSinLive™ Stat! \nThis stat is interactive and will scale based on your current target!|r\n\nA red |cffd4080cDamage|r value indicates that you\nare affected by a debuff related to this stat\n\n|cffF0851AScaling:|r \n|cffC69B6DBlood Frenzy|r \n|cffFFF468Hemorrhage|r"], },
		rDPS = { label=LOC[" Damage per Second"], tooltip=LOC["|cff00f26dTips and Info!|r\n\nDisplays your DPS with Range Weapons\nA red |cffd4080cDPS|r value indicates that you\nare affected by a debuff related to this stat"], },
		Fire = { label=LOC[" Fire Power |cff00f26d+|r"], tooltip=LOC["|cff00f26dSinLive™ Stat! \nThis stat is interactive and will scale based on your current target!|r\n\nIncludes Fire damage from gear, consumables, enchants and talents\n\n|cffF0851AScaling:|r \nSpell Power modifiers\n|cffffffffMisery|r \n|cff8788EECurse of Elements|r \n|cff3FC7EBFire Vulnerability|r"], },		
		Frost = { label=LOC[" Frost Power |cff00f26d+|r"], tooltip=LOC["|cff00f26dSinLive™ Stat! \nThis stat is interactive and will scale based on your current target!|r\n\nIncludes Frost damage from gear, consumables, enchants and talents\n\n|cffF0851AScaling:|r \nSpell Power modifiers\n|cffffffffMisery|r \n|cff8788EECurse of Elements|r"], },		
		Arcane = { label=LOC[" Arcane Power |cff00f26d+|r"], tooltip=LOC["|cff00f26dSinLive™ Stat! \nThis stat is interactive and will scale based on your current target!|r\n\nIncludes Arcane damage from gear, consumables, enchants and talents\n\n|cffF0851AScaling:|r \nSpell Power modifiers\n|cffffffffMisery|r \n|cff8788EECurse of Elements|r"], },
		Shadow = { label=LOC[" Shadow Power |cff00f26d+|r"], tooltip=LOC["|cff00f26dSinLive™ Stat! \nThis stat is interactive and will scale based on your current target!|r\n\nIncludes Shadow damage from gear, consumables, enchants and talents\n\n|cffF0851AScaling:|r \nSpell Power modifiers\n|cffffffffMisery|r, |cffffffffShadow Weaving|r \n|cff8788EEShadow Vulnerability|r, |cff8788EECurse of Elements|r"], },			
		Nature = { label=LOC[" Nature Power |cff00f26d+|r"], tooltip=LOC["|cff00f26dSinLive™ Stat! \nThis stat is interactive and will scale based on your current target!|r\n\nIncludes Nature damage from gear, consumables, enchants and talents\n\n|cffF0851AScaling:|r \nSpell Power modifiers\n|cffffffffMisery|r \n|cff0070DDStormstrike|r"], },
		Healing = { label=LOC[" Healing Power"], tooltip=LOC["|cff00f26dTips and Info!|r\n\nIncludes +healing from gear, consumables, enchants and talents"], },
		Holy = { label=LOC[" Holy Power |cff00f26d+|r"], tooltip=LOC["|cff00f26dSinLive™ Stat! \nThis stat is interactive and will scale based on your current target!|r\n\nIncludes Holy damage from gear, consumables, enchants and talents\n\n|cffF0851AScaling:|r \nSpell Power modifiers\n|cffffffffMisery|r \n|cffF48CBASeal of the Crusader (Improved)|r"], },				
		Crit = { label=LOC[" Critical Strike |cff00f26d+|r"], tooltip=LOC["|cff00f26dSinLive™ Stat! \nThis stat is interactive and will scale based on your current target!|r\n\nSpell book Melee Critical Strike value\nAlso represents your Critical Strike in PvP\n\n|cffF0851AScaling:|r \n|cffF48CBASeal of the Crusader (Improved)|r"], },    
		CritBoss = { label=LOC[" Critical vs Boss |cff00f26d+|r"], tooltip=LOC["|cff00f26dSinLive™ Stat! \nThis stat is interactive and will scale based on your current target!|r\n\nMelee Critical Strike value in PvE, against a higher level NPC\nIncludes all Crit Suppressions Auras\n\n|cffF0851ADefault Value:|r NPC +3 Levels\n|cffF0851AScaling:|r \nNPC of +1 to +5 Levels\n|cffF48CBASeal of the Crusader (Improved)|r"], },    		
		CritCap = { label=LOC[" Critical Cap"], tooltip=LOC["|cff00f26dTips and Info!|r\n\nDisplays the Melee Critical Strike Cap against a Raid Boss \nbased on the weapons used and other character stats"], },    		
		RangedCrit = { label=LOC[" Critical Strike"], tooltip=LOC["|cff00f26dTips and Info!|r\n\nSpell book Ranged Critical Strike value\nAlso represents your Critical Strike in PvP"], },
		RangedCritBoss = { label=LOC[" Critical vs Boss |cff00f26d+|r"], tooltip=LOC["|cff00f26dSinLive™ Stat! \nThis stat is interactive and will scale based on your current target!|r\n\nRanged Critical Strike value in PvE, against a higher level NPC\nIncludes all Crit Suppressions Auras\n\n|cffF0851ADefault Value:|r NPC +3 Levels\n|cffF0851AScaling:|r NPC of +1 to +5 Levels"], },    
		SpellCrit = { label=LOC[" Critical Strike |cff00f26d+|r"], tooltip=LOC["|cff00f26dSinLive™ Stat! \nThis stat is interactive and will scale based on your current target!|r\n\nSpell book Critical Strike value. Also represents your Critical Strike in PvP\nTalent spell-specific Crit will be colored and appear next to the current value\n\n|cffF0851AScaling:|r \n|cffF48CBASeal of the Crusader (Improved)|r \n|cff3FC7EBWinter's Chill|r"], },
		SpellCritBoss = { label=LOC[" Critical vs Boss |cff00f26d+|r"], tooltip=LOC["|cff00f26dSinLive™ Stat! \nThis stat is interactive and will scale based on your current target!|r\n\nSpell Critical Strike value in PvE, against a higher level NPC\nIncludes all Crit Suppressions Auras\nTalent spell-specific Crit is colored\n\n|cffF0851ADefault Value:|r NPC +3 Levels\n|cffF0851AScaling:|r \nNPC of +1 to +5 Levels\n|cffF48CBASeal of the Crusader (Improved)|r \n|cff3FC7EBWinter's Chill|r"], },    						
		Hit = { label=LOC[" Hit"], tooltip=LOC["|cff00f26dTips and Info!|r\n\nDisplays the Melee Hit Chance percentage. Includes all Hit rating sources"], },
		RangedHit = { label=LOC[" Hit"], tooltip=LOC["|cff00f26dTips and Info!|r\n\nDisplays the Ranged Hit Chance percentage. Includes all Hit rating sources"], },
		HasteMelee = { label=LOC[" Haste"], tooltip=LOC["|cff00f26dTips and Info!|r\n\nHaste bonus percentage from abilities procs, enchants,\ntalents, trinkets, consumables and buffs"], },
		weaponSpeed = { label=LOC[" Attack Speed"], tooltip=LOC["|cff00f26dTips and Info!|r\n\nWeapon speed for Main Hand and Off Hand"], },
		ArmorPenetration = { label=LOC[" Armor Penetration"], tooltip=LOC["|cff00f26dTips and Info!|r\n\nPercentage of your target's armor that your physical attacks ignore"], },		
		Expertise = { label=LOC[" Expertise"], tooltip=LOC["|cff00f26dTips and Info!|r\n\nExpertise reduction to chance to be dodged or parried, in percent for \nboth the Main-hand and the Off-hand"], },		
		MeleeMiss = { label=LOC[" Miss Chance"], tooltip=LOC["|cff00f26dTips and Info!|r\n\nMiss chance with melee weapons against an NPC of the same level"], },
		MeleeBoss = { label=LOC[" Miss vs Boss |cff00f26d+|r"], tooltip=LOC["|cff00f26dSinLive™ Stat! \nThis stat is interactive and will scale based on your current target!|r\n\nMiss chance with melee weapons against an NPC of Boss Levels\n\n|cffF0851ADefault Value:|r NPC of +3 Levels\n|cffF0851AScaling:|r NPC of +1 to +5 Levels"], },
		Avoidance = { label=LOC[" Avoidance |cff00f26d+|r"], tooltip=LOC["|cff00f26dSinLive™ Stat!\nThis stat is interactive and will scale based on your current target!|r\n\nChance to avoid Crushing Blows \nA green |cff00f26dAvoidance|r text indicates that you are uncrushable \n\n|cffF0851ADefault Value:|r NPC +3 Levels\n|cffF0851AScaling:|r \n|cffAAD372Scorpid Sting|r \n|cffFF7C0AInsect Swarm debuffs"], },	
		Crushing = { label=LOC[" Crushing |cff00f26d+|r"], tooltip=LOC["|cff00f26dSinLive™ Stat!\nThis stat is interactive and will scale based on your current target!|r\n\nChance to be hit by a Crushing Blow \nA green |cff00f26dCrushing|r text indicates that you are uncrushable \n\n|cffF0851ADefault Value:|r NPC +3 Levels\n|cffF0851AScaling:|r \n|cffAAD372Scorpid Sting|r \n|cffFF7C0AInsect Swarm debuffs"], },			
		CritReceived = { label=LOC[" Critically Hit |cff00f26d+|r"], tooltip=LOC["|cff00f26dSinLive™ Stat!\nThis stat is interactive and will scale based on your current target!|r\n\nChance to get Critically hit by an NPC \nA green |cff00f26dCrtically Hit|r text indicates that you cannot be critically hit\nA red |cffd4080cCrtically Hit|r indicates that you are under the critical hit cap\n\n|cffF0851ADefault Value:|r NPC +3 Levels\n|cffF0851AScaling:|r \n|cffFF7C0ASurvival of the Fittest|r"], },					
		HasteRanged = {  label=LOC[" Haste"], tooltip=LOC["|cff00f26dTips and Info!|r\n\nHaste bonus percentage from abilities procs, enchants\ntalents, trinkets, consumables, and buffs"], },
		rangedSpeed = {  label=LOC[" Attack Speed"], tooltip=LOC["|cff00f26dTips and Info!|r\n\nWeapon speed of the equipped range weapon"], },		
		RangedMiss = { label=LOC[" Miss Chance"], tooltip=LOC["|cff00f26dTips and Info!|r\n\nMiss chance with ranged weapons against an NPC of the same level"], },
		RangedBoss = { label=LOC[" Miss vs Boss |cff00f26d+|r"], tooltip=LOC["|cff00f26dSinLive™ Stat! \nThis stat is interactive and will scale based on your current target!|r\n\nMiss chance with range weapons against an NPC of +3 levels\n\n|cffF0851ADefault Value:|r NPC of +3 Levels\n|cffF0851AScaling:|r NPC of +1 to +5 Levels"], },
		SpellHit = { label=LOC[" Hit"], tooltip=LOC["|cff00f26dTips and Info!|r\n\nTalent spell-specific Hit is colored"], },
		HasteCaster = { label=LOC[" Haste"], tooltip=LOC["|cff00f26dTips and Info!|r\n\nHaste bonus percentage from abilities procs,\ntalents, trinkets, consumables and buffs"], },
		SpellMiss = { label=LOC[" Miss Chance"], tooltip=LOC["|cff00f26dTips and Info!|r\n\nMiss chance against an NPC of the same level"], },
		SpellBoss = { label=LOC[" Miss vs Boss"], tooltip=LOC["|cff00f26dTips and Info!|r\n\nMiss chance against an NPC of +3 levels with Spells"], },
		ManaRegen = { label=LOC[" Mana Regen"], tooltip=LOC["|cff00f26dTips and Info!|r\n\nMana Regeneration per tick (every 2 secs),\nalso known as MP2 (outside 5-sec rule). \nIt reflects the mana bar regeneration"], },
		CastingRegen = { label=LOC[" Casting Regen"], tooltip=LOC["|cff00f26dTips and Info!|r\n\nMana Regeneration per tick (every 2 secs) while casting.\nAlso known as MP2 (inside 5-sec rule).\n It reflects the mana bar regeneration"], },
		MP5 = { label=LOC[" MP5"], tooltip=LOC["|cff00f26dTips and Info!|r\n\nMana Regeneration per 5 seconds (Outside 5-second rule)"], },
		MP5Casting = { label=LOC[" Casting MP5"], tooltip=LOC["|cff00f26dTips and Info!|r\n\nMana Regeneration per 5 seconds while casting (Inside 5-second rule)"], },		
		Armor = { label=LOC[" Armor"], tooltip=LOC["|cff00f26dTips and Info!|r\n\nEffective Armor, including all modifiers\nA red |cffd4080cArmor|r value indicates that you are affected by a debuff related to this stat"], },
		Resilience = { label=LOC[" Resilience"], tooltip=LOC["|cff00f26dTips and Info!|r\n\nPercentage of periodic damage reduction, chance \nto be critically hit and damage reduction of mana drains \nand critical strikes"], },		
		DMGReduc = { label=LOC[" Mitigation"], tooltip=LOC["|cff00f26dTips and Info!|r\n\nPercentage of damage reduction against an NPC of +3 levels"] , },
		Defense = { label=LOC[" Defense"], tooltip=LOC["|cff00f26dTips and Info!|r\n\nDisplays the effective Defense skills. Includes all +Defense sources"], },
		Dodge = { label=LOC[" Dodge"], tooltip=LOC["|cff00f26dTips and Info!|r\n\nDisplays the chance to Dodge an attack. Includes all Dodge rating sources"], },
		Parry = { label=LOC[" Parry"], tooltip=LOC["|cff00f26dTips and Info!|r\n\nDisplays the chance to Parry an attack. Includes all Parry rating sources"], },
		Block = { label=LOC[" Block"], tooltip=LOC["|cff00f26dTips and Info!|r\n\nDisplays the chance to Block an attack. Includes all Block rating sources"], },
		FireResist = { label=LOC[" Fire"], tooltip=LOC["|cff00f26dTips and Info!|r\n\nDisplays the resistance value of the Fire school of magic\nIncludes all sources"], },
		FrostResist = { label=LOC[" Frost"], tooltip=LOC["|cff00f26dTips and Info!|r\n\nDisplays the resistance value of the Frost school of magic\nIncludes all sources"], },
		ShadowResist = { label=LOC[" Shadow"], tooltip=LOC["|cff00f26dTips and Info!|r\n\nDisplays the resistance value of the Shadow school of magic\nIncludes all sources"], },
		ArcaneResist = { label=LOC[" Arcane"], tooltip=LOC["|cff00f26dTips and Info!|r\n\nDisplays the resistance value of the Arcane school of magic\nIncludes all sources"], },	
		NatureResist = { label=LOC[" Nature"], tooltip=LOC["|cff00f26dTips and Info!|r\n\nDisplays the resistance value of the Nature school of magic\nIncludes all sources"], },
		Speed = { label=LOC[" Movement Speed"], tooltip=LOC["|cff00f26dTips and Info!|r\n\nThe current movement speed of your character, in real-time.|nA red |cffd4080cSpeed|r value indicates that you are affected by a slowing\neffect or moving at a slower speed than normal"], },
		Durability = { label=LOC[" Durability"], tooltip=LOC["|cff00f26dTips and Info!|r\n\nDurability percentage of your currently equipped gear and weapons"], },
		BuffCounter = { label=LOC[" Player Buffs"], tooltip=LOC["|cff00f26dTips and Info!|r\n\nDisplays the total number of beneficial auras applied to you"], },
		DebuffCounter = { label=LOC[" Target Debuffs |cff00f26d+|r"], tooltip=LOC["|cff00f26dSinLive™ Stat! \nThis stat is interactive and will scale based on your current target!|r\n\nDisplays the total number of non-beneficial auras (debuffs) applied to your current target\n\n|cffF0851AScaling:|r Targeted NPC"], },		
		Lag = { label=LOC[" Latency [ms]"], tooltip=false, },
		FPS = { label=LOC[" Framerate [FPS]"], tooltip=false, },
		Money = { label=LOC[" Money"], tooltip=LOC["|cff00f26dTips and Info!|r\n\nTotal gold in your current character's possession"], },		
	}
	for i= 1, #AddonTable.DisplayOrder do
		if not 	Configs[AddonTable.DisplayOrder[i].hud] then
			print("|cffff0000MISSING Config entry: ".. AddonTable.DisplayOrder[i].hud.."|r")
		end
	end
	
	------------------------------------------------
	-- Factory functions for creating check boxes --
	------------------------------------------------
	local function OnEnter(self)
		local parent = self.tooltip and self or self:GetParent()
		GameTooltip:SetOwner(parent, "ANCHOR_LEFT")
		GameTooltip:SetText(parent.tooltip)
	end

	local function OnLeave()
		GameTooltip:Hide()
	end

local function CreateCheckBox(parent, name, label, key, entry, tooltip)
        local f = CreateFrame("CheckButton", "$parent"..name, parent, "UICheckButtonTemplate")
        f:SetSize(20, 20)
        f.LabelButton = CreateFrame("Button", "$parentButton", f)
        f.LabelButton:SetHighlightTexture("Interface/QuestFrame/UI-QuestTitleHighlight")
        f.LabelButton:GetHighlightTexture():SetBlendMode("ADD")
        f.LabelButton:SetPoint("LEFT", f, "RIGHT", 5, 0)
        f.LabelButton:SetScript("OnClick", function(self)
            self:GetParent():Click()
        end)
        f.Label = f:CreateFontString("$parentLabel", "OVERLAY")
        f.Label:SetFontObject(GameFontNormal)
        f.Label:SetJustifyV("CENTER")
        f.Label:SetTextColor(1, 1, 1, 1)
        f.Label:SetPoint("LEFT", f.LabelButton)
        local w, h = f.Label:GetSize()
        f.LabelButton:SetSize(w+5, h)
        f.key = key
        f.entry = entry
        f:SetChecked(key[entry])
        f:SetScript("OnClick", function(self)
            self.key[self.entry] = self:GetChecked()
            if not self.ignoreUpdate then
                SinStatsFrame.Stats[self.entry]:SetShown(self:GetChecked())
            end
            SinStatsFrame:ResizeStats()
            SinStatsFrame:RedrawStats()
            PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
        end)
        f:SetScript("OnDisable", function(self)
            self.Label:SetAlpha(0.5)
        end)
        f:SetScript("OnEnable", function(self)
            self.Label:SetAlpha(1)
        end)
        function f:SetText(text)
            self.Label:SetText(text)
            self.LabelButton:SetSize(self.Label:GetSize())
        end
        f:SetText(label)
        if tooltip then
            f.tooltip = tooltip
            f:SetScript("OnEnter",  OnEnter)
            f:SetScript("OnLeave",  OnLeave)
            f.LabelButton:SetScript("OnEnter",  OnEnter)
            f.LabelButton:SetScript("OnLeave",  OnLeave)
        end
        return f
    end

	----------------------------------------------------
	-- Factory functions for creating sheets and tabs --
	----------------------------------------------------
	local function TabOnClick(self) 
		PlaySound(SOUNDKIT.IG_CHARACTER_INFO_TAB)
		local ID = self:GetID()
		self:SetAlpha(1)
		self.widgets:Show()
		local parent = self:GetParent()
		for i=1, #parent.Tabs do
			if i ~= ID then
				parent.Tabs[i]:SetAlpha(0.5)
				parent.Tabs[i].widgets:Hide()
			end
		end
	end
     
	local function CreateTab(id, parent, text)
		local f = CreateFrame("Button", "$parentTab"..id, parent, "ConfigCategoryButtonTemplate")
		f:Hide()
		tinsert(parent.Tabs, f)
		f:SetID(id)
		f:SetText(text)
		local Text = _G[f:GetName().."NormalText"]
		Text:ClearAllPoints()
		Text:SetAllPoints()
		Text:SetJustifyH("CENTER")
		local width = parent:GetWidth() - 20
		f:SetSize(width / 6, Text:GetHeight() + 10)
		f:SetHighlightTexture("Interface\\PaperDollInfoFrame\\UI-Character-Tab-Highlight")
		if id == 1 then
			f:SetPoint("TOPLEFT",parent,"TOPLEFT", 0, 0)
		else
			f:SetPoint("LEFT",parent.Tabs[id-1],"RIGHT", 0, 0)
		end
		f.widgets = CreateFrame("Frame", nil, f)
		f.widgets:Hide()
		f.widgets:SetSize(parent:GetWidth(), parent:GetHeight() - f:GetHeight()) 
		f.widgets:SetPoint("TOPLEFT", parent.Tabs[1], "BOTTOMLEFT")
		f:SetScript("OnClick", TabOnClick)
		f:Show()
		return f
	end

	---------------------------------------
	-- Factory functions for other stuff --
	---------------------------------------
	local function CreateSheetLabel(parent, text)
		local f = parent:CreateFontString("$parentLabel", "OVERLAY");
		f:SetFontObject("GameFontHighlight");
		f:SetText(text)
		return f
	end

	local function AddCheckBoxes(sheet, group, colwidth, rowoffset, coloffset)
        local Entries = {}
        sheet.CheckBoxes = {}
        for i=1, #AddonTable.DisplayOrder do
            if AddonTable.DisplayOrder[i].grp == group then
                tinsert(Entries, i)
            end
        end
        local row = rowoffset
        local col = coloffset
        local colcount = 1
        local rowmax = math.floor(#Entries/3)
        local over = mod(#Entries, 3)
        local rowcount = 0
        for i=1, #Entries do 
            local Settings = AddonTable.DisplayOrder[Entries[i]]
            local ConfigSettings = Configs[Settings.hud]
            local f = CreateCheckBox(sheet, Settings.hud, Settings.icon..ConfigSettings.label, SinStatsDB.Stats, Settings.hud, ConfigSettings.tooltip)
            tinsert(sheet.CheckBoxes, f)
            f:SetPoint("TOPLEFT", sheet, col, row)
            rowcount = rowcount + 1
            if ((over > 0 and colcount <= over) and rowcount == rowmax+1) or (colcount > over and rowcount == rowmax) then
                colcount = colcount + 1
                col = col + colwidth
                row = rowoffset
                rowcount = 0
            else
                row = row - 25
            end
        end
    end

	-------------------------------------------
	-- Hide/Show or Create the config. frame --
	-------------------------------------------
	if SinStatsConfig.Init then
		SinStatsConfig:SetShown(not SinStatsConfig:IsShown())
		return
	end
	local f = SinStatsConfig
	f.Init = true
	f:Show()
	f:SetBackdrop({
		bgFile="Interface/DialogFrame/UI-DialogBox-Background-Dark",
		edgeFile="Interface/DialogFrame/UI-DialogBox-Background-Dark",
		tile=1, tileSize=0, edgeSize=5,
	 })
	f:SetBackdropColor(1,1,1,1)
	f:SetWidth(635)
	f:SetHeight(390)
	f:ClearAllPoints()
	f:SetPoint("CENTER",UIParent)
	f:EnableMouse(true)
	f:RegisterForDrag("LeftButton")
	f:SetScript("OnDragStart", function(self) self:StartMoving() end)
	f:SetScript("OnDragStart", function(self) self:StartMoving() end)
	f:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end)
	f:SetFrameStrata("FULLSCREEN_DIALOG")
	tinsert(UISpecialFrames, "SinStatsConfigFrame")
	f.Close = CreateFrame('Button', '$parentClose', f, "UIPanelCloseButton")
	f.Close:SetPoint('TOPRIGHT', 0,0)
	f.Close:SetSize(25, 25)
	f.Close:SetScript('OnClick', function(self)
		self:GetParent():Hide()
	end)
	
	f.Title = f:CreateFontString(nil, "OVERLAY");
	f.Title:SetFontObject("GameFontHighlight");
	f.Title:SetPoint("TOP", SinStatsConfig, "TOP", 0, -5);
	f.Title:SetText("|cff00f26dSinStats :|r |cffF0851ABurning Crusade Classic|r");		

	local TabSettings = SinStatsDB.Stats
 	f.Tabs = {}
	local tab = CreateTab(1, f, "|cffF0851AHUD|r") 
	tab:ClearAllPoints() 
	tab:SetPoint("TOPLEFT", 10, -40)
	local sheet = tab.widgets
	local colWidth = (sheet:GetWidth()-10)/3
	local colOffset = 35
	local rowOffset = -60
	
	sheet.SubSettings = CreateSheetLabel(sheet, "|cff00f26dGeneral Options|r");	
	sheet.SubSettings.ignoreUpdate = true
	sheet.SubSettings:SetFontObject("GameFontHighlight");
	sheet.SubSettings:SetPoint('TOPLEFT', 105, -50)	
	
	sheet.SndSubSettings = CreateSheetLabel(sheet, "|cff00f26dStats Text Options|r");	
	sheet.SndSubSettings.ignoreUpdate = true
	sheet.SndSubSettings:SetFontObject("GameFontHighlight");
	sheet.SndSubSettings:SetPoint('LEFT', 105, 35)	
	
	local l = sheet:CreateLine()
	l:SetColorTexture(1,0.49,0.04,0.5)
	l:SetStartPoint("LEFT",104,118)
	l:SetEndPoint("RIGHT",-90,118)
	l:SetThickness(1)
	l:Show()
	
	local sndl = sheet:CreateLine()
	sndl:SetColorTexture(1,0.49,0.04,0.5)
	sndl:SetStartPoint("LEFT",104,27)
	sndl:SetEndPoint("RIGHT",-90,27)
	sndl:SetThickness(1)
	sndl:Show()
	
	sheet.Reset = CreateFrame('Button', '$parentReset', sheet, "UIMenuButtonStretchTemplate")
	sheet.Reset:SetSize(60, 40)
	sheet.Reset:SetText(LOC["Reset \nPosition"])
	sheet.Reset:SetPoint("BOTTOMLEFT", -6, 43)
	sheet.Reset:SetScript('OnClick', function(self)
		StaticPopup_Show("SINSTATS_HUD_RESET")
	end)	
	
	sheet.SigVer = CreateSheetLabel(sheet, "|cff00f26d" .. addVer .. "|r");	
	sheet.SigVer.ignoreUpdate = true
	sheet.SigVer:SetFontObject("GameFontHighlightSmall");	
	sheet.SigVer:SetPoint('BOTTOMRIGHT', -15, 43);				

	sheet.Label = CreateSheetLabel(sheet, LOC["|cffF0851AHUD Settings|r"])
	sheet.Label:SetPoint("TOP", sheet, "TOP", 0, -20);	

	------------------
	-- Enable Frame --
	------------------	
	sheet.Enable = CreateCheckBox(sheet, "Enable", "", SinStatsDB, "SinHideVar", LOC["Enable/Disable the stats frame\nThis option can also be performed by Right-Clicking on the Minimap Button"])
	sheet.Enable.ignoreUpdate = true
	sheet.Enable:SetPoint('TOPLEFT', 105, -73)
	sheet.Enable:HookScript('OnClick', function(self)
	        local Setting = self.key[self.entry]
		self:SetText(Setting and LOC["HUD [|cffd4080cDisabled|r]"] or LOC["HUD [|cff00f26dEnabled|r]"])
		AddonTable:UpdateStatus()
		self:GetParent().Locked:SetEnabled(not Setting)
	end)

	----------------
	-- Lock frame --
	----------------	
	sheet.Locked = CreateCheckBox(sheet, "Locked", "", SinStatsDB, "SinLockVar", LOC["Locks/Unlocks the Stats frame to move it\nThis option can also be performed by Shift + Right-Clicking on the Minimap Button"])
	sheet.Locked.ignoreUpdate = true
 	sheet.Locked:SetPoint('TOP', 50, -73)
 	sheet.Locked:HookScript('OnClick', function(self)
		local Locked = self.key[self.entry]
         	self:SetText(Locked and LOC["HUD [|cffd4080cLocked|r]"] or LOC["HUD [|cff00f26dUnlocked|r]"])
         	AddonTable:UpdateStatus()
	end)
	sheet.Locked:GetScript('OnClick')(sheet.Locked)
	sheet.Enable:GetScript('OnClick')(sheet.Enable)

	--------------------
	-- Minimap button --
	--------------------	
	sheet.mmToggle = CreateCheckBox(sheet, "mmToggle", "", SinStatsDB.minimap, "hide", LOC["Toggle the minimap button"])
	sheet.mmToggle:SetPoint("TOP", sheet.Enable, "BOTTOM", 0, -5);
	sheet.mmToggle.ignoreUpdate = true		
	if SinStatsDB.minimap.hide then
		byPass = true
	else	
		byPass = false
	end
	sheet.mmToggle:SetScript("OnClick", function(self)
    self.key[self.entry] = not self:GetChecked()
    local mmHide = self.key[self.entry]
    self:SetText(mmHide and LOC["Minimap Button [|cffC41E3ADisabled|r]"] or LOC["Minimap Button [|cff00f26dEnabled|r]"])
    if SinStatsDB.minimap.hide and byPass then
		AddonTable.sshMiniButton:Hide("SinStats") 
	elseif SinStatsDB.minimap.hide and not byPass then
		LibDBIcon10_SinStats:Hide()
    elseif not SinStatsDB.minimap.hide and byPass then
		AddonTable.sshMiniButton:Show("SinStats") 
	elseif not SinStatsDB.minimap.hide and not byPass then		
		LibDBIcon10_SinStats:Show()
    end
	end)          
	sheet.mmToggle:SetChecked(not SinStatsDB.minimap.hide)
	sheet.mmToggle:GetScript('OnClick')(sheet.mmToggle)		

	----------------
	-- Stat Icons --
	----------------	
	sheet.Icons = CreateCheckBox(sheet, "Icons", "", SinStatsDB, "IconVar", LOC["Toggles the icons on the HUD"])
	sheet.Icons.ignoreUpdate = true
 	sheet.Icons:SetPoint('TOP', sheet.Locked, 'BOTTOM', 0, -5)
	sheet.Icons:HookScript("OnClick", function(self)
		self:SetText(self.key[self.entry] and LOC["Stats Icons [|cff00f26dEnabled|r]"] or LOC["Stats Icons [|cffd4080cDisabled|r]"])
		SinStatsFrame.AddIcons = self.key[self.entry]
		AddonTable:RunAllEvents()
		SinStatsFrame:GetScript("OnUpdate")(SinStatsFrame, 5)
	end)		
	sheet.Icons:GetScript('OnClick')(sheet.Icons)	

	-------------------
	-- Font Selector --
	-------------------
	local fontSelector = AceGUI:Create("Dropdown")
	local LSMList = LSM:List("font")
	fontSelector:SetList(LSMList)
	 
	fontSelector:SetCallback("OnValueChanged", function(widget, event, key, ...)
		SinStatsDB.FontName = LSMList[key] -- Store the key to initalise the list next time
		SinStatsDB.StatFonts = LSM:Fetch("font", SinStatsDB.FontName) -- Store the font for SetFont
		SinStatsFrame:ResizeStats()  
		AddonTable:RunAllEvents()		
	end)
	
	for k, v in pairs(LSMList) do
		if v == SinStatsDB.FontName then
			fontSelector:SetValue(k)
			break
		end
	end

	fontSelector:SetLabel(LOC["|cffFFFFFFChange Fonts|r"])
	fontSelector:SetWidth(150)
	fontSelector.frame:SetParent(sheet)
	fontSelector.frame:SetPoint("LEFT", 110, 0)
	
	------------------
	-- Text Outline --
	------------------
	local textOuline = AceGUI:Create("Dropdown")
	textOuline:SetList({
	"Thin", "Thick", "Monochrome", "Thin Monochrome", "Thick Monochrome", "None"
	})
	textOuline:SetCallback("OnValueChanged", function(widget, event, key)
		SinStatsDB.OutlineKey = key
		SinStatsDB.OutlineText = OutlineStyle[key]
		print(SinStatsDB.OutlineText)
		SinStatsFrame:ResizeStats()
		AddonTable:RunAllEvents()		
		--SinStatsFrame:RedrawStats()
    end)
    textOuline:SetValue(SinStatsDB.OutlineKey)
    textOuline:SetLabel(LOC["|cffFFFFFFText Outline|r"])
	textOuline:SetWidth(135)
    textOuline.frame:SetParent(sheet)
	textOuline.frame:SetPoint("CENTER", 25, 0)
	
	---------------------
	-- Stats Alignment -- 
	---------------------
	local TextAlignment = AceGUI:Create("Dropdown")
	TextAlignment:SetList({
	"Left", "Right"
	})
	TextAlignment:SetCallback("OnValueChanged", function(widget, event, key)

	if SinStatsDB.TextIdentKey == 2 and SinStatsDB.SinDirection then
		SinStatsDB.TextIdentKey = 1
		SinStatsFrame:RedrawStats()
		AddonTable:RunAllEvents()
		TextAlignment:SetValue(SinStatsDB.TextIdentKey)
	else
		SinStatsDB.TextIdentKey = key
		SinStatsFrame:RedrawStats()
		AddonTable:RunAllEvents()		
	end
		
    end)
    TextAlignment:SetValue(SinStatsDB.TextIdentKey)
    TextAlignment:SetLabel(LOC["|cffFFFFFFStats Alignment|r"])
	TextAlignment:SetWidth(125)
    TextAlignment.frame:SetParent(sheet)
	TextAlignment.frame:SetPoint("CENTER", 170, 0)	
	
	----------------
	-- Stat Order --
	----------------		
	local statsOrder = AceGUI:Create("Dropdown")
	statsOrder:SetList({
	"Default", "Tab"
	})
	statsOrder:SetCallback("OnValueChanged", function(widget, event, key)
		SinStatsDB.OrderKey = key
		if SinStatsDB.OrderKey == 1 then
			SinStatsDB.GroupOrder = false
		else
			SinStatsDB.GroupOrder = true
		end
		SinStatsFrame:RedrawStats()
    end)
    statsOrder:SetValue(SinStatsDB.OrderKey)
    statsOrder:SetLabel(LOC["|cffFFFFFFStats Grouping|r"])
	statsOrder:SetWidth(125)
    statsOrder.frame:SetParent(sheet)
	statsOrder.frame:SetPoint("LEFT", 110, -50)		


	--------------------
	-- Text Alignment --
	--------------------	
	sheet.Direction = CreateCheckBox(sheet, "Direction", "", SinStatsDB, "SinDirection", LOC["Changes the direction of the stats, between vertical and horizontal\nIf Horizontal is selected, you will have the option to set the\nnumber of stats displayed per row"])
    sheet.Direction.ignoreUpdate = true
    sheet.Direction:SetPoint('TOP', sheet.Icons, 'BOTTOM', 65, -110)
    sheet.Direction:HookScript('OnClick', function(self)
        local Setting = self.key[self.entry]
        self:SetText(Setting and LOC["Text Rows [|cffF2A427Horizontal|r]"] or LOC["Text Rows [|cff00f26dVertical|r]"])
        SinStatsFrame:RedrawStats()
        self:GetParent().Rows:SetShown(self:GetChecked())
		if Setting then
		SinStatsDB.TextIdentKey = 1
		TextAlignment:SetValue(SinStatsDB.TextIdentKey)
		SinStatsFrame:RedrawStats()
		AddonTable:RunAllEvents()
		end
    end)
    sheet.Direction:SetText(SinStatsDB.SinDirection and LOC["Text Rows [|cffF2A427Horizontal|r]"] or LOC["Text Rows [|cff00f26dVertical|r]"])

	---------------	
	-- Text Rows --
	---------------	
	sheet.Rows = CreateFrame("Slider", "SinStatsSlider", sheet, 'OptionsSliderTemplate')
    sheet.Rows:SetShown(SinStatsDB.SinDirection)
    sheet.Rows:SetPoint("TOPLEFT", sheet.Direction, "BOTTOMLEFT", 20, -16)
    sheet.Rows.Low:SetText('1'); 
    sheet.Rows.High:SetText('5');   
    sheet.Rows.Text:SetText('Stats Rows');
    sheet.Rows:SetMinMaxValues(1, 5)
    sheet.Rows:SetValueStep(1)
    sheet.Rows.key = SinStatsDB
    sheet.Rows.entry = "StatRows"
    sheet.Rows:SetValue(SinStatsDB.StatRows or 1)
    sheet.Rows.Label = sheet.Rows:CreateFontString(nil, "OVERLAY");
    sheet.Rows.Label:SetFontObject("GameFontHighlightSmall");
    sheet.Rows.Label:SetPoint("TOP", sheet.Rows, "BOTTOM", 3, 0);     
    sheet.Rows:SetScript("OnValueChanged", function (self)
        local value = math.floor(self:GetValue())
        self.key[self.entry] = value
        SinStatsFrame:RedrawStats()
        self.Label:SetText(LOC["Current: "] .. self.key[self.entry])
    end)
    sheet.Rows:GetScript("OnValueChanged")(sheet.Rows)	

	----------------	
	-- Text Style --
	----------------	
	local textStyle = AceGUI:Create("Dropdown")
	textStyle:SetList({
	"Normal", "Short"
	})
	if (SinStatsDB.SinAbrev == false) then
		SinStatsDB.StyleKey = 1
	else
		SinStatsDB.StyleKey = 2
	end
	textStyle:SetCallback("OnValueChanged", function(widget, event, key)
		SinStatsDB.StyleKey = key
		if SinStatsDB.StyleKey == 1 then
			SinStatsDB.SinAbrev = false
		else
			SinStatsDB.SinAbrev = true
		end
		AddonTable:RunAllEvents()
    end)
    textStyle:SetValue(SinStatsDB.StyleKey)
    textStyle:SetLabel(LOC["|cffFFFFFFText Style|r"])
	textStyle:SetWidth(125)
    textStyle.frame:SetParent(sheet)
	textStyle.frame:SetPoint("CENTER", 25, -50)	

	---------------	
	-- Text Size --
	---------------
	sheet.Size = CreateFrame("Slider", "SinStatsSlider", sheet, 'OptionsSliderTemplate')
	sheet.Size:SetPoint('TOP', sheet.mmToggle, 'BOTTOM', 70, -160)
	sheet.Size.Low:SetText('8'); 
	sheet.Size.High:SetText('40');   
	sheet.Size.Text:SetText(LOC['Text Size']);
	sheet.Size:SetMinMaxValues(8, 40)
	sheet.Size:SetValueStep(1)
	sheet.Size.key = SinStatsDB
	sheet.Size.entry = "StatFontSize"
	sheet.Size:SetValue(SinStatsDB.StatFontSize)
	sheet.Size.Label = sheet.Size:CreateFontString(nil, "OVERLAY");
	sheet.Size.Label:SetFontObject("GameFontHighlightSmall");
	sheet.Size.Label:SetPoint("TOP", sheet.Size, "BOTTOM", 0, -5);		
	sheet.Size:SetScript("OnValueChanged", function (self)
		local value = math.floor(self:GetValue())
		self.key[self.entry] = value
		SinStatsFrame:RedrawStats()
		SinStatsFrame:ResizeStats()		
		AddonTable:RunAllEvents()		
		self.Label:SetText("Current: " .. self.key[self.entry])
	end)
	sheet.Size:GetScript("OnValueChanged")(sheet.Size)

	for grp=1, #AddonTable.Groups do
		tab = CreateTab(grp+1, f, AddonTable.Groups[grp])
		sheet = tab.widgets 
		sheet.Label = CreateSheetLabel(sheet, "|cffF0851A"..AddonTable.Groups[grp]..LOC[" Settings|r"])
		sheet.Label:SetPoint("TOP", sheet, "TOP", 0, -30);
		AddCheckBoxes(sheet, grp, colWidth, rowOffset, colOffset)
		
		sheet.EnableAll = CreateFrame('Button', '$parentEnableAll', sheet, "UIMenuButtonStretchTemplate")
		sheet.EnableAll:SetSize(110, 25)
		sheet.EnableAll:SetText(LOC["Enable All Stats"])
		sheet.EnableAll:SetPoint('BOTTOMLEFT', 0, 43)
		sheet.EnableAll:SetScript('OnClick', function(self)
		PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
		local Parent = self:GetParent()
			for k, v in ipairs(Parent.CheckBoxes) do
				v:SetChecked(true)
				v.key[v.entry] = true
				if not v.ignoreUpdate then
					SinStatsFrame.Stats[v.entry]:Show()
				end
			end
			SinStatsFrame:RedrawStats()
			SinStatsFrame:ResizeStats()		
			AddonTable:RunAllEvents()
		end)	
		
		sheet.DisableAll = CreateFrame('Button', '$parentDisableAll', sheet, "UIMenuButtonStretchTemplate")
		sheet.DisableAll:SetSize(110, 25)
		sheet.DisableAll:SetText(LOC["Disable All Stats"])
		sheet.DisableAll:SetPoint('BOTTOMLEFT', 120, 43)
		sheet.DisableAll:SetScript('OnClick', function(self)
		PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
		local Parent = self:GetParent()
			for k, v in ipairs(Parent.CheckBoxes) do
				v:SetChecked(false)
				v.key[v.entry] = false
				if not v.ignoreUpdate then
					SinStatsFrame.Stats[v.entry]:Hide()
				end
			end
			SinStatsFrame:RedrawStats()
			SinStatsFrame:ResizeStats()		
			AddonTable:RunAllEvents()					
		end)
		
	end
	
	TabOnClick(f.Tabs[1])	
	
	--------------------------------------
	-- Factory function for break lines --
	--------------------------------------
	local function CreateOptionLine(parent)
		local f = parent:CreateLine()
			f:SetColorTexture(1,0.49,0.04,0.5)
			f:SetStartPoint("LEFT",120,137)
			f:SetEndPoint("RIGHT",-120,137)
			f:SetThickness(1)
			f:Show()
		return f
	end	
	
	sheet.OptionLine = CreateOptionLine(SinStatsConfigFrameTab2.widgets)
	sheet.OptionLine = CreateOptionLine(SinStatsConfigFrameTab3.widgets)
	sheet.OptionLine = CreateOptionLine(SinStatsConfigFrameTab4.widgets)
	sheet.OptionLine = CreateOptionLine(SinStatsConfigFrameTab5.widgets)
	sheet.OptionLine = CreateOptionLine(SinStatsConfigFrameTab6.widgets)
	
end

SinStatsOptions = {};

SinStatsOptions.panel = CreateFrame( "Frame", "SinStatsOptionsPanel", UIParent );
SinStatsOptions.panel.name = "SinStats";
InterfaceOptions_AddCategory(SinStatsOptions.panel);


local maintitle = SinStatsOptions.panel:CreateFontString("MainTitle", "OVERLAY", "GameFontHighlightLarge")
maintitle:SetPoint("TOP", "SinStatsOptionsPanel", "TOP", 0, -15)
maintitle:SetText("|cff00f26dSinStats|r")
maintitle:SetFont("Fonts\\FRIZQT__.TTF", 45)

local wowversion = SinStatsOptions.panel:CreateFontString("WowVersion", "OVERLAY", "GameFontHighlightLarge")
wowversion:SetPoint("TOP", "MainTitle", "BOTTOM", 0, -10)
wowversion:SetText("|cffF2A427Burning Crusade Classic|r")
wowversion:SetFont("Fonts\\FRIZQT__.TTF", 30)

local OptionButton = CreateFrame('Button', '$parentSinStatsOptionsPanel', SinStatsOptionsPanel, "UIPanelButtonTemplate")
OptionButton:SetPoint("TOP", "WowVersion", "BOTTOM", 0, -40)
OptionButton:SetSize(160, 25)
OptionButton:SetText("|cffFFFFFFOpen SinStats Settings|r")
OptionButton:SetScript('OnClick', function(self)
	InterfaceOptionsFrame:Hide()
	HideUIPanel(GameMenuFrame)
	AddonTable:ToggleConfig()
end)

local tipText = SinStatsOptions.panel:CreateFontString("TipText", "OVERLAY", "GameFontHighlight")
tipText:SetPoint("TOP", "WowVersion", "BOTTOM", 0, -150)
tipText:SetText("|cffF2A427The settings panel can be accessed with the commands " .. "|cff00f26d/sinstats|r" .. " or " .. "|cff00f26d/ss|r")

local tipTextSnd = SinStatsOptions.panel:CreateFontString("TipTextSnd", "OVERLAY", "GameFontHighlight")
tipTextSnd:SetPoint("TOP", "TipText", "BOTTOM", 0, -3)
tipTextSnd:SetText("|cffF2A427The" .." |cff00f26dminimap button|r" .. " can also be used to quickly access the settings.|r")

local VersionText = SinStatsOptions.panel:CreateFontString("VersionText", "OVERLAY", "GameFontHighlight")
VersionText:SetPoint("TOP", "TipTextSnd", "BOTTOM", 0, -70)
VersionText:SetText("|cffF2A427Version:|r " .. "|cff00f26d" .. addVer .. "|r")

local authorText = SinStatsOptions.panel:CreateFontString("authorText", "OVERLAY", "GameFontHighlight")
authorText:SetPoint("TOP", "VersionText", "BOTTOM", 0, -10)
authorText:SetText("|cffF2A427Author:|r |cff00f26dSinba|r")



