local M = {}

--- We only merge empty tables or tables that are not an array (indexed by integers)
local function can_merge(v)
   return type(v) == 'table'
end

local function tbl_extend(behavior, deep_extend, ...)
   if behavior ~= 'error' and behavior ~= 'keep' and behavior ~= 'force' then
      error('invalid "behavior": ' .. tostring(behavior))
   end

   if select('#', ...) < 2 then
      error(
         'wrong number of arguments (given '
            .. tostring(1 + select('#', ...))
            .. ', expected at least 3)'
      )
   end

   local ret = select(1, ...) --- @type table<any,any>

   for i = 2, select('#', ...) do
      local tbl = select(i, ...)
      assert(type(tbl) == 'table', 'after the second argument must a table!')
      --- @cast tbl table<any,any>
      if tbl then
         for k, v in pairs(tbl) do
            if deep_extend and can_merge(v) and can_merge(ret[k]) then
               ret[k] = tbl_extend(behavior, true, ret[k], v)
            elseif behavior ~= 'force' and ret[k] ~= nil then
               if behavior == 'error' then
                  error('key found in more than one map: ' .. k)
               end -- Else behavior is "keep".
            else
               ret[k] = v
            end
         end
      end
   end
   return ret
end

--- Merges two or more tables.
---
---@param behavior 'error'|'keep'|'force' Decides what to do if a key is found in more than one map:
---      - "error": raise an error
---      - "keep":  use value from the leftmost map
---      - "force": use value from the rightmost map
---@param ... table Two or more tables
---@return table : Merged table
function M.tbl_extend(behavior, ...)
   return tbl_extend(behavior, false, ...)
end

--- Merges recursively two or more tables.
---
---@generic T1: table
---@generic T2: table
---@param behavior 'error'|'keep'|'force' Decides what to do if a key is found in more than one map:
---      - "error": raise an error
---      - "keep":  use value from the leftmost map
---      - "force": use value from the rightmost map
---@param ... T2 Two or more tables
---@return T1|T2 (table) Merged table
function M.tbl_deep_extend(behavior, ...)
   return tbl_extend(behavior, true, ...)
end

return M
