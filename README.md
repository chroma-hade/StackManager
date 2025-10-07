Example down blow.

```lua
local StackManager = require("ModuleLocation")

-- Add Stack from any object.
StackManager.AddStack(Object, {
		["Name"] = "Stun", -- Name of stack name to save
		["LifeTime"] = 1, -- How many time stack will be stay
	}
)

-- Add Stack from any object.
StackManager.AddStack(Object, {
		["Name"] = "Freeze", -- Just a stack name again.
		["LifeTime"] = "inf", -- this is infinite time (you can reset it with use .ResetStack)
	}
)

-- Remove stack (inculde infinite lifetime) from object by stack name.
StackManager.ResetStack(Character, "Freeze")
```
