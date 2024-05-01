--[[
MIT License

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
]]


Dictionary = {};

--[[
<h2>New Instance:</h2>
<h3>Returns a Dictionary</h3>
<b>Creates an Instance of a Dictionary</b>
</br>
Needs to set the Key Type and Value Type
</br>
<i>Key Cannot be of type "Function" or "Table"</i>
]]
function Dictionary:New(keyType, valueType)
    assert(not keyType ~= "function" and  keyType ~= "table", "Key Cannot be a Function or Table")
    local instance = setmetatable({}, self)
    instance.KeyType = keyType
    instance.ValueType = valueType
    instance.Dictionary = {}
    setmetatable(instance, self)
    self.__index = self
    return instance
end
--[[
<h2>Insert a New Field (Key,Value) </h2>
<h3>Returns a Dictionary of Itself</h3>
<b>Inserts a new Field to the Dictionary</b>
</br>
<i>Remember to Follow the Key Type and Value Type</i>
]]
function Dictionary:Insert(key, value)
    assert(type(key) == self.KeyType, "Key must be type: " .. self.KeyType .. ", got: " .. type(key))
    assert(type(value) == self.ValueType, "Value must be type: " .. self.ValueType .. ", got: " .. type(value))
    assert(self:KeyExist(key) == false, 'Key "' .. tostring(key) .. '" already exists')
    table.insert(self.Dictionary, {key, value})
    return self
end
--[[
<h2>Remove a Field</h2>
<h3>Returns a Dictionary of Itself</h3>
<b>Remove a Field from the Dictionary from Key</b>
</br>
<i>Throws an Error if Key does not exist</i>
]]
function Dictionary:Remove(key)
    assert(self:KeyExist(key) == true,'Key "'..key..'" does not exist')
    for _i, _value in ipairs(self.Dictionary) do
        if(key == _value[1]) then
            table.remove(self.Dictionary,_i)
        end
    end
    return self
end
--[[
<h2>Get Value</h2>
<h3>Returns The Value</h3>
<b>Gets the current value of Field base on the Key</b>
</br>
<i>Throws an Error if Key does not exist</i>
]]
function Dictionary:Get(key)
    assert(self:KeyExist(key) == true,'Key "'..key..'" does not exist')
    if not self:KeyExist(key) then
        return
    end
    local value;
    for _, _value in ipairs(self.Dictionary) do
        if key == _value[1] then
            value = _value[2]
        end
    end
    return value;
end
--[[
<h2>Set</h2>
<h3>Returns a Dictionary of Itself</h3>
<b>Sets the value of a Field based on the Key</b>
</br>
<i>Throws an Error if Key does not exist</i>
]]
function Dictionary:Set(key, newValue)
    assert(self:KeyExist(key) == true,'Key "'..key..'" does not exist')
    for _, _value in ipairs(self.Dictionary) do
        if key == _value[1] then
            _value[2] = newValue
        end
    end
    return self
end
--[[
<h2>Key Exist</h2>
<h3>Returns a Boolean</h3>
<b>Checks if The provided key Exist</b>
</br>
<i>It does not throw an Error</i>
]]
function Dictionary:KeyExist(key)
    local keyExist = false
    for _, _value in ipairs(self.Dictionary) do
        if _value[1] == key then
            keyExist = true
        end
    end
    return keyExist
end
--[[
<h2>Get Keys</h2>
<h3>Returns a Table</h3>
<b>Creates a List with all the "Keys" of the Dictionary</b>
</br>
<i>It does not Throws an Error</i>
]]
function Dictionary:GetKeys()
    local keys = {}
    for _, _value in ipairs(self.Dictionary) do
        table.insert(keys,_value[1])
    end
    return keys
end
--[[
<h2>Get Values</h2>
<h3>Returns a Table</h3>
<b>Creates a List with all the "Values" of the Dictionary</b>
</br>
<i>It does not Throws an Error</i>
]]
function Dictionary:GetValues()
    local vaules = {}
    for _, _value in ipairs(self.Dictionary) do
        table.insert(vaules,_value[2])
    end
    return vaules
end
--[[
<h2>Iter</h2>
<h3>Returns Dictionary</h3>
<b>Iterates over all the (Key, Value) on the dictionary and returns a new Dictionary</b>
</br>
<i>Throws an error if callBack is not a Function</i>
]]
function Dictionary:Iter(callBack)
    assert(type(callBack)=="function", "Callback must be a Function, got: "..type(callBack))
    local dictionary = Dictionary:New(self.KeyType,self.ValueType)
    for _, _value in ipairs(self.Dictionary) do
        local v1,v2 = callBack(_value[1],_value[2])
        v2 = v2 or _value[2]
        if v1 or v2 then
            dictionary:Insert(v1,v2)
        else 
            dictionary:Insert(_value[1],_value[2])
        end
    end
    return dictionary
end
--[[
<h2>Filter</h2>
<h3>Returns Dictionary</h3>
<b>Iterates over all the (Key, Value) And returns teh dictionary filtered based on condition</b>
</br>
<i>Throws an error if callBack is not a Function</i>
]]
function Dictionary:Filter(callBack)
    assert(type(callBack) == "function", "Callback must be a function")
    local filtered = Dictionary:New(self.KeyType, self.ValueType)
    if #self.Dictionary == 0 then
        return filtered
    end
    for _, _value in ipairs(self.Dictionary) do
        local key, value = _value[1], _value[2]
        if callBack(key, value) then
            filtered:Insert(key, value)
        end
    end    
    return filtered
end
--[[
<h2>Sort By Key</h2>
<h3>Returns Dictionary</h3>
<b>Sorts the Dictionary filtered based on the Key</b>
]]
function Dictionary:SortByKey()
    table.sort(self.Dictionary, function(a, b)
        return a[1] < b[1]
    end)
    return self
end
--[[
<h2>Sort By Value</h2>
<h3>Returns Dictionary</h3>
<b>Sorts the Dictionary filtered based on the Value</b>
]]
function Dictionary:SortByValue()
    table.sort(self.Dictionary, function(a, b)
        return a[2] < b[2]
    end)
    return self
end
--[[
<h2>Copy</h2>
<h3>Returns Dictionary</h3>
<b>Returns a Vopy of the Dictionary</b>
]]
function Dictionary:Copy()
    local copy = Dictionary:New(self.KeyType, self.ValueType)
    for _, _value in ipairs(self.Dictionary) do
        copy:Insert(_value[1], _value[2])
    end
    return copy
end
--[[
<h2>Clear</h2>
<h3>Returns Dictionary</h3>
<b>Clears all the fields of the Dictionary</b>
]]
function Dictionary:Clear()
    self.Dictionary = {}
    return self
end
--[[
<h2>Merge</h2>
<h3>Returns Dictionary</h3>
<b>Merges Dictionary with another Dictionary</b>
<i>Throws an error if parameter is not Dictionary</i>
<i>Throws an error if Dictionary is not the same Format</i>
]]
function Dictionary:Merge(otherDictionary)
    assert(Dictionary.IsDictionary(otherDictionary),"Argument must be an instance of Dictionary")
    assert(otherDictionary:GetFormat() == self:GetFormat(), "Dictionary must be: "..self:GetFormat())
    for _, _value in ipairs(otherDictionary.Dictionary) do
        self:Insert(_value[1], _value[2])
    end
    return self
end
--[[
<h2>Is Dictionary</h2>
<h3>Returns Boolean</h3>
<b>Checks if is Dictionary</b>
]]
function Dictionary.IsDictionary(dic)
   return(getmetatable(dic) == Dictionary) 
end
--[[
<h2>Validate Key</h2>
<h3>Returns a validation key Function</h3>
<b>Validates a key base on a callBack</b>
<i>Throws an error if parameter is not a function</i>
]]
function Dictionary:ValidateKey(key, validationFunction)
    assert(type(validationFunction) == "function", "Validation function must be a function")
    assert(type(key) ~= "nil", "Key cannot be nil")
    assert(type(key) ~= "function" and type(key) ~= "table", "Key cannot be a function or table")
    return validationFunction(key)
end
--[[
<h2></h2>
<h3>Returns Boolean</h3>
<b>Checks if is Dictionary</b>
]]
function Dictionary:ToTable()
    local tableDic = {}
    for _, _value in ipairs(self.Dictionary) do
        tableDic[_value[1]] = _value[2]
    end
    return tableDic
end
--[[
<h2>Serialize</h2>
<h3>Returns a Table</h3>
<b>Returns a Table with the Dictionary data</b>
]]
function Dictionary:Serialize()
    local serialized = {
        format = {KeyType = self.KeyType, ValueType = self.ValueType},
        data = {}
    }
    for _, _value in ipairs(self.Dictionary) do
        table.insert(serialized.data, {_value[1], _value[2]})
    end
    return serialized
end
--[[
<h2>Deserialize</h2>
<h3>Returns a Dictionary</h3>
<b>Returns a Dictionary Deserialized table data</b>
]]
function Dictionary:Deserialize(serialized)
    local dict = Dictionary:New(serialized.format.KeyType, serialized.format.ValueType)
    for _, entry in ipairs(serialized.data) do
        dict:Insert(entry[1], entry[2])
    end
    return dict
end
--[[
<h2>Get Format</h2>
<h3>Returns a String</h3>
<b>Returns the Format ValueType and KeyType as a String</b>
]]
function Dictionary:GetFormat()
    return '(KeyType: '..tostring(self.KeyType)..', ValueType: '..tostring(self.ValueType)..')'
end

--[[
<h2>Is Empty</h2>
<h3>Returns a Boolean</h3>
<b>Returns true if table is Empty</b>
]]
function Dictionary:IsEmpty()
    return #self.Dictionary == 0
end

function Dictionary:__tostring()
    local function tableToString(tbl, indent)
        local str = ""
        for k, v in pairs(tbl) do
            str = str .. ("\n" .. string.rep(" ", indent + 4) .. tostring(k) .. " : ")
            if type(v) == "table" then
                str = str .. "{"
                str = str .. tableToString(v, indent + 4)
                str = str .. ("\n" .. string.rep(" ", indent + 4) .. "}")
            else
                str = str .. tostring(v)
            end
            str = str .. ","
        end
        return str
    end
    
    local str = "{"
    for i, pair in ipairs(self.Dictionary) do
        local key = pair[1]
        local value = pair[2]
        
        str = str .. "\n    " .. tostring(key) .. " : "
        if type(value) == "table" then
            str = str .. "{"
            str = str .. tableToString(value, 4)
            str = str .. "\n    }"
        else
            str = str .. tostring(value)
        end
        if i < #self.Dictionary then
            str = str .. ","
        end
    end
    str = str .. "\n}"
    return str
end

