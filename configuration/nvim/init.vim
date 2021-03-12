call plug#begin('~/.config/nvim/plugged')

    " Visuals
    Plug 'jistr/vim-nerdtree-tabs'                      " nerdtree open file in tab
    Plug 'bagrat/vim-buffet'
    Plug 'luochen1990/rainbow'                          " rainbow parantheses
    Plug 'mhinz/vim-startify'                           " replace welcome screen
    Plug 'ntpeters/vim-better-whitespace'               " display trailing whitespace
    Plug 'ryanoasis/vim-devicons'                       " nerdtree icons
    Plug 'tomasr/molokai'                               " theme
    Plug 'vim-airline/vim-airline'                      " status line
    Plug 'vim-airline/vim-airline-themes'               " status line theme
    Plug 'yggdroot/indentline'                          " indicate indents

    " Functionality
    Plug 'elixir-lang/vim-elixir'                       " elixir support
    Plug 'godlygeek/tabular'                            " Align text
    Plug 'scrooloose/nerdtree'                          " File explorer
    Plug 'spf13/vim-autoclose'                          " Auto close brackets/braces/etc
    Plug 'tveskag/nvim-blame-line'                      " display git blame
    Plug 'vim-scripts/BufOnly.vim'                      " Close all buffers but current
    Plug 'vim-syntastic/syntastic'                      " linters
    Plug 'wikitopian/hardmode'                          " disable arrow keys / hjkl
    Plug 'scrooloose/nerdcommenter'                     " toggle comments
    Plug 'phpactor/phpactor', {'for': 'php', 'tag': '*', 'do': 'composer install --no-dev -o'}

    " Completion
    Plug 'elixir-lsp/coc-elixir', {'do': 'yarn install --frozen-lockfile'}
    Plug 'iamcco/coc-spell-checker', {'do': 'yarn install --frozen-lockfile'}
    Plug 'marlonfan/coc-phpls', {'do': 'yarn install --frozen-lockfile'}
    Plug 'neoclide/coc-css', {'do': 'yarn install --frozen-lockfile'}
    Plug 'neoclide/coc-eslint', {'do': 'yarn install --frozen-lockfile'}
    Plug 'neoclide/coc-git', {'do': 'yarn install --frozen-lockfile'}
    Plug 'neoclide/coc-html', {'do': 'yarn install --frozen-lockfile'}
    Plug 'neoclide/coc-json', {'do': 'yarn install --frozen-lockfile'}
    Plug 'neoclide/coc-python', {'do': 'yarn install --frozen-lockfile'}
    Plug 'neoclide/coc-rls', {'do': 'yarn install --frozen-lockfile'}
    Plug 'neoclide/coc-tsserver', {'do': 'yarn install --frozen-lockfile'}
    Plug 'neoclide/coc-vetur', {'do': 'yarn install --frozen-lockfile'}
    Plug 'neoclide/coc-yaml', {'do': 'yarn install --frozen-lockfile'}
    Plug 'neoclide/coc.nvim', {'branch': 'release'}
    Plug 'phpactor/coc-phpactor', {'do': 'yarn install --frozen-lockfile'}

    " Fuzzy search
    if isdirectory('/usr/local/opt/fzf')
        Plug '/usr/local/opt/fzf' | Plug 'junegunn/fzf.vim'
    else
        Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --bin' }
        Plug 'junegunn/fzf.vim'
    endif

call plug#end()

" Settings
let $FZF_DEFAULT_COMMAND = 'rg --hidden'
let NERDTreeShowHidden=1
let g:NERDCreateDefaultMappings = 0
let g:NERDToggleCheckAllLines = 1
let g:NERDTreeExactMatchHighlightFullName = 1
let g:NERDTreeFileExtensionHighlightFullName = 1
let g:NERDTreeGitStatusIndicatorMapCustom = {
    \ "Modified"  : "?",
    \ "Staged"    : "?",
    \ "Untracked" : "?",
    \ "Renamed"   : "?",
    \ "Unmerged"  : "?",
    \ "Deleted"   : "?",
    \ "Dirty"     : "?",
    \ "Clean"     : "??",
    \ 'Ignored'   : '?',
    \ "Unknown"   : "?"
    \ }
let g:NERDTreeGitStatusShowIgnored = 1
let g:NERDTreePatternMatchHighlightFullName = 1
let g:airline#extensions#ale#enabled = 1
let g:airline#extensions#branch#enabled = 1
let g:airline#extensions#tabline#enabled = 0
let g:airline#extensions#tagbar#enabled = 1
let g:airline_skip_empty_sections = 1
let g:airline_theme = 'angr'
let g:better_whitespace_enabled=1
let g:blameLineVirtualTextHighlight = 'Question'
let g:buffet_left_trunc_icon = "\uf0a8"
let g:buffet_powerline_separators = 0
let g:buffet_right_trunc_icon = "\uf0a9"
let g:buffet_tab_icon = "\uf00a"
let g:indent_guides_enable_on_vim_startup = 1
let g:rainbow_active = 1
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 1
let g:syntastic_cs_checkers = ['code_checker']
let g:syntastic_elixir_checkers = ['elixir']
let g:syntastic_enable_elixir_checker = 1
let g:syntastic_php_checkers = ['php', 'phpcs', 'phpmd']
let g:syntastic_python_checkers = ['python', 'pylint']
let g:syntastic_vue_checkers = ['eslint', 'pug_lint_vue']
set autoindent
set autoread
set background=dark
set backspace=indent,eol,start
set clipboard=unnamedplus 	                        " sync to clipboard
set colorcolumn=120		                            " enable max width line
set encoding=utf-8
set expandtab
set fileencoding=utf-8
set fileencodings=utf-8
set foldmethod=indent
set guifont=FiraCode\ Nerd\ Font:h12
set mouse=a			                                " enable mouse
set noswapfile			                            " disable swap files
set number relativenumber 	                        " use hybrid numberr
set shiftwidth=4
set smartindent
set softtabstop=0
set tabstop=4
set tags=tags;,./tags;
set ttyfast

if executable('rg')
  set grepprg=rg\ --nogroup\ --nocolor
endif

runtime coc.vim                                     " include coc.vim settings file

" autocmd VimEnter,BufNewFile,BufReadPost * silent! call HardMode()
autocmd BufEnter * EnableBlameLine
autocmd BufEnter * EnableWhitespace

" Bindings
let mapleader = ","

map <leader>rr :source ~/.config/nvim/init.vim<CR>
map <leader>s :sort u<CR>
nmap <leader>0 <Plug>BuffetSwitch(10)
nmap <leader>1 <Plug>BuffetSwitch(1)
nmap <leader>2 <Plug>BuffetSwitch(2)
nmap <leader>3 <Plug>BuffetSwitch(3)
nmap <leader>4 <Plug>BuffetSwitch(4)
nmap <leader>5 <Plug>BuffetSwitch(5)
nmap <leader>6 <Plug>BuffetSwitch(6)
nmap <leader>7 <Plug>BuffetSwitch(7)
nmap <leader>8 <Plug>BuffetSwitch(8)
nmap <leader>9 <Plug>BuffetSwitch(9)
nnoremap <A-Left> :bp<CR>
nnoremap <A-Right> :bn<CR>
nnoremap <C-Left> :bp<CR>
nnoremap <C-Right> :bn<CR>
nnoremap <leader>ct :!ctags -R .<CR>
nnoremap <silent> <leader>F :Rg<CR>
nnoremap <silent> <leader>db :BufOnly<CR>
nnoremap <silent> <leader>f :NERDTreeToggle<CR>
noremap <C-t> :tabnew split<CR>
noremap <Leader>C :Bw!<CR>
noremap <Leader>c :Bw<CR>
noremap <leader>Q :PhpactorContextMenu<CR>
noremap <leader>cc :call NERDComment('n', 'toggle')<CR>

" move line up or down
nnoremap <A-j> :m .+1<CR>==
nnoremap <A-k> :m .-2<CR>==
inoremap <A-j> <Esc>:m .+1<CR>==gi
inoremap <A-k> <Esc>:m .-2<CR>==gi
vnoremap <A-j> :m '>+1<CR>gv=gv
vnoremap <A-k> :m '<-2<CR>gv=gv

if exists(":Tabularize")
  nmap <Leader>t= :Tabularize /=<CR>
  nmap <Leader>t= :Tabularize /=<CR>
  nmap <Leader>t: :Tabularize /:\zs<CR>
  vmap <Leader>t: :Tabularize /:\zs<CR>
endif

" Colors
function! OverrideColors()
    hi ColorColumn ctermfg=144 ctermbg=52
    hi Comment ctermfg=darkred
    hi SyntasticError ctermfg=144 ctermbg=9
    hi SyntasticStyleError ctermfg=144 ctermbg=9
    hi SyntasticStyleWarning ctermfg=144 ctermbg=9
    hi SyntasticWarning ctermfg=144 ctermbg=9

    " transparent background
    hi! NonText ctermbg=NONE guibg=NONE
    hi! Normal ctermbg=NONE guibg=NONE
endfunction

augroup MyColorScheme
    autocmd!
    autocmd ColorScheme * call OverrideColors()
augroup END

colorscheme molokai
