-- if player chat bad words from this lsit it will be tagged
BadWords = {"robux.me", "freerobux.com", "fastbucks.me", "globux.me", "get-bux.me", "robuxgiver.tk", "freebux4u.com", "REDVALK", "roblox.news", "roboxwin.com", "rbxfree.com", "boostmyrobux.info", "get-bux .me", "get-bux. me", "get-bux . me", "oprewards.me", "bux.gg", "generate ROBUX", "gamepasses FREE", "earnpoints.gg", "bux.today"}

local function Run(ChatService)
	local function applyExtraFilters(sender, message, channelName)
		for _,BadWord in ipairs(BadWords) do
			local first,last = string.find(string.lower(message), string.lower(BadWord), 1, true)
			if first then
				return true
			end
		end
		return false
	end
	
	ChatService:RegisterProcessCommandsFunction("applyExtraFilters", applyExtraFilters)
end
 
return Run
-- Its bread boi