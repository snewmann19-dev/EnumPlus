# EnumPlus
Roblox Enums, or Enumerations, are primitive values that represent a number value and are useful for multiple purposes. As Roblox doesn't include custom Enums, this package is designed to open up new capabilities to developers for mimicking how Roblox implements its Enums.
This package emulates Enum.EnumType.EnumItem also implements custom immutability and metamethods. 

You might be questioning, **what really makes EnumPlus different from other custom Enum modules?** Well, EnumPlus aims to match—to the best of its efforts—how Enums are demonstrated throughout Roblox core Enums. EnumPlus does this through offering metamethods and using advanced metatable magic to mimic the design that Roblox has given developers. Multiple methods are also available, which also exactly emulate how Roblox’s Enum methods work. 

A massive downside for EnumPlus is typechecking. This module uses typeof() to typecheck the user-defined custom Enum types, which is not the best possible way to go about doing so. LUAU typechecking is not advanced enough to handle custom Enumerations, with defining a single integer value and then later turning it into .Value, .Name, and .EnumType. As this was the bad part of EnumPlus, I used (‘integer’ :: CustomEnumItem) to allow the typechecker to still show the CustomEnumItem type
