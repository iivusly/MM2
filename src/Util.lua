local Util = {
	QuickBuild = function(ClassName, Parent, Properties)
		local Inst = Instance.new(ClassName)
		
		if (Properties) then
			for i,v in next, Properties do
				pcall(function()
					Inst[i] = v
				end)
			end
		end
		
		Inst.Parent = Parent
		
		return Inst
	end,
}

return Util