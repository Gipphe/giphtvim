local keys = require 'keygroups'
local groups = {}

local search = {
  group = keys.groups.search,
  {
    lhs = 'B',
    rhs = function()
      require('snacks').picker.grep_buffers()
    end,
    desc = 'Search open buffers with grep',
  },
  {
    lhs = 'g',
    rhs = function()
      require('snacks').picker.grep()
    end,
    desc = 'Search files with grep',
  },
  {
    lhs = 'w',
    rhs = function()
      require('snacks').picker.grep_word()
    end,
    desc = 'Search for visual selection or word',
    mode = { 'n', 'x' },
  },
  {
    lhs = '/',
    rhs = function()
      require('snacks').picker.search_history()
    end,
    desc = 'Search history',
  },
  {
    lhs = 'b',
    rhs = function()
      require('snacks').picker.lines()
    end,
    desc = 'Search buffer lines',
  },
}
table.insert(groups, search)

local code = {
  group = keys.groups.code,

  -- TODO: I don't think I even have cliphist.
  -- {
  --   lhs = 'h',
  --   rhs = function()
  --     require('snacks').picker.cliphist()
  --   end,
  --   desc = 'View cliphist',
  -- },
}
table.insert(groups, code)

local buffers = {
  group = keys.groups.buffer,
  {
    lhs = 'h',
    rhs = function()
      require('snacks').picker.buffers()
    end,
    desc = 'Pick buffers',
  },
}
table.insert(groups, buffers)

local ui = {
  group = keys.groups.ui,

  {
    lhs = 'C',
    rhs = function()
      require('snacks').picker.colorschemes()
    end,
    desc = 'Pick colorscheme',
  },
}
table.insert(groups, ui)

local git = {
  group = keys.groups.git,

  {
    lhs = 'Pb',
    rhs = function()
      require('snacks').picker.git_branches()
    end,
    desc = 'Git branches',
  },
  {
    lhs = 'Pl',
    rhs = function()
      require('snacks').picker.git_log()
    end,
    desc = 'Git log',
  },
  {
    lhs = 'PL',
    rhs = function()
      require('snacks').picker.git_log_line()
    end,
    desc = 'Git log line',
  },
  {
    lhs = 'Ps',
    rhs = function()
      require('snacks').picker.git_status()
    end,
    desc = 'Git status',
  },
  {
    lhs = 'PS',
    rhs = function()
      require('snacks').picker.git_stash()
    end,
    desc = 'Git stash',
  },
  {
    lhs = 'Pd',
    rhs = function()
      require('snacks').picker.git_diff()
    end,
    desc = 'Git diff (hunks)',
  },
  {
    lhs = 'Pf',
    rhs = function()
      require('snacks').picker.git_log_file()
    end,
    desc = 'Git log file',
  },
}
table.insert(groups, git)

local find = {
  group = keys.groups.find,

  {
    lhs = 'g',
    rhs = function()
      require('snacks').picker.git_grep()
    end,
    desc = 'Find git-tracked files',
  },
  {
    lhs = 'c',
    rhs = function()
      ---@diagnostic disable-next-line: assign-type-mismatch
      require('snacks').picker.files { cwd = vim.fn.stdpath 'config' }
    end,
    desc = 'Find config file',
  },
  {
    lhs = 'f',
    rhs = function()
      require('snacks').picker.files()
    end,
    desc = 'Find files',
  },
  {
    lhs = 'p',
    rhs = function()
      require('snacks').picker.projects()
    end,
    desc = 'Find projects',
  },
  {
    lhs = 'r',
    rhs = function()
      require('snacks').picker.recent()
    end,
    desc = 'Find recent files',
  },
}
table.insert(groups, find)

local inspect = {
  group = keys.groups.inspect,

  {
    lhs = 'a',
    rhs = function()
      require('snacks').picker.autocmds()
    end,
    desc = 'Autocmds',
  },
  {
    lhs = '"',
    rhs = function()
      require('snacks').picker.registers()
    end,
    desc = 'Registers',
  },
  {
    lhs = 'c',
    rhs = function()
      require('snacks').picker.command_history()
    end,
    desc = 'Command history',
  },
  {
    lhs = 'C',
    rhs = function()
      require('snacks').picker.commands()
    end,
    desc = 'Commands',
  },
  {
    lhs = 'h',
    rhs = function()
      require('snacks').picker.highlights()
    end,
    desc = 'Highlights',
  },
  {
    lhs = 'i',
    rhs = function()
      require('snacks').picker.icons()
    end,
    desc = 'Icons',
  },
  {
    lhs = 'j',
    rhs = function()
      require('snacks').picker.jumps()
    end,
    desc = 'Jumps',
  },
  {
    lhs = 'k',
    rhs = function()
      require('snacks').picker.keymaps()
    end,
    desc = 'Keymaps',
  },
  {
    lhs = 'm',
    rhs = function()
      require('snacks').picker.marks()
    end,
    desc = 'Marks',
  },
  {
    lhs = 'n',
    rhs = function()
      require('snacks').picker.notifications()
    end,
    desc = 'Notifications',
  },
  {
    lhs = 'p',
    rhs = function()
      require('snacks').picker.lazy()
    end,
    desc = 'Search for plugin spec',
  },
  {
    lhs = 'u',
    rhs = function()
      require('snacks').picker.undo()
    end,
    desc = 'Undo history',
  },
}
table.insert(groups, inspect)

local diagnostic = {
  group = keys.groups.diagnostic,

  {
    lhs = 'd',
    rhs = function()
      require('snacks').picker.diagnostics()
    end,
    desc = 'View diagnostics',
  },
  {
    lhs = 'D',
    rhs = function()
      require('snacks').picker.diagnostics_buffer()
    end,
    desc = 'View buffer diagnostics',
  },
}
table.insert(groups, diagnostic)

local help = {
  group = keys.groups.help,

  {
    lhs = 'h',
    rhs = function()
      require('snacks').picker.help()
    end,
    desc = 'Help pages',
  },
  {
    lhs = 'M',
    rhs = function()
      require('snacks').picker.man()
    end,
    desc = 'Man pages',
  },
}
table.insert(groups, help)

local navigation = {
  group = keys.groups.navigation,

  {
    lhs = 'l',
    rhs = function()
      require('snacks').picker.loclist()
    end,
    desc = 'Location list',
  },
  {
    lhs = 'q',
    rhs = function()
      require('snacks').picker.qflist()
    end,
    desc = 'Quickfix list',
  },
}
table.insert(groups, navigation)

local common = {
  {
    lhs = '<leader><space>',
    rhs = function()
      require('snacks').picker.smart()
    end,
    desc = 'Smart find files',
  },
  {
    lhs = '<leader>,',
    rhs = function()
      require('snacks').picker.buffers()
    end,
    desc = 'Find buffers',
  },
  {
    lhs = '<leader>/',
    rhs = function()
      require('snacks').picker.grep()
    end,
    desc = 'Grep files',
  },
  {
    lhs = '<leader>:',
    rhs = function()
      require('snacks').picker.command_history()
    end,
    desc = 'Find command history',
  },

  {
    lhs = '<leader>R',
    rhs = function()
      require('snacks').picker.resume()
    end,
    desc = 'Resume',
  },
}
table.insert(groups, common)

return {
  keys = (function()
    local ret = {}
    for _, group in pairs(groups) do
      local prefix = group.group and group.group.prefix or ''
      for _, binding in ipairs(group) do
        local prefixed_binding = vim.tbl_extend('force', {}, binding, { prefix .. binding.lhs })
        table.insert(ret, prefixed_binding)
      end
    end

    return ret
  end)(),
}
