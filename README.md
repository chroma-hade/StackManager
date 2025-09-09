Example down blow.

```lua
local StackManager = require("ModuleLocation")

-- Add Stack from any object.
StackManager.AddStack(Character, {
		["Name"] = "Stun",
		["LifeTime"] = 1,
	}
)

-- Remove every stack from object by stack name.
StackManager.ResetStack(Character, "Slowed")
```
