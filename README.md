# StackManager

Stackable attribute flags for Roblox! Put `Stun` on a character twice, and it stays stunned until both are gone. One ModuleScript, a little over 100 lines.

Here's the problem it fixes. Two moves each stun someone for a second. The first one ends, sets `Stun` back to nil, and the second stun just vanishes halfway through. StackManager counts them, so the attribute only goes away when the last one does☆

## Getting it

Grab `StackManager.rbxm` from the [releases page](https://github.com/chroma-hade/StackManager/releases) and put it anywhere you can require it from, like `ReplicatedStorage.Packages`.

If you use Wally, add it to your `wally.toml`:

```toml
[dependencies]
StackManager = "chroma-hade/stackmanager@1.0.0"
```

Or just copy `src/init.luau` into your project.

## Using it

```lua
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local StackManager = require(ReplicatedStorage.Packages.StackManager)
StackManager.AddStack(Character, "Stun", 1)
```

That sets the `Stun` attribute on `Character` to `true` for one second. It's a plain attribute, so anything can check it without requiring StackManager at all!

```lua
if Character:GetAttribute("Stun") then
    return
end
```

Set it on the server and clients see it too, since attributes replicate.

## Keeping it on

Leave out the time and the stack stays until you remove it. `AddStack` hands you the stack back for that.

```lua
local Blocking = StackManager.AddStack(Character, "Blocking")
Blocking:Destroy()
```

`ClearStack` removes every stack with that name at once. Handy when getting hit should cancel whatever someone was doing.

```lua
StackManager.ClearStack(Character, "Stun")
```

## Values

Pass a number as the fourth argument and the attribute gets that instead of `true`.

```lua
StackManager.AddStack(Character, "Slowed", 2, 8)
```

Every new stack writes its own value, so the newest one wins. The attribute still sticks around until the last stack is gone.

When an object's Parent becomes nil, destroyed or not, every stack on it goes away and its attributes are cleared. No cleanup on your side☆

## Everything

That's the whole API!

| | |
|---|---|
| `StackManager.AddStack(Object, Name, LifeTime?, Value?)` | Adds one stack and returns it |
| `StackManager.ClearStack(Object, Name)` | Removes every stack with that name |
| `Stack:Destroy()` | Removes that one stack |

## License

MIT, so go wild☆ Just keep the license file around.
