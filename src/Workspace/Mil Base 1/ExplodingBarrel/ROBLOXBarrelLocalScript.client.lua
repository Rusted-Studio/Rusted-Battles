if game.Workspace.FilteringEnabled then
	game.ReplicatedStorage.ROBLOXExplodingBarrelEvent.OnClientEvent:connect(function(barrel)
		print("remote fired")
		if barrel then
			for _, part in pairs(barrel:GetChildren()) do
				if part and part:IsA("BasePart") and part.Name ~= "BurnPart" and part.Name ~= "Torso" and part.Name ~= "Head" then
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
					end)
					coroutine.resume(burnOutThread)
				end
			end
		end
	end)
end
