local burnerOn = false
local handle = script.Parent.Interactive
local sound = handle.Click
local burnerSound = handle.Burner

handle.ClickDetector.MouseClick:Connect(function()
	sound:Play()		
	if burnerOn then
		burnerSound:Stop()
		handle.CFrame = handle.CFrame * CFrame.Angles(0, math.rad(-45), 0)
		burnerOn = false
		for i, v in pairs(script.Parent:GetChildren()) do
			if v.Name == "Flame" then
				for i, c in pairs(v:GetChildren()) do
					c.Rate = 0
				end
			end
		end
	else
		burnerOn = true
		burnerSound:Play()
		handle.CFrame = handle.CFrame * CFrame.Angles(0, math.rad(45), 0)
		for i, v in pairs(script.Parent:GetChildren()) do
			if v.Name == "Flame" then
				for i, c in pairs(v:GetChildren()) do
					c.Rate = 1000
				end
			end
		end
	end
end)