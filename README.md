# EnumPlus – Advanced Custom Enums for Roblox

**EnumPlus** is a Lua module that brings **custom enumeration functionality** to Roblox, mimicking the behavior and structure of Roblox’s native `Enum` system.

Roblox’s core Enums are primitive number values, but Roblox does not support custom Enums natively. EnumPlus fills this gap by allowing developers to create fully-featured, type-aware, immutable custom Enums that behave like Roblox’s built-in Enums.

---

## Core Features

- **Roblox-Like Behavior**  
  EnumPlus emulates the `Enum.EnumType.EnumItem` pattern, including `.Name`, `.Value`, and `.EnumType`.

- **Metamethod Magic**  
  Each enum item supports metamethods such as `__tostring` and `__eq`, ensuring equality checks and string conversions behave like native Enums.

- **Container Methods**  
  Each enum container provides methods such as `FromName`, `FromValue`, and `GetEnumItems`, replicating Roblox’s Enum methods.

- **Immutability**  
  Once defined, Enums cannot be changed or extended at runtime, mimicking the behavior of native Roblox Enums.

- **Standalone Module**  
  No dependencies—just require the module:

  ```lua
  local EnumPlus = require(path.to.EnumPlus)

  ```
You can add new Enums inside the EnumPlus module at line 20, where the local variable CustomEnums is defined, remember that every value that is assigned has to be formatted like: <code>(‘integer’ :: CustomEnumItem)</code>, to have typechecking. 
```lua
local CustomEnums = {
	ExampleEnum = {
		EnumValue0 = (0 :: CustomEnumItem),
		EnumValue1 = (1 :: CustomEnumItem),
		EnumValue2 = (2 :: CustomEnumItem),
	},
}
```

You might be questioning, **what really makes EnumPlus different from other custom Enum modules?** Well, EnumPlus aims to match—to the best of its efforts—how Enums are demonstrated throughout Roblox core Enums. EnumPlus does this through offering metamethods and using advanced metatable magic to mimic the design that Roblox has given developers. Multiple methods are also available, which also exactly emulate how Roblox’s Enum methods work. 

A massive downside for EnumPlus is typechecking. This module uses typeof() to typecheck the user-defined custom Enum types, which is not the best possible way to go about doing so. LUAU typechecking is not advanced enough to handle custom Enumerations, with defining a single integer value and then later turning it into .Value, .Name, and .EnumType. As this was the bad part of EnumPlus, I used <code>(‘integer’ :: CustomEnumItem)</code> to allow the typechecker to still show the <code>CustomEnumItem</code> type.

I hope all developers can benefit off of my work here, feel free to leave any requests to modify/tips on what to modify.
