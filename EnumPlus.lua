export type EnumContainerMethods = {
	-- Container methods
	FromName: (self: EnumContainerMethods, name: string) -> EnumType,
	FromValue: (self: EnumContainerMethods, value: number) -> EnumType,
	GetEnumItems: (self: EnumContainerMethods) -> {EnumType}
}
export type EnumContainer = { [string]: {any} } & EnumContainerMethods
export type EnumType = { [string]: EnumContainer }
export type CustomEnumItem = {
	Name: string,
	Value: number,
	EnumType: EnumType,
	IsA: (self: CustomEnumItem, className: string) -> boolean
}

-- We use a :: CustomEnumItem casting due to Roblox typechecking not being
-- able to deal with us doing this. It works fine at runtime, but makes it
-- harder to implement new CustomEnums. Make sure all CustomEnumItem values
-- are a number that is casted with :: to CustomEnumItem.
local CustomEnums = {
	ExampleEnum = {
		EnumValue0 = (0 :: CustomEnumItem),
		EnumValue1 = (1 :: CustomEnumItem),
		EnumValue2 = (2 :: CustomEnumItem),
	},
}

-- Utility for converting a table to an array
local function toArray(tbl)
	local result = {}
	for key, value in pairs(tbl) do
		table.insert(result, value)
	end
	return result
end

local function CheckEnumEquality(a: EnumItem, b: EnumItem): boolean
	return a.EnumType == b.EnumType
end

-- Set up the enum objects so they get turned into meta objects
local function SetupEnumObjects(): ()
	for containerName, customEnumItemContainer in pairs(CustomEnums) do
		local enumContainerMethods = {
			-- Gets the enum item from the container with the index of <em>name</em>
			FromName = function(self, name)
				return customEnumItemContainer[name]
			end;
			-- Gets the enum item from the container with the index of <em>value</em>
			FromValue = function(self, value)
				for name2, enumItem in pairs(customEnumItemContainer) do
					if enumItem.Value == value then
						return enumItem
					end
				end
				return nil
			end;

			-- Gets all the items in the container as an array
			GetEnumItems = function(self)
				return toArray(customEnumItemContainer)
			end,
		}

		-- Use the methods table as the __index of the metatable so the methods are not
		-- stored on the container itself (they won't appear in pairs()).
		local mt = {
			__index = enumContainerMethods,
			__newindex = function() end,
			__metatable = "EnumContainerLocked"
		}

		customEnumItemContainer = setmetatable(customEnumItemContainer, mt)
		
		for name, value in pairs(customEnumItemContainer) do
			if type(name) == "string" and type(value) ~= "table" then
				local newEnumObject = { EnumType = containerName }

				function newEnumObject:IsA(n: string)
					if containerName == n then
						return true
					elseif n == "EnumItem" or n == "Enum" then
						return true
					end
					return false
				end

				local metaData = {
					__index = function(tbl, idx)
						if idx == "Name" then
							return name
						elseif idx == "Value" then
							return value
						elseif idx == "EnumType" then
							return containerName
						end
					end;

					__newindex = function() end;

					__tostring = function()
						return string.format("Enum.%s.%s", containerName, name)
					end;

					__eq = CheckEnumEquality
				}
				setmetatable(newEnumObject, metaData)
				-- Replace the numeric placeholder with the EnumItem-like object
				customEnumItemContainer[name] = newEnumObject :: EnumItem
			end
		end
	end
end

type EnumProxy = {
	[string]: EnumItem?
}

local EnumProxies = {} -- { [string]: EnumProxy }

function GetProxyForEnum(index: string): EnumProxy
	if not EnumProxies[index] then
		EnumProxies[index] = setmetatable({
			_name = index
		},
		{
			__index = function(tbl, index2)
				if CustomEnums[tbl._name][index2] == nil then
					error(index2.." is not a valid member of Enum")
				end
				return CustomEnums[tbl._name][index2]
			end,

			__newindex = function(tbl, index2, value)
				-- Cannot add new indexes at runtime!
				return nil
			end,

			__tostring = function()
				return index
			end,
		}) :: EnumProxy
	end
	return EnumProxies[index]
end

local EnumsProxyTable = setmetatable({
	--- Public methods ---

	-- Gets all registered enums as a an array
	GetEnums = function(self: any)
		return CustomEnums
	end,
	-- Gets all items of a specific <em>enumName</em>
	GetEnumItems = function(self: any, enumName: string)
		return CustomEnums[enumName]
	end,
	-- Query if value <em>(any)</em> is a EnumItem
	IsEnumItem = function(self: any, value: any)
		return type(value) == "table" and type(rawget(value, "EnumType")) == "string"
	end,
}, {
	-- Indexing
	__index = function(tbl, index)
		-- Query if the Custom enum is found or RobloxEnums is found
		if CustomEnums[index] ~= nil then
			return GetProxyForEnum(index)
		end
	end,

	__newindex = function(tbl, index, value)
		-- You cannot add indexes at runtime!
		return nil
	end,
	__tostring = function()
		return "Enums"
	end,
})

-- Setup enum objects on require()
SetupEnumObjects()

-- A helpful exported type for known enums so editors show autocompletion.
export type EnumsModule = typeof(EnumsProxyTable) & typeof(CustomEnums) & {[string]: EnumContainerMethods}

return EnumsProxyTable :: EnumsModule
