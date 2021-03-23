let test#custom_runners = {'php': ['Customphpunit']}
let test#strategy = "vimux"
let test#enabled_runners = ["php#customphpunit"]
let test#php#customphpunit#executable = './vim-test.sh'

if has('nvim')
  tmap <C-o> <C-\><C-n>
endif

augroup test
  autocmd!
  autocmd BufWrite * if test#exists() |
    \   TestFile |
    \ endif
augroup END

" these "Ctrl mappings" work well when Caps Lock is mapped to Ctrl
nmap <silent> t<C-n> :TestNearest<CR>
nmap <silent> t<C-f> :TestFile<CR>
nmap <silent> t<C-s> :TestSuite<CR>
nmap <silent> t<C-l> :TestLast<CR>
nmap <silent> t<C-g> :TestVisit<CR>
