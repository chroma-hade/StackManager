local StackManager = {}

local StackClass = {}
StackClass.__index = StackClass

local StackStore: { [Instance]: { [string]: number } } = {}
local ClassStore: { [Instance]: { StackObject } } = {}
local ConnectionStore: { [Instance]: RBXScriptConnection } = {}

type StackObject = {
	Object: Instance,
	Name: string,
	Destroy: (StackObject) -> ()
}

function StackClass.new(Object: Instance, Name: string, Value: number?)
	local Class = setmetatable({}, StackClass)
	Class.Object = Object
	Class.Name = Name

	if not StackStore[Object] then
		StackStore[Object] = {}
	end

	local Store = StackStore[Object]
	local CurrentStack = Store[Name] or 0
	Store[Name] = CurrentStack + 1
	Object:SetAttribute(Name, Value or true)

	return Class
end

function StackClass:Destroy()
	if not StackStore[self.Object] then
		return
	end

	local Store = StackStore[self.Object]
	local CurrentStack = Store[self.Name] or 0
	Store[self.Name] = CurrentStack - 1
	if Store[self.Name] < 1 then
		self.Object:SetAttribute(self.Name, nil)
		Store[self.Name] = nil
	end

	local Classes = ClassStore[self.Object]
	if Classes then
		local Index = table.find(Classes, self)
		if Index then
			table.remove(Classes, Index)
		end
	end

	table.clear(self)
end

local function ClearObject(Object: Instance)
	local Classes = ClassStore[Object]
	for Index = #Classes, 1, -1 do
		Classes[Index]:Destroy()
	end

	ConnectionStore[Object]:Disconnect()

	ClassStore[Object] = nil
	StackStore[Object] = nil
	ConnectionStore[Object] = nil
end

function StackManager.AddStack(Object: Instance, Name: string, LifeTime: number?, Value: number?)
	if not ClassStore[Object] then
		ClassStore[Object] = {}
		ConnectionStore[Object] = Object.AncestryChanged:Connect(function()
			if Object.Parent ~= nil then
				return
			end
			ClearObject(Object)
		end)
	end

	local Stack = StackClass.new(Object, Name, Value)
	table.insert(ClassStore[Object], Stack)

	if not LifeTime then
		return Stack
	end

	task.delay(LifeTime, function()
		Stack:Destroy()
	end)

	return Stack
end

function StackManager.ClearStack(Object: Instance, Name: string)
	if not ClassStore[Object] then
		return
	end
	local Store = ClassStore[Object]
	for Index = #Store, 1, -1 do
		local Class = Store[Index]
		if Class.Name ~= Name then
			continue
		end
		Class:Destroy()
	end
end

return StackManager
