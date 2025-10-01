local StackManager = {}
local StackStore = {}

type StackData = {
	Name : string,
	LifeTime : number,
}

type MinusData = {
	Name : string,
	Object : Instance
}

local function MinusStack(Object : Instance, Name : string)
	if Object and Name then
		local Stack = Object:GetAttribute(Name) or 0
		local Minus = math.clamp(Stack - 1, 0, 256)
		Object:SetAttribute(Name, Minus > 0 and Minus or nil)
	end
end

local function HandleStack(Object : Instance, Name : string, LifeTime : number, Debug : boolean)
	local Tick = tick()
	local Ignore = false
	repeat task.wait()
		local TimeResume = tick() - Tick
		local Result = Object:GetAttribute(Name)
		local Store = StackStore[Object]
		if Result == nil then
			Ignore = true
			break
		end
	until TimeResume >= LifeTime
	if not Ignore then
		MinusStack(Object, Name)
	end
end

local function AddStack(Object : Instance, Data : StackData)
	local Name = Data["Name"]
	local LifeTime = Data["LifeTime"] or 1
	local Debug = Data["Debug"]
	if Object and typeof(Name) == "string" then
		local Stack = Object:GetAttribute(Name) or 0
		Object:SetAttribute(Name, Stack + 1)
		if typeof(LifeTime) == "number" then
			task.defer(HandleStack, Object, Name, LifeTime, Debug)
		else
			local Plus = StackStore[Object] and StackStore[Object][Name] or 0
			if not StackStore[Object] then
				StackStore[Object] = {}
			end
			StackStore[Object][Name] = Plus + 1
		end
	end
end

local function ResetInfStack(Object : Instance)
	local Store = StackStore[Object]
	if Store then
		for Name, Value in Store do
			local Stack = Object:GetAttribute(Name)
			if Stack then
				local Minus = (Stack - Value)
				Object:SetAttribute(Name, Minus > 0 and Minus or nil)
			end
			StackStore[Object][Name] = nil
		end
	end
end

local function ResetStack(Object : Instance, Name : string)
	if Object and typeof(Name) == "string" then
		Object:SetAttribute(Name, nil)
	end
end

StackManager.AddStack = AddStack
StackManager.ResetStack = ResetStack
StackManager.ResetInfStack = ResetInfStack

return StackManager
