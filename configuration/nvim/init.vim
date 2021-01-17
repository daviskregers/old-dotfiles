call plug#begin('~/.config/nvim/plugged')
    Plug 'AlessandroYorba/Alduin' " Colorscheme
    Plug 'Xuyuanp/nerdtree-git-plugin'
    Plug 'christoomey/vim-conflicted'
    Plug 'ctrlpvim/ctrlp.vim'
    Plug 'dart-lang/dart-vim-plugin'
    Plug 'ekalinin/dockerfile.vim'
    Plug 'elixir-lsp/coc-elixir', {'do': 'yarn install && yarn prepack'}
    Plug 'ferrine/md-img-paste.vim'
    Plug 'frazrepo/vim-rainbow'
    Plug 'jistr/vim-nerdtree-tabs'
    Plug 'joonty/vdebug'
    Plug 'junegunn/vim-easy-align'
    Plug 'majutsushi/tagbar'
    Plug 'mg979/vim-visual-multi'
    Plug 'ntpeters/vim-better-whitespace'
    Plug 'omnisharp/omnisharp-vim' " RUN :OmniSharpInstall v1.34.2
    Plug 'plasticboy/vim-markdown'
    Plug 'ryanoasis/vim-devicons'
    Plug 'sakshamgupta05/vim-todo-highlight' " Highlight tasks
    Plug 'scrooloose/nerdcommenter'
    Plug 'scrooloose/nerdtree'
    Plug 'suan/vim-instant-markdown', {'for': 'markdown'}
    Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
    Plug 'tpope/vim-fugitive'
    Plug 'tveskag/nvim-blame-line' " Display GIT Blame on the same line as cursor
    Plug 'vim-airline/vim-airline'
    Plug 'vim-airline/vim-airline-themes'
    Plug 'vim-scripts/BufOnly.vim'
    Plug 'vim-syntastic/syntastic'
    Plug 'yggdroot/indentline'

    if isdirectory('/usr/local/opt/fzf')
        Plug '/usr/local/opt/fzf' | Plug 'junegunn/fzf.vim'
    else
        Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --bin' }
        Plug 'junegunn/fzf.vim'
    endif

    Plug 'neoclide/coc.nvim', {'branch': 'release'}

call plug#end()

function! InstallOrUpdatePlugins()
    execute ":echo \"Updating plugins...\""
    execute ":PlugClean"
    execute ":PlugInstall"
    execute ":PlugUpdate"
    execute ":CocInstall coc-tsserver coc-git coc-yaml coc-json coc-python coc-html coc-eslint coc-rls coc-vetur coc-tslint coc-tslint-plugin coc-css coc-phpls coc-elixir coc-spell-checker coc-flutter"
endfunction
" autocmd VimEnter * call InstallOrUpdatePlugins()

au ColorScheme * hi Normal ctermbg=none guibg=none
au ColorScheme myspecialcolors hi Normal ctermbg=red guibg=red

" Rainbow brackets
au FileType c,cpp,objc,objcpp,cs,js,php,vue call rainbow#load()
let g:rainbow_active = 1

" General settings
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

" Font
set guifont=Fira\ Code:h12

"" Colors
set background = "dark"
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
set foldmethod=indent

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
map <F9> :source ~/.config/nvim/init.vim<CR>:call InstallOrUpdatePlugins()<CR>

" Display tasks
function! SearchTodos()
  ::cexpr system('git grep --line-number -e FIXME -e TODO -e DEIVS')
  :copen
endfunction
nnoremap <F8> :call SearchTodos()<CR>
"autocmd VimEnter * :call SearchTodos()

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
let g:airline#extensions#tagbar#enabled = 1
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
let g:syntastic_cs_checkers = ['code_checker']

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
noremap <leader>c :NERDTreeClose<CR>:bd<CR>

" Tags
nmap <F5> :TagbarToggle<CR>
" autocmd BufEnter * TagbarToggle

" Search
let g:fzf_buffers_jump = 1

" RG searcher
if executable('rg')
  set grepprg=rg\ --nogroup\ --nocolor
endif
let $FZF_DEFAULT_COMMAND = 'rg --hidden'
nnoremap <silent> <F3> :Rg<CR>

" CtrlP
let g:ctrlp_map = '<F2>'
let g:ctrlp_cmd = 'CtrlP'

" --- COC configuration
" Add an option to rename things
nmap <leader>rn <Plug>(coc-rename)

" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying codeAction to the current buffer.
nmap <leader>ac  <Plug>(coc-codeaction)

" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Use CTRL-S for selections ranges.
" Requires 'textDocument/selectionRange' support of language server.
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

" Notes on COC:
" -- dockblocks - just type /**

" unfold all under selected
" formatting
" " Applying codeAction to the selected region.

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

" Refactor
xmap <leader>rf <Plug>(coc-refactor)
nmap <leader>rf <Plug>(coc-refactor)

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

" Markdown
let g:vim_markdown_folding_disabled = 1

"let g:instant_markdown_slow = 1
let g:instant_markdown_autostart = 1
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

" Transparent background
" hi Normal guibg=NONE ctermbg=NONE

" Omnisharp
" Note: this is required for the plugin to work
filetype indent plugin on

" Use the stdio OmniSharp-roslyn server
let g:OmniSharp_server_stdio = 1

" Set the type lookup function to use the preview window instead of echoing it
"let g:OmniSharp_typeLookupInPreview = 1

" Timeout in seconds to wait for a response from the server
let g:OmniSharp_timeout = 5

" Don't autoselect first omnicomplete option, show options even if there is only
" one (so the preview documentation is accessible). Remove 'preview', 'popup'
" and 'popuphidden' if you don't want to see any documentation whatsoever.
" Note that neovim does not support `popuphidden` or `popup` yet: 
" https://github.com/neovim/neovim/issues/10996
"set completeopt=longest,menuone,preview,popuphidden

" Highlight the completion documentation popup background/foreground the same as
" the completion menu itself, for better readability with highlighted
" documentation.
"set completepopup=highlight:Pmenu,border:off

" Fetch full documentation during omnicomplete requests.
" By default, only Type/Method signatures are fetched. Full documentation can
" still be fetched when you need it with the :OmniSharpDocumentation command.
let g:omnicomplete_fetch_full_documentation = 1

" Set desired preview window height for viewing documentation.
" You might also want to look at the echodoc plugin.
set previewheight=5

" Update semantic highlighting on BufEnter, InsertLeave and TextChanged
let g:OmniSharp_highlight_types = 2

augroup omnisharp_commands
    autocmd!

    " Show type information automatically when the cursor stops moving.
    " Note that the type is echoed to the Vim command line, and will overwrite
    " any other messages in this space including e.g. ALE linting messages.
    autocmd CursorHold *.cs OmniSharpTypeLookup

    " The following commands are contextual, based on the cursor position.
    autocmd FileType cs nnoremap <buffer> gd :OmniSharpGotoDefinition<CR>
    autocmd FileType cs nnoremap <buffer> <Leader>fi :OmniSharpFindImplementations<CR>
    autocmd FileType cs nnoremap <buffer> <Leader>fs :OmniSharpFindSymbol<CR>
    autocmd FileType cs nnoremap <buffer> <Leader>fu :OmniSharpFindUsages<CR>

    " Finds members in the current buffer
    autocmd FileType cs nnoremap <buffer> <Leader>fm :OmniSharpFindMembers<CR>

    autocmd FileType cs nnoremap <buffer> <Leader>fx :OmniSharpFixUsings<CR>
    autocmd FileType cs nnoremap <buffer> <Leader>tt :OmniSharpTypeLookup<CR>
    autocmd FileType cs nnoremap <buffer> <Leader>dc :OmniSharpDocumentation<CR>
    autocmd FileType cs nnoremap <buffer> <C-\> :OmniSharpSignatureHelp<CR>
    autocmd FileType cs inoremap <buffer> <C-\> <C-o>:OmniSharpSignatureHelp<CR>

    " Navigate up and down by method/property/field
    autocmd FileType cs nnoremap <buffer> <C-k> :OmniSharpNavigateUp<CR>
    autocmd FileType cs nnoremap <buffer> <C-j> :OmniSharpNavigateDown<CR>

    " Find all code errors/warnings for the current solution and populate the quickfix window
    autocmd FileType cs nnoremap <buffer> <Leader>cc :OmniSharpGlobalCodeCheck<CR>
augroup END

" Contextual code actions (uses fzf, CtrlP or unite.vim when available)
nnoremap <Leader><Space> :OmniSharpGetCodeActions<CR>
" Run code actions with text selected in visual mode to extract method
xnoremap <Leader><Space> :call OmniSharp#GetCodeActions('visual')<CR>

" Rename with dialog
nnoremap <Leader>nm :OmniSharpRename<CR>
" Rename without dialog - with cursor on the symbol to rename: `:Rename newname`
command! -nargs=1 Rename :call OmniSharp#RenameTo("<args>")

nnoremap <Leader>cf :OmniSharpCodeFormat<CR>

" Start the omnisharp server for the current solution
nnoremap <Leader>ss :OmniSharpStartServer<CR>
nnoremap <Leader>sp :OmniSharpStopServer<CR>

" Enable snippet completion
" let g:OmniSharp_want_snippet=1

" NerdTree Git Status
let g:NERDTreeGitStatusIndicatorMapCustom = {
    \ "Modified"  : "✹",
    \ "Staged"    : "✚",
    \ "Untracked" : "✭",
    \ "Renamed"   : "➜",
    \ "Unmerged"  : "═",
    \ "Deleted"   : "✖",
    \ "Dirty"     : "✗",
    \ "Clean"     : "✔︎",
    \ 'Ignored'   : '☒',
    \ "Unknown"   : "?"
    \ }
let g:NERDTreeGitStatusShowIgnored = 1

" NerdTree syntax highligh
let g:NERDTreeFileExtensionHighlightFullName = 1
let g:NERDTreeExactMatchHighlightFullName = 1
let g:NERDTreePatternMatchHighlightFullName = 1

" Copy to clipboard
set clipboard=unnamedplus

" BufOnly
nnoremap <F7> :BufOnly<CR>

" Disable swap files - haven't used them and usually when closing terminal
" they persist, takes an extra step to open files.
set noswapfile

" Flutter
let g:dart_format_on_save = 1

" Indent line
" let g:indentLine_color_term = 0


" switch tabs
nnoremap <C-Left> :bp<CR>
nnoremap <C-Right> :bn<CR>

" Sorting
map <leader>s :sort u<CR>

" Git merge conflicts

function! s:setupConflicted()
    set stl+=%{ConflictedVersion()}
    " Resolve and move to next conflicted file.
    nnoremap ]m :GitNextConflict<cr>
endfunction
autocmd User VimConflicted call s:setupConflicted()


" Folding
" Just use the za / zR
"inoremap <leader>f <C-O>za
"nnoremap <leader>f za
"onoremap <leader>f <C-C>za
"vnoremap <leader>f zR

"inoremap <leader>F <C-O>zR
"nnoremap <leader>F zR
"onoremap <leader>F <C-C>zR
"vnoremap <leader>F zR

"inoremap <leader>FF <C-O>zM
"nnoremap <leader>FF zM
"onoremap <leader>FF <C-C>zM
"vnoremap <leader>FF zM

" Trailing whitespace
" nnoremap <leader>s :s/\s\+$//e<CR>

" Tags
set tags=tags;,./tags;
nnoremap <F10> :!ctags -R .<CR>

" Providers
let g:ruby_host_prog = '~/.gem/ruby/2.7.0/bin/neovim-ruby-host'

if !exists("g:os")
    if has("win64") || has("win32") || has("win16")
        let g:os = "Windows"
    else
        let g:os = substitute(system('uname'), '\n', '', '')
    endif
endif

if has("gui_running")
    if g:os == "Darwin"
        let g:python3_host_prog = '/usr/local/bin/python3'
    elseif g:os == "Linux"
        let g:python3_host_prog = '/usr/bin/python'
    endif
endif

" YAML
au! BufNewFile,BufReadPost *.{yaml,yml} set filetype=yaml foldmethod=indent
autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab

" Vue
au! BufNewFile,BufReadPost *.vue set filetype=vue foldmethod=indent
autocmd FileType vue setlocal ts=2 sts=2 sw=2 expandtab

" Vdebug
let g:vdebug_options = {
      \ 'port' : 9001,
      \ 'server' : '',
      \ 'path_maps': {
      \    '/var/www/': '/home/davis/projects/edurio/edurio_api/'
      \ }
      \}

" multiple cursors
"let g:VM_maps = {}
"let g:VM_maps['Find Under']         = '<C-d>'           " replace C-n
"let g:VM_maps['Find Subword Under'] = '<C-d>'           " replace visual C-n

let g:VM_mouse_mappings = 1
nmap   <C-LeftMouse>         <Plug>(VM-Mouse-Cursor)
nmap   <C-RightMouse>        <Plug>(VM-Mouse-Word)
nmap   <M-C-RightMouse>      <Plug>(VM-Mouse-Column)

" Alignment
" Start interactive EasyAlign in visual mode (e.g. vipga)
" Start interactive EasyAlign for a motion/text object (e.g. gaip)
" try these commands:
" vipga= visual-select inner paragraph
" gaip= Start EasyAlign command (ga) for inner paragraph
xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)

" Line numbers
set number relativenumber

:augroup numbertoggle
:  autocmd!
:  autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
:  autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
:augroup END

" Indentation

function! SetAutoIndent()
    set autoindent
    set smartindent
endfunction
autocmd VimEnter * call SetAutoIndent()
