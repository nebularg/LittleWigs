﻿-------------------------------------------------------------------------------
--  Module Declaration 

-- "Portals" isn't going to work, gonna have to rethink that
local mod = BigWigs:NewBoss("Portals", "The Violet Hold")
mod.partyContent = true
mod.otherMenu = "Dalaran"
mod:RegisterEnableMob(30658)
mod.toggleOptions = {"portals", "bosskill"}

-------------------------------------------------------------------------------
--  Localization

local L = mod:NewLocale("enUS", true)
if L then
--@do-not-package@
L["portals"] = "Portals"
L["next_portal"] = "Portal %d"
L["portal_opened"] = "Portal %d opened"
L["portals_desc"] = "Information about portals after a boss dies."
L["portal_message15s"] = "Portal %d in ~15 seconds!"
L["portal_message120s"] = "Portal %d in ~120 seconds!"
L["portal_message95s"] = "Portal %d in ~95 seconds!"--@end-do-not-package@
--@localization(locale="enUS", namespace="Dalaran/The_Violet_Hold", format="lua_additive_table", handle-unlocalized="ignore")@
end
L = mod:GetLocale()
mod.displayName = L["portals"]

-------------------------------------------------------------------------------
--  Initialization
local lastportal = 0

function mod:OnBossEnable()
	self:RegisterEvent("UPDATE_WORLD_STATES")
	self:Death("Deaths", 29315,29316,29313,29266,29312,29314,32226,32230,32231,32234,32235,32237)
	self:Death("Disable", 31134)
end

-------------------------------------------------------------------------------
--  Event Handlers

function mod:Deaths()
	self:Message("portals", L["portal_message95s"]:format(lastportal+1), "Attention", "INV_Misc_ShadowEgg")
	self:DelayedMessage("portals", 80, L["portal_message15s"]:format(lastportal+1), "Attention", "INV_Misc_ShadowEgg")
	self:Bar("portals", L["next_portal"]:format(lastportal+1), 95, "INV_Misc_ShadowEgg")
end


function mod:UPDATE_WORLD_STATES()
	local text = select(3, GetWorldStateUIInfo(2))
	if not text then return end
	local portal = tonumber(text:match("([0-9]+)/18")) or 0
	if portal < lastportal then -- wiped probably
		lastportal = 0
	elseif portal > lastportal then
		self:SendMessage("BigWigs_StopBar", self, L["next_portal"]:format(lastportal+1))
		self:CancelDelayedMessage(L["portals_message15s"]:format(lastportal+1))
		if portal ~= 6 and portal ~= 12 and portal ~= 18 then
			self:Message("portals", L["portal_opened"]:format(portal), "Important", "INV_Misc_ShadowEgg")
			self:Bar("portals", L["next_portal"]:format(portal+1), 120, "INV_Misc_ShadowEgg")
			self:DelayedMessage("portals", 105, L["portal_message15s"]:format(portal+1), "Attention", "INV_Misc_ShadowEgg")
		end
		lastportal = portal
	end
end
