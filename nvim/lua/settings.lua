local global = vim.o
local window = vim.wo
local buffer = vim.bo

local cmd = vim.cmd
local u = require('utils')

-- If you’re not sure if an option is global, buffer or window-local,
-- consult the Vim help! For example, :h 'number':

global.swapfile = false
global.dir = '/tmp'
global.smartcase = true
global.laststatus = 2
global.hlsearch = true
global.incsearch = true
global.ignorecase = true
global.scrolloff = 12
global.hidden = true
global.pumheight = 10
global.ruler = true
global.cmdheight = 2
global.mouse = 'a'
global.splitbelow = true
global.splitright = true
global.smarttab = true
global.expandtab = true
global.smartindent = true
global.autoindent = true
global.background = 'dark'
global.showtabline = 2
global.showmode = false
global.backup = false
global.writebackup = false
global.updatetime = 300
global.timeoutlen = 500
global.clipboard = 'unnamedplus'
global.guifont = 'FiraCode Nerd Font:h12'
global.tags ='tags;,./tags;'
global.grepprg = 'rg --nogroup --nocolor'
global.completeopt = "menuone,noinsert,noselect"

window.number = false
window.wrap = false
window.conceallevel = 0
window.number = true
window.cursorline = true
window.colorcolumn = '120'
window.foldmethod = 'indent'

buffer.expandtab = true
buffer.syntax = 'ON'
--buffer.iskeyword+=-
buffer.tabstop = 4
buffer.shiftwidth = 3
buffer.autoread = true
buffer.softtabstop = 4
--buffer.formatoptions -= cro
--

-- auto commands
-- u.create_augroup({
--    { 'BufRead,BufNewFile', '/tmp/nail-*', 'setlocal', 'ft=mail' },
--    { 'BufRead,BufNewFile', '*s-nail-*', 'setlocal', 'ft=mail' },
--}, 'ftmail')

cmd('au CursorHold * checktime')
--cmd('au! BufWritePost $MYVIMRC source %')
cmd('au! BufWritePost $MYVIMRC :Reload')
cmd('au Filetype * setlocal omnifunc=v:lua.vim.lsp.omnifunc')

-- blame line
cmd('au BufEnter * EnableBlameLine')
vim.api.nvim_set_var('blameLineVirtualTextHighlight', 'BlameLine')

require('autocmd-lua').augroup {
  -- the keys `group` and `autocmds` are also optional
  'filetype_commands',
  {{
    'FileType', {
      yaml = 'set tabstop=2 shiftwidth=2',
      yml = 'set tabstop=2 shiftwidth=2',
      tf = 'set tabstop=2 shiftwidth=2',
    }
  }}
}

require("which-key").setup {
  -- your configuration comes here
  -- or leave it empty to use the default settings
  -- refer to the configuration section below
}
