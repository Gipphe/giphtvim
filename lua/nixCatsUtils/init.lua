--[[
  This directory is the luaUtils template.
  You can choose what things from it that you would like to use.
  And then delete the rest.
  Everything in this directory is optional.
--]]

local M = {}

--[[
  This file is for making your config still work WITHOUT nixCats.
  When you don't use nixCats to load your config,
  you won't have the nixCats plugin.

  The setup function defined here defines a mock nixCats plugin when nixCats wasn't used to load the config.
  This will help avoid indexing errors when the nixCats plugin doesnt exist.

  NOTE: If you only ever use nixCats to load your config, you don't need this file.
--]]

---@type boolean
M.isNixCats = vim.g[ [[nixCats-special-rtp-entry-nixCats]] ] ~= nil

---@class CallableTable<T> : table<T, any>
---@field __call fun(path: string): any|nil

---Attaches a metatable with a __call that retrieves the a nested table value
---accessible using dot-notation, or with a table of strings.
---
---```
---local tbl = mk_with_meta { foo = 'bar', baz = {quack = 'quux'}}
---print(tbl('foo'))
--- --> 'bar'
---print(tbl('baz.quack'))
--- --> 'quux'
---print(tbl({'baz', 'quack'}))
--- --> 'quux'
---```
---@generic T
---@param tbl table<T, any>
---@return CallableTable<T>
local mk_with_meta = function(tbl)
  return setmetatable(tbl, {
    __call = function(_, attrpath)
      local strtable = {}
      if type(attrpath) == 'table' then
        strtable = attrpath
      elseif type(attrpath) == 'string' then
        for key in attrpath:gmatch '([^%.]+)' do
          table.insert(strtable, key)
        end
      else
        print 'function requires a table of strings or a dot separated string'
        return
      end
      return vim.tbl_get(tbl, unpack(strtable))
    end,
  })
end

---@class nixCatsSetupOpts
---@field non_nix_value boolean|nil
---@field local_cat_file_path string|nil File path to local categories file. Defaults to `~/.config/nvim/nix_cats_local_categories.json`.

---This function will setup a mock nixCats plugin when not using nix
---It will help prevent you from running into indexing errors without a nixCats plugin from nix.
---If you loaded the config via nix, it does nothing
---non_nix_value defaults to true if not provided or is not a boolean.
---@param v nixCatsSetupOpts
function M.setup(v)
  if not M.isNixCats then
    local nixCats_default_value

    local cat_file_path = v.local_cat_file_path
    if type(cat_file_path) ~= 'string' or cat_file_path == '' then
      local config_path = vim.fn.stdpath 'config'
      cat_file_path = config_path .. '/nix_cats_local_categories.json'
    end
    local local_cats = M.getLocalCats(cat_file_path)

    if type(local_cats) == 'table' and type(local_cats.categories) == 'table' then
      local_cats.categories = mk_with_meta(M.local_cats.categories)
    end

    if type(local_cats) == 'table' and type(local_cats.default_value) == 'boolean' then
      nixCats_default_value = local_cats.default_value
    elseif type(v) == 'table' and type(v.non_nix_value) == 'boolean' then
      nixCats_default_value = v.non_nix_value
    else
      nixCats_default_value = true
    end
    package.preload['nixCats'] = function()
      local ncsub = {
        ---@param cat string|string[]
        get = function(cat)
          if type(local_cats) ~= 'table' or type(local_cats.categories) ~= 'table' then
            return nixCats_default_value
          end

          local cat_val = local_cats.categories(cat)
          if cat_val == nil then
            return nixCats_default_value
          else
            return cat_val
          end
        end,
        cats = mk_with_meta {
          nixCats_config_location = vim.fn.stdpath 'config',
          wrapRc = false,
        },
        settings = mk_with_meta {
          nixCats_config_location = vim.fn.stdpath 'config',
          configDirName = os.getenv 'NVIM_APPNAME' or 'nvim',
          wrapRc = false,
        },
        petShop = mk_with_meta {},
        extra = mk_with_meta {},
        pawsible = mk_with_meta {
          allPlugins = {
            start = {},
            opt = {},
          },
        },
        configDir = vim.fn.stdpath 'config',
        packageBinPath = os.getenv 'NVIM_WRAPPER_PATH_NIX' or vim.v.progpath,
      }
      return setmetatable(ncsub, {
        __call = function(_, cat)
          return ncsub.get(cat)
        end,
      })
    end
    _G.nixCats = require 'nixCats'
  end
end

---@class LocalCats<T>
---@field categories table<T, boolean> Configured categories.
---@field default_value boolean|nil Default value for undefined categories.

---@param cat_file_path string
---@return LocalCats|nil
function M.getLocalCats(cat_file_path)
  local exists = vim.uv.fs_stat(cat_file_path) ~= nil
  if not exists then
    return nil
  end

  local local_cats = vim.fn.json_decode(vim.fn.readfile(cat_file_path))
  if type(local_cats) ~= 'table' then
    vim.notify 'Local cats is not a JSON object'
    return nil
  end

  local valid_cats = type(local_cats.categories) == 'table'
  local valid_default_value = local_cats.default_value == nil or type(local_cats.default_value) == 'boolean'
  if not valid_cats or not valid_default_value then
    vim.notify 'Local cats is not a valid LocalCats object'
    return nil
  end

  return local_cats
end

---allows you to guarantee a boolean is returned, and also declare a different
---default value than specified in setup when not using nix to load the config
---@overload fun(v: string|string[]): boolean
---@overload fun(v: string|string[], default: boolean): boolean
function M.enableForCategory(v, default)
  if M.isNixCats or default == nil then
    if nixCats(v) then
      return true
    else
      return false
    end
  else
    return default
  end
end

---Short name for `enableForCategory`
---@overload fun(v: string|string[]): boolean
---@overload fun(v: string|string[], default: boolean): boolean
function M.cat(v, default)
  return M.enableForCategory(v, default)
end

---if nix, return value of nixCats(v) else return default
---Exists to specify a different non_nix_value than the one in setup()
---@param v string|string[]
---@param default any
---@return any
function M.getCatOrDefault(v, default)
  if M.isNixCats then
    return nixCats(v)
  else
    return default
  end
end

---for conditionally disabling build steps on nix, as they are done via nix
---I should probably have named it dontAddIfCats or something.
---@overload fun(v: any): any|nil
---Will return the second value if nix, otherwise the first
---@overload fun(v: any, o: any): any
function M.lazyAdd(v, o)
  if M.isNixCats then
    return o
  else
    return v
  end
end

---for picking values depending on whether Nix is involved in the configuration and build of this neovim config.
---@generic T
---@param whenNixCats T
---@param notNixCats T
---@return T
---@overload fun(whenNixCats: any): any|nil
function M.whenNixCatsElse(whenNixCats, notNixCats)
  if M.isNixCats then
    return whenNixCats
  end
  return notNixCats
end

---for picking values depending on whether Nix is involved in the configuration and build of this neovim config.
---Flipped version of [`whenNixCatsElse`](lua://M.whenNixCatsElse)
---@generic T
---@param notNixCats T
---@param whenNixCats T
---@return T
---@overload fun(notNixCats: any): any|nil
function M.whenNotNixCatsElse(notNixCats, whenNixCats)
  return M.whenNixCatsElse(whenNixCats, notNixCats)
end

return M
