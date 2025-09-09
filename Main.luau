local StackManager = {}

type StackData = {
	Name : string,
	LifeTime : number,
}

type MinusData = {
	Name : string,
	Object : Instance
}

local function MinusStack(Data : MinusData)
	local Name = Data["Name"]
	local Object = Data["Object"]
	if Name and Object then
		local Stack = Object:GetAttribute(Name) or 0
		local Minus = math.clamp(Stack - 1, 0, 256)
		if Stack > 0 then
			Object:SetAttribute(Name, Minus)
		else
			Object:SetAttribute(Name, nil)
		end
	end
end

local function AddStack(Object : Instance, Data : StackData)
	local Name = Data["Name"]
	local LifeTime = Data["LifeTime"] or 1
	if Object and typeof(Name) == "string" then
		local Stack = Object:GetAttribute(Name) or 0
		Object:SetAttribute(Name, Stack + 1)
		task.delay(LifeTime, MinusStack, 
			{
				["Name"] = Name,
				["Object"] = Object
			}
		)
	end
end

local function ResetStack(Object : Instance, Name : string)
	if Object and typeof(Name) == "string" then
		Object:SetAttribute(Name, nil)
	end
end

StackManager.AddStack = AddStack
StackManager.ResetStack = ResetStack

return StackManager
