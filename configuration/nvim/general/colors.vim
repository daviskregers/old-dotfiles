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
