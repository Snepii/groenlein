local Util = {
   _stack = {},
   _nstack = {}
}

function Util.file_exists(name)
   if name == nil then return false end
   
   local f=io.open(name,"r")
   if f~=nil then io.close(f) return true else return false end
end

---handles the opening, output, closing of files
---@param name string "has to include the path"
---@param content any
---@param mode string "default \"w\""
function Util.writeFile(name, content, mode)
   local file = io.open(name,mode or "w")
   io.output(file)
   io.write(content)
   io.close()
   io.output()
end

---handles the opening, input, closing of files
---@param name string "has to include the path"
---@param mode string "default \"r\""
---@return string
function Util.readFile(name, mode)
   local file = io.open(name, mode or "r")
   io.input(file)
   local string = io.read()
   io.close(file)
   io.input()
   return string
end


--- replacement for (a==nil)?b:a
---@param if_nil any
---@param else_value any
---@return any
function Util.ifelsenil(if_nil, else_value)
   if if_nil == nil then return else_value else return if_nil end
end

---replacement for (a)?b:c
---@param if_value any
---@param then_return any
---@param else_return any
---@return any
function Util.ifelse(if_value, then_return, else_return)
   if if_value then
      return then_return
   else
      return else_return
   end
end


--- pushes the element <item> onto stack "<property>"
--- returns the updated amount of elements on stack
---@param property string
---@param item any
---@return number
function Util.push(property, item, ...)

   if Util._stack[property] == nil then
      --print("not on stack, creating")
      Util._stack[property] = {}
      Util._nstack[property] = 0
   end

   local args = {...}
   if args ~= nil then
      local i = {}
      local j = 1
      i[j] = item
      for _,v in pairs(args) do
         i[j+1] = v
         j = j+1
      end
      item = i
   end

   table.insert(Util._stack[property], item)
   Util._nstack[property] = Util._nstack[property] + 1

   --Util.printStack(property)

   return Util._nstack[property]
end


--- returns the last element of stack "<property>" and kicks it out
---@param property string
---@return any
function Util.pop(property)
   local count = Util._nstack[property]
   if count == nil or count == 0 then
      print("nilled")
      return nil
   end 

   local e = table.remove(Util._stack[property], count)
   Util._nstack[property] = count - 1
   if count == 1 then
      local idx = 1
      for k,_ in pairs(Util._stack) do
         if k == property then
            break
         else
            idx = idx + 1
         end
      end
      

      --print("removing " .. property .. " from stack bc empty")
      table.remove(Util._stack, idx)
      --print("removing " .. property .. " from nstack bc empty")
      table.remove(Util._nstack, idx)
   end

   return e
end

function Util.printStack(property)
   if Util._stack[property] == nil then
      print("stack[" .. property .. "] doesn't exist")
   elseif Util._nstack[property] == 0 then
      print("stack[" .. property .. "] is empty")
   else
      print("elements in " .. property .. "(" .. #Util._stack[property] .. "): ")
      --for i,v in ipairs(Util.stack[property]) do
        -- print(i..": " .. v)
      --end
      Util.printTable(Util._stack[property])
   end
end

function Util.tableToString(tbl)

   local s = "{"
   if type(tbl) ~= "table" then
      return tbl
   else
      for k,v in pairs(tbl) do
         s = s ..  k .. ":" .. Util.tableToString(v) .. ","
      end

      if string.match(s, ',' .. "$") ~= nil then
         s = string.sub(s, 1, #s-1) .. "}"
      end
   end


   local gsub = string.gsub(s, "},", "},\n ") 

   return gsub
end

function Util.printTable(tbl)
   print(Util.tableToString(tbl))
end

---shortcut for push("color", love.graphics.getColor())
---@return number
function PushColor()
   return Util.push("color", love.graphics.getColor())
end

---shortcut for pop("color")
---@return any
function PopColor()
   love.graphics.setColor(Util.pop("color"))
end


return Util