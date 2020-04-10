call plug#begin('~/.config/nvim/plugged')
    Plug 'scrooloose/nerdtree'
    " Plug 'majutsushi/tagbar'

    Plug 'AlessandroYorba/Alduin' " Colorscheme
    Plug 'sakshamgupta05/vim-todo-highlight' " Highlight tasks

    Plug 'vim-airline/vim-airline'
    Plug 'vim-airline/vim-airline-themes'

    Plug 'vim-syntastic/syntastic'
    Plug 'tveskag/nvim-blame-line' " Display GIT Blame on the same line as cursor
    Plug 'ntpeters/vim-better-whitespace'
    Plug 'scrooloose/nerdcommenter'

    if isdirectory('/usr/local/opt/fzf')
        Plug '/usr/local/opt/fzf' | Plug 'junegunn/fzf.vim'
    else
        Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --bin' }
        Plug 'junegunn/fzf.vim'
    endif

    Plug 'ctrlpvim/ctrlp.vim'

    " :CocInstall coc-tsserver coc-git coc-yaml coc-json coc-python coc-html
    " coc-eslint coc-rls coc-vetur coc-tslint coc-tslint-plugin coc-css
    " coc-phpls coc-elixir coc-spell-checker
    Plug 'neoclide/coc.nvim', {'branch': 'release'}
    Plug 'ekalinin/dockerfile.vim'
    Plug 'vim-scripts/PDV--phpDocumentor-for-Vim'

    Plug 'plasticboy/vim-markdown'
    Plug 'suan/vim-instant-markdown', {'for': 'markdown'}
    Plug 'ferrine/md-img-paste.vim'

call plug#end()

" General settings
set tags=tags;,./tags;
syntax on
set ruler
set number              " show line numbers
set hidden              " if hidden is not set, TextEdit might fail.
set nobackup            " Some servers have issues with backup files, see #649
set nowritebackup
set cmdheight=2         " Better display for messages
set updatetime=300      " You will have bad experience for diagnostic messages when it's default 4000.
set shortmess+=c        " don't give |ins-completion-menu| messages.
set signcolumn=yes      " always show signcolumns
let mapleader=','       " Map leader to ,
filetype plugin on

"" Colors
set background = "dark"
" let g:alduin_Shout_Dragon_Aspect = 1
silent! colorscheme alduin " https://github.com/AlessandroYorba/Alduin

"" Encoding
set encoding=utf-8
set fileencoding=utf-8
set fileencodings=utf-8
set ttyfast

"" Fix backspace indent
set backspace=indent,eol,start

"" Tabs. May be overridden by autocmd rules
set tabstop=4
set softtabstop=0
set shiftwidth=4
set expandtab

"" The PC is fast enough, do syntax highlight syncing from start unless 200 lines
augroup vimrc-sync-fromstart
  autocmd!
  autocmd BufEnter * :syntax sync maxlines=200
augroup END

"" Remember cursor position
augroup vimrc-remember-cursor-position
  autocmd!
  autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
augroup END

"" txt
augroup vimrc-wrapping
  autocmd!
  autocmd BufRead,BufNewFile *.txt call s:setupWrapping()
augroup END

"" make/cmake
augroup vimrc-make-cmake
  autocmd!
  autocmd FileType make setlocal noexpandtab
  autocmd BufNewFile,BufRead CMakeLists.txt setlocal filetype=cmake
augroup END
set autoread

" Enable mouse
set mouse=a

" RELOAD vimrc
map <F9> :source ~/.config/nvim/init.vim<CR>

" Display tasks
nnoremap <F8> ::cexpr system('git grep --line-number -e FIXME -e TODO -e DEIVS')<CR>:copen<CR>

" Blame
let g:blameLineVirtualTextHighlight = 'Question'
nnoremap <Leader>B :Gblame<CR>
nnoremap <silent> <leader>b :ToggleBlameLine<CR>
autocmd BufEnter * EnableBlameLine

" Statusline
set title
set titleold="Terminal"
set titlestring=%F

" vim-airline
let g:airline_theme = 'angr'
let g:airline#extensions#branch#enabled = 1
let g:airline#extensions#ale#enabled = 1
let g:airline#extensions#tabline#enabled = 1
" let g:airline#extensions#tagbar#enabled = 1
let g:airline_skip_empty_sections = 1

" Syntax
nnoremap <F1> :SyntasticCheck<CR>

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 1

let g:syntastic_php_checkers = ['php', 'phpcs', 'phpmd']
let g:syntastic_vue_checkers = ['eslint', 'pug_lint_vue']
let g:syntastic_python_checkers = ['python', 'pylint']
let g:syntastic_elixir_checkers = ['elixir']

let g:syntastic_enable_elixir_checker = 1
let g:syntastic_enable_elixir_checker = 1
" Color column for max characters in line
:set colorcolumn=79

" Trailing whitespace
let g:better_whitespace_enabled=1
autocmd BufEnter * EnableWhitespace

" Navigation
let NERDTreeShowHidden=1
nnoremap <silent> <F4> :NERDTreeToggle<CR>

" Buffers
noremap <leader>z :bp<CR>
noremap <leader>q :bp<CR>
noremap <leader>x :bn<CR>
noremap <leader>w :bn<CR>
noremap <leader>c :bd<CR>

" Tags
" nmap <F5> :TagbarToggle<CR>
" autocmd BufEnter * TagbarToggle

" Search
let g:fzf_buffers_jump = 1

" The Silver Searcher
if executable('ag')
  set grepprg=ag\ --nogroup\ --nocolor
endif
let $FZF_DEFAULT_COMMAND = 'ag --hidden --ignore .git --ignore "*tags" --ignore "*-chunk.js" -g ""'
nnoremap <silent> <F3> :Ag<CR>

" CtrlP
let g:ctrlp_map = '<F2>'
let g:ctrlp_cmd = 'CtrlP'

" Autocomplete
" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current
" position. Coc only does snippet and additional edit on confirm.
if has('patch8.1.1068')
  " Use `complete_info` if your (Neo)Vim version supports it.
  inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
else
  imap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
endif

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Formatting selected code.
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Add (Neo)Vim's native statusline support.
" NOTE: Please see `:h coc-status` for integrations with external plugins that
" provide custom statusline: lightline.vim, vim-airline.
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Docblock
inoremap <C-P> <ESC>:call PhpDocSingle()<CR>i
nnoremap <C-P> :call PhpDocSingle()<CR>
vnoremap <C-P> :call PhpDocRange()<CR>

" Markdown
let g:vim_markdown_folding_disabled = 1

"let g:instant_markdown_slow = 1
"let g:instant_markdown_autostart = 0
"let g:instant_markdown_open_to_the_world = 1
"let g:instant_markdown_allow_unsafe_content = 1
"let g:instant_markdown_allow_external_content = 0
let g:instant_markdown_mathjax = 1
let g:instant_markdown_logfile = '/tmp/instant_markdown.log'
"let g:instant_markdown_autoscroll = 0
"let g:instant_markdown_port = 8888
"let g:instant_markdown_python = 1

autocmd FileType markdown nmap <silent> <leader>p :call mdip#MarkdownClipboardImage()<CR>
" there are some defaults for image directory and image name, you can change them
" let g:mdip_imgdir = 'img'
" let g:mdip_imgname = 'image'
