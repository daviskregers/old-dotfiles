call plug#begin('~/.config/nvim/plugged')
    
  Plug 'christophermca/meta5'
  Plug 'scrooloose/nerdtree'
  Plug 'vim-airline/vim-airline'
  Plug 'vim-airline/vim-airline-themes'
  Plug 'airblade/vim-gitgutter'  
  Plug 'tpope/vim-fugitive'
  Plug 'tveskag/nvim-blame-line'
  Plug 'neoclide/coc.nvim'
  Plug 'vim-syntastic/syntastic'
  Plug 'eslint/eslint'
  Plug 'plasticboy/vim-markdown'
  Plug 'suan/vim-instant-markdown', {'for': 'markdown'}
  Plug 'ferrine/md-img-paste.vim'
  Plug 'majutsushi/tagbar'
  Plug 'neoclide/coc-yaml'
  Plug 'marlonfan/coc-phpls'
  Plug 'ekalinin/dockerfile.vim'
  Plug 'scrooloose/nerdcommenter'
  Plug 'brett-griffin/phpdocblocks.vim'
  Plug 'neoclide/coc-eslint'
  Plug 'neoclide/coc-vetur'
  Plug 'elixir-editors/vim-elixir'
  Plug 'mmorearty/elixir-ctags'
  Plug 'amiralies/coc-elixir'
  Plug 'neoclide/coc-python'
  Plug 'hdima/python-syntax'
  Plug 'nsf/gocode', { 'rtp': 'nvim', 'do': '~/.config/nvim/plugged/gocode/nvim/symlink.sh' }
  Plug 'jiangmiao/auto-pairs'

  if isdirectory('/usr/local/opt/fzf')
    Plug '/usr/local/opt/fzf' | Plug 'junegunn/fzf.vim'
  else
    Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --bin' }
    Plug 'junegunn/fzf.vim'
  endif

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

"""
" Keymaps:
" - Leader is `,`
" - F1 - syntastic
" - F9 - reload vim configuration
" - F3 - Toggle NerdTree
" - F6 - TODO List
" - F7 - TODO List with DEIVS only
" - <Leader>b - toggle blame line
" - <Leader>B - git blame table
" - <Leader>cc - toggle comments
" - <Leader>pd - generate docblock
"""

" Reload vimrc
map <F9> :source ~/.config/nvim/init.vim<CR>

" NerdTREE
let NERDTreeShowHidden=1
nnoremap <silent> <F3> :NERDTreeToggle<CR>
" autocmd VimEnter * NERDTree | wincmd p

" Color
set background = "dark"
silent! colorscheme meta5

" GBlame / Blame line
autocmd BufEnter * EnableBlameLine
nnoremap <Leader>B :Gblame<CR>
nnoremap <silent> <leader>b :ToggleBlameLine<CR>

"""""" COC
" :CocInstall coc-phpls
" :CocInstall coc-elixir
" :CocInstall coc-python



" Use tab for trigger completion with characters ahead and navigate.
" Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.

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

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current position.
" Coc only does snippet and additional edit on confirm.
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
" Or use `complete_info` if your vim support it, like:
" inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"

" Use `[g` and `]g` to navigate diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Highlight symbol under cursor on CursorHold
autocmd CursorHold * silent call CocActionAsync('highlight')

" Remap for rename current word
nmap <leader>rn <Plug>(coc-rename)

" Remap for format selected region
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Remap for do codeAction of selected region, ex: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap for do codeAction of current line
nmap <leader>ac  <Plug>(coc-codeaction)
" Fix autofix problem of current line
nmap <leader>qf  <Plug>(coc-fix-current)

" Create mappings for function text object, requires document symbols feature of languageserver.
xmap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap if <Plug>(coc-funcobj-i)
omap af <Plug>(coc-funcobj-a)

" Use <C-d> for select selections ranges, needs server support, like: coc-tsserver, coc-python
nmap <silent> <C-d> <Plug>(coc-range-select)
xmap <silent> <C-d> <Plug>(coc-range-select)

" Use `:Format` to format current buffer
command! -nargs=0 Format :call CocAction('format')

" Use `:Fold` to fold current buffer
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" use `:OR` for organize import of current buffer
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" Add status line support, for integration with other plugin, checkout `:h coc-status`
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Using CocList
" Show all diagnostics
nnoremap <silent> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions
nnoremap <silent> <space>e  :<C-u>CocList extensions<cr>
" Show commands
nnoremap <silent> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document
nnoremap <silent> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols
nnoremap <silent> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list
nnoremap <silent> <space>p  :<C-u>CocListResume<CR>

" Statusline

set title
set titleold="Terminal"
set titlestring=%F

set statusline=%F%m%r%h%w%=(%{&ff}/%Y)\ (line\ %l\/%L,\ col\ %c)\

if exists("*fugitive#statusline")
  set statusline+=%{fugitive#statusline()}
endif

" vim-airline
let g:airline_theme = 'powerlineish'
let g:airline#extensions#branch#enabled = 1
let g:airline#extensions#ale#enabled = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tagbar#enabled = 1
let g:airline_skip_empty_sections = 1

" Syntastic
nnoremap <F1> :SyntasticCheck<CR>

set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_javascript_checkers = ['eslint', 'phpcs', 'elixir']
let g:syntastic_enable_elixir_checker = 1

" Buffers
noremap <leader>z :bp<CR>
noremap <leader>q :bp<CR>
noremap <leader>x :bn<CR>
noremap <leader>w :bn<CR>
noremap <leader>c :bd<CR>

" Enable mouse usage
set mouse=a
"set ttymouse=sgr
" the ^[ must be typed as <C-v><Esc> while in insert mode
map OA <up>
map OB <down>
map OC <right>
map OD <left>
map OAOAOAOAOAOAOA <Up>
map OBOBOBOBOBOBOB <Down>

" Todos - list occurrences for search

nnoremap <F6> ::cexpr system('git grep --line-number -e FIXME -e TODO -e DEIVS')<CR>:copen<CR>
nnoremap <F7> :cexpr system('git grep --line-number -e DEIVS')<CR>:copen<CR>
"autocmd VimEnter * execute "normal \<F6>"

""""" Comments https://vimawesome.com/plugin/the-nerd-commenter

" Add spaces after comment delimiters by default
let g:NERDSpaceDelims = 1

" Use compact syntax for prettified multi-line comments
let g:NERDCompactSexyComs = 1

" Align line-wise comment delimiters flush left instead of following code indentation
let g:NERDDefaultAlign = 'left'

" Set a language to use its alternate delimiters by default
let g:NERDAltDelims_java = 1

" Add your own custom formats or override the defaults
let g:NERDCustomDelimiters = { 'c': { 'left': '/**','right': '*/' } }

" Allow commenting and inverting empty lines (useful when commenting a region)
let g:NERDCommentEmptyLines = 1

" Enable trimming of trailing whitespace when uncommenting
let g:NERDTrimTrailingWhitespace = 1

" Enable NERDCommenterToggle to check all selected lines is commented or not 
let g:NERDToggleCheckAllLines = 1

" Docblock
nnoremap <leader>pd :PHPDocBlocks<cr>
let g:phpdocblocks_move_cursor = 1

" TagBar
nmap <F4> :TagbarToggle<CR>
" autocmd BufEnter * TagbarOpen

let g:tagbar_type_elixir = {
    \ 'ctagstype' : 'elixir',
    \ 'kinds' : [
        \ 'p:protocols',
        \ 'm:modules',
        \ 'e:exceptions',
        \ 'y:types',
        \ 'd:delegates',
        \ 'f:functions',
        \ 'c:callbacks',
        \ 'a:macros',
        \ 't:tests',
        \ 'i:implementations',
        \ 'o:operators',
        \ 'r:records'
    \ ],
    \ 'sro' : '.',
    \ 'kind2scope' : {
        \ 'p' : 'protocol',
        \ 'm' : 'module'
    \ },
    \ 'scope2kind' : {
        \ 'protocol' : 'p',
        \ 'module' : 'm'
    \ },
    \ 'sort' : 0
\ }

let g:tagbar_type_css = {
\ 'ctagstype' : 'Css',
    \ 'kinds'     : [
        \ 'c:classes',
        \ 's:selectors',
        \ 'i:identities'
    \ ]
\ }

" The Silver Searcher
if executable('ag')
  let $FZF_DEFAULT_COMMAND = 'ag --hidden --ignore .git -g ""'
  set grepprg=ag\ --nogroup\ --nocolor
endif
let $FZF_DEFAULT_COMMAND = 'ag --hidden --ignore .git --ignore "*tags" --ignore "*-chunk.js" -g ""'
nnoremap <silent> <F2> :Ag<CR>
