local module = {}

function module.onEnable(entity, component)

	local lamp = entity

	for index, possibleClickDetector in pairs(lamp:GetDescendants()) do
		if possibleClickDetector:IsA("ClickDetector") then
			possibleClickDetector.MouseClick:connect(function()
				for index, possibleLight in pairs(lamp:GetDescendants()) do
					if possibleLight:IsA("Light") then
						possibleLight.Enabled = not possibleLight.Enabled
					end
				end
			end)
		end
	end
end

return module
