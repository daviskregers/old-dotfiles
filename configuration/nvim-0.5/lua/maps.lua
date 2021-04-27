local map = vim.api.nvim_set_keymap

-- map the leader key
map('n', ',', '', {})
vim.g.mapleader = ','  -- 'vim.g' sets global variables

options = { noremap = true }
--[[
map('n', '<leader><esc>', ':nohlsearch<cr>', options)
map('n', '<leader>n', ':bnext<cr>', options)
map('n', '<leader>p', ':bprev<cr>', options)
--]]

-- Better nav for omnicomplete
--map('i', '<c-j>', '("\<C-n>")', { noremap = true, expr = true })
--map('i', '<c-k>', '("\<C-p>")', { noremap = true, expr = true })

-- Use alt + hjkl to resize windows
map('n', '<M-j>', ':resize -2<CR>', options)
map('n', '<M-k>', ':resize +2<CR>', options)
map('n', '<M-h>', ':vertical resize -2<CR>', options)
map('n', '<M-l>', ':vertical resize +2<CR>', options)

-- I hate escape more than anything else
map('i', 'jk', '<ESC>', options)
map('i', 'kj', '<ESC>', options)

-- Easy CAPS
map('i', '<c-u>' , '<ESC>viwUi', options)
map('n', '<c-u>' , 'viwU<ESC>', options)

-- TAB in general mode will move to text buffer
-- SHIFT-TAB will go back
map('n', '<TAB>', ':bnext<CR>', options)
map('n', '<S-TAB>', ':bprevious<CR>', options)

map('n', '<C-Left>', ':bp<CR>', options)
map('n', '<C-Right>', ':bn<CR>', options)

-- close buffer
map('n', '<Leader>C', ':Bw!<CR>', options)
map('n', '<Leader>c', ':Bw<CR>', options)

-- Alternate way to save
map('n', '<C-s>', ':w<CR>', options)
-- Alternate way to quit
map('n', '<C-Q>', 'wq!<CR>', options)
-- Use control-c instead of escape
map('n', '<C-c>', '<Esc>', options)

-- Better tabbing
map('v', '<', '<gv', options)
map('v', '>', '>gv', options)

-- Better window navigation
map('n', '<C-h>', '<C-w>h', options)
map('n', '<C-j>', '<C-w>j', options)
map('n', '<C-k>', '<C-w>k', options)
map('n', '<C-l>', '<C-w>l', options)
map('n', '<M-Left>', '<C-w>h', options)
map('n', '<M-Down>', '<C-w>j', options)
map('n', '<M-Up>', '<C-w>k', options)
map('n', '<M-Right>', '<C-w>l', options)

map('n', '<Leader>o', 'o<Esc>^Da', options)
map('n', '<Leader>O', 'O<Esc>^Da', options)

-- reload vimrc
map('n', '<leader>rr', ':Reload<CR>', options)

-- generate ctags
map('n', '<leader>ct', ':!ctags -R .<CR>', options)

-- sort selected lines
map('v', '<leader>s', ':sort u<CR>', {})

-- move line up or down
map('n', '<A-j>', ':m .+1<CR>==', options)
map('n', '<A-k>', ':m .-2<CR>==', options)
map('i', '<A-j>', '<Esc>:m .+1<CR>==gi', options)
map('i', '<A-k>', '<Esc>:m .-2<CR>==gi', options)
map('v', '<A-j>', ':m \'>+1<CR>gv=gv', options)
map('v', '<A-k>', ':m \'<-2<CR>gv=gv', options)

map('n', '<A-Down>', ':m .+1<CR>==', options)
map('n', '<A-Up>', ':m .-2<CR>==', options)
map('i', '<A-Down>', '<Esc>:m .+1<CR>==gi', options)
map('i', '<A-Up>', '<Esc>:m .-2<CR>==gi', options)
map('v', '<A-Down>', ':m \'>+1<CR>gv=gv', options)
map('v', '<A-Up>', ':m \'<-2<CR>gv=gv', options)

-- fuzzy file finder

map('n', '<leader>f', '<cmd>Telescope find_files<CR>', options)
map('n', '<leader>fg', '<cmd>Telescope live_grep<CR>', options)
map('n', '<leader>fb', '<cmd>Telescope buffers<CR>', options)
map('n', '<leader>fh', '<cmd>Telescope help_tags<CR>', options)
map('n', '<leader>fl', '<cmd>Telescope git_files<CR>', options)

-- tabline
map('n', '<A-Left>', ':BufferPrevious<CR>', { silent = true, noremap = true })
map('n', '<A-Right>', ':BufferNext<CR>', { silent = true, noremap = true })
map('n', '<A-S-Left>', ':BufferMovePrevious<CR>', { silent = true, noremap = true })
map('n', '<A-S-Right>', ':BufferMoveNext<CR>', { silent = true, noremap = true })

map('n', '<leader>1', ':BufferGoto 1<CR>', { silent = true, noremap = true })
map('n', '<leader>2', ':BufferGoto 2<CR>', { silent = true, noremap = true })
map('n', '<leader>3', ':BufferGoto 3<CR>', { silent = true, noremap = true })
map('n', '<leader>4', ':BufferGoto 4<CR>', { silent = true, noremap = true })
map('n', '<leader>5', ':BufferGoto 5<CR>', { silent = true, noremap = true })
map('n', '<leader>6', ':BufferGoto 6<CR>', { silent = true, noremap = true })
map('n', '<leader>7', ':BufferGoto 7<CR>', { silent = true, noremap = true })
map('n', '<leader>8', ':BufferGoto 8<CR>', { silent = true, noremap = true })
map('n', '<leader>9', ':BufferLast<CR>', { silent = true, noremap = true })
map('n', '<leader>c', ':BufferClose<CR>', { silent = true, noremap = true })

-- text align
map('n', 'ga', '<Plug>(EasyAlign)', {})
map('x', 'ga', '<Plug>(EasyAlign)', {})

-- phpactor
map('n', '<leader>Q', ':PhpactorContextMenu<CR>', options)

-- tagbar
map('n', '<leader>tb', ':TagbarToggle<CR>', {})
