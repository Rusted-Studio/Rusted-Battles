local barrel = script.Parent
local damageModel = barrel.Humanoid
local fire = barrel.Torso:FindFirstChild("Fire")
if not fire then
	fire = Instance.new("Fire", barrel.Torso)
	fire.Color = Color3.new(255/255,127/255,0/255)
	fire.Enabled = false
	fire.SecondaryColor = Color3.new(1, 0, 0)
	fire.Size = 8
end
local smoke = barrel.Torso:FindFirstChild("Smoke")
if not smoke then
	smoke = Instance.new("Smoke", barrel.Torso)
	smoke.Color = Color3.new(0, 0, 0)
	smoke.Enabled = false
	smoke.Opacity = 0.8
	smoke.RiseVelocity = 4
	smoke.Size = 0.25
end
local maxHealth = barrel.Humanoid.MaxHealth
local startedBurning = false
damageModel.Health = maxHealth

local burnPart = Instance.new("Part", barrel)
burnPart.CanCollide = false
burnPart.Anchored = true
burnPart.Transparency = 1
burnPart.Name = "BurnPart"
burnPart.Size = Vector3.new(1,1,1)

fire.Parent = burnPart
smoke.Parent = burnPart

if game.Workspace.FilteringEnabled then
	if not game.ReplicatedStorage:FindFirstChild("ROBLOXExplodingBarrelEvent") then
		local explodeEvent = Instance.new("RemoteEvent", game.ReplicatedStorage)
		explodeEvent.Name = "ROBLOXExplodingBarrelEvent"
	end
		
	
	game.Players.PlayerAdded:connect(function(player)
	local backpack = player:WaitForChild("Backpack")
	if not backpack:FindFirstChild("ROBLOXBarrelLocalScript") then
		local localScript = barrel.ROBLOXBarrelLocalScript:clone()
		localScript.Parent = player:WaitForChild("Backpack")
	end
	end)
end

local function getConfig(configName, default)
	local configs = barrel:FindFirstChild("Configurations")
	if configs and configs:FindFirstChild(configName) then
		return configs:FindFirstChild(configName).Value or default
	end
	return default
end

local blastPressure = getConfig("BlastPressure", 50000)
local blastRadius = getConfig("BlastRadius", 6)

local function burn()
	while damageModel.Health > 0 do
		damageModel.Health = damageModel.Health - 2
		wait(.3)
	end
	return
end
local burnThread = coroutine.create(burn)

local healthConnection
local diedConnection

local function onDied()
	healthConnection:disconnect()
	diedConnection:disconnect()
	local explosion = Instance.new("Explosion", barrel.Torso)
	explosion.BlastPressure = blastPressure
	explosion.Position = barrel.Torso.Position
	explosion.BlastRadius = blastRadius
	explosion.DestroyJointRadiusPercent = 1
	explosion.ExplosionType = Enum.ExplosionType.NoCraters
	if game.Workspace.FilteringEnabled then
		game.ReplicatedStorage.ROBLOXExplodingBarrelEvent:FireAllClients(barrel)
	else
		for _, part in pairs(barrel:GetChildren()) do
			if part and part:IsA("BasePart") and part.Name ~= "BurnPart" and part.Name ~= "Torso" and part.Name ~= "Head" then
				part.CanCollide = true				
				
				local firePart = Instance.new("Part", barrel)
				firePart.CanCollide = false
				firePart.Anchored = true
				firePart.Transparency = 1
				
				local partFire = Instance.new("Fire", firePart)
				partFire.Enabled = true
				partFire.Size = math.ceil(2 * (part.Size.X + part.Size.Y + part.Size.Z) / 3)
				
				local burnOutThread = coroutine.create(function()
					local start = os.time()
					local waitTime = math.random(3, 5)
					while partFire.Size > 2 do
						if os.time() - start > waitTime then
							start = os.time()
							partFire.Size = partFire.Size - .5
						end
						firePart.Position = part.Position
						wait()
					end
	
					firePart:Destroy()
					wait(waitTime)
					part:Destroy()
				end)
				coroutine.resume(burnOutThread)
			end
		end
	end
	fire.Enabled = false
	smoke.Enabled = false
	barrel.Torso.CanCollide = false
	barrel.Torso.Transparency = 1
	wait(1)
	burnPart:Destroy()
	if barrel:FindFirstChild("Torso") then
		barrel.Torso:Destroy()
	end
	
	if barrel:FindFirstChild("Head") then
		barrel.Head:Destroy()
	end
	
	if barrel:FindFirstChild("Humanoid") then
		barrel.Humanoid:Destroy()
	end
end

healthConnection = damageModel.HealthChanged:connect(function(health)
	if health < maxHealth / 3 then
		if not startedBurning then
			startedBurning = true
			coroutine.resume(burnThread)
		end
		fire.Enabled = true
		fire.Size = 8
		smoke.Enabled = true
	elseif health < maxHealth * 2 / 3 then
		if not startedBurning then
			startedBurning = true
			coroutine.resume(burnThread)
		end
		fire.Enabled = true
		fire.Size = 5
	elseif health < maxHealth then
		fire.Enabled = true
		fire.Size = 3
	end
	if health <= 0 then
		onDied()
	end
end)

diedConnection = damageModel.Died:connect(onDied)
damageModel:ChangeState(Enum.HumanoidStateType.Physics)
while true do
	--damageModel:ChangeState(Enum.HumanoidStateType.Ragdoll)
	if barrel:FindFirstChild("Torso") and barrel:FindFirstChild("BurnPart") then
		burnPart.Position = barrel.Torso.Position
	end
	wait()
end