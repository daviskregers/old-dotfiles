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
    " Plug 'kbarrette/mediummode'                         " same as hard mode, but allow 2 consecutive arrow keys
    Plug 'elixir-lang/vim-elixir'                       " elixir support
    Plug 'godlygeek/tabular'                            " Align text
    Plug 'lilydjwg/colorizer'
    Plug 'liuchengxu/vim-which-key'
    Plug 'phpactor/phpactor', {'for': 'php', 'tag': '*', 'do': 'composer install --no-dev -o'}
    Plug 'scrooloose/nerdcommenter'                     " toggle comments
    Plug 'scrooloose/nerdtree'                          " File explorer
    Plug 'spf13/vim-autoclose'                          " Auto close brackets/braces/etc
    Plug 'tveskag/nvim-blame-line'                      " display git blame
    Plug 'vim-scripts/BufOnly.vim'                      " Close all buffers but current
    Plug 'vim-syntastic/syntastic'                      " linters
    Plug 'vim-test/vim-test'

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
source $HOME/.config/nvim/general/settings.vim
source $HOME/.config/nvim/general/mappings.vim

" Plugin configuration
source $HOME/.config/nvim/plugins/airline.vim
source $HOME/.config/nvim/plugins/better-whitespace.vim
source $HOME/.config/nvim/plugins/blame-line.vim
source $HOME/.config/nvim/plugins/bufonly.vim
source $HOME/.config/nvim/plugins/coc.vim
source $HOME/.config/nvim/plugins/indent-lines.vim
source $HOME/.config/nvim/plugins/nerdcommenter.vim
source $HOME/.config/nvim/plugins/nerdtree.vim
source $HOME/.config/nvim/plugins/rainbow.vim
source $HOME/.config/nvim/plugins/rg.vim
source $HOME/.config/nvim/plugins/syntastic.vim
source $HOME/.config/nvim/plugins/tabularize.vim
source $HOME/.config/nvim/plugins/vim-buffet.vim
source $HOME/.config/nvim/plugins/vim-test.vim
source $HOME/.config/nvim/plugins/which-key.vim

" Colors
source $HOME/.config/nvim/general/colors.vim " load colorscheme and overload colors
