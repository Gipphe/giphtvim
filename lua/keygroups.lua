local M = {}

M.groups = {
  goto = {
    prefix = 'g',
    group = '+goto',
    mode = { 'n', 'v' },
  },
  surround = {
    prefix = 'gs',
    group = '+surround',
    mode = { 'n', 'v' },
  },
  fold = {
    prefix = 'z',
    group = '+surround',
    mode = { 'n', 'v' },
  },
  next = {
    prefix = ']',
    group = '+next',
    mode = { 'n', 'v' },
  },
  prev = {
    prefix = '[',
    group = '+prev',
    mode = { 'n', 'v' },
  },
  tab = {
    prefix = '<leader><tab>',
    group = '+tabs',
    mode = { 'n', 'v' },
  },
  buffer = {
    prefix = '<leader>b',
    group = '+buffers',
    mode = { 'n', 'v' },
  },
  git = {
    prefix = '<leader>g',
    group = '+git',
    mode = { 'n', 'v' },
  },
  search = {
    prefix = '<leader>s',
    group = '+search',
    mode = { 'n', 'v' },
  },
  code = {
    prefix = '<leader>c',
    group = '+code',
    mode = { 'n', 'v' },
  },
  ui = {
    prefix = '<leader>u',
    group = '+ui',
    mode = { 'n', 'v' },
  },
  find = {
    prefix = '<leader>f',
    group = '+find/files',
    mode = { 'n', 'v' },
  },
  inspect = {
    prefix = '<leader>i',
    group = '+inspect',
    mode = { 'n', 'v' },
  },
  diagnostic = {
    prefix = '<leader>x',
    group = '+diagnostics/quickfix',
    mode = { 'n', 'v' },
  },
  help = {
    prefix = '<leader>h',
    group = '+help',
    mode = { 'n', 'v' },
  },
  navigation = {
    prefix = '<leader>n',
    group = '+navigation',
    mode = { 'n', 'v' },
  },
  quit = {
    prefix = '<leader>q',
    group = '+quit/session',
    mode = { 'n', 'v' },
  },
  window = {
    prefix = '<leader>w',
    group = '+window',
    mode = { 'n', 'v' },
  },
}

local aliases = {
  session = 'quit',
  file = 'find',
}

M.groups_with_aliases = vim.tbl_extend('force', {}, M.groups)

for a, n in pairs(aliases) do
  M.groups_with_aliases[a] = M.groups_with_aliases[n]
end

---@type table<string, string>
M.prefixes = {}
for k, g in pairs(M.groups_with_aliases) do
  M.prefixes[k] = g.prefix
end

---@type wk.Spec
M.which_key = {}
for _, g in pairs(M.groups) do
  M.which_key[#M.which_key + 1] = g
end

---@type table<string, fun(s: string): string>
M.key = {}
for k, g in pairs(M.groups_with_aliases) do
  M.key[k] = function(s)
    return g.prefix .. s
  end
end

return M
