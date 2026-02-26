-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

local map = vim.keymap.set
local util = require 'util'
local keys = require 'keygroups'

-- Set highlight on search, but clear on pressing <Esc> in normal mode
vim.opt.hlsearch = true
map('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
map('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })
map('t', '<C-h>', '<cmd>wincmd h<cr>', { desc = 'Go to left window' })
map('t', '<C-j>', '<cmd>wincmd j<cr>', { desc = 'Go to lower window' })
map('t', '<C-k>', '<cmd>wincmd k<cr>', { desc = 'Go to upper window' })
map('t', '<C-l>', '<cmd>wincmd l<cr>', { desc = 'Go to right window' })
map('t', '<C-/>', '<cmd>close<cr>', { desc = 'Hide terminal' })
map('t', '<c-_>', '<cmd>close<cr>', { desc = 'which_key_ignore' })

-- Windows
map('n', keys.key.window 'w', '<C-W>p', {
  desc = 'Other Window',
  remap = true,
})
map('n', keys.key.window 'd', '<C-W>c', {
  desc = 'Delete Window',
  remap = true,
})
map('n', keys.key.window '-', '<C-W>s', {
  desc = 'Split Window Below',
  remap = true,
})
map('n', keys.key.window '|', '<C-W>v', {
  desc = 'Split Window Right',
  remap = true,
})
map('n', '<leader>-', '<C-W>s', {
  desc = 'Split Window Below',
  remap = true,
})
map('n', '<leader>|', '<C-W>v', {
  desc = 'Split Window Right',
  remap = true,
})

-- Tabs
map('n', keys.key.tab 'l', '<cmd>tablast<cr>', { desc = 'Last tab' })
map('n', keys.key.tab 'f', '<cmd>tabfirst<cr>', { desc = 'First tab' })
map('n', keys.key.tab '<tab>', '<cmd>tabnew<cr>', { desc = 'New tab' })
map('n', keys.key.tab ']', '<cmd>tabnext<cr>', { desc = 'Next tab' })
map('n', keys.key.tab 'd', '<cmd>tabclose<cr>', { desc = 'Close tab' })
map('n', keys.key.tab '[', '<cmd>tabprevious<cr>', { desc = 'Previous tab' })

-- TIP: Disable arrow keys in normal mode
-- map('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
-- map('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
-- map('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
-- map('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
map('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
map('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
map('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
map('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- Make j and k move through wrapped lines
map({ 'n', 'x' }, 'j', "v:count == 0 ? 'gj' : 'j'", { silent = true, expr = true })
map({ 'n', 'x' }, 'k', "v:count == 0 ? 'gk' : 'k'", { silent = true, expr = true })
map({ 'n', 'x' }, '<Down>', "v:count == 0 ? 'gj' : 'j'", { silent = true, expr = true })
map({ 'n', 'x' }, '<Up>', "v:count == 0 ? 'gk' : 'k'", { silent = true, expr = true })

-- Resize window using <ctrl> arrow keys
map('n', '<C-Up>', '<cmd>resize +2<cr>', { desc = 'Increase window height' })
map('n', '<C-Down>', '<cmd>resize -2<cr>', { desc = 'Decrease window height' })
map('n', '<C-Left>', '<cmd>vertical resize -2<cr>', { desc = 'Decrease window width' })
map('n', '<C-Right>', '<cmd>vertical resize +2<cr>', { desc = 'Increase window width' })

-- Move lines
map('n', '<A-j>', '<cmd>m .+1<cr>==', { desc = 'Move down' })
map('n', '<A-k>', '<cmd>m .-2<cr>==', { desc = 'Move up' })
map('i', '<A-j>', '<esc><cmd>m .+1<cr>==gi', { desc = 'Move down' })
map('i', '<A-k>', '<esc><cmd>m .-2<cr>==gi', { desc = 'Move up' })
map('v', '<A-j>', ":m '>+1<cr>gv=gv", { desc = 'Move down' })
map('v', '<A-k>', ":m '<-2<cr>gv=gv", { desc = 'Move up' })

-- Buffers
map('n', '<S-h>', function()
  util.close_floating_windows()
  vim.cmd.bprevious()
end, { desc = 'Prev buffer' })
map('n', '<S-l>', function()
  util.close_floating_windows()
  vim.cmd.bnext()
end, { desc = 'Next buffer' })
map('n', '[b', function()
  util.close_floating_windows()
  vim.cmd.bprevious()
end, { desc = 'Prev buffer' })
map('n', ']b', function()
  util.close_floating_windows()
  vim.cmd.bnext()
end, { desc = 'Next buffer' })
map('n', keys.key.buffer 'b', '<cmd>e #<cr>', { desc = 'Switch to other buffer' })

-- Clear search, diff update and redraw
-- taken from runtime/lua/_editor.lua (from LazyVim?)
map('n', keys.key.ui 'r', '<cmd>nohlsearch<Bar>diffupdate<Bar>normal! <C-L><cr>', {
  desc = 'Redraw / clear hlsearch / diff update',
})

-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
map('n', 'n', "'Nn'[v:searchforward].'zv'", {
  expr = true,
  desc = 'Next Search Result',
})
map({ 'x', 'o' }, 'n', "'Nn'[v:searchforward]", {
  expr = true,
  desc = 'Next Search Result',
})
map('n', 'N', "'nN'[v:searchforward].'zv'", {
  expr = true,
  desc = 'Prev Search Result',
})
map({ 'x', 'o' }, 'N', "'nN'[v:searchforward]", {
  expr = true,
  desc = 'Prev Search Result',
})

-- Add undo breakpoints
map('i', ',', ',<c-g>u', {})
map('i', '.', '.<c-g>u', {})
map('i', ';', ';<c-g>u', {})

-- keywordprg
map('n', '<leader>K', '<cmd>norm! K<cr>', { desc = 'Keywordprg' })

-- Keep indented text selected with when indenting in visual mode
map('v', '<', '<gv')
map('v', '>', '>gv')

-- New file
map('n', keys.key.file 'n', '<cmd>new<cr>', { desc = 'New file' })

-- Troubleshooting
map('n', '<leader>xl', '<cmd>lopen<cr>', { desc = 'Location list' })
map('n', '<leader>xq', '<cmd>copen<cr>', { desc = 'Quickfix list' })
map('n', '[q', vim.cmd.cprev, { desc = 'Previous Quickfix' })
map('n', ']q', vim.cmd.cnext, { desc = 'Next Quickfix' })

local diag_jumps = function()
  local dj = vim.diagnostic.jump
  local sev = vim.diagnostic.severity
  map('n', '<leader>cd', vim.diagnostic.open_float, { desc = 'Line diagnostics' })
  map('n', ']d', function()
    dj { count = 1, float = true }
  end, { desc = 'Next diagnostic' })
  map('n', '[d', function()
    dj { count = -1, float = true }
  end, { desc = 'Prev diagnostic' })
  map('n', ']e', function()
    dj { count = 1, float = true, severity = sev.ERROR }
  end, { desc = 'Next error' })
  map('n', '[e', function()
    dj { count = -1, float = true, severity = sev.ERROR }
  end, { desc = 'Prev error' })
  map('n', ']w', function()
    dj { count = 1, float = true, severity = sev.WARN }
  end, { desc = 'Next warning' })
  map('n', '[w', function()
    dj { count = -1, float = true, severity = sev.WARN }
  end, { desc = 'Prev warning' })
end
diag_jumps()

map('n', '<leader>qq', '<cmd>qa<cr>', { desc = 'Quit all' })
map('n', '<leader>ui', vim.show_pos, { desc = 'Inspect pos' })

map('n', 'g/', '*')
map('n', '[/', '[<C-i>')
map('n', '<C-w>/', function()
  local word = vim.fn.expand '<cword>'
  if word ~= '' then
    vim.cmd('split | silent! ijump /' .. word .. '/')
  end
end)
map('x', '/', '<esc>/\\%V') -- `:h /\%V`
