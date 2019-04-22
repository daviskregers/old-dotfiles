" Sources: 
" - https://www.linode.com/docs/tools-reference/tools/introduction-to-vim-customization/
" - https://shapeshed.com/vim-netrw/
" - https://vim.fandom.com/wiki/Find_in_files_within_Vim
" - https://thoughtbot.com/blog/faster-grepping-in-vim
" - https://shapeshed.com/vim-statuslines/
" - https://alvinalexander.com/linux/vi-vim-editor-color-scheme-colorscheme
" - https://vim.fandom.com/wiki/Script_for_choosing_vim_background_color
" - https://vim.fandom.com/wiki/Xterm256_color_names_for_console_Vim
" - https://jonasjacek.github.io/colors/
" - https://thoughtbot.com/blog/vim-splits-move-faster-and-more-naturally
"
" Searching:
"
"   To search in current directory:
"   :lvim /regex/gj *.txt
"
"   To recursive search:
"   :vimgrep /dostuff()/j ../**/*.php
"
"   :Ag keywork directory
"
" Switching tabs:
"
"   gt          - next tab
"   Ctrl+PgDown
"   gT          - prev tab
"   Ctrl+PgUp
"   <n>gt       - to specific tab
"
" Indenting:
"
"   use V for selection and then use `<` and `>`
"
" TODO:
"   - plugins
"       - definitions
"       - linters
"       - autocomplete
"       - toggle comments
"   - https://medium.com/@schtoeffel/you-don-t-need-more-than-one-cursor-in-vim-2c44117d51db
"

set nocompatible

" Helps forcing plugins to load correctly when it is turned back on below
filetype off

" syntax highlighting
syntax on
set synmaxcol=128
syntax sync minlines=256

" For plugins to load correctly
filetype indent plugin on

" Number lines
set number

" Show partial command in status line
set showcmd

" Show matching brackets
set showmatch

" Enable mouse usage
set mouse=a
set ttymouse=sgr
" the ^[ must be typed as <C-v><Esc> while in insert mode
map OA <up>
map OB <down>
map OC <right>
map OD <left>
map OAOAOAOAOAOAOA <Up>
map OBOBOBOBOBOBOB <Down>

"map <ScrollWheelUp> <C-Y>
"map <ScrollWheelDown> <C-E>

set lazyredraw

" automatically save before commands like :next and :make
set autowrite

" Hide buffers when they are abandoned
set hidden


" Turn off mode lines
set modelines=0

" Automatically wrap text that extends beyond the screen length
set wrap

" Vim auto indentation feature does not work properly with text copied from
" outside of Vim.
nnoremap <F2> :set invpaste paste?<CR>
imap <F2> <C-O>:set invpaste paste?<CR>
set pastetoggle=<F2>

" Tabs & stuff
"set textwidth=79
set formatoptions=tcqrn1
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab
set noshiftround

" Display 5 lines above / below the cursor when scrolling with a mouse
set scrolloff=5

" Fixes common backspace problems
set backspace=indent,eol,start

" Status bar
set laststatus=2

" Display options
set showmode
set showcmd

" Highlight matching pairs of brackets. Use the `%` character to jump between
" them.
set matchpairs+=<:>

" Display different types of white spaces.
set list
set listchars=tab:›\ ,trail:•,extends:#,nbsp:.

" Encoding
set encoding=utf-8

" Highlight matching search patterns
set hlsearch 
" Enable incremental search
set incsearch
" Ignore matching uppercase words with lowercase search term
set ignorecase
" Include only uppercase words with uppercase search term
set smartcase

" Store info from no more than 100 files at a time, 9999 lines of text, 100kb
" of data.Useful for copying large amounts of data between files.
set viminfo='100,<9999,s100

" Map the <Space> key to toggle a selected fold opened/closed.
nnoremap <silent> <Space> @=(foldlevel('.')?'za':"\<Space>")<CR>
vnoremap <Space> zf

" Automatically save and load folds
autocmd BufWinLeave *.* mkview
autocmd BufWinEnter *.* loadview

" File manager stuff -
" :Explore - open `netrw` in the current window
" :Sexplore - open `netrw` in horizontal split
" :Vexplore - open `netrw` in vertical split
"
" The directory listing view can be bodified to show more or less information
" on files and directories, change the sorting order and hiding certain files.
"
" With the directory browser open hit `i` to cycle through view types. There
" are 4 different view types - thin, long, wide and tree. A preferred view
" type can be made permanent by setting it in .vimrc.

let g:netrw_liststyle=3

" Hide the banner
" To toggle in vim, use `I`.

let g:netrw_banner=0

" Changing how files are opened
"
" By default files will be opened in the same window as the netrw directory
" browser. To change this behaviour the `netrw_browse_split` option mat be
" set. Thew options are as follows:
"
" - 1 - open files in a new horizontal split
" - 2 - open files in a new vertical split
" - 3 - open files in a new tab
" - 4 - open in previous window
let g:netrw_browse_split=3

" Set the width of the directory explorer
"
" The width of the directory explorer can be fixed with the
" `netrw_browse_split` option. The following sets the width to 25% of the page
let g:netrw_winsize=25

" NERDtree like setup
" 
" If NERDtree is your thing netrw can give you a similar experience with the
" following settings:
"
" let g:netrw_banner=0
" let g:netrw_liststyle=3
" let g:netrw_browse_split=4
" let g:netrw_altv=1
" let g:netrw_winsize=25
" augroup ProjectDrawer
" 	autocmd!
" 	autocmd VimEnter * :Vexplore
" augroup END

" Reload vimrc
map <F9> :source ~/.vimrc<CR>

" wildignore - exclude patterns with vimgrep
set wildignore+=objd/**,obj/**,*.tmp,vendor/**,node_modules/**,*.pyc

" The Silver Searcher
if executable('ag')
  " Use ag over grep
  set grepprg=ag\ --nogroup\ --nocolor

  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'

  " ag is fast enough that CtrlP doesn't need to cache
  let g:ctrlp_use_caching = 0
endif

" Search the word under cursor
nnoremap K :grep! "\b<C-R><C-W>\b"<CR>:cw<CR>

" Open up with quickfix window
" bind \ to grep shortcut
"
command -nargs=+ -complete=file -bar Ag silent! grep! <args>|cwindow|redraw!
nnoremap \ :Ag<SPACE>

" Statusline
"
" The statusline can be shown regardless of whether you have more than one
" buffer open with the following setting int your .vimrc
" 
" set laststatus=2
"
" You can disable it by using
"
" set laststatus=0

set laststatus=2

" A very basic statusline can be achieved by adding the following to the vimrc
"
" set statusline=helloWorld
"
" A useful pattern to use when building a statusline is to concatenate the
" line and build the statusline over multiple lines in your vimrc.
"
" set statusline = 
" set statusline += hello
" set statusline += world
"
" - Vimscrip functions
"
"   Statuslines can use Vim functions and it is possible to show anything that
"   can be programmed in Vimscript in the statusline. This might be the
"   weather, the proce of ETH or more commonly the git branch that you are on.
"   The following returns the current branch and an empty string if there is
"   no git repository.
"
"   function! StatuslineGit()
"       let l:branchname = GitBranch()
"       return strlen(l:branchname) > 0?'  '.l:branchname.' ':''
"   endfunction
"
"   set statusline= 
"   set statusline+=%{StatuslineGit()}
"
" - Showing data
"
"   Vim has a number of variables that may be used in statuslines. The `f`
"   character for example shows the path to the file in the buffer and the vim
"   documentation outlines clearly the data that can be shown.
"
"   http://vimdoc.sourceforge.net/htmldoc/options.html#'statusline'
"
"   set statusline= 
"   set statusline+=\ %f
"
" - Color
"
"   Color is perhaps the hardest part to configure in statuslines. The
"   documentation (http://docs.huihoo.com/vim/7.2/syntax.html7) is harder 
"   to decipher here but offers the highlight color names that may be used to 
"   change the color of the statusline. 
"
"   These colors are named highlights so it is difficult to understand what the color will
"   be without playing around with them. The syntax using these colors is as
"   follows:
"
"   set statusline= 
"   set statusline+=%#LineNr#
"   set statusline+=\ %f
"
" - A few lines over a plugin reading the documentation and understanding how
"   statuslines work it is easy to construct a statusline that works.
"

function! GitBranch()
  return system("git rev-parse --abbrev-ref HEAD 2>/dev/null | tr -d '\n'")
endfunction

function! StatuslineGit()
  let l:branchname = GitBranch()
  return strlen(l:branchname) > 0?'  '.l:branchname.' ':''
endfunction

set statusline= 
set statusline+=%#PmenuSel#
set statusline+=%{StatuslineGit()}
set statusline+=%#LineNr#
set statusline+=\ %f
set statusline+=%m\
set statusline+=%=
set statusline+=%#CursorColumn#
set statusline+=\ %y
set statusline+=\ %{&fileencoding?&fileencoding:&encoding}
set statusline+=\[%{&fileformat}\]
set statusline+=\ %p%%
set statusline+=\ %l:%c
set statusline+=\

" Colorscheme
colo pablo
set t_Co=256
highlight Normal ctermfg=254 ctermbg=234

" Panes:
"
"   You can create a vertical split using `:vsp` and horizontal with `:sp`.
"
"   ```
"   :vsp ~/.vimrc
"   ```
"
"   You can specify the new split height by prefixing with a number:
"
"   ```
"   :10sp ~/.zshrc
"   ```
"
"   Close the split like you would close vim:
"
"   ```
"   :q
"   ```
"
" Easier split navigations:
"
"   We can use different key mappings for easy navigation between splits to
"   save a keystroke. So instead of `ctrl-w` then `j`, it's just `ctrl-j`.
"
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

nnoremap <C-Down> <C-W><C-J>
nnoremap <C-Up> <C-W><C-K>
nnoremap <C-Right> <C-W><C-L>
nnoremap <C-Left> <C-W><C-H>

" More natural split opening
"
"   Open new plit panes to right and bottom, which feels more natural than
"   Vim's default.
"
set splitbelow
set splitright

" Resizing splits
"
"   Vims defaults are useful for changing split shapes:
"
"       Max out the height of the current split
"       ctrl + w _
"
"       Max out the width of the current split
"       ctrl + w |
"
"       Normalize all split sizes, which is very handy when resizing terminal
"       ctrl + w =
"
" More split manipulation
"
"   Swap top/bottom or left/right split
"   ctrl + W R
"
"   Break out current window into a new tab
"   Ctrl + W T
"
"   Close every window in the current tab but the current one
"   Ctrl + W o
"
" More help on splits:
"   :help splits
set encoding=utf-8
set title

" Switching tabs
"
" Use ALT+Arrows to switch between tabs

nnoremap <A-Left> :tabprevious<CR>
nnoremap <A-Right> :tabnext<CR>
nnoremap <A-Up> :tabfirst<CR>
nnoremap <A-Down> :tablast<CR>
