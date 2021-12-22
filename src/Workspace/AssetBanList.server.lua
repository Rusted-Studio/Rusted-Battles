--[[ -- -- 

== Nikilis' Asset Ban List ==

This script allows developers to ban specfic assets from their game.
The main purpose of this script was to delete assets uploaded through UGC
that disrupt competitive gameplay. You can customize it to restrict any type
of assets though!

-- -- -- ]]


-- Add specific assets you want to ban here!

local CustomBanList= {
	
	[4794183296] = true; -- Big box 
	[4793971886] = true; -- Filing cabinet
	
	
	-- Add more here by copy and pasting one of the lines above.
	
	[4793971886] = true;
	
	--
};

-- This grabs all assets that have been decided are problematic for competitive games.
-- Set this to false if your game is a social game without competitive gameplay.

local UseGlobalBanList = true; -- Set to false if you don't want to ban huge assets.
local GlobalBanList = require( 4797702287 ); -- Set this to 4797702287 to use Nik's Ban List.

-- Nikilis' Global Ban List can be viewed here:
-- https://www.roblox.com/library/4797702287/Asset-Ban-List


-- Here you can add package/body parts to ban. Some Rthro packages allow you to cheat in games. 

local BanBodyParts = true;

local BodyPartBanList = {
	
	[2608536258] = true; -- Magma Fiend Legs allow you to shrink your character unreasonably.
	[2608538559] = true; -- Magma Fiend
	
};



-- Don't edit below this line unless you are a scripter.
---------------------------------------------------------

local CompletedBanList = {};
for ID,_ in pairs(CustomBanList) do CompletedBanList[ID] = true; end;
if UseGlobalBanList and GlobalBanList then
	for ID,_ in pairs(GlobalBanList) do CompletedBanList[ID] = true; end;
end

local AccessoryTypes = {"Back","Face","Front","Hair","Hat","Neck","Shoulders","Waist"};
local BodyPartTypes = {"Face","Head","LeftArm","LeftLeg","RightArm","RightLeg","Torso"};
local function ClearBannedAssets( Character )
	local Humanoid = Character:WaitForChild("Humanoid");
	local Description = Humanoid:GetAppliedDescription(); 
	
	-- Cycle through accessory types
	for _,AccessoryPart in pairs(AccessoryTypes) do
		local AccessoryType = AccessoryPart.."Accessory";
		local EquippedAccessorysString = Description[ AccessoryType ];
		for BannedAsset,_ in pairs(CompletedBanList) do
			EquippedAccessorysString = string.gsub( EquippedAccessorysString, BannedAsset, "");
		end
		Description[ AccessoryType ] = EquippedAccessorysString;
	end;
	
	-- Ban Body Parts
	if BanBodyParts then
		for _,BodyPart in pairs(BodyPartTypes) do
			local EquippedPart = Description[BodyPart];
			if BodyPartBanList[EquippedPart] then
				Description[BodyPart] = 0;
			end
		end
	end;
	
	-- Apply Description can only be called if the Character is in the Workspace.
	repeat wait(); until Character.Parent~=nil or Character==nil;
	Humanoid:ApplyDescription( Description );
end

game.Players.PlayerAdded:Connect(function( Player ) Player.CharacterAdded:connect( ClearBannedAssets ) end)

-- Studio 
for _,Player in pairs(game.Players:GetPlayers()) do
	if Player.Character then ClearBannedAssets( Player.Character ); end;
end
--

--[[
	Here is a simple thing you can copy and paste into the command bar to print all the assets in the bundle,
	if you want to ban a specific bundle asset.
	
	--
	local BundleID = 429;
	local BundleDetails  = game:GetService("AssetService"):GetBundleDetailsAsync(429); 
	for i,ItemData in pairs(BundleDetails.Items) do
		print("--"); 
		print("ID:",ItemData.Id)
		print("Name:",ItemData.Name);
	end;
	--
]]