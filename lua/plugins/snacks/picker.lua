local keys = require 'keygroups'
local groups = {}

local search = {
  group = keys.groups.search,
  {
    'B',
    function()
      require('snacks').picker.grep_buffers()
    end,
    desc = 'Search open buffers with grep',
  },
  {
    'g',
    function()
      require('snacks').picker.grep()
    end,
    desc = 'Search files with grep',
  },
  {
    'w',
    function()
      require('snacks').picker.grep_word()
    end,
    desc = 'Search for visual selection or word',
    mode = { 'n', 'x' },
  },
  {
    '/',
    function()
      require('snacks').picker.search_history()
    end,
    desc = 'Search history',
  },
  {
    'b',
    function()
      require('snacks').picker.lines()
    end,
    desc = 'Search buffer lines',
  },
}
groups[#groups + 1] = search

local code = {
  group = keys.groups.code,

  -- TODO: I don't think I even have cliphist.
  -- {
  --   'h',
  --   function()
  --     require('snacks').picker.cliphist()
  --   end,
  --   desc = 'View cliphist',
  -- },
}
groups[#groups + 1] = code

local buffers = {
  group = keys.groups.buffer,
  {
    'h',
    function()
      require('snacks').picker.buffers()
    end,
    desc = 'Pick buffers',
  },
}
groups[#groups + 1] = buffers

local ui = {
  group = keys.groups.ui,

  {
    'C',
    function()
      require('snacks').picker.colorschemes()
    end,
    desc = 'Pick colorscheme',
  },
}
groups[#groups + 1] = ui

local git = {
  group = keys.groups.git,

  {
    'pb',
    function()
      require('snacks').picker.git_branches()
    end,
    desc = 'Git branches',
  },
  {
    'pl',
    function()
      require('snacks').picker.git_log()
    end,
    desc = 'Git log',
  },
  {
    'pL',
    function()
      require('snacks').picker.git_log_line()
    end,
    desc = 'Git log line',
  },
  {
    'ps',
    function()
      require('snacks').picker.git_status()
    end,
    desc = 'Git status',
  },
  {
    'pS',
    function()
      require('snacks').picker.git_stash()
    end,
    desc = 'Git stash',
  },
  {
    'pd',
    function()
      require('snacks').picker.git_diff()
    end,
    desc = 'Git diff (hunks)',
  },
  {
    'pf',
    function()
      require('snacks').picker.git_log_file()
    end,
    desc = 'Git log file',
  },
}
groups[#groups + 1] = git

local find = {
  group = keys.groups.find,

  {
    'g',
    function()
      require('snacks').picker.git_grep()
    end,
    desc = 'Find git-tracked files',
  },
  {
    'c',
    function()
      ---@diagnostic disable-next-line: assign-type-mismatch
      require('snacks').picker.files { cwd = vim.fn.stdpath 'config' }
    end,
    desc = 'Find config file',
  },
  {
    'f',
    function()
      require('snacks').picker.files()
    end,
    desc = 'Find files',
  },
  {
    'p',
    function()
      require('snacks').picker.projects()
    end,
    desc = 'Find projects',
  },
  {
    'r',
    function()
      require('snacks').picker.recent()
    end,
    desc = 'Find recent files',
  },
}
groups[#groups + 1] = find

local inspect = {
  group = keys.groups.inspect,

  {
    'a',
    function()
      require('snacks').picker.autocmds()
    end,
    desc = 'Autocmds',
  },
  {
    '"',
    function()
      require('snacks').picker.registers()
    end,
    desc = 'Registers',
  },
  {
    'c',
    function()
      require('snacks').picker.command_history()
    end,
    desc = 'Command history',
  },
  {
    'C',
    function()
      require('snacks').picker.commands()
    end,
    desc = 'Commands',
  },
  {
    'h',
    function()
      require('snacks').picker.highlights()
    end,
    desc = 'Highlights',
  },
  {
    'i',
    function()
      require('snacks').picker.icons()
    end,
    desc = 'Icons',
  },
  {
    'j',
    function()
      require('snacks').picker.jumps()
    end,
    desc = 'Jumps',
  },
  {
    'k',
    function()
      require('snacks').picker.keymaps()
    end,
    desc = 'Keymaps',
  },
  {
    'm',
    function()
      require('snacks').picker.marks()
    end,
    desc = 'Marks',
  },
  {
    'n',
    function()
      require('snacks').picker.notifications()
    end,
    desc = 'Notifications',
  },
  {
    'p',
    function()
      require('snacks').picker.lazy()
    end,
    desc = 'Search for plugin spec',
  },
  {
    'u',
    function()
      require('snacks').picker.undo()
    end,
    desc = 'Undo history',
  },
}
groups[#groups + 1] = inspect

local diagnostic = {
  group = keys.groups.diagnostic,

  {
    'd',
    function()
      require('snacks').picker.diagnostics()
    end,
    desc = 'View diagnostics',
  },
  {
    'D',
    function()
      require('snacks').picker.diagnostics_buffer()
    end,
    desc = 'View buffer diagnostics',
  },
}
groups[#groups + 1] = diagnostic

local help = {
  group = keys.groups.help,

  {
    'h',
    function()
      require('snacks').picker.help()
    end,
    desc = 'Help pages',
  },
  {
    'M',
    function()
      require('snacks').picker.man()
    end,
    desc = 'Man pages',
  },
}
groups[#groups + 1] = help

local navigation = {
  group = keys.groups.navigation,

  {
    'l',
    function()
      require('snacks').picker.loclist()
    end,
    desc = 'Location list',
  },
  {
    'q',
    function()
      require('snacks').picker.qflist()
    end,
    desc = 'Quickfix list',
  },
}
groups[#groups + 1] = navigation

local common = {
  {
    '<leader><space>',
    function()
      require('snacks').picker.smart()
    end,
    desc = 'Smart find files',
  },
  {
    '<leader>,',
    function()
      require('snacks').picker.buffers()
    end,
    desc = 'Find buffers',
  },
  {
    '<leader>/',
    function()
      require('snacks').picker.grep()
    end,
    desc = 'Grep files',
  },
  {
    '<leader>:',
    function()
      require('snacks').picker.command_history()
    end,
    desc = 'Find command history',
  },

  {
    '<leader>R',
    function()
      require('snacks').picker.resume()
    end,
    desc = 'Resume',
  },
}
groups[#groups + 1] = common

return {
  'folke/snacks.nvim',
  dependencies = {
    {
      'nvim-tree/nvim-web-devicons',
      enabled = vim.g.have_nerd_font,
    },
  },
  ---@type snacks.Config
  opts = {
    picker = {},
  },
  keys = function()
    local ret = {}
    for _, group in pairs(groups) do
      local prefix = group.group and group.group.prefix or ''
      for _, binding in ipairs(group) do
        local prefixed_binding = vim.tbl_extend('force', {}, binding, { prefix .. binding[1] })
        ret[#ret + 1] = prefixed_binding
      end
    end

    return ret
  end,
}
