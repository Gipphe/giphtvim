local spec_util = require 'loader.spec'
local M = {}

function M.gh(src)
  return 'https://github.com/' .. src
end

function M.glab(src)
  return 'https://gitlab.com/' .. src
end

function M.cb(src)
  return 'https://codeberg.org/' .. src
end

local specs = {}

function M.add(spec)
  local old_spec = specs[spec.src] or {}
  specs[spec.src] = spec_util.merge('force', old_spec, spec)
end

return M
