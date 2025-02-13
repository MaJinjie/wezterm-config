local wezterm = require('wezterm')
local utils = require('utils')

local PLATFORM = wezterm.target_triple ---@type string

---@param behavior 'error'|'keep'|'force' Decides what to do if a key is found in more than one map:
---@param raw_options table
---@param new_options table
local function merge_config(behavior, raw_options, new_options)
   local platform_options = {} ---@type {name:string, options:table}

   for k, v in pairs(new_options) do
      if k:find(':', 1, true) then
         local label, value = k:match('^(.*):(.*)$') ---@type string
         if label == 'platform' then
            if PLATFORM:match(value) then
               table.insert(platform_options, { name = value, options = v })
            end
         end
         new_options[k] = nil
      end
   end

   -- merge common options
   utils.tbl_deep_extend(behavior, raw_options, new_options)

   -- merge platform options
   if #platform_options > 0 then
      table.sort(platform_options, function(a, b)
         return #a.name < #b.name
      end)
      for _, v in ipairs(platform_options) do
         utils.tbl_deep_extend(behavior, raw_options, v.options)
      end
   end
end

---@class Config
---@field options table
local Config = {}
Config.__index = Config

---Initialize Config
---@param init_options? table
---@return Config
function Config:init(init_options)
   return setmetatable({ options = init_options or {} }, self)
end

---Get Config
---@return Config
function Config:finish()
   return self.options
end

---Append to `Config.options`
---@param new_options string|table? new options to append
---@return Config
function Config:append(new_options)
   if type(new_options) == 'string' then
      new_options = require('config.' .. new_options)
   end
   ---@cast new_options table?
   if new_options then
      merge_config('force', self.options, new_options)
   end
   return self
end

return Config
