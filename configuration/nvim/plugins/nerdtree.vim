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

nnoremap <silent> <leader>F :NERDTreeToggle<CR>
