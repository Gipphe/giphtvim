local M = {}

---@class Overwrites<T>
---@field val T
---@field __overwrites__ boolean
---@field pick fun(other: Overwrites<T>): Overwrites<T>

---@generic T
---@param x T
---@return Overwrites<T>
function M.overwrites(x)
  local o = {
    val = x,
    __overwrites__ = true,
  }

  function o:pick(other)
    return other
  end

  return o
end

local function is_overwrites(x)
  return type(x) == 'table' and type(x.__overwrites__) == 'boolean' and x.__overwrites__
end

---@class Concatenates<T>
---@field tbl T[]
---@field __concatenates__ boolean
---@field concat fun(other: Concatenates<T>): Concatenates<T>

---@param tbl any[]
---@return Concatenates<any>
function M.concatenates(tbl)
  assert(type(tbl) == 'table' and vim.islist(tbl), 'loader.concatenates() passed something other than a list-like table')

  local c = {
    tbl = tbl,
    __concatenates__ = true,
  }

  ---@param other Concatenates<any>
  ---@return Concatenates<any>
  function c:concat(other)
    local new_tbl = vim.list_extend(vim.list_extend({}, self.tbl), other)
    return M.concatenates(new_tbl)
  end

  return c
end

---@param x any
---@return boolean
local function is_concatenates(x)
  return type(x) == 'table' and type(x.__concatenates__) == 'boolean' and x.__concatenates__
end

---Merge tables using the specified behavior. Will concatenate integer-indexed
---tables (lists), unlike vim.tbl_deep_extend.
---@param behavior 'force'|'keep'|'error'
---@param ... table<any, any>
---@return table
function M.merge_(behavior, ...)
  local ret = {}

  local is_dict = function(v)
    return type(v) == 'table' and not vim.islist(v)
  end

  for i = 1, select('#', ...) do
    local tbl = select(i, ...) --[[@as table<any, any>]]
    if tbl then
      for k, v in pairs(tbl) do
        if is_concatenates(v) and is_concatenates(ret[k]) then
          ret[k] = ret[k]:concat(v)
        elseif is_overwrites(v) and is_overwrites(ret[k]) then
          ret[k] = ret[k]:pick(v)
        elseif is_dict(v) and is_dict(ret[k]) then
          ret[k] = M.merge_(behavior, ret[k], v)
        elseif behavior ~= 'force' and ret[k] ~= nil then
          if behavior == 'error' then
            error('key found in more than one map: ' .. k)
          end -- else behavior is 'keep'
        else
          ret[k] = v
        end
      end
    end
  end

  return ret
end

---@param ... table<any, any>
---@return table
function M.merge(...)
  return M.merge_('force', ...)
end

return M
